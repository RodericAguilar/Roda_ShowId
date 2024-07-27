local isPlayerIDActive = false
local playerGamerTags = {}
local Distancia = Config.DistanceToDisplay

local gamerTagCompsEnum = {
    GamerName = 0,
    CrewTag = 1,
    HealthArmour = 2,
    BigText = 3,
    AudioIcon = 4,
    UsingMenu = 5,
    PassiveMode = 6,
    WantedStars = 7,
    Driver = 8,
    CoDriver = 9,
    Tagged = 12,
    GamerNameNearby = 13,
    Arrow = 14,
    Packages = 15,
    InvIfPedIsFollowing = 16,
    RankText = 17,
    Typing = 18
}

function cleanUpGamerTags()
    for _, v in pairs(playerGamerTags) do
        if IsMpGamerTagActive(v.gamerTag) then
            RemoveMpGamerTag(v.gamerTag)
        end
    end
    playerGamerTags = {}
end

local function showGamerTags()
    local curCoords = GetEntityCoords(PlayerPedId())
    local allActivePlayers = GetActivePlayers()

    for _, i in ipairs(allActivePlayers) do
        local targetPed = GetPlayerPed(i)
        local playerStr = 'ID: ' .. GetPlayerServerId(i) .. '' .. ''
        if not playerGamerTags[i] or not IsMpGamerTagActive(playerGamerTags[i].gamerTag) then
            playerGamerTags[i] = {
                gamerTag = CreateFakeMpGamerTag(targetPed, playerStr, false, false, 0),
                ped = targetPed
            }
        end

        local targetTag = playerGamerTags[i].gamerTag

        local targetPedCoords = GetEntityCoords(targetPed)
        if #(targetPedCoords - curCoords) <= Distancia then
            SetMpGamerTagVisibility(targetTag, gamerTagCompsEnum.GamerName, 1)
            if NetworkIsPlayerTalking(i) then
                SetMpGamerTagVisibility(targetTag, gamerTagCompsEnum.AudioIcon, true)
                SetMpGamerTagColour(targetTag, gamerTagCompsEnum.AudioIcon, 149) --HUD_COLOUR_YELLOW
                SetMpGamerTagColour(targetTag, gamerTagCompsEnum.GamerName, 149) --HUD_COLOUR_YELLOW
            else
                SetMpGamerTagVisibility(targetTag, gamerTagCompsEnum.AudioIcon, false)
                SetMpGamerTagColour(targetTag, gamerTagCompsEnum.AudioIcon, 0)
                SetMpGamerTagColour(targetTag, gamerTagCompsEnum.GamerName, 0)
            end
        else
            SetMpGamerTagVisibility(targetTag, gamerTagCompsEnum.GamerName, 0)
        end
    end
end

function togglePlayerIDsHandler()

    isPlayerIDActive = not isPlayerIDActive
    if not isPlayerIDActive then
        cleanUpGamerTags()
        showNotify(Config.Translation.off)
    else
        showNotify(Config.Translation.on)
    end
end

RegisterCommand(Config.Command.command, function()
    togglePlayerIDsHandler()
end)

if Config.Command.useKey then
    RegisterKeyMapping(Config.Command.command, 'Show Id', 'keyboard', Config.Command.key)
end

CreateThread(function()
    local sleep = 150
    while true do
        if isPlayerIDActive then
            showGamerTags()
            sleep = 50
        else
            sleep = 500
        end
        Wait(sleep)
    end
end)

