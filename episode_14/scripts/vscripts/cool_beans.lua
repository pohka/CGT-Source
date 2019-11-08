cool_beans = class({})

function cool_beans:OnSpellStart()
  local target = self:GetCursorTarget()
  local caster = self:GetCaster()

  if target ~= nil then
    local damageTable = {
      victim = target,
      attacker = caster,
      damage = self:GetAbilityDamage(),
      damage_type = self:GetAbilityDamageType(),
      --damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
      --ability = self, --Optional.
    }

    ApplyDamage(damageTable)

    local stunDuration = self:GetSpecialValueFor("stun_duration")
    print("stun duration: " .. stunDuration)
  end
end
