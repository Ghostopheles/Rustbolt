---@class VerityClassUtil
local ClassUtil = {};

function ClassUtil:AddAttribute(object, name, defaultValue)
    assert(object[name] == nil, "Cannot add attribute '" .. name .. "': An attribute with that name already exists.");

    object[name] = defaultValue;

    object["Get"..name] = function(obj)
        return obj[name];
    end

    object["Set"..name] = function(obj, value)
        obj[name] = value;
    end
end

------------

Verity.ClassUtil = ClassUtil;