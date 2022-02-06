ZUI_LickAndTickle = LibStub("AceAddon-3.0"):NewAddon("ZUI_LickAndTickle", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("ZUI_LickAndTickle_Locale")
local ZUI_GUI = LibStub("AceGUI-3.0")
local ZUI_LDB = LibStub("LibDataBroker-1.1"):NewDataObject("ZUI_LickAndTickle", {
    type = "data source",
    text = L["ZUI Lick and Tickle"],
    icon = GetItemIcon(5041),
    OnClick = function()
        if (ZUI_GUI.frame:IsVisible())
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
        licked = {},
        tickled = {},
    },
}

function ZUI_LickAndTickle:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("ZUI_LickAndTickleDB", defaults, true)
    icon:Register("ZUI_LickAndTickle", ZUI_LDB, self.db.profile.minimap)
    self.db:ResetDB()
end

function ZUI_LickAndTickle:OnEnable()
    ZUI_LickAndTickle:CreateBtns("tickleFrame", UIParent, "Tickle", "tickle")
    ZUI_LickAndTickle:CreateBtns("lickFrame", tickleFrame, "Lick", "lick")
end

function ZUI_LickAndTickle:OnDisable()
    ZUI_GUI.frame:Hide()
end

function ZUI_LickAndTickle:CreateBtns(frameName, parent, btnText, emote)
    local points = {}
    if (btnText == "Tickle") then points[1] = 100 points[2] = -100 else points[1] = 0 points[2] = -40  end
    ZUI_GUI.frame = CreateFrame("Button", frameName, parent)
    frame = ZUI_GUI.frame
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(0)
    frame:SetSize(64, 20)
    frame:SetPoint("TOPLEFT", points[1], points[2])
    frame:SetScript("OnClick", function() ZUI_LickAndTickle:btnClicked(emote) end)
    
    text = frame:CreateFontString("text", "HIGH")
    text:SetPoint("CENTER")
    text:SetFont("Fonts\\FRIZQT__.TTF", 20, "THINOUTLINE")
    text:SetText(btnText)  
end

function ZUI_LickAndTickle:btnClicked(emote)
    DoEmote(emote)
    local target = GetUnitName("target")

    if (emote == "tickle") then 
        if (#self.db.profile.tickled == 0) then table.insert(self.db.profile.tickled, target) end
        local isInDB = false;
        for i, name in ipairs(self.db.profile.tickled) do
            if (name == target) then isInDB = true end
        end
        if (isInDB == false) then table.insert(self.db.profile.tickled, target) end
        
    else
        if (#self.db.profile.licked == 0) then table.insert(self.db.profile.licked, target) end
        local isInDB = false;
        for i, name in ipairs(self.db.profile.licked) do
            if (name == target) then isInDB = true end
        end
        if (isInDB == false) then table.insert(self.db.profile.licked, target) end
        
    end
end
