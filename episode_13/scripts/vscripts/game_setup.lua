if GameSetup == nil then
  GameSetup = class({})
end

--nil will not force a hero selection
local forceHero = "skeleton_king"


function GameSetup:init()
  if IsInToolsMode() then  --debug build
    --skip all the starting game mode stages e.g picking screen, showcase, etc
    GameRules:EnableCustomGameSetupAutoLaunch(true)
    GameRules:SetCustomGameSetupAutoLaunchDelay(0)
    GameRules:SetHeroSelectionTime(10)
    GameRules:SetStrategyTime(0)
    GameRules:SetPreGameTime(5)
    GameRules:SetShowcaseTime(0)
    GameRules:SetPostGameTime(5)
    
    --disable some setting which are annoying then testing
    local GameMode = GameRules:GetGameModeEntity()
    GameMode:SetAnnouncerDisabled(true)
    GameMode:SetKillingSpreeAnnouncerDisabled(true)
    GameMode:SetDaynightCycleDisabled(true)
    GameMode:DisableHudFlip(true)
    GameMode:SetDeathOverlayDisabled(true)
    GameMode:SetWeatherEffectsDisabled(true)

    --disable music events
    GameRules:SetCustomGameAllowHeroPickMusic(false)
    GameRules:SetCustomGameAllowMusicAtGameStart(false)
    GameRules:SetCustomGameAllowBattleMusic(false)

    -- Remove starting TP scroll using inventroy filter
    -- GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(function(ctx, event)
    --     local item = EntIndexToHScript(event.item_entindex_const)
    --     if item:GetAbilityName() == "item_tpscroll" and item:GetPurchaser() == nil then 
    --       return false
    --     end
    --     return true
    -- end, self)

    GameSetup:AddInventroyFilter()

    --multiple players can pick the same hero
    GameRules:SetSameHeroSelectionEnabled(true)

    --force single hero selection (optional)
    if forceHero ~= nil then
      GameMode:SetCustomGameForceHero(forceHero)
    end
    
    --listen to game state event
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(self, "OnStateChange"), self)

    GameRules:SetUseUniversalShopMode(true)
    
  else --release build

    --put your rules here

  end
end

function GameSetup:AddInventroyFilter()

  --this filter functionality:
  --  1. removes starting teleport
  --  2. drops lower tier item of same type from inventory
  GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(
		function(ctx, event)
			local item = EntIndexToHScript(event.item_entindex_const)

			--remove starting teleport scroll
			if item:GetAbilityName() == "item_tpscroll" and item:GetPurchaser() == nil then 
				return false
			end
			
			local unitPickUpIndex = event.inventory_parent_entindex_const
			local unit = EntIndexToHScript(unitPickUpIndex)
			--local unit = item:GetOwner()
			if unit ~= nil then
				local itemPos = item:GetAbsOrigin()

				local itemName = item:GetName()
        local sub = string.sub(itemName, 1, -2)
        
        --table of items to spawn
        local itemPrefixs = {
          "item_boots_tier_",
          "item_armor_tier_"
        }

        for i=1, #itemPrefixs do
          local itemPrefix = itemPrefixs[i]

          if sub == itemPrefix then
            local num = string.sub(itemName, -1)
            local tier = tonumber(num)

            --get current tier by name
            local currentTier = 0
            if unit:HasItemInInventory(itemPrefix .. "1") then
              currentTier = 1
            elseif unit:HasItemInInventory(itemPrefix .. "2") then
              currentTier = 2
            elseif unit:HasItemInInventory(itemPrefix .. "3") then
              currentTier = 3
            end

            if currentTier < tier then
              --drop current item if new item tier is higher
              if currentTier > 0 then
                local curItemName = itemPrefix .. currentTier
                local curItem = Query:findItemByName(unit, curItemName)
                if curItem ~= nil then
                  unit:RemoveItem(curItem)
                  local itemCopy = CreateItem(curItemName, nil, nil)
                  local pos = unit:GetAbsOrigin()
                  local drop = CreateItemOnPositionSync( pos, itemCopy )
                  local pos_launch = pos+RandomVector(RandomFloat(30,50))
                  itemCopy:LaunchLoot(false, 250, 0.75, pos_launch)
                end
              end
            --drop item because we currently have a higher or equal item
            elseif currentTier >= tier then
              local pos = unit:GetAbsOrigin()
              local drop = CreateItemOnPositionSync( pos, item )
              local pos_launch = pos+RandomVector(RandomFloat(30,50))
              item:LaunchLoot(false, 250, 0.75, pos_launch)
              return false
            end
          end --end of item loop
				end
			end

      --this event is broken in dota, so calling it from here instead
      if item.OnItemEquipped ~= nil then
        item:OnItemEquipped(item)
      end
		  return true
		end,
		self)
