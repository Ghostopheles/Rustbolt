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

local function GetWorldPanel()
    local panel = GetReflectionPanel();
    return panel.World;
end


---@class RustboltReflectionSystem
local Reflection = {};

function Reflection.GetWorldPanel()
    return GetWorldPanel();
end

---@param obj RustboltObject
---@param name string
function Reflection.AddToInspector(obj, name)
    local inspector = GetInspectorPanel();
    inspector:AddHeader(name);
end

------------

Rustbolt.Reflection = Reflection;



