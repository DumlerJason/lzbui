local _, AddOn = ...

AddOn.Nameplates = {}
local Nameplates = AddOn.Nameplates
local S = AddOn.Settings.NameplateSettings

-- Create a frame to hook into target changes
Nameplates.plateEventFrame = {}
Nameplates.LastUpdateTime = 0

function Nameplates:SetNameplateAlpha(nameplate, alpha)
    if not nameplate then
        return
    end
    
    if not alpha then
        return
    end

    if alpha < 0.05 or alpha > 1 then
        return
    end
    
    local unitFrame = nameplate.UnitFrame

    if unitFrame and unitFrame:IsShown() then
        local nameText = unitFrame.name or unitFrame.Name or unitFrame.NameText
        local unitFrameBorder = unitFrame.Border
        local healthBar = unitFrame.healthBar
        local healthBarsContainer = unitFrame.HealthBarsContainer

        if S.HideHealthbarBorders then
            if unitFrameBorder then
                unitFrameBorder:SetAlpha(0)
            end

            if healthBarsContainer and healthBarsContainer.border then
                healthBarsContainer.border:SetAlpha(0)
            end
        end

        if S.SetTextAlpha and nameText then
            nameText:SetAlpha(alpha)
        end

        if S.SetHealthbarAlpha and healthBar then
            healthBar:SetAlpha(alpha)
        end
    end
end

-- Function to update nameplates, showing only the hostile target's nameplate
function Nameplates:UpdateNameplates()
    -- do not update too often!
    if self.LastUpdateTime < S.UpdateRate then
        return
    end

    local targetUnit = "target"  -- The unit ID for the player's current target
    local targetGUID = UnitGUID(targetUnit)  -- Get the GUID of the target

    local playerUnit = "player"
    local playerGUID = UnitGUID(playerUnit)

    local petUnit = "pet"
    local petGUID = UnitGUID(petUnit)


    local nameplates = C_NamePlate.GetNamePlates()
    for _, nameplate in pairs(nameplates) do
        local unit = nameplate.UnitFrame.unit
        local unitGUID = UnitGUID(unit)

        local isTarget = (unitGUID == targetGUID or UnitIsUnit("target", unit))
        local isPlayer = (unitGuid == playerGUID)
        local isPet = (unitGUID == petGUID or UnitIsUnit("pet", unit))
        local isAttacking = (playerThreatSituation and playerThreatSituation > 0)
        local isInCombat = (UnitAffectingCombat(unit) and UnitCanAttack("player", unit))
            
        local playerThreatSituation = UnitThreatSituation("player", unit)

        if isPlayer then
            self:SetNameplateAlpha(nameplate, S.PlayerAlpha)
        elseif isPet then
            self:SetNameplateAlpha(nameplate, S.PetAlpha)
        elseif isTarget then
            self:SetNameplateAlpha(nameplate, S.TargetAlpha)
        elseif isAttacking then
            self:SetNameplateAlpha(nameplate, S.IsAttackingAlpha)
        elseif isInCombat then
            self:SetNameplateAlpha(nameplate, S.InCombatAlpha)
        else
            self:SetNameplateAlpha(nameplate, S.IsOtherAlpha)
        end
    end

    -- reset the update timer
    self.LastUpdateTime = 0
end


function Nameplates:Init()
    self.LastUpdateTime = 0
    self.plateEventFrame = CreateFrame("Frame")

    -- Update on a schedule using the OnUpdate event.
    self.plateEventFrame:SetScript("OnUpdate", function(_, elapsed)
        self.LastUpdateTime = self.LastUpdateTime + elapsed
        self:UpdateNameplates()
    end)
end

--return Nameplates