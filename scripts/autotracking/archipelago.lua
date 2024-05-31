ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

CUR_INDEX = -1
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}

TAB_SWITCH_KEY = ""

TAB_MAPPING = {
    [0] = "Stage Select",
    [0x01] = "Intro",
    [0x02] = "Maverick Stages/Launch Octopus",
    [0x03] = "Maverick Stages/Sting Chameleon",
    [0x04] = "Maverick Stages/Armored Armadillo",
    [0x05] = "Maverick Stages/Flame Mammoth",
    [0x06] = "Maverick Stages/Storm Eagle",
    [0x07] = "Maverick Stages/Spark Mandrill",
    [0x08] = "Maverick Stages/Boomer Kuwanger",
    [0x09] = "Maverick Stages/Chill Penguin",
    [0x0A] = "Sigma's Fortress/Sigma Fortress 1",
    [0x0B] = "Sigma's Fortress/Sigma Fortress 2",
    [0x0C] = "Sigma's Fortress/Sigma Fortress 3",
    [0x0D] = "Sigma's Fortress/Sigma Fortress 4"
}

function onSetReply(key, value, old)
    return
end

function set_if_exists(slot_data, slotname)
    if slot_data[slotname] then
        Tracker:FindObjectForCode(slotname).AcquiredCount = slot_data[slotname]
    end
end
function enable_if_exists(slot_data, slotname)
    if slot_data[slotname] then
        obj = Tracker:FindObjectForCode(slotname)
        if slot_data[slotname] == 0 then
            obj.Active = false
        else
            obj.Active = true
        end
    end
end
function enable_progressive_if_exists(slot_data, slotname)
    if slot_data[slotname] then
        obj = Tracker:FindObjectForCode(slotname)
        if slot_data[slotname] == 0 then
            obj.CurrentStage = 0
        else
            obj.CurrentStage = 1
        end
    end
end
function set_stage_state_unlocked(stagecode)
    local state = Tracker:FindObjectForCode(stagecode)
    if state then
        if state.CurrentStage == 0 then state.CurrentStage = 1 end
    end
end


function set_ap_sigma_access(slot_data)
    --option_medals = 1
    --option_weapons = 2
    --option_armor_upgrades = 4
    --option_heart_tanks = 8
    --option_sub_tanks = 16
    --option_all = 31

    if (slot_data['sigma_open']) then
        local so = slot_data['sigma_open']
        Tracker:FindObjectForCode("sigma_open").AcquiredCount = so
        if (so & 1) > 0 then
            set_if_exists(slot_data, 'sigma_medal_count')
        end
        if (so & 2) > 0 then
            set_if_exists(slot_data, 'sigma_weapon_count')
        end
        if (so & 4) > 0 then
            set_if_exists(slot_data, 'sigma_upgrade_count')
        end
        if (so & 8) > 0 then
            set_if_exists(slot_data, 'sigma_heart_tank_count')
        end
        if (so & 16) > 0 then
            set_if_exists(slot_data, 'sigma_sub_tank_count')
        end
    end
end

function tab_switch_handler(tab_id)
    if tab_id then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("tab_switch_handler(), tab_id=%x", tab_id))
        end
        if Tracker:FindObjectForCode('auto_tab_switch').CurrentStage == 1 then
            for str in string.gmatch(TAB_MAPPING[tab_id], "([^/]+)") do
                --print(string.format("On stage %x, switching to tab %s",tab_id,str))
                Tracker:UiHint("ActivateTab", str)
            end
        end
    end
end

