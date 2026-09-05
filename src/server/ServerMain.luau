-- Server Entry Point
-- Initializes server-side systems
-- Note: All players must be in the group to access the experience

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UIPermissions = require(ReplicatedStorage.Shared.ui.UIPermissions)

-- Log when player joins (for permission debugging)
Players.PlayerAdded:Connect(function(player)
    local level = UIPermissions.GetPermissionLevel(player)
    print(`[Server] {player.Name} joined - Permission: {level}`)
end)

-- Clear cache on leave
Players.PlayerRemoving:Connect(function(player)
    UIPermissions.InvalidateCache(player)
end)

print("[Server] Initialization complete")