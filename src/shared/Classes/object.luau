local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")

local BaseEntity = {}
BaseEntity.__index = BaseEntity

function BaseEntity.new(config) end

return BaseEntity
