-- Permission Module based on Roblox Group/Role
-- Checks if player is GM (specific role) or Player (group member)
-- Assumes all players are in the group (required to join experience)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UIConfig = require(ReplicatedStorage.Shared.ui.UIConfig)

local UIPermissions = {}

-- Permission cache per player
local permissionCache = {}

-- Checks if player has GM role
local function hasGMRole(player: Player): boolean
    local success, result = pcall(function()
        return player:GetRankInGroup(UIConfig.GroupId) >= UIConfig.GMRoleId
    end)
    return success and result
end

-- Gets player permission level: "GM" or "Player"
function UIPermissions.GetPermissionLevel(player: Player): "GM" | "Player"
    local cached = permissionCache[player.UserId]
    if cached then return cached end

    if hasGMRole(player) then
        permissionCache[player.UserId] = "GM"
        return "GM"
    end

    permissionCache[player.UserId] = "Player"
    return "Player"
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