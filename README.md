# lzbui
World of Warcraft AddOn to do the following:
 * Minimize the display of non-target enemy nameplates.
 * Minimize the HUGE talking heads frame.
 * Minimize the 'Power Bar' frame to make it easier to fly.

TODO (possible):
 * Do something with the mini-map alpha?
 * Add menu options to the GUI.
 * Add button somewhere that opens the Lua Errors Window.

2025-05-11 - started playing again so updated the UI version in the TOC.
 * Scaling and width of nameplates cannot be changed once combat starts; removed that functionality.
 * MinimizeUI.lua from earlier version kept as a reference for possible functionality changes.

Need help viewing Lua Errors?  This will open the Lua Errors Window
WARNING; Having this as a macro can result in a bazillion script errors. Don't keep it on your button bar.
/run UIParentLoadAddOn("Blizzard_DebugTools"); ScriptErrorsFrame:SetParent(UIParent); ScriptErrorsFrame:SetPoint("CENTER"); ScriptErrorsFrame:Show()

2025-05-14
 * Adding gui.
 * Adding features:
   - Setting nameplate alpha depending on combat state.
   - Setting UI element alpha depending on combat state; Player Frame, Pet Frame, Button Bars, Power Bar.
   - Setting nameplate healthbar color depending on combat state.
   - Option to remove healthbar borders.
 * Current features:
   - Set the size of UI elements that cannot be managed using 'Edit' mode.

