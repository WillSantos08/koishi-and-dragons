-- Client UI Controller
-- Registers UIs created in Studio and manages initialization

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local UIManager = require(ReplicatedStorage.Shared.ui.UIManager)
local UIPermissions = require(ReplicatedStorage.Shared.ui.UIPermissions)

local UIClientController = {}

-- Mapping: logical UI name -> exact ScreenGui name in PlayerGui (Studio)
local UI_PATHS = {
    -- GM Only
    GMPanel = "GMPanel",
    AdminControls = "AdminControls",
    WorldEditor = "WorldEditor",
    -- Player Access
    CharacterSheet = "CharacterSheet",
    Inventory = "Inventory",
    DiceRoller = "DiceRoller",
    MapView = "MapView",
}

-- Button names that should be hidden for non-GM players
local GM_BUTTON_NAMES = {
    "GMPanelButton",
    "AdminControlsButton",
    "WorldEditorButton",
}

-- Initializes and registers all found UIs
function UIClientController.Initialize()
    local localPlayer = Players.LocalPlayer
    local permissionLevel = UIPermissions.GetPermissionLevel(localPlayer)

    print(`[UI] Initializing for {permissionLevel}: {localPlayer.Name}`)

    for uiName, pathName in UI_PATHS do
        local screenGui = PlayerGui:FindFirstChild(pathName)

        if screenGui and screenGui:IsA("ScreenGui") then
            -- Check permission before registering
            if UIPermissions.CanAccessUI(localPlayer, uiName) then
                UIManager.RegisterUI(uiName, screenGui)
                print(`[UI] Registered: {uiName} ({pathName})`)
            else
                -- Ensure UIs without permission stay disabled
                screenGui.Enabled = false
                print(`[UI] Blocked (no permission): {uiName}`)
            end
        else
            warn(`[UI] Not found in PlayerGui: {pathName}`)
        end
    end

    -- Hide GM buttons for non-GM players
    UIClientController.HideGMButtons(localPlayer)
end

-- Hides GM-related buttons for non-GM players
function UIClientController.HideGMButtons(player: Player)
    local permissionLevel = UIPermissions.GetPermissionLevel(player)
    if permissionLevel == "GM" then return end -- GM sees all buttons

    for _, buttonName in GM_BUTTON_NAMES do
        local button = PlayerGui:FindFirstChild(buttonName, true)
        if button and (button:IsA("TextButton") or button:IsA("ImageButton") or button:IsA("GuiButton")) then
            button.Visible = false
            print(`[UI] Hidden GM button: {buttonName}`)
        end
    end
end

-- Helper to show UI by name
function UIClientController.ShowUI(uiName: string)
    UIManager.Show(uiName)
end

-- Helper to hide UI by name
function UIClientController.HideUI(uiName: string)
    UIManager.Hide(uiName)
end

-- Helper to toggle UI by name
function UIClientController.ToggleUI(uiName: string)
    UIManager.Toggle(uiName)
end

return UIClientController