ZUI_LickAndTickle = LibStub("AceAddon-3.0"):NewAddon("ZUI_LickAndTickle", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("ZUI_LickAndTickle_Locale")
local LAT_GUI = LibStub("AceGUI-3.0")
local icon = LibStub("LibDBIcon-1.0")
local ZUI_LDB = LibStub("LibDataBroker-1.1"):NewDataObject("ZUI_LickAndTickle", {
    type = "data source",
    text = L["ZUI Lick and Tickle"],
    icon = GetItemIcon(5041),
    OnClick = function(self, button)
        if (button == "RightButton") then
            ZUI_LickAndTickle:InputFrame()
        end
        if (button == "LeftButton" and LAT_GUI.ButtonFrame:IsVisible() and IsShiftKeyDown()) then
            SetCVar("nameplateShowFriends", 0)
        elseif (button == "LeftButton" and LAT_GUI.ButtonFrame:IsVisible()) then
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

local options = {
    name = "ZUI_LickAndTickle",
    handler = ZUI_LickAndTickle,
    type = 'group',
    args = {
        
    }
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
    ZUI_LickAndTickle:ReShowNameplates()
    ZUI_LickAndTickle.db:ResetDB()
    ZUI_LickAndTickle:OnDisable()
    ZUI_LickAndTickle:OnEnable()
end 

function ZUI_LickAndTickle:OnInitialize()
    --self.db:ResetDB() -- to reset for debuging
    LAT_GUI.buttonTable = {}
    LAT_GUI.iconTable = {}
    ZUI_LickAndTickle.firstLoad = true
    self.db = LibStub("AceDB-3.0"):New("ZUI_LickAndTickleDB", defaults, true)
    icon:Register("ZUI_LickAndTickle", ZUI_LDB, self.db.realm.minimap)

    -- make interface options 
    ZUI_LickAndTickle:CreateInterfaceOptions()

    -- make button frame
    LAT_GUI.ButtonFrame = CreateFrame("Frame", "lickAndTickle", UIParent)
    LAT_GUI.ButtonFrame:SetSize(80,80)
    LAT_GUI.ButtonFrame:SetPoint("TOPLEFT", 80, -80)
    LAT_GUI.ButtonFrame:SetMovable(true)
    LAT_GUI.ButtonFrame:EnableMouse(true)
    LAT_GUI.ButtonFrame:RegisterForDrag("LeftButton")
    LAT_GUI.ButtonFrame:SetScript("OnDragStart", function() if(IsShiftKeyDown() == true) then LAT_GUI.ButtonFrame:StartMoving() end end)
    LAT_GUI.ButtonFrame:SetScript("OnDragStop", LAT_GUI.ButtonFrame.StopMovingOrSizing)
    -- Calls NamePlateAdded() or NamePlateRemoved()
    LAT_GUI.ButtonFrame:SetScript("OnEvent", function(self, event, ...)
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
    
    -- make buttons
    if (self.db.realm.otherEmote) then 
        ZUI_LickAndTickle:CreateBtns("otherFrame", lickAndTickle, self.db.realm.otherText, self.db.realm.otherEmote)
    else
        ZUI_LickAndTickle:CreateBtns("tickleFrame", lickAndTickle, L["Tickle"], "tickle")
        ZUI_LickAndTickle:CreateBtns("lickFrame", lickAndTickle, L["Lick"], "lick")
    end
end

function ZUI_LickAndTickle:OnEnable()
    -- Show UI
    LAT_GUI.ButtonFrame:Show()
    for i,item in ipairs(LAT_GUI.iconTable) do
        item:Show()
    end
    -- Registers NamePlateAdded and NamePlateRemoved
    LAT_GUI.ButtonFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    LAT_GUI.ButtonFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

    -- if first load, check if it should show UI on the first load
    if (ZUI_LickAndTickle.db.profile.showOnFirstLoad == false and ZUI_LickAndTickle.firstLoad == 1) then
        ZUI_LickAndTickle:OnDisable()
    end
    ZUI_LickAndTickle.firstLoad = false

    -- Hides the wrong profiles buttons
    ZUI_LickAndTickle:HideDisabledProfileButtons()
end

function ZUI_LickAndTickle:OnDisable()
    -- Hide UI
    LAT_GUI.ButtonFrame:Hide()
    for i,item in ipairs(LAT_GUI.iconTable) do
        item:Hide()
    end
    -- Unregisters NamePlateAdded and NamePlateRemoved
    LAT_GUI.ButtonFrame:UnregisterEvent("NAME_PLATE_UNIT_ADDED")
    LAT_GUI.ButtonFrame:UnregisterEvent("NAME_PLATE_UNIT_REMOVED")
end

function ZUI_LickAndTickle:HideAllEmoteButtons()
    for i, v in pairs(LAT_GUI.buttonTable) do
        v:Hide()
    end
end

function ZUI_LickAndTickle:CreateInterfaceOptions()
    local panel = CreateFrame("Frame")
    panel.name = "Friendly Emote Tracker"               
    InterfaceOptions_AddCategory(panel) 
    local title = panel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -8)
    title:SetText("ZUI Friendly Emote Tracker")

    local hideEmoteButtonsFunc = function() ZUI_LickAndTickle:HideAllEmoteButtons() end
    local showEmoteButtonsFunc = function() ZUI_LickAndTickle:HideDisabledProfileButtons() end

    ZUI_LickAndTickle:CreateInterfaceButton(panel, -50, "Hide", "Hide Emote Buttons", hideEmoteButtonsFunc)
    ZUI_LickAndTickle:CreateInterfaceButton(panel, -80, "Show", "Show Emote Buttons", showEmoteButtonsFunc)
    ZUI_LickAndTickle:CreateInterfaceButton(panel, -110, "Lick And Tickle", "something else")
end



function ZUI_LickAndTickle:CreateInterfaceButton(panel, yCord, buttonText, labelText, buttonFunc)
    local button = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    button:SetPoint("TOPLEFT", 320, yCord)
    button:SetSize(200, 25)
    button:SetText(buttonText)
    button:SetScript("OnClick", function() buttonFunc() end)
    local label = button:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
    label:SetPoint("CENTER", -298, 0)
    label:SetText(labelText)
end

function ZUI_LickAndTickle:CreateBtns(frameName, parent, btnText, emote)
    local points = {0, 16}
    if (btnText == "Lick") then points[1] = 0 points[2] = -16  end

    -- create emote button
    local emoteButton = CreateFrame("Button", frameName, parent)
    emoteButton.btnText = btnText
    emoteButton.emote = emote
    emoteButton:SetFrameStrata("HIGH")
    emoteButton:SetFrameLevel(0)
    emoteButton:SetSize(64, 20)
    emoteButton:SetPoint("CENTER", points[1], points[2])
    emoteButton:SetScript("OnClick", function() ZUI_LickAndTickle:btnClicked(emote) end)
    emoteButton:Show()

    -- add text to emote button
    local text = emoteButton:CreateFontString("text", "HIGH")
    text:SetPoint("CENTER")
    text:SetFont("Fonts\\FRIZQT__.TTF", 20, "THINOUTLINE")
    text:SetText(btnText)  

    -- add emote button to buttonTable
    table.insert(LAT_GUI.buttonTable, emoteButton)
end

function ZUI_LickAndTickle:btnClicked(emote)
    local unitGuid = UnitGUID("target")
    local locClass, engClass, locRace, engRace, gender, name, server = GetPlayerInfoByGUID(unitGuid)
    
    -- does buttons emote
    DoEmote(emote)
    
    -- check if targeting a player, and they are the same of the same faction
    if (locClass and UnitFactionGroup("Target") == UnitFactionGroup("Player")) then 
        local nameInDB = false;
        local emoteInEmotesList = false
        
        -- for each emote look through their DB (there are 3 DB's, one for each emote) 
        -- and check if the target is already in the DB. if not add them to DB
        if (emote == "tickle") then 
            -- set first obj. first loop not working without any obj in table. put first target in
            if (#self.db.realm.tickled == 0) then table.insert(self.db.realm.tickled, name) end
            for i, v in ipairs(self.db.realm.tickled) do
                if (v == name) then nameInDB = true end
            end
            if (nameInDB == false) then 
                table.insert(self.db.realm.tickled, name) 
            end
        elseif (emote == "lick") then
            -- set first obj
            if (#self.db.realm.licked == 0) then table.insert(self.db.realm.licked, name) end
            for i, v in ipairs(self.db.realm.licked) do
                if (v == name) then nameInDB = true end
            end
            if (nameInDB == false) then 
                table.insert(self.db.realm.licked, name) 
            end
        else 
            -- check if the given emote is in the list of in-game emotes
            for i, v in pairs(ZUI_LickAndTickle.emotes) do
                for j, k in ipairs(v) do
                if (emote == k.emote) then emoteInEmotesList = true end
                end
            end
            if (emoteInEmotesList) then 
                -- set first object
                if (#self.db.realm.other == 0) then table.insert(self.db.realm.other, name) end
                for i, v in ipairs(self.db.realm.other) do
                    if (v == name) then nameInDB = true end
                end
                if (nameInDB == false) then 
                    table.insert(self.db.realm.other, name) 
                end
            end
        end
        
        -- look through all icons. if the icon is on our target, hide it and remove it from the table
        for i, icon in pairs(LAT_GUI.iconTable) do
            if (icon.unitname == name) then 
                table.remove(LAT_GUI.iconTable, i) 
                icon:Hide()
                -- if the icon was red, we are on the lick and tickle profile. we need to spawn a new icon (blue or red)
                if (icon.bgFile == "Interface\\AddOns\\ZUI_LickAndTickle\\images\\RedBall.blp") then 
                    ZUI_LickAndTickle:NamePlateAdded(icon.nameplateid)
                end
                return
            end
        end
    end
end

function ZUI_LickAndTickle:NamePlateAdded(nameplateid)
    local unitname = UnitName(nameplateid)
    local unitGuid = UnitGUID(nameplateid)
    local locClass, engClass, locRace, engRace, gender, name, server = GetPlayerInfoByGUID(unitGuid) -- gets target info
    local faction
    local inLickDB = false
    local inTickleDB = false
    local inOtherDB = false
    local inEitherDB = true
    local isPlaterAddon, namePlate = ZUI_LickAndTickle:CheckForPlater(nameplateid) -- Gets nameplate

    -- Hides the wrong profiles buttons
    ZUI_LickAndTickle:HideDisabledProfileButtons()

    -- check if player is same faction as new nameplate unit
    if (UnitFactionGroup(nameplateid) == UnitFactionGroup("Player")) then
        -- sets profile
        if(LAT_GUI.profile2 == true) then inLickDB = true inTickleDB = true end

        -- checks if target's name is in any DB
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

        -- Makes Nameplates
        if (inEitherDB == false and LAT_GUI.profile2 == false and locClass) then ZUI_LickAndTickle:CreateSingleIcon("Interface\\AddOns\\ZUI_LickAndTickle\\images\\RedBall.blp", namePlate, nameplateid, unitGuid, unitname, isPlaterAddon) 
        elseif (inEitherDB == true and inLickDB == false and locClass) then  ZUI_LickAndTickle:CreateSingleIcon("Interface\\AddOns\\ZUI_LickAndTickle\\images\\BlueBall.blp", namePlate, nameplateid, unitGuid, unitname, isPlaterAddon) 
        elseif (inEitherDB == true and inTickleDB == false and locClass) then ZUI_LickAndTickle:CreateSingleIcon("Interface\\AddOns\\ZUI_LickAndTickle\\images\\YellowBall.blp", namePlate, nameplateid, unitGuid, unitname, isPlaterAddon) 
        elseif (LAT_GUI.profile2 == true and inOtherDB == false and locClass) then ZUI_LickAndTickle:CreateSingleIcon("Interface\\AddOns\\ZUI_LickAndTickle\\images\\YellowBall.blp", namePlate, nameplateid, unitGuid, unitname, isPlaterAddon) 
        end
    end
end

function ZUI_LickAndTickle:NamePlateRemoved(nameplateid)
    -- removes and hides icons when namePlate is removed
    for i, item in ipairs(LAT_GUI.iconTable) do
        if (nameplateid == item.nameplateid) then table.remove(LAT_GUI.iconTable, i) item:Hide() end
    end
end

function ZUI_LickAndTickle:CreateSingleIcon(bgFile, namePlate, nameplateid, unitGuid, unitname, isPlaterAddon)
    local backdropInfo =
    {
        bgFile = bgFile,
        tile = true,
        tileEdge = true,
        tileSize = 20,
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    }

    -- Create a single icon, parent it to namePlate, insert it into iconTable
    -- have to parent to namePlate, cant parent to LAT_GUI table. need to insert into table later
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

function ZUI_LickAndTickle:InputFrame()
    local bgInfo = {
        bgFile = "Interface\\AddOns\\ZUI_LickAndTickle\\images\\LAT_GUIInputFrameBackdrop.blp", 
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",  
        tile = true, 
        tileEdge = true, 
        tileSize = 252, 
        insets = { left = 10, right = 10, top = 10, bottom = 10 }
    }

    -- check if frame exists. if not create the frame
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
        local enterBtn = LAT_GUI.enterBtn
        enterBtn:SetPoint("BOTTOM", 50, 14)
        enterBtn:SetText("Enter")
        enterBtn:SetWidth(100)
        enterBtn:SetHeight(18)
        enterBtn:SetScript("OnClick", function(self, button, down) ZUI_LickAndTickle:CheckEmote() end)
    end
end

function ZUI_LickAndTickle:InputEntered(self, event, ...)   
    if(event == "ENTER") then ZUI_LickAndTickle:CheckEmote()end
    if(event == "ESCAPE") then LAT_GUI.inputFrame:Hide() end
end

function ZUI_LickAndTickle:CheckEmote()
    local oldEmote
    local notFound = true
    LAT_GUI.inputText = LAT_GUI.editbox:GetText() 

    -- hide inputframe
    LAT_GUI.inputFrame:Hide()
    -- flick namePlates
    ZUI_LickAndTickle:ReShowNameplates()
    
    -- look through all 3 emotes lists
    for j, k in pairs(ZUI_LickAndTickle.emotes) do
        -- if not found in last list
        if (notFound) then
            for i, v in pairs(k) do
                -- if emote from list == input emote, set values
                if(string.lower(v.text) == string.lower(LAT_GUI.inputText)) then 
                    notFound = false
                    oldEmote = ZUI_LickAndTickle.db.realm.otherEmote
                    ZUI_LickAndTickle.db.realm.otherEmote = v.emote
                    ZUI_LickAndTickle.db.realm.otherText = v.text
                end
            end
        end
    end
    -- if the emote isnt found do nothing but console print
    if (notFound == true) then
        local myString = "|cfffc4e85Emote not found. Please try another emote|r"
        print(myString)
    -- if emote was found look through button table
    else
        for i, v in pairs(LAT_GUI.buttonTable) do
            -- found the emote, set to profile 2 by hiding lick and tickle buttons
            if (v.emote == "lick" or v.emote == "tickle") then
                v:Hide()
            end
            -- hide and remove old custom emote button
            if (v.emote == oldEmote) then
                v:Hide()
                table.remove(LAT_GUI.buttonTable, i)
            end
        end
        -- create new emote button
        ZUI_LickAndTickle:CreateBtns("otherFrame", lickAndTickle, ZUI_LickAndTickle.db.realm.otherText, ZUI_LickAndTickle.db.realm.otherEmote)
    end
end

function ZUI_LickAndTickle:SwapBtnPressed(self, button, down)
    LAT_GUI.inputFrame:Hide()
    ZUI_LickAndTickle:ReShowNameplates()
    ZUI_LickAndTickle:HideDisabledProfileButtons()
    ZUI_LickAndTickle.db.realm.otherText = nil
    ZUI_LickAndTickle.db.realm.otherEmote = nil
    
    ZUI_LickAndTickle:CreateBtns("tickleFrame", lickAndTickle, L["Tickle"], "tickle")
    ZUI_LickAndTickle:CreateBtns("lickFrame", lickAndTickle, L["Lick"], "lick")
end

-- Utils
function ZUI_LickAndTickle:setEmoteList(emotes)
    ZUI_LickAndTickle.emotes = emotes
end

function ZUI_LickAndTickle:ReShowNameplates()
    SetCVar("nameplateShowFriends", 0)
	C_Timer.After(0.3, function() SetCVar("nameplateShowFriends", 1)  end)
end

function ZUI_LickAndTickle:HideDisabledProfileButtons()
    -- if the user has selected a custom emote. set profile2 true. hide and remove lick and tickle buttons
    if (ZUI_LickAndTickle.db.realm.otherEmote) then
        LAT_GUI.profile2 = true
        for i, v in pairs(LAT_GUI.buttonTable) do
            if (v.btnText ~= ZUI_LickAndTickle.db.realm.otherText) then
                v:Hide()
                table.remove(LAT_GUI.buttonTable, i) 
            else
                v:Show()
            end
        end

    -- if the user hasent selected a custom emote. set profile2 false. hide and remove wrong buttons
    else
        LAT_GUI.profile2 = false
        for i, v in pairs(LAT_GUI.buttonTable) do
            if (v.btnText ~= "Lick" and v.btnText ~= "Tickle") then
                v:Hide() 
                table.remove(LAT_GUI.buttonTable, i)
            else
                v:Show()
            end
        end
    end
end

function ZUI_LickAndTickle:CheckForPlater(nameplateid)
    -- Checks for Plater Addon
    local isPlaterAddon, namePlate
    if (C_NamePlate.GetNamePlateForUnit(nameplateid).unitFrame) then
        -- plater uses lowercase 'u' for their unitFrame
        namePlate = C_NamePlate.GetNamePlateForUnit(nameplateid).unitFrame
        isPlaterAddon = true
    else
        namePlate = C_NamePlate.GetNamePlateForUnit(nameplateid).UnitFrame
        isPlaterAddon = false
    end
    return isPlaterAddon, namePlate
end

-- needs better locale support
-- add lick and tickle button together
-- track emotes without using buttons
-- track all emotes other than just selected emotes
-- reset pos config
-- make both realm based or profile based
-- make keybind for emote
-- default profile set to wave, input profile, then profile for lick and tickle
-- hide buttons without hiding icons
-- change addon name
-- open options from minimap
-- see if the addon NEEDs ACE3