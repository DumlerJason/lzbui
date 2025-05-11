
MinimizeUI = {}

-- Used to listen for events.
MinimizeUI.EventFrame = CreateFrame("Frame")

MinimizeUI.MinAlpha = 0.1               -- minimum alpha for a Frame.
MinimizeUI.MaxAlpha = 1.0               -- maximum alpha for a Frame.
MinimizeUI.MouseOverAlpha = 0.4         -- add this much alpha on mouse over
MinimizeUI.EnterCombatAlpha = 0.9       -- add this much alpha on enter combat
MinimizeUI.EnterFlyingAlpha = 0.9       -- add this much alpha on enter flying
MinimizeUI.StatusAlpha = 0.4            -- add this much alpha on a status ailment

MinimizeUI.LastOnUpdate = 0             -- last time the OnUpdate handler was run.
MinimizeUI.OnUpdateFrameRate = 15       -- how many times per second to run this.
MinimizeUI.OnUpdateInterval = 1 / MinimizeUI.OnUpdateFrameRate

-- Just a list of all the events we're responding to.
MinimizeUI.AllEvents = {
    "PLAYER_ENTERING_WORLD",        -- alpha, resize, combat?
    "PLAYER_TARGET_CHANGED",        -- alpha, resize, combat?
    "UNIT_TARGET",                  -- alpha, resize, combat?
    "UNIT_PORTRAIT_UPDATE",         -- alpha, resize, combat?
    "TALKINGHEAD_REQUESTED",        -- resize
    "UNIT_POWER_UPDATE",            -- alpha, resize
    "UNIT_POWER_FREQUENT",          -- alpha, resize
    "PLAYER_ENTER_COMBAT",          -- combat
    "PLAYER_LEAVE_COMBAT",          -- combat
    "PLAYER_REGEN_ENABLED",         -- combat
    "PLAYER_REGEN_DISABLED",        -- combat
    "UNIT_COMBAT",                  -- combat
    "PLAYER_MOUNT_DISPLAY_CHANGED", -- mounting, flying
    "UNIT_AURA",                    -- mounting, flying
    "UNIT_HEALTH",                  -- combat
    "PLAYER_TARGET_CHANGED",        -- nameplates
    "NAME_PLATE_UNIT_REMOVED",      -- nameplates
    "NAME_PLATE_UNIT_ADDED"         -- nameplates
}

-- Events that indicate the player has entered or left combat.
MinimizeUI.CombatEvents = {
    "PLAYER_ENTER_COMBAT",          -- player enter combat event
    "PLAYER_LEAVE_COMBAT",          -- player leave combat event
    "PLAYER_REGEN_ENABLED",         -- player's regeneration is enabled (outside of combat)
    "PLAYER_REGEN_DISABLED",        -- player's regeneration is disabled (while in combat)
    "UNIT_COMBAT",                  -- some unit somewhere did a combat
    "UNIT_HEALTH"
}

-- Events that indicate player health has changed.
MinimizeUI.HealthEvents = {
    "UNIT_HEALTH"
}

-- Events for mounts or flying.
MinimizeUI.MountEvents = {
    "PLAYER_MOUNT_DISPLAY_CHANGED",
    "UNIT_AURA"
}

-- Events that indicate we should try to resize frames.
MinimizeUI.ResizeEvents = {
        "PLAYER_ENTERING_WORLD",
        "TALKINGHEAD_REQUESTED",
        "UNIT_POWER_UPDATE",
        "UNIT_POWER_FREQUENT"
}

-- Events that indicate we need to manage the Nameplates.
MinimizeUI.NameplateEvents = {
    "PLAYER_TARGET_CHANGED",
    "NAME_PLATE_UNIT_REMOVED",
    "NAME_PLATE_UNIT_ADDED"
}

