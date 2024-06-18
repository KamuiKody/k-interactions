function GetKeyFromId(id)
    if type(id) ~= "number" then return false end
    if Config.Locations[id] and Config.Locations[id].id == id then return id end
    for i, v in ipairs(Config.Locations) do
        if v.id == id then return i end
    end
    return false
end

function deepcopy(orig)
    local copy = {}
    if orig == nil or type(orig) ~= 'table' then return orig end
    for orig_key, orig_value in next, orig, nil do
        copy[deepcopy(orig_key)] = deepcopy(orig_value)
    end
    setmetatable(copy, deepcopy(getmetatable(orig)))
    return copy
end

function rgba(r, g, b, a)
    return {r = r, g = g, b = b, a = a}
end