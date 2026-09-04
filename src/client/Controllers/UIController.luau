local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Permissions = require(Shared.Modules.Permissions)

local UIController = {}
UIController.__index = UIController

UIController._uis = {} -- [uiName] = ScreenGui/Frame
UIController._toggles = {} -- [toggleName] = {uiName, button}

function UIController.RegisterUI(uiName: string, guiObject: GuiObject)
	UIController._uis[uiName] = guiObject
	guiObject.Visible = false -- Default hidden
end

function UIController.RegisterToggle(toggleName: string, button: TextButton, uiName: string)
	UIController._toggles[toggleName] = {uiName = uiName, button = button}
	
	button.MouseButton1Click:Connect(function()
		UIController.Toggle(uiName)
	end)
end

function UIController.Toggle(uiName: string)
	local gui = UIController._uis[uiName]
	if not gui then
		warn(`UI "{uiName}" not registered`)
		return
	end
	
	local player = Players.LocalPlayer
	if not Permissions.HasAccess(player, uiName) then
		warn(`Player {player.Name} does not have access to UI "{uiName}"`)
		return
	end
	
	gui.Visible = not gui.Visible
	UIController._UpdateToggleButton(uiName)
end

function UIController.Show(uiName: string)
	local gui = UIController._uis[uiName]
	if not gui then
		warn(`UI "{uiName}" not registered`)
		return
	end
	
	local player = Players.LocalPlayer
	if not Permissions.HasAccess(player, uiName) then
		warn(`Player {player.Name} does not have access to UI "{uiName}"`)
		return
	end
	
	gui.Visible = true
	UIController._UpdateToggleButton(uiName)
end

function UIController.Hide(uiName: string)
	local gui = UIController._uis[uiName]
	if not gui then
		warn(`UI "{uiName}" not registered`)
		return
	end
	
	gui.Visible = false
	UIController._UpdateToggleButton(uiName)
end

function UIController.HideAll()
	for uiName, gui in UIController._uis do
		gui.Visible = false
		UIController._UpdateToggleButton(uiName)
	end
end

function UIController._UpdateToggleButton(uiName: string)
	for _, toggleData in UIController._toggles do
		if toggleData.uiName == uiName then
			local gui = UIController._uis[uiName]
			toggleData.button.Text = gui.Visible and "Hide" or "Show"
			break
		end
	end
end

function UIController.Init()
	local player = Players.LocalPlayer
	
	-- Auto-hide GM-only UIs for non-GM players
	for uiName, gui in UIController._uis do
		if not Permissions.HasAccess(player, uiName) then
			gui.Visible = false
		end
	end
	
	print("UIController initialized")
end

return UIController