function onClear(slot_data)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onClear, slot_data:\n%s", dump_table(slot_data)))
    end
    SLOT_DATA = slot_data
    CUR_INDEX = -1
    -- reset locations
    for _, v in pairs(LOCATION_MAPPING) do
        if v[1] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing location %s", v[1]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[1]:sub(1, 1) == "@" then
                    obj.AvailableChestCount = obj.ChestCount
                else
                    obj.Active = false
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] and v[2] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    obj.CurrentStage = 0
                    obj.Active = false
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: unknown item type %s for code %s", v[2], v[1]))
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end

    if slot_data['logic_charged_shotgun_ice'] then
        local obj = Tracker:FindObjectForCode("icelogic")
        local stage = slot_data['logic_charged_shotgun_ice']
        if (stage >=2) then
            stage = 2
        end
        if obj then
            obj.CurrentStage = stage
        end
    end

    enable_progressive_if_exists(slot_data, 'pickupsanity')
    enable_progressive_if_exists(slot_data, 'jammed_buster')

    set_ap_sigma_access(slot_data)

    enable_progressive_if_exists(slot_data, 'logic_leg_sigma')
    enable_progressive_if_exists(slot_data, 'sigma_all_levels')
    enable_if_exists(slot_data, 'logic_boss_weakness')
    set_if_exists(slot_data, 'boss_weakness_rando')

    if Tracker:FindObjectForCode('logic_boss_weakness').Active then
        if Tracker:FindObjectForCode('boss_weakness_rando').AcquiredCount == 0 then
            Tracker:FindObjectForCode('logic_boss_unshuffled_weakness').CurrentStage = 1
        end
    end

    if slot_data['jammed_buster'] > 0 then
        Tracker:FindObjectForCode('arms').CurrentStage = 0
    end

    LOCAL_ITEMS = {}
    GLOBAL_ITEMS = {}

    PLAYER_ID = Archipelago.PlayerNumber or -1
	TEAM_NUMBER = Archipelago.TeamNumber or 0

    if Archipelago.PlayerNumber>-1 then
		TAB_SWITCH_KEY="mmx1_level_id_"..TEAM_NUMBER.."_"..PLAYER_ID
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("SET NOTIFY %s",TAB_SWITCH_KEY))
        end
		Archipelago:SetNotify({TAB_SWITCH_KEY})
		Archipelago:Get({TAB_SWITCH_KEY})
	end

end


-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
    end
    if not AUTOTRACKER_ENABLE_ITEM_TRACKING then
        return
    end
    if index <= CUR_INDEX then
        return
    end
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index;
    local v = ITEM_MAPPING[item_id]
    if not v then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: could not find item mapping for id %s", item_id))
        end
        return
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: code: %s, type %s", v[1], v[2]))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[2] == "toggle" then
            obj.Active = true
        elseif v[2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif v[2] == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: unknown item type %s for code %s", v[2], v[1]))
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: could not find object for code %s", v[1]))
    end
    -- track local items via snes interface
    if is_local then
        if LOCAL_ITEMS[v[1]] then
            LOCAL_ITEMS[v[1]] = LOCAL_ITEMS[v[1]] + 1
        else
            LOCAL_ITEMS[v[1]] = 1
        end
    else
        if GLOBAL_ITEMS[v[1]] then
            GLOBAL_ITEMS[v[1]] = GLOBAL_ITEMS[v[1]] + 1
        else
            GLOBAL_ITEMS[v[1]] = 1
        end
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("local items: %s", dump_table(LOCAL_ITEMS)))
        print(string.format("global items: %s", dump_table(GLOBAL_ITEMS)))
    end

    if item_id == 12453894 then
        set_stage_state_unlocked("launch_octopus_state")
    end
    if item_id == 12453890 then
        set_stage_state_unlocked("armored_armadillo_state")
    end
    if item_id == 12453891 then
        set_stage_state_unlocked("boomer_kuwanger_state")
    end
    if item_id == 12453892 then
        set_stage_state_unlocked("chill_penguin_state")
    end
    if item_id == 12453893 then
        set_stage_state_unlocked("flame_mammoth_state")
    end
    if item_id == 12453895 then
        set_stage_state_unlocked("spark_mandrill_state")
    end
    if item_id == 12453896 then
        set_stage_state_unlocked("sting_chameleon_state")
    end
    if item_id == 12453897 then
        set_stage_state_unlocked("storm_eagle_state")
    end
    if is_sigma_open() then
        Tracker:FindObjectForCode('stage_sigma_fortress').Active = true
    end
    if item_id == 12453918 then
        local arms = Tracker:FindObjectForCode("arms")
        if arms then
            arms.CurrentStage = arms.CurrentStage + 1
        end
    end
end

