-- This will help manage nameplates so that during combat only the 
-- necessary nameplates are visible.

Nameplates = {}

-- Create a frame to hook into target changes
Nameplates.plateEventFrame = CreateFrame("Frame")

Nameplates.FullAlpha = 1.0
Nameplates.HalfAlpha = 0.5
Nameplates.QuarterAlpha = 0.25
Nameplates.TransparentAlpha = 0.0

Nameplates.LargeScale = 1.5
Nameplates.FullScale = 1.0
Nameplates.HalfScale = 0.5
Nameplates.QuarterScale = 0.25

Nameplates.LargeWidth = 150
Nameplates.FullWidth = 115
Nameplates.HalfWidth = 57
Nameplates.QuarterWidth = 28

Nameplates.TallHeight = 20
Nameplates.FullHeight = 10
Nameplates.HalfHeight = 5
Nameplates.QuarterHeight = 2

Nameplates.AutoUpdateNameplates = true
Nameplates.UpdateRate = 0.1
Nameplates.LastUpdateTime = 0
Nameplates.BypassRateLimit = true

-- Record the initial user settings for nameplates.
function Nameplates:GetUserSettings()
    -- load local user settings (for future Menu/UI options)
end

function Nameplates:SetPlayerNameplate(nameplate)
    local unitFrame = nameplate.UnitFrame
    nameplate:SetWidth(self.FullWidth)
    unitFrame:SetAlpha(self.FullAlpha)
    unitFrame:SetScale(self.FullScale)
end

function Nameplates:SetTargetNameplate(nameplate)
    local unitFrame = nameplate.UnitFrame
    nameplate:SetWidth(self.FullWidth)
    unitFrame:SetAlpha(self.FullAlpha)
    unitFrame:SetScale(self.FullScale)
end

function Nameplates:SetAddsNameplate(nameplate)
    local unitFrame = nameplate.UnitFrame
    nameplate:SetWidth(self.FullWidth)
    unitFrame:SetAlpha(self.FullAlpha)
    unitFrame:SetScale(self.HalfScale)
end

function Nameplates:SetCombatNameplate(nameplate)
    local unitFrame = nameplate.UnitFrame
    nameplate:SetWidth(self.FullWidth)
    unitFrame:SetAlpha(self.HalfAlpha)
    unitFrame:SetScale(self.HalfScale)
end

function Nameplates:SetHideNameplate(nameplate)
    local unitFrame = nameplate.unitFrame
    nameplate:SetWidth(self.FullWidth)
    unitFrame:SetAlpha(self.QuarterAlpha)
    unitFrame:SetScale(self.FullScale)
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

        if unitGUID == playerGUID then
            -- the player
            self:SetPlayerNameplate(nameplate)
        elseif unitGUID == petGUID or UnitIsUnit("pet", unit) then
            -- player's pet
            self:SetPlayerNameplate(nameplate)
        elseif unitGUID == targetGUID or UnitIsUnit("target", unit) then
            -- player target
            self:SetTargetNameplate(nameplate)
        elseif UnitThreatSituation("player", unit) then
            -- unit is aggro'd to player
            self:SetAddsNameplate(nameplate)
        elseif UnitAffectingCombat(unit) then
            -- unit has player in combat
            self:SetCombatNameplate(nameplate)
        else
            -- unknown or non-combat unit
            self:SetHideNameplate(nameplate)
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

    -- When any of the above events occur, update the nameplates.
    self.plateEventFrame:SetScript("OnEvent", function(_, event, unit, ...)
        self:UpdateNameplates()
    end)

    if not self.LastUpdateTime then
        self.LastUpdateTime = 0
    end

    self.plateEventFrame:SetScript("OnUpdate", function(_, elapsed)
        self.LastUpdateTime = self.LastUpdateTime + elapsed
        if self.BypassRateLimit or self.LastUpdateTime >= self.UpdateRate then
            self:UpdateNameplates()
            self.LastUpdateTime = 0
        end
    end)
end

function Nameplates:Init()
    self:RegisterEvents()
end

--return Nameplates