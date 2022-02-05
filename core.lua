ZUI_LickAndTickle = LibStub("AceAddon-3.0"):NewAddon("ZUI_LickAndTickle", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("ZUI_LickAndTickle_Locale")
local ZUI_LDB = LibStub("LibDataBroker-1.1"):NewDataObject("ZUI_LickAndTickle", {
    type = "data source",
    text = L["ZUI Lick and Tickle"],
    icon = GetItemIcon(5041),
    OnClick = function()
        if (frame:IsVisible())
        then
            ZUI_LickAndTickle:OnDisable();
        else
            ZUI_LickAndTickle:OnEnable();
        end
    end,
    OnTooltipShow = function(tooltip)
        tooltip:SetText(L["ZUI Lick and Tickle"])
    end,
})
local icon = LibStub("LibDBIcon-1.0")

local options = {
    name = "ZUI_LickAndTickle",
    handler = ZUI_LickAndTickle,
    type = 'group',
    args = {

    },
}

local defaults = {
    profile = {
        minimap = {
            hide = false,
        },
    },
}

function ZUI_LickAndTickle:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("ZUI_LickAndTickleDB", defaults, true)
    icon:Register("ZUI_LickAndTickle", ZUI_LDB, self.db.profile.minimap)
end

function ZUI_LickAndTickle:OnEnable()
    frame = CreateFrame("Frame", "LickAndTickle", UIParent)
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(0)
    frame:SetSize(64, 10)
    frame:SetPoint("CENTER", 0, 0)

    text = frame:CreateFontString("text", "HIGH")
    text:SetPoint("CENTER")
    text:SetFont("Fonts\\FRIZQT__.TTF", 10, "THINOUTLINE")
    text:SetText("Tickle")
    
   
end

function ZUI_LickAndTickle:OnDisable()
    frame:Hide()
end

-- lick and tickle buttons
-- track if target has been licked or tickled
