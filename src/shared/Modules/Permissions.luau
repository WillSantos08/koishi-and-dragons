local Permissions = {}

Permissions.GroupId = 0 -- Set to your Roblox group ID
Permissions.GMRank = 255 -- Rank ID for GM (typically 255 for owner, adjust as needed)

function Permissions.IsGM(player: Player): boolean
	if Permissions.GroupId == 0 then
		return false
	end
	local rank = player:GetRankInGroup(Permissions.GroupId)
	return rank >= Permissions.GMRank
end

function Permissions.IsPlayer(player: Player): boolean
	if Permissions.GroupId == 0 then
		return true -- Default to player if no group configured
	end
	local rank = player:GetRankInGroup(Permissions.GroupId)
	return rank > 0 and rank < Permissions.GMRank
end

function Permissions.HasAccess(player: Player, uiName: string): boolean
	if Permissions.IsGM(player) then
		return true -- GM has access to all UIs
	end
	
	-- Define player-accessible UIs here
	local playerUIs = {
		["CharacterSheet"] = true,
		["Inventory"] = true,
		["DiceRoller"] = true,
		["Chat"] = true,
		["Map"] = true,
	}
	
	return playerUIs[uiName] == true
end

return Permissions