-- Hit profile class
local HitProfile = {}

AccessorFunc(HitProfile, "width", "Width", FORCE_NUMBER)
AccessorFunc(HitProfile, "length", "Length", FORCE_NUMBER)
AccessorFunc(HitProfile, "center_offset", "CenterOffset", FORCE_NUMBER)
AccessorFunc(HitProfile, "outline_thickness", "OutlineThickness")
AccessorFunc(HitProfile, "outline", "Outline", FORCE_BOOL)

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


--[[-------------------------------
_hm.NormalShotProfile()
	Normal shot profile constructor
]]---------------------------------
function _hm.NormalShotProfile()
	local this = table.Copy(HitProfile)

	this:SetWidth(1.5) -- 1.5
	this:SetLength(5) -- 5
	this:SetCenterOffset(6) -- 6
	this:SetOutlineThickness(2)
	this:SetOutline(true)
	this:SetColor() -- default white

	return this
end
--[[--------------------------------------------------------
_hm.HeadShotProfile()
	Head shot profile constructor - Just changes color/sound
---------------------------------------------------------]]
function _hm.HeadShotProfile()
	local this = _hm.NormalShotProfile()

	this:SetColor(235, 244, 66) -- yellow

	return this
end

--[[--------------------------------------------------------
_hm.KillShotProfile()
	Kill shot profile constructor - just changes color/sound
]]----------------------------------------------------------
function _hm.KillShotProfile()
	local this = _hm.NormalShotProfile()

	this:SetColor(145, 27, 27) -- dark red

	return this
end