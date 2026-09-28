-- AutoAcceptQuests: accepts quests from NPCs automatically, doing only what
-- Blizzard's own Accept button and quest lists do (QuestFrame.lua, GossipFrameShared.lua).
local addonName = ...

local handlers = {}
local tried = {} -- quests picked from this NPC's list, so one that can't be accepted isn't picked forever

-- Opens a quest from an NPC's list once per conversation. Returns true if it did.
local function TryQuest(questID, open, arg)
    if questID and not tried[questID] then
        tried[questID] = true
        open(arg)
        return true
    end
end

-- Quest text is showing: accept it. PvP, item-started and adventure map quests
-- are left to Blizzard, which asks first.
function handlers.QUEST_DETAIL(questStartItemID)
    if QuestIsFromAdventureMap() or (questStartItemID or 0) ~= 0 or QuestFlagsPVP() then return end
    if QuestGetAutoAccept() then AcknowledgeAutoAcceptQuest() else AcceptQuest() end
end

-- Gossip menu: open the next available quest. Accepting it brings the menu back.
-- SelectAvailableQuest takes the questID (the docs say optionID; Blizzard passes questID).
function handlers.GOSSIP_SHOW()
    for _, quest in ipairs(C_GossipInfo.GetAvailableQuests()) do
        if not quest.isIgnored and TryQuest(quest.questID, C_GossipInfo.SelectAvailableQuest, quest.questID) then
            return
        end
    end
end

-- Older quest greeting list: same, by index.
function handlers.QUEST_GREETING()
    for index = 1, GetNumAvailableQuests() do
        if TryQuest(select(5, GetAvailableQuestInfo(index)), SelectAvailableQuest, index) then return end
    end
end

function handlers.GOSSIP_CLOSED(interactionIsContinuing)
    if not interactionIsContinuing then wipe(tried) end
end

function handlers.QUEST_FINISHED()
    wipe(tried)
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(_, event, ...)
    if not AutoAcceptQuestsDisabled then handlers[event](...) end
end)
for event in pairs(handlers) do frame:RegisterEvent(event) end

SLASH_AUTOACCEPTQUESTS1, SLASH_AUTOACCEPTQUESTS2 = "/aaq", "/autoacceptquests"
SlashCmdList.AUTOACCEPTQUESTS = function()
    AutoAcceptQuestsDisabled = not AutoAcceptQuestsDisabled
    print(addonName .. ": " .. (AutoAcceptQuestsDisabled and "off" or "on"))
end
