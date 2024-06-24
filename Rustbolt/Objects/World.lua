local MapManager = Rustbolt.MapManager;
local ObjectManager = Rustbolt.ObjectManager;

---@class RustboltWorld
local World = {};

---@type table<string, RustboltObject>
World.Objects = {};

function World:SetMapID(mapID)
    self.MapID = mapID;
    self.Map = MapManager:GetMap(self.MapID);
end

function World:ApplyWorldSettings(worldSettings)
    self.Settings = worldSettings;
end

function World:ValidateHandler(handler)
    return handler ~= nop and type(handler) == "function";
end

function World:ShouldTick(object)
    return object.ShouldTick and object:ShouldTick();
end

function World:TickObjects(deltaTime)
    for _, object in pairs(self.Objects) do
        if self:ShouldTick(object) then
            object:OnTick(deltaTime);
        end
    end
end

function World:BeginPlay()
    for _, object in pairs(self.Objects) do
        if self:ValidateHandler(object.OnBeginPlay) then
            object:OnBeginPlay();
        end
    end
end

function World:EndPlay()
    for _, object in pairs(self.Objects) do
        if self:ValidateHandler(object.OnEndPlay) then
            object:OnEndPlay();
        end
    end
end

---Creates and initializes an object in the world
---@param name string
---@param objectTypeName string
---@param ... any Arguments passed to object constructor
---@return RustboltObject? object
function World:CreateObject(name, objectTypeName, ...)
    local object = ObjectManager:CreateObject(objectTypeName, ...);
    object:SetWorld(self);

    self.Objects[name] = object;
    return object;
end

---@param name string
---@return RustboltObject? object
function World:GetObjectByName(name)
    return self.Objects[name];
end

------------

---@class RustboltWorldStatic
Rustbolt.World = {};

---@return RustboltWorld world
function Rustbolt.World:NewWorld()
    return CreateFromMixins(World);
end