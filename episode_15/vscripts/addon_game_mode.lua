-- Generated from template

if BattleArena == nil then
	BattleArena = class({})
end



require("game_setup")
require("query")

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]

	PrecacheResource( "model", "models/props_gameplay/boots_of_speed.vmdl", context )

	PrecacheResource( "particle", "particles/econ/items/mirana/mirana_crescent_arrow/mirana_spell_crescent_arrow.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf", context )
	PrecacheResource( "particle", "particles/items3_fx/lotus_orb_shield.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/silencer/silencer_ti6/silencer_last_word_status_ti6_ring_ember.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_silencer/silencer_last_word_status_ring_ember.vpcf", context )
	

	PrecacheResource( "soundfile", "soundevents/game_sounds_items.vsndevts", context )
end

require("game_setup")
require("constants")

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = BattleArena()
	GameRules.AddonTemplate:InitGameMode()
end

function BattleArena:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 1 )

	GameSetup:init()

	local GameMode = GameRules:GetGameModeEntity()
	GameMode:SetModifyExperienceFilter(
		function(ctx, event)
			print("----event---")

			for k,v in pairs(event) do
				print(k,v)
			end

			

			print("-----------")


			local unit  = EntIndexToHScript(event.hero_entindex_const)
			if unit ~= nil then
				unit:GiveMana(50)
			end

			return false --disable default expeirence
		end
		, self)


	ListenToGameEvent("npc_spawned", Dynamic_Wrap(self, "OnUnitSpawned"), self)

	ListenToGameEvent("entity_killed", Dynamic_Wrap(self, "OnUnitKilled"), self)
end


function BattleArena:OnUnitKilled( args )

	local unit = EntIndexToHScript(args.entindex_killed)

	if unit ~= nil then
		if unit:IsHero() then
			print("killed hero:" .. unit:GetName())
		end
	end
end





function BattleArena:OnUnitSpawned( args )
	local entH = EntIndexToHScript(args.entindex)
	if entH ~= nil then
		local count = entH:GetAbilityCount()
		if entH:IsHero() then

			--add starting items
			local hero = entH
			if hero:HasItemInInventory("item_custom_blink") == false then
				hero:AddItemByName("item_custom_blink")
				hero:AddItemByName("item_shield")
				--hero:AddItemByName("item_armor_tier_1")
			end

			--level up all abilities to max
			local i = 0
			while i < 24 or i < count do
				local abil = hero:GetAbilityByIndex(i)
				if abil ~= nil then
					local maxLevel = abil:GetMaxLevel()
					abil:SetLevel(maxLevel);
				end
				i = i + 1
			end
		end
	end
end

-- Evaluate the state of the game
function BattleArena:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print("here")


		local myTable = CustomNetTables:GetTableValue("game_state", "round_data")

		print("constant value:", CUSTOM_GAME_STATE_LOOT)

		if myTable == nil then
			print("value is nil")
			CustomNetTables:SetTableValue("game_state", "round_data", { value = 0, last_update = GameRules:GetGameTime() })
		else
			print("value:" .. myTable.value)
			local nextValue = myTable.value + 1
			CustomNetTables:SetTableValue("game_state", "round_data", { value = nextValue })
		end

		
		

	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end