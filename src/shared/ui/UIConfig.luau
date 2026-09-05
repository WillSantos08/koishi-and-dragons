-- UI Permission Configuration based on Roblox Group
-- GM = full access | Members = limited access

local UIConfig = {}

UIConfig.GroupId = 0 -- Replace with your Roblox Group ID
UIConfig.GMRoleId = 0 -- Replace with GM Role Rank ID (e.g., 255)

UIConfig.UIAccess = {
    GMOnly = {
       -- Insert UIs here that should be accessible only to GM
    },

    PlayerAccess = {
        -- Insert UIs here that should be accessible to all group members
    },
}

return UIConfig
