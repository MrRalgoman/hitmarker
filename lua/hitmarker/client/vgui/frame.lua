-- tabs panel
local tabs = { }

--[[
tabs:OpenHitmarkerPanel( )
	- opens the hitmarker panel
]]
function tabs:OpenHitmarkerPanel()
	if ( not IsValid( self.tabs[1].panel ) or not IsValid( self.tabs[2].panel ) )
		then return end

	self.tabs[1].panel:Show()
	self.tabs[2].panel:Hide()
end

--[[
tabs:OpenDamagePanel( )
	- opens the damage panel
]]
function tabs:OpenDamagePanel()
	if ( not IsValid( self.tabs[1].panel ) or not IsValid( self.tabs[2].panel ) )
		then return end

	self.tabs[2].panel:Show()
	self.tabs[1].panel:Hide()
end

--[[
tabs:BuildButtons( )
	- builds the actual tab buttons
]]
function tabs:BuildButtons()
	local n = table.Count( self.tabs )

	PrintTable( self.tabs )

	for i = 1, n do
		local tab = vgui.Create( "DButton", self )
		tab:SetText( self.tabs[i].name )

		tab:Dock( LEFT )
		tab:SetWide( self:GetWide() / 2 )
		tab:InvalidateParent( true )

		function tab:DoClick()
			self:GetParent().tabs[i].openFunc()
		end
	end
end

--[[
tabs:Init( )
	intializes the tabs panel
]]
function tabs:Init()
	local parent = self:GetParent()

	self:Dock( TOP )
	self:SetTall( parent:GetTall() / 16 )
	self:InvalidateParent( true )

	print( " Parent:GetWide() = " .. parent:GetWide() )

	self.tabs =
	{
		[1] = { panel = vgui.Create( "HitmarkerConfigPanel", parent ), name = "Hitmarker Settings",
			openFunc = function () self:OpenHitmarkerPanel() end },
		[2] = { panel = vgui.Create( "DamageConfigPanel", parent ), name = "Damage Settings",
			openFunc = function() self:OpenDamagePanel() end }
	}

	self:BuildButtons()
end

vgui.Register( "HitmarkerTabPanel", tabs, "DPanel" )

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

	vgui.Create( "HitmarkerTabPanel", self )
end

vgui.Register( "HitmarkerConfigFrame", config, "DFrame" )

-- Listener for serverside chat command
net.Receive( "hitmarker_open_cfg_frame",
function()
	vgui.Create( "HitmarkerConfigFrame" )
end )

-- Clientside concommand so that it auto-completes in console
concommand.Add( _hm.cfg.open_command,
function()
	vgui.Create( "HitmarkerConfigFrame" )
end )