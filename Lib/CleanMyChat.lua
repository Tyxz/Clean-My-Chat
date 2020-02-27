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
    version = "1.1.0",
    savedVersion = 1,
    channelNames = {
        [CHAT_CHANNEL_SAY] = GetString(SI_CHAT_CHANNEL_NAME_SAY),
        [CHAT_CHANNEL_YELL] = GetString(SI_CHAT_CHANNEL_NAME_YELL),
        [CHAT_CHANNEL_EMOTE] = GetString(SI_CHAT_CHANNEL_NAME_EMOTE),
        [CHAT_CHANNEL_WHISPER] = GetString(SI_CHAT_CHANNEL_NAME_WHISPER),
        -- Zone
        [CHAT_CHANNEL_ZONE] = GetString(SI_CHAT_CHANNEL_NAME_ZONE),
        [CHAT_CHANNEL_ZONE_LANGUAGE_1] = GetString(SI_CHAT_CHANNEL_NAME_ZONE_ENGLISH),
        [CHAT_CHANNEL_ZONE_LANGUAGE_2] = GetString(SI_CHAT_CHANNEL_NAME_ZONE_FRENCH),
        [CHAT_CHANNEL_ZONE_LANGUAGE_3] = GetString(SI_CHAT_CHANNEL_NAME_ZONE_GERMAN),
        [CHAT_CHANNEL_ZONE_LANGUAGE_4] = GetString(SI_CHAT_CHANNEL_NAME_ZONE_JAPANESE),
        -- Party
        [CHAT_CHANNEL_PARTY] = GetString(SI_CHAT_CHANNEL_NAME_PARTY),
        -- Guild - no generic names found
        [CHAT_CHANNEL_GUILD_1] = "Guild 1",
        [CHAT_CHANNEL_GUILD_2] = "Guild 2",
        [CHAT_CHANNEL_GUILD_3] = "Guild 3",
        [CHAT_CHANNEL_GUILD_4] = "Guild 4",
        [CHAT_CHANNEL_GUILD_5] = "Guild 5",
        -- Officer - no generic names found
        [CHAT_CHANNEL_OFFICER_1] = "Officer 1",
        [CHAT_CHANNEL_OFFICER_2] = "Officer 2",
        [CHAT_CHANNEL_OFFICER_3] = "Officer 3",
        [CHAT_CHANNEL_OFFICER_4] = "Officer 4",
        [CHAT_CHANNEL_OFFICER_5] = "Officer 5",
    },
    defaults = {
        debug = false,
        lastVersion = {
            major = 1,
            minor = 1
        },
        statistic = {
            cyrillic = 0,
            german = 0,
            french = 0,
            slavic = 0,
            custom = 0,
        },
        cleanCyrillic = true,
        cleanGerman = false,
        cleanFrench = false,
        cleanSlavic = false,
        cleanCustom = false,
        customFilter = {},
        filterChannel = false,
        channel = {
            [CHAT_CHANNEL_SAY] = true,
            [CHAT_CHANNEL_YELL] = true,
            [CHAT_CHANNEL_EMOTE] = true,
            [CHAT_CHANNEL_WHISPER] = false,
            -- Zone
            [CHAT_CHANNEL_ZONE] = true,
            [CHAT_CHANNEL_ZONE_LANGUAGE_1] = false,
            [CHAT_CHANNEL_ZONE_LANGUAGE_2] = false,
            [CHAT_CHANNEL_ZONE_LANGUAGE_3] = false,
            [CHAT_CHANNEL_ZONE_LANGUAGE_4] = false,
            -- Party
            [CHAT_CHANNEL_PARTY] = false,
            -- Guild
            [CHAT_CHANNEL_GUILD_1] = false,
            [CHAT_CHANNEL_GUILD_2] = false,
            [CHAT_CHANNEL_GUILD_3] = false,
            [CHAT_CHANNEL_GUILD_4] = false,
            [CHAT_CHANNEL_GUILD_5] = false,
            -- Officer
            [CHAT_CHANNEL_OFFICER_1] = false,
            [CHAT_CHANNEL_OFFICER_2] = false,
            [CHAT_CHANNEL_OFFICER_3] = false,
            [CHAT_CHANNEL_OFFICER_4] = false,
            [CHAT_CHANNEL_OFFICER_5] = false,
        }
    },
}

