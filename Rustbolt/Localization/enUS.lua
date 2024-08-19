local AceLocale = LibStub("AceLocale-3.0");
local L = AceLocale:NewLocale("Rustbolt", "enUS", true);

-- BEGIN LOCALIZATION

L["ADDON_TITLE"] = "Rustbolt";

L["WINDOW_TITLE"] = "Rustbolt Engine (Dev)";

L["VERSION_FORMAT"] = "Version: v%s";
L["AUTHOR"] = "Created by Ghost";

L["START_SCREEN_TITLE"] = "$Game Title$";
L["START_SCREEN_BOUNCING_TEXT"] = "$Bouncing Text$";
L["START_SCREEN_NEW_GAME"] = "$New Game$";
L["START_SCREEN_START_GAME"] = "$Start Game$";
L["START_SCREEN_RESUME_GAME"] = "$Resume Game$";
L["START_SCREEN_LOAD_GAME"] = "$Load Game$";
L["START_SCREEN_SETTINGS"] = "$Settings$";
L["START_SCREEN_HELP"] = "$Help$";
L["START_SCREEN_CREDITS"] = "$Credits$";

L["CAMPAIGN_NEW_PH"] = "New Campaign";
L["CAMPAIGN_WINDOW_TITLE"] = "Playing: %s";

L["NOTIFICATION_TRAY_TITLE"] = "Notifications";

-- END LOCALIZATION

Rustbolt.Strings = AceLocale:GetLocale("Rustbolt", false);