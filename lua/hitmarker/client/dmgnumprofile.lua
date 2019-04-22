-- DmgNumProfile class
local DmgNumProfile = {}

--[[--------------------------------------------------
setColor(...)
	general set color function for getters and setters
]]----------------------------------------------------
local function setColor(...)
	local args = {...}

	if (type(args[1]) == "table") then
		return Color(args[1].r, args[1].g, args[1].b, args[1].a) end

	return Color(args[1] or 255, args[2] or 255, args[3] or 255, args[4] or 255)
end

AccessorFunc(DmgNumProfile, "outline", "Outline", FORCE_BOOL)
AccessorFunc(DmgNumProfile, "size", "Size", FORCE_NUMBER)
AccessorFunc(DmgNumProfile, "dmg_amount", "DmgAmount", FORCE_NUMBER)
AccessorFunc(DmgNumProfile, "outline_thickness", "OutlineThickness", FORCE_NUMBER)
AccessorFunc(DmgNumProfile, "center_offset", "CenterOffset", FORCE_NUMBER)
-- get/set color
DmgNumProfile.color = Color(255, 255, 255, 255) -- default: white
function DmgNumProfile:SetColor(...) self.color = setColor({ ... }) end
function DmgNumProfile:GetColor() return self.color end
-- get/set outline color
DmgNumProfile.outline_color = Color(0, 0, 0, 255) -- default: black
function DmgNumProfile:SetOutlineColor(...) self.outline_color = setColor({ ... }) end
function DmgNumProfile:GetOutlineColor() return self.outline_color end

--[[------------------------------------
DmgNumProfile:Draw( Number x, Number y )
	draws the damage
]]--------------------------------------
function DmgNumProfile:Draw(x, y)
	if (self.outline) then
		draw.SimpleTextOutlined(self.dmg_amount, "hitmarker_" .. math.Clamp(self.size, 14, 50), -- clamp between lo/hi font sizes
			self.center_offset + x, self.center_offset - y, self.color, TEXT_ALIGN_CENTER, 
			TEXT_ALIGN_CENTER, self.outline_thickness, self.outline_color)
	else
		draw.SimpleText(self.dmg_amount, "hitmarker_" .. math.Clamp(self.size, 14, 50), 
			self.center_offset + x, self.center_offset - y, self.color, TEXT_ALIGN_CENTER, 
			TEXT_ALIGN_CENTER)
	end
end

--[[-----------------------------------------
DmgNumProfile:Scrape( )
	scrapes the data from class and returns a 
	condensed table
]]-------------------------------------------
function DmgNumProfile:Scrape()
	local tbl = {}

	tbl["outline"] = self.outline
	tbl["size"] = self.size
	tbl["dmg_amount"] = self.dmg_amount
	tbl["outline_thickness"] = self.outline_thickness

	return tbl
end

--[[------------------------------
_hm.DmgNumProfile( Number amount )
	DmgNumProfile constructor
]]--------------------------------
function _hm.DmgNumProfile(amount)
	local this = table.Copy(DmgNumProfile)

	this:SetOutline(true)
	this:SetDmgAmount(amount or 0)
	this:SetSize(24)
	this:SetOutlineThickness(2)
	this:SetCenterOffset(35)

	return this
end