-- These are the frames we want to manage.
--- @class FrameSettings
--- @field Frame Frame                   -- Reference to the Frame
--- @field Description string            -- Description of the Frame
--- @field EnableAlpha boolean           -- Whether alpha change is enabled
--- @field EnableResize boolean          -- Whether resizing is enabled
--- @field EnableMouseOver boolean       -- Whether mouseover effects are enabled
--- @field EnableCombat boolean          -- Whether combat-based changes are enabled
--- @field EnableMount boolean           -- Whether mounting changes are enabled
--- @field EnableFlying boolean          -- Whether flying-based changes are enabled
--- @field FrameScale number             -- Scale of the frame
--- @field FrameAlpha number             -- Alpha value of the frame
--- @field MouseOverAlpha number         -- Alpha value on mouseover
--- @field CombatAlpha number            -- Alpha value during combat
--- @field FlyingAlpha number            -- Alpha value during flying
--- @type FrameSettings[]                -- Declare MinimizeFrames.Frames as an array of FrameSettings
MinimizeUI.Frames = {
    {
        Frame = TalkingHeadFrame,                   -- Reference to the Frame
        Description = "Annoyingly huge talking head Frame",
        EnableAlpha = false,
        EnableResize = true,
        EnableMouseOver = false,
        EnableCombat = false,
        EnableMount = false,
        EnableFlying = false,
        EnableHealth = false,
        FrameScale = 0.5,
        FrameAlpha = MinimizeUI.MaxAlpha,
        MouseOverAlpha = 0.0,
        CombatAlpha = 0.0,
        FlyingAlpha = 0.0
    },
    {
        Frame = UIWidgetPowerBarContainerFrame,     -- Dragonflight energy indicator
        Description = "Dragonflight energy indicator",
        EnableAlpha = true,
        EnableResize = true,
        EnableMouseOver = true,
        EnableCombat = false,
        EnableMount = false,
        EnableFlying = true,
        EnableHealth = false,
        FrameScale = 0.5,
        FrameAlpha = MinimizeUI.MaxAlpha,
        MouseOverAlpha = 0.4,
        CombatAlpha = 0.9,
        FlyingAlpha = 0.9
    },
    {
        Frame = PlayerFrame,                        -- Player Frame
        Description = "Player Frame",
        EnableAlpha = true,
        EnableResize = true,
        EnableMouseOver = true,
        EnableCombat = true,
        EnableMount = false,
        EnableFlying = false,
        EnableHealth = true,
        FrameScale = 0.8,
        FrameAlpha = MinimizeUI.MinAlpha,
        MouseOverAlpha = 0.4,
        CombatAlpha = 0.9,
        FlyingAlpha = 0.0
    },
    {
        Frame = PetFrame,                           -- Player pet Frame
        Description = "Player pet Frame",
        EnableAlpha = true,
        EnableResize = false,
        EnableMouseOver = true,
        EnableCombat = true,
        EnableMount = false,
        EnableFlying = false,
        EnableHealth = true,
        FrameScale = 1.0,
        FrameAlpha = MinimizeUI.MinAlpha,
        MouseOverAlpha = 0.4,
        CombatAlpha = 0.9,
        FlyingAlpha = 0.0
    },
    {
        Frame = TargetFrame,                        -- Player target Frame
        Description = "Target Frame",
        EnableAlpha = false,
        EnableResize = true,
        EnableMouseOver = false,
        EnableCombat = false,
        EnableMount = false,
        EnableFlying = false,
        EnableHealth = false,
        FrameScale = 0.8,
        FrameAlpha = MinimizeUI.MinAlpha,
        MouseOverAlpha = 0.4,
        CombatAlpha = 0.9,
        FlyingAlpha = 0.0
    },
    {
        Frame = ObjectiveTrackerFrame.NineSlice,    -- Background of the objective tracker
        Description = "Background of the objective tracker",
        EnableAlpha = true,
        EnableResize = false,
        EnableMouseOver = true,
        EnableCombat = false,
        EnableMount = false,
        EnableFlying = false,
        EnableHealth = false,
        FrameScale = 1.0,
        FrameAlpha = MinimizeUI.MinAlpha,
        MouseOverAlpha = 0.9,
        CombatAlpha = -0.9,
        FlyingAlpha = 0.0
    },
    {
        Frame = MainMenuBar,    -- Action Bar 1
        Description = "Action Bar 1",
        EnableAlpha = true,
        EnableResize = false,
        EnableMouseOver = true,
        EnableCombat = true,
        EnableMount = true,
        EnableFlying = true,
        EnableHealth = false,
        FrameScale = 1.0,
        FrameAlpha = MinimizeUI.MinAlpha,
        MouseOverAlpha = 0.9,
        CombatAlpha = 0.9,
        FlyingAlpha = 0.9
    },
    {
        Frame = MultiBarBottomLeft,    -- Action Bar 2
        Description = "Action Bar 2",
        EnableAlpha = true,
        EnableResize = false,
        EnableMouseOver = true,
        EnableCombat = true,
        EnableMount = false,
        EnableFlying = false,
        EnableHealth = false,
        FrameScale = 1.0,
        FrameAlpha = MinimizeUI.MinAlpha,
        MouseOverAlpha = 0.9,
        CombatAlpha = 0.9,
        FlyingAlpha = 0.0
    },
    {
        Frame = MultiBarBottomRight,    -- Action Bar 3
        Description = "Action Bar 3",
        EnableAlpha = false,
        EnableResize = false,
        EnableMouseOver = false,
        EnableCombat = false,
        EnableMount = false,
        EnableFlying = false,
        EnableHealth = false,
        FrameScale = 1.0,
        FrameAlpha = MinimizeUI.MinAlpha,
        MouseOverAlpha = 0.9,
        CombatAlpha = 0.9,
        FlyingAlpha = 0.0
    },
    {
        Frame = MultiBarRight,    -- Action Bar 4
        Description = "Action Bar 4",
        EnableAlpha = false,
        EnableResize = false,
        EnableMouseOver = false,
        EnableCombat = false,
        EnableMount = false,
        EnableFlying = false,
        EnableHealth = false,
        FrameScale = 1.0,
        FrameAlpha = MinimizeUI.MinAlpha,
        MouseOverAlpha = 0.9,
        CombatAlpha = 0.0,
        FlyingAlpha = 0.0
    },
    {
        Frame = MultiBarLeft,    -- Action Bar 5
        Description = "Action Bar 5",
        EnableAlpha = false,
        EnableResize = false,
        EnableMouseOver = false,
        EnableCombat = false,
        EnableMount = false,
        EnableFlying = false,
        EnableHealth = false,
        FrameScale = 1.0,
        FrameAlpha = MinimizeUI.MinAlpha,
        MouseOverAlpha = 0.9,
        CombatAlpha = 0.0,
        FlyingAlpha = 0.0
    },
    {
        Frame = MultiBar5,    -- Action Bar 6
        Description = "Action Bar 6",
        EnableAlpha = false,
        EnableResize = false,
        EnableMouseOver = false,
        EnableCombat = false,
        EnableMount = false,
        EnableFlying = false,
        EnableHealth = false,
        FrameScale = 1.0,
        FrameAlpha = MinimizeUI.MinAlpha,
        MouseOverAlpha = 0.9,
        CombatAlpha = 0.0,
        FlyingAlpha = 0.0
    },
    {
        Frame = MultiBar6,    -- Action Bar 7
        Description = "Action Bar 7",
        EnableAlpha = true,
        EnableResize = false,
        EnableMouseOver = true,
        EnableCombat = true,
        EnableMount = false,
        EnableFlying = false,
        EnableHealth = false,
        FrameScale = 1.0,
        FrameAlpha = MinimizeUI.MinAlpha,
        MouseOverAlpha = 0.9,
        CombatAlpha = 0.9,
        FlyingAlpha = 0.0
    },
    {
        Frame = MultiBar7,    -- Action Bar 8
        Description = "Action Bar 8",
        EnableAlpha = false,
        EnableResize = false,
        EnableMouseOver = false,
        EnableCombat = false,
        EnableMount = false,
        EnableFlying = false,
        EnableHealth = false,
        FrameScale = 1.0,
        FrameAlpha = MinimizeUI.MinAlpha,
        MouseOverAlpha = 0.9,
        CombatAlpha = 0.0,
        FlyingAlpha = 0.0
    },
    {
        Frame = ExtraActionBarFrame,    -- Extra Action Bar
        Description = "Extra Action Bar",
        EnableAlpha = false,
        EnableResize = false,
        EnableMouseOver = false,
        EnableCombat = false,
        EnableMount = false,
        EnableFlying = false,
        EnableHealth = false,
        FrameScale = 1.0,
        FrameAlpha = MinimizeUI.MinAlpha,
        MouseOverAlpha = 0.9,
        CombatAlpha = 0.0,
        FlyingAlpha = 0.0
    }
}

