hero_spawn_booter_modifier = class({})

function hero_spawn_booter_modifier:OnDestroy()
  if IsServer() then
    local hero = self:GetParent()
    --hero:SetBaseMaxHealth(4)
    --hero:SetMaxHealth(4)
    --hero:SetHealth(4)
    hero:SetMaxMana (100)
    hero:SetMana(0)
    hero:SetBaseHealthRegen(0.0)
    hero:SetBaseManaRegen(0.0)


  end
end
