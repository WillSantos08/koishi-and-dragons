local Whitelist = require(script.Parent.Whitelist)
local Players = game:GetService("Players")
local remoteFunction = Instance.new("RemoteFunction")

remoteFunction.Name = "isGameMaster"
remoteFunction.Parent = game.ReplicatedStorage.Remotes

local WhitelistManager = {}

-- Verifica se o jogador está na whitelist e, caso não esteja, o expulsa do jogo
function WhitelistManager:CheckPlayer(player: Player)
    local entry = Whitelist[tostring(player.UserId)]
    if not entry then
        player:Kick("You are not whitelisted to join this game.")
    end
end

-- Verifica se o jogador é um Game Master
function WhitelistManager:isGameMaster(player: Player): boolean
    local entry = Whitelist[tostring(player.UserId)]
    return entry and entry.role == "GameMaster"
end

-- Configura o RemoteFunction para verificar se o jogador é um Game Master
remoteFunction.OnServerInvoke = function(player)
    return WhitelistManager:isGameMaster(player)
end

-- Conecta o evento PlayerAdded para verificar se o jogador está na whitelist ao entrar no jogo
Players.PlayerAdded:Connect(function(player)
    WhitelistManager:CheckPlayer(player)
end)

return WhitelistManager