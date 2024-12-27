page 55001 "Api Content"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "API Content";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec.No)
                {
                    Caption = 'No.';
                    Editable = false;
                }
                field(Fact; Rec.Fact)
                {
                    Caption = 'Fact';
                    Editable = false;
                }
                field(Value; Rec.Value)
                {
                    Caption = 'Value';
                    Editable = false;
                }
            }
        }
    }
}