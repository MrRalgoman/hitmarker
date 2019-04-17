local function drawDamage( ) 
end

local midX, midY = ScrW() / 2, ScrH() / 2
local l = 10 
local a = 3 
local w = 2 
local d = w + 1
local negative_arm =
{
	{ x = midX + -a * l * ( w / d ), y = midY + -a * l * ( 1 / d ) },
	{ x = midX + -a * l * ( 1 / d ), y = midY + -a * l * ( w / d ) },
	{ x = midX + a * l * ( w / d ), y = midY + a * l * ( 1 / d ) },
	{ x = midX + a * l * ( 1 / d ), y = midY + a * l * ( w / d ) }
}
local positive_arm =
{
	{ x = midX + -a * l * ( w / d ), y = midY + a * l * ( 1 / d ) },
	{ x = midX + -a * l * ( 1 / d ), y = midY + a * l * ( w / d ) },
	{ x = midX + a * l * ( w / d ), y = midY + -a * l * ( 1 / d ) },
	{ x = midX + a * l * ( 1 / d ), y = midY + -a * l * ( w / d ) }
}

local function createHitMarkerArm( midX, midY, length, width, dir )
	local denom = width + 1

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

local function drawHitmarker( centerO, length, width, outlineWidth )
	local arms =
	{
		[1] = createHitMarkerArm( midX - centerO, midY + centerO, length, width, true ),
		[2] = createHitMarkerArm( midX - centerO, midY - centerO, length, width ),
		[3] = createHitMarkerArm( midX + centerO, midY + centerO, length, width ),
		[4] = createHitMarkerArm( midX + centerO, midY - centerO, length, width, true ) 
	}

	if ( outlineWidth ) then
		length = length + outlineWidth
		width = width + outlineWidth

		local outlineArms =
		{
			[1] = createHitMarkerArm( midX - centerO, midY + centerO, length, width, true ),
			[2] = createHitMarkerArm( midX - centerO, midY - centerO, length, width ),
			[3] = createHitMarkerArm( midX + centerO, midY + centerO, length, width ),
			[4] = createHitMarkerArm( midX + centerO, midY - centerO, length, width, true ) 
		}

		surface.SetDrawColor( 0, 0, 0, 255 )
		for i = 1, #outlineArms do
			surface.DrawPoly( outlineArms[i] ) end
	end
	
	surface.SetDrawColor( 255, 255, 255, 255 )

	for i = 1, #arms do
		surface.DrawPoly( arms[i] ) end
end

local function draw( )
	drawHitmarker( 100, 25, 20, 2 )
end
hook.Add( "HUDPaint", "my_hud_paint_hook", draw )