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
				--drawBar(-o, -l, w, 1)
	local topLeftbotRight = {
		{ x = ((scrW / 2) + offset + length) + -width/2, y = ((scrH / 2) + offset + length) + width/2 },
		{ x = ((scrW / 2) + offset + length) + width/2, y = ((scrH / 2) + offset + length) + -width/2 },
		{ x = ((scrW / 2) + offset + width) + width/2, y = ((scrH / 2) + offset + width) + -width/2 },
		{ x = ((scrW / 2) + offset + width) + -width/2, y = ((scrH / 2) + offset + width) + width/2 }
	}
	local topRightBotLeft = {
		{ x = ((scrW / 2) + offset + width) + -width/2, y = ((scrH / 2) + offset + width) + width/2 },
		{ x = ((scrW / 2) + offset + width) + width/2, y = ((scrH / 2) + offset + width) + -width/2 },
		{ x = ((scrW / 2) + offset + length) + width/2, y = ((scrH / 2) + offset + length) + -width/2 },
		{ x = ((scrW / 2) + offset + length) + -width/2, y = ((scrH / 2) + offset + length) + width/2 }
	}

	if (type == 1) then
		draw.NoTexture()
		surface.DrawPoly(topLeftbotRight)
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
	local scrW, scrH = ScrW(), ScrH() -- if cached, won't update with screen res change
	
	local l, w, o =  drawInfo:GetLength(), drawInfo:GetWidth(), drawInfo:GetCenterOffset()

	-- local rect = {
	-- 	{ x = ((scrW / 2) - o - l) + -w/2, y = ((scrH / 2) - o - l) + w/2 },
	-- 	{ x = ((scrW / 2) - o - l) + w/2, y = ((scrH / 2) - o - l) + -w/2 },
	-- 	{ x = ((scrW / 2) - o - w) + w/2, y = ((scrH / 2) - o - w) + -w/2 },
	-- 	{ x = ((scrW / 2) - o - w) + -w/2, y = ((scrH / 2) - o - w) + w/2 }
	-- }
	surface.SetDrawColor(drawInfo:GetColor())
	--drawBar(o, l, -w, 1) -- lower right
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

	LocalPlayer().hitProfile:SetWasHeadshot(wasHeadshot) -- update hitprofile

	timer.Simple(0.2, function() shouldDrawHit = false end) -- add to config
end
net.Receive("hitmarker_when_hit", whenShouldDrawHit)

--[[----------------------------------------------------
plyDraw()
	LocalPlayer's draw hook, here we draw the hitmarkers
	when needed
]]------------------------------------------------------
local function plyDraw()
	--if (shouldDrawHit) then
		drawHit()
	--end
end
hook.Add("HUDPaint", "hitmarker_draw_hits", plyDraw)