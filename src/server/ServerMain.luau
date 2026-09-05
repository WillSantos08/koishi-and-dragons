-- Server Entry Point
-- Initializes server-side systems
-- Note: Whitelist controls access; group-based access removed

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UIPermissions = require(ReplicatedStorage.Shared.ui.UIPermissions)
local WhitelistConfig = require(ReplicatedStorage.Shared.ui.WhitelistConfig)

-- Log when player joins (for permission debugging)
Players.PlayerAdded:Connect(function(player)
    local allowed = WhitelistConfig.IsAllowed(player.UserId)
    if not allowed then
        print(`[Server] {player.Name} not whitelisted - kicking`)
        player:Kick("You are not whitelisted for this experience.")
        return
    end

    local level = UIPermissions.GetPermissionLevel(player)
    print(`[Server] {player.Name} joined - Whitelisted: {allowed} - Permission: {level}`)
end)

-- Clear cache on leave
Players.PlayerRemoving:Connect(function(player)
    UIPermissions.InvalidateCache(player)
end)

print("[Server] Initialization complete - Whitelist mode active")