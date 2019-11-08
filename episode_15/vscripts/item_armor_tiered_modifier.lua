item_armor_tiered_modifier = class({})

function item_armor_tiered_modifier:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_HEALTH_BONUS
  }
  return funcs
end

function item_armor_tiered_modifier:IsHidden()
  return true
end

function item_armor_tiered_modifier:GetModifierHealthBonus()
  local abil = self:GetAbility()
  if abil ~= nil then
    local bonusHP = abil:GetSpecialValueFor("hp")
    if bonusHP ~= nil then
      return bonusHP
    end
  end
  return 0
end
