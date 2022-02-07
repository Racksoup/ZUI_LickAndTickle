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
            SetCVar("nameplateShowFriends", 1)
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
    realm = {
        minimap = {
            hide = false,
        },
        licked = {},
        tickled = {},
    },
}

SLASH_RESETDB1 = "/resetdb"
SLASH_RESETDB2 = "/redb"
SlashCmdList["RESETDB"] = function()
    ZUI_LickAndTickle.db:ResetDB()
    ZUI_LickAndTickle:OnDisable()
    ZUI_LickAndTickle:OnEnable()
end 

function ZUI_LickAndTickle:OnInitialize()
    LAT_GUI.backdropTable = {}
    LAT_GUI.plateTable = {}
    self.db = LibStub("AceDB-3.0"):New("ZUI_LickAndTickleDB", defaults, true)
    icon:Register("ZUI_LickAndTickle", ZUI_LDB, self.db.realm.minimap)
    LAT_GUI.LickAndTickle = CreateFrame("Frame", "lickAndTickle", UIParent)
    LAT_GUI.LickAndTickle:SetSize(200,200)
    LAT_GUI.LickAndTickle:SetPoint("TOPLEFT", 100, -100)
    ZUI_LickAndTickle:CreateBtns("tickleFrame", lickAndTickle, L["Tickle"], "tickle")
    ZUI_LickAndTickle:CreateBtns("lickFrame", tickleFrame, L["Lick"], "lick")
    ZUI_LickAndTickle:CreateNamePlateUI()
    LAT_GUI.LickAndTickle:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    LAT_GUI.LickAndTickle:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    LAT_GUI.LickAndTickle:SetScript("OnEvent", function(self, event, ...)
        if (event == "NAME_PLATE_UNIT_ADDED") then
            local nameplateid = ...
            if (UnitGUID(nameplateid) ~= UnitGUID("Player"))then
            ZUI_LickAndTickle:NamePlateAdded(nameplateid) 
        end
        end
        if (event == "NAME_PLATE_UNIT_REMOVED") then
            local nameplateid = ...
            ZUI_LickAndTickle:NamePlateRemoved(nameplateid)    
        end
    end)
    --self.db:ResetDB()
end

function ZUI_LickAndTickle:OnEnable()
    LAT_GUI.LickAndTickle:Show()
    for i,item in ipairs(LAT_GUI.backdropTable) do
        item:Show()
    end
end

function ZUI_LickAndTickle:OnDisable()
    LAT_GUI.LickAndTickle:Hide()
    for i,item in ipairs(LAT_GUI.backdropTable) do
        item:Hide()
    end
end

function ZUI_LickAndTickle:NamePlateAdded(nameplateid)
    
    local unitname = UnitName(nameplateid)
    local unitGuid = UnitGUID(nameplateid)
    local namePlate
    if (C_NamePlate.GetNamePlateForUnit(nameplateid).unitFrame) then
        namePlate = C_NamePlate.GetNamePlateForUnit(nameplateid).unitFrame
    else
        namePlate = C_NamePlate.GetNamePlateForUnit(nameplateid).UnitFrame
    end
    local locClass, engClass, locRace, engRace, gender, name, server = GetPlayerInfoByGUID(unitGuid)
    local inLickDB = false
    local inTickleDB = false
    local inAnyDB = true
    namePlate:Show()

    for i, item in ipairs(ZUI_LickAndTickle.db.realm.licked) do
        if (item == unitname) then inLickDB = true end
    end
    for i, item in ipairs(ZUI_LickAndTickle.db.realm.tickled) do
        if (item == unitname) then inTickleDB = true end
    end
    if (inLickDB == false and inTickleDB == false) then
        inAnyDB = false
    else
        inAnyDB = true
    end

    if (inAnyDB == false and locClass) then ZUI_LickAndTickle:CreateNamePlateUI("Interface\\AddOns\\ZUI_LickAndTickle\\images\\RedBall.blp", namePlate, nameplateid, unitGuid, unitname) 
    elseif (inAnyDB == true and inLickDB == false and locClass) then  ZUI_LickAndTickle:CreateNamePlateUI("Interface\\AddOns\\ZUI_LickAndTickle\\images\\BlueBall.blp", namePlate, nameplateid, unitGuid, unitname) 
    elseif (inAnyDB == true and inTickleDB == false and locClass) then ZUI_LickAndTickle:CreateNamePlateUI("Interface\\AddOns\\ZUI_LickAndTickle\\images\\YellowBall.blp", namePlate, nameplateid, unitGuid, unitname) 
    end
end

function ZUI_LickAndTickle:NamePlateRemoved(nameplateid)
    for i, item in ipairs(LAT_GUI.backdropTable) do
        if (nameplateid == item.num) then table.remove(LAT_GUI.backdropTable, i) item:Hide() end
    end
end

function ZUI_LickAndTickle:CreateNamePlateUI(bgFile, namePlate, nameplateid, unitGuid, unitname)
    
    local backdropInfo =
    {
        bgFile = bgFile,
        tile = true,
        tileEdge = true,
        tileSize = 15,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    }

    local frame = CreateFrame("Frame", nil, namePlate, "BackdropTemplate")
    frame.unitname = unitname
    frame.num = nameplateid
    frame.Guid = unitGuid
    frame.nameplateid = nameplateid
    frame.bgFile = bgFile
    frame:SetBackdrop(backdropInfo)
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(0)
    frame:SetSize(15, 15)
    frame:SetPoint("CENTER", -70, -10)
    if(frame.unitname) then
        table.insert(LAT_GUI.backdropTable, frame)
    end
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
    for i, v in ipairs(LAT_GUI.backdropTable) do
        print(i, "=", v)
    end

    DoEmote(emote)
    local target = GetUnitName("target")
    local unitGuid = UnitGUID("target")
    local locClass, engClass, locRace, engRace, gender, name, server = GetPlayerInfoByGUID(unitGuid)

    if (emote == "tickle" and locClass) then 
        if (#self.db.realm.tickled == 0) then table.insert(self.db.realm.tickled, target) end
        local isInDB = false;
        for i, name in ipairs(self.db.realm.tickled) do
            if (name == target) then isInDB = true end
        end
        if (isInDB == false) then 
            table.insert(self.db.realm.tickled, target) 
        end
    elseif (emote == "lick" and locClass) then
        if (#self.db.realm.licked == 0) then table.insert(self.db.realm.licked, target) end
        local isInDB = false;
        for i, name in ipairs(self.db.realm.licked) do
            if (name == target) then isInDB = true end
        end
        if (isInDB == false) then 
            table.insert(self.db.realm.licked, target) 
        end
    end
    
    for i, item in pairs(LAT_GUI.backdropTable) do
        if (item.unitname == target) then 
            table.remove(LAT_GUI.backdropTable, i) 
            item:Hide()
            local namePlate
            if (C_NamePlate.GetNamePlateForUnit(item.nameplateid).unitFrame) then
                namePlate = C_NamePlate.GetNamePlateForUnit(item.nameplateid).unitFrame
            else
                namePlate = C_NamePlate.GetNamePlateForUnit(item.nameplateid).UnitFrame
            end
            if (item.bgFile == "Interface\\AddOns\\ZUI_LickAndTickle\\images\\RedBall.blp" and namePlate) then 
                ZUI_LickAndTickle:NamePlateAdded(item.nameplateid)
            end
            return
        end
    end

end


-- chat command text on minimap button
-- reposition nameplate-Icon for plater addon

-- right click minimap for emote input frame
-- enable user to enter any one emote to replace lick&tickle