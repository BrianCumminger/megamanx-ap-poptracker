-- use this file to map the AP location ids to your locations
-- to reference a location in Pop use @ in the beginning and then path to the section (more info: https://github.com/black-sliver/PopTracker/blob/master/doc/PACKS.md#locations)
-- to reference an item use it's code
-- here are the SM locations as an example: https://github.com/Cyb3RGER/sm_ap_tracker/blob/main/scripts/autotracking/location_mapping.lua
LOCATION_MAPPING = {
    [12453968] = {"@Stages/Intro Stage/HP Pickup (after Bee Blader)"},
    [12453969] = {"@Stages/Intro Stage/Small HP Pickup (after Bee Blader)"},
    [12453910] = {"@Stages/Intro Stage/Get Defeated By Vile"},
    [12453918] = {"@Stages/Intro Stage/Bee Blader #1"},
    [12453919] = {"@Stages/Intro Stage/Bee Blader #2"},

    [12453889] = {"@Stages/Chill Penguin/Chill Penguin"},
    [12453938] = {"@Stages/Chill Penguin/Heart Tank"},
    [12453953] = {"@Stages/Chill Penguin/Legs Capsule"},
    [12453994] = {"@Stages/Chill Penguin/Weapon Energy Pickup (Inside third dome)"},
    [12454001] = {"@Stages/Chill Penguin/Chill Penguin Clear"},

    [12453888] = {"@Stages/Armored Armadillo/Armored Armadillo"},
    [12453916] = {"@Stages/Armored Armadillo/Mole Borer #1"},
    [12453917] = {"@Stages/Armored Armadillo/Mole Borer #2"},
    [12453936] = {"@Stages/Armored Armadillo/Heart Tank"},
    [12453937] = {"@Stages/Armored Armadillo/Sub Tank"},
    [12453952] = {"@Stages/Armored Armadillo/Hadouken Capsule"},
    [12453970] = {"@Stages/Armored Armadillo/HP Pickup 1 (In blocked ceiling)"},
    [12453971] = {"@Stages/Armored Armadillo/HP Pickup 2 (In blocked ceiling)"},
    [12453972] = {"@Stages/Armored Armadillo/HP Pickup 3 (Next to Hadouken capsule)"},
    [12454000] = {"@Stages/Armored Armadillo/Armored Armadillo Clear"},
    
    [12453890] = {"@Stages/Spark Mandrill/Spark Mandrill"},
    [12453915] = {"@Stages/Spark Mandrill/Thunder Slimer"},
    [12453939] = {"@Stages/Spark Mandrill/Sub Tank"},
    [12453940] = {"@Stages/Spark Mandrill/Heart Tank"},
    [12454002] = {"@Stages/Spark Mandrill/Spark Mandrill Clear"},
    
    [12453891] = {"@Stages/Launch Octopus/Launch Octopus"},
    [12453911] = {"@Stages/Launch Octopus/Anglerge #1"},
    [12453912] = {"@Stages/Launch Octopus/Anglerge #2"},
    [12453913] = {"@Stages/Launch Octopus/Utuboros #1"},
    [12453914] = {"@Stages/Launch Octopus/Utuboros #2"},
    [12453941] = {"@Stages/Launch Octopus/Heart Tank"},
    [12453973] = {"@Stages/Launch Octopus/HP Pickup (Crane platform above water)"},
    [12454003] = {"@Stages/Launch Octopus/Launch Octopus Clear"},

    [12453892] = {"@Stages/Boomer Kuwanger/Boomer Kuwanger"},
    [12453942] = {"@Stages/Boomer Kuwanger/Heart Tank"},
    [12454004] = {"@Stages/Boomer Kuwanger/Boomer Kuwanger Clear"},

    [12453893] = {"@Stages/Sting Chameleon/Sting Chameleon"},
    [12453943] = {"@Stages/Sting Chameleon/Heart Tank"},
    [12453954] = {"@Stages/Sting Chameleon/Body Capsule"},
    [12453974] = {"@Stages/Sting Chameleon/1up Pickup (Inside second mini-cave in mountain)"},
    [12453975] = {"@Stages/Sting Chameleon/HP Pickup (On top of platform in the swamp)"},
    [12454005] = {"@Stages/Sting Chameleon/Sting Chameleon Clear"},

    [12453894] = {"@Stages/Storm Eagle/Storm Eagle"},
    [12453944] = {"@Stages/Storm Eagle/Heart Tank"},
    [12453945] = {"@Stages/Storm Eagle/Sub Tank"},
    [12453955] = {"@Stages/Storm Eagle/Helmet Capsule"},
    [12453995] = {"@Stages/Storm Eagle/1up Pickup 1 (Behind wall in third set of gas tanks)"},
    [12453976] = {"@Stages/Storm Eagle/1up Pickup 2 (Behind fourth set of gas tanks)"},
    [12453977] = {"@Stages/Storm Eagle/1up Pickup 3 (Above helmet capsule)"},
    [12453978] = {"@Stages/Storm Eagle/HP Pickup 1 (Behind first set of gas tanks)"},
    [12453979] = {"@Stages/Storm Eagle/HP Pickup 2 (Behind second set of gas tanks)"},
    [12453980] = {"@Stages/Storm Eagle/HP Pickup 3 (Behind third set of gas tanks)"},
    [12454006] = {"@Stages/Storm Eagle/Storm Eagle Clear"},

    [12453895] = {"@Stages/Flame Mammoth/Flame Mammoth"},
    [12453946] = {"@Stages/Flame Mammoth/Heart Tank"},
    [12453947] = {"@Stages/Flame Mammoth/Sub Tank"},
    [12453956] = {"@Stages/Flame Mammoth/Arms Capsule"},
    [12453983] = {"@Stages/Flame Mammoth/HP Pickup 1 (After first conveyor belts section)"},
    [12453984] = {"@Stages/Flame Mammoth/HP Pickup 2 (Top platform in Dig Labour section)"},
    [12453985] = {"@Stages/Flame Mammoth/1up Pickup (Top platform in Dig Labour section)"},
    [12454007] = {"@Stages/Flame Mammoth/Flame Mammoth Clear"},

    [12453896] = {"@Stages/Sigma Fortress 1/Bospider"},
    [12453897] = {"@Stages/Sigma Fortress 1/Vile"},
    [12453898] = {"@Stages/Sigma Fortress 1/Boomer Kuwanger (Rematch)"},

    [12453899] = {"@Stages/Sigma Fortress 2/Chill Penguin (Rematch)"},
    [12453900] = {"@Stages/Sigma Fortress 2/Storm Eagle (Rematch)"},
    [12453901] = {"@Stages/Sigma Fortress 2/Rangda Bangda"},

    [12453902] = {"@Stages/Sigma Fortress 3/Armored Armadillo (Rematch)"},
    [12453986] = {"@Stages/Sigma Fortress 3/HP Pickup 1 (Before Sting Chameleon rematch)"},
    [12453903] = {"@Stages/Sigma Fortress 3/Sting Chameleon (Rematch)"},
    [12453987] = {"@Stages/Sigma Fortress 3/Weapon Energy Pickup 1 (Before Spark Mandrill rematch)"},
    [12453988] = {"@Stages/Sigma Fortress 3/HP Pickup 2 (Before Spark Mandrill rematch)"},
    [12453904] = {"@Stages/Sigma Fortress 3/Spark Mandrill (Rematch)"},
    [12453989] = {"@Stages/Sigma Fortress 3/HP Pickup 3 (Before Launch Octopus rematch)"},
    [12453990] = {"@Stages/Sigma Fortress 3/Weapon Energy Pickup 2 (Before Launch Octopus rematch)"},
    [12453905] = {"@Stages/Sigma Fortress 3/Launch Octopus (Rematch)"},
    [12453991] = {"@Stages/Sigma Fortress 3/HP Pickup 4 (On spikes)"},
    [12453992] = {"@Stages/Sigma Fortress 3/Weapon Energy Pickup 3 (On Spikes)"},
    [12453993] = {"@Stages/Sigma Fortress 3/1up Pickup (On spikes)"},
    [12453906] = {"@Stages/Sigma Fortress 3/Flame Mammoth (Rematch)"},
    [12453907] = {"@Stages/Sigma Fortress 3/D-Rex"},

    [12453908] = {"@Stages/Sigma Fortress 4/Velguarder"},
    [12453909] = {"@Stages/Sigma Fortress 4/Sigma"}
    
}
