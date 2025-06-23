local _, AddOn = ...

AddOn.Settings = {}

local C = AddOn.Constants

Settings = AddOn.Settings

-- Nameplates.luca
Settings.NameplateSettings = {}
Settings.NameplateSettings.UpdateRate = 0.05
Settings.NameplateSettings.SetNameAlpha = true
Settings.NameplateSettings.SetHealthbarAlpha = true
Settings.NameplateSettings.SetTextAlpha = false
Settings.NameplateSettings.HideHealthbarBorders = true
Settings.NameplateSettings.PlayerAlpha = C.Alpha.Max
Settings.NameplateSettings.PetAlpha = C.Alpha.Max
Settings.NameplateSettings.TargetAlpha = C.Alpha.Max
Settings.NameplateSettings.InCombatAlpha = C.Alpha.Quarter
Settings.NameplateSettings.IsAttackingAlpha = C.Alpha.Quarter
Settings.NameplateSettings.IsOtherAlpha = C.Alpha.Min

-- Resizer.lua
Settings.ResizerSettings = {}
Settings.ResizerSettings.UpdateRate = 0.05
Settings.ResizerSettings.ScaleTalkingHead = true
Settings.ResizerSettings.TalkingHeadScale = C.Scale.Half
Settings.ResizerSettings.ScalePowerBar = true
Settings.ResizerSettings.PowerBarScale = C.Scale.Half

-- ObjectiveTracker.lua
Settings.ObjectiveTrackerSettings = {}
Settings.ObjectiveTrackerSettings.SetAlphaOnMouseOver = true
Settings.ObjectiveTrackerSettings.Alpha = C.Alpha.Half

-- ActionBars.lua
-- Action bars can be minimized outside of combat.

-- CharacterFrames.lua
-- Player/Pet frames can be minimized outside of combat.

-- FloatingCombatText.lua
-- Floating combat text can be removed.

-- fini