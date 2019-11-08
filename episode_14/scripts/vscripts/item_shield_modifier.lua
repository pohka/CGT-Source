item_shield_modifier = class({})


function item_shield_modifier:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}

	return funcs
end

function item_shield_modifier:OnTakeDamage( params )
  self:Destroy()
end

function item_shield_modifier:GetEffectName()
	return "particles/items3_fx/lotus_orb_shield.vpcf"
end

function item_shield_modifier:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function item_shield_modifier:IsDebuff()
	return false
end

function item_shield_modifier:GetModifierTotal_ConstantBlock()
  return 100000
end


