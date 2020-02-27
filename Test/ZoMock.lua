--[[--------------------------------------------
    Project:    Clock - Tamriel Standard Time
    Author:     Arne Rantzen (Tyx)
    Created:    2020-02-19
    Updated:    2020-02-25
    License:    GPL-3.0
--------------------------------------------]]--

_G.EVENT_ADD_ON_LOADED = 0

_G.GetCVar = function(key)
    if key == "Language.2" then
        return "en"
    end
    return "undefined"
end

_G.EVENT_MANAGER = {}
function _G.EVENT_MANAGER:RegisterForEvent(_, event, func)
    if event == EVENT_ADD_ON_LOADED then
        func(event, "CleanMyChat")
    end
end
function _G.EVENT_MANAGER:UnregisterForEvent(_, _)
end
function _G.EVENT_MANAGER:RegisterForUpdate(_, _, func)
    func()
end
function _G.EVENT_MANAGER:UnregisterForUpdate(_)
end

_G.ZO_SavedVars = {}
function _G.ZO_SavedVars:New(_, _, _, defaults)
    return defaults
end
function _G.ZO_SavedVars:NewAccountWide(_, _, _, defaults)
    return defaults
end

_G.d = function(...)
    for i = 1, select('#', ...) do
        local element = select(i, ...)
        if type(element) == "table" then
            require("pl.pretty").dump(element)
        else
            print(element)
        end
    end
end

_G.zo_strformat = function(str, ...)
    local out = str
    for i = 1, select("#", ...) do
        out = string.gsub(out, "<<".. tostring(i) .. ">>", select(i, ...))
    end
    print(out)
end

_G.SLASH_COMMANDS = {}

_G.CHAT_SYSTEM = {}
function _G.CHAT_SYSTEM:AddMessage(...) _G.d(...) end

function _G.GetString(_) return "Test" end


_G.CHAT_CHANNEL_SAY = 1
_G.CHAT_CHANNEL_YELL = 2
_G.CHAT_CHANNEL_EMOTE = 3
_G.CHAT_CHANNEL_WHISPER = 4
-- Zone
_G.CHAT_CHANNEL_ZONE = 5
_G.CHAT_CHANNEL_ZONE_LANGUAGE_1 = 6
_G.CHAT_CHANNEL_ZONE_LANGUAGE_2 = 7
_G.CHAT_CHANNEL_ZONE_LANGUAGE_3 = 8
_G.CHAT_CHANNEL_ZONE_LANGUAGE_4 = 9
-- Party
_G.CHAT_CHANNEL_PARTY = 10
-- Guild - no generic names found
_G.CHAT_CHANNEL_GUILD_1 = 11
_G.CHAT_CHANNEL_GUILD_2 = 12
_G.CHAT_CHANNEL_GUILD_3 = 13
_G.CHAT_CHANNEL_GUILD_4 = 14
_G.CHAT_CHANNEL_GUILD_5 = 15
-- Officer - no generic names found
_G.CHAT_CHANNEL_OFFICER_1 = 16
_G.CHAT_CHANNEL_OFFICER_2 = 17
_G.CHAT_CHANNEL_OFFICER_3 = 18
_G.CHAT_CHANNEL_OFFICER_4 = 19
_G.CHAT_CHANNEL_OFFICER_5 = 20
