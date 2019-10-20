wraith_king_q = class({})

function wraith_king_q:OnSpellStart()
  local caster = self:GetCaster()
  local target = self:GetCursorTarget()

  if target ~= nil then
    local info = 
    {
      Target = target,
      Source = caster,
      Ability = self,	
      EffectName = "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf",
      iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
      iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
      bDodgeable = true,
      flExpireTime = GameRules:GetGameTime() + 10, 
      bProvidesVision = false
      --iVisionRadius = 400,
    }
    projectile = ProjectileManager:CreateTrackingProjectile(info)
    EmitSoundOn( "Hero_SkeletonKing.Hellfire_Blast", self:GetCaster() )
  end
end

function wraith_king_q:OnProjectileHit(hTarget, vLocation)
  if hTarget ~= nil then
    
    local damageTable = {
      victim = hTarget,
      attacker = self:GetCaster(),
      damage = self:GetAbilityDamage(),
      damage_type = self:GetAbilityDamageType(),
      damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
      ability = self, --Optional.
    }
    
    ApplyDamage(damageTable)
  end
end
