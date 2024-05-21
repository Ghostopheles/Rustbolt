---@class VerityCharacterObject : VerityObjectBase
local CharacterObject = Verity.ObjectManager:CreateObject("Object");

function CharacterObject:OnBeginPlay()
    print(self:GetWorld());
end

Verity.ObjectManager:RegisterObjectType("Character", Verity.ObjectType.OBJECT, CharacterObject);