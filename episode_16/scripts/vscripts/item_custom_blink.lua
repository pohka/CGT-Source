item_custom_blink = class({})

function item_custom_blink:OnSpellStart()
  local caster = self:GetCaster()
  local point = self:GetCursorPosition()
  local casterPt = caster:GetAbsOrigin()

  if point ~= nil and casterPt ~= nil then
    local diff = point - casterPt
    diff.z = 0
    local direction = diff:Normalized()
    local castDistance = diff:Length2D()

    local maxRange = self:GetSpecialValueFor("max_range")
    local penaltyRange = self:GetSpecialValueFor("penalty_range")

    ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_glow_nexon_hero_cp_2014.vpcf", PATTACH_ABSORIGIN, caster)

    --dodge projectile
    ProjectileManager:ProjectileDodge(caster)

    --move unit based on ranges
    if castDistance > maxRange then
      local position = caster:GetAbsOrigin() + (direction * penaltyRange)
      FindClearSpaceForUnit(caster, position, true)
    else
      local position = caster:GetAbsOrigin() + (direction * castDistance)
      FindClearSpaceForUnit(caster, position, true)
    end

    --decide which sound to play
    if castDistance <= maxRange and castDistance > penaltyRange then
      EmitSoundOn( "DOTA_Item.BlinkDagger.NailedIt", self:GetCaster() )
    else
      EmitSoundOn( "DOTA_Item.BlinkDagger.Activate", self:GetCaster() )
    end
  end
end
