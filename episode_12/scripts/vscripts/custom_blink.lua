custom_blink  = class({})

function custom_blink:OnSpellStart()
  local caster = self:GetCaster()
  local point = self:GetCursorPosition()
  FindClearSpaceForUnit(caster, point, true)
end
