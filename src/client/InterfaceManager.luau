local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local InterfaceManager = {}
local isGameMaster = false

-- Verifica se o jogador é um Game Master ao entrar no jogo
function InterfaceManager:ShowInterface()
    local ok, result = pcall(function()
        return Remotes:FindFirstChild("isGameMaster"):InvokeServer()
    end)
    isGameMaster = ok and result or false
    InterfaceManager:SetVisibility(isGameMaster)
end

-- Define a função SetVisibility para controlar a visibilidade da interface com base no status de Game Master
function InterfaceManager:SetVisibility(visible: boolean)
    local player = Players.LocalPlayer
    local masterButtons =  player:WaitForChild("PlayerGui"):WaitForChild("GeneralUI"):WaitForChild("ButtonsContainer"):WaitForChild("MasterSide")

    for _, child in pairs(masterButtons:GetChildren()) do
        if child:IsA("GuiObject") then
            child.Visible = visible
        end
    end
end

return InterfaceManager