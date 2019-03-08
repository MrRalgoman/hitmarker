--[[ global file vars
	- for ease of changing lengths/widths ]]
local frame_w = 800 -- frame width
local frame_h = 500 -- frame height
local tabs_h = 35 -- height of tabs panel
local tabs_o = 25 -- tabs panel offset
local formPnl_p = 5 -- form panel padding
local formPnl_w = frame_w - formPnl_p * 2 -- form panel width
local formPnl_h = frame_h - tabs_o - formPnl_p * 2 - tabs_h -- form panel height

--[[---------------------------------------------------
buildTabs( DPanel tabPnl )
	- Builds the tabs for the configuration frame (hitmarker and dmg nums)
]]-----------------------------------------------------
local function buildTabs(tabPnl)
	local len, xPos = #tabPnl:GetParent()._forms, 0
	for i = 1, len do
		local tabBtn = vgui.Create("DButton", tabPnl)
		tabBtn:SetPos(xPos, 0)
		tabBtn:SetSize(tabPnl:GetWide() / len + 1, tabPnl:GetTall())
		tabBtn:SetText(i)

		function tabBtn:DoClick()
			for i = 1, len do 
				tabPnl:GetParent()._forms[i]:SetVisible(false) end
			
			tabPnl:GetParent()._forms[i]:SetVisible(true)
		end

		xPos = (xPos + tabPnl:GetWide() / len) - 1
	end
end

--[[--------------------------------
buildFrame()
	- builds the configuration frame
]]----------------------------------
local function buildFrame()
	local profile = _hm.HitProfile()
	local frame = vgui.Create("DFrame")
	frame:SetSize(frame_w, frame_h)
	frame:SetTitle("")
	frame:Center()
	frame:MakePopup()

	frame._forms = { vgui.Create("DPanel", frame), vgui.Create("DPanel", frame) }

	local tabPnl = vgui.Create("DPanel", frame)
	tabPnl:Dock(TOP)
	tabPnl:InvalidateParent(true)
	tabPnl:SetTall(tabs_h)

	buildTabs(tabPnl)

	for i = 1, #frame._forms do
		frame._forms[i]:Dock(FILL)
		frame._forms[i]:InvalidateParent(true)
		if (i == 2) then -- don't show 2nd panel
			frame._forms[i]:SetVisible(false) end
	end

	_hm.hitForm(frame._forms[1]) -- build hit form
	_hm.dmgNumForm(frame._forms[2]) -- build dmg num form
end
net.Receive("hitmarker_open_cfg_frame", buildFrame)