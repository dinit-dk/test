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
                    Outs: OutStream;
                    T: Text;
                    TempBlob: Codeunit "Temp Blob";
                    tofile, Jsontext : Text;
                    JTok: JsonToken;
                begin
                    if not Rec.Json.HasValue then begin
                        Error('Json has no value')
                    end else begin
                        Rec.CalcFields(Json);
                        Rec.Json.CreateInStream(ins);
                        // Write T to Jtoken
                        JTok.ReadFrom(ins);
                        // Call reformat json function
                        Jsontext := APICodeUnit.ReturnFormatJsonText(JTok, 0, false);
                        Outs.Write(Jsontext);
                        // Create temblob for reformatted json text to download from instream
                        TempBlob.CreateInStream(Ins);
                        tofile := 'Json.json';
                        DownloadFromStream(ins, '', '', '', tofile);
                    end;
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