item_boots_tier_2 = class({})
LinkLuaModifier("item_boots_tiered_modifier", LUA_MODIFIER_MOTION_NONE)


function item_boots_tier_2:GetIntrinsicModifierName()
  return "item_boots_tiered_modifier"
end

