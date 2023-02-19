local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local myText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
myText:SetPoint("CENTER")

local SRSwindow = CreateFrame("Frame", "SpellReflect Show", UIParent)
SRSwindow:SetSize(200, 100)
SRSwindow:SetPoint("CENTER")

-- create a close button to hide the frame
local closeButton = CreateFrame("Button", nil, SRSwindow, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", SRSwindow, "TOPRIGHT", -5, -5)

-- create a slash command to show/hide the frame
SLASH_SRS1 = "/srs"
SlashCmdList["SRS"] = function()
    if SRSwindow:IsShown() then
        SRSwindow:Hide()
    else
        SRSwindow:Show()
    end
end

-- make the frame moveable
SRSwindow:SetMovable(true)
SRSwindow:EnableMouse(true)
SRSwindow:SetScript("OnMouseDown", function()
    SRSwindow:StartMoving()
end)
SRSwindow:SetScript("OnMouseUp", function()
    SRSwindow:StopMovingOrSizing()
end)

-- capture the spell reflect
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, eventType, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID, spellName, _, extraSpellID, extraSpellName = ...
        if eventType == "SPELL_CAST_SUCCESS" and sourceGUID == UnitGUID("player") and spellID == 23920 then
            myText:SetText("Spell Reflection: "..extraSpellName) -- Display the name of the spell being reflected
            myText:Show()
        end
    end
end)