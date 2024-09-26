local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;

local CVarCategory = Rustbolt.Enum.CVarCategory;
local I_CVarCategory = tInvert(CVarCategory);

------------

---@class RustboltCVar
---@field protected Name string
---@field protected Type string
---@field protected Category RustboltCVarCategory
---@field protected DefaultValue any
---@field protected Value any
---@field protected Ephemeral boolean
local CVar = {};

function CVar:Init(name, type, category, defaultValue, ephemeral)
    self.Name = name;
    self.Type = type;
    self.Category = category;
    self.DefaultValue = defaultValue;
    self.Value = defaultValue;
    self.Ephemeral = ephemeral;
end

function CVar:GetName()
    return self.Name;
end

function CVar:GetType()
    return self.Type;
end

function CVar:GetCategory()
    return self.Category;
end

function CVar:GetDefaultValue()
    return self.DefaultValue;
end

function CVar:GetEphemeral()
    return self.Ephemeral;
end

---@param value any
---@param noEvent? boolean If true, does not fire the CVAR_VALUE_CHANGED event.
function CVar:SetValue(value, noEvent)
    if value == self:GetValue() then
        return;
    end

    self.Value = value;

    if not noEvent then
        Registry:TriggerEvent(Events.CVAR_VALUE_CHANGED, self);
    end

    self:OnValueChanged();
end

function CVar:GetValue()
    return self.Value;
end

function CVar:AddValueChangedCallback(cb, runNow)
    if not self.Callbacks then
        self.Callbacks = {};
    end

    tinsert(self.Callbacks, cb);

    if runNow then
        self:OnValueChanged();
    end
end

function CVar:OnValueChanged()
    if Rustbolt.TableUtil.IsEmpty(self.Callbacks) then
        return;
    end

    local value = self:GetValue();
    for _, cb in ipairs(self.Callbacks) do
        cb(value) -- TODO: probably pcall this
    end
end

------------

local function CreateCVar(name, type, category, defaultValue, ephemeral)
    return CreateAndInitFromMixin(CVar, name, type, category, defaultValue, ephemeral);
end

---@class RustboltCVarManager
local CVarManager = {
    CVars = {},
};

function CVarManager:ValidateSavedVars()
    if not RustboltConfig then
        RustboltConfig = {};
    end

    if not RustboltConfig.CVars then
        RustboltConfig.CVars = {};
    end
end

function CVarManager:OnAddonLoaded()
    self:ValidateSavedVars();

    for _, v in pairs(RustboltConfig.CVars) do
        if self.CVars[v.Name] then
            -- cvar has already been registered from elsewhere
            self.CVars[v.Name]:SetValue(v.Value);
        else
            -- cvar hasn't been registered, so create it from saved variables
            local cvar = CreateCVar(v.Name, v.Type, v.Category, v.DefaultValue);
            cvar:SetValue(v.Value);
            CVarManager.CVars[v.Name] = cvar;
        end
    end

    Registry:TriggerEvent(Events.CVARS_LOADED);
end

function CVarManager:OnAddonUnloading()
    for _, cvar in pairs(self.CVars) do
        if not cvar:GetEphemeral() then
            RustboltConfig.CVars[cvar:GetName()] = {
                Name = cvar:GetName(),
                Type = cvar:GetType(),
                Category = cvar:GetCategory(),
                DefaultValue = cvar:GetDefaultValue(),
                Value = cvar:GetValue(),
            };
        end
    end
end

---@param category any
---@return boolean isValidCategory
function CVarManager:IsCategoryValid(category)
    return I_CVarCategory[category] ~= nil;
end

---Creates and registers a CVar object
---@param name string
---@param type string
---@param category RustboltCVarCategory
---@param defaultValue any
---@param ephemeral? boolean
---@return RustboltCVar
function CVarManager:RegisterCVar(name, type, category, defaultValue, ephemeral)
    assert(not self:CVarExists(name), "Attempt to register duplicate CVar");
    assert(self:IsCategoryValid(category), "Invalid CVar category");

    local cvar = CreateCVar(name, type, category, defaultValue, ephemeral);
    self.CVars[name] = cvar;

    Registry:TriggerEvent(Events.CVAR_CREATED, cvar);
    return cvar;
end

---@param name string
function CVarManager:DeleteCVar(name)
    self.CVars[name] = nil;
    Registry:TriggerEvent(Events.CVAR_DELETED, name);
end

---Returns a table containing all registered CVars
---@return table<RustboltCVar>
function CVarManager:GetAllCVars()
    return self.CVars;
end

---@param name string CVar name
---@return boolean cvarExists
function CVarManager:CVarExists(name)
    return self:GetCVarObject(name) ~= nil;
end

---Returns a CVar object. To retrieve only the CVar value, use :GetCVar
---@param name string
---@return RustboltCVar? cvar
function CVarManager:GetCVarObject(name)
    return self.CVars[name];
end

---Returns a CVar value
---@param name string
---@return any cvarValue
function CVarManager:GetCVar(name)
    local cvar = self:GetCVarObject(name);
    if cvar then
        return cvar:GetValue();
    end
end

---Sets the value of a CVar
---@param name string CVar name
---@param value any CVar value
function CVarManager:SetCVar(name, value, noEvent)
    local cvar = self:GetCVarObject(name);
    if cvar then
        cvar:SetValue(value, noEvent);
    end
end

Registry:RegisterCallback(Events.ADDON_LOADED, CVarManager.OnAddonLoaded, CVarManager);
Registry:RegisterCallback(Events.ADDON_UNLOADING, CVarManager.OnAddonUnloading, CVarManager);

------------

Rustbolt.CVarManager = CVarManager;

Registry:TriggerEvent(Events.CVAR_MANAGER_LOADED);