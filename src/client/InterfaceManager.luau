local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local InterfaceManager = {}
local isGameMaster = false
local masterButtons: Instance? = nil

-- Helper genérico para evitar cadeias de WaitForChild
local function waitForPath(root: Instance, path: {string}): Instance
    local current = root
    for _, name in ipairs(path) do
        current = current:WaitForChild(name)
    end
    return current
end

-- Busca (uma única vez) e cacheia o container dos botões de master
local function getMasterButtons(): Instance
    if not masterButtons then
        local player = Players.LocalPlayer
        masterButtons = waitForPath(player, {
            "PlayerGui",
            "GeneralUI",
            "ButtonsContainer",
            "MasterSide",
        })
    end
    return masterButtons
end

-- Verifica se o jogador é um Game Master ao entrar no jogo
function InterfaceManager:ShowInterface()
    local ok, result = pcall(function()
        local remote = Remotes:WaitForChild("isGameMaster")
        return remote:InvokeServer()
    end)
    isGameMaster = ok and result or false
    InterfaceManager:SetVisibility(isGameMaster)
end

-- Controla a visibilidade da interface com base no status de Game Master
function InterfaceManager:SetVisibility(visible: boolean)
    local buttons = getMasterButtons()
    for _, child in buttons:GetChildren() do
        if child:IsA("GuiObject") then
            child.Visible = visible
        end
    end
end

return InterfaceManager