local alphabet = {
    cyrillic = {
        "Б", "б", "Г", "г", "Д", "д", "Ж", "ж", "З", "з", "И", "и", "Й", "й", "К", "к", "Л", "л", "Н", "н", "П",
        "п", "У", "Ф", "ф", "Ц", "ц", "Ч", "ч", "Ш", "ш", "Щ", "щ", "Ъ", "ъ", "Ы", "ы", "Э", "э", "Ю", "ю", "Я",
        "я", -- "Ђ", "ђ", "Ѓ", "ѓ", "Є", "є", "Љ", "љ", "Њ", "њ", "Ћ", "ћ", "Ќ", "ќ", "Ѝ", "ѝ", "Ў", "ў", "Џ", "џ"
    },
    german = {
        "ä", "ö", "ü"
    },
    french = {
        "é", "à", "ê", "â", "î"
    },
    slavic = {
        "ł", "ą", "ć", "ś", "ę", "ż"
    }
}

local LAM = LibAddonMenu2
local Log

--- Debug output to the console
--@param .. variable parameters to be printed as a debug log
local function Debug(...)
    if Log then
        Log:Debug(...)
    else
        d(...)
    end
end

--- Output to the console
--@param .. variable parameters to be printed as a log
local function Print(...)
    if Log then
        Log:Info(...)
    else
        CHAT_SYSTEM:AddMessage(...)
    end
end

--- Warning output to the console
--@param .. variable parameters to be printed as a log
local function Warn(...)
    if Log then
        Log:Warn(...)
    else
        for i = 1, select("#", ...) do
            -- Print each warning parameter in orange
            CHAT_SYSTEM:AddMessage(zo_strformat("|cFF7900<<1>>|r", select(i, ...)))
        end
    end
end

local function Check(message, table)
    for _, letter in ipairs(table) do
        if string.find(string.lower(message), string.lower(letter)) then return true end
    end
    return false
end

--- Test if message contains letters known to be common in cyrillic languages
-- @param message text to be filtered
function CleanMyChat.IsCyrillic(message)
    return Check(message, alphabet.cyrillic)
end

--- Test if message contains letters known to be common in German
-- @param message text to be filtered
function CleanMyChat.IsGerman(message)
    return Check(message, alphabet.german)
end

--- Test if message contains letters known to be common in French
-- @param message text to be filtered
function CleanMyChat.IsFrench(message)
    return Check(message, alphabet.french)
end

--- Test if message contains letters known to be common in Slavic
-- @param message text to be filtered
function CleanMyChat.IsSlavic(message)
    return Check(message, alphabet.slavic)
end

--- Test if message contains letters previous defined in the custom filter
-- @param message text to be filtered
function CleanMyChat:IsCustom(message)
    return Check(message, self.saved.customFilter)
end


function CleanMyChat:MessageNeedsToBeRemoved(_, ...)
    local channel = select(1, ...)
    local shouldBeFiltered = self.saved.channel[channel]

    if self.saved.debug then
        local channelName = self.channelNames[channel] or "System or World"
        Debug(zo_strformat("Broadcast on channel <<1>>::<<2>>", channel, channelName))
        if shouldBeFiltered then
            Debug("Set to be filtered")
        else
            Debug("Is not set to be filtered")
        end
    end

    if self.saved.filterChannel and not shouldBeFiltered then return false end

    local fromName = zo_strformat("<<1>>", select(2, ...))
    local message = zo_strformat("<<1>>", select(3, ...))
    local displayName = zo_strformat("<<1>>", select(5, ...))

    local removeCyrillicMessage = self.saved.cleanCyrillic and self.IsCyrillic(message)
    local removeGermanMessage = self.saved.cleanGerman and self.IsGerman(message)
    local removeFrenchMessage = self.saved.cleanFrench and self.IsFrench(message)
    local removeSlavicMessage = self.saved.cleanSlavic and self.IsSlavic(message)
    local removeCustomMessage = self.saved.cleanCustom and self:IsCustom(message)
    local removeMessage = removeSlavicMessage or removeFrenchMessage or removeGermanMessage
            or removeCyrillicMessage or removeCustomMessage

    local found = {}
    if removeCyrillicMessage then
        self.saved.statistic.cyrillic = self.saved.statistic.cyrillic + 1
        table.insert(found, "Cyrillic")
    end
    if removeGermanMessage then
        self.saved.statistic.german = self.saved.statistic.german + 1
        table.insert(found, "German")
    end
    if removeFrenchMessage then
        self.saved.statistic.french = self.saved.statistic.french + 1
        table.insert(found, "French")
    end
    if removeSlavicMessage then
        self.saved.statistic.slavic = self.saved.statistic.slavic + 1
        table.insert(found, "Slavic")
    end
    if removeCustomMessage then
        self.saved.statistic.custom = self.saved.statistic.custom + 1
        table.insert(found, "Custom")
    end

    if self.saved.debug then
        Debug(tostring(message))
        if removeMessage then
            Debug(zo_strformat(
                    "Found <<1>> characters in the message.\nIt will be removed if it was not from you.",
                    ZO_GenerateCommaSeparatedList(found)
                )
            )
        end
    end

    -- Don't filter your own message
    if removeMessage and (GetUnitName("player") == fromName or GetDisplayName() == displayName) then
        Warn(zo_strformat("You just wrote with filtered <<1>> characters.\n"
                .. "You might not see responses.\n"
                .."Maybe you want to unset the filter of the language you just used...\n"
                .. "Write /cmc to open the settings menu.",
                ZO_GenerateCommaSeparatedList(found)
        ))
        removeMessage = false
    end

    return removeMessage
