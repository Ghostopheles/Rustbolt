local RESIZE_DIRECTION = Rustbolt.Enum.ResizeDirection;

------------

RustboltResizeBarMixin = {};

local CURSOR_TEXTURE = "Interface/CURSOR/Crosshair/UI-Cursor-Move";

function RustboltResizeBarMixin:OnLoad()
end

function RustboltResizeBarMixin:OnUpdate(_)
    if not self.Resizing then
        return;
    end

    local direction = self.Direction;
    local deltaX, deltaY = GetScaledCursorDelta();

    local target = self.Target;

    local w, h = target:GetSize(true);
    local explicitWidth, explicitHeight = w ~= 0, h ~= 0;

    local point, relativeTo, relativePoint, offsetX, offsetY;

    if self.TargetPoint then
        point, relativeTo, relativePoint, offsetX, offsetY = self.Target:GetPointByName(self.TargetPoint);
    end

    if direction == RESIZE_DIRECTION.BOTH or direction == RESIZE_DIRECTION.HORIZONTAL then
        if explicitWidth then
            self.Target:SetWidth(w - deltaX);
        else
            offsetX = offsetX + deltaX;
        end
    end

    if direction == RESIZE_DIRECTION.BOTH or direction == RESIZE_DIRECTION.VERTICAL then
        if explicitHeight then
            self.Target:SetHeight(h - deltaX);
        else
            offsetY = offsetY + deltaY;
        end
    end

    if not explicitWidth and not explicitHeight then
        self.Target:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY);
    end
end

function RustboltResizeBarMixin:OnEnter()
    SetCursor(CURSOR_TEXTURE);
end

function RustboltResizeBarMixin:OnLeave()
    SetCursor(nil);
end

function RustboltResizeBarMixin:OnMouseDown()
    self.Resizing = true;
end

function RustboltResizeBarMixin:OnMouseUp()
    self.Resizing = false;
end

function RustboltResizeBarMixin:OnDoubleClick()
    self:Reset();
end

function RustboltResizeBarMixin:Reset()
    local defaults = self.Defaults;
    if defaults.Point then
        local p = defaults.Point;
        self.Target:SetPoint(p.Point, p.RelativeTo, p.RelativePoint, p.OffsetX, p.OffsetY);
        return;
    end

    if defaults.Width ~= 0 then
        self.Target:SetWidth(defaults.Width);
    end

    if defaults.Height ~= 0 then
        self.Target:SetHeight(defaults.Height);
    end
end

function RustboltResizeBarMixin:SetTarget(target, targetPoint, direction)
    self.Target = target;
    self.Direction = direction;
    self.TargetPoint = targetPoint;

    self.Defaults = {
        Width = self.Target:GetWidth(true),
        Height = self.Target:GetHeight(true)
    };

    if self.TargetPoint then
        local point, relativeTo, relativePoint, offsetX, offsetY = self.Target:GetPointByName(self.TargetPoint);
        self.Defaults.Point = {
            Point = point,
            RelativeTo = relativeTo,
            RelativePoint = relativePoint,
            OffsetX = offsetX,
            OffsetY = offsetY
        };
    end
end