function MinimizeUI:FrameSettingsCount()
    return #MinimizeUI.Frames
end

function MinimizeUI:AllEventsCount()
    return #MinimizeUI.AllEvents
end

-- Set the alpha for the frame. Default is min alpha.
function MinimizeUI:CalculateAlpha(frameSettings)
    local newAlpha = 0.0

    if (not frameSettings.Frame) then
        return newAlpha
    end

    local currentAlpha = frameSettings.Frame:GetAlpha()
    if (not frameSettings.EnableAlpha) then
        return currentAlpha
    end

    newAlpha = MinimizeUI.MinAlpha
    local isFlying = IsFlying("player") or UnitOnTaxi("player")
    local isMounted = IsMounted()

    -- Add some alpha when the mouse is over the Frame.
    if (frameSettings.EnableMouseOver and Utility:IsMouseOverFrame(frameSettings.Frame)) then
        newAlpha = Utility:Clamp(newAlpha + frameSettings.MouseOverAlpha, MinimizeUI.MinAlpha, MinimizeUI.MaxAlpha)
    end

    -- special case where action bar 1 needs to be visible when mounted.
    if (frameSettings.EnableMount and isMounted) then
        newAlpha = Utility:Clamp(newAlpha + frameSettings.FlyingAlpha, MinimizeUI.MinAlpha, MinimizeUI.MaxAlpha)
    end

    if (frameSettings.EnableFlying and isFlying) then
        newAlpha = Utility:Clamp(newAlpha + frameSettings.FlyingAlpha, MinimizeUI.MinAlpha, MinimizeUI.MaxAlpha)
    end

    if (frameSettings.EnableCombat) then
        if (UnitAffectingCombat("player") or UnitAffectingCombat("pet")) then
            -- player or pet is in combat
            newAlpha = Utility:Clamp(newAlpha + frameSettings.CombatAlpha, MinimizeUI.MinAlpha, MinimizeUI.MaxAlpha)
        else
            local playerHealth = UnitHealth("player")
            local playerMaxHealth = UnitHealthMax("player")
            local playerIsHurt = playerHealth < playerMaxHealth

            local petHealth = 0
            local petMaxHealth = 0
            local petIsDead = false
            local petIsHurt = false

            if (UnitExists("pet")) then
                petHealth = UnitHealth("pet")
                petMaxHealth = UnitHealthMax("pet")
                petIsHurt = petHealth < petMaxHealth
                if (petHealth == 0) then
                    petIsDead = true
                end
            end

            if (playerIsHurt or petIsHurt or petIsDead) then
                newAlpha = Utility:Clamp(newAlpha + frameSettings.CombatAlpha, MinimizeUI.MinAlpha, MinimizeUI.MaxAlpha)
            end
        end
    end

    return newAlpha
