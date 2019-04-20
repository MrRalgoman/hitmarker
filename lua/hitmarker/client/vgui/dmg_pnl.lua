-- hit config panel
local dmgCfg = { }

--[[
dmgCfg:Init( )
	initalizes the dmgCfg panel
]]
function dmgCfg:Init()
	local parent = self:GetParent()

	self:Dock( FILL )
	self:Hide()

	local label = vgui.Create( "DLabel", self )
	label:SetText( "DamageConfigPanel" )
end

vgui.Register( "DamageConfigPanel", dmgCfg, "DPanel" )