AddEventHandler('onResourceStop', function(resourceName)
    TriggerClientEvent('interactions:client:clearInteractions', -1, resourceName)
end)