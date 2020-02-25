describe("CleanMyChat", function()
    setup(function()
        require("Test.ZoMock")
        require("Lib.CleanMyChat")
    end)
    describe("Cyrillic", function()
        it("should filter return true if text is only cyrillic letters", function()
            local tMessage = "нибудь из присутствующих"
            local tResult = CleanMyChat.IsCyrillic(tMessage)
            assert.truthy(tResult)
        end)
        it("should filter return true if text contains cyrillic letters", function()
            local tMessage = "Hello, присутствующих test"
            local tResult = CleanMyChat.IsCyrillic(tMessage)
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
            local tMessage = "Hallo, könnten du aufhören?"
            local tResult = CleanMyChat.IsGerman(tMessage)
            assert.truthy(tResult)
        end)
        it("should filter return false if text contains no german letters", function()
            local tMessage = "Hello, is anybody here?"
            local tResult = CleanMyChat.IsGerman(tMessage)
            assert.falsy(tResult)
        end)
    end)

end)