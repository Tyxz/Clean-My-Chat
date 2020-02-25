std = "max+busted+eso"
stds.eso = {
    globals = {
        "CleanMyChat",
        "CLEAN_MY_CHAT_PANEL",
        "CHAT_ROUTER",
        "CHAT_SYSTEM",
        "d",
        "EVENT_ADD_ON_LOADED",
        "EVENT_CHAT_MESSAGE_CHANNEL",
        "EVENT_MANAGER",
        "LibAddonMenu2",
        "LibFeedback",
        "GetCVar",
        "GetDisplayName",
        "GetUnitName",
        "GetWorldName",
        "SLASH_COMMANDS",
        "ZO_SavedVars",
    },
}
self = false
exclude_files = {
    "Test/ZOMock.lua",
}
include_files = {
    "Lib/**/*.lua",
    "Test/**/*.lua"
}