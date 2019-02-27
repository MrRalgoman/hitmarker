--[[------------------------------
createAddonFont(Number size)
	- Creates a font for the addon
]]--------------------------------
local function createAddonFont(size)
	surface.CreateFont("hitmarker_" .. size, {
		font = "Arial",
		size = size,
		weight = 500,
		antialias = true,
	} )

	-- create bold as well
	surface.CreateFont("hitmarker_B" .. size, {
		font = "Arial",
		size = size,
		weight = 700,
		antialias = true,
	} )
end

-- can do this here because this is loaded in initialize hook
for i = 14, 50 do
	createAddonFont(i)
end