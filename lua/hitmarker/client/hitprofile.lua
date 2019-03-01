-- Hit profile class
local HitProfile = {}

--[[--------------------------------------------------
setColor(...)
	general set color function for getters and setters
]]----------------------------------------------------
local function setColor(...)
	local args = {...}

	print(args)

	if (type(args[1]) == "table") then
		return Color(args[1].r, args[1].g, args[1].b, args[1].a) end

	return Color(args[1] or 255, args[2] or 255, args[3] or 255, args[4] or 255)
end

AccessorFunc(HitProfile, "width", "Width", FORCE_NUMBER)
AccessorFunc(HitProfile, "length", "Length", FORCE_NUMBER)
AccessorFunc(HitProfile, "center_offset", "CenterOffset", FORCE_NUMBER)
AccessorFunc(HitProfile, "outline_thickness", "OutlineThickness", FORCE_NUMBER)
AccessorFunc(HitProfile, "outline", "Outline", FORCE_BOOL)
AccessorFunc(HitProfile, "was_headshot", "Headshot", FORCE_BOOL)
AccessorFunc(HitProfile, "was_kill", "Kill", FORCE_BOOL)
-- get/set color
HitProfile.color = Color(255, 255, 255, 255)
function HitProfile:SetColor(...)
	print({...})
	self.color = setColor({...}) end
function HitProfile:GetColor()
	return self.color end -- default: white
-- get/set headshot color
HitProfile.headshot_color = Color(235, 244, 66)
function HitProfile:SetHeadshotColor(...)
	self.headshot_color = setColor({...}) end
function HitProfile:GetHeadshotColor()
	return self.color end -- default: yellow
-- get/set kill color
HitProfile.kill_color = Color(145, 27, 27)
function HitProfile:SetKillColor(...)
	self.kill_color = setColor({...}) end
function HitProfile:GetKillColor()
	return self.color end -- default: red
-- get/set outline color
HitProfile.outline_color = Color(0, 0, 0, 255)
function HitProfile:SetOutlineColor(...)
	self.outline_color = setColor({...}) end
function HitProfile:GetOutlineColor()
	return self.color end -- default: black

--[[-------------------
HitProfile:Draw( )
	- Draws a hitmarker
]]---------------------
function HitProfile:Draw()
	local scrW, scrH = ScrW(), ScrH()

	local lowerRight = {
		{ x = (scrW / 2) + self.center_offset + self.length + self.width/2,
		  y = (scrH / 2) + self.center_offset + self.length - self.width/2 },
		{ x = (scrW / 2) + self.center_offset + self.length - self.width/2,
		  y = (scrH / 2) + self.center_offset + self.length + self.width/2 },
		{ x = (scrW / 2) + self.center_offset - self.width - self.width/2,
		  y = (scrH / 2) + self.center_offset - self.width + self.width/2 },
		{ x = (scrW / 2) + self.center_offset - self.width + self.width/2,
		  y = (scrH / 2) + self.center_offset - self.width - self.width/2 }
	}
	local lowerLeft = {
		{ x = (scrW / 2) - self.center_offset + self.width + self.width/2,
		  y = (scrH / 2) + self.center_offset - self.width + self.width/2 },
		{ x = (scrW / 2) - self.center_offset - self.length + self.width/2,
		  y = (scrH / 2) + self.center_offset + self.length + self.width/2 },
		{ x = (scrW / 2) - self.center_offset - self.length - self.width/2,
		  y = (scrH / 2) + self.center_offset + self.length - self.width/2 },
		{ x = (scrW / 2) - self.center_offset + self.width - self.width/2,
		  y = (scrH / 2) + self.center_offset - self.width - self.width/2 }
	}
	local upperLeft = {
		{ x = (scrW / 2) - self.center_offset - self.length - self.width/2,
		  y = (scrH / 2) - self.center_offset - self.length + self.width/2 },
		{ x = (scrW / 2) - self.center_offset - self.length + self.width/2,
		  y = (scrH / 2) - self.center_offset - self.length - self.width/2 },
		{ x = (scrW / 2) - self.center_offset + self.width + self.width/2,
		  y = (scrH / 2) - self.center_offset + self.width - self.width/2 },
		{ x = (scrW / 2) - self.center_offset + self.width - self.width/2,
		  y = (scrH / 2) - self.center_offset + self.width + self.width/2 }
	}
	local upperRight = {
		{ x = (scrW / 2) + self.center_offset - self.width - self.width/2,
		  y = (scrH / 2) - self.center_offset + self.width - self.width/2 },
		{ x = (scrW / 2) + self.center_offset + self.length - self.width/2,
		  y = (scrH / 2) - self.center_offset - self.length - self.width/2 },
		{ x = (scrW / 2) + self.center_offset + self.length + self.width/2,
		  y = (scrH / 2) - self.center_offset - self.length + self.width/2 },
		{ x = (scrW / 2) + self.center_offset - self.width + self.width/2,
		  y = (scrH / 2) - self.center_offset + self.width + self.width/2 }
	}
	
	draw.NoTexture()

	if (self.outline) then
		local lowerRight = table.Copy(lowerRight)
		lowerRight[1].x = lowerRight[1].x + self.outline_thickness
		lowerRight[2].y = lowerRight[2].y + self.outline_thickness
		lowerRight[3].x = lowerRight[3].x - self.outline_thickness
		lowerRight[4].y = lowerRight[4].y - self.outline_thickness

		local lowerLeft = table.Copy(lowerLeft)
		lowerLeft[1].x = lowerLeft[1].x + self.outline_thickness
		lowerLeft[2].y = lowerLeft[2].y + self.outline_thickness
		lowerLeft[3].x = lowerLeft[3].x - self.outline_thickness
		lowerLeft[4].y = lowerLeft[4].y - self.outline_thickness

		local upperLeft = table.Copy(upperLeft)
		upperLeft[1].x = upperLeft[1].x - self.outline_thickness
		upperLeft[2].y = upperLeft[2].y - self.outline_thickness
		upperLeft[3].x = upperLeft[3].x + self.outline_thickness
		upperLeft[4].y = upperLeft[4].y + self.outline_thickness

		local upperRight = table.Copy(upperRight)
		upperRight[1].x = upperRight[1].x - self.outline_thickness
		upperRight[2].y = upperRight[2].y - self.outline_thickness
		upperRight[3].x = upperRight[3].x + self.outline_thickness
		upperRight[4].y = upperRight[4].y + self.outline_thickness

		surface.SetDrawColor(self.outline_color)
		surface.DrawPoly(lowerLeft)
		surface.DrawPoly(lowerRight)
		surface.DrawPoly(upperLeft)
		surface.DrawPoly(upperRight)
	end

	print("Headshot: " .. tostring(self.was_headshot))
	print("Kill: " .. tostring(self.was_kill))

	local col = self.color
	if (self.was_headshot) then col = self.headshot_color end
	if (self.was_kill) then col = self.kill_color end
	surface.SetDrawColor(col)

	surface.DrawPoly(lowerRight)
	surface.DrawPoly(lowerLeft)
	surface.DrawPoly(upperLeft)
	surface.DrawPoly(upperRight)
end

--[[---------------------------------
_hm.HitProfile( )
	- Normal shot profile constructor
]]-----------------------------------
function _hm.HitProfile()
	local this = table.Copy(HitProfile)

	this:SetWidth(1.5) -- 1.5
	this:SetLength(10) -- 5
	this:SetCenterOffset(6) -- 6
	this:SetOutlineThickness(2)
	this:SetOutline(true)
	this:SetHeadshot(false)
	this:SetKill(false)

	return this
end