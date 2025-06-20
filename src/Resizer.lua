local _, AddOn = ...

AddOn.Resizer = {}
local Resizer = AddOn.Resizer
local C = AddOn.Constants

Resizer.EventFrame = {}
Resizer.UpdateRate = 0.05
Resizer.LastUpdateTime = 0

function Resizer:ResizeTalkingHead()
    if TalkingHeadFrame and TalkingHeadFrame:IsShown() then
        TalkingHeadFrame:SetScale(C.Scale.Half)  -- Set TalkingHeadFrame to 50% size
    end
end

function Resizer:ResizeUIWidgetPowerBar()
    if UIWidgetPowerBarContainerFrame and UIWidgetPowerBarContainerFrame:IsShown() then
        UIWidgetPowerBarContainerFrame:SetScale(C.Scale.Half)
    end
end

function Resizer:ResizeElements(elapsed)
    self.LastUpdateTime = self.LastUpdateTime + elapsed
    if self.LastUpdateTime < self.UpdateRate then
        return
    end

    self:ResizeTalkingHead()
    self:ResizeUIWidgetPowerBar()
    self.LastUpdateTime = 0
end

function Resizer:Init()
    self.EventFrame = CreateFrame("Frame")
    self.EventFrame:SetScript("OnUpdate", function(_, elapsed)
        self:ResizeElements(elapsed)
    end)

end

--return Resizer