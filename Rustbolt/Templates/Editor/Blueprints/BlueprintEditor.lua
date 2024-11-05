local CVarManager = Rustbolt.CVarManager;
local Registry = Rustbolt.EventRegistry;
local Events = Rustbolt.Events;
local L = Rustbolt.Strings;

------------

RustboltBlueprintEditorMixin = {};

function RustboltBlueprintEditorMixin:OnLoad()
    self.CurrentScale = 1;

    local maxScaleCVar = CVarManager:GetCVarObject("fBlueprintGraphMaxScale");
    local minScaleCVar = CVarManager:GetCVarObject("fBlueprintGraphMinScale");
    local scaleStepCVar = CVarManager:GetCVarObject("fBlueprintGraphScaleStep");

    maxScaleCVar:AddValueChangedCallback(function(newValue)
        self.MaxScale = newValue;
    end, true);

    minScaleCVar:AddValueChangedCallback(function(newValue)
        self.MinScale = newValue;
    end, true);

    scaleStepCVar:AddValueChangedCallback(function(newValue)
        self.ScaleStep = newValue;
    end, true);

    self.VirtualWidth = 2560;
    self.VirtualHeight = 2560;

    local width, height = self:GetSize();
    self.AutoScaleWidth = width + 120;
    self.AutoScaleHeight = height + 120;

    self:RegisterForDrag("LeftButton");
    self:EnableMouseWheel(true);

    self.IsPanning = false;
    self:ResetCanvas();
    self:CreateCanvasBorder();

    self.TitleText:SetText(L.BLUEPRINT_GRAPH_TITLE);
    self:SetFilename(L.BLUEPRINT_GRAPH_PH_FILENAME);
end

function RustboltBlueprintEditorMixin:OnUpdate()
end

function RustboltBlueprintEditorMixin:OnMouseWheel(delta)
    if self.IsPanning then
        return;
    end

    local centerX, centerY = self:GetCenter();
    local canvasCenterX, canvasCenterY = self.Canvas:GetCenter();
    local canvasWidth, canvasHeight = self.Canvas:GetSize();
    local offsetX = (canvasCenterX - centerX) / canvasWidth;
    local offsetY = (canvasCenterY - centerY) / canvasHeight;
    local scale = self.CurrentScale + (self.ScaleStep * delta);
    self:SetDisplayScale(scale);

    local newWidth, newHeight = self.Canvas:GetSize();
    self:SetCanvasOffsets(offsetX * newWidth, offsetY * newHeight);
end

function RustboltBlueprintEditorMixin:OnMouseDown(button)
end

function RustboltBlueprintEditorMixin:OnMouseUp(button, isInside)
end

function RustboltBlueprintEditorMixin:OnDragStart()
    if not self.Canvas:IsVisible() then
        return;
    end

    self.Canvas:StartMoving();
    self.IsPanning = true;
end

function RustboltBlueprintEditorMixin:OnDragStop()
    if not self.IsPanning then
        return;
    end

    self.Canvas:StopMovingOrSizing();
    local centerX, centerY = self:GetCenter();
    local canvasCenterX, canvasCenterY = self.Canvas:GetCenter();
    self:SetCanvasOffsets(canvasCenterX - centerX, canvasCenterY - centerY);
    self.IsPanning = false;
end

function RustboltBlueprintEditorMixin:SetCanvasOffsets(x, y)
    x, y = x or 0, y or 0;
    self.Canvas:ClearAllPoints();
    self.Canvas:SetPoint("CENTER", self, x, y);
end

function RustboltBlueprintEditorMixin:SetDisplayScale(scale)
    scale = min(self.MaxScale, max(self.MinScale, scale));
    self.CurrentScale = scale;
    self:UpdateCanvasSize();
    self:UpdateZoomText();
end

function RustboltBlueprintEditorMixin:UpdateCanvasSize()
    local width = self.VirtualWidth * self.CurrentScale;
    local height = self.VirtualHeight * self.CurrentScale;
    self.Canvas:SetSize(width, height);
end

function RustboltBlueprintEditorMixin:UpdateZoomText()
    self.ZoomText:SetFormattedText(L.BLUEPRINT_GRAPH_ZOOM_FORMAT, self.CurrentScale * 100);
end

function RustboltBlueprintEditorMixin:SetFilename(filename)
    self.FileNameText:SetText(filename);
end

function RustboltBlueprintEditorMixin:ResetCanvas()
    local scale = 1;
    if self.VirtualHeight > self.AutoScaleHeight or self.VirtualWidth > self.AutoScaleWidth then
        local widthScale = floor(self.AutoScaleWidth / self.VirtualWidth / self.ScaleStep) * self.ScaleStep
		local heightScale = floor(self.AutoScaleHeight / self.VirtualHeight / self.ScaleStep) * self.ScaleStep
		scale = max(self.MinScale, min(widthScale, heightScale));
    end

    self:SetCanvasOffsets(0, 0);
    self:SetDisplayScale(scale);
end

function RustboltBlueprintEditorMixin:GetMouseCoordinatesOnCanvas()
    if not self:IsMouseOver() then
        return;
    end

    local x, y = GetScaledCursorPosition();
	x = x - self.Canvas:GetLeft();
	y = -y + self.Canvas:GetTop();

	local width, height = self.Canvas:GetSize();

	x = Saturate(x / width);
	y = Saturate(y / height);
    return x, y;
end

function RustboltBlueprintEditorMixin:CreateCanvasBorder()
    if self.Canvas.BorderLeft or self.Canvas.BorderRight or self.Canvas.BorderTop or self.Canvas.BorderBottom then
        return;
    end

    local function MakeLine()
        local line = self.Canvas:CreateLine(nil, "OVERLAY");
        local r, g, b, a = 0.1, 0.1, 0.1, 1;
        line:SetColorTexture(r, g, b, a);
        line:SetThickness(2.5);
        return line;
    end

    local left = MakeLine();
    left:SetStartPoint("BOTTOMLEFT", self.Canvas);
    left:SetEndPoint("TOPLEFT", self.Canvas);
    self.Canvas.BorderLeft = left;

    local right = MakeLine();
    right:SetStartPoint("BOTTOMRIGHT", self.Canvas);
    right:SetEndPoint("TOPRIGHT", self.Canvas);
    self.Canvas.BorderRight = right;

    local top = MakeLine();
    top:SetStartPoint("TOPLEFT", self.Canvas);
    top:SetEndPoint("TOPRIGHT", self.Canvas);
    self.Canvas.BorderTop = top;

    local bottom = MakeLine();
    bottom:SetStartPoint("BOTTOMLEFT", self.Canvas);
    bottom:SetEndPoint("BOTTOMRIGHT", self.Canvas);
    self.Canvas.BorderBottom = bottom;
end