-- Hit profile class
local HitProfile = {}

AccessorFunc(HitProfile, "width", "Width", FORCE_NUMBER)
AccessorFunc(HitProfile, "length", "Length", FORCE_NUMBER)
AccessorFunc(HitProfile, "center_offset", "CenterOffset", FORCE_NUMBER)
AccessorFunc(HitProfile, "outline_thickness", "OutlineThickness")
AccessorFunc(HitProfile, "outline", "Outline", FORCE_BOOL)
AccessorFunc(HitProfile, "was_kill", "WasKill", FORCE_BOOL)
AccessorFunc(HitProfile, "was_headshot", "WasHeadshot", FORCE_BOOL)

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

--[[-------------------------------------------------------
_hm.HitProfile()
	HitProfile constructor
---------------------------------------------------------]]
function _hm.HitProfile()
	local this = table.Copy(HitProfile)

	this:SetWidth(1.5) -- 1.5
	this:SetLength(5) -- 5
	this:SetCenterOffset(6) -- 6
	this:SetOutlineThickness(2)
	this:SetOutline(true)
	this:SetWasKill(false)
	this:SetWasHeadshot(false)
	this:SetColor()

	return this
end