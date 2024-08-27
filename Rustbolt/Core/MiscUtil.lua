local MiscUtil = {};

local PREFIX = TRANSMOGRIFY_FONT_COLOR:WrapTextInColorCode("Rustbolt") .. ": ";

function MiscUtil.Printf(fmt, ...);
    local str = format(fmt, ...);
    print(PREFIX .. str);
end

------------

Rustbolt.MiscUtil = MiscUtil;