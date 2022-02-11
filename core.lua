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
        tooltip:AddLine(L["|cFFCFCFCF/fet-reset or /fetre to reset|r"])
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
        otherText = "Wave",
        otherEmote = "wave",
        profile2 = true,
    },
    profile = {
        showOnFirstLoad = true,
        useRealmSetting = true,
        licked = {},
        tickled = {},
        other = {},
    },
}

SLASH_RESETDB1 = "/fet-reset"
SLASH_RESETDB2 = "/fetre"
SlashCmdList["RESETDB"] = function()
    ZUI_LickAndTickle:ReShowNameplates()
    ZUI_LickAndTickle.db:ResetDB()
    ZUI_LickAndTickle:OnDisable()
    ZUI_LickAndTickle:OnEnable()
end 

function ZUI_LickAndTickle:OnInitialize()
    LAT_GUI.buttonTable = {}
    LAT_GUI.iconTable = {}
    ZUI_LickAndTickle.firstLoad = true
    self.db = LibStub("AceDB-3.0"):New("ZUI_LickAndTickleDB", defaults, true)
    icon:Register("ZUI_LickAndTickle", ZUI_LDB, self.db.realm.minimap)
    --self.db:ResetDB() -- to reset for debuging

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
    LAT_GUI.ButtonFrame:SetScript("OnEvent", function(self, event, ...)
        -- Calls NamePlateAdded()
        if (event == "NAME_PLATE_UNIT_ADDED") then
            local nameplateid = ...
            if (UnitGUID(nameplateid) ~= UnitGUID("Player"))then
            ZUI_LickAndTickle:NamePlateAdded(nameplateid) 
        end
        end
        -- calls NamePlateRemoved()
        if (event == "NAME_PLATE_UNIT_REMOVED") then
            local nameplateid = ...
            ZUI_LickAndTickle:NamePlateRemoved(nameplateid)    
        end
        -- adds target to db when user sends chat emote
        if (event == "CHAT_MSG_TEXT_EMOTE") then
            if (ZUI_LickAndTickle.emoteButtonPressed == false or ZUI_LickAndTickle.emoteButtonPressed == nil) then
                local t = {}
                local wasPlayer = false
                local typedEmote
                for i in string.gmatch(..., "%S+") do
                    table.insert(t, i)
                end
                -- check if typed emote was sent by the player
                if ("You" == t[1]) then 
                    wasPlayer = true
                end
                -- check if typedEmote was lick or tickle to add too the db
                for i, v in ipairs(t) do
                    if ("lick" == v) then
                        typedEmote = "lick"
                    end
                    if ("tickle" == v) then
                        typedEmote = "tickle"
                    end
                end
                -- if the typed emote was sent by the player, and it was lick or tickle then - 
                -- it needs to change the lick and tickle DBs aswell
                if (wasPlayer and typedEmote == "lick" or wasPlayer and typedEmote == "tickle") then
                    ZUI_LickAndTickle:AddTargetToDB(nil, true, "profile", typedEmote)
                    ZUI_LickAndTickle:AddTargetToDB(nil, true, "realm", typedEmote)
                -- if the typed emote was sent by the player, but its not lick or tickle then - 
                -- only change other DB
                elseif (wasPlayer) then
                    ZUI_LickAndTickle:AddTargetToDB(nil, true, "profile")
                    ZUI_LickAndTickle:AddTargetToDB(nil, true, "realm")
                end
            end
            ZUI_LickAndTickle.emoteButtonPressed = false
        end
    end)

    -- make buttons
    if (self.db.realm.profile2) then 
        ZUI_LickAndTickle:CreateEmoteButtons("otherFrame", lickAndTickle, self.db.realm.otherText, self.db.realm.otherEmote)
    else
        ZUI_LickAndTickle:CreateEmoteButtons("tickleFrame", lickAndTickle, L["Tickle"], "tickle")
        ZUI_LickAndTickle:CreateEmoteButtons("lickFrame", lickAndTickle, L["Lick"], "lick")
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
    LAT_GUI.ButtonFrame:RegisterEvent("CHAT_MSG_TEXT_EMOTE")

    -- if first load, check if it should show UI on the first load
    if (ZUI_LickAndTickle.db.profile.showOnFirstLoad == false and ZUI_LickAndTickle.firstLoad == true) then
        ZUI_LickAndTickle:OnDisable()
    end
    ZUI_LickAndTickle.firstLoad = false

    -- Hides the wrong profiles buttons
    ZUI_LickAndTickle:ToggleProfileAndEmoteButtons()
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
    -- make frame
    local panel = CreateFrame("Frame")
    panel.name = "Friendly Emote Tracker"            
    -- add frame to interface options   
    InterfaceOptions_AddCategory(panel) 
    local title = panel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -8)
    title:SetText("ZUI Friendly Emote Tracker")

    -- set button functions
    local hideEmoteButtonsFunc = function() ZUI_LickAndTickle:HideAllEmoteButtons() end
    local showEmoteButtonsFunc = function() ZUI_LickAndTickle:ToggleProfileAndEmoteButtons() end
    local resetEmoteButtonsPos = function() ZUI_LickAndTickle:ResetEmoteButtonsPos() end
    local switchToLickAndTickle = function() ZUI_LickAndTickle:SwitchToLickAndTickle() end
    local openInputFrame = function() ZUI_LickAndTickle:InputFrame() end
    -- create buttons
    ZUI_LickAndTickle:CreateInterfaceButton(panel, -50, "Hide", "Hide Emote Buttons", hideEmoteButtonsFunc)
    ZUI_LickAndTickle:CreateInterfaceButton(panel, -80, "Show", "Show Emote Buttons", showEmoteButtonsFunc)
    ZUI_LickAndTickle:CreateInterfaceButton(panel, -110, "Reset", "Reset Emote Buttons Position", resetEmoteButtonsPos)
    ZUI_LickAndTickle:CreateInterfaceButton(panel, -140, "Switch", "Switch To Lick and Tickle Profile", switchToLickAndTickle)
    ZUI_LickAndTickle:CreateInterfaceButton(panel, -170, "Input Emote", "Switch To Default Profile", openInputFrame)
    ZUI_LickAndTickle:CreateInterfaceCheckButton(panel)
