std = "max+busted+eso"
stds.eso = {
    globals = {
        "CHAT_CHANNEL_SAY",
        "SI_CHAT_CHANNEL_NAME_SAY",
        "CHAT_CHANNEL_YELL",
        "SI_CHAT_CHANNEL_NAME_YELL",
        "CHAT_CHANNEL_EMOTE",
        "SI_CHAT_CHANNEL_NAME_EMOTE",
        "CHAT_CHANNEL_WHISPER",
        "SI_CHAT_CHANNEL_NAME_WHISPER",
        "CHAT_CHANNEL_WHISPER_SENT",
        "CHAT_CHANNEL_ZONE",
        "SI_CHAT_CHANNEL_NAME_ZONE",
        "CHAT_CHANNEL_ZONE_LANGUAGE_1",
        "SI_CHAT_CHANNEL_NAME_ZONE_ENGLISH",
        "CHAT_CHANNEL_ZONE_LANGUAGE_2",
        "SI_CHAT_CHANNEL_NAME_ZONE_FRENCH",
        "CHAT_CHANNEL_ZONE_LANGUAGE_3",
        "SI_CHAT_CHANNEL_NAME_ZONE_GERMAN",
        "CHAT_CHANNEL_ZONE_LANGUAGE_4",
        "SI_CHAT_CHANNEL_NAME_ZONE_JAPANESE",
        "CHAT_CHANNEL_PARTY",
        "SI_CHAT_CHANNEL_NAME_PARTY",
        "CHAT_CHANNEL_GUILD_1",
        "CHAT_CHANNEL_GUILD_2",
        "CHAT_CHANNEL_GUILD_3",
        "CHAT_CHANNEL_GUILD_4",
        "CHAT_CHANNEL_GUILD_5",
        "CHAT_CHANNEL_OFFICER_1",
        "CHAT_CHANNEL_OFFICER_2",
        "CHAT_CHANNEL_OFFICER_3",
        "CHAT_CHANNEL_OFFICER_4",
        "CHAT_CHANNEL_OFFICER_5",
        "CleanMyChat",
        "CLEAN_MY_CHAT_PANEL",
        "CHAT_ROUTER",
        "CHAT_SYSTEM",
        "d",
        "EVENT_ADD_ON_LOADED",
        "EVENT_CHAT_MESSAGE_CHANNEL",
        "EVENT_MANAGER",
        "GetString",
        "LibAddonMenu2",
        "LibDebugLogger",
        "LibFeedback",
        "GetCVar",
        "GetDisplayName",
        "GetUnitName",
        "GetWorldName",
        "pChat",
        "SLASH_COMMANDS",
        "ZO_ChatSystem",
        "ZO_ChatSystem_AddEventHandler",
        "ZO_ChatSystem_GetEventHandlers",
        "ZO_GenerateCommaSeparatedList",
        "ZO_PreHook",
        "ZO_SavedVars",
        "zo_strformat",
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