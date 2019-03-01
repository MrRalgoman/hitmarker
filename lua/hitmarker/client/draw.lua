--[[ global file vars 
	- track when we should actually be drawing a hitmarker and damage done ]]
local shouldDrawHit = false
local dmgAmounts = {} -- will keep track of current dmg amounts to display

--[[--------------------------------------------------
loadProfiles( )
	Initializes a hitprofile object on the LocalPlayer
]]----------------------------------------------------
local function loadProfiles()
	LocalPlayer()._hitProfile = _hm.HitProfile()
	LocalPlayer()._dmgProfle = _hm.DmgNumProfile()
end
hook.Add("InitPostEntity", "hitmarker_init_ply_profiles", loadProfiles)
LocalPlayer()._hitProfile = _hm.HitProfile() -- delete this shit later
LocalPlayer()._dmgProfle = _hm.DmgNumProfile() -- delet this shit later

--[[--------------------------------------------------------------
whenShouldDrawHit( Number msgLen )
	Toggles shouldDrawHit boolean when called, also builds part of
	the HitProfile used in drawHit function
]]----------------------------------------------------------------
local function whenShouldDrawHit(msgLen)
	shouldDrawHit = true

	-- the number in the table is an xpos we need to track for each individual dmg profile
	table.insert(dmgAmounts, 1, { _hm.DmgNumProfile(net.ReadInt(6)), 0 }) -- insert front
	LocalPlayer()._hitProfile:SetHeadshot(net.ReadBool()) -- get if it was a headshot
	LocalPlayer()._hitProfile:SetKill(net.ReadBool()) -- get if it was a killshot

	if (not timer.Exists("hitmarker_hitlast")) then
		timer.Create("hitmarker_hitlast", 0.2, 1, -- add to config
		function()
			shouldDrawHit = false
		end)
	end

	timer.Simple(0.6, -- we want this timer to be called everytime
	function()		  -- a dmgAmount is inserted so that it can also
		table.remove(dmgAmounts, #dmgAmounts) -- be removed (pop back)
	end)
end
net.Receive("hitmarker_when_hit", whenShouldDrawHit)

--[[---------------------
drawDamage( )
	draws the damage done
]]-----------------------
local function drawDamage()
	for _, dmgTable in pairs(dmgAmounts) do
		dmgTable[2] = dmgTable[2] + (1 / 2)
		local x = dmgTable[2] -- dmgTable[2] is the xpos of text

		-- want it follow a parabolic motion in 2nd quandrant
		dmgTable[1]:Draw( -- change 35 here to center offset
			(ScrW()/2) + x, -- x
			(ScrH()/2) - ((x * x) / 50))  -- y = (x^2) / 50
	end
end

--[[---------------------------------------------------
plyDraw( )
	LocalPlayer's draw hook, here we draw the hitmarker
	when needed
]]-----------------------------------------------------
local function plyDraw()
	if (shouldDrawHit) then
		LocalPlayer()._hitProfile:Draw(ScrW()/2, ScrH()/2) end

	drawDamage()
end
hook.Add("HUDPaint", "hitmarker_draw_hits", plyDraw)
