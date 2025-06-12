-- === CONFIGURATION ===
local SERVER_NAME = "netherwing"  -- Change this to e.g. "mistblade" or any other Stormforge server if needed
local BASE_URL = "https://logs.stormforge.gg/en/character/" .. SERVER_NAME .. "/"

-- === POPUP DEFINITION ===
StaticPopupDialogs["STORMFORGE_COPY"] = {
    text = "Press Ctrl+C to copy the Armory link:",
    button1 = "Close",
    hasEditBox = true,
    editBoxWidth = 350,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
    OnShow = function(self)
        local editBox = self.editBox
        editBox:SetFocus()
        editBox:HighlightText()
    end,
}

-- === CLICK HANDLER ===
local function OnHyperlinkClick(self, link, text, button)
    if IsAltKeyDown() and button == "LeftButton" then
        local linkType, raw = link:match("^(.-):(.+)$")
        if linkType == "player" and raw then
            local playerName = raw:match("^([^:]+)") or raw
            playerName = playerName:match("^[^%-]+") -- remove realm if present
            local url = BASE_URL .. playerName

            local dialog = StaticPopup_Show("STORMFORGE_COPY")
            if dialog then
                dialog.editBox:SetText(url)
                dialog.editBox:HighlightText()
            end
        end
    end
end

-- === HOOK CHAT WINDOWS ===
for i = 1, NUM_CHAT_WINDOWS do
    _G["ChatFrame"..i]:HookScript("OnHyperlinkClick", OnHyperlinkClick)
end
