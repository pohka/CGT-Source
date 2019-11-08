item_shield = class({})
LinkLuaModifier("item_shield_modifier", LUA_MODIFIER_MOTION_NONE)

function item_shield:OnSpellStart()
  if self:IsItem() then
    local caster = self:GetPurchaser()
    if caster ~= nil then
      caster:AddNewModifier(caster, self, "item_shield_modifier", { duration = 5.0 })
      EmitSoundOn("DOTA_Item.LinkensSphere.Target", caster)
    end
  end
end


