RustboltOutlinerCellMixin = CreateFromMixins(TableBuilderCellMixin);

function RustboltOutlinerCellMixin:Init(...)
    DevTools_Dump(...);
end

------------

RustboltOutlinerTableBuilderMixin = {};

function RustboltOutlinerTableBuilderMixin:AddColumnInternal(owner, sortOrder, cellTemplate, ...)
	local column = self:AddColumn();

	if sortOrder then
		local headerName = "uwu";
		column:ConstructHeader("BUTTON", "RustboltOutlinerNameTemplate", owner, headerName, sortOrder);
	end

	column:ConstructCells("FRAME", cellTemplate, owner, ...);

	return column;
end

function RustboltOutlinerTableBuilderMixin:AddUnsortableColumnInternal(owner, headerText, cellTemplate, ...)
	local column = self:AddColumn();
	local sortOrder = nil;
	column:ConstructHeader("BUTTON", "RustboltOutlinerNameTemplate", owner, headerText, sortOrder);
	column:ConstructCells("FRAME", cellTemplate, owner, ...);
	return column;
end

function RustboltOutlinerTableBuilderMixin:AddFixedWidthColumn(owner, padding, width, leftCellPadding, rightCellPadding, sortOrder, cellTemplate, ...)
	local column = self:AddColumnInternal(owner, sortOrder, cellTemplate, ...);
	column:SetFixedConstraints(width, padding);
	column:SetCellPadding(leftCellPadding, rightCellPadding);
	return column;
end

function RustboltOutlinerTableBuilderMixin:AddFillColumn(owner, padding, fillCoefficient, leftCellPadding, rightCellPadding, sortOrder, cellTemplate, ...)
	local column = self:AddColumnInternal(owner, sortOrder, cellTemplate, ...);
	column:SetFillConstraints(fillCoefficient, padding);
	column:SetCellPadding(leftCellPadding, rightCellPadding);
	return column;
end

function RustboltOutlinerTableBuilderMixin:AddUnsortableFixedWidthColumn(owner, padding, width, leftCellPadding, rightCellPadding, headerText, cellTemplate, ...)
	local column = self:AddUnsortableColumnInternal(owner, headerText, cellTemplate, ...);
	column:SetFixedConstraints(width, padding);
	column:SetCellPadding(leftCellPadding, rightCellPadding);
	return column;
end

function RustboltOutlinerTableBuilderMixin:AddUnsortableFillColumn(owner, padding, fillCoefficient, leftCellPadding, rightCellPadding, headerText, cellTemplate, ...)
	local column = self:AddUnsortableColumnInternal(owner, headerText, cellTemplate, ...);
	column:SetFillConstraints(fillCoefficient, padding);
	column:SetCellPadding(leftCellPadding, rightCellPadding);
	return column;
end