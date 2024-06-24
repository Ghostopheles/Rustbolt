local InputManager = Rustbolt.InputManager;

---@class RustboltCharacterObject : RustboltObjectBase
---@field InputEnabled boolean
---@field ControlsSetup boolean
---@field MovementSpeed number
local CharacterObject = Rustbolt.ObjectManager:CreateObject("Object");

function CharacterObject:OnBeginPlay()
    self.MovementSpeed = 100;
    self:SetupControls();
end

function CharacterObject:OnTick(deltaTime)
    local position = self:GetPosition();
    print(format("X: %d, Y: %d, Z: %d", position.x, position.y, position.z));
end

function CharacterObject:IsInputEnabled()
    return self.InputEnabled;
end

function CharacterObject:SetInputEnabled(inputEnabled)
    self.InputEnabled = inputEnabled;
end

function CharacterObject:SetupControls()
    local gate = function() return self:IsInputEnabled(); end;

    InputManager:RegisterInputListener("W", self.MoveY, self, nil, gate);
    InputManager:RegisterInputListener("S", self.MoveY, self, nil, gate);
    InputManager:RegisterInputListener("A", self.MoveX, self, nil, gate);
    InputManager:RegisterInputListener("D", self.MoveX, self, nil, gate);
end

function CharacterObject:MoveY(direction)
    direction = 1;

    local x, y, z = self:GetPosition():GetXYZ();
    local delta = (direction * self.MovementSpeed) * GetTickTime();
    self:SetPosition(x, y + delta, z);
end

function CharacterObject:MoveX(direction)
    direction = 1;

    local x, y, z = self:GetPosition():GetXYZ();
    local delta = (direction * self.MovementSpeed) * GetTickTime();
    self:SetPosition(x + delta, y, z);
end

Rustbolt.ObjectManager:RegisterObjectType("Character", Rustbolt.ObjectType.OBJECT, CharacterObject);