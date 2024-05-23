ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

CUR_INDEX = -1
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}

function onSetReply(key, value, old)
    if key == "Mega Man X - Player " .. Archipelago.PlayerNumber .. " - Game Complete" then
        Tracker:FindObjectForCode("gameover", ITEMS).Active = true
    end
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

    if slot_data['pickupsanity'] then
        local obj = Tracker:FindObjectForCode("pickupsanity")
        local stage = slot_data['pickupsanity']
        --print(string.format("pickupsanity found set to %d", stage))
        if (stage >=2) then
            stage = 2
        end
        if obj then
            obj.CurrentStage = stage
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

    if slot_data['jammed_buster'] then
        local obj = Tracker:FindObjectForCode("jammed_buster")
        local stage = slot_data['jammed_buster']
        if (stage >=2) then
            stage = 2
        end
        if obj then
            obj.CurrentStage = stage
        end
    end

    if slot_data['starting_life_count'] then
        local obj = Tracker:FindObjectForCode("startlives")
        local count = slot_data['starting_life_count']
        print(string.format("starting_life_count found set to %d", count))
        obj.AcquiredCount = count
    end

    set_if_exists(slot_data, 'sigma_open')
    set_if_exists(slot_data, 'sigma_weapon_count')
    set_if_exists(slot_data, 'sigma_upgrade_count')
    set_if_exists(slot_data, 'sigma_heart_tank_count')
    set_if_exists(slot_data, 'sigma_sub_tank_count')
    set_if_exists(slot_data, 'sigma_medal_count')

    enable_if_exists(slot_data, 'logic_leg_sigma')
    enable_if_exists(slot_data, 'logic_boss_weakness')
    set_if_exists(slot_data, 'boss_weakness_rando')

    if Tracker:FindObjectForCode('logic_boss_weakness').Active then
        if Tracker:FindObjectForCode('boss_weakness_rando').AcquiredCount == 0 then
            Tracker:FindObjectForCode('logic_boss_unshuffled_weakness').Active = true
        end
    end

    local sigmaopen = Tracker:FindObjectForCode('sigma_open').AcquiredCount
    local sigmalogic = Tracker:FindObjectForCode('sigmalogic')
    if sigmaopen == 0 then
        sigmalogic.CurrentStage = 0
    elseif sigmaopen == 1 then
        sigmalogic.CurrentStage = 1
    elseif sigmaopen == 2 then
        sigmalogic.CurrentStage = 2
    elseif sigmaopen == 4 then
        sigmalogic.CurrentStage = 3
    elseif sigmaopen == 8 then
        sigmalogic.CurrentStage = 4
    elseif sigmaopen == 16 then
        sigmalogic.CurrentStage = 5
    elseif sigmaopen == 31 then
        sigmalogic.CurrentStage = 6
    end


    LOCAL_ITEMS = {}
    GLOBAL_ITEMS = {}

    --Archipelago:SetNotify({"Mega Man X - Player " .. Archipelago.PlayerNumber .. " - Game Complete"})
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
        print_debug_sigma()
    end
    if PopVersion < "0.20.1" or AutoTracker:GetConnectionState("SNES") == 3 then
        -- add snes interface functions here for local item tracking
    end

    if item_id == 12453894 then
        local state = Tracker:FindObjectForCode("launch_octopus_state")
        if state.CurrentStage == 0 then state.CurrentStage = 1 end
    end
    if item_id == 12453890 then
        local state = Tracker:FindObjectForCode("armored_armadillo_state")
        if state.CurrentStage == 0 then state.CurrentStage = 1 end
    end
    if item_id == 12453891 then
        local state = Tracker:FindObjectForCode("boomer_kuwanger_state")
        if state.CurrentStage == 0 then state.CurrentStage = 1 end
    end
    if item_id == 12453892 then
        local state = Tracker:FindObjectForCode("chill_penguin_state")
        if state.CurrentStage == 0 then state.CurrentStage = 1 end
    end

    if item_id == 12453893 then
        local state = Tracker:FindObjectForCode("flame_mammoth_state")
        if state.CurrentStage == 0 then state.CurrentStage = 1 end
    end
    if item_id == 12453895 then
        local state = Tracker:FindObjectForCode("spark_mandrill_state")
        if state.CurrentStage == 0 then state.CurrentStage = 1 end
    end
    if item_id == 12453896 then
        local state = Tracker:FindObjectForCode("sting_chameleon_state")
        if state.CurrentStage == 0 then state.CurrentStage = 1 end
    end
    if item_id == 12453897 then
        local state = Tracker:FindObjectForCode("storm_eagle_state")
        if state.CurrentStage == 0 then state.CurrentStage = 1 end
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

-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
if AUTOTRACKER_ENABLE_ITEM_TRACKING then
    Archipelago:AddItemHandler("item handler", onItem)
end
if AUTOTRACKER_ENABLE_LOCATION_TRACKING then
    Archipelago:AddLocationHandler("location handler", onLocation)
end
Archipelago:AddSetReplyHandler("set reply handler", onSetReply)
-- Archipelago:AddScoutHandler("scout handler", onScout)
-- Archipelago:AddBouncedHandler("bounce handler", onBounce)
