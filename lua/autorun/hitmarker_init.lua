AddCSLuaFile()

--[[---------------------------------------------------------
loadAddon()
	Realm: Shared
	- Downloads and includes the required files for the addon
	- Builds the global table for the addon
-----------------------------------------------------------]]
local function loadAddon()
	_hm = _hm or {}

	if (SERVER) then
		AddCSLuaFile "hitmarker_cfg.lua"
		AddCSLuaFile "hitmarker/client/hitprofile.lua"
		AddCSLuaFile "hitmarker/client/hitmarker.lua"

		include "hitmarker_cfg.lua"
		include "hitmarker/server/hitmarker.lua"
	elseif (CLIENT) then
		include "hitmarker_cfg.lua"
		include "hitmarker/client/hitprofile.lua"
		include "hitmarker/client/hitmarker.lua"
	end
end
hook.Add("Initialize", "hitmarker_load_addon", loadAddon)

-- net strings
if (CLIENT) then return end
util.AddNetworkString "hitmarker_when_hit"