local availableDuiObjects = {}
local currentDuiObject = {}
local increment = 0
local distanceFromClosestDui = 1000

local function loadTxd(txdName)
    local index = 0
    RequestStreamedTextureDict(txdName)
    while not HasStreamedTextureDictLoaded(txdName) do
        Wait(0)
        index += 1
        if index >= 500 then print('Txdname failed to load in interactions.lua') return false end
    end
    return true
end

local function createDuiObject()
    increment += 1
    local screenWidth, screenHeight = GetActiveScreenResolution()
    local duiObject = CreateDui('https://cfx-nui-interactions/html/index.html', screenWidth, screenHeight)
    local duiHandle = GetDuiHandle(duiObject)
    local txdName = 'made_up_name_'..increment
    local txtName = 'another_made_up_name_'..increment
    local txd = CreateRuntimeTxd(txdName)
    local ret = CreateRuntimeTextureFromDuiHandle(txd, txtName, duiHandle)
    loadTxd(txdName)
    return {duiObject = duiObject, txdName = txdName, txtName = txtName}
end

RegisterNUICallback("enter", function(data)
    if not currentDuiObject.active then return end
    if currentDuiObject.menuOptions[data.index].isServer then return TriggerServerEvent(currentDuiObject.menuOptions[data.index].event, currentDuiObject.menuOptions[data.index].args) end
    TriggerEvent(currentDuiObject.menuOptions[data.index].event, currentDuiObject.menuOptions[data.index].args)
end)

local function distanceCheckingLoop()
    local progress = 0
    loadTxd('shared')
    while true do
        local sleep = 3000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for i, v in pairs(Config.Locations) do
            if v and v.active then
                local dist = #(v.position - coords)
                if dist < v.drawDistance then
                    sleep = 5
                    local obj = availableDuiObjects[v.id]
                    SetDrawOrigin(v.position.x, v.position.y, v.position.z)
                    if obj then
                        if IsControlPressed(0, Config.KeyMappingLegend[v.key]) and progress <= 100 then
                            progress += 1
                            SendDuiMessage(obj.duiObject, json.encode{ action = "keydown", progress = progress})
                            if progress >= 100 then SendDuiMessage(obj.duiObject, json.encode{ action = "keyup"}) Wait(100) progress = 0 end
                        end
                        if IsControlJustReleased(0, Config.KeyMappingLegend[v.key]) then
                            SendDuiMessage(obj.duiObject, json.encode{ action = "keyup"})
                            progress = 0
                        end
                        for option, keyPress in pairs(Config.MenuNavigation) do
                            if IsControlJustReleased(0, keyPress) then
                                if currentDuiObject.active then SendDuiMessage(obj.duiObject, json.encode{ action = option}) end
                            end
                        end
                        if v.id == currentDuiObject.id then
                            distanceFromClosestDui = dist
                            local scale = math.max(0, (v.drawDistance - dist) / (v.drawDistance - 1))
                            SendDuiMessage(obj.duiObject, json.encode({ action = "update", key = v.key, options = v.menuOptions}))
                            DrawInteractiveSprite(obj.txdName, obj.txtName, 0, 0, scale, scale, 0.0, 255, 255, 255, 255)
                        elseif dist < distanceFromClosestDui then
                            currentDuiObject = v
                            distanceFromClosestDui = dist
                            SendDuiMessage(obj.duiObject, json.encode({ action = "open"}))
                            availableDuiObjects[v.id].open = true
                            DrawInteractiveSprite(obj.txdName, obj.txtName, 0, 0, 1.0, 1.0, 0.0, 255, 255, 255, 255)
                        else
                            if obj.open then
                                SendDuiMessage(obj.duiObject, json.encode({ action = "close"}))
                                availableDuiObjects[v.id].open = false
                            end
                            DrawInteractiveSprite('shared', 'emptydot_32', 0, 0, 0.01, 0.02, 0.0, Config.SpriteColor.r, Config.SpriteColor.g, Config.SpriteColor.b, Config.SpriteColor.a)
                        end
                    else                        
                        availableDuiObjects[v.id] = createDuiObject()
                        DrawInteractiveSprite('shared', 'emptydot_32', 0, 0, 0.01, 0.02, 0.0, Config.SpriteColor.r, Config.SpriteColor.g, Config.SpriteColor.b, Config.SpriteColor.a)
                    end
                else
                    local duiObj = availableDuiObjects[v.id]
                    if duiObj and duiObj.duiObject and IsDuiAvailable(duiObj.duiObject) then
                        DestroyDui(duiObj.duiObject)
                        availableDuiObjects[v.id] = nil
                    end
                end
            end
        end
        Wait(sleep)
    end
end
distanceCheckingLoop()

RegisterNetEvent('interactions:client:clearInteractions', function(resourceName)
    for id, data in pairs(Config.Locations) do
        print(data.resource)
        if data.resource == resourceName then
            Config.Locations[id] = nil
            availableDuiObjects[id] = nil
        end
    end
end)