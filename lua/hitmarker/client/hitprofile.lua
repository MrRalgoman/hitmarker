-- Hit profile class
local HitProfile = {}

AccessorFunc(HitProfile, "width", "Width", FORCE_NUMBER)
AccessorFunc(HitProfile, "length", "Length", FORCE_NUMBER)
AccessorFunc(HitProfile, "center_offset", "CenterOffset", FORCE_NUMBER)
AccessorFunc(HitProfile, "was_kill", "WasKill", FORCE_BOOL)
AccessorFunc(HitProfile, "was_headshot", "WasHeadshot", FORCE_BOOL)
function HitProfile:SetColor(col)
	self.color = Color(col.r, col.g, col.b, col.a)
end
function HitProfile:SetColor(...)
	local args = {...}
	self.color = Color(args[1] or 255, args[2] or 255,
		args[3] or 255, args[4] or 255)
end
function HitProfile:GetColor()
	return self.color
end

--[[-------------------------------------------------------
_hm.HitProfile()
	HitProfile constructor
---------------------------------------------------------]]
function _hm.HitProfile()
	local this = table.Copy(HitProfile)

	this:SetWidth(3)
	this:SetLength(10)
	this:SetCenterOffset(10)
	this:SetWasKill(false)
	this:SetWasHeadshot(false)
	this:SetColor()

	return this
end