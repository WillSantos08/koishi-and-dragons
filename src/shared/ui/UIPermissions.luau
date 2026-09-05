-- Permission Module based on Whitelist
-- Checks if player is GM or Player based on UserId whitelist

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UIConfig = require(ReplicatedStorage.Shared.ui.UIConfig)
local WhitelistConfig = require(ReplicatedStorage.Shared.ui.WhitelistConfig)

local UIPermissions = {}

-- Permission cache per player
local permissionCache = {}

-- Gets player permission level: "GM" or "Player"
function UIPermissions.GetPermissionLevel(player: Player): "GM" | "Player"
    local cached = permissionCache[player.UserId]
    if cached then return cached end

    if WhitelistConfig.IsGM(player.UserId) then
        permissionCache[player.UserId] = "GM"
        return "GM"
    end

    permissionCache[player.UserId] = "Player"
    return "Player"
end

-- Checks if player is whitelisted
function UIPermissions.IsWhitelisted(player: Player): boolean
    return WhitelistConfig.IsAllowed(player.UserId)
end

-- Checks if player can access a specific UI
function UIPermissions.CanAccessUI(player: Player, uiName: string): boolean
    local level = UIPermissions.GetPermissionLevel(player)

    if level == "GM" then return true end -- GM accesses everything

    -- Player: check if in access list
    for _, name in UIConfig.UIAccess.PlayerAccess do
        if name == uiName then return true end
    end

    return false
end

-- Invalidates cache (useful when role changes)
function UIPermissions.InvalidateCache(player: Player)
    permissionCache[player.UserId] = nil
end

-- Clears cache when player leaves
Players.PlayerRemoving:Connect(function(player)
    permissionCache[player.UserId] = nil
end)

return UIPermissions