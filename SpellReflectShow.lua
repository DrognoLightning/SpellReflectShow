--Create frame, border and position
--[[https://github.com/Ketho/BlizzardInterfaceResources/blob/mainline/Resources/Templates.lua
  ["ResizeCheckButtonBehaviorTemplate"] = {type = "Frame", mixin = "ResizeCheckButtonMixin", inherits = "ResizeLayoutFrame"},
  ["ResizeCheckButtonTemplate"] = {type = "Frame", inherits = "ResizeCheckButtonBehaviorTemplate"},
  ["ResizeLayoutFrame"] = {type = "Frame", mixin = "ResizeLayoutMixin", inherits = "BaseLayoutFrameTemplate"},
  /run local f = CreateFrame("Frame", nil, UIParent, "ObjectiveTrackerUIWidgetBlock"); f:SetSize(100, 100); f:SetPoint("CENTER")
  misc_rnrredxbutton
]]
local SRSwindow = CreateFrame("Frame", "SpellReflect Show", UIParent, "BasicFrameTemplateWithInset")
SRSwindow:SetSize(200, 100)
SRSwindow:SetPoint("CENTER")

-- initialise text
local myText = SRSwindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
myText:SetPoint("TOPLEFT", SRSwindow, "TOPLEFT", 5, -20)
--myText:SetText("Spell Reflection: ... test")
myText:SetText(SRlog)
myText:Show()

if not SRlog then
    SRlog = "Go reflect some spells!"
    myText:SetText(SRlog)
end


-- Create child frame for move frame
local moveArea = CreateFrame("Button", nil, SRSwindow)
moveArea:SetPoint("TOPLEFT", SRSwindow, "TOPLEFT", 0, 0)
moveArea:SetSize(100, 20)
moveArea:EnableMouse(true)
moveArea:SetScript("OnMouseDown", function()
    SRSwindow:SetMovable(true)
    SRSwindow:StartMoving()
end)
moveArea:SetScript("OnMouseUp", function()
    SRSwindow:SetMovable(false)
    SRSwindow:StopMovingOrSizing()
end)

-- Create child frame for resize
local resizeArea = CreateFrame("Button", nil, SRSwindow)
resizeArea:SetPoint("BOTTOMRIGHT", SRSwindow, "BOTTOMRIGHT", 0, 0)
resizeArea:SetSize(10, 10)
resizeArea:EnableMouse(true)
resizeArea:RegisterForDrag("LeftButton")
SRSwindow:SetResizeBounds(200, 100, 400, 300)
resizeArea:SetScript("OnDragStart", function()
    SRSwindow:SetResizable(true)
	SRSwindow:StartSizing()
	SRSwindow.isMoving = true
	SRSwindow.hasMoved = false
end)
resizeArea:SetScript("OnDragStop", function()
    SRSwindow:SetResizable(false)
	SRSwindow:StopMovingOrSizing()
	SRSwindow.isMoving = false
	SRSwindow.hasMoved = true
end)

-- Create child frame for clear text
local clearTextIcon = CreateFrame("Button", nil, SRSwindow)
clearTextIcon:SetPoint("TOPRIGHT", SRSwindow, "TOPRIGHT", -40, -4)
clearTextIcon:SetSize(16, 16)
clearTextIcon:EnableMouse(true)
clearTextIcon:SetScript("OnClick", function()
    SRlog = "Cleared\nGo reflect some spells!"
    myText:SetText(SRlog)
end)
-- create a texture frame
local clearIcon = SRSwindow:CreateTexture(nil, "OVERLAY")
clearIcon:SetTexture("Interface\\Icons\\misc_rnrredxbutton")
clearIcon:SetSize(16, 16)
-- position the texture frame on the child frame
clearIcon:SetPoint("CENTER", clearTextIcon, "CENTER", 0, 0)
-- Create a tooltip frame
local clearIconTooltipFrame = CreateFrame("GameTooltip", "MyTooltip", UIParent, "GameTooltipTemplate")
clearIconTooltipFrame:SetOwner(clearTextIcon, "ANCHOR_RIGHT")
-- Set the tooltip text -- doesn't follow when dragged.
clearTextIcon:SetScript("OnEnter", function(self)
    if not ShowTooltipFrame then
        clearIconTooltipFrame:SetOwner(clearTextIcon, "ANCHOR_RIGHT")
        clearIconTooltipFrame:SetText("Clear logs")
        clearIconTooltipFrame:Show()
        ShowTooltipFrame = true
    end
end)
-- Hide the tooltip frame
clearTextIcon:SetScript("OnLeave", function(self)
    clearIconTooltipFrame:Hide()
    ShowTooltipFrame = false
end)

SRSwindow:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

-- Create the title text for the frame
local title = SRSwindow:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
title:SetPoint("TOPLEFT", SRSwindow, "TOPLEFT", 5, -5)
title:SetText("Spell Reflect Show")

-- Add a frame level event handler for the "OnSizeChanged" event
SRSwindow:SetScript("OnSizeChanged", function(self, width, height)
    myText:SetPoint("TOPLEFT", SRSwindow, "TOPLEFT", 5, -30)
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

-- capture the spell reflect
SRSwindow:SetScript("OnEvent", function(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, eventType, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID, spellName, _, extraSpellID, extraSpellName = ...
        if eventType == "SPELL_CAST_SUCCESS" and sourceGUID == UnitGUID("player") and spellID == 23920 then
            SRlog = "Spell Reflection: "..extraSpellName
            myText:SetText(SRlog)
            myText:Show()
        end
    end
end)