-- hit config panel
local dmgCfg = { }

--[[
dmgCfg:Init( )
	initalizes the dmgCfg panel
]]
function dmgCfg:Init()
	local parent = self:GetParent()

	self:Dock( FILL )
	self:Show( false )
end

vgui.Register( "DamageConfigPanel", dmgCfg, "DPanel" )