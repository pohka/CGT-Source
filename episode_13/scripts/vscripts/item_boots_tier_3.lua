item_boots_tier_3 = class({})
LinkLuaModifier("item_boots_tiered_modifier", LUA_MODIFIER_MOTION_NONE)


function item_boots_tier_3:GetIntrinsicModifierName()
  return "item_boots_tiered_modifier"
end