end

function ZUI_LickAndTickle:CreateInterfaceCheckButton(panel)
    local checkButton = CreateFrame("CheckButton", nil, panel, "ChatConfigCheckButtonTemplate")
    checkButton:SetPoint("TOPLEFT", 416, -200)
    checkButton:SetSize(25,25)
    checkButton:SetChecked(true)
    checkButton:SetScript("OnClick", function() 
        -- Inverts useRealmSettigns
        ZUI_LickAndTickle.db.profile.useRealmSetting = not ZUI_LickAndTickle.db.profile.useRealmSetting
        ZUI_LickAndTickle:ReShowNameplates()
    end)
    local label = checkButton:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
    label:SetPoint("CENTER", -278, 0)
    label:SetText("Use Data From All Characters")
end

function ZUI_LickAndTickle:CreateInterfaceButton(panel, yCord, buttonText, labelText, buttonFunc)
    local button = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    button:SetPoint("TOPLEFT", 330, yCord)
    button:SetSize(200, 25)
    button:SetText(buttonText)
    button:SetScript("OnClick", function() buttonFunc() end)
    local label = button:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
    label:SetPoint("CENTER", -278, 0)
    label:SetText(labelText)
end

function ZUI_LickAndTickle:ResetEmoteButtonsPos()
    LAT_GUI.ButtonFrame:ClearAllPoints()
    LAT_GUI.ButtonFrame:SetPoint("TOPLEFT", 80, -80)
end

