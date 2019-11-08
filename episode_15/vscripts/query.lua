if Query == nil then
  Query = class({})
end

function Query:findItemByName(unit, itemName)
  if unit ~= nil and unit:HasInventory() then
    for i=DOTA_ITEM_SLOT_1, DOTA_STASH_SLOT_6 do
      local item = unit:GetItemInSlot(i);
      if item:GetName() == itemName then
        return item
      end
    end
  end
  return nil
end
