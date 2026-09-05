-- Generic UI Manager - show/hide/toggle
-- Works on both client and server (via RemoteEvents)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local UIPermissions = require(ReplicatedStorage.Shared.ui.UIPermissions)

local UIManager = {}

-- Stores registered UI references
local registeredUIs = {}

-- RemoteEvents for server-client communication
local remotes = {}

local function getOrCreateRemote(name: string): RemoteEvent
    if remotes[name] then return remotes[name] end

    local remote = Instance.new("RemoteEvent")
    remote.Name = name
    remote.Parent = ReplicatedStorage
    remotes[name] = remote
    return remote
end

-- Registers a UI in the manager
function UIManager.RegisterUI(uiName: string, screenGui: ScreenGui)
    registeredUIs[uiName] = screenGui
    screenGui.Enabled = false -- Starts disabled
end

-- Gets a registered UI
function UIManager.GetUI(uiName: string): ScreenGui?
    return registeredUIs[uiName]
end

-- Shows UI (with permission check on client)
function UIManager.Show(uiName: string, player: Player?)
    local ui = registeredUIs[uiName]
    if not ui then
        warn(`UI "{uiName}" not registered`)
        return false
    end

    if RunService:IsClient() then
        local localPlayer = Players.LocalPlayer
        -- Permission check happens in CanAccessUI (GM = true, Player = check list)
        if not UIPermissions.CanAccessUI(localPlayer, uiName) then
            warn(`No permission to access "{uiName}"`)
            return false
        end
        ui.Enabled = true
        return true
    else
        -- Server: sends to specific client or all
        local remote = getOrCreateRemote("UI_Show")
        if player then
            remote:FireClient(player, uiName)
        else
            remote:FireAllClients(uiName)
        end
        return true
    end
end

-- Hides UI
function UIManager.Hide(uiName: string, player: Player?)
    local ui = registeredUIs[uiName]
    if not ui then
        warn(`UI "{uiName}" not registered`)
        return false
    end

    if RunService:IsClient() then
        ui.Enabled = false
        return true
    else
        local remote = getOrCreateRemote("UI_Hide")
        if player then
            remote:FireClient(player, uiName)
        else
            remote:FireAllClients(uiName)
        end
        return true
    end
end

-- Toggles UI (show/hide)
function UIManager.Toggle(uiName: string, player: Player?)
    local ui = registeredUIs[uiName]
    if not ui then
        warn(`UI "{uiName}" not registered`)
        return false
    end

    if RunService:IsClient() then
        local localPlayer = Players.LocalPlayer
        if not UIPermissions.CanAccessUI(localPlayer, uiName) then
            warn(`No permission to access "{uiName}"`)
            return false
        end
        ui.Enabled = not ui.Enabled
        return true
    else
        local remote = getOrCreateRemote("UI_Toggle")
        if player then
            remote:FireClient(player, uiName)
        else
            remote:FireAllClients(uiName)
        end
        return true
    end
end

-- Checks if UI is visible
function UIManager.IsVisible(uiName: string): boolean
    local ui = registeredUIs[uiName]
    return ui and ui.Enabled or false
end

-- Hides all UIs
function UIManager.HideAll(player: Player?)
    for name, _ in registeredUIs do
        UIManager.Hide(name, player)
    end
end

-- Initializes listeners on client
if RunService:IsClient() then
    local localPlayer = Players.LocalPlayer

    getOrCreateRemote("UI_Show").OnClientEvent:Connect(function(uiName)
        UIManager.Show(uiName)
    end)

    getOrCreateRemote("UI_Hide").OnClientEvent:Connect(function(uiName)
        UIManager.Hide(uiName)
    end)

    getOrCreateRemote("UI_Toggle").OnClientEvent:Connect(function(uiName)
        UIManager.Toggle(uiName)
    end)
end

return UIManager