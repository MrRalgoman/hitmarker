AddCSLuaFile()

--[[---------------------------------------------------------
loadAddon()
	Realm: Shared
	- Downloads and includes the required files for the addon
	- Builds the global table for the addon
-----------------------------------------------------------]]
local function loadAddon()
	_hm = _hm or { }

	if (SERVER) then
		AddCSLuaFile "hitmarker/client/fonts.lua"
		AddCSLuaFile "hitmarker_cfg.lua"
		AddCSLuaFile "hitmarker/client/hitprofile.lua"
		AddCSLuaFile "hitmarker/client/dmgnumprofile.lua"
		AddCSLuaFile "hitmarker/client/draw.lua"
		AddCSLuaFile "hitmarker/client/vgui/frame.lua"
		AddCSLuaFile "hitmarker/client/vgui/hit_form.lua"
		AddCSLuaFile "hitmarker/client/vgui/dmgnum_form.lua"

		include "hitmarker_cfg.lua"
		include "hitmarker/server/hitmarker.lua"
	elseif (CLIENT) then
		include "hitmarker/client/fonts.lua"
		include "hitmarker_cfg.lua"
		include "hitmarker/client/hitprofile.lua"
		include "hitmarker/client/dmgnumprofile.lua"
		include "hitmarker/client/draw.lua"
		include "hitmarker/client/vgui/frame.lua"
		include "hitmarker/client/vgui/hit_form.lua"
		include "hitmarker/client/vgui/dmgnum_form.lua"
	end
end
hook.Add("Initialize", "hitmarker_load_addon", loadAddon)

-- net strings
if (CLIENT) then return end
util.AddNetworkString "hitmarker_when_hit"
util.AddNetworkString "hitmarker_open_cfg_frame"