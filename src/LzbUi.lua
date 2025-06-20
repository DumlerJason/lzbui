local _, AddOn = ...
_G.AddOn = AddOn

print("In LzbUi.lua ", AddOn)

AddOn.Nameplates:Init()
AddOn.Resizer:Init()

-- Print a message to indicate the addon has loaded
print("LzbUi loaded: Nameplates will be managed and UI elements will be minimized.")