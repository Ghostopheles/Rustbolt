---@meta VerityObjectTypes

---@class VerityObject
---@field protected Parent? VerityObject
---@field protected Children table<VerityObject>
---@field OnBeginPlay fun(self: VerityObject)
---@field OnEndPlay fun(self: VerityObject)
---@field OnTick fun(self: VerityObject, deltaTime: number)
---@field OnCreate fun(self: VerityObject)
---@field OnDestroy fun(self: VerityObject)
---@field Init? fun(...)
---@field protected World? VerityWorld
---@field SetWorld fun(self: VerityObject, world: VerityWorld)
---@field GetWorld fun(self: VerityObject): VerityWorld?
---@field Super fun(funcOrAttribute: string): any