RegisterServerEvent('legrestraint:restrain')
AddEventHandler('legrestraint:restrain', function(target)
    local source = source
    local player = tonumber(target)
    local restrained = IsPlayerRestrained(player)

    if not restrained then
        TriggerClientEvent('legrestraint:clientRestrained', player)
    end
end)

RegisterServerEvent('legrestraint:unrestrain')
AddEventHandler('legrestraint:unrestrain', function(target)
    local source = source
    local player = tonumber(target)
    local restrained = IsPlayerRestrained(player)

    if restrained then
        TriggerClientEvent('legrestraint:clientRestrained', player)
    end
end)

function IsPlayerRestrained(player)
    local playerId = tonumber(player)
    return restrainedPlayers[playerId] or false
end

local restrainedPlayers = {}

AddEventHandler('playerDropped', function()
    local playerId = tonumber(source)
    restrainedPlayers[playerId] = nil
end)

AddEventHandler('legrestraint:clientRestrained', function(player)
    local playerId = tonumber(player)
    restrainedPlayers[playerId] = not restrainedPlayers[playerId]
end)

local resourceName = "legrestraint"