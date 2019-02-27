--[[ global file vars to track when we should actually
 	 be drawing a hitmarker and if it was headshot/killshot ]]
local shouldDrawHit = false
local wasHeadshot = false
local wasKillShot = false
local dmgAmounts = {} -- will keep track of current dmg amounts to display

--[[--------------------------------------------------
loadHitProfiles( )
	Initializes a hitprofile object on the LocalPlayer
]]----------------------------------------------------
local function loadHitProfiles()
	LocalPlayer()._normHit = _hm.NormalShotProfile()
	LocalPlayer()._headHit = _hm.HeadShotProfile()
	LocalPlayer()._killHit = _hm.KillShotProfile()
	LocalPlayer()._dmgProfle = _hm.DmgNumProfile()
end
hook.Add("InitPostEntity", "hitmarker_init_ply_hitprofile", loadHitProfiles)
LocalPlayer()._normHit = _hm.NormalShotProfile() -- delete this shit later
LocalPlayer()._headHit = _hm.HeadShotProfile() -- delete this shit later
LocalPlayer()._killHit = _hm.KillShotProfile() -- delete this shit later
LocalPlayer()._dmgProfle = _hm.DmgNumProfile() -- delet this shit later

--[[--------------------------------------------------------------
whenShouldDrawHit(Number msgLen)
	Toggles shouldDrawHit boolean when called, also builds part of
	the HitProfile used in drawHit function
]]----------------------------------------------------------------
local function whenShouldDrawHit(msgLen)
	shouldDrawHit = true

	local dmgAmount = net.ReadInt(6) -- get damage amount
	wasHeadshot = net.ReadBool() -- get if it was a headshot
	wasKillshot = net.ReadBool()

	if (not timer.Exists("hitmarker_hitlast")) then
		timer.Create("hitmarker_hitlast", 0.2, 1,  -- add to config 
		function()
			shouldDrawHit = false
			wasHeadshot = false
			wasKillShot = false
		end) 
	end
end
net.Receive("hitmarker_when_hit", whenShouldDrawHit)

--[[-----------------
drawHit(  )
	draws a hitmarker
]]-------------------
local function drawHit()
	local HitProfile = LocalPlayer()._normHit

	if (wasHeadshot) then
		HitProfile = LocalPlayer()._headHit end

	if (wasKillshot) then
		HitProfile = LocalPlayer()._killHit end-- want this to override all other hits

	HitProfile:Draw()
end

--[[---------------------
drawDamage( )
	draws the damage done
]]-----------------------
local function drawDamage()
	for _, dmgTable in pairs(dmgAmounts) do
		dmgTable[2] = dmgTable[2] + (1 / 2)
		local x = dmgTable[2] -- dmgTable[2] is xpos of text

		-- want it follow a parabolic motion in 2nd quandrant
		dmgTable[1]:Draw(
			(ScrW()/2) + 35 + x, -- x
			(ScrH()/2) - 35 - ((x * x) / 50))  -- y = (x^2) / 50
	end
end

--[[--------------------------------------------------------------
whenShouldDrawHit( Number msgLen )
	Toggles shouldDrawHit boolean when called, also builds part of
	the HitProfile used in drawHit function
]]----------------------------------------------------------------
local function whenShouldDrawHit(msgLen)
	shouldDrawHit = true

	local dmgAmount = net.ReadInt(6) -- get damage amount
	wasHeadshot = net.ReadBool() -- get if it was a headshot
	wasKillshot = net.ReadBool() -- get if it was a killshot
	-- the number in the table is an xpos we need to track for each individual dmg profile
	table.insert(dmgAmounts, 1, { _hm.DmgNumProfile(dmgAmount), 0 }) -- insert front


	if (not timer.Exists("hitmarker_hitlast")) then
		timer.Create("hitmarker_hitlast", 0.2, 1, -- add to config
		function()
			shouldDrawHit = false
			wasHeadshot = false
			wasKillShot = false
		end)
	end

	timer.Simple(0.6, -- we want this timer to be called everytime
	function()		  -- a dmgAmount is inserted so that it can also
		table.remove(dmgAmounts, #dmgAmounts) -- be removed (pop back)
	end)
end
net.Receive("hitmarker_when_hit", whenShouldDrawHit)

--[[---------------------------------------------------
plyDraw( )
	LocalPlayer's draw hook, here we draw the hitmarker
	when needed
]]-----------------------------------------------------
local function plyDraw()
	if (shouldDrawHit) then
		drawHit() end
	
	drawDamage()
end
hook.Add("HUDPaint", "hitmarker_draw_hits", plyDraw)
