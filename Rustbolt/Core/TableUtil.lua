---@class RustboltTableUtil
local TableUtil = {};

function TableUtil.IsEmpty(tbl)
    if not tbl then
        return true;
    end

    return next(tbl) == nil;
end

------------

Rustbolt.TableUtil = TableUtil;