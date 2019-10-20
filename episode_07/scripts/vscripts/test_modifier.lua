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

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------