local InterfaceManager = require(script.Parent.InterfaceManager)

local ok, err = pcall(function()
    InterfaceManager:ShowInterface()
end)
if not ok then
    warn("[InitClient] Error: " .. tostring(err))
end