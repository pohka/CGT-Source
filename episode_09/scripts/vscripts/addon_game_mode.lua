-- Generated from template

if BattleArena == nil then
	BattleArena = class({})
end

require("game_setup")

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]

	PrecacheResource( "particle", "particles/econ/items/mirana/mirana_crescent_arrow/mirana_spell_crescent_arrow.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf", context )
	

	PrecacheResource( "soundfile", "soundevents/game_sounds_items.vsndevts", context )
end

require("game_setup")

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = BattleArena()
	GameRules.AddonTemplate:InitGameMode()
end


function BattleArena:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

	GameSetup:init()

	CreateUnitByName("johnboy", Vector(0,1300,0), true, nil, nil, DOTA_TEAM_BADGUYS)

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
	
	--args.entindex_attacker

	--args.entindex_inflictor
	--args.damagebits
end





function BattleArena:OnUnitSpawned( args )
	local entH = EntIndexToHScript(args.entindex)
	if entH ~= nil then
		local count = entH:GetAbilityCount()
		if entH:IsHero() then

			--add starting items
			local hero = entH
			if hero:HasItemInInventory("item_blink") == false then
				hero:AddItemByName("item_blink")
				hero:AddItemByName("item_custom_blink")
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
		--print( "Template addon script is running." )
		
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end