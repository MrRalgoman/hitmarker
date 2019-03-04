--[[---------------------------------------
_hm.dmgNumForm( DFrame prnt )
	- returns a damage number form (DPanel)
]]-----------------------------------------
function _hm.dmgNumForm(prnt)
	local form = vgui.Create("DPanel", prnt)
	form:Dock(FILL)
	form:InvalidateParent(true)
	form:SetVisible(false)

	return form
end