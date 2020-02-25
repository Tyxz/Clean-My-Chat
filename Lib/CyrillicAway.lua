local CyrillicAway = {
	name = "Cyrillic Away",
	version = 1,
	author = "Tyx",
	alphabet = {
		"Б", "б", "Г", "г", "Д", "д", "Ж", "ж", "З", "з", "И", "и", "Й", "й", "К", "к", "Л", "л", "Н", "н", "П",
		"п", "У", "Ф", "ф", "Ц", "ц", "Ч", "ч", "Ш", "ш", "Щ", "щ", "Ъ", "ъ", "Ы", "ы", "Э", "э", "Ю", "ю", "Я",
		"я", "Ђ", "ђ", "Ѓ", "ѓ", "Є", "є", "Љ", "љ", "Њ", "њ", "Ћ", "ћ", "Ќ", "ќ", "Ѝ", "ѝ", "Ў", "ў", "Џ", "џ",
	},
}


function CyrillicAway.IsCyrillic(message)
	-- detect possible cyrillic characters in the message
	for letter in CyrillicAway.alphabet do
		if string.find(message, letter) then return true end
	end
	return false
end

function CyrillicAway:RegisterEvent()
	
	local function IsCyrillicMessage(eventType, ...)
		if eventType ~= EVENT_CHAT_MESSAGE_CHANNEL then 
			return false
		end
				
		local fromName = tostring(select(2, ...))
		local message = tostring(select(3, ...))

		if GetUnitName("player") == fromName or GetDisplayName() == fromName then
			return false
		end
		
		return self.IsCyrillic(message)
		
	end

	local function OnChatEvent(control, ...)
		if IsCyrillicMessage(...) then
			-- the message contained cyrillic characters,
			-- so it will be filtered out
			return
		end
		
		-- the message did not contain cyrillic characters,
		-- so it will not be filtered out
		CHAT_SYSTEM.OnChatEvent(control, ...)
	end

	EVENT_MANAGER:UnregisterForEvent("ChatRouter", EVENT_CHAT_MESSAGE_CHANNEL)
	EVENT_MANAGER:RegisterForEvent("ChatRouter", EVENT_CHAT_MESSAGE_CHANNEL, OnChatEvent)
end

function CyrillicAway:Initialize()
	self:RegisterEvent()
end

--Register Loaded Callback
EVENT_MANAGER:RegisterForEvent(
    CyrillicAway.name, EVENT_ADD_ON_LOADED,
    function(_, addOnName)
        if(addOnName ~= "CyrillicAway") then return end
        CyrillicAway:Initialize()
    end
)