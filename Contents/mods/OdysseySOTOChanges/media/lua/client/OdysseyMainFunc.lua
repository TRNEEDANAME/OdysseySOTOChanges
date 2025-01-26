-- Functions

function OdysseyDecBoredom(player, chance, boredom)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentBoredom = player:getBodyDamage():getBoredomLevel();
		player:getBodyDamage():setBoredomLevel(currentBoredom - boredom);
		if player:getBodyDamage():getBoredomLevel() < 0 then
			player:getBodyDamage():setBoredomLevel(0);
		end
	end
end

function OdysseyDecUnhapyness(player, chance, Unhapyness)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentUnhapyness = player:getBodyDamage():getUnhappynessLevel();
		player:getBodyDamage():setUnhappynessLevel(currentUnhapyness - Unhapyness);
		if player:getBodyDamage():getUnhappynessLevel() < 0 then
			player:getBodyDamage():setUnhappynessLevel(0);
		end
	end
end

function OdysseyDecStressCig(player, chance, stress_cigarettes)
    --print("ODYSSEY CHANGES : CIG STRESS : " .. tostring(stress_cigarettes))
    if player and player.getBodyDamage and player:getBodyDamage() and player.getStats and player:getStats() then
        local currentStressCig = player:getStats():getStressFromCigarettes()
        if type(currentStressCig) == "number" and type(stress_cigarettes) == "number" then
            local HundredChance = ZombRand(100);
            if HundredChance <= chance and player:HasTrait("Smoker") then
                --player:getStats():setStressFromCigarettes(currentStressCig - stress_cigarettes);
                player:getStats():setStress(math.max(0.01, player:getStats():getStress() - player:getStats():getStressFromCigarettes()) - stress_cigarettes)
                --print("ODYSSEY CHANGES : CIG STRESS CHANGED : ".. tostring(currentStressCig - stress_cigarettes))
                if player:getStats():getStressFromCigarettes() < 0 then
                    player:getStats():setStressFromCigarettes(0);
                end
            end
        end
    end
end


function OdysseyDecStress(player, chance, stress)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentStress = player:getStats():getStress();
		if player:getStats():getStress() < 0 then
			player:getStats():setStress(0);
		end
		player:getStats():setStress(currentStress - stress);
	end
end

-- Traits changes

function Outdoorsmantraitbored ()
    local player = getPlayer();
    local boredoommod = SandboxVars.OdysseySOTOChanges.OdysseyRPOutdoorsmanBoredomReduction;
    if (player:HasTrait("Outdoorsman") or player:HasTrait("Outdoorsman2")) and player:isOutside() and SandboxVars.OdysseySOTOChanges.DoesOutdoorsmanReduceBoredom then
        if not player:isAsleep() then
            OdysseyDecBoredom(player, 100, boredoommod);
        end
        if player:isAsleep() then
            OdysseyDecBoredom(player, 100, (boredoommod * 2));
        end
    end
end

function Outdoorsmantraitunhapyness ()
    local player = getPlayer();
    local unhapyness = SandboxVars.OdysseySOTOChanges.OdysseyRPOutdoorsmanUnhapynessReduction;
    if (player:HasTrait("Outdoorsman") or player:HasTrait("Outdoorsman2")) and player:isOutside() and SandboxVars.OdysseySOTOChanges.DoesOutdoorsmanReduceUnhapyness then
        if not player:isAsleep() then
            OdysseyDecUnhapyness(player, 100, unhapyness * 2);
        end
        if player:isAsleep() then
            OdysseyDecUnhapyness(player, 100, (unhapyness * 4));
        end
    end
end



function Outdoorsmantraitstress ()
    local player = getPlayer();
    local stress = SandboxVars.OdysseySOTOChanges.OdysseyRPOutdoorsmanStressReduction;
    local stressCig = SandboxVars.OdysseySOTOChanges.OdysseyRPOutdoorsmanCigStressReduction;
    if (player:HasTrait("Outdoorsman") or player:HasTrait("Outdoorsman2")) and player:HasTrait("Smoker") and player:isOutside() and player:getStats():getStressFromCigarettes() ~= 0 and SandboxVars.OdysseySOTOChanges.DoesOutdoorsmanReduceStress then
        if not player:isAsleep() then
            print("ODYSSEY CHANGES : CIG STRESS : " .. player:getStats():getStressFromCigarettes())
            OdysseyDecStressCig(player, 100, stressCig);
        end
        if player:isAsleep() and player:getStats():getStressFromCigarettes() ~= 0 then
            --print("ODYSSEY CHANGES : CIG STRESS : " .. player:getStats():getStressFromCigarettes())
            OdysseyDecStressCig(player, 100, (stressCig * 2));
        end
    end
    if (player:HasTrait("Outdoorsman") or player:HasTrait("Outdoorsman2")) and not player:HasTrait("Smoker") and player:isOutside() and SandboxVars.OdysseySOTOChanges.DoesOutdoorsmanReduceStress then
        if not player:isAsleep() then
            OdysseyDecStress(player, 100, stress);
        end
        if player:isAsleep() then
            OdysseyDecStress(player, 100, (stress * 2));
        end
    end
    if (player:HasTrait("Outdoorsman") or player:HasTrait("Outdoorsman2")) and player:isOutside() and SandboxVars.OdysseySOTOChanges.DoesOutdoorsmanReduceBoredom then
        if not player:isAsleep() then
            OdysseyDecStress(player, 100, stress);
        end
        if player:isAsleep() then
            OdysseyDecStress(player, 100, (stress * 2));
        end
    end
end

function Outdoorsmantrait ()
    local player = getPlayer()
    local currentBoredom = player:getBodyDamage():getBoredomLevel()
    local currentUnhapyness = player:getBodyDamage():getUnhappynessLevel()
    local currentStress = player:getStats():getStress()
    local currentStressCig = player:getStats():getStressFromCigarettes()

    if player:getModData().OdysseyHourUntilDepression == nil then
        player:getModData().OdysseyHourUntilDepression = 0
    end

    if (player:HasTrait("Outdoorsman") or player:HasTrait("Outdoorsman2")) and not player:isAsleep() and player:getModData().OdysseyHourUntilDepression <= 32 and player:isOutside() then
        if SandboxVars.OdysseySOTOChanges.DoesOutdoorsmanReduceUnhapyness and currentUnhapyness >= 50 then
            OdysseyDecUnhapyness(player, 100, currentUnhapyness)
        end

        if SandboxVars.OdysseySOTOChanges.DoesOutdoorsmanReduceBoredom and currentBoredom >= 50 then
            OdysseyDecBoredom(player, 100, currentBoredom)
        end

        if SandboxVars.OdysseySOTOChanges.DoesOutdoorsmanReduceStress and currentStress >= 50 then
            OdysseyDecStress(player, 100, currentStress)
        end

        if SandboxVars.OdysseySOTOChanges.DoesOutdoorsmanReduceStressCig and player:HasTrait("Smoker") and currentStressCig >= 50 and player:getStats():getStressFromCigarettes() ~= nil then
            OdysseyDecStressCig(player, 100, currentStressCig)
        end
    end
end

Events.OnPlayerUpdate.Add(Outdoorsmantrait);
Events.EveryOneMinute.Add(Outdoorsmantraitbored);
Events.EveryOneMinute.Add(Outdoorsmantraitunhapyness);
Events.EveryOneMinute.Add(Outdoorsmantraitstress);