end

-- Set the alpha of the frame and fade in/out.
function MinimizeUI:SetAlpha(frame, newAlpha)
    local currentAlpha = frame:GetAlpha()
    if (currentAlpha < newAlpha) then
        UIFrameFadeIn(frame, 0.5, currentAlpha, newAlpha)
    elseif (currentAlpha > newAlpha) then
        UIFrameFadeOut(frame, 0.5, currentAlpha, newAlpha)
    end
end

function MinimizeUI:OnUpdate(frameSettings)
    if (frameSettings.Frame and frameSettings.EnableMouseOver) then
        local newAlpha = MinimizeUI:CalculateAlpha(frameSettings)
        MinimizeUI:SetAlpha(frameSettings.Frame, newAlpha)
    end
end

-- Set alpha of frames based on the player's combat state.
function MinimizeUI:SetCombatAlpha()
    local framesCount = MinimizeUI:FrameSettingsCount()
    for i = 1, framesCount do
        local frameSettings = MinimizeUI.Frames[i]
        -- this frame reacts to combat
        if (frameSettings.EnableCombat) then
            if (frameSettings.EnableAlpha and frameSettings.Frame) then
                local newAlpha = MinimizeUI:CalculateAlpha(frameSettings)
                MinimizeUI:SetAlpha(frameSettings.Frame, newAlpha)
            end
        end
    end
