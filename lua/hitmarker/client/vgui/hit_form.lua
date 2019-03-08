local tabs_h = 35 -- height of tabs panel

--[[-------------------------------------
buildForm( DPanel prnt, HitProfile prfl )
	- Builds a HitProfile form on the passed panel
]]---------------------------------------
local function buildForm(prnt, prfl)
	local row_h, row_p = 54, 10 -- height and padding

	local function buildCheckboxPnl(text, prnt, initVal, onChange)
		local lbl = vgui.Create("DLabel", prnt)
		lbl:SetWide(300)
		lbl:DockMargin(5, 0, 5, 0)
		lbl:Dock(LEFT)
		lbl:SetColor(Color(0, 0, 0, 255))
		lbl:SetText(text)

		local checkBox = vgui.Create("DCheckBox", prnt)
		checkBox:SetSize(20, 20)
		checkBox:SetPos(prnt:GetWide() - checkBox:GetWide() - row_p,
			(prnt:GetTall() - checkBox:GetTall()) / 2)
		checkBox:SetValue(initVal)

		function checkBox:OnChange(bVal)
			onChange(bVal) end
	end

	---------- Headshot Checkbox Panel ----------
	local checkHeadshotPnl = vgui.Create("DPanel", prnt)
	checkHeadshotPnl:SetTall(row_h)
	checkHeadshotPnl:Dock(TOP)
	checkHeadshotPnl:InvalidateParent(true)

	buildCheckboxPnl("View Headshot", checkHeadshotPnl, prfl:GetHeadshot(),
	function(bVal) prfl:SetHeadshot(bVal) end)
	---------------------------------------------

	---------- Kill Checkbox Panel ----------
	local checkKillPnl = vgui.Create("DPanel", prnt)
	checkKillPnl:SetTall(row_h)
	checkKillPnl:Dock(TOP)
	checkKillPnl:InvalidateParent(true)

	buildCheckboxPnl("View Killshot", checkKillPnl, prfl:GetKill(),
	function(bVal) prfl:SetKill(bVal) end)
	-----------------------------------------

	---------- Should Draw Outline Checkbox Panel ----------
	local shouldDrawOutlinePnl = vgui.Create("DPanel", prnt)
	shouldDrawOutlinePnl:SetTall(row_h)
	shouldDrawOutlinePnl:Dock(TOP)
	shouldDrawOutlinePnl:InvalidateParent(true)

	buildCheckboxPnl("Enable Outline", shouldDrawOutlinePnl, prfl:GetOutline(),
	function(bVal) prfl:SetOutline(bVal) end)
	-------------------------------------------------------

	local function buildNumSliderPnl(text, prnt, initVal, onChange)
		local lbl = vgui.Create("DLabel", prnt)
		lbl:SetWide(300)
		lbl:DockMargin(5, 0, 5, 0)
		lbl:Dock(LEFT)
		lbl:SetColor(Color(0, 0, 0, 255))
		lbl:SetText(text)

		local numSlider = vgui.Create("DNumSlider", prnt)
		numSlider:SetSize(300, prnt:GetTall() - 4)
		numSlider:SetPos(prnt:GetWide() - numSlider:GetWide() - row_p,
			(prnt:GetTall() - numSlider:GetTall()) / 2)
		numSlider:SetDecimals(0)
		numSlider:SetMin(1)
		numSlider:SetMax(25)
		numSlider:SetValue(initVal)

		function numSlider:OnValueChanged(val)
			onChange(val) end
	end

	---------- Set Width Panel  ----------
	local setWidthPnl = vgui.Create("DPanel", prnt)
	setWidthPnl:SetTall(row_h)
	setWidthPnl:Dock(TOP)
	setWidthPnl:InvalidateParent(true)

	buildNumSliderPnl("Set Width", setWidthPnl, prfl:GetWidth(),
	function(val) prfl:SetWidth(val) end)
	--------------------------------------

	---------- Set Length Panel  ----------
	local setLengthPnl = vgui.Create("DPanel", prnt)
	setLengthPnl:SetTall(row_h)
	setLengthPnl:Dock(TOP)
	setLengthPnl:InvalidateParent(true)

	buildNumSliderPnl("Set Length", setLengthPnl, prfl:GetLength(),
	function(val) prfl:SetLength(val) end)
	---------------------------------------

	---------- Set Center Offset Panel  ----------
	local setCenterOffsetPnl = vgui.Create("DPanel", prnt)
	setCenterOffsetPnl:SetTall(row_h)
	setCenterOffsetPnl:Dock(TOP)
	setCenterOffsetPnl:InvalidateParent(true)

	buildNumSliderPnl("Set Center Offset", setCenterOffsetPnl, prfl:GetCenterOffset(),
	function(val) prfl:SetCenterOffset(val) end)
	----------------------------------------------

	---------- Set Outline Panel  ----------
	local setOutlineWidthPnl = vgui.Create("DPanel", prnt)
	setOutlineWidthPnl:SetTall(row_h)
	setOutlineWidthPnl:Dock(TOP)
	setOutlineWidthPnl:InvalidateParent(true)

	buildNumSliderPnl("Set Outline Thickness", setOutlineWidthPnl, prfl:GetOutlineThickness(),
	function(val) prfl:SetOutlineThickness(val) end)
	----------------------------------------

	---------- Save Changes button ----------
	local save = vgui.Create("DButton", prnt)
	save:SetTall(row_h)
	save:Dock(BOTTOM)
	save:SetText("Save Changes")

	function save:DoClick()
		print("Shit Saved boi")
	end
	-----------------------------------------
