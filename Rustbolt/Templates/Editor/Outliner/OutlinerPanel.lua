local Outliner = Rustbolt.Outliner;

RustboltEditorOutlinerPanelMixin = {};

function RustboltEditorOutlinerPanelMixin:OnLoad()
    self:SetupTableBuilder();

    self.SelectionBehavior = ScrollUtil.AddSelectionBehavior(self.ScrollBox, SelectionBehaviorFlags.Intrusive);
    self.SelectionBehavior:RegisterCallback("OnSelectionChanged", self.OnSelectionChanged, self);

    ScrollUtil.AddAcquiredFrameCallback(self.ScrollBox, self.OnFrameAcquired, self);
end

function RustboltEditorOutlinerPanelMixin:OnSelectionChanged(data, isSelected)
end

function RustboltEditorOutlinerPanelMixin:OnFrameAcquired(frame, data)
end

function RustboltEditorOutlinerPanelMixin:SetupTableBuilder()
    if self.TableBuilder then
        return;
    end

    self.TableBuilder = CreateTableBuilder(nil, RustboltOutlinerTableBuilderMixin);

    local function ElementDataTranslator(elementData)
        return elementData;
    end

    ScrollUtil.RegisterTableBuilder(self.ScrollBox, self.TableBuilder, ElementDataTranslator);

    self.TableBuilder:Reset();
    self.TableBuilder:SetColumnHeaderOverlap(2);
    self.TableBuilder:SetHeaderContainer(self.HeaderContainer);
    self.TableBuilder:SetTableMargins(-3, 5);
    self.TableBuilder:SetTableWidth(self.ScrollBox:GetWidth());

    self.TableBuilder:Arrange();
end

function RustboltEditorOutlinerPanelMixin:AddHeader(text)
    local data = {
        Template = "RustboltEditorReflectionHeaderTemplate",
        Text = text
    };
    return self.DataProvider:Insert(data);
end

function RustboltEditorOutlinerPanelMixin:AddEntry(data)
    return self.DataProvider:Insert(data);
end