end

-- Set the alpha of some things due to the player's flying state.
function MinimizeUI:SetFlyingAlpha()
    local framesCount = MinimizeUI:FrameSettingsCount()
    for i = 1, framesCount do
        local frameSettings = MinimizeUI.Frames[i]

        -- this frame reacts to flying
        if (frameSettings.Frame) then
            if (frameSettings.EnableFlying) then
                if (frameSettings.EnableAlpha) then
                    local newAlpha = MinimizeUI:CalculateAlpha(frameSettings)
                    MinimizeUI:SetAlpha(frameSettings.Frame, newAlpha)
                end
            end
        end
    end
end

-- Set the sizes for the frames; should only need to be done at startup.
function MinimizeUI:ResizeFrames()
    local framesCount = MinimizeUI:FrameSettingsCount()
    for i = 1, framesCount do
        local frameSettings = MinimizeUI.Frames[i]
        if frameSettings.EnableResize and frameSettings.Frame then
            frameSettings.Frame:SetScale(frameSettings.FrameScale)
        end
    end
end

-- Make the target nameplate visible and hide all other nameplates.
function MinimizeUI:SetNameplateVisibility()
    -- Get the nameplate for the current target
    local targetPlate = C_NamePlate.GetNamePlateForUnit("target")
    local inCombat = UnitAffectingCombat("player")
    -- Loop through all active nameplates
    local nameplates = C_NamePlate.GetNamePlates()
    for _, namePlate in pairs(nameplates) do
        local unitToken = namePlate.namePlateUnitToken

        if (namePlate == targetPlate) then
            -- Show and customize the target's nameplate
            namePlate.UnitFrame.healthBar:SetAlpha(1)  -- Make it fully visible
            namePlate.UnitFrame.HealthBarsContainer:SetAlpha(1)
            namePlate.UnitFrame:SetScale(1.5)  -- Increase the size to make it stand out
        elseif (inCombat) then
            if (UnitAffectingCombat(unitToken)) then
                -- unit has player in combat
                namePlate.UnitFrame.healthBar:SetAlpha(0.7)
                namePlate.UnitFrame.HealthBarsContainer:SetAlpha(0)
                namePlate.UnitFrame:SetScale(0.7)
            elseif (UnitReaction("player", unitToken) > 4) then
                -- Unit is hostile to player.
                namePlate.UnitFrame.healthBar:SetAlpha(0.7)
                namePlate.UnitFrame.HealthBarsContainer:SetAlpha(0)
                namePlate.UnitFrame:SetScale(0.7)
            elseif (UnitAffectingCombat(unitToken)) then
                -- Unit has the player in combat.
                -- Unit is hostile to player.
                namePlate.UnitFrame.healthBar:SetAlpha(0.7)
                namePlate.UnitFrame.HealthBarsContainer:SetAlpha(0)
                namePlate.UnitFrame:SetScale(0.7)
            elseif (UnitThreatSituation("player", unitToken)) then
                -- unit is aggro'd to player
                namePlate.UnitFrame.healthBar:SetAlpha(0.7)
                namePlate.UnitFrame.HealthBarsContainer:SetAlpha(0)
                namePlate.UnitFrame:SetScale(0.7)
            else
                -- Hide all other nameplates
                namePlate.UnitFrame.healthBar:SetAlpha(0)
                namePlate.UnitFrame.HealthBarsContainer:SetAlpha(0)
            end
        else
            -- Hide all other nameplates
            namePlate.UnitFrame.healthBar:SetAlpha(0)
            namePlate.UnitFrame.HealthBarsContainer:SetAlpha(0)
        end
    end
