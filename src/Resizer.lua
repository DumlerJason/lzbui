Resizer = {}

Resizer.talkingHeadFrame = CreateFrame("Frame")
Resizer.uiWidgetPowerBar = CreateFrame("Frame")
Resizer.EventFrame = CreateFrame("Frame")

function Resizer:ResizeTalkingHead()
    if TalkingHeadFrame then
        TalkingHeadFrame:SetScale(0.5)  -- Set TalkingHeadFrame to 50% size
    end
end

function Resizer:ResizeUIWidgetPowerBar()
    if UIWidgetPowerBarContainerFrame then
        UIWidgetPowerBarContainerFrame:SetScale(0.5)
    end
end

function Resizer:RegisterEvents()
    -- Create a frame to hook into the talking head frame being shown.
    self.EventFrame:RegisterEvent("TALKINGHEAD_REQUESTED")
    self.EventFrame:RegisterEvent("ON_SHOW")
    self.EventFrame:RegisterEvent("UNIT_POWER_UPDATE")
    self.EventFrame:SetScript("OnEvent", function(self, event, ...)
        if event == "UNIT_POWER_UPDATE" then
            self:ResizeUIWidgetPowerBar()
        elseif event == "TALKINGHEAD_REQUESTED" then
            self:ResizeTalkingHead()
        else
            self:ResizeTalkingHead()
            self:ResizeUIWidgetPowerBar()
        end
    end)
end

function Resizer:Init()
    self:RegisterEvents()

    self:ResizeUIWidgetPowerBar()
    self:ResizeTalkingHead()
end

--return Resizer