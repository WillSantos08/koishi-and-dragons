-- UI Permission Configuration based on Whitelist
-- GM = full access | Members = limited access
-- Note: Group-based access removed; uses WhitelistConfig instead

local UIConfig = {}

UIConfig.GroupId = 0 -- Deprecated: group access removed; use WhitelistConfig
UIConfig.GMRoleId = 0 -- Deprecated: group access removed; use WhitelistConfig

UIConfig.UIAccess = {
    GMOnly = {
       -- Insert UIs here that should be accessible only to GM
    },

    PlayerAccess = {
        -- Insert UIs here that should be accessible to all group members
    },
}

return UIConfig
