--[[-----------------------------
_hm.hitForm( DFrame prnt )
	- builds a hit form
]]-------------------------------
function _hm.hitForm(prnt)
	local form = vgui.Create("DPanel", prnt)
	form:SetWide(prnt:GetWide() / 2)
	form:Dock(LEFT)

	local colPick = vgui.Create("DPanel", prnt)
	colPick:SetTall(prnt:GetTall() / 2)
	colPick:Dock(TOP)

	local view = vgui.Create("DPanel", prnt)
	view:Dock(FILL)

	local HitProfile = _hm.HitProfile()
	function view:PaintOver(w, h)
		HitProfile:Draw(w / 2, h / 2)
	end

	return form
end