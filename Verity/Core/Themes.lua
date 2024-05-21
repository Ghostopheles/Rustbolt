--- THEMES FOR THE UI ONLY
local Events = Verity.Events;
local Registry = Verity.EventRegistry;

---@class VerityThemeManager
local ThemeManager = {};

local THEME_NAMES = {
    DEFAULT = "DEFAULT",
};
Verity.Enum.ThemeName = THEME_NAMES;

ThemeManager.ThemedTextures = {};
ThemeManager.CurrentTheme = THEME_NAMES.DEFAULT;
ThemeManager.ThemeStore = {};

ThemeManager.ThemeStore[THEME_NAMES.DEFAULT] = {
    START_SCREEN_BG = "islands-queue-background",
    START_SCREEN_BUTTON_STACK_BG = "auctionhouse-background-buy-commodities-market"
};

function ThemeManager:GetTexture(textureKey)
    local theme = self:GetCurrentTheme();
    return self.ThemeStore[theme][textureKey];
end

function ThemeManager:GetTheme(themeName)
    return self.ThemeStore[themeName];
end

function ThemeManager:GetCurrentTheme()
    return self.CurrentTheme;
end

function ThemeManager:SetTheme(themeName)
    if not self.ThemeStore[themeName] then
        return;
    end

    self.CurrentTheme = themeName;
    Registry:TriggerEvent(Events.UI_THEME_CHANGED, themeName);
end

function ThemeManager:RegisterThemedTexture(object, textureKey)
    object.TextureKey = textureKey;
    local atlas = self:GetTexture(textureKey);
    object:SetAtlas(atlas);

    self.ThemedTextures[object] = textureKey;
end

function ThemeManager:OnThemeChanged(newTheme)
    local theme = self:GetTheme(newTheme);
    for obj, textureKey in pairs(self.ThemedTextures) do
        obj:SetAtlas(theme[textureKey]);
    end
end

------------

Verity.ThemeManager = ThemeManager;
Registry:RegisterCallback(Events.UI_THEME_CHANGED, ThemeManager.OnThemeChanged, ThemeManager);