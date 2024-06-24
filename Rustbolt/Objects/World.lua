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

local _Ticked = {};
function World:ShouldTick(object)
    return not _Ticked[object] and object.ShouldTick and object:ShouldTick();
end


function World:TickObjects(deltaTime, objects)
    if not objects then
        _Ticked = {};
    end

    objects = objects or self.Objects;

    for _, object in pairs(objects) do
        if self:ShouldTick(object) then
            object:OnTick(deltaTime);
            _Ticked[object] = true;
            if object.Children and #object.Children > 0 then
                return self:TickObjects(deltaTime, object.Children);
            end
        end
    end
end

local _BeginPlay;
function World:BeginPlay(objects)
    if not objects then
        _BeginPlay = {};
    end

    objects = objects or self.Objects;

    for _, object in pairs(objects) do
        if not _BeginPlay[object] then
            object:OnBeginPlay();
            _BeginPlay[object] = true;
            if object.Children and #object.Children > 0 then
                return self:BeginPlay(object.Children);
            end
        end
    end
end

local _EndPlay;
function World:EndPlay(objects)
    if not objects then
        _EndPlay = {};
    end

    objects = objects or self.Objects;

    for _, object in pairs(objects) do
        if not _EndPlay[object] then
            object:OnEndPlay();
            _EndPlay[object] = true;
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