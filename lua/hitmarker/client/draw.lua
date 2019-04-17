--[[ global file vars 
	- track when we should actually be drawing a hitmarker and damage done ]]
local shouldDrawHit = false
local dmgAmounts = { } -- will keep track of current dmg amounts to display

--[[
loadProfiles( )
	Initializes a hitprofile object on the LocalPlayer
]]
local function loadProfiles()
	LocalPlayer()._hit = _hm.Hit()
end
hook.Add("InitPostEntity", "hitmarker_init_ply_profiles", loadProfiles)
LocalPlayer()._hit = _hm.Hit() -- delete this shit later

--[[
whenShouldDrawHit( Number msgLen )
	Toggles shouldDrawHit boolean when called, also builds part of
	the HitProfile used in drawHit function
]]
local function whenShouldDrawHit( msgLen )
	shouldDrawHit = true
	LocalPlayer()._hit:SetWasHeadshot( net.ReadBool() )
	LocalPlayer()._hit:SetWasKill( net.ReadBool() )

	if ( not timer.Exists( "hitmarker_hitlast" ) ) then
		timer.Create( "hitmarker_hitlast", _hm.cfg.hitmarker_last, 1,
		function()
			shouldDrawHit = false
			LocalPlayer()._hit:SetWasHeadshot( false )
			LocalPlayer()._hit:SetWasKill( false )
		end )
	end
end
net.Receive( "hitmarker_when_hit", whenShouldDrawHit )

--[[---------------------
drawDamage( )
	draws the damage done
]]-----------------------
local function drawDamage()
	for _, dmgTable in pairs(dmgAmounts) do
		dmgTable[2] = dmgTable[2] + (1 / 2)
		local x = dmgTable[2] -- dmgTable[2] is the xpos of text

		-- want it follow a parabolic motion in 2nd quandrant
		dmgTable[1]:Draw( -- change 35 here to center offset
			(ScrW()/2) + x, -- x
			(ScrH()/2) - ((x * x) / 50))  -- y = (x^2) / 50
	end
end

--[[
plyDraw( )
	Draws the hitmarker and damage when needed
]]
local function plyDraw()
	if ( shouldDrawHit ) then
		LocalPlayer()._hit:Draw() end

	--LocalPlayer()._hit:DrawMarker()
	-- print( " Hello World!" )

	-- drawDamage()
end
hook.Add("HUDPaint", "hitmarker_draw_hits", plyDraw)
