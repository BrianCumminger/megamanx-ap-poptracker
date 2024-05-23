---[[
function has(item, amount)
    local count = Tracker:ProviderCountForCode(item)
    amount = tonumber(amount)
    if not amount then
        return count > 0
    else
        return count >= amount
    end
end

function can_charge()
    local jammed = Tracker:FindObjectForCode('jammed_buster').CurrentStage
    local arms = Tracker:FindObjectForCode("arms").CurrentStage
    if jammed == 0 then
        if arms > 0 then 
            return true
        end
    elseif arms > 1 then
        return true
    end
    return false
end

function boss_weaknesses_not_required()
    --local logic_boss_weakness = Tracker:FindObjectForCode("logic_boss_weakness").Active
    --local boss_weakness_strictness = Tracker:FindObjectForCode("boss_weakness_strictness").Active
    --if (not logic_boss_weakness) and (not boss_weakness_strictness) then return true end
    local logic_boss_unshuffled_weakness = Tracker:FindObjectForCode('logic_boss_unshuffled_weakness').Active
    return not logic_boss_unshuffled_weakness
end

function get_weapons_count()
    local weapons = 0
    if Tracker:FindObjectForCode("shotgun_ice").Active then weapons = weapons + 1 end
    if Tracker:FindObjectForCode("electric_spark").Active then weapons = weapons + 1 end
    if Tracker:FindObjectForCode("rolling_shield").Active then weapons = weapons + 1 end
    if Tracker:FindObjectForCode("homing_torpedo").Active then weapons = weapons + 1 end
    if Tracker:FindObjectForCode("boomerang_cutter").Active then weapons = weapons + 1 end
    if Tracker:FindObjectForCode("chameleon_sting").Active then weapons = weapons + 1 end
    if Tracker:FindObjectForCode("storm_tornado").Active then weapons = weapons + 1 end
    if Tracker:FindObjectForCode("fire_wave").Active then weapons = weapons + 1 end
    return weapons
end
function get_upgrades_count()
    local upgrades = 0
    if Tracker:FindObjectForCode("helmet").Active then upgrades = upgrades + 1 end
    if Tracker:FindObjectForCode("body").Active then upgrades = upgrades + 1 end
    if Tracker:FindObjectForCode("legs").Active then upgrades = upgrades + 1 end
    if Tracker:FindObjectForCode("arms").CurrentStage > 0 then upgrades = upgrades + 1 end
    return upgrades
end

function sigma_legs_req_met()
    local logic_leg_sigma = Tracker:FindObjectForCode("logic_leg_sigma").Active
    local legs = Tracker:FindObjectForCode("legs").Active
    local legs_req_met = false
    if legs then legs_req_met = true end
    if (not logic_leg_sigma) then legs_req_met = true end
    return legs_req_met
end
function sigma_codes_req_met()
    return Tracker:FindObjectForCode("stage_sigma_fortress").Active
end
function sigma_medals_req_met()
    local mavericks = Tracker:ProviderCountForCode("maverick_medal")
    local mavericks_needed = Tracker:ProviderCountForCode("sigma_medal_count")
    return mavericks >= mavericks_needed
end
function sigma_weapons_req_met()
    local weapons = get_weapons_count()
    local weapons_needed = Tracker:ProviderCountForCode("sigma_weapon_count")
    return weapons >= weapons_needed
end
function sigma_upgrade_req_met()
    local upgrades = get_upgrades_count()
    local upgrades_needed = Tracker:ProviderCountForCode("sigma_upgrade_count")
    return upgrades >= upgrades_needed
end
function sigma_heart_tanks_req_met()
    local heart_tanks = Tracker:ProviderCountForCode("heart_tank")
    local heart_tanks_needed = Tracker:ProviderCountForCode("sigma_heart_tank_count")
    return heart_tanks >= heart_tanks_needed
end
function sigma_sub_tanks_req_met()
    local sub_tanks = Tracker:ProviderCountForCode("sub_tank")
    local sub_tanks_needed = Tracker:ProviderCountForCode("sigma_sub_tank_count")
    return sub_tanks >= sub_tanks_needed
end
function sigma_all_req_met()
    return sigma_medals_req_met() and sigma_weapons_req_met() and sigma_upgrade_req_met() and sigma_heart_tanks_req_met() and sigma_sub_tanks_req_met()
end

function is_sigma_open()
    --option_multiworld = 0
    --option_medals = 1
    --option_weapons = 2
    --option_armor_upgrades = 4
    --option_heart_tanks = 8
    --option_sub_tanks = 16
    --option_all = 31
    local legs_req_met = sigma_legs_req_met()
--[[
    local sigma_mode = Tracker:ProviderCountForCode("sigma_open")

    if sigma_mode == 0 then
        return sigma_codes_req_met() and legs_req_met
    elseif sigma_mode == 1 then
        return sigma_medals_req_met() and legs_req_met
    elseif sigma_mode == 2 then
        return sigma_weapons_req_met() and legs_req_met
    elseif sigma_mode == 4 then
        return sigma_upgrade_req_met() and legs_req_met
    elseif sigma_mode == 8 then
        return sigma_heart_tanks_req_met() and legs_req_met
    elseif sigma_mode == 16 then
        return sigma_sub_tanks_req_met() and legs_req_met
    elseif sigma_mode == 31 then
        return sigma_all_req_met() and legs_req_met
    end
--]]

    local sigma_mode = Tracker:FindObjectForCode("sigmalogic").CurrentStage
    if sigma_mode == 0 then
        return sigma_codes_req_met() and legs_req_met
    elseif sigma_mode == 1 then
        return sigma_medals_req_met() and legs_req_met
    elseif sigma_mode == 2 then
        return sigma_weapons_req_met() and legs_req_met
    elseif sigma_mode == 3 then
        return sigma_upgrade_req_met() and legs_req_met
    elseif sigma_mode == 4 then
        return sigma_heart_tanks_req_met() and legs_req_met
    elseif sigma_mode == 5 then
        return sigma_sub_tanks_req_met() and legs_req_met
    elseif sigma_mode == 6 then
        return sigma_all_req_met() and legs_req_met
    end

    print("Fell through to the end of is_sigma_open(), should not happen")
    return false
end

function print_debug_sigma()
    print("get_weapons_count(): ", get_weapons_count())
    print("get_upgrades_count(): ", get_upgrades_count())
    print("sigma_legs_req_met(): ", sigma_legs_req_met())
    print("sigma_codes_req_met(): ", sigma_codes_req_met())
    print("sigma_medals_req_met(): ", sigma_medals_req_met())
    print("sigma_weapons_req_met(): ", sigma_weapons_req_met())
    print("sigma_upgrade_req_met(): ", sigma_upgrade_req_met())
    print("sigma_heart_tanks_req_met(): ", sigma_heart_tanks_req_met())
    print("sigma_sub_tanks_req_met(): ", sigma_sub_tanks_req_met())
    print("sigma_all_req_met(): ", sigma_all_req_met())
    print("is_sigma_open(): ", is_sigma_open())
end

