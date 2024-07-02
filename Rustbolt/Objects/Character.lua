local InputManager = Rustbolt.InputManager;

---@class RustboltCharacterObject : RustboltObject
---@field InputEnabled boolean
---@field ControlsSetup boolean
---@field MovementSpeed number
local CharacterObject = Rustbolt.ObjectManager:CreateObject("Object");

function CharacterObject:OnBeginPlay()
    self.MovementSpeed = 1000;
    self:SetupControls();
end

function CharacterObject:OnTick(deltaTime)
end

function CharacterObject:IsInputEnabled()
    return self.InputEnabled;
end

function CharacterObject:SetInputEnabled(inputEnabled)
    self.InputEnabled = inputEnabled;
end

function CharacterObject:SetupControls()
    local gate = function() return self:IsInputEnabled(); end;

    local function HandleW()
        self:MoveY(1);
    end

    local function HandleS()
        self:MoveY(-1);
    end

    local function HandleA()
        self:MoveX(-1);
    end

    local function HandleD()
        self:MoveX(1);
    end

    InputManager:RegisterInputListener("W", HandleW, self, nil, gate);
    InputManager:RegisterInputListener("S", HandleS, self, nil, gate);
    InputManager:RegisterInputListener("A", HandleA, self, nil, gate);
    InputManager:RegisterInputListener("D", HandleD, self, nil, gate);
end

function CharacterObject:MoveY(direction)
    local x, y, z = self:GetPosition():GetXYZ();
    local delta = (direction * self.MovementSpeed) * GetTickTime();
    self:SetPosition(x, y + delta, z);
end

function CharacterObject:MoveX(direction)
    local x, y, z = self:GetPosition():GetXYZ();
    local delta = (direction * self.MovementSpeed) * GetTickTime();
    self:SetPosition(x + delta, y, z);
end

Rustbolt.ObjectManager:RegisterObjectType("Character", Rustbolt.ObjectType.OBJECT, CharacterObject);