-- tabs panel
local tabs = { }

--[[
tabs:Init( )
	intializes the tabs panel
]]
function tabs:Init()
	local parent = self:GetParent()
end

-- config frame
local config = { }

--[[
config:Init( )
	initializes the config frame
]]
function config:Init()
	self:SetSize( 800, 600 )
	self:Center()
	self:SetTitle( "Hitmarker Config" )
	self:MakePopup()
end

vgui.Register( "HitmarkerConfigFrame", config, "DFrame" )

net.Receive( "hitmarker_open_cfg_frame",
function()
	vgui.Create( "HitmarkerConfigFrame" )
end )