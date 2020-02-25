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

_G.SLASH_COMMANDS = {}

_G.CHAT_SYSTEM = {}
function _G.CHAT_SYSTEM:AddMessage(...) _G.d(...) end
