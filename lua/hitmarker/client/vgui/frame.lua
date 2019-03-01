--[[ global file vars
	- for ease of changing lengths/widths ]]

--[[--------------------------------------------------
buildConfigurationPnl( DPanel form, HitProfile prfl )
	- builds the config panel
]]----------------------------------------------------
local function buildConfigurationPnl(form, prfl)
	local pnl = vgui.Create("DPanel", form)
	pnl:SetWide(form:GetWide()/2)
	pnl:Dock(LEFT)
end

--[[---------------------------------------------------
buildColorPickerPnl( DPanel form, HitProfile prfl )
	- builds the color picker for head/kill/normal hits
]]-----------------------------------------------------
local function buildColorPickerPnl(form, prfl)
	local pnl = vgui.Create("DPanel", form)
	pnl:SetTall(form:GetTall()/2)
	pnl:Dock(TOP)
end

--[[------------------------------------------------------------
buildViewPnl( DPanel form, HitProfile prfl )
	- builds the panel which displays a preview of the hitmarker
	being customized
]]--------------------------------------------------------------
local function buildViewPnl(form, prfl)
	local pnl = vgui.Create("DPanel", form)
	pnl:Dock(TOP)
end

--[[---------------------------------------------------
buildHitProfileForm( DFrame prnt, HitProfile prfl )
	- Builds a normal profile form to be inhereted from
]]-----------------------------------------------------
local function buildHitProfileForm(prnt, prfl)
	local form = vgui.Create("DPanel", prnt)
	form:Dock(FILL)
	form:InvalidateLayout(true)

	function form:PaintOver(w, h)
		prfl:Draw(w/2, h/2)
	end

	print(form:GetSize())
	buildConfigurationPnl(form, prfl)
	buildColorPickerPnl(form, prfl)
	buildViewPnl(form, prfl)

	return form
end

--[[--------------------------------
buildFrame()
	- builds the configuration frame
]]----------------------------------
local function buildFrame()
	local profile = _hm.HitProfile()
	local frame = vgui.Create("DFrame")
	frame:SetSize(600, 500)
	frame:SetTitle("")
	frame:Center()
	frame:MakePopup()

	buildHitProfileForm(frame, profile)
end
net.Receive("hitmarker_open_cfg_frame", buildFrame)