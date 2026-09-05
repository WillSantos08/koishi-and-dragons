-- Client Entry Point
-- Initializes UI systems on load

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UIClientController = require(ReplicatedStorage.Client.ui.UIClientController)

-- Wait for PlayerGui to be ready
Players.LocalPlayer:WaitForChild("PlayerGui")

-- Initialize UI controller
UIClientController.Initialize()

print("[Client] Initialization complete")