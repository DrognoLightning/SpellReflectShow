--Create frame, border and position
--[[https://github.com/Ketho/BlizzardInterfaceResources/blob/mainline/Resources/Templates.lua
  ["ResizeCheckButtonBehaviorTemplate"] = {type = "Frame", mixin = "ResizeCheckButtonMixin", inherits = "ResizeLayoutFrame"},
  ["ResizeCheckButtonTemplate"] = {type = "Frame", inherits = "ResizeCheckButtonBehaviorTemplate"},
  ["ResizeLayoutFrame"] = {type = "Frame", mixin = "ResizeLayoutMixin", inherits = "BaseLayoutFrameTemplate"},
  /run local f = CreateFrame("Frame", nil, UIParent, "ObjectiveTrackerUIWidgetBlock"); f:SetSize(100, 100); f:SetPoint("CENTER")
]]
local SRSwindow = CreateFrame("Frame", "SpellReflect Show", UIParent, "BasicFrameTemplateWithInset")
SRSwindow:SetSize(200, 100)
SRSwindow:SetPoint("CENTER")

SRSwindow:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local myText = SRSwindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
myText:SetPoint("CENTER")
myText:SetPoint("BOTTOMRIGHT", SRSwindow, "BOTTOMRIGHT", -5, 5)
myText:SetText("Spell Reflection: ... test")
myText:Show()

-- Create the title text for the frame
local title = SRSwindow:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
title:SetPoint("TOPLEFT", SRSwindow, "TOPLEFT", 5, -5)
title:SetText("Spell Reflect Show")

-- Make the frame resizable
SRSwindow:SetResizable(true)

-- Set the minimum and maximum dimensions for the frame
SRSwindow:SetResizeBounds(100, 50, 800, 600)

-- Add a frame level event handler for the "OnSizeChanged" event
SRSwindow:SetScript("OnSizeChanged", function(self, width, height)
    myText:SetPoint("BOTTOMRIGHT", SRSwindow, "BOTTOMRIGHT", -5, 5)
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