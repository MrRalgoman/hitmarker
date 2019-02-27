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
	LocalPlayer()._dmgProfle = _hm.dmgNumProfile()
end
hook.Add("InitPostEntity", "hitmarker_init_ply_hitprofile", loadHitProfiles)
LocalPlayer()._normHit = _hm.NormalShotProfile() -- delete this shit later
LocalPlayer()._headHit = _hm.HeadShotProfile() -- delete this shit later
LocalPlayer()._killHit = _hm.KillShotProfile() -- delete this shit later
LocalPlayer()._dmgProfle = _hm.DmgNumProfile() -- delet this shit later


--[[--------------------------------------------------------------
drawBar( Number offset, Number length, Number width, Number type )
	Draws a specific bar in the hitmarker
	type 1: topLeftBotRight type2: topRightBotLeft
]]----------------------------------------------------------------
local function drawBar(offset, length, width, type)
	local scrW, scrH = ScrW(), ScrH() -- if cached, won't update with screen res change

	local topLeftBotRight = {
		{ x = (scrW / 2) + offset + length + -width/2,
		  y = (scrH / 2) + offset + length + width/2 },
		{ x = (scrW / 2) + offset + length + width/2,
		  y = (scrH / 2) + offset + length - width/2 },
		{ x = (scrW / 2) + offset + width + width/2,
		  y = (scrH / 2) + offset + width - width/2 },
		{ x = (scrW / 2) + offset + width + -width/2,
		  y = (scrH / 2) + offset + width + width/2 }
	}
	local topRightBotLeft = {
		{ x = (scrW / 2) + offset + width + width/2,
		  y = (scrH / 2) - offset - width + width/2 },
		{ x = (scrW / 2) + offset + length + width/2,
		  y = (scrH / 2) - offset - length + width/2 },
		{ x = (scrW / 2) + offset + length + -width/2,
		  y = (scrH / 2) - offset - length - width/2 },
		{ x = (scrW / 2) + offset + width + -width/2,
		  y = (scrH / 2) - offset - width - width/2 }
	}

	if (type == 1) then
		draw.NoTexture()
		surface.DrawPoly(topLeftBotRight)
	elseif (type == 2) then
		draw.NoTexture()
		surface.DrawPoly(topRightBotLeft)
	end
end

--[[-------------------------------------------------------------------------------------
drawBarOutline( Number offset, Number length, Number width, Number type, Number outline )
	Draws a specific bar in the hitmarker
	type 1: topLeftBotRight type2: topRightBotLeft
]]---------------------------------------------------------------------------------------
local function drawBarOutline(offset, length, width, type, outline)
	local scrW, scrH = ScrW(), ScrH() -- if cached, won't update with screen res change

	local topLeftBotRight = {
		{ x = (scrW / 2) + offset + length + -width/2 - outline,
		  y = (scrH / 2) + offset + length + width/2 },
		{ x = (scrW / 2) + offset + length + width/2,
		  y = (scrH / 2) + offset + length - width/2 - outline },
		{ x = (scrW / 2) + offset + width + width/2 + outline,
		  y = (scrH / 2) + offset + width - width/2 },
		{ x = (scrW / 2) + offset + width + -width/2,
		  y = (scrH / 2) + offset + width + width/2 + outline }
	}
	local topRightBotLeft = {
		{ x = (scrW / 2) + offset + width + width/2 + outline,
		  y = (scrH / 2) - offset - width + width/2 },
		{ x = (scrW / 2) + offset + length + width/2,
		  y = (scrH / 2) - offset - length + width/2 + outline },
		{ x = (scrW / 2) + offset + length - width/2 - outline,
		  y = (scrH / 2) - offset - length - width/2 },
		{ x = (scrW / 2) + offset + width - width/2,
		  y = (scrH / 2) - offset - width - width/2 - outline }
	}

	if (type == 1) then
		draw.NoTexture()
		surface.DrawPoly(topLeftBotRight)
	elseif (type == 2) then
		draw.NoTexture()
		surface.DrawPoly(topRightBotLeft)
	end
end

--[[-----------------
drawHit(  )
	draws a hitmarker
]]-------------------
local function drawHit()
	local drawInfo = LocalPlayer()._normHit

	if (wasHeadshot) then
		drawInfo = LocalPlayer()._headHit end

	if (wasKillshot) then
		drawInfo = LocalPlayer()._killHit end-- want this to override all other hits

	local l, w, o, ot =  drawInfo:GetLength(), drawInfo:GetWidth(), drawInfo:GetCenterOffset(),
		drawInfo:GetOutlineThickness()

	surface.SetDrawColor(drawInfo:GetOutlineColor())
	drawBarOutline(o, l, -w, 1, -ot) -- lower right
	drawBarOutline(-o, -l, w, 1, ot) -- upper left
	drawBarOutline(o, l, -w, 2, -ot) -- lower right
	drawBarOutline(-o, -l, w, 2, ot) -- upper left

	drawBar(o, l, -w, 1) -- lower right
	drawBar(-o, -l, w, 1) -- upper left
	drawBar(o, l, -w, 2) -- lower right
	drawBar(-o, -l, w, 2) -- upper left

	for _, dmgTable in pairs(dmgAmounts) do -- THIS ISNT WORKING START HERE
		dmgTable[2] = dmgTable[2] + (1 / 4)
		local x = dmgTable[2]

		-- want it follow a parabolic motion in 2nd quandrant
		dmgTable[1]:Draw(
			x, -- x
			(x * x) / 50)  -- y = (x^2) / 50
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

	timer.Simple(0.2, -- we want this timer to be called everytime
	function()		  -- a dmgAmount is inserted so that it can also
		table.remove(dmgAmounts, #dmgAmounts) -- be removed (pop back)
	end)
end
net.Receive("hitmarker_when_hit", whenShouldDrawHit)

--[[----------------------------------------------------
plyDraw( )
	LocalPlayer's draw hook, here we draw the hitmarker
	when needed
]]------------------------------------------------------
local function plyDraw()
	if (shouldDrawHit) then
		drawHit()
	end
end
hook.Add("HUDPaint", "hitmarker_draw_hits", plyDraw)