function ZUI_LickAndTickle:CreateEmoteButtons(frameName, parent, btnText, emote)
    -- set button points
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
    emoteButton:SetScript("OnClick", function() 
        -- register and unregister CHAT_MSG_TEXT_EMOTE when button is clicked so that it doesn't run twice
        -- added emoteButtonPressed bool to make it more succure. CHAT_MSG_TEXT_EMOTE wasn't always working
        LAT_GUI.ButtonFrame:UnregisterEvent("CHAT_MSG_TEXT_EMOTE")
        ZUI_LickAndTickle.emoteButtonPressed = true
        -- add to both db's and remove/replace icon
        ZUI_LickAndTickle:AddTargetToDB(emote, nil, "profile") 
        ZUI_LickAndTickle:AddTargetToDB(emote, nil, "realm") 
        LAT_GUI.ButtonFrame:RegisterEvent("CHAT_MSG_TEXT_EMOTE")  
        ZUI_LickAndTickle.emoteButtonPressed = false
    end)
    emoteButton:Show()

    -- add text to emote button
    local text = emoteButton:CreateFontString("text", "HIGH")
    text:SetPoint("CENTER")
    text:SetFont("Fonts\\FRIZQT__.TTF", 20, "THINOUTLINE")
    text:SetText(btnText)  

    -- add emote button to buttonTable
    table.insert(LAT_GUI.buttonTable, emoteButton)
end

