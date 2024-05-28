local SCREENS_ALL = "all";
local DOUBLE_TAP_TIMEOUT = 0.25;

---@class VerityInputContext
local InputContextBase = {
    OnUp = false,
    Hold = false,
    DoubleTap = false,
    Screens = {}
};

function InputContextBase:Init(onUp, hold, doubleTap, screens)
    self.OnUp = onUp or false;
    self.Hold = hold or false;
    self.DoubleTap = doubleTap or false;
    self.Screens = screens or SCREENS_ALL;
end

------------

---@class VerityInputListener
local InputListenerBase = {
    Context = InputContextBase,
    Callback = function() end,
    Owner = nil,
};

function InputListenerBase:Init(context, callback, owner)
    self.Context = context;
    self.Callback = callback;
    self.Owner = owner;
end

------------

---@class VerityInputManager
---@field Keys table<string, table<VerityInputListener>>
local InputManager = {
    Keys = {},
    HandlingKeyDown = false,
    HandlingKeyUp = false,
    LastKey = nil,
};

---@param onUp? boolean
---@param hold? boolean
---@param doubleTap? boolean
---@param screens? table | string
---@return VerityInputContext
function InputManager:CreateInputContext(onUp, hold, doubleTap, screens)
    return CreateAndInitFromMixin(InputContextBase, onUp, hold, doubleTap, screens);
end

---@param context VerityInputContext
---@param callback function
---@param owner table
---@return VerityInputListener
function InputManager:CreateInputListener(context, callback, owner)
    return CreateAndInitFromMixin(InputListenerBase, context, callback, owner);
end

--- Creates and registers an input listener
---@param key string
---@param callback function
---@param owner table
---@param context? VerityInputContext | string
---@return VerityInputListener
function InputManager:RegisterInputListener(key, callback, owner, context)
    if not self.Keys[key] then
        self.Keys[key] = {};
    end

    if type(context) == "string" then
        local screens = context ~= SCREENS_ALL and {[context] = true} or SCREENS_ALL;
        context = self:CreateInputContext(nil, nil, nil, screens);
    end

    if not context then
        context = self:CreateInputContext();
    end

    DevTools_Dump(context);

    local listener = self:CreateInputListener(context, callback, owner);
    tinsert(self.Keys[key], listener);

    return listener;
end

function InputManager:HandleInputError(key, message)
    print("Error handling input for key '" .. key .. "'\n" .. message);
end



function InputManager:ShouldPropagateKey(key)
    return not self.Keys[key];
end

function InputManager:SetLastKey(key)
    self.LastKey = key;

    self.KeyTimeout = false;
    local callback = C_FunctionContainers.CreateCallback(function() self.KeyTimeout = true; end);

    C_Timer.After(DOUBLE_TAP_TIMEOUT, callback);
end

function InputManager:ClearLastKey()
    self.LastKey = nil;
end

function InputManager:IsDoubleTap(key)
    return key == self.LastKey and not self.KeyTimeout;
end

function InputManager:OnKeyDown(key)
    self.HandlingKeyDown = true;

    local isDoubleTap = self:IsDoubleTap(key);

    print(key .. "_DOWN");

    local listeners = self.Keys[key];
    if not listeners then
        return false;
    end

    local currentScreenName = VerityGameWindow:GetScreen().Name;
    for _, listener in pairs(listeners) do
        local context = listener.Context;
        if not context.OnUp and not context.Hold then
            if context.DoubleTap == isDoubleTap then
                if context.Screens == SCREENS_ALL or context.Screens[currentScreenName] then
                    local success, result = pcall(listener.Callback, listener.Owner, key);
                    if not success then self:HandleInputError(key, result); end;
                end
            end
        end
    end

    self:SetLastKey(key);
    self.HandlingKeyDown = false;
end

function InputManager:OnKeyUp(key)
    self.HandlingKeyUp = true;

    print(key .. "_UP");

    self.HandlingKeyUp = false;
end

------------

Verity.InputManager = InputManager;