-- DmgNumProfile class
local DmgNumProfile = {}

AccessorFunc(DmgNumProfile, "outline", "Outline", FORCE_BOOL)
AccessorFunc(DmgNumProfile, "size", "Size", FORCE_NUMBER)
AccessorFunc(DmgNumProfile, "dmg_amount", "DmgAmount", FORCE_NUMBER)
AccessorFunc(DmgNumProfile, "outline_thickness", "OutlineThickness", FORCE_NUMBER)
-- get/set color
function DmgNumProfile:SetColor(...)
	local args = {...}

	if (type(args[1]) == "table") then
		self.color = Color(args[1].r, args[1].g, args[1].b, args[1].a)
		return
	end

	self.color = Color(args[1] or 255, args[2] or 255,
		args[3] or 255, args[4] or 255)
end
function DmgNumProfile:GetColor()
	return self.color or Color(255, 255, 255, 255)
end
-- get/set outline color
function DmgNumProfile:SetOutlineColor(...)
	local args = {...}

	if (table.Count(args) > 0 and type(args[1]) == "table") then
		self.outline_color = Color(args[1].r, args[1].g, args[1].b, args[1].a)
		return
	end
	
	self.outline_color = Color(args[1] or 0, args[2] or 0,
		args[3] or 0, args[4] or 255)
end
function DmgNumProfile:GetOutlineColor()
	return self.outline_color or Color(0, 0, 0, 255)
end

--[[------------------------------------
DmgNumProfile:Draw( Number x, Number y )
	draws the damage
]]--------------------------------------
function DmgNumProfile:Draw(x, y)
	if (self:GetOutline()) then
		draw.SimpleTextOutlined(self:GetDmgAmount(), "hitmarker_" .. self:GetSize(),
			x, y, self:GetColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,
			self:GetOutlineThickness(), self:GetOutlineColor())
	else
		draw.SimpleText(self:GetDmgAount(), "hitmarker_" .. self:GetSize(), x, y,
			self:GetColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
	this:SetColor()
	this:SetOutlineColor()

	return this
end