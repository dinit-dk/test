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
                    APICodeUnit: Codeunit "API Code Unit";
                    ins: InStream;
                    T: Text;
                    TempBlob: Codeunit "Temp Blob";
                    tofile: Text;
                begin
                    if not Rec.Json.HasValue then
                        Error('Json has no value');
                    Rec.CalcFields(Json);
                    Rec.Json.CreateInStream(ins);
                    ins.ReadText(T);
                    tofile := 'Json.txt';
                    DownloadFromStream(ins,'','','',tofile);
                end;
            }
            action(Do_2)
            {
                trigger OnAction()
                var
                CdUnit: Codeunit "API Code Unit";
                begin
                    CdUnit.SaveJsonTokenToTempBlob();
                end;
            }
        }
    }
}