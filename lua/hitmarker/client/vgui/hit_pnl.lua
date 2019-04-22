-- hit form panel
local hitForm = { }

--[[
hitForm:Init( )
	initializes the hit form panel
]]
function hitForm:Init()
	local parent = self:GetParent()

	self:Dock( LEFT )
	self:SetWide( parent:GetWide() / 2 )
	self:InvalidateParent( true )
end

vgui.Register( "HitmarkerHitForm", hitForm, "DPanel" )

-- color form tabs panel
local colFormTabs = { }


--[[
BuildTabs( )
	builds the tab buttons for the color form
]]
function colFormTabs:BuildTabs() 
	local parent = self:GetParent()
	local n = #self._tabs

	for i = 1, n do
		local tab = vgui.Create( "DButton", self )
		tab:Dock( LEFT )
		tab:SetSize( parent:GetWide() / 4 )
		tab:InvalidateParent( true )
		tab:SetText( self._tabs[i].name )

		local this = self

		function tab:DoClick()
			this._tabs[i].openFunc()
		end
	end
end

--[[
colFormTabs:Init( )
	initializes the hit form panel
]]
function colFormTabs:Init()
	local Hit = LocalPlayer()._hit
	local parent = self:GetParent()

	self:Dock( TOP )
	self:SetTall( parent:GetTall() / 8 )
	self:InvalidateParent( true )

	local tabPnls = { }
	for i = 1, 4 do
		tabPnls[i] = vgui.Create( "DPanel", parent ) end

	local function openTab( index )
		for i = 1, 4 do
			tabPnls[i]:Hide() end

		tabPnls[index]:Show()
	end

	self._tabs =
	{
		[1] = { name = "Default Color", confirmMessage = "Change Default Color",
			panel = tabPnls[1], openFunc = function() openTab( 1 ) end,
			updateFunc = function( c ) Hit:SetColor( c ) end, default = Hit:GetColor() },
		[2] = { name = "Headshot Color", confirmMessage = "Change Headshot Color", 
			panel = tabPnls[2], openFunc = function() openTab( 2 ) end,
			updateFunc = function( c ) Hit:SetHeadshotColor( c ) end, default = Hit:GetHeadshotColor() },
		[3] = { name = "Kill Color", confirmMessage = "Change Kill Color", 
			panel = tabPnls[3], openFunc = function() openTab( 3 ) end,
			updateFunc = function( c ) Hit:SetKillColor( c ) end, default = Hit:GetKillColor() },
		[4] = { name = "Outline Color", confirmMessage = "Change Outline Color", 
			panel = tabPnls[4], openFunc = function() openTab( 4 ) end,
			updateFunc = function( c ) Hit:SetOutlineColor( c ) end, default = Hit:GetOutlineColor }
end

vgui.Register( "HitmarkerColorFormTabs", colFormTabs, "DPanel" )

-- color form panel
local colForm = { }

--[[
BuildTabPanels( DPanel tabPnl )
	builds the tab panels for the color, these consist of the
	different color configurations 
]]
function colForm:BuildTabPanels( tabPnl )
	local Hit = LocalPlayer()._hit
	local parent = self:GetParent()
	local n = #tabPnl._tabs

	for i = 1, n do
		local pnl = tabPnl._tabs[i].panel
		pnl:Dock( FILL )
		pnl:InvalidateParent( true )

		local saveButton = vgui.Create( "DButton", pnl )
		saveButton:Dock( BOTTOM )
		saveButton:InvalidateParent( true )
		saveButton:SetTall( self:GetTall() / 8 )
		saveButton:SetText( tabPnl._tabs[i].confirmMessage )

		local colorPicker = vgui.Create( "DColorMixer", pnl )
		colorPicker:Dock( FILL )
		colorPicker:InvalidateParent( true )
		colorPicker:SetColor( Hit:)

		function saveButton:DoClick()
			tabPnl._tabs[i].updateFunc( colorPicker:GetColor() )
		end
	end
end

--[[
colForm:Init( )
	initalizes the color form panel
]]
function colForm:Init()
	local parent = self:GetParent()
	
	self:Dock( TOP )
	self:SetTall( parent:GetTall() / 2 )
	self:InvalidateParent( true )

	local tabPnl = vgui.Create( "HitmarkerColorFormTabs", self )
	self:BuildTabPanels( tabPnl )
end

vgui.Register( "HitmarkerColorForm", colForm, "DPanel" )

-- display panel
local display = { }

--[[
display:init( )
	initializes the hit form panel
]]
function display:Init()
	local parent = self:GetParent()

	self:Dock( FILL )
	self:InvalidateParent( true )
	
	local hm = parent:GetHitmarker()
	hm._x = self:GetWide() / 2 
	hm._y = self:GetTall() / 2
end

--[[
display:Paint( Number width, Number height )
	paints a preview of the hitmarker, updates realtime
]]
function display:Paint( width, height )
	-- can't get this fucking hitmarker to draw
	self:GetParent()._hitmarker:DrawMarker( width / 2, height / 2 )
end

vgui.Register( "HitmarkerDisplayPanel", display, "DPanel" )

-- hit config panel
local hitCfg = { }

--[[
hitCfg:Init( )
	initalizes the hitCfg panel
]]
function hitCfg:Init()
	local parent = self:GetParent()

	self:Dock( FILL )
	self:InvalidateParent( true )
	self:Show() 

	self._hitmarker = LocalPlayer()._hit

	vgui.Create( "HitmarkerHitForm", self )
	vgui.Create( "HitmarkerColorForm", self )
	vgui.Create( "HitmarkerDisplayPanel", self )
end

--[[
hitCfg:GetHitmarker( )
	returns the hitmarker object to be modified
]]
function hitCfg:GetHitmarker()
	return self._hitmarker end

--[[
hitCfg:Paint( )
	empty draw function, don't want to draw this panel
]]
function hitCfg:Paint()
	end

--[[
hitCfg:OnRemove( )
	reset the hitmarkers x and y values to center of the screen
]]
function hitCfg:OnRemove()
	self._hitmarker._x = ScrW() / 2
	self._hitmarker._y = ScrH() / 2
end

vgui.Register( "HitmarkerConfigPanel", hitCfg, "DPanel" )