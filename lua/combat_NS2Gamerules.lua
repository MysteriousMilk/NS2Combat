//________________________________
//
//   	Combat Mod     
//	Made by JimWest, 2012
//
//	Version 0.1
//	
//________________________________

// combat_NS2Gamerules.lua

if(not CombatNS2Gamerules) then
  CombatNS2Gamerules = {}
end

local HotReload = ClassHooker:Mixin("CombatNS2Gamerules")

function CombatNS2Gamerules:OnLoad()

    ClassHooker:SetClassCreatedIn("NS2Gamerules", "lua/NS2Gamerules.lua")
    self:PostHookClassFunction("NS2Gamerules", "JoinTeam", "JoinTeam_Hook")
    
    ClassHooker:SetClassCreatedIn("Gamerules", "lua/Gamerules.lua")
    self:PostHookClassFunction("Gamerules", "OnClientConnect", "OnClientConnect_Hook")
	
end

// Free the lvl when changing Teams
function CombatNS2Gamerules:JoinTeam_Hook(self, player, newTeamNumber, force)

	// Reinitialise the tech tree
	player.combatTechTree = nil
	player:CheckCombatData()
	
    if player:GetLvl() > 1 then
        if player.combatTable.techtree[1] then
             // give the Lvl back
            player.combatTable.lvlfree = player.combatTable.lvlfree + player.combatTable.lvl - 1
            // clear the techtree
            player.combatTable.techtree = {}
			player.resources = 999
		end
    else
	   // Give the player the average XP of all players on the server.
       if GetGamerules():GetGameStarted() then
            // get AvgXp 
            player:AddXp(Experience_GetAvgXp())
            // Printing the avg xp to the Server Console for testing
            Print(Experience_GetAvgXp())
        end    
    end

end

// If the client connects, send him the welcome Message
function CombatNS2Gamerules:OnClientConnect_Hook(self, client)
    local player = client:GetControllingPlayer()
    
    for i, message in ipairs(combatWelcomeMessage) do
        player:SendDirectMessage(message)  
    end

end

if(HotReload) then
    CombatNS2Gamerules:OnLoad()
end