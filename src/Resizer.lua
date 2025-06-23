local _, AddOn = ...

AddOn.Resizer = {}
local Resizer = AddOn.Resizer
local S = AddOn.Settings.ResizerSettings

Resizer.EventFrame = {}
Resizer.LastUpdateTime = 0

function Resizer:ResizeTalkingHead()
    if S.ScaleTalkingHead then
        if TalkingHeadFrame and TalkingHeadFrame:IsShown() then
            TalkingHeadFrame:SetScale(S.TalkingHeadScale)
        end
    end
end

function Resizer:ResizeUIWidgetPowerBar()
    if S.ScalePowerBar then
        if UIWidgetPowerBarContainerFrame and UIWidgetPowerBarContainerFrame:IsShown() then
            UIWidgetPowerBarContainerFrame:SetScale(S.PowerBarScale)
        end
    end
end

function Resizer:ResizeElements(elapsed)
    self.LastUpdateTime = self.LastUpdateTime + elapsed
    if self.LastUpdateTime < S.UpdateRate then
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