end

function GameSetup:OnStateChange()
  --random hero once we reach strategy phase
  if GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
    GameSetup:RandomForNoHeroSelected()
  elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    GameSetup:SpawnItems()

    if IsInToolsMode() then
      --create test hero and allow player to control it
      local playerID= PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, 1)
      print("playerID:" .. playerID)
      local player = PlayerResource:GetPlayer(playerID)
      local unit = CreateUnitByName("npc_dota_hero_sven", Vector(0,0,0), true, nil, nil, DOTA_TEAM_BADGUYS)

      unit:SetControllableByPlayer(playerID, true)
      
    end
    
  end
end

-- spawns random items of each type in random spawn point
-- the spawn points for each item is unique and all mirrored for each team
function GameSetup:SpawnItems()
  print("spawning items")

  --table of items to spawn
  local items = {
    "item_boots_tier_",
    "item_armor_tier_"
  }

  --item rarity
  local tier2Rate = 35
  local tier3Rate = 20

  --teams
  local firstTeam = DOTA_TEAM_GOODGUYS
  local lastTeam = DOTA_TEAM_GOODGUYS

  local totalSpawnPts = 10 -- total possible spawn locations
  local maxSpawns = 4 -- total number of item of each type spawned

  if totalSpawnPts < maxSpawns * #items then
    print("WARNING: more total spawn points needed")
  end

  --fill table with indexes
  local unusedSpawnIndexes = {}
  for i=1, totalSpawnPts do
    table.insert(unusedSpawnIndexes, i)
  end

  
  for itemIndex=1, #items do
    --table for spawnIndexes for this item
    local spawnPts = {}
    
     --pick random indexes from unused indexes (each spawn point index is unique)
    while #spawnPts < maxSpawns do
      local tableIndex = RandomInt(1, #unusedSpawnIndexes)
      local spawnIndex = unusedSpawnIndexes[tableIndex]
      table.insert(spawnPts, spawnIndex)
      table.remove(unusedSpawnIndexes, tableIndex)
    end

    for teamID=firstTeam, lastTeam do
      for i=1, #spawnPts do
        local spawnIndex = spawnPts[i]
        local spawnName = "item_spawn_" .. teamID .. "_" .. spawnIndex
        local spawnPointEnt = Entities:FindByName(nil, spawnName)
    
        if spawnPointEnt ~= nil then
          --random tier based on rarity
          local randomNum = RandomInt(1,100)
          local tier = 1
          if randomNum < tier3Rate then
            tier = 3
          elseif randomNum < tier2Rate+tier3Rate then
            tier = 2
          end
    
          --mirror item spawns for each team
          for teamID=firstTeam, lastTeam do
            local itemName = items[itemIndex] .. tier
            local item  = CreateItem(itemName, nil, nil)
            if item ~= nil then
              local point = spawnPointEnt:GetAbsOrigin()
              CreateItemOnPositionSync(point, item)
            else
                print("item was not able to be created: " .. itemName)
            end
          end
        else
          print("spawn point not found: " .. spawnName)
        end
      end
    end
  end
end


function GameSetup:RandomForNoHeroSelected()
    --NOTE: GameRules state must be in HERO_SELECTION or STRATEGY_TIME to pick heroes
    --loop through each player on every team and random a hero if they haven't picked
  local maxPlayers = 5
  for teamNum = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
    for i=1, maxPlayers do
      local playerID = PlayerResource:GetNthPlayerIDOnTeam(teamNum, i)
      if playerID ~= nil then
        if not PlayerResource:HasSelectedHero(playerID) then
          local hPlayer = PlayerResource:GetPlayer(playerID)
          if hPlayer ~= nil then
            hPlayer:MakeRandomHeroSelection()
          end
        end
      end
    end
  end
end
