Resizer = {}

Resizer.EventFrame = CreateFrame("Frame")

Resizer.TalkingHeadScale = 0.5
Resize.PowerBarScale = 0.5

function Resizer:ResizeTalkingHead()
    if TalkingHeadFrame and TalkingHeadFrame:IsShown() then
        TalkingHeadFrame:SetScale(self.TalkingHeadScale)  -- Set TalkingHeadFrame to 50% size
    end
end

function Resizer:ResizeUIWidgetPowerBar()
    if UIWidgetPowerBarContainerFrame and UIWidgetPowerBarContainerFrame:IsShown() then
        UIWidgetPowerBarContainerFrame:SetScale(self.PowerBarScale)
    end
end

function Resizer:RegisterEvents()
    -- Create a frame to hook into the talking head frame being shown.
    self.EventFrame:RegisterEvent("TALKINGHEAD_REQUESTED")
    self.EventFrame:RegisterEvent("UNIT_POWER_UPDATE")
    self.EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    
    self.EventFrame:SetScript("OnEvent", function(_, event, unit, ...)
        if event == "UNIT_POWER_UPDATE" and unit == "player" then
            self:ResizeUIWidgetPowerBar()
        elseif event == "TALKINGHEAD_REQUESTED" then
            self:ResizeTalkingHead()
        elseif event == "PLAYER_ENTERING_WORLD" then
            self:ResizeUIWidgetPowerBar()
            self:ResizeTalkingHead()
        end
    end)
end

function Resizer:Init()
    self:RegisterEvents()
end

--return Resizer