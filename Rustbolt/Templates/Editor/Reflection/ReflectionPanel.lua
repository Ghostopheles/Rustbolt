-- I know this naming is confusing - this is for the frame containing both reflection panels
-- the mixin below this one (RustboltEditorReflectionPanelMixin) is the base mixin for both the outliner and inspector panels
RustboltEditorReflectionMixin = {};

function RustboltEditorReflectionMixin:OnLoad()
    self.ResizeBar:SetTarget(self.Outliner, "BOTTOMRIGHT", Rustbolt.Enum.ResizeDirection.VERTICAL);
end

------------

RustboltEditorReflectionPanelMixin = {};

function RustboltEditorReflectionPanelMixin:OnLoad()
    self.DataProvider = CreateTreeDataProvider();

    self.ScrollView = CreateScrollBoxListTreeListView();
    self.ScrollView:SetDataProvider(self.DataProvider);

    local TOP_LEVEL_EXTENT = 20;
    local DEFAULT_EXTENT = 20;

    self.ScrollView:SetPanExtent(DEFAULT_EXTENT);
    self.ScrollView:SetElementExtentCalculator(function(_, elementData)
        local extent;
        local data = elementData:GetData();
        if data.RequestedExtent then
            extent = data.RequestedExtent;
        elseif data.IsTopLevel then
            extent = TOP_LEVEL_EXTENT;
        else
            extent = DEFAULT_EXTENT;
        end

        return extent;
    end);

    local function Initializer(frame, node)
        frame:Init(node:GetData());
    end

    self.ScrollView:SetElementFactory(function(factory, node)
		local data = node:GetData();
		local template = data.Template or "RustboltEditorReflectionEntryTemplate";
		factory(template, Initializer);
	end);

    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);

    local anchorsWithScrollBar = {
        CreateAnchor("TOPLEFT", 4, -4);
        CreateAnchor("BOTTOMRIGHT", self.ScrollBar, -13, 4),
    };

    local anchorsWithoutScrollBar = {
        anchorsWithScrollBar[1],
        CreateAnchor("BOTTOMRIGHT", -4, 4);
    };

    ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, anchorsWithScrollBar, anchorsWithoutScrollBar);

    self.SelectionBehavior = ScrollUtil.AddSelectionBehavior(self.ScrollBox, SelectionBehaviorFlags.Intrusive);
    self.SelectionBehavior:RegisterCallback("OnSelectionChanged", self.OnSelectionChanged, self);

    ScrollUtil.AddAcquiredFrameCallback(self.ScrollBox, self.OnFrameAcquired, self);
end

function RustboltEditorReflectionPanelMixin:OnSelectionChanged(data, isSelected)
end

function RustboltEditorReflectionPanelMixin:OnFrameAcquired(frame, data)
end

function RustboltEditorReflectionPanelMixin:AddHeader(text)
    local data = {
        Template = "RustboltEditorReflectionHeaderTemplate",
        Text = text
    };
    return self.DataProvider:Insert(data);
end

function RustboltEditorReflectionPanelMixin:AddEntry(data)
    return self.DataProvider:Insert(data);
end

------------

RustboltEditorReflectionWorldPanelMixin = {};
RustboltEditorReflectionInspectorPanelMixin = {};