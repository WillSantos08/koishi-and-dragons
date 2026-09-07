local Whitelist = require(script.Parent.Whitelist)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local WhitelistManager = {}

-- Verifica se o jogador está na whitelist e, caso não esteja, o expulsa do jogo
function WhitelistManager:CheckPlayer(player: Player)
    local entry = Whitelist[player.UserId]
    if not entry then
        player:Kick("You are not whitelisted to join this game.")
    end
end

-- Verifica se o jogador é um Game Master
function WhitelistManager:isGameMaster(player: Player): boolean
    local entry = Whitelist[player.UserId]
    return entry and entry.role == "GameMaster"
end

local remoteFunction = Instance.new("RemoteFunction")
remoteFunction.Name = "isGameMaster"

-- Configura o RemoteFunction ANTES de definir Parent para evitar race condition
remoteFunction.OnServerInvoke = function(player)
    return WhitelistManager:isGameMaster(player)
end

remoteFunction.Parent = Remotes

-- Verifica jogadores já existentes (para Studio test)
for _, player in Players:GetPlayers() do
    task.spawn(function()
        WhitelistManager:CheckPlayer(player)
    end)
end

-- Conecta o evento PlayerAdded para verificar se o jogador está na whitelist ao entrar no jogo
Players.PlayerAdded:Connect(function(player)
    WhitelistManager:CheckPlayer(player)
end)

return WhitelistManager