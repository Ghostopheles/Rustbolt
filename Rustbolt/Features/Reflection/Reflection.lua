local Enum = Rustbolt.Enum;
local Engine = Rustbolt.Engine;

local REFLECTION_TYPE = Enum.ReflectionEntryType;

------------

local function GetReflectionPanel()
    local screen = Engine:GetScreenByName(Enum.GameWindowScreen.EDITOR_HOME);
    return screen.ReflectionPanel;
end

local function GetInspectorPanel()
    local panel = GetReflectionPanel();
    return panel.Inspector;
end

------------

---@class RustboltReflectionSystem
local Reflection = {};

function Reflection.GetInspectorPanel()
    return GetInspectorPanel();
end

---@param obj RustboltObject
---@param name string
function Reflection.AddToInspector(obj, name)
    local inspector = GetInspectorPanel();
end

------------

Rustbolt.Reflection = Reflection;



