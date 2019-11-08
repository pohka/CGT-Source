item_armor_tier_2 = class({})
LinkLuaModifier("item_armor_tiered_modifier", LUA_MODIFIER_MOTION_NONE)

function item_armor_tier_2:GetIntrinsicModifierName()
  return "item_armor_tiered_modifier"
end
