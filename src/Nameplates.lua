-- This will help manage nameplates so that during combat only the 
-- necessary nameplates are visible.

Nameplates = {}

-- Create a frame to hook into target changes
Nameplates.plateEventFrame = CreateFrame("Frame")

Nameplates.FullAlpha = 1.0
Nameplates.HalfAlpha = 0.5
Nameplates.QuarterAlpha = 0.25
Nameplates.TransparentAlpha = 0.0

Nameplates.AutoUpdateNameplates = true
Nameplates.UpdateRate = 0.05
Nameplates.LastUpdateTime = 0

function Nameplates:SetNameplateAlpha(nameplate, alpha)
    if not nameplate then
        return
    end
    
    if alpha < 0.05 or alpha > 1 then
        return
    end

    local unitFrame = nameplate.UnitFrame
    if unitFrame and unitFrame:IsShown() then
        unitFrame:SetAlpha(alpha)
    end
end

-- Function to update nameplates, showing only the hostile target's nameplate
function Nameplates:UpdateNameplates()
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

        playerThreatSituation = UnitThreatSituation("player", unit)

        if unitGUID == playerGUID then
            -- the player
            self:SetNameplateAlpha(nameplate, Constants.MaxAlpha)
        elseif unitGUID == petGUID or UnitIsUnit("pet", unit) then
            -- player's pet
            self:SetNameplateAlpha(nameplate, Constants.MaxAlpha)
        elseif unitGUID == targetGUID or UnitIsUnit("target", unit) then
            -- player target
            self:SetNameplateAlpha(nameplate, Constants.MaxAlpha)
        elseif playerThreatSituation and playerThreatSituation > 0 then
            -- unit is aggro'd to player
            self:SetNameplateAlpha(nameplate, Constants.MaxAlpha)
        elseif UnitAffectingCombat(unit) and UnitCanAttack("player", unit) then
            -- unit has player in combat
            self:SetNameplateAlpha(nameplate, 0.5)
        else
            -- unknown or non-combat unit
            self:SetNameplateAlpha(nameplate, 0.25)
        end
    end
end

function Nameplates:RegisterEvents()
    self.plateEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
    self.plateEventFrame:RegisterEvent("PLAYER_ENTER_COMBAT")
    self.plateEventFrame:RegisterEvent("PLAYER_LEAVE_COMBAT")
    self.plateEventFrame:RegisterEvent("NAME_PLATE_CREATED")
    self.plateEventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    self.plateEventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    self.plateEventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    self.plateEventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
    self.plateEventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

    -- When any of the above events occur, update the nameplates.
    self.plateEventFrame:SetScript("OnEvent", function(_, event, unit, ...)
        self:UpdateNameplates()
    end)

    if not self.LastUpdateTime then
        self.LastUpdateTime = 0
    end

    self.plateEventFrame:SetScript("OnUpdate", function(_, elapsed)
        self.LastUpdateTime = self.LastUpdateTime + elapsed
        if self.LastUpdateTime >= self.UpdateRate then
            self:UpdateNameplates()
            self.LastUpdateTime = 0
        end
    end)
end

function Nameplates:Init()
    self:RegisterEvents()
end

--return Nameplates