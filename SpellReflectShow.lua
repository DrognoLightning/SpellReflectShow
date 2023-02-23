local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

--Create frame and position
local SRSwindow = CreateFrame("Frame", "SpellReflect Show", UIParent)
SRSwindow:SetSize(200, 100)
SRSwindow:SetPoint("CENTER")

local myText = SRSwindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
myText:SetPoint("CENTER")

-- Create the title text for the frame
local title = SRSwindow:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
title:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -5)
title:SetText("Spell Reflect Show")

-- create a close button to hide the frame
local closeButton = CreateFrame("Button", nil, SRSwindow, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", SRSwindow, "TOPRIGHT", -5, -5)

-- Make the frame resizable
SRSwindow:SetResizable(true)

-- Set the minimum and maximum dimensions for the frame
SRSwindow:SetMinResize(100, 50)
SRSwindow:SetMaxResize(800, 600)

-- Add a frame level event handler for the "OnSizeChanged" event
SRSwindow:SetScript("OnSizeChanged", function(self, width, height)
    myText:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 5)
end)

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
SRSwindow:SetScript("OnEvent", function(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, eventType, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID, spellName, _, extraSpellID, extraSpellName = ...
        if eventType == "SPELL_CAST_SUCCESS" and sourceGUID == UnitGUID("player") and spellID == 23920 then
            myText:SetText("Spell Reflection: "..extraSpellName) -- Display the name of the spell being reflected
            myText:Show()
        end
    end
end)