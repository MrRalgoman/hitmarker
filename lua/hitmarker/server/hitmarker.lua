--[[--------------------------------------------------------
shouldDrawHit(Entity victim, CTakeDamageInfo damage)
	tracks when we should be drawing a hit for which client,
	notifies which client should draw a hit
]]----------------------------------------------------------
local function shouldDrawHit(victim, damage)
	local attacker = damage:GetAttacker() -- get attacker
	
	if (attacker:IsValid() and attacker:IsPlayer()) then
		local dmgAmount = damage:GetDamage() -- get damage
		local wasHeadshot = false
		local wasKillshot = false
		
		if (victim:IsPlayer()) then
			wasHeadshot = (victim:LastHitGroup() == HITGROUP_HEAD) end -- check if was a headshot

		if ((victim:Health() - damage:GetDamage()) < 0) then
			wasKillshot = true end -- check if was a killshot

		print("Was Headshot: " .. tostring(wasHeadshot))
		print("Was Killshot: " .. tostring(wasKillshot))

		net.Start("hitmarker_when_hit")
			net.WriteInt(dmgAmount, 6) -- send damage amount
			net.WriteBool(wasHeadshot) -- send if it was a heashot
			net.WriteBool(wasKillshot) -- send if it was a killshot
		net.Send(attacker) -- send to person attacking
	end
end
hook.Add("EntityTakeDamage", "hitmarker_when_hit", shouldDrawHit)