local _, AddOn = ...

AddOn.Nameplates = {}
local Nameplates = AddOn.Nameplates
local C = AddOn.Constants

-- Create a frame to hook into target changes
Nameplates.plateEventFrame = {}

Nameplates.UpdateRate = 0.05
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
        if unitFrame.healthBar.border then
            unitFrame.healthBar.border:SetAlpha(0)
        end

        if unitFrame.threatGlow then
            unitFrame.threatGlow:SetAlpha(0)
        end

        if unitFrame.selectionHighlight then
            unitFrame.selectionHighlight:SetAlpha(0)
        end
        if nameplate.UnitFrame.healthBar then
            nameplate.UnitFrame.healthBar:SetAlpha(alpha)
        end
    end
end

-- Function to update nameplates, showing only the hostile target's nameplate
function Nameplates:UpdateNameplates()
    -- do not update too often!
    if self.LastUpdateTime < self.UpdateRate then
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

        local playerThreatSituation = UnitThreatSituation("player", unit)

        if unitGUID == playerGUID then
            -- the player
            self:SetNameplateAlpha(nameplate, Constants.Alpha.Max)
        elseif unitGUID == petGUID or UnitIsUnit("pet", unit) then
            -- player's pet
            self:SetNameplateAlpha(nameplate, C.Alpha.Max)
        elseif unitGUID == targetGUID or UnitIsUnit("target", unit) then
            -- player target
            self:SetNameplateAlpha(nameplate, C.Alpha.Max)
        elseif playerThreatSituation and playerThreatSituation > 0 then
            -- unit is aggro'd to player
            self:SetNameplateAlpha(nameplate, C.Alpha.Max)
        elseif UnitAffectingCombat(unit) and UnitCanAttack("player", unit) then
            -- unit has player in combat
            self:SetNameplateAlpha(nameplate, C.Alpha.Tenth)
        else
            -- unknown or non-combat unit
            self:SetNameplateAlpha(nameplate, C.Alpha.Tenth)
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