local AceLocale = LibStub("AceLocale-3.0");
local L = AceLocale:NewLocale("Verity", "enUS", true);

-- BEGIN LOCALIZATION

L["ADDON_TITLE"] = "Verity";

L["GAME_WINDOW_TITLE"] = "$Game Window Title$";

L["GAME_VERSION_FORMAT"] = "Version: v%s";
L["GAME_AUTHOR"] = "Created by Ghost";

L["START_SCREEN_TITLE"] = "$Game Title$";
L["START_SCREEN_BOUNCING_TEXT"] = "$Bouncing Text$";
L["START_SCREEN_NEW_GAME"] = "$New Game$";
L["START_SCREEN_START_GAME"] = "$Start Game$";
L["START_SCREEN_RESUME_GAME"] = "$Resume Game$";
L["START_SCREEN_LOAD_GAME"] = "$Load Game$";
L["START_SCREEN_SETTINGS"] = "$Settings$";
L["START_SCREEN_HELP"] = "$Help$";
L["START_SCREEN_CREDITS"] = "$Credits$";

-- END LOCALIZATION

Verity.Strings = AceLocale:GetLocale("Verity", false);