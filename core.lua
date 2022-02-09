ZUI_LickAndTickle = LibStub("AceAddon-3.0"):NewAddon("ZUI_LickAndTickle", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("ZUI_LickAndTickle_Locale")
local LAT_GUI = LibStub("AceGUI-3.0")
local ZUI_LDB = LibStub("LibDataBroker-1.1"):NewDataObject("ZUI_LickAndTickle", {
    type = "data source",
    text = L["ZUI Lick and Tickle"],
    icon = GetItemIcon(5041),
    OnClick = function(self, button)
        if (button == "RightButton") then
            ZUI_LickAndTickle:InputFrame()
        end
        if (button == "LeftButton" and LAT_GUI.LickAndTickle:IsVisible()) then
            ZUI_LickAndTickle.db.profile.showOnFirstLoad = false
            ZUI_LickAndTickle:OnDisable();
        elseif(button == "LeftButton") then
            ZUI_LickAndTickle.db.profile.showOnFirstLoad = true
            ZUI_LickAndTickle:OnEnable();
            SetCVar("nameplateShowFriends", 1)
        end
    end,
    OnTooltipShow = function(tooltip)
        tooltip:AddLine(L["ZUI Lick and Tickle"], 0, .9, 1)
        tooltip:AddLine(L["|cFFCFCFCFLeft click|r: Show/Hide UI"])
        tooltip:AddLine(L["|cFFCFCFCFRight click|r: Change Emote"])
        tooltip:AddLine(L["|cFFCFCFCF/lat-reset or /latre to reset|r"])
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
        other = {},
    },
    profile = {
        showOnFirstLoad = false,
    },
}

SLASH_RESETDB1 = "/lat-reset"
SLASH_RESETDB2 = "/latre"
SlashCmdList["RESETDB"] = function()
    SetCVar("nameplateShowFriends", 0)
    ZUI_LickAndTickle:ReShowNameplates()
    ZUI_LickAndTickle.db:ResetDB()
    ZUI_LickAndTickle:OnDisable()
    ZUI_LickAndTickle:OnEnable()
end 

function ZUI_LickAndTickle:OnInitialize()
    LAT_GUI.buttonTable = {}
    LAT_GUI.iconTable = {}
    LAT_GUI.plateTable = {}
    ZUI_LickAndTickle.firstLoad = true
    self.db = LibStub("AceDB-3.0"):New("ZUI_LickAndTickleDB", defaults, true)
    icon:Register("ZUI_LickAndTickle", ZUI_LDB, self.db.realm.minimap)
    LAT_GUI.LickAndTickle = CreateFrame("Frame", "lickAndTickle", UIParent)
    LAT_GUI.LickAndTickle:SetSize(80,80)
    LAT_GUI.LickAndTickle:SetPoint("TOPLEFT", 80, -80)
    LAT_GUI.LickAndTickle:SetMovable(true)
    LAT_GUI.LickAndTickle:EnableMouse(true)
    LAT_GUI.LickAndTickle:RegisterForDrag("LeftButton")
    LAT_GUI.LickAndTickle:SetScript("OnDragStart", function()
        if(IsShiftKeyDown() == true)then 
            LAT_GUI.LickAndTickle:StartMoving()
        end
    end)
    LAT_GUI.LickAndTickle:SetScript("OnDragStop", LAT_GUI.LickAndTickle.StopMovingOrSizing)
    ZUI_LickAndTickle:CreateBtns("tickleFrame", lickAndTickle, L["Tickle"], "tickle")
    ZUI_LickAndTickle:CreateBtns("lickFrame", lickAndTickle, L["Lick"], "lick")
    ZUI_LickAndTickle:CreateBtns("otherFrame", lickAndTickle, self.db.realm.otherText, self.db.realm.otherEmote)
    ZUI_LickAndTickle:CreateNamePlateUI()
    --self.db:ResetDB()
end

function ZUI_LickAndTickle:OnEnable()
    LAT_GUI.LickAndTickle:Show()
    for i,item in ipairs(LAT_GUI.iconTable) do
        item:Show()
    end
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

    if (ZUI_LickAndTickle.db.profile.showOnFirstLoad == false and ZUI_LickAndTickle.firstLoad == true) then
        print("hit")
        ZUI_LickAndTickle:OnDisable()
    end
    ZUI_LickAndTickle.firstLoad = false
end

function ZUI_LickAndTickle:OnDisable()
    LAT_GUI.LickAndTickle:Hide()
    for i,item in ipairs(LAT_GUI.iconTable) do
        item:Hide()
    end
    LAT_GUI.LickAndTickle:UnregisterEvent("NAME_PLATE_UNIT_ADDED")
    LAT_GUI.LickAndTickle:UnregisterEvent("NAME_PLATE_UNIT_REMOVED")
end

function ZUI_LickAndTickle:NamePlateAdded(nameplateid)
    -- hides any old icons
    -- for i, v in ipairs(LAT_GUI.iconTable) do
    --     if (nameplateid == v.nameplateid) then v:Hide() end
    -- end

    -- if the user has selected a custom emote. set profile2 true. hide and remove lick and tickle buttons
    if (ZUI_LickAndTickle.db.realm.otherEmote) then
        LAT_GUI.profile2 = true
        for i, v in pairs(LAT_GUI.buttonTable) do
            if (v.btnText ~= ZUI_LickAndTickle.db.realm.otherText) then
                v:Hide()
               table.remove(LAT_GUI.buttonTable, i) 
            end
        end
    -- if the user hasent selected a custom emote. set profile2 false. hide and remove wrong buttons
    else
        LAT_GUI.profile2 = false
        for i, v in pairs(LAT_GUI.buttonTable) do
            if (v.btnText ~= "Lick" and v.btnText ~= "Tickle") then
                v:Hide() 
                table.remove(LAT_GUI.buttonTable, i)
            end
        end
    end
    
    local unitname = UnitName(nameplateid)
    local unitGuid = UnitGUID(nameplateid)
    local isPlaterAddon = false
    local namePlate
    if (C_NamePlate.GetNamePlateForUnit(nameplateid).unitFrame) then
        -- plater uses lowercase 'u' for their unitFrame
        namePlate = C_NamePlate.GetNamePlateForUnit(nameplateid).unitFrame
        isPlaterAddon = true
    else
        namePlate = C_NamePlate.GetNamePlateForUnit(nameplateid).UnitFrame
        isPlaterAddon = false
    end
    local locClass, engClass, locRace, engRace, gender, name, server = GetPlayerInfoByGUID(unitGuid)
    local faction
    local inLickDB = false
    local inTickleDB = false
    local inOtherDB = false
    local inEitherDB = true

    -- check if player is same faction as new nameplate unit
    if (UnitFactionGroup(nameplateid) == UnitFactionGroup("Player")) then
    namePlate:Show()

    if(LAT_GUI.profile2 == true) then inLickDB = true inTickleDB = true end

    for i, item in ipairs(ZUI_LickAndTickle.db.realm.licked) do
        if (item == unitname) then inLickDB = true end
    end
    for i, item in ipairs(ZUI_LickAndTickle.db.realm.tickled) do
        if (item == unitname) then inTickleDB = true end
    end
    for i, item in ipairs(ZUI_LickAndTickle.db.realm.other) do
        if (item == unitname) then inOtherDB = true end
    end
    if (inLickDB == false and inTickleDB == false) then
        inEitherDB = false
    else
        inEitherDB = true
    end

    if (inEitherDB == false and LAT_GUI.profile2 == false and locClass) then ZUI_LickAndTickle:CreateNamePlateUI("Interface\\AddOns\\ZUI_LickAndTickle\\images\\RedBall.blp", namePlate, nameplateid, unitGuid, unitname, isPlaterAddon) 
    elseif (inEitherDB == true and inLickDB == false and locClass) then  ZUI_LickAndTickle:CreateNamePlateUI("Interface\\AddOns\\ZUI_LickAndTickle\\images\\BlueBall.blp", namePlate, nameplateid, unitGuid, unitname, isPlaterAddon) 
    elseif (inEitherDB == true and inTickleDB == false and locClass) then ZUI_LickAndTickle:CreateNamePlateUI("Interface\\AddOns\\ZUI_LickAndTickle\\images\\YellowBall.blp", namePlate, nameplateid, unitGuid, unitname, isPlaterAddon) 
    elseif (LAT_GUI.profile2 == true and inOtherDB == false and locClass) then ZUI_LickAndTickle:CreateNamePlateUI("Interface\\AddOns\\ZUI_LickAndTickle\\images\\YellowBall.blp", namePlate, nameplateid, unitGuid, unitname, isPlaterAddon) 
    end
end
end

function ZUI_LickAndTickle:NamePlateRemoved(nameplateid)
    for i, item in ipairs(LAT_GUI.iconTable) do
        if (nameplateid == item.nameplateid) then table.remove(LAT_GUI.iconTable, i) item:Hide() end
    end
end

function ZUI_LickAndTickle:CreateNamePlateUI(bgFile, namePlate, nameplateid, unitGuid, unitname, isPlaterAddon)
    
    local backdropInfo =
    {
        bgFile = bgFile,
        tile = true,
        tileEdge = true,
        tileSize = 20,
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    }

    local frame = CreateFrame("Frame", nil, namePlate, "BackdropTemplate")
    frame.unitname = unitname
    frame.nameplateid = nameplateid
    frame.Guid = unitGuid
    frame.nameplateid = nameplateid
    frame.bgFile = bgFile
    frame:SetBackdrop(backdropInfo)
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(0)
    frame:SetSize(18, 18)
    if(isPlaterAddon) then frame:SetPoint("CENTER", -35, 11) else frame:SetPoint("CENTER", -70, -7) end
    if(frame.unitname) then
        table.insert(LAT_GUI.iconTable, frame)
    end
end

function ZUI_LickAndTickle:CreateBtns(frameName, parent, btnText, emote)
    local points = {0, 16}


    if (btnText == "Lick") then points[1] = 0 points[2] = -16  end
    btnFrame = CreateFrame("Button", frameName, parent)
    btnFrame.btnText = btnText
    btnFrame.emote = emote
    btnFrame:SetFrameStrata("HIGH")
    btnFrame:SetFrameLevel(0)
    btnFrame:SetSize(64, 20)
    btnFrame:SetPoint("CENTER", points[1], points[2])
    btnFrame:SetScript("OnClick", function() ZUI_LickAndTickle:btnClicked(emote) end)
    btnFrame:Show()
    
    text = btnFrame:CreateFontString("text", "HIGH")
    text:SetPoint("CENTER")
    text:SetFont("Fonts\\FRIZQT__.TTF", 20, "THINOUTLINE")
    text:SetText(btnText)  

    table.insert(LAT_GUI.buttonTable, btnFrame)
end

function ZUI_LickAndTickle:btnClicked(emote)
    DoEmote(emote)
    local target = GetUnitName("target")
    if (target) then 
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
        elseif (locClass) then
            local isInEmotes = false
            for i, v in pairs(ZUI_LickAndTickle.emotes) do
                for j, k in ipairs(v) do
                if (emote == k.emote) then isInEmotes = true end
                end
            end
            if (isInEmotes) then 
                if (#self.db.realm.other == 0) then table.insert(self.db.realm.other, target) end
                local isInDB = false;
                for i, name in ipairs(self.db.realm.other) do
                    if (name == target) then isInDB = true end
                end
                if (isInDB == false) then 
                    table.insert(self.db.realm.other, target) 
                end
            end
        end
        
        for i, item in pairs(LAT_GUI.iconTable) do
            if (item.unitname == target) then 
                table.remove(LAT_GUI.iconTable, i) 
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
    
end

function ZUI_LickAndTickle:InputFrame()
    local bgInfo = {bgFile = "Interface\\AddOns\\ZUI_LickAndTickle\\images\\LAT_GUIInputFrameBackdrop.blp", edgeFile = "Interface/Tooltips/UI-Tooltip-Border",  tile = true, tileEdge = true, tileSize = 232, insets = { left = 10, right = 10, top = 10, bottom = 10 }}
    if (LAT_GUI.inputFrame == nil or LAT_GUI.inputFrame:IsVisible() == false) then
        LAT_GUI.inputFrame = CreateFrame("Frame", "inputFrame", UIParent, "BackdropTemplate")
        local inputFrame = LAT_GUI.inputFrame
        inputFrame:SetPoint("TOP", 0, -70)
        inputFrame:SetWidth(270)
        inputFrame:SetHeight(92)
        inputFrame:SetBackdrop(bgInfo)
        inputFrame:SetBackdropColor(1,1,1,0.3)
        LAT_GUI.inputTextFrame = inputFrame:CreateFontString("text", "HIGH")
        local inputT = LAT_GUI.inputTextFrame
        inputT:SetPoint("TOP", 0, -14)
        inputT:SetFont("Fonts\\FRIZQT__.TTF", 20, "THINOUTLINE")
        inputT:SetText(L["Enter Other Emote"])  
        LAT_GUI.editbox = CreateFrame("EditBox", "myeditbox", inputFrame, "InputBoxTemplate")
        local editbox = LAT_GUI.editbox
        editbox:SetPoint("CENTER", 0, -2)
        editbox:SetWidth(200)
        editbox:SetHeight(10)
        editbox:SetScript("OnKeyDown", function(self, event, ...)
            ZUI_LickAndTickle:InputEntered(self, event, ...)
        end)
        LAT_GUI.swapBtn = CreateFrame("Button", "swapbutton", inputFrame, "UIPanelButtonTemplate")
        local swapBtn = LAT_GUI.swapBtn
        swapBtn:SetPoint("BOTTOM", -50, 14)
        swapBtn:SetText("Lick&Tickle")
        swapBtn:SetWidth(100)
        swapBtn:SetHeight(18)
        swapBtn:SetScript("OnClick", function(self, button, down) ZUI_LickAndTickle.SwapBtnPressed(self, button, down) end) 
        LAT_GUI.enterBtn = CreateFrame("Button", "enterbutton", inputFrame, "UIPanelButtonTemplate")
        enterBtn = LAT_GUI.enterBtn
        enterBtn:SetPoint("BOTTOM", 50, 14)
        enterBtn:SetText("Enter")
        enterBtn:SetWidth(100)
        enterBtn:SetHeight(18)
        enterBtn:SetScript("OnClick", function(self, button, down) ZUI_LickAndTickle.EnterBtnPressed(self, button, down)  end)
    end
end

function ZUI_LickAndTickle:InputEntered(self, event, ...)
    LAT_GUI.inputText = self:GetText() 
    if(event == "ENTER") then 
        ZUI_LickAndTickle:ReShowNameplates()
        self:ClearFocus() 
        self:GetParent():Hide()

        local oldEmote
        local notFound = true
        if (notFound) then
            for i, v in pairs(ZUI_LickAndTickle.emotes.anim) do
                if(string.lower(v.text) == string.lower(LAT_GUI.inputText)) then 
                    notFound = false
                    oldEmote = ZUI_LickAndTickle.db.realm.otherEmote
                    ZUI_LickAndTickle.db.realm.otherEmote = v.emote
                    ZUI_LickAndTickle.db.realm.otherText = v.text
                end
            end
        end
        if (notFound) then
            for i, v in pairs(ZUI_LickAndTickle.emotes.voice) do
                if(string.lower(v.text) == string.lower(LAT_GUI.inputText)) then 
                    notFound = false
                    oldEmote = ZUI_LickAndTickle.db.realm.otherEmote
                    ZUI_LickAndTickle.db.realm.otherEmote = v.emote
                    ZUI_LickAndTickle.db.realm.otherText = v.text
                end
            end
        end
        if (notFound) then
            for i, v in pairs(ZUI_LickAndTickle.emotes.other) do
                if(string.lower(v.text) == string.lower(LAT_GUI.inputText)) then 
                    notFound = false
                    oldEmote = ZUI_LickAndTickle.db.realm.otherEmote
                    ZUI_LickAndTickle.db.realm.otherEmote = v.emote
                    ZUI_LickAndTickle.db.realm.otherText = v.text
                end
            end
        end
        if (notFound == true) then
            print("|cFFCFCFCFEmote not found. Please try another emote|r")
        else
            for i, v in pairs(LAT_GUI.buttonTable) do
                if (v.emote == "lick" or v.emote == "tickle") then
                    v:Hide()
                end
                if (v.emote == oldEmote) then
                    v:Hide()
                    table.remove(LAT_GUI.buttonTable, i)
                end
            end
            SetCVar("nameplateShowFriends", 0)
            ZUI_LickAndTickle:CreateBtns("otherFrame", lickAndTickle, ZUI_LickAndTickle.db.realm.otherText, ZUI_LickAndTickle.db.realm.otherEmote)
        end
    end
    if(event == "ESCAPE") then self:ClearFocus() self:GetParent():Hide() end
end

function ZUI_LickAndTickle:EnterBtnPressed(self, button, down)  
    ZUI_LickAndTickle:ReShowNameplates()
    LAT_GUI.inputText = LAT_GUI.editbox:GetText() 
    LAT_GUI.inputFrame:Hide()

    local oldEmote
    local notFound = true
    if (notFound) then
        for i, v in pairs(ZUI_LickAndTickle.emotes.anim) do
            if(string.lower(v.text) == string.lower(LAT_GUI.inputText)) then 
                notFound = false
                oldEmote = ZUI_LickAndTickle.db.realm.otherEmote
                ZUI_LickAndTickle.db.realm.otherEmote = v.emote
                ZUI_LickAndTickle.db.realm.otherText = v.text
            end
        end
    end
    if (notFound) then
        for i, v in pairs(ZUI_LickAndTickle.emotes.voice) do
            if(string.lower(v.text) == string.lower(LAT_GUI.inputText)) then 
                notFound = false
                oldEmote = ZUI_LickAndTickle.db.realm.otherEmote
                ZUI_LickAndTickle.db.realm.otherEmote = v.emote
                ZUI_LickAndTickle.db.realm.otherText = v.text
            end
        end
    end
    if (notFound) then
        for i, v in pairs(ZUI_LickAndTickle.emotes.other) do
            if(string.lower(v.text) == string.lower(LAT_GUI.inputText)) then 
                notFound = false
                oldEmote = ZUI_LickAndTickle.db.realm.otherEmote
                ZUI_LickAndTickle.db.realm.otherEmote = v.emote
                ZUI_LickAndTickle.db.realm.otherText = v.text
            end
        end
    end
    if (notFound == true) then
        local myString = "|cfffc4e85Emote not found. Please try another emote|r"
        print(myString)
    else
        for i, v in pairs(LAT_GUI.buttonTable) do
            if (v.emote == "lick" or v.emote == "tickle") then
                v:Hide()
            end
            if (v.emote == oldEmote) then
                v:Hide()
                table.remove(LAT_GUI.buttonTable, i)
            end
        end
        SetCVar("nameplateShowFriends", 0)
        ZUI_LickAndTickle:CreateBtns("otherFrame", lickAndTickle, ZUI_LickAndTickle.db.realm.otherText, ZUI_LickAndTickle.db.realm.otherEmote)
    end
end

function ZUI_LickAndTickle:SwapBtnPressed(self, button, down)
    LAT_GUI.inputFrame:Hide()
    ZUI_LickAndTickle:ReShowNameplates()
    for i, v in ipairs(LAT_GUI.buttonTable) do
        v:Hide()
    end
    ZUI_LickAndTickle.db.realm.otherText = nil
    ZUI_LickAndTickle.db.realm.otherEmote = nil
    SetCVar("nameplateShowFriends", 0)
    ZUI_LickAndTickle:CreateBtns("tickleFrame", lickAndTickle, L["Tickle"], "tickle")
    ZUI_LickAndTickle:CreateBtns("lickFrame", lickAndTickle, L["Lick"], "lick")
end

function ZUI_LickAndTickle:setEmoteList(emotes)
    ZUI_LickAndTickle.emotes = emotes
end

function ZUI_LickAndTickle:ReShowNameplates()
	C_Timer.After(0.3, function() SetCVar("nameplateShowFriends", 1)  end)
end

-- needs better locale support
-- needs cleaning
-- add lick and tickle button together
-- add config window
-- track emotes without using buttons
-- track all emotes other than just selected emotes
-- reset pos config
-- might be showing icons on enemies
-- needs more comments
-- make both realm based or profile based
-- make keybind for emote
-- default profile set to wave, input profile, then profile for lick and tickle
-- hide buttons without hiding display