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
		
		if (victim:IsPlayer()) then
			wasHeadshot = (victim:LastHitGroup() == HITGROUP_HEAD) end -- check if was a headshot

		net.Start("hitmarker_when_hit")
			net.WriteInt(dmgAmount, 6) -- send damage amount
			net.WriteBool(wasHeadshot) -- send if it was a heashot
			-- eventually send if it was a kill shot
		net.Send(attacker) -- send to person attacking
	end
end
hook.Add("EntityTakeDamage", "hitmarker_when_hit", shouldDrawHit)