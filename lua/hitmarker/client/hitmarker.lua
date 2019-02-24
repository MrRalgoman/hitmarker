--[[--------------------------------------------------
loadHitProfile()
	Initializes a hitprofile object on the LocalPlayer
]]----------------------------------------------------
local function loadHitProfile()
	LocalPlayer().hitProfile = _hm.HitProfile()
end
hook.Add("InitPostEntity", "hitmarker_init_ply_hitprofile", loadHitProfile)

LocalPlayer().hitProfile = _hm.HitProfile()

--[[ global file var to track when we should actually
 	 be drawing a hitmarker ]]
local shouldDrawHit = false

--[[------------------------------------------------------------
drawBar(Number offset, Number length, Number width, Number type)
	Draws a specific bar in the hitmarker
	type 1: topLeftBotRight type2: topRightBotLeft
]]--------------------------------------------------------------
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

--[[------------------------------------------------------------------------------------
drawBarOutline(Number offset, Number length, Number width, Number type, Number outline)
	Draws a specific bar in the hitmarker
	type 1: topLeftBotRight type2: topRightBotLeft
]]--------------------------------------------------------------------------------------
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
drawHit()
	draws a hitmarker
]]-------------------
local function drawHit()
	local drawInfo = LocalPlayer().hitProfile
	local l, w, o, ot =  drawInfo:GetLength(), drawInfo:GetWidth(), drawInfo:GetCenterOffset(),
		drawInfo:GetOutlineThickness()

	surface.SetDrawColor(drawInfo:GetOutlineColor())
	print(drawInfo:GetOutlineColor())
	drawBarOutline(o, l, -w, 1, -ot) -- lower right
	drawBarOutline(-o, -l, w, 1, ot) -- upper left
	drawBarOutline(o, l, -w, 2, -ot) -- lower right
	drawBarOutline(-o, -l, w, 2, ot) -- upper left

	surface.SetDrawColor(drawInfo:GetColor())
	drawBar(o, l, -w, 1) -- lower right
	drawBar(-o, -l, w, 1) -- upper left
	drawBar(o, l, -w, 2) -- lower right
	drawBar(-o, -l, w, 2) -- upper left
end

--[[--------------------------------------------------------------
whenShouldDrawHit(Number msgLen)
	Toggles shouldDrawHit boolean when called, also builds part of
	the HitProfile used in drawHit function
]]----------------------------------------------------------------
local function whenShouldDrawHit(msgLen)
	shouldDrawHit = true

	local dmgAmount = net.ReadInt(6) -- get damage amount
	local wasHeadshot = net.ReadBool() -- get if it was a headshot
	-- eventually check if it was a kill shot

	if (not timer.Exists("hitmarker_hitlast")) then
		timer.Create("hitmarker_hitlast", 0.2, 1, function() shouldDrawHit = false end) end -- add to config
end
net.Receive("hitmarker_when_hit", whenShouldDrawHit)

--[[----------------------------------------------------
plyDraw()
	LocalPlayer's draw hook, here we draw the hitmarker
	when needed
]]------------------------------------------------------
local function plyDraw()
	if (shouldDrawHit) then
		drawHit()
	end
end
hook.Add("HUDPaint", "hitmarker_draw_hits", plyDraw)