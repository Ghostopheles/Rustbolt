local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;

---@enum RustboltCVarCategory
local CVarCategory = {
    ENGINE = 1,
    GAME = 2,
    DEBUG = 3,
};

local I_CVarCategory = tInvert(CVarCategory);

------------

---@class RustboltCVar
---@field protected Name string
---@field protected Type string
---@field protected Category RustboltCVarCategory
---@field protected DefaultValue any
---@field protected Value any
local CVar = {};

function CVar:Init(name, type, category, defaultValue)
    self.Name = name;
    self.Type = type;
    self.Category = category;
    self.DefaultValue = defaultValue;
    self.Value = defaultValue;
end

---@param value any
---@param noEvent boolean If true, does not fire the CVAR_VALUE_CHANGED event.
function CVar:SetValue(value, noEvent)
    self.Value = value;

    if not noEvent then
        Registry:TriggerEvent(Events.CVAR_VALUE_CHANGED, self);
    end
end

function CVar:GetValue()
    return self.Value;
end

------------

local function CreateCVar(name, type, category, defaultValue)
    return CreateAndInitFromMixin(CVar, name, type, category, defaultValue);
end

---@class RustboltCVarManager
local CVarManager = {
    CVars = {},
};

function CVarManager:IsCategoryValid(category)
    return I_CVarCategory[category] ~= nil;
end

---Creates and registers a CVar object
---@param name string
---@param type string
---@param category RustboltCVarCategory
---@param defaultValue any
---@return RustboltCVar
function CVarManager:RegisterCVar(name, type, category, defaultValue)
    assert(self.CVars[name] == nil, "Attempt to create duplicate cvar");
    assert(self:IsCategoryValid(category), "Invalid CVar category");

    local cvar = CreateCVar(name, type, category, defaultValue);
    self.CVars[name] = cvar;

    Registry:TriggerEvent(Events.CVAR_CREATED, cvar);
    return cvar;
end

---Returns a table containing all registered CVars
---@return table<RustboltCVar>
function CVarManager:GetAllCVars()
    return self.CVars;
end

---Returns a CVar object. To retrieve only the CVar value, use :GetCVarValue
---@param name string
---@return RustboltCVar? cvar
function CVarManager:GetCVar(name)
    return self.CVars[name];
end

---Returns a CVar value. To retrieve the whole CVar object, use :GetCVar
---@param name string
---@return any cvarValue
function CVarManager:GetCVarValue(name)
    local cvar = self:GetCVar(name);
    if cvar then
        return cvar:GetValue();
    end
end

------------

Rustbolt.CVarCategory = CVarCategory;
Rustbolt.CVarManager = CVarManager;