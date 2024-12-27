page 55000 "API Site Address"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "API Address";


    layout
    {
        area(Content)
        {
            repeater(Address)
            {
                field(Name; Rec.Name)
                {
                    Caption = 'Name';
                    Editable = true;
                }
                field(URL; Rec.Url)
                {
                    Caption = 'URL';
                    Editable = true;
                }
                field(Search; Rec.Search)
                {
                    Caption = 'Search';
                    Editable = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Do)
            {
                Caption = 'Do';
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    CD: Codeunit "API Code Unit";
                begin
                    CD.InsertCountValueFact();
                end;
            }
        }
    }
}