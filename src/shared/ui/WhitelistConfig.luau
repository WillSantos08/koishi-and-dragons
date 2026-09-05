-- Whitelist Configuration
-- Defines which UserIds have access and their roles
-- Note: Group-based access removed; whitelist controls everything

local WhitelistConfig = {}

-- Whitelist: UserIds allowed to access the experience
WhitelistConfig.AllowedUsers = {
    -- Example: Add your UserId here for testing
    -- 12345678,
    -- 87654321,
}

-- GM Whitelist: UserIds with full access (GM role)
WhitelistConfig.GMUsers = {
    -- Example: Add GM UserIds here
    -- 12345678,
}

-- Helper: Check if user is allowed
function WhitelistConfig.IsAllowed(userId: number): boolean
    for _, id in WhitelistConfig.AllowedUsers do
        if id == userId then return true end
    end
    return false
end

-- Helper: Check if user is GM
function WhitelistConfig.IsGM(userId: number): boolean
    for _, id in WhitelistConfig.GMUsers do
        if id == userId then return true end
    end
    return false
end

return WhitelistConfig