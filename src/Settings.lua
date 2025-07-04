local _, AddOn = ...

AddOn.Settings = {}

Settings = AddOn.Settings
Settings.GlobalOptions = {}
Settings.GlobalOptions.NameplateSettings = {}
Settings.GlobalOptions.NameplateSettings.SetHealthbarAlpha = true
Settings.GlobalOptions.NameplateSettings.SetNameAlpha = false

-- "Talking Head Options"
-- "Adjust the size of the talking head."
-- TalkingHead.Scale

-- "Objective Tracker Options"
-- "Make the objective tracker more visible when mousing over it."
-- ObjectiveTracker
-- ObjectiveTracker.Alpha
-- ObjectiveTracker.Alpha.MouseOver

-- "Power Bar Options"
-- "Set the size and alpha of the power bar depending on the mounted state."
-- PowerBar
-- PowerBar.Scale
-- PowerBar.Alpha
-- PowerBar.Alpha.Mounted
-- Powerbar.Alpha.Flying
-- PowerBar.Alpha.MouseOver

-- "Frame Combat Options"
-- "Set the alpha of player frames in different combat states."
-- PlayerFrame
-- PlayerFrame.Alpha
-- PlayerFrame.Alpha.InCombat
-- PlayerFrame.Alpha.InRegen
-- PlayerFrame.Alpha.Mounted
-- PlayerFrame.Alpha.Flying
-- PlayerFrame.Alpha.MouseOver

-- "Frame Combat Options"
-- "Set the alpha of the pet frame in different combat states."
-- PetFrame
-- PetFrame.Alpha
-- PetFrame.Alpha.InCombat
-- PetFrame.Alpha.InRegen
-- PetFrame.Alpha.Mounted
-- PetFrame.Alpha.Flying
-- PetFrame.Alpha.MouseOver

-- "Action Bar Options"
-- "Set the visibility of the different action bars depending on combat or mounted states."
-- ActionBars
-- ActionBars.X.Alpha
-- ActionBars.X.Alpha.InCombat
-- ActionBars.X.Alpha.InRegen
-- ActionBars.X.Alpha.Mounted
-- ActionBars.X.Alpha.Flying
-- ActionBars.X.Alpha.MouseOver

-- "Nameplate Options"
-- "Set the visibility of nameplates dependent on mob hostility and combat states."
-- Nameplate
-- Nameplate.Alpha
-- Nameplate.Alpha.InCombat
-- Nameplate.Alpha.Friendly
-- Nameplate.Alpha.Hostile
-- Nameplate.Alpha.NonCombat
-- Nameplate.Alpha.Target
-- Nameplate.Border
-- Nameplate.Border.Target

-- "Out of Combat Nameplate Options"
-- "Set global nameplate sizes out of combat."
-- Nameplate.Size.Enemy
-- Nameplate.Size.Friendly


-- fini