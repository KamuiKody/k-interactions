--- Registers a new location.
-- @param key A unique identifier for the location.
-- @param menuOptions A table containing the menu options for the location.
-- @param position A table containing the position coordinates of the location.
-- @param drawDistance A number indicating the draw distance for the location.
-- @return id The unique identifier of the registered location, or false if registration failed.
local function RegisterLocation(key, menuOptions, position, drawDistance)
    local id = #Config.Locations + 1
    if not menuOptions or not position or not drawDistance then return false end
    Config.Locations[id] = {
        id = id,
        active = true,
        drawDistance = drawDistance,
        position = position,
        key = key,
        menuOptions = deepcopy(menuOptions)
    }
    return id
end
exports('RegisterLocation', RegisterLocation)

--- Toggles the active state of a location.
-- @param id The unique identifier of the location.
-- @param bool A boolean indicating whether to activate or deactivate the location.
-- @return success True if the location state was successfully toggled, false otherwise.
local function ToggleLocationActive(id, bool)
    local key = GetKeyFromId(id)
    if key then Config.Locations[id].active = bool return true end
    return false
end
exports('ToggleLocationActive', ToggleLocationActive)

--- Removes a registered location.
-- @param id The unique identifier of the location.
-- @return success True if the location was successfully removed, false otherwise.
local function RemoveLocation(id)
    local key = GetKeyFromId(id)
    if key then Config.Locations[id] = nil return true end
    return false
end
exports('RemoveLocation', RemoveLocation)

--- Retrieves the data of a registered location.
-- @param id The unique identifier of the location.
-- @return data A table containing the location data, or false if the location was not found.
local function GetLocationData(id)
    local key = GetKeyFromId(id)
    if key then return Config.Locations[id] end
    return false
end
exports('GetLocationData', GetLocationData)

--- Edits an existing location.
-- @param id The unique identifier of the location.
-- @param key (Optional) A new unique identifier for the location.
-- @param menuOptions (Optional) A table containing the new menu options for the location.
-- @param position (Optional) A table containing the new position coordinates of the location.
-- @param drawDistance (Optional) A number indicating the new draw distance for the location.
-- @return success True if the location was successfully edited, false otherwise.
local function EditLocation(id, key, menuOptions, position, drawDistance)
    local key = GetKeyFromId(id)
    if key then
        local menu = menuOptions or Config.Locations[key].menuOptions
        Config.Locations[key] = {
            id = id,
            active = Config.Locations[key].active,
            drawDistance = drawDistance or Config.Locations[key].drawDistance,
            position = position or Config.Locations[key].position,
            key = key or Config.Locations[key].key,
            menuOptions = deepcopy(menu)
        }
        return true
    end
    return false
end
exports('EditLocation', EditLocation)
