item_armor_tier_3 = class({})
LinkLuaModifier("item_armor_tiered_modifier", LUA_MODIFIER_MOTION_NONE)

function item_armor_tier_3:GetIntrinsicModifierName()
  return "item_armor_tiered_modifier"
end