end

--- Register filter for chat event
function CleanMyChat:RegisterEvent()
    if self.saved.debug then
        Debug("Register for chat event")
    end
    -- TODO: Change this to a hook
    local function OnChatEvent(control, ...)
        if not self:MessageNeedsToBeRemoved(control, ...) then
            return CHAT_ROUTER.registeredEventHandlers[EVENT_CHAT_MESSAGE_CHANNEL](control, ...)
        end
    end

    EVENT_MANAGER:UnregisterForEvent("ChatRouter", EVENT_CHAT_MESSAGE_CHANNEL)
    EVENT_MANAGER:RegisterForEvent("ChatRouter", EVENT_CHAT_MESSAGE_CHANNEL, OnChatEvent)

    --ZO_PreHook(ZO_ChatSystem_GetEventHandlers(), EVENT_CHAT_MESSAGE_CHANNEL, function(...)
    --    return self:MessageNeedsToBeRemoved(nil, ...)
    --end)
end

--- Register filter for pChat addon
function CleanMyChat:RegisterPChat()
    if self.saved.debug then
        Debug("Register for pChat")
    end
    --- Function intercepts pChat FormatMessage (3457) and mimics its spam detection (Hook idea from Baertram@ESOUI)
    ZO_PreHook(pChat.chatHandlers, EVENT_CHAT_MESSAGE_CHANNEL, function(...)
        return self:MessageNeedsToBeRemoved(nil, ...)
    end)
end

