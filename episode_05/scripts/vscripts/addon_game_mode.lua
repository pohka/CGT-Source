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