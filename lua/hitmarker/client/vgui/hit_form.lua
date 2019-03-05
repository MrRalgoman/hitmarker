--[[----------------------------------------------
buildForm( DPanel prnt, HitProfile prfl )
	- Builds a HitProfile form on the passed panel
]]------------------------------------------------
local function buildForm(prnt, prfl)
	local row_h, row_p = 32, 10 -- height and padding

	local function buildCheckboxPnl(text, prnt, onChange)
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

		function checkBox:OnChange(bVal)
			onChange(bVal) end
	end

	---------- headshot checkbox panel ----------
	local checkHeadshotPnl = vgui.Create("DPanel", prnt)
	checkHeadshotPnl:SetTall(row_h)
	checkHeadshotPnl:Dock(TOP)
	checkHeadshotPnl:InvalidateParent(true)

	buildCheckboxPnl("View Headshot", checkHeadshotPnl,
	function(bVal) prfl:SetHeadshot(bVal) end)
	---------------------------------------------

	---------- kill checkbox panel ----------
	local checkKillPnl = vgui.Create("DPanel", prnt)
	checkKillPnl:SetTall(row_h)
	checkKillPnl:Dock(TOP)
	checkKillPnl:InvalidateParent(true)

	buildCheckboxPnl("View Killshot", checkKillPnl,
	function(bVal) prfl:SetKill(bVal) end)
	-----------------------------------------
end

--[[-----------------------------
_hm.hitForm( DFrame prnt )
	- builds a hit form
]]-------------------------------
function _hm.hitForm(prnt)
	local exampleHitProfile = _hm.HitProfile()

	---------- Form Panel ----------
	local form = vgui.Create("DPanel", prnt)
	form:SetWide(prnt:GetWide() / 2)
	form:Dock(LEFT)

	buildForm(form, exampleHitProfile)
	--------------------------------

	---------- Color Picker Panel ----------
	local colPick = vgui.Create("DPanel", prnt)
	colPick:SetTall(prnt:GetTall() / 2)
	colPick:Dock(TOP)


	----------------------------------------

	---------- View Panel ----------
	local view = vgui.Create("DPanel", prnt)
	view:Dock(FILL)

	function view:PaintOver(w, h)
		exampleHitProfile:Draw(w / 2, h / 2)
	end
	--------------------------------

	return form
end