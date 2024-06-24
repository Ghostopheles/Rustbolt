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

function World:ShouldTick(object)
    return object.ShouldTick and object:ShouldTick();
end

function World:TickObjects(deltaTime, objects)
    objects = objects or self.Objects;

    for _, object in pairs(objects) do
        if self:ShouldTick(object) then
            object:OnTick(deltaTime);
            if object.Children and #object.Children > 0 then
                self:TickObjects(deltaTime, object.Children);
            end
        end
    end
end

function World:BeginPlay(objects)
    objects = objects or self.Objects;

    for _, object in pairs(objects) do
        if object.Water ~= nil then
            if object.OnBeginPlay then
                object:OnBeginPlay();
            end
            if object.Children and #object.Children > 0 then
                self:BeginPlay(object.Children);
            end
        end
    end
end

function World:EndPlay(objects)
    objects = objects or self.Objects;

    for _, object in pairs(objects) do
        if object.Water ~= nil then
            if object.OnEndPlay then
                object:OnEndPlay();
            end
            if object.Children and #object.Children > 0 then
                self:EndPlay(object.Children);
            end
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
    object:OnCreate(); -- trigger objects OnCreate callback

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