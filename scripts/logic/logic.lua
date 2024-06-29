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
function is_active(item)
    return Tracker:FindObjectForCode(item).Active
end


function can_charge()
    local arms = Tracker:FindObjectForCode("arms").CurrentStage
    return arms >= 2
end

function boss_weaknesses_not_required()
    local setting_weakness = Tracker:FindObjectForCode('setting_weakness').CurrentStage == 1
    return not setting_weakness
end

function boss_buster_damage_possible()
    local strictness = Tracker:FindObjectForCode("boss_weakness_strictness").CurrentStage
    if strictness == 3 then return false end
    if strictness == 2 then
        return can_charge()
    end
    return true
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
    local arms = Tracker:FindObjectForCode("arms").CurrentStage
    if Tracker:FindObjectForCode('jammed_buster').CurrentStage == 0 then
        if arms > 1 then upgrades = upgrades + arms - 1 end
    else
        upgrades = upgrades + arms
    end
    return upgrades
end

function sigma_legs_req_met()
    local logic_leg_sigma = Tracker:FindObjectForCode("logic_leg_sigma").CurrentStage == 1
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

    local legs_req_met = sigma_legs_req_met()

    local allreqs = Tracker:ProviderCountForCode("sigma_sub_tank_count") + Tracker:ProviderCountForCode("sigma_heart_tank_count") + Tracker:ProviderCountForCode("sigma_upgrade_count") + Tracker:ProviderCountForCode("sigma_weapon_count") + Tracker:ProviderCountForCode("sigma_medal_count")

    if allreqs == 0 then
        return sigma_codes_req_met() and legs_req_met
    end
    return sigma_all_req_met() and legs_req_met

end
function are_sigma_two_and_three_open()
    if Tracker:FindObjectForCode('sigma_all_levels').CurrentStage > 0 then
        return is_sigma_open()
    end
    return false
end
function is_sigma_four_open()
    local sigma_1_cleared = Tracker:FindObjectForCode('sigma_1_cleared').Active
    local sigma_2_cleared = Tracker:FindObjectForCode('sigma_2_cleared').Active
    local sigma_3_cleared = Tracker:FindObjectForCode('sigma_3_cleared').Active
    return sigma_1_cleared and sigma_2_cleared and sigma_3_cleared
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
    print("sigma_open object: ", Tracker:ProviderCountForCode("sigma_open"))
end

WEAPON_CHECKS = {
    [0x00] = function() return true end, --"Lemon",
    [0x01] = function() return Tracker:FindObjectForCode("arms").CurrentStage >= 1 end, --"Charged Shot (Level 1)",
    [0x02] = function() return can_charge() end, --"Charged Shot (Level 3, Bullet Stream)",
    [0x03] = function() return Tracker:FindObjectForCode("arms").CurrentStage >= 1 end, --"Charged Shot (Level 2)",
    [0x04] = function() return is_active("hadouken") end, --"Hadouken",
    [0x06] = function() return Tracker:FindObjectForCode("legs").CurrentStage >= 1 end, --"Lemon (Dash)",
    [0x07] = function() return is_active("homing_torpedo") end, --"Uncharged Homing Torpedo",
    [0x08] = function() return is_active("chameleon_sting") end, --"Uncharged Chameleon Sting",
    [0x09] = function() return is_active("rolling_shield") end, --"Uncharged Rolling Shield",
    [0x0A] = function() return is_active("fire_wave") end, --"Uncharged Fire Wave",
    [0x0B] = function() return is_active("storm_tornado") end, --"Uncharged Storm Tornado",
    [0x0C] = function() return is_active("electric_spark") end, --"Uncharged Electric Spark",
    [0x0D] = function() return is_active("boomerang_cutter") end, --"Uncharged Boomerang Cutter",
    [0x0E] = function() return is_active("shotgun_ice") end, --"Uncharged Shotgun Ice",
    [0x10] = function() return can_charge() and is_active("homing_torpedo") end, --"Charged Homing Torpedo",
    [0x12] = function() return can_charge() and is_active("rolling_shield") end, --"Charged Rolling Shield",
    [0x13] = function() return can_charge() and is_active("fire_wave") end, --"Charged Fire Wave",
    [0x14] = function() return can_charge() and is_active("storm_tornado") end, --"Charged Storm Tornado",
    [0x15] = function() return can_charge() and is_active("electric_spark") end, --"Charged Electric Spark",
    [0x16] = function() return can_charge() and is_active("boomerang_cutter") end, --"Charged Boomerang Cutter",
    [0x17] = function() return can_charge() and is_active("shotgun_ice") end, --"Charged Shotgun Ice",
    [0x1D] = function() return can_charge() end, --"Charged Shot (Level 3, Shockwave)",
}

--vanilla weaknesses
BOSS_WEAKNESSES = {
    ["Wolf Sigma"] =            {[1] = 2,[2] = 29,[3] = 9,[4] = 18,},
    ["Boomer Kuwanger"] =       {[1] = 7,[2] = 16,},
    ["Vile"] =                  {[1] = 7,[2] = 16,},
    ["Launch Octopus"] =        {[1] = 9,[2] = 18,},
    ["Rangda Bangda"] =         {[1] = 8,},
    ["Flame Mammoth"] =         {[1] = 11,[2] = 20,},
    ["Armored Armadillo"] =     {[1] = 12,[2] = 21,},
    ["Thunder Slimer"] =        {[1] = 0,[2] = 6,[3] = 1,[4] = 3,[5] = 2,[6] = 29,},
    ["Spark Mandrill"] =        {[1] = 14,[2] = 23,},
    ["Chill Penguin"] =         {[1] = 10,[2] = 19,},
    ["D-Rex"] =                 {[1] = 13,[2] = 22,},
    ["Storm Eagle"] =           {[1] = 8,},
    ["Sting Chameleon"] =       {[1] = 13,[2] = 22,},
    ["Sigma"] =                 {[1] = 12,[2] = 21,},
    ["Bospider"] =              {[1] = 14,[2] = 23,},
    ["Velguarder"] =            {[1] = 14,[2] = 23,},
}

function has_weakness_for(bossname)
    --print(string.format("Checking weaknesses for %s", bossname))
    for _,weapon in ipairs(BOSS_WEAKNESSES[bossname]) do
        local fn = WEAPON_CHECKS[weapon]
        --print(string.format("has weakness for weapon 0x%x: %s", weapon, fn()))
        if fn() then return true end
    end
    --print("Player does not have weakness")
    return false
end