end

--[[-----------------------------
buildColPickerTabs( DPanel prnt )
	- builds the tabs for the color picker pnl,
	(normal/head/kill hit)
]]-------------------------------
local function buildColPickerTabs(prnt)
	local tabs = vgui.Create("DPanel", prnt)
	tabs:SetTall(tabs_h)
	tabs:Dock(TOP)
	tabs:InvalidateParent(true)

	local names = { "Normal Shot", "Head Shot", "Kill Shot" }

	local xPos = 0
	for i = 1, 3 do
		local tab = vgui.Create("DButton", tabs)
		tab:SetSize((tabs:GetWide() / 3) + 3, tabs_h)
		tab:SetPos(xPos, 0)
		tab:SetText(names[i])

		function tab:DoClick()
			for c = 1, 3 do
				prnt._colForms[c]:SetVisible(false)
			end -- disable all

			prnt._colForms[i]:SetVisible(true) -- enable this one
		end

		xPos = xPos + (tabs:GetWide() / 3) - 1
	end
end

--[[------------------------------------------------------
buildColorPicker( DPanel prnt, HitProfile prfl, DPanel pnl 
	Color initVal, function onChange )
	- Builds a color picker form on the passed pnl,
	changes the colors of the HitProfile
]]--------------------------------------------------------
local function buildColorPicker(prnt, pnl, prfl, initVal, onChange)
	pnl:Dock(FILL)
	pnl:InvalidateParent(true)
	pnl:SetVisible(false)

	local colPick = vgui.Create("DColorMixer", pnl)
	colPick:Dock(FILL)
	colPick:SetBaseColor(initVal)
	colPick:SetColor(initVal)
	-- ISSUE: SETTING DEFAULT COLORS ISNT WORKING RIGHT

	function colPick:ValueChanged(col)
		onChange(col) end

	return pnl
end

--[[-----------------------------
_hm.hitForm( DFrame prnt )
	- builds a hit form
]]-------------------------------
function _hm.hitForm(prnt)
	local prfl = _hm.HitProfile()

	---------- Form Panel ----------
	local form = vgui.Create("DPanel", prnt)
	form:SetWide(prnt:GetWide() / 2)
	form:Dock(LEFT)
	form:InvalidateParent(true)

	buildForm(form, prfl)
	--------------------------------

	---------- Color Picker Panel ----------
	local colPick = vgui.Create("DPanel", prnt)
	colPick:SetTall(prnt:GetTall() / 2)
	colPick:Dock(TOP)
	colPick:InvalidateParent(true)
	colPick._colForms = { vgui.Create("DPanel", colPick), vgui.Create("DPanel", colPick),
		vgui.Create("DPanel", colPick) }

	buildColPickerTabs(colPick)

	colPick._colForms[1] = buildColorPicker(colPick, colPick._colForms[1], prfl, prfl:GetColor(),
	function(col) prfl:SetColor(col) end)
	colPick._colForms[1]:SetVisible(true) -- have to make sure one is visible by default

	colPick._colForms[2] = buildColorPicker(colPick, colPick._colForms[2], prfl, prfl:GetHeadshotColor(),
	function(col) prfl:SetHeadshotColor(col) end)

	colPick._colForms[3] = buildColorPicker(colPick, colPick._colForms[3], prfl, prfl:GetKillColor(),
	function(col) prfl:SetKillColor(col) end)
	----------------------------------------

	---------- View Panel ----------
	local view = vgui.Create("DPanel", prnt)
	view:Dock(FILL)

	function view:PaintOver(w, h)
		prfl:Draw(w / 2, h / 2)
	end
	--------------------------------
end