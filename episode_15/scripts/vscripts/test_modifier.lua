test_modifier = class({})

--------------------------------------------------------------------------------

function test_modifier:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function test_modifier:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function test_modifier:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

--------------------------------------------------------------------------------

function test_modifier:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function test_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function test_modifier:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function test_modifier:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function test_modifier:OnCreated( kv )
	if IsServer() then
		self.tick_rate = kv.tick_rate
		self.damage_per_tick = kv.damage_per_tick

		print("onCreated:" .. GameRules:GetGameTime())
		self:StartIntervalThink( kv.tick_rate )
		self:OnIntervalThink()
	end
end


function test_modifier:OnIntervalThink()
	if IsServer() then
		print("ticking:" .. GameRules:GetGameTime())

		local ability = self:GetAbility()

		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage_per_tick,
			damage_type = DAMAGE_TYPE_MAGICAL,
			--damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = ability, --Optional.
		}
		
		ApplyDamage(damageTable)
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------