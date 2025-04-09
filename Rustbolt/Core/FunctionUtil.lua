---@class RustboltFunctionUtil
local FunctionUtil = {};

function FunctionUtil.Debounce(timeout, callback)
    local calls = 0;

	local function Decrement()
		calls = calls - 1;

		if calls == 0 then
			callback();
		end
	end

	return function()
		C_Timer.After(timeout, Decrement);
		calls = calls + 1;
	end
end

------------

Rustbolt.FunctionUtil = FunctionUtil;