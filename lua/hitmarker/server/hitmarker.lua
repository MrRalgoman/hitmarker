--[[
shouldDrawHit(Entity victim, CTakeDamageInfo damage)
	Tracks when we should be drawing a hit for which client
	Notifies which client should draw a hit
]]
local function shouldDrawHit( victim, damage )
	local attacker = damage:GetAttacker() -- get attacker
	
	if ( attacker:IsValid() and attacker:IsPlayer() ) then
		local dmgAmount = damage:GetDamage() -- get damage
		local wasHeadshot = false
		local wasKillshot = false
		
		if ( victim:IsPlayer() ) then
			wasHeadshot = ( victim:LastHitGroup() == HITGROUP_HEAD ) end -- check if was a headshot

		if ( ( victim:Health() - damage:GetDamage() ) < 0 ) then
			wasKillshot = true end -- check if was a killshot

		net.Start( "hitmarker_when_hit" )
			net.WriteInt( dmgAmount, 6 ) -- send damage amount
			net.WriteBool( wasHeadshot ) -- send if it was a heashot
			net.WriteBool( wasKillshot ) -- send if it was a killshot
		net.Send( attacker ) -- send to person attacking
	end
end
hook.Add( "EntityTakeDamage", "hitmarker_when_hit", shouldDrawHit )

--[[----------------------------------------------------
openConfigFrame( Player ply, string text )
	- Opens the configuration frame from console command
	- Can be called via console command or chat message
	- Returns empty string (for chat hook)
]]------------------------------------------------------
local function openConfigFrame(ply, text)
	if (not _hm.cfg.allow_everyone and not _hm.cfg.admin_groups[ply:GetUserGroup()]) then
		return end

	if (text != _hm.cfg.open_command:lower()) then
		text = text:lower():sub(2, #text) -- cut off preceding ! or /

		if (text != _hm.cfg.open_command:lower()) then
			return end
	end

	net.Start("hitmarker_open_cfg_frame")
	net.Send(ply)

	return ""
end
hook.Add("PlayerSay", "hitmarker_open_cfg_frame", openConfigFrame)