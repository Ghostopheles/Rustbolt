local IO = {};

local PREFIX = TRANSMOGRIFY_FONT_COLOR:WrapTextInColorCode("Rustbolt") .. ": ";

function IO.Printf(fmt, ...)
    local str = format(fmt, ...);
    IO.Print(str);
end

function IO.Print(...)
    local first = select(1, ...);
    local str = PREFIX .. first;
    if select("#", ...) > 1 then
        print(str, unpack{select(2, ...)});
    else
        print(str);
    end
end

------------

Rustbolt.IO = IO;