-- hit config panel
local hitCfg = { }

--[[
hitCfg:Init( )
	initalizes the hitCfg panel
]]
function hitCfg:Init()
	local parent = self:GetParent()

	self:Dock( FILL )
	self:Show( false )
end

vgui.Register( "HitConfigPanel", hitCfg, "DPanel" )