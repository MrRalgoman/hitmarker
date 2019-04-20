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
colFormTabs:Init( )
	initializes the hit form panel
]]
function colFormTabs:Init()
	local parent = self:GetParent()

	self:Dock( TOP )
	self:SetTall( parent:GetTall() / 8 )
	self:InvalidateParent( true )
end

vgui.Register( "HitmarkerColorFormTabs", colFormTabs, "DPanel" )

-- color form panel
local colForm = { }

--[[
colForm:Init( )
	initalizes the color form panel
]]
function colForm:Init()
	local parent = self:GetParent()
	
	self:Dock( TOP )
	self:SetTall( parent:GetTall() / 2 )
	self:InvalidateParent( true )

	vgui.Create( "HitmarkerColorFormTabs", self )
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