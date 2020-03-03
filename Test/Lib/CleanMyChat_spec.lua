describe("CleanMyChat", function()
    local match
    setup(function()
        match = require("luassert.match")
        require("Test.ZoMock")
        stub(_G, "d")
    end)
    insulate("Functions", function()
        local tCyrillic = "Алло, не могли бы вы остановиться?"
        local tGerman = "Hallo, könnten du aufhören?"
        local tFrench = "Bonjour, pouvez-vous vous arrêter?"
        local tSlavic = "Halo, możesz przestać?"
        local tNordic = "Forhåbentlig kan du høre mig"
        local tSpanish = "Hola, ¿podrías parar?"
        setup(function()
            require("Lib.CleanMyChat")
            stub(_G, "d")
        end)
        describe("Cyrillic", function()
            it("should filter return true if text is only cyrillic letters", function()
                local tMessage = "нибудь из присутствующих"
                local tResult = CleanMyChat.IsCyrillic(tMessage)
                assert.truthy(tResult)
            end)
            it("should filter return true if text contains cyrillic letters", function()
                local tResult = CleanMyChat.IsCyrillic(tCyrillic)
                assert.truthy(tResult)
            end)
            it("should filter return false if text contains no cyrillic letters", function()
                local tMessage = "Hellö, is anybody here?"
                local tResult = CleanMyChat.IsCyrillic(tMessage)
                assert.falsy(tResult)
            end)
        end)
        describe("German", function()
            it("should filter return true if text is only german letters", function()
                local tMessage = "äöüöäöüüäöö äöäüö"
                local tResult = CleanMyChat.IsGerman(tMessage)
                assert.truthy(tResult)
            end)
            it("should filter return true if text contains german letters", function()
                local tResult = CleanMyChat.IsGerman(tGerman)
                assert.truthy(tResult)
            end)
            it("should filter return false if text contains no german letters", function()
                local tMessage = "Hello, is anybody here?"
                local tResult = CleanMyChat.IsGerman(tMessage)
                assert.falsy(tResult)
            end)
        end)
        describe("French", function()
            it("should filter return true if text is only french letters", function()
                local tMessage = "éàêâî"
                local tResult = CleanMyChat.IsFrench(tMessage)
                assert.truthy(tResult)
            end)
            it("should filter return true if text contains french letters", function()
                local tResult = CleanMyChat.IsFrench(tFrench)
                assert.truthy(tResult)
            end)
            it("should filter return false if text contains no french letters", function()
                local tMessage = "Hellö, is anybody here?"
                local tResult = CleanMyChat.IsFrench(tMessage)
                assert.falsy(tResult)
            end)
        end)
        describe("Slavic", function()
            it("should filter return true if text is only slavic letters", function()
                local tMessage = "łąćśęż"
                local tResult = CleanMyChat.IsSlavic(tMessage)
                assert.truthy(tResult)
            end)
            it("should filter return true if text contains slavic letters", function()
                local tResult = CleanMyChat.IsSlavic(tSlavic)
                assert.truthy(tResult)
            end)
            it("should filter return false if text contains no slavic letters", function()
                local tMessage = "Hellö, is anybody here?"
                local tResult = CleanMyChat.IsSlavic(tMessage)
                assert.falsy(tResult)
            end)
        end)
        describe("Nordic", function()
            it("should filter return true if text is only nordic letters", function()
                local tMessage = "ø å"
                local tResult = CleanMyChat.IsNordic(tMessage)
                assert.truthy(tResult)
            end)
            it("should filter return true if text contains nordic letters", function()
                local tResult = CleanMyChat.IsNordic(tNordic)
                assert.truthy(tResult)
            end)
            it("should filter return false if text contains no nordic letters", function()
                local tMessage = "Hello, is anybody here?"
                local tResult = CleanMyChat.IsNordic(tMessage)
                assert.falsy(tResult)
            end)
        end)
        describe("Spanish", function()
            it("should filter return true if text is only spanish letters", function()
                local tMessage = "áíóúñ¿¡"
                local tResult = CleanMyChat.IsSpanish(tMessage)
                assert.truthy(tResult)
            end)
            it("should filter return true if text contains spanish letters", function()
                local tResult = CleanMyChat.IsSpanish(tSpanish)
                assert.truthy(tResult)
            end)
            it("should filter return false if text contains no spanish letters", function()
                local tMessage = "Hello, is anybody here?"
                local tResult = CleanMyChat.IsSpanish(tMessage)
                assert.falsy(tResult)
            end)
        end)
        insulate("Custom", function()
            local tFilter = "test"
            local tFilterSentence = "This is a test"
            local CMC
            setup(function()
                CMC = CleanMyChat:Initialize()
            end)
            it("should set custom filter", function()
                CMC.saved.customFilter = { tFilter }
                assert.same(CMC.saved.customFilter, { tFilter })
            end)
            it("should filter return true if text is only french letters", function()
                local tResult = CMC:IsCustom(tFilter)
                assert.truthy(tResult)
            end)
            it("should filter return true if text contains french letters", function()
                local tResult = CMC:IsCustom(tFilterSentence)
                assert.truthy(tResult)
            end)
            it("should filter return false if text contains no french letters", function()
                local tMessage = "Hellö, is anybody here?"
                local tResult = CMC:IsCustom(tMessage)
                assert.falsy(tResult)
            end)
        end)

        describe("MessageNeedsToBeRemoved", function()
            local tChannel, tFromName, CMC
            local tFilter = "test"
            local tCustom = "This is a test"
            setup(function()
                tFromName = "@Test"
                CMC = CleanMyChat:Initialize()
                CMC.saved.customFilter = { tFilter }
            end)
            describe("Filter", function()
                local function check(tText, tDisplayName)
                    tChannel = CHAT_CHANNEL_SAY
                    local tResult = CMC:MessageNeedsToBeRemoved(tChannel, tFromName, tText, false, tDisplayName)
                    return tResult
                end
                insulate("Cyrillic", function()
                    it("should filter cyrillic message if set to filter", function()
                        CMC.saved.cleanCyrillic = true
                        assert.truthy(check(tCyrillic, "Player"))
                    end)
                    it("should not filter cyrillic message if not set to filter", function()
                        CMC.saved.cleanCyrillic = false
                        assert.falsy(check(tCyrillic, "Player"))
                    end)
                    it("should not filter cyrillic message if set to filter but from player", function()
                        CMC.saved.cleanCyrillic = true
                        assert.falsy(check(tCyrillic, "Test"))
                    end)
                    it("should warn player if own message would be filtered", function()
                        CMC.saved.cleanCyrillic = true
                        assert.falsy(check(tCyrillic, "Test"))
                        assert.stub(_G.d).was_called()
                    end)
                    it("should update the statistic if filtered", function()
                        CMC.saved.cleanCyrillic = true
                        local tExpected = CMC.saved.statistic.cyrillic + 1
                        check(tCyrillic, "Player")
                        local tResult = CMC.saved.statistic.cyrillic
                        assert.truthy(tExpected, tResult)
                    end)
                end)
                insulate("German", function()
                    it("should filter german message if set to filter", function()
                        CMC.saved.cleanGerman = true
                        assert.truthy(check(tGerman, "Player"))
                    end)
                    it("should not filter german message if not set to filter", function()
                        CMC.saved.cleanGerman = false
                        assert.falsy(check(tGerman, "Player"))
                    end)
                    it("should not filter german message if set to filter but from player", function()
                        CMC.saved.cleanGerman = true
                        assert.falsy(check(tGerman, "Test"))
                    end)
                    it("should warn player if own message would be filtered", function()
                        CMC.saved.cleanGerman = true
                        assert.falsy(check(tGerman, "Test"))
                        assert.stub(_G.d).was_called()
                    end)
                    it("should update the statistic if filtered", function()
                        CMC.saved.cleanGerman = true
                        local tExpected = CMC.saved.statistic.german + 1
                        check(tGerman, "Player")
                        local tResult = CMC.saved.statistic.german
                        assert.truthy(tExpected, tResult)
                    end)
                end)
                insulate("French", function()
                    it("should filter french message if set to filter", function()
                        CMC.saved.cleanFrench = true
                        assert.truthy(check(tFrench, "Player"))
                    end)
                    it("should not filter french message if not set to filter", function()
                        CMC.saved.cleanFrench = false
                        assert.falsy(check(tFrench, "Player"))
                    end)
                    it("should not filter french message if set to filter but from player", function()
                        CMC.saved.cleanFrench = true
                        assert.falsy(check(tFrench, "Test"))
                    end)
                    it("should warn player if own message would be filtered", function()
                        CMC.saved.cleanFrench = true
                        assert.falsy(check(tFrench, "Test"))
                        assert.stub(_G.d).was_called()
                    end)
                    it("should update the statistic if filtered", function()
                        CMC.saved.cleanFrench = true
                        local tExpected = CMC.saved.statistic.french + 1
                        check(tFrench, "Player")
                        local tResult = CMC.saved.statistic.french
                        assert.truthy(tExpected, tResult)
                    end)
                end)
                insulate("Slavic", function()
                    it("should filter slavic message if set to filter", function()
                        CMC.saved.cleanSlavic = true
                        assert.truthy(check(tSlavic, "Player"))
                    end)
                    it("should not filter slavic message if not set to filter", function()
                        CMC.saved.cleanSlavic = false
                        assert.falsy(check(tSlavic, "Player"))
                    end)
                    it("should not filter slavic message if set to filter but from player", function()
                        CMC.saved.cleanSlavic = true
                        assert.falsy(check(tSlavic, "Test"))
                    end)
                    it("should warn player if own message would be filtered", function()
                        CMC.saved.cleanSlavic = true
                        assert.falsy(check(tSlavic, "Test"))
                        assert.stub(_G.d).was_called()
                    end)
                    it("should update the statistic if filtered", function()
                        CMC.saved.cleanSlavic = true
                        local tExpected = CMC.saved.statistic.slavic + 1
                        check(tSlavic, "Player")
                        local tResult = CMC.saved.statistic.slavic
                        assert.truthy(tExpected, tResult)
                    end)
                end)
                insulate("Nordic", function()
                    it("should filter nordic message if set to filter", function()
                        CMC.saved.cleanNordic = true
                        assert.truthy(check(tNordic, "Player"))
                    end)
                    it("should not filter nordic message if not set to filter", function()
                        CMC.saved.cleanNordic = false
                        assert.falsy(check(tNordic, "Player"))
                    end)
                    it("should not filter nordic message if set to filter but from player", function()
                        CMC.saved.cleanNordic = true
                        assert.falsy(check(tNordic, "Test"))
                    end)
                    it("should warn player if own message would be filtered", function()
                        CMC.saved.cleanNordic = true
                        assert.falsy(check(tNordic, "Test"))
                        assert.stub(_G.d).was_called()
                    end)
                    it("should update the statistic if filtered", function()
                        CMC.saved.cleanNordic = true
                        local tExpected = CMC.saved.statistic.nordic + 1
                        check(tNordic, "Player")
                        local tResult = CMC.saved.statistic.nordic
                        assert.truthy(tExpected, tResult)
                    end)
                end)
                insulate("Spanish", function()
                    it("should filter spanish message if set to filter", function()
                        CMC.saved.cleanSpanish = true
                        assert.truthy(check(tSpanish, "Player"))
                    end)
                    it("should not filter spanish message if not set to filter", function()
                        CMC.saved.cleanSpanish = false
                        assert.falsy(check(tSpanish, "Player"))
                    end)
                    it("should not filter spanish message if set to filter but from player", function()
                        CMC.saved.cleanSpanish = true
                        assert.falsy(check(tSpanish, "Test"))
                    end)
                    it("should warn player if own message would be filtered", function()
                        CMC.saved.cleanSpanish = true
                        assert.falsy(check(tSpanish, "Test"))
                        assert.stub(_G.d).was_called()
                    end)
                    it("should update the statistic if filtered", function()
                        CMC.saved.cleanSpanish = true
                        local tExpected = CMC.saved.statistic.spanish + 1
                        check(tSpanish, "Player")
                        local tResult = CMC.saved.statistic.spanish
                        assert.truthy(tExpected, tResult)
                    end)
                end)
                insulate("Custom", function()
                    it("should filter custom message if set to filter", function()
                        CMC.saved.cleanCustom = true
                        assert.truthy(check(tCustom, "Player"))
                    end)
                    it("should not filter custom message if not set to filter", function()
                        CMC.saved.cleanCustom = false
                        assert.falsy(check(tCustom, "Player"))
                    end)
                    it("should not filter custom message if set to filter but from player", function()
                        CMC.saved.cleanCustom = true
                        assert.falsy(check(tCustom, "Test"))
                    end)
                    it("should warn player if own message would be filtered", function()
                        CMC.saved.cleanCustom = true
                        assert.falsy(check(tCustom, "Test"))
                        assert.stub(_G.d).was_called()
                    end)
                    it("should update the statistic if filtered", function()
                        CMC.saved.cleanCustom = true
                        local tExpected = CMC.saved.statistic.custom + 1
                        check(tCustom, "Player")
                        local tResult = CMC.saved.statistic.custom
                        assert.truthy(tExpected, tResult)
                    end)
                end)
            end)
        end)
    end)

    insulate("Commands", function()
        insulate("LibAddonMenu", function()
            setup(function()
                _G.LibAddonMenu2 = {}
                function _G.LibAddonMenu2:RegisterAddonPanel(_, _) end
                function _G.LibAddonMenu2:RegisterOptionControls(_, _) end
                function _G.LibAddonMenu2:OpenToPanel(_) end
                stub(_G.LibAddonMenu2, "OpenToPanel")
                require("Lib.CleanMyChat")
            end)

            it("should open Libaddonmenu if installed and no command given", function()
                SLASH_COMMANDS["/cmc"]("")
                assert.stub(LibAddonMenu2.OpenToPanel).was_called()
            end)
        end)
        describe("without libaddonmenu", function()
            local cmd, CMC
            setup(function()
                require("Lib.CleanMyChat")
                CMC = CleanMyChat:Initialize()
                cmd = SLASH_COMMANDS["/cmc"]
            end)

            it("should print settings if no command given", function()
                cmd("")
                assert.stub(_G.d).was_called()
            end)
            it("should print filter", function()
                CMC.customFilter = {"test"}
                cmd("filter")
                assert.stub(_G.d).was_called()
            end)
            describe("toggle", function()
                it("should toggle cyrillic", function()
                    local tExpected = not CMC.saved.cleanCyrillic
                    cmd("cyrillic")
                    assert.same(tExpected, CMC.saved.cleanCyrillic)
                end)
                it("should toggle german", function()
                    local tExpected = not CMC.saved.cleanGerman
                    cmd("german")
                    assert.same(tExpected, CMC.saved.cleanGerman)
                end)
                it("should toggle french", function()
                    local tExpected = not CMC.saved.cleanFrench
                    cmd("french")
                    assert.same(tExpected, CMC.saved.cleanFrench)
                end)
                it("should toggle slavic", function()
                    local tExpected = not CMC.saved.cleanSlavic
                    cmd("slavic")
                    assert.same(tExpected, CMC.saved.cleanSlavic)
                end)
                it("should toggle nordic", function()
                    local tExpected = not CMC.saved.cleanNordic
                    cmd("nordic")
                    assert.same(tExpected, CMC.saved.cleanNordic)
                end)
                it("should toggle spanish", function()
                    local tExpected = not CMC.saved.cleanSpanish
                    cmd("spanish")
                    assert.same(tExpected, CMC.saved.cleanSpanish)
                end)
                it("should toggle custom", function()
                    local tExpected = not CMC.saved.cleanCustom
                    cmd("custom")
                    assert.same(tExpected, CMC.saved.cleanCustom)
                end)
            end)

        end)
    end)

    insulate("Register", function()
        setup(function()
            _G.LibAddonMenu2 = {}
            function _G.LibAddonMenu2:RegisterAddonPanel(_, _) end
            function _G.LibAddonMenu2:RegisterOptionControls(_, _) end
            _G.LibFeedback = {}
            function _G.LibFeedback:initializeFeedbackWindow(_, _, _, _, _, _, _) end
            require("Lib.CleanMyChat")
        end)
        it("should register pChat hook if pChat is active", function()
            _G.pChat = {}
            stub(_G, "ZO_PreHook")
            CleanMyChat:Initialize()
            assert.stub(_G.ZO_PreHook).was_called.with(match.is_ref(pChat), "FormatMessage", match.is_function())
        end)
        it("should register esoui hook if pChat is not active", function()
            stub(_G, "ZO_PreHook")
            _G.pChat = nil
            CleanMyChat:Initialize()
            assert.stub(_G.ZO_PreHook).was_called.with(match.is_ref(ZO_ChatSystem_GetEventHandlers()),
                    EVENT_CHAT_MESSAGE_CHANNEL, match.is_function())
        end)
        it("should register settings menu if LibAddonMenu is active", function()
            stub(_G.LibAddonMenu2, "RegisterAddonPanel")
            stub(_G.LibAddonMenu2, "RegisterOptionControls")
            CleanMyChat:Initialize()
            assert.stub(_G.LibAddonMenu2.RegisterAddonPanel).was_called()
            assert.stub(_G.LibAddonMenu2.RegisterOptionControls).was_called()
        end)
        it("should register feedback if LibAddonMenu and LibFeedback are active", function()
            stub(_G.LibFeedback, "initializeFeedbackWindow")
            CleanMyChat:Initialize()
            assert.stub(_G.LibFeedback.initializeFeedbackWindow).was_called()
        end)
        it("should register commands", function()
            CleanMyChat:Initialize()
            assert.is.same("function", type(SLASH_COMMANDS["/cmc"]))
        end)
        it("should add channel and statistic to v1.0.0", function()
            local CMC = CleanMyChat:Initialize()
            CMC.saved.channel = nil
            CMC.saved.statistic = nil
            CMC.saved.lastVersion = nil
            CMC:Migrate()
            assert.is.same(CleanMyChat.defaults.statistic, CMC.saved.statistic)
            assert.is.same(CleanMyChat.defaults.channel, CMC.saved.channel)
            assert.is.same(CleanMyChat:GetVersion(), CMC.saved.lastVersion)
        end)
    end)
end)