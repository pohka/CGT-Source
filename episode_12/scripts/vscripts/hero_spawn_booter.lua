hero_spawn_booter = class({})
LinkLuaModifier("hero_spawn_booter_modifier",  LUA_MODIFIER_MOTION_NONE )

function hero_spawn_booter:OnUpgrade()
 local caster = self:GetCaster()
 caster:SetBaseAgility(0)
 caster:SetBaseIntellect(0)
 caster:SetBaseStrength(0)

 caster:AddNewModifier(caster, self, "hero_spawn_booter_modifier", { duration = 1.0 })
end