-- called when a location gets cleared
function onLocation(location_id, location_name)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onLocation: %s, %s", location_id, location_name))
    end
    if not AUTOTRACKER_ENABLE_LOCATION_TRACKING then
        return
    end
    local v = LOCATION_MAPPING[location_id]
    if not v and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[1]:sub(1, 1) == "@" then
            obj.AvailableChestCount = obj.AvailableChestCount - 1
        else
            obj.Active = true
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find object for code %s", v[1]))
    end

    --handle stage clear events
    if location_id == 12454003 then
        local obj = Tracker:FindObjectForCode("launch_octopus_cleared")
        print("Handled launch octopus cleared event")
        obj.Active = true
        local state = Tracker:FindObjectForCode("launch_octopus_state")
        state.CurrentStage = 2
    end
    if location_id == 12454001 then
        local obj = Tracker:FindObjectForCode("chill_penguin_cleared")
        obj.Active = true
        local state = Tracker:FindObjectForCode("chill_penguin_state")
        state.CurrentStage = 2
    end
    if location_id == 12454002 then
        local obj = Tracker:FindObjectForCode("spark_mandrill_cleared")
        obj.Active = true
        local state = Tracker:FindObjectForCode("spark_mandrill_state")
        state.CurrentStage = 2
    end
    
    if location_id == 12454000 then
        local obj = Tracker:FindObjectForCode("armored_armadillo_cleared")
        obj.Active = true
        local state = Tracker:FindObjectForCode("armored_armadillo_state")
        state.CurrentStage = 2
    end
    
    if location_id == 12454004 then
        local obj = Tracker:FindObjectForCode("boomer_kuwanger_cleared")
        obj.Active = true
        local state = Tracker:FindObjectForCode("boomer_kuwanger_state")
        state.CurrentStage = 2
    end
    if location_id == 12454005 then
        local obj = Tracker:FindObjectForCode("sting_chameleon_cleared")
        obj.Active = true
        local state = Tracker:FindObjectForCode("sting_chameleon_state")
        state.CurrentStage = 2
    end
    if location_id == 12454006 then
        local obj = Tracker:FindObjectForCode("storm_eagle_cleared")
        obj.Active = true
        local state = Tracker:FindObjectForCode("storm_eagle_state")
        state.CurrentStage = 2
    end
    if location_id == 12454007 then
        local obj = Tracker:FindObjectForCode("flame_mammoth_cleared")
        obj.Active = true
        local state = Tracker:FindObjectForCode("flame_mammoth_state")
        state.CurrentStage = 2
    end
    if location_id == 12453896 then
        local obj = Tracker:FindObjectForCode("sigma_1_cleared")
        obj.Active = true
    end
    if location_id == 12453901 then
        local obj = Tracker:FindObjectForCode("sigma_2_cleared")
        obj.Active = true
    end
    if location_id == 12453907 then
        local obj = Tracker:FindObjectForCode("sigma_3_cleared")
        obj.Active = true
    end
end

-- called when a locations is scouted
function onScout(location_id, location_name, item_id, item_name, item_player)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onScout: %s, %s, %s, %s, %s", location_id, location_name, item_id, item_name,
            item_player))
    end
    -- not implemented yet :(
end

-- called when a bounce message is received 
function onBounce(json)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onBounce: %s", dump_table(json)))
    end
    -- your code goes here
end

function onNotify(key, value, old_value)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onNotify called. key=%s value=%s old_value=%s", key, value, old_value))
    end
    if key == TAB_SWITCH_KEY then
        tab_switch_handler(value)
    end
end

function onNotifyLaunch(key, value)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onNotifyLaunch called. key=%s value=%s", key, value))
    end
    if key == TAB_SWITCH_KEY then
        tab_switch_handler(value)
    end
end

-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
if AUTOTRACKER_ENABLE_ITEM_TRACKING then
    Archipelago:AddItemHandler("item handler", onItem)
end
if AUTOTRACKER_ENABLE_LOCATION_TRACKING then
    Archipelago:AddLocationHandler("location handler", onLocation)
end
--Archipelago:AddSetReplyHandler("set reply handler", onSetReply)
Archipelago:AddSetReplyHandler("notify handler", onNotify)
Archipelago:AddRetrievedHandler("notify launch handler", onNotifyLaunch)
--Archipelago:AddScoutHandler("scout handler", onScout)
--Archipelago:AddBouncedHandler("bounce handler", onBounce)
