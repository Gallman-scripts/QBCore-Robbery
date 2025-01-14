local QBCore = exports['qb-core']:GetCoreObject()
local robberyInProgress = false
local robberyBlip = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for _, location in pairs(Config.RobberyLocations) do
            local distance = #(playerCoords - location.coords)
            
            if distance < 2.0 then
                DrawText3D(location.coords.x, location.coords.y, location.coords.z, '[E] Start Robbery')
                if IsControlJustPressed(0, 38) then -- 38 is the key code for 'E'
                    if not robberyInProgress then
                        TriggerServerEvent('qb-robbery:startRobbery', location.message, location.coords)
                    else
                        QBCore.Functions.Notify("Ett rån pågår redan!", "error")
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('qb-robbery:robberyStarted')
AddEventHandler('qb-robbery:robberyStarted', function(coords)
    robberyInProgress = true
    if coords then
        -- Ta bort befintlig blip om det finns en
        if robberyBlip ~= nil then
            RemoveBlip(robberyBlip)
        end
        -- Skapa en ny blip för rånet
        robberyBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(robberyBlip, 161)
        SetBlipScale(robberyBlip, 1.0)
        SetBlipColour(robberyBlip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Butiksrån")
        EndTextCommandSetBlipName(robberyBlip)
        
        -- Ställ in en timer för hur länge blipen ska vara synlig (t.ex. 5 minuter = 300000 ms)
        Citizen.SetTimeout(900000, function()
            if robberyBlip ~= nil then
                RemoveBlip(robberyBlip)
                robberyBlip = nil
                robberyInProgress = false  -- Tillåt spelaren att starta ett nytt rån efter att blipen försvunnit
            end
        end)
    else
        print("Koordinaterna (coords) är nil eller felaktiga.")
    end
end)

RegisterNetEvent('qb-robbery:notifyAll')
AddEventHandler('qb-robbery:notifyAll', function(message)
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0 },
        multiline = true,
        args = {"[Rån]", message}
    })
end)

function DrawText3D(x, y, z, text)
    local onScreen, px, py = World3dToScreen2d(x, y, z)

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(px, py)
        local factor = (string.len(text)) / 370
        DrawRect(px, py + 0.0150, 0.015 + factor, 0.03, 41, 11, 41, 100)
    end
end
