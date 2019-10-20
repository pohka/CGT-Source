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
    GameRules:SetPreGameTime(0)
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
    GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(function(ctx, event)
        local item = EntIndexToHScript(event.item_entindex_const)
        if item:GetAbilityName() == "item_tpscroll" and item:GetPurchaser() == nil then return false end
        return true
    end, self)

    --multiple players can pick the same hero
    GameRules:SetSameHeroSelectionEnabled(true)

    --force single hero selection (optional)
    if forceHero ~= nil then
      GameMode:SetCustomGameForceHero(forceHero)
    end
    
    --listen to game state event
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(self, "OnStateChange"), self)
    
  else --release build

    --put your rules here

  end
end

function GameSetup:OnStateChange()
  --random hero once we reach strategy phase
  if GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
    GameSetup:RandomForNoHeroSelected()
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
