item_boots_tiered_modifier = class({})

function item_boots_tiered_modifier:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}

	return funcs
end

function item_boots_tiered_modifier:GetModifierMoveSpeedBonus_Constant()
  local abil = self:GetAbility()
  if abil ~= nil then
    local moveSpeed = abil:GetSpecialValueFor("move_speed")
    if moveSpeed ~= nil then
      return moveSpeed
    end
  end
  return 0
end

function item_boots_tiered_modifier:IsHidden()
  return true
end
