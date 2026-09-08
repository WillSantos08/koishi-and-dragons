local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local InterfaceManager = {}
local isGameMaster = false
local masterButtons: Instance? = nil

-- Helper genérico para evitar cadeias de WaitForChild
local function waitForPath(root: Instance, path: {string}): Instance?
    local current = root
    for _, name in ipairs(path) do
        current = current:WaitForChild(name, 5)
        if not current then return nil end
    end
    return current
end

-- Busca e cacheia o container dos botões de master
local function getMasterButtons(): Instance?
    if not masterButtons then
        local player = Players.LocalPlayer
        masterButtons = waitForPath(player, {
            "PlayerGui",
            "GeneralUI",
            "ButtonsContainer",
            "MasterSide",
        })
        if not masterButtons then
            warn("MasterSide container not found in PlayerGui hierarchy")
        end
    end
    return masterButtons
end

-- Verifica se o jogador é um Game Master ao entrar no jogo
function InterfaceManager:ShowInterface()
    local maxRetries = 5
    local retryDelay = 1

    for attempt = 1, maxRetries do
        local ok, result = pcall(function()
            local remote = Remotes:WaitForChild("isGameMaster", 5)
            if not remote then
                error("RemoteFunction 'isGameMaster' not found")
            end
            return remote:InvokeServer()
        end)

        if ok then
            isGameMaster = result or false
            InterfaceManager:SetVisibility(isGameMaster)
            return
        else
            warn("[InterfaceManager] Attempt " .. attempt .. " failed:", result)
        end

        if attempt < maxRetries then
            task.wait(retryDelay)
        end
    end

    isGameMaster = false
    InterfaceManager:SetVisibility(false)
    warn("Failed to verify GameMaster status after " .. maxRetries .. " attempts")
end

-- Controla a visibilidade da interface com base no status de Game Master
function InterfaceManager:SetVisibility(visible: boolean)
    local buttons = getMasterButtons()
    if not buttons then
        warn("[InterfaceManager] Cannot set visibility: MasterSide container not found")
        return
    end
    for _, child in buttons:GetChildren() do
        if child:IsA("GuiObject") then
            child.Visible = visible
        end
    end
end

return InterfaceManager