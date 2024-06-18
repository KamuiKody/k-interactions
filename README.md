# Location Interactions Script

This script provides functions to manage locations in a configuration, including registering, toggling, removing, retrieving, and editing locations. The functions are exposed as exports to be easily used in other scripts.

## Exports

### RegisterLocation

Registers a new location.

**Parameters:**
- `key` (string): A unique identifier for the location.
- `menuOptions` (table): A table containing the menu options for the location.
- `position` (table): A table containing the position coordinates of the location.
- `drawDistance` (number): A number indicating the draw distance for the location.

**Returns:**
- `id` (number): The unique identifier of the registered location, or `false` if registration failed.

**Example:**
```lua
local menuOptions = {
    {
        label = 'Print Yes',
        event = 'test:print',
        args = 'yes'
    },
    {
        label = 'Print No',
        event = 'test:print',
        args = 'no'
    },
}
local position = vector3(-213.533, -1332.272, 30.890) -- default bennys
local drawDistance = 10.0

local locationId = exports['k-interactions']:RegisterLocation('e', menuOptions, position, drawDistance)
if locationId then
    print('Location registered with ID:', locationId)
else
    print('Failed to register location')
end

RegisterNetEvent('test:print', function(data)
    print(data)
end)
```

### ToggleLocationActive

Toggles the active state of a location.

**Parameters:**
- `id` (number): The unique identifier of the location.
- `bool` (boolean): A boolean indicating whether to activate (`true`) or deactivate (`false`) the location.

**Returns:**
- `success` (boolean): `True` if the location state was successfully toggled, `false` otherwise.

**Example:**
```lua
local success = exports['k-interactions']:ToggleLocationActive(locationId, true)
if success then
    print('Location activated')
else
    print('Failed to activate location')
end
```

### RemoveLocation

Removes a registered location.

**Parameters:**
- `id` (number): The unique identifier of the location.

**Returns:**
- `success` (boolean): `True` if the location was successfully removed, `false` otherwise.

**Example:**
```lua
local success = exports['k-interactions']:RemoveLocation(locationId)
if success then
    print('Location removed')
else
    print('Failed to remove location')
end
```

### GetLocationData

Retrieves the data of a registered location.

**Parameters:**
- `id` (number): The unique identifier of the location.

**Returns:**
- `data` (table): A table containing the location data, or `false` if the location was not found.

**Example:**
```lua
local locationData = exports['k-interactions']:GetLocationData(locationId)
if locationData then
    print('Location data:', locationData)
else
    print('Location not found')
end
```

### EditLocation

Edits an existing location.

**Parameters:**
- `id` (number): The unique identifier of the location.
- `key` (string, optional): A new unique identifier for the location.
- `menuOptions` (table, optional): A table containing the new menu options for the location.
- `position` (table, optional): A table containing the new position coordinates of the location.
- `drawDistance` (number, optional): A number indicating the new draw distance for the location.

**Returns:**
- `success` (boolean): `True` if the location was successfully edited, `false` otherwise.

**Example:**
```lua
local newMenuOptions = { option1 = "New Option 1", option2 = "New Option 2" }
local newPosition = { x = 150, y = 250, z = 350 }
local newDrawDistance = 60

local success = exports['k-interactions']:EditLocation(locationId, 'new_key', newMenuOptions, newPosition, newDrawDistance)
if success then
    print('Location edited')
else
    print('Failed to edit location')
end
```
