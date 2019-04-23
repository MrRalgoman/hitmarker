-- Hit object
local Hit = { }

--[[
	Hit object interface

	_hm.Hit( ) --> Object constructor

	Hit:UpdateCenter( ) --> Updates the center of the hitmarker

	Hit:CreateArm( Number midX, Number midY, Number length, Number width, Boolean dir ) 
	--> (INTERNAL) creates a hitmarker arm for draw hitmarker function, the direction determines whether
	the polygon is SE -> NW (false) or SW -> NE (true)

	Hit:DrawMarker( ) --> Draws the hitmarker

	Hit:GetLength( ) -------------> Get the length of the hitmarker
	Hit:SetLength( Number len ) --> Set the length of the hitmarker
	
	Hit:GetWidth( ) -------------> Get the width of the hitmarker
	Hit:SetWidth( Number len ) --> Set the width of the hitmarker

	Hit:GetCenterOffset( ) -------------> Get the center offset of the hitmarker
	Hit:SetCenterOffset( Number len ) --> Set the center offset of the hitmarker
	
	Hit:GetOutlineWidth( ) -------------> Get the outline width of the hitmarker
	Hit:SetOutlineWidth( Number len ) --> Set the outline width of the hitmarker

	Hit:GetWasHeadshot( ) ---------------> Get if the last hit was a headshot
	Hit:SetWasHeadshot( Boolean bool ) --> Set if the last hit was a headshot

	Hit:GetWasKill( ) ---------------> Get if the last hit was a kill
	Hit:SetWasKill( Boolean bool ) --> Set if the last hit was a kill

	Hit:GetColor( ) ------------> Get the color of the hitmarker
	Hit:SetColor( Color col ) --> Set the color of the hitmarker
	
	Hit:GetHeadshotColor( ) ------------> Get the headshot color of the hitmarker
	Hit:SetHeadshotColor( Color col ) --> Set the headshot color of the hitmarker

	Hit:GetKillColor( ) ------------> Get the kill color of the hitmarker
	Hit:SetKillColor( Color col ) --> Set the kill color of the hitmarker

	Hit:GetOutlineColor( ) -----------------> Get the outline color of the hitmarker
	Hit:SetOutlineColorColor( Color col ) --> Set the outline color of the hitmarker
]]

AccessorFunc( Hit, "_l", "Length", FORCE_NUMBER )
AccessorFunc( Hit, "_w", "Width", FORCE_NUMBER )
AccessorFunc( Hit, "_centerO", "CenterOffset", FORCE_NUMBER )
AccessorFunc( Hit, "_outW", "OutlineWidth", FORCE_NUMBER )
AccessorFunc( Hit, "_headshot", "WasHeadshot", FORCE_BOOL )
AccessorFunc( Hit, "_kill", "WasKill", FORCE_BOOL )
Hit._color = Color( 255, 255, 255, 255 )
Hit._headCol = Color( 239, 224, 4, 255 ) -- yellow
Hit._killCol = Color( 153, 35, 35, 255 ) -- red
Hit._outlineColor = Color( 0, 0, 0, 255 )

function Hit:SetColor( col )
	self._color = col end
function Hit:GetColor( )
	return self._color or Color( 255, 255, 255, 255 ) end
	
function Hit:SetHeadshotColor( col )
	self._headCol = col end
function Hit:GetHeadshotColor( )
	return self._headCol or Color( 239, 224, 4, 255 ) end

function Hit:SetKillColor( col )
	self._killCol = col end
function Hit:GetKillColor( )
	return self._killCol or Color( 153, 35, 35, 255 ) end

function Hit:SetOutlineColor( col )
	self._outlineColor = col end
function Hit:GetOutlineColor( )
	return self._outlineColor or Color( 0, 0, 0, 255 ) end

--[[
Hit:CreateArm( Number midX, Number midY, Number length, Number width, Boolean dir )
	(INTERNAL) creates a hitmarker arm for draw hitmarker function, the
	direction determins whether the polygon is SE -> NW (false) or SW -> NE (true) 
]]
function Hit:CreateArm( midX, midY, length, width, dir )
	-- https://gyazo.com/2b394e4526ffd97be8396113cb0ed4b5
	if (dir) then
		return {
			{ x = midX - length - width, y = midY + length - width },
			{ x = midX + length - width, y = midY - length - width },
			{ x = midX + length + width, y = midY - length + width },
			{ x = midX - length + width, y = midY + length + width }
		}
	else
		return {
			{ x = midX - length - width, y = midY - length + width },
			{ x = midX - length + width, y = midY - length - width },
			{ x = midX + length + width, y = midY + length - width },
			{ x = midX + length - width, y = midY + length + width }
		}
	end
end

--[[
Hit:DrawMarker( )
	Draws the marker
]]
function Hit:DrawMarker( centerX, centerY )
	local arms, outlineArms =
	{
		[1] = self:CreateArm( centerX - self._centerO, centerY + self._centerO, self._l, self._w, true ),
		[2] = self:CreateArm( centerX - self._centerO, centerY - self._centerO, self._l, self._w, false ),
		[3] = self:CreateArm( centerX + self._centerO, centerY + self._centerO, self._l, self._w, false ),
		[4] = self:CreateArm( centerX + self._centerO, centerY - self._centerO, self._l, self._w, true ) 
	}

	if ( 0 < self._outW ) then
		local length, width = self._l + self._outW, self._w + self._outW

		outlineArms =
		{
			[1] = self:CreateArm( centerX - self._centerO, centerY + self._centerO, length, width, true ),
			[2] = self:CreateArm( centerX - self._centerO, centerY - self._centerO, length, width, false ),
			[3] = self:CreateArm( centerX + self._centerO, centerY + self._centerO, length, width, false ),
			[4] = self:CreateArm( centerX + self._centerO, centerY - self._centerO, length, width, true ) 
		}
		
		surface.SetDrawColor( self:GetOutlineColor() )
		for i = 1, #outlineArms do
			surface.DrawPoly( outlineArms[i] ) end
	end
	
	local col = self:GetColor()

	if ( self:GetWasHeadshot() ) then col = self:GetHeadshotColor() end
	if ( self:GetWasKill() ) then col = self:GetKillColor() end

	surface.SetDrawColor( col )
	for i = 1, #arms do
		surface.DrawPoly( arms[i] ) end
end

--[[
_hm.Hit( )
	Hit object constructor
]]
function _hm.Hit()
	local this = table.Copy( Hit )

	this:SetLength( 3 )
	this:SetWidth( 1 )
	this:SetCenterOffset( 8 )
	this:SetOutlineWidth( 1 )
	this:SetColor( Color( 255, 255, 255, 255 ) )
	this:SetHeadshotColor( Color( 239, 224, 4, 255 ) )
	this:SetKillColor( Color( 153, 35, 35, 255 ) )
	this:SetOutlineColor( Color( 0, 0, 0, 255 ) )
	this:SetWasHeadshot( false )
	this:SetWasKill( false )

	return this
end