end

-- Apply event handlers to the event frame.
function MinimizeUI:SetEventHandlers()

    -- Set mouse over processing.
    MinimizeUI.EventFrame:HookScript("OnUpdate", function(self, elapsed, ...)
        MinimizeUI.LastOnUpdate = MinimizeUI.LastOnUpdate + elapsed
        if (MinimizeUI.LastOnUpdate > MinimizeUI.OnUpdateInterval) then
            local framesCount = MinimizeUI:FrameSettingsCount()
            for i = 1, framesCount do
                local frameSettings = MinimizeUI.Frames[i]

                if (frameSettings.EnableMouseOver and frameSettings.Frame) then
                    MinimizeUI:OnUpdate(frameSettings)
                    MinimizeUI.LastOnUpdate = 0
                end
            end
        end
    end)

    -- Register events to the eventFrame
    local eventsCount = MinimizeUI:AllEventsCount()
    for eventsi = 1, eventsCount do
        MinimizeUI.EventFrame:RegisterEvent(MinimizeUI.AllEvents[eventsi])
    end

    MinimizeUI.EventFrame:SetScript("OnEvent", function(self, event, ...)
        -- Do something when a resize event occurs.
        if (Utility:TableContains(MinimizeUI.ResizeEvents, event)) then
            -- we need to make sure the frames are resized as expected.
            MinimizeUI:ResizeFrames()
        elseif (Utility:TableContains(MinimizeUI.MountEvents, event)) then
            -- A change in mounted state; flying, not flying, etc.
            MinimizeUI:SetFlyingAlpha()
        else
            if (Utility:TableContains(MinimizeUI.CombatEvents, event)) then
                -- A combat event has happened.
                MinimizeUI:SetCombatAlpha()
            end

            if (Utility:TableContains(MinimizeUI.NameplateEvents, event)) then
                MinimizeUI:SetNameplateVisibility()
            end
        end
    end)

end

-- Disable scrolling combat text that interferes with visibility of the 
-- frames you need to see.
function MinimizeUI:DisableScrollingCombatText()
    SetCVar("floatingCombatTextCombatDamage", 0)
    -- Turn off floating combat text for healing
    SetCVar("floatingCombatTextCombatHealing", 0)
    -- Turn off auto-attack damage text
    SetCVar("floatingCombatTextCombatDamageAllAutos", 0)
    -- Turn off periodic spell damage (e.g., DoTs)
    SetCVar("floatingCombatTextCombatLogPeriodicSpells", 0)
    -- Turn off aura gains and losses
    SetCVar("floatingCombatTextAuras", 0)

    -- Disable all pet frame combat text.
    SetCVar("petCombatText", 0)

    -- Disable healing text only
    SetCVar("floatingCombatTextPetHealing", "0")

    -- Disable damage text only
    SetCVar("floatingCombatTextPetMeleeDamage", "0")
end

-- Initialize the addon.
-- Set event listeners, etc.
function MinimizeUI:Init()
    print("Disabling scrolling and floating combat text.")
    MinimizeUI:DisableScrollingCombatText()
    
    print("LzbUi MinimizeFrames Setting Event Handlers")
    MinimizeUI:SetEventHandlers()

    -- Resize the frames where we enabled resizing.
    print("LzbUi MinimizeFrames Resizing Frames")
    MinimizeUI:ResizeFrames()

    -- Set initial combat and flying alpha settings.
    print("LzbUi MinimizeFrames setting initial alpha.")
    MinimizeUI:SetCombatAlpha()
    MinimizeUI:SetFlyingAlpha()

    print("LzbUi.MinimizeFrames loaded.")
end