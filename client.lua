local restrained = false
local restraintAnimDict = "mp_arresting"
local restraintAnimName = "idle"

RegisterNetEvent('legrestraint:clientRestrained')
AddEventHandler('legrestraint:clientRestrained', function()
    restrained = not restrained
    
    local playerPed = PlayerId()

    if restrained then
        Citizen.CreateThread(function()
            RequestAnimDict(restraintAnimDict)

            while not HasAnimDictLoaded(restraintAnimDict) do
                Citizen.Wait(100)
            end

            TaskPlayAnim(playerPed, restraintAnimDict, restraintAnimName, 8.0, 8.0, -1, 1, 0, false, false, false)
            TriggerEvent('chatMessage', '^2SYSTEM', {255, 255, 255}, 'You have been restrained.')
            SetEntityInvincible(playerPed, true)
            SetEntityHasGravity(playerPed, false)
        end)
    else
        ClearPedTasks(playerPed)
        TriggerEvent('chatMessage', '^2SYSTEM', {255, 255, 255}, 'You have been unrestrained.')
        SetEntityInvincible(playerPed, false)
        SetEntityHasGravity(playerPed, true)
    end
end)

RegisterCommand('legrestraint', function()
    local playerId = PlayerId()
    local playerPed = GetPlayerPed(-1)

    if not restrained then
        TriggerServerEvent('legrestraint:restrain', playerId)
    else
        TriggerServerEvent('legrestraint:unrestrain', playerId)
    end
end, false)

local resourceName = "legrestraint"

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustReleased(0, 38) then -- Replace '38' with your desired key code (Default: E)
            local playerPed = GetPlayerPed(-1)
            local coords = GetEntityCoords(playerPed)
            local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 70)

            if DoesEntityExist(vehicle) then
                local vehicleClass = GetVehicleClass(vehicle)

                if vehicleClass == 18 then -- Change this to your desired vehicle class (18: Police Vehicles)
                    TriggerEvent('chatMessage', '^2SYSTEM', {255, 255, 255}, 'Entering a police vehicle while restrained is not allowed.')
                    CancelEvent()
                end
            end
        end
    end
end)
