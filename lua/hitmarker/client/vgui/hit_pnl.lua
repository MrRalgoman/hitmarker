-- hit form panel
local hitForm = { }

--[[
hitForm:BuildForm( )
	builds the hitmarker settings
]]
function hitForm:BuildForm()
	local Hit = LocalPlayer()._hit

	PrintTable( Hit )

	local bools =
	{
		[1] = { text = "Enable Hitmarker:", default = true }
	}

	local sliders =
	{
		[1] = { text = "Length:", min = 1, max = 100, default = Hit:GetLength() },
		[2] = { text = "Width:", min = 1, max = 100, default = Hit:GetWidth() },
		[3] = { text = "Center Offset:", min = 1, max = 100, default = Hit:GetCenterOffset() },
		[4] = { text = "Outline Width:", min = 1, max = 100, default = Hit:GetOutlineWidth() }
	}

	local n = #bools + #sliders

	for i = 1, #sliders do
		local holder = vgui.Create( "DPanel", self )
		holder:Dock( TOP )
		holder:SetTall( self:GetTall() / n )
		holder:InvalidateParent( true )

		local slider = vgui.Create( "DNumSlider", holder )
		slider:SetSize( holder:GetWide() * ( 9 / 10 ), holder:GetTall() * ( 2 / 3 ) )
		slider:Center()
		slider:SetValue( sliders[i].default )
		slider:SetText( sliders[i].text )
		slider:SetMin( sliders[i].min )
		slider:SetMax( sliders[i].max )
		slider:SetDecimals( 0 )
	end

	for i = 1, #bools do
		local holder = vgui.Create( "DPanel", self )
		holder:Dock( TOP )
		holder:SetTall( self:GetTall() / n )
		holder:InvalidateParent( true )
	end
end

--[[
hitForm:Init( )
	initializes the hit form panel
]]
function hitForm:Init()
	local parent = self:GetParent()

	self:Dock( LEFT )
	self:SetWide( parent:GetWide() / 2 )
	self:InvalidateParent( true )

	self:BuildForm()
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
		
		if ( index == 2 ) then
			Hit:SetWasKill( false )
			Hit:SetWasHeadshot( true )
		elseif ( index == 3 ) then
			Hit:SetWasHeadshot( false )
			Hit:SetWasKill( true )
		else
			Hit:SetWasHeadshot( false )
			Hit:SetWasKill( false )
		end

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
			updateFunc = function( c ) Hit:SetOutlineColor( c ) end, default = Hit:GetOutlineColor() }
	}

	openTab( 1 ) -- by default show the 1st tab
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
		colorPicker:SetColor( tabPnl._tabs[i].default )

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
	tabPnl:BuildTabs()
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