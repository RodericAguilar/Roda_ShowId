Config = {}

Config.Translation = {
    ['on'] = 'Show id ~g~on~w~',
    ['off'] = 'Show id ~r~off~w~'
}

Config.DistanceToDisplay = 5 -- Distance to display the ids
Config.Command = {
    command = 'showid',
    useKey = true,
    key = 'CAPITAL',
}

function showNotify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, true)
end
