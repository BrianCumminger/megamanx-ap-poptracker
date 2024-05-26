Tracker:AddLayouts("layouts/settings_popup.json")

if (string.find(Tracker.ActiveVariantUID,"standard")) then
    Tracker:AddMaps("maps/maps.json")
    Tracker:AddLocations("locations/locations.json")
    Tracker:AddLayouts("layouts/broadcast.json")
    Tracker:AddLayouts("layouts/tracker.json")
    Tracker:AddLayouts("layouts/layouttabs.json")
end