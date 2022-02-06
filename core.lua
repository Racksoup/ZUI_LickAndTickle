ZUI_LickAndTickle = LibStub("AceAddon-3.0"):NewAddon("ZUI_LickAndTickle", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("ZUI_LickAndTickle_Locale")
local LAT_GUI = LibStub("AceGUI-3.0")
local ZUI_LDB = LibStub("LibDataBroker-1.1"):NewDataObject("ZUI_LickAndTickle", {
    type = "data source",
    text = L["ZUI Lick and Tickle"],
    icon = GetItemIcon(5041),
    OnClick = function()
        if (LAT_GUI.LickAndTickle:IsVisible())
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
    LAT_GUI.LickAndTickle = CreateFrame("Frame", "lickAndTickle", UIParent)
    LAT_GUI.LickAndTickle:SetSize(200,200)
    LAT_GUI.LickAndTickle:SetPoint("TOPLEFT", 100, -100)
    ZUI_LickAndTickle:CreateBtns("tickleFrame", lickAndTickle, "Tickle", "tickle")
    ZUI_LickAndTickle:CreateBtns("lickFrame", tickleFrame, "Lick", "lick")
end

function ZUI_LickAndTickle:OnEnable()
    LAT_GUI.LickAndTickle:Show()
end

function ZUI_LickAndTickle:OnDisable()
    LAT_GUI.LickAndTickle:Hide()
end

function ZUI_LickAndTickle:CreateBtns(frameName, parent, btnText, emote)
    local points = {}
    if (btnText == "Tickle") then points[1] = 0 points[2] = 0 else points[1] = 0 points[2] = -40  end
    local btnFrame = CreateFrame("Button", frameName, parent)
    
    btnFrame:SetFrameStrata("HIGH")
    btnFrame:SetFrameLevel(0)
    btnFrame:SetSize(64, 20)
    btnFrame:SetPoint("TOPLEFT", points[1], points[2])
    btnFrame:SetScript("OnClick", function() ZUI_LickAndTickle:btnClicked(emote) end)
    
    text = btnFrame:CreateFontString("text", "HIGH")
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


local framex = CreateFrame("Frame")
local timeElapsed = 0
framex:RegisterEvent("NAME_PLATE_UNIT_ADDED")
framex:SetScript("OnEvent", function(self, event, ...)
    if (event == "NAME_PLATE_UNIT_ADDED") then
        local nameplateid = ...
        local nameplateUnitGuid = UnitGUID(nameplateid)
        local unitname = UnitName(nameplateid)
        print(unitname)
    end
end)