--- Create menu in LibAddonMenu2 settings if available
function CleanMyChat:RegisterSettings()
    local lang = GetCVar("Language.2")
    local link = zo_strformat("https://<<1>>.liberapay.com/Tyx/", lang)
    local panel = {
        type = "panel",
        name = self.name,
        displayName = self.displayName,
        author = zo_strformat("|c5175ea<<1>>|r", self.author),
        version = self.version,
        website = "https://www.esoui.com/downloads/info2544-CleanMyChat.html",
        feedback = "https://github.com/Tyxz/Clean-My-Chat/issues/new/choose",
        donation = link,
        --slashCommand = "/cmc",
        registerForRefresh = true,
        registerForDefaults = true,
        resetFunc = function()
            for k,v in pairs(self.defaults) do
                self.saved[k] = v
            end
        end,
    }

    if LAM then
        CLEAN_MY_CHAT_PANEL = LAM:RegisterAddonPanel(self.name, panel)

        local controls = {}
        for i, _ in pairs(self.defaults.channel) do
            table.insert(controls, {
                type = "checkbox",
                name = self.channelNames[i],
                getFunc = function() return self.saved.channel[i] end,
                setFunc = function(value) self.saved.channel[i] = value end
            })
        end

        local data = {
            {
                type = "description",
                name = "Statistic",
                text = function()
                    local statistic = {}
                    for k,v in pairs(self.saved.statistic) do
                        if self.saved[zo_strformat("clean<<C:1>>", k)] then
                            table.insert(statistic, zo_strformat("<<1>> <<C:2>>", v, k))
                        end
                    end
                    return zo_strformat("<<1>> messages blocked.", ZO_GenerateCommaSeparatedList(statistic))
                end
            },
            {
                type = "checkbox",
                name = "Clean Cyrillic",
                tooltip = table.concat(alphabet.cyrillic, ", "),
                getFunc = function() return self.saved.cleanCyrillic end,
                setFunc = function(value) self.saved.cleanCyrillic = value end
            },
            {
                type = "checkbox",
                name = "Clean German",
                tooltip = table.concat(alphabet.german, ", "),
                getFunc = function() return self.saved.cleanGerman end,
                setFunc = function(value) self.saved.cleanGerman = value end
            },
            {
                type = "checkbox",
                name = "Clean French",
                tooltip = table.concat(alphabet.french, ", "),
                getFunc = function() return self.saved.cleanFrench end,
                setFunc = function(value) self.saved.cleanFrench = value end
            },
            {
                type = "checkbox",
                name = "Clean Slavic",
                tooltip = table.concat(alphabet.slavic, ", "),
                getFunc = function() return self.saved.cleanSlavic end,
                setFunc = function(value) self.saved.cleanSlavic = value end
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
                        if i ~= "" then
                            table.insert(self.saved.customFilter, i)
                        end
                    end
                end
            },
            {
                type = "checkbox",
                name = "Filter channel",
                tooltip = "Filter only specific channels",
                getFunc = function() return self.saved.filterChannel end,
                setFunc = function(value) self.saved.filterChannel = value end
            },
            {
                type = "submenu",
                name = "Channels",
                controls = controls,
                disabled = function() return not self.saved.filterChannel end,
            },
            {
                type = "checkbox",
                name = "Debug",
                getFunc = function() return self.saved.debug end,
                setFunc = function(value)
                    Debug(zo_strformat("Debug output: <<1>>",  value))
                    self.saved.debug = value
                end
            },
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
                        Print(zo_strformat("<<1>>:\t<<2>>", k, v))
                    end
                end
            end
        else
            if command == "filter" then
                Print(zo_strformat("Custom filter:\n<<1>>", table.concat(self.saved.customFilter, ", ")))
            elseif command == "cyrillic" then
                self.saved.cleanCyrillic = not self.saved.cleanCyrillic
                Print(zo_strformat("Cyrillic filter:\t<<1>>", self.saved.cleanCyrillic))
            elseif command == "german" then
                self.saved.cleanGerman = not self.saved.cleanGerman
                Print(zo_strformat("German filter:\t<<1>>", self.saved.cleanGerman))
            elseif command == "french" then
                self.saved.cleanFrench = not self.saved.cleanFrench
                Print(zo_strformat("French filter:\t<<1>>", self.saved.cleanFrench))
            elseif command == "slavic" then
                self.saved.cleanSlavic = not self.saved.cleanSlavic
                Print(zo_strformat("Slavic filter:\t<<1>>", self.saved.cleanSlavic))
            elseif command == "custom" then
                self.saved.cleanCustom = not self.saved.cleanCustom
                Print(zo_strformat("Custom filter:\t<<1>>", self.saved.cleanCustom))
            end
        end
    end
end

--- Function to migrate saved variables without resetting them
function CleanMyChat:Migrate()
    --- Version is 1.0.0
    if not self.saved.lastVersion then
        self.saved.channel = {}
        for i, v in pairs(self.defaults.channel) do
            self.saved.channel[i] = v
        end
        self.saved.statistic = {}
        for k, v in pairs(self.defaults.statistic) do
            self.saved.statistic[k] = v
        end
        self.saved.lastVersion = {
            major = 1,
            minor = 0
        }
    end
    local major, minor = string.match(self.version, "(%d+).(%d+).%d+")
    major, minor = tonumber(major), tonumber(minor)
    local lastVersion = self.saved.lastVersion
    if lastVersion.major < major or lastVersion.minor < minor then
        if self.saved.debug then
            Debug(zo_strformat("Migrate from <<1>>.<<2>> to <<3>>", lastVersion.major, lastVersion.minor, self.version))
        end
    end
    self.saved.lastVersion = {
        major = major,
        minor = minor
    }
end

--- Initialize functions
function CleanMyChat:Initialize()
    if LibDebugLogger then
        Log = LibDebugLogger(self.name)
    end
    self.saved = ZO_SavedVars:NewAccountWide(self.name .. "_Settings", self.savedVersion, nil, self.defaults)
    self:Migrate()
    self:RegisterSettings()
    self:RegisterCommands()
    if pChat then
        self:RegisterPChat()
    else
        self:RegisterEvent()
    end
    return self
end

--Register Loaded Callback
EVENT_MANAGER:RegisterForEvent(
        CleanMyChat.name, EVENT_ADD_ON_LOADED,
        function(_, addOnName)
            if(addOnName ~= CleanMyChat.name) then return end
            CleanMyChat:Initialize()
        end
)
