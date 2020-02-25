--[[--------------------------------------------
    Project:    Clean My Chat
    Author:     Arne Rantzen (Tyx)
    Created:    2020-02-25
    Updated:    2020-02-25
    License:    GPL-3.0
--------------------------------------------]]--

CleanMyChat = {
    author = "Tyx",
    name = "CleanMyChat",
    displayName = "Clean My Chat",
    version = "1.0.0",
    saved_version = 1,
    defaults = {
        cleanCyrillic = true,
        cleanGerman = false,
        cleanCustom = false,
        customFilter = {}
    },
}

local alphabet = {
    cyrillic = {
        "Б", "б", "Г", "г", "Д", "д", "Ж", "ж", "З", "з", "И", "и", "Й", "й", "К", "к", "Л", "л", "Н", "н", "П",
        "п", "У", "Ф", "ф", "Ц", "ц", "Ч", "ч", "Ш", "ш", "Щ", "щ", "Ъ", "ъ", "Ы", "ы", "Э", "э", "Ю", "ю", "Я",
        "я", "Ђ", "ђ", "Ѓ", "ѓ", "Є", "є", "Љ", "љ", "Њ", "њ", "Ћ", "ћ", "Ќ", "ќ", "Ѝ", "ѝ", "Ў", "ў", "Џ", "џ"
    },
    german = {
        "ä", "ö", "ü"
    }
}

local LAM = LibAddonMenu2

--- Test if message contains letters known to be common in cyrillic languages
-- @param message text to be filtered
function CleanMyChat.IsCyrillic(message)
    for _, letter in ipairs(alphabet.cyrillic) do
        if string.find(message, letter) then return true end
    end
    return false
end

--- Test if message contains letters known to be common in German
-- @param message text to be filtered
function CleanMyChat.IsGerman(message)
    for _, letter in ipairs(alphabet.german) do
        if string.find(message, letter) then return true end
    end
    return false
end

--- Test if message contains letters previous defined in the custom filter
-- @param message text to be filtered
function CleanMyChat:IsCustom(message)
    for _, letter in ipairs(self.saved.customFilter) do
        if string.find(message, letter) then return true end
    end
    return false
end

--- Register filter for chat event
function CleanMyChat:RegisterEvent()
    local function MessageNeedsToBeRemoved(_, ...)
        local fromName = tostring(select(1, ...))
        local message = tostring(select(2, ...))
        local displayName = tostring(select(4, ...))

        local removeGermanMessage = self.saved.cleanGerman and self.IsGerman(message)
        local removeCyrillicMessage = self.saved.cleanCyrillic and self.IsCyrillic(message)
        local removeCustomMessage = self.saved.cleanCustom and self:IsCustom(message)
        local removeMessage = removeGermanMessage or removeCyrillicMessage or removeCustomMessage

        -- Don't filter your own message
        if removeMessage and (GetUnitName("player") == fromName or GetDisplayName() == displayName) then
            if removeGermanMessage then
                CHAT_SYSTEM:AddMessage("You just wrote with filtered German characters."
                        .. "You might not see responses.\n"
                        .."Maybe you want to unset the filter of the language you just used...\n"
                        .. "Write /cmc to open the settings menu.")
            elseif removeCyrillicMessage then
                CHAT_SYSTEM:AddMessage("You just wrote with filtered cyrillic characters."
                        .. "You might not see responses.\n"
                        .."Maybe you want to unset the filter of the language you just used...\n"
                        .. "Write /cmc to open the settings menu.")
            else
                CHAT_SYSTEM:AddMessage("You just wrote with filtered custom characters."
                        .. "You might not see responses.\n"
                        .."Maybe you want to unset the filter of the language you just used...\n"
                        .. "Write /cmc to open the settings menu.")
            end
            return false
        end

        return removeMessage

    end

    local function OnChatEvent(control, ...)
        if not MessageNeedsToBeRemoved(...) then
            return CHAT_ROUTER.registeredEventHandlers[EVENT_CHAT_MESSAGE_CHANNEL](control, ...)
        end
    end

    EVENT_MANAGER:UnregisterForEvent("ChatRouter", EVENT_CHAT_MESSAGE_CHANNEL)
    EVENT_MANAGER:RegisterForEvent("ChatRouter", EVENT_CHAT_MESSAGE_CHANNEL, OnChatEvent)
end

--- Create menu in LibAddonMenu2 settings if available
function CleanMyChat:RegisterSettings()
    local lang = GetCVar("Language.2")
    local link = "https://" .. lang .. ".liberapay.com/Tyx/"
    local panel = {
        type = "panel",
        name = self.name,
        displayName = self.displayName,
        author = "|c5175ea" .. self.author .. "|r",
        version = self.version,
        --website = "https://rantzen.net/clock-tamriel-standard-time/",
        feedback = "https://github.com/Tyxz/Clean-My-Chat/issues/new/choose",
        donation = link,
        --slashCommand = "/cmc",
        --registerForRefresh = true,
        registerForDefaults = true,
        resetFunc = function()
            for k,v in pairs(self.defaults) do
                self.saved[k] = v
            end
        end,
    }

    if LAM then
        CLEAN_MY_CHAT_PANEL = LAM:RegisterAddonPanel(self.name, panel)
        local data = {
            {
                type = "checkbox",
                name = "Clean Cyrillic",
                getFunc = function() return self.saved.cleanCyrillic end,
                setFunc = function(value) self.saved.cleanCyrillic = value end
            },
            {
                type = "checkbox",
                name = "Clean German",
                getFunc = function() return self.saved.cleanGerman end,
                setFunc = function(value) self.saved.cleanGerman = value end
            },
            {
                type = "checkbox",
                name = "Clean Custom",
                disabled = function() return self.customFilter == {} end,
                getFunc = function() return self.saved.cleanCustom end,
                setFunc = function(value) self.saved.cleanCustom = value end
            },
            {
                type = "editbox",
                name = "Custom filter - one word or character separated with a ',' ",
                isMultiline = true,
                isExtraWide = true,
                getFunc = function() return table.concat(self.saved.customFilter, ", ") end,
                setFunc = function(value)
                    self.saved.customFilter = {}
                    local filter = string.gsub(value, "[ ,;\n\t]+", " ")
                    for i in string.gmatch(filter, "%S+") do
                        d(i)
                        if i ~= "" then
                            table.insert(self.saved.customFilter, i)
                        end
                    end
                    d(self.saved.customFilter)
                end
            }
        }
        LAM:RegisterOptionControls(self.name, data)

        if LibFeedback then
            local buttons =
            {
                { panel.feedback, "Report an issue", false },
            }
            local worldName = GetWorldName()
            if worldName == "EU Megaserver" then
                table.insert(buttons, { 0, "In-game Feedback", false })
                table.insert(buttons, { 5000, "Small donation", true })
                table.insert(buttons, { 50000, "Larger donation", true })
            end
            table.insert(buttons, { panel.donation, "Real donation", false })
            return LibFeedback:initializeFeedbackWindow(
                    self,
                    self.displayName,
                    CLEAN_MY_CHAT_PANEL,
                    self.author,
                    {12 , CLEAN_MY_CHAT_PANEL, 12 , -20, 20}, -- Anchor
                    buttons,
                    "If you found a bug, have a request or a suggestion, or simply wish to donate,\n"
                    .. "you are welcome to send me an email."
            )
        end
    end
end

--- Register slash commands
function CleanMyChat:RegisterCommands()
    SLASH_COMMANDS["/cmc"] = function(...)
        local command = string.lower(select(1, ...))
        if select("#", ...) == 1 and command == "" then
            if LAM then
                LAM:OpenToPanel(CLEAN_MY_CHAT_PANEL)
            else
                for k, v in pairs(self.saved) do
                    if k ~= "customFilter" then
                        CHAT_SYSTEM:AddMessage(k .. ":\t" .. v)
                    end
                end
            end
        else
            if command == "filter" then
                CHAT_SYSTEM:AddMessage("Custom filter:\n" .. table.concat(self.saved.customFilter, ", "))
            elseif command == "cyrillic" then
                self.saved.cleanCyrillic = not self.saved.cleanCyrillic
                CHAT_SYSTEM:AddMessage("Cyrillic filter:\t" .. self.saved.cleanCyrillic)
            elseif command == "german" then
                self.saved.cleanGerman = not self.saved.cleanGerman
                CHAT_SYSTEM:AddMessage("German filter:\t" .. self.saved.cleanGerman)
            elseif command == "custom" then
                self.saved.cleanCustom = not self.saved.cleanCustom
                CHAT_SYSTEM:AddMessage("Custom filter:\t" .. self.saved.cleanCustom)
            end
        end
    end
end

--- Initialize functions
function CleanMyChat:Initialize()
    self.saved = ZO_SavedVars:NewAccountWide(self.name .. "_Settings", self.saved_version, nil, self.defaults)
    self:RegisterSettings()
    self:RegisterEvent()
    self:RegisterCommands()
end

--Register Loaded Callback
EVENT_MANAGER:RegisterForEvent(
        CleanMyChat.name, EVENT_ADD_ON_LOADED,
        function(_, addOnName)
            if(addOnName ~= CleanMyChat.name) then return end
            CleanMyChat:Initialize()
        end
)