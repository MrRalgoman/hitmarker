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
		AddCSLuaFile "hitmarker/shared/hitprofile.lua"
		AddCSLuaFile "hitmarker_cfg.lua"

		include "hitmarker_cfg.lua"
		include "hitmarker/shared/hitprofile.lua"
	elseif (CLIENT) then
		include "hitmarker_cfg.lua"
		include "hitmarker/shared/hitprofile.lua"
	end
end
hook.Add("Initialize", "hitmarker_load_addon", loadAddon)