function ZUI_LickAndTickle:AddTargetToDB(emote, isChatMsgEmote, DB, LorT)
    if (emote) then DoEmote(emote) end
    local unitGuid = UnitGUID("target")
    -- takes user input lick or tickle emotes and sets them after already sending the emote through
    if (LorT == "lick" or LorT == "tickle") then emote = LorT end

    -- checks if target exits
    if (unitGuid) then
        local locClass, engClass, locRace, engRace, gender, name, server = GetPlayerInfoByGUID(unitGuid)
        local mainDatabase

        -- set DB to add to 
        if (DB == "profile") then
            mainDatabase = ZUI_LickAndTickle.db.profile
        else
            mainDatabase = ZUI_LickAndTickle.db.realm
        end

        -- check if targeting a player, and they are the same of the same faction
        if (locClass and UnitFactionGroup("Target") == UnitFactionGroup("Player")) then 
            local nameInDB = false;
            local emoteInEmotesList = false
            local emoteColor
            
            -- for each emote look through their DB (there are 3 DB's, one for each emote) 
            -- and check if the target is already in the DB. if not add them to DB
            if (emote == "tickle") then 
                print(emote)
                emoteColor = "yellow"
                -- set first obj. first loop not working without any obj in table. put first target in
                if (#mainDatabase.tickled == 0) then table.insert(mainDatabase.tickled, name) end
                -- check if in tickle DB, if not add to DB
                for i, v in ipairs(mainDatabase.tickled) do
                    if (v == name) then nameInDB = true end
                end
                if (nameInDB == false) then 
                    table.insert(mainDatabase.tickled, name) 
                end
                -- check if in Other DB, if not add to DB
                local inTheOtherDB = false
                if (#mainDatabase.other == 0) then table.insert(mainDatabase.other, name) end
                for i, v in ipairs(mainDatabase.other) do
                    if (v == name) then inTheOtherDB = true end
                end
                if (inTheOtherDB == false) then 
                    table.insert(mainDatabase.other, name) 
                end
            end

            if (emote == "lick") then
                emoteColor = "blue"
                -- set first obj
                if (#mainDatabase.licked == 0) then table.insert(mainDatabase.licked, name) end
                -- check if in licked DB, if not add to DB
                for i, v in ipairs(mainDatabase.licked) do
                    if (v == name) then nameInDB = true end
                end
                if (nameInDB == false) then 
                    table.insert(mainDatabase.licked, name) 
                end
                -- check if in Other DB, if not add to DB
                local inTheOtherDB = false
                if (#mainDatabase.other == 0) then table.insert(mainDatabase.other, name) end
                for i, v in ipairs(mainDatabase.other) do
                    if (v == name) then inTheOtherDB = true end
                end
                if (inTheOtherDB == false) then 
                    table.insert(mainDatabase.other, name) 
                end   
            end   

            if (emote == nil and isChatMsgEmote) then 
                emoteColor = "yellow"
                print("hit")
                -- check if the given emote is in the list of in-game emotes
                for i, v in pairs(ZUI_LickAndTickle.emotes) do
                    for j, k in ipairs(v) do
                        if (emote == k.emote) then emoteInEmotesList = true end
                    end
                end
                if (emoteInEmotesList) then
                -- set first object
                    if (#mainDatabase.other == 0) then table.insert(mainDatabase.other, name) end
                    -- check if in Other DB, if not add to DB
                    for i, v in ipairs(mainDatabase.other) do
                        if (v == name) then nameInDB = true end
                    end
                    if (nameInDB == false) then 
                        table.insert(mainDatabase.other, name) 
                    end
                end
            end
            
            -- only run once
            if (DB == "realm") then
                -- reset icon color if on profile2 so the lick can destroy yellow frames
                if (ZUI_LickAndTickle.db.realm.profile2) then emoteColor = "yellow" end
                -- look through all icons. if the icon is on our target, hide it and remove it from the table
                for i, icon in pairs(LAT_GUI.iconTable) do
                    -- find the right icon, only make icon disapear if emote is supposed to destroy that color
                    if (icon.unitname == name and icon.color == "red" or icon.unitname == name and icon.color == emoteColor) then
                        table.remove(LAT_GUI.iconTable, i) 
                        icon:Hide()
                        -- if the icon was red we need to spawn a new icon (blue or red)
                        if (icon.color == "red") then                
                            ZUI_LickAndTickle:NamePlateAdded(icon.nameplateid)
                        end
                    end
                end
            end
        end
    end
end


function ZUI_LickAndTickle:NamePlateAdded(nameplateid)
    local unitname = UnitName(nameplateid)
    local unitGuid = UnitGUID(nameplateid)
    local locClass, engClass, locRace, engRace, gender, name, server = GetPlayerInfoByGUID(unitGuid) -- gets target info
    local faction, mainDatabase
    local inLickDB = false
    local inTickleDB = false
    local inOtherDB = false
    local inEitherDB = true
    local isPlaterAddon, namePlate = ZUI_LickAndTickle:CheckForPlater(nameplateid) -- Gets nameplate

    -- select which database to use for showing icons
    if (ZUI_LickAndTickle.db.profile.useRealmSetting == true) then
        mainDatabase = ZUI_LickAndTickle.db.realm
    elseif (ZUI_LickAndTickle.db.profile.useRealmSetting == false) then
        mainDatabase = ZUI_LickAndTickle.db.profile
    end

    -- Hides the wrong profiles buttons
    ZUI_LickAndTickle:ToggleProfileAndEmoteButtons()

    -- check if player is same faction as new nameplate unit
    if (UnitFactionGroup(nameplateid) == UnitFactionGroup("Player")) then
        -- sets profile
        if(ZUI_LickAndTickle.db.realm.profile2 == true) then inLickDB = true inTickleDB = true end

        -- checks if target's name is in any DB
        for i, item in ipairs(mainDatabase.licked) do
            if (item == unitname) then inLickDB = true end
        end
        for i, item in ipairs(mainDatabase.tickled) do
            if (item == unitname) then inTickleDB = true end
        end
        for i, item in ipairs(mainDatabase.other) do
            if (item == unitname) then inOtherDB = true end
        end
        if (inLickDB == false and inTickleDB == false) then
            inEitherDB = false
        else
            inEitherDB = true
        end

        -- Makes Nameplates
        if (inEitherDB == false and ZUI_LickAndTickle.db.realm.profile2 == false and locClass) then ZUI_LickAndTickle:CreateSingleIcon("Interface\\AddOns\\ZUI_LickAndTickle\\images\\RedBall.blp", namePlate, nameplateid, unitGuid, unitname, isPlaterAddon) 
        elseif (inEitherDB == true and inLickDB == false and locClass) then  ZUI_LickAndTickle:CreateSingleIcon("Interface\\AddOns\\ZUI_LickAndTickle\\images\\BlueBall.blp", namePlate, nameplateid, unitGuid, unitname, isPlaterAddon) 
        elseif (inEitherDB == true and inTickleDB == false and locClass) then ZUI_LickAndTickle:CreateSingleIcon("Interface\\AddOns\\ZUI_LickAndTickle\\images\\YellowBall.blp", namePlate, nameplateid, unitGuid, unitname, isPlaterAddon) 
        elseif (ZUI_LickAndTickle.db.realm.profile2 == true and inOtherDB == false and locClass) then ZUI_LickAndTickle:CreateSingleIcon("Interface\\AddOns\\ZUI_LickAndTickle\\images\\YellowBall.blp", namePlate, nameplateid, unitGuid, unitname, isPlaterAddon) 
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
    if(bgFile == "Interface\\AddOns\\ZUI_LickAndTickle\\images\\RedBall.blp") then 
        frame.color = "red"
    elseif(bgFile == "Interface\\AddOns\\ZUI_LickAndTickle\\images\\YellowBall.blp") then 
            frame.color = "yellow"
    elseif(bgFile == "Interface\\AddOns\\ZUI_LickAndTickle\\images\\BlueBall.blp") then 
            frame.color = "blue"
    end
    
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
        LAT_GUI.enterBtn = CreateFrame("Button", "enterbutton", inputFrame, "UIPanelButtonTemplate")
        local enterBtn = LAT_GUI.enterBtn
        enterBtn:SetPoint("BOTTOM", 0, 14)
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
        -- set to profile 2 
        ZUI_LickAndTickle.db.realm.profile2 = true
        for i, v in pairs(LAT_GUI.buttonTable) do
            -- hide lick and tickle buttons
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
        ZUI_LickAndTickle:CreateEmoteButtons("otherFrame", lickAndTickle, ZUI_LickAndTickle.db.realm.otherText, ZUI_LickAndTickle.db.realm.otherEmote)
    end
end

function ZUI_LickAndTickle:SwitchToLickAndTickle(self, button, down)
    -- toggle UI frames
    if(LAT_GUI.inputFrame) then LAT_GUI.inputFrame:Hide() end
    ZUI_LickAndTickle:ReShowNameplates()
    ZUI_LickAndTickle:ToggleProfileAndEmoteButtons()
    -- set vars
    ZUI_LickAndTickle.db.realm.otherText = nil
    ZUI_LickAndTickle.db.realm.otherEmote = nil
    ZUI_LickAndTickle.db.realm.profile2 = false
    -- create new buttons
    ZUI_LickAndTickle:CreateEmoteButtons("tickleFrame", lickAndTickle, L["Tickle"], "tickle")
    ZUI_LickAndTickle:CreateEmoteButtons("lickFrame", lickAndTickle, L["Lick"], "lick")
end

-- Utils
function ZUI_LickAndTickle:setEmoteList(emotes)
    ZUI_LickAndTickle.emotes = emotes
end

function ZUI_LickAndTickle:ReShowNameplates()
    -- set timer so that frames get destroyed and re-created
    SetCVar("nameplateShowFriends", 0)
	C_Timer.After(0.3, function() SetCVar("nameplateShowFriends", 1)  end)
end

function ZUI_LickAndTickle:ToggleProfileAndEmoteButtons()
    -- if the user has selected a custom emote. set profile2 true. hide and remove lick and tickle buttons
    if (ZUI_LickAndTickle.db.realm.profile2) then
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
-- make keybind for emote - inteface option
-- add lick and tickle button together - interface option

-- final tests (check dbs)
-- final comments