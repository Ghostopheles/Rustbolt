---@meta

---@class RustboltObject
---@field protected Owner? RustboltObject
---@field protected Children table<RustboltObject>
---@field protected World? RustboltWorld
---@field protected Name? string
---@field DoTick boolean
---@field Position Vector3DMixin
---@field Replicated boolean
local Object = {};

function Object:OnBeginPlay() end;
function Object:OnEndPlay() end;

---@param deltaTime number
function Object:OnTick(deltaTime) end;

function Object:OnCreate() end;
function Object:OnDestroy() end;
function Object:OnAdopt() end;
