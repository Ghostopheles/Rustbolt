---@class VerityMathUtil
local MathUtil = {};

--- Calculates x, y grid coordinates for a given index
---@param index number
---@param maxWidth number
---@return integer, integer
function MathUtil.CalculateCoordinatesFromIndex(index, maxWidth)
    local x = (index - 1) % maxWidth;
    local y = floor((index - 1) / maxWidth);
    return x, y;
end

------------

Verity.MathUtil = MathUtil;