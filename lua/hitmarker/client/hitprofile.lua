-- Hit profile class
local HitProfile = {}

AccessorFunc(HitProfile, "width", "Width", FORCE_NUMBER)
AccessorFunc(HitProfile, "length", "Length", FORCE_NUMBER)
AccessorFunc(HitProfile, "center_offset", "CenterOffset", FORCE_NUMBER)
AccessorFunc(HitProfile, "outline_thickness", "OutlineThickness", FORCE_NUMBER)
AccessorFunc(HitProfile, "outline", "Outline", FORCE_BOOL)
-- get/set color
function HitProfile:SetColor(...)
	local args = {...}

	if (type(args[1]) == "table") then
		self.color = Color(args[1].r, args[1].g, args[1].b, args[1].a)
		return
	end

	self.color = Color(args[1] or 255, args[2] or 255,
		args[3] or 255, args[4] or 255)
end
function HitProfile:GetColor()
	return self.color or Color(255, 255, 255, 255)
end
-- get/set outline color
function HitProfile:SetOutlineColor(...)
	local args = {...}

	if (table.Count(args) > 0 and type(args[1]) == "table") then
		self.outline_color = Color(args[1].r, args[1].g, args[1].b, args[1].a)
		return
	end
	
	self.outline_color = Color(args[1] or 0, args[2] or 0,
		args[3] or 0, args[4] or 255)
end
function HitProfile:GetOutlineColor()
	return self.outline_color or Color(0, 0, 0, 255)
end

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

		surface.SetDrawColor(self:GetOutlineColor())
		surface.DrawPoly(lowerLeft)
		surface.DrawPoly(lowerRight)
		surface.DrawPoly(upperLeft)
		surface.DrawPoly(upperRight)
	end

	surface.SetDrawColor(self:GetColor())
	surface.DrawPoly(lowerRight)
	surface.DrawPoly(lowerLeft)
	surface.DrawPoly(upperLeft)
	surface.DrawPoly(upperRight)
end

--[[---------------------------------
_hm.NormalShotProfile( )
	- Normal shot profile constructor
]]-----------------------------------
function _hm.NormalShotProfile()
	local this = table.Copy(HitProfile)

	this:SetWidth(1.5) -- 1.5
	this:SetLength(10) -- 5
	this:SetCenterOffset(6) -- 6
	this:SetOutlineThickness(2)
	this:SetOutline(true)
	this:SetColor() -- default white

	return this
end

--[[-------------------------------
_hm.HeadShotProfile( )
	- Head shot profile constructor
]]---------------------------------
function _hm.HeadShotProfile()
	local this = _hm.NormalShotProfile()

	this:SetColor(235, 244, 66) -- yellow

	return this
end

--[[-------------------------------
_hm.KillShotProfile( )
	- Kill shot profile constructor
]]---------------------------------
function _hm.KillShotProfile()
	local this = _hm.NormalShotProfile()

	this:SetColor(145, 27, 27) -- dark red

	return this
end