local InterfaceManager = require(script.Parent.InterfaceManager)
local GMDashboard = require(script.Parent.Interfaces.GMDashboard)

local ok, err = pcall(function()
    InterfaceManager:ShowInterface()
end)
if not ok then
    warn("[InitClient] Error: " .. tostring(err))
end

GMDashboard:Init()