-- use this to send debug output to a 'Debug' chat frame.

ChatFrames = {}

-- Set this while doing development.
ChatFrames.DebugChatFrame = ChatFrame6

-- Print out a list of chat frames (does not print titles)
function ChatFrames:PrintChatFrames()
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        print("Chat Frame " .. i .. ": " .. chatFrame:GetName())
    end
end

-- This only works on my profile in WoW.
function ChatFrames:PrintDebug(msg)
    if self.DebugChatFrame then
        self.DebugChatFrame:AddMessage(msg)
    end
end

--return ChatFrames