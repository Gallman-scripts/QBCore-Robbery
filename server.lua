RegisterServerEvent('qb-robbery:startRobbery')
AddEventHandler('qb-robbery:startRobbery', function(message, coords)
    local source = source
    TriggerClientEvent('qb-robbery:robberyStarted', source, coords)
    TriggerClientEvent('qb-robbery:notifyAll', -1, message)
    -- Lägg till server-side logik här, t.ex. alerta poliser, loggning, etc.
end)
