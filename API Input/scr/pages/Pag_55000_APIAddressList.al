page 55000 "API Address List"
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
                    APICodeUnit: Codeunit "API Code Unit";
                begin
                    APICodeUnit.InsertCountValueFact(Rec);
                    Page.Run(Page::"Api Content");
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        TestText: Text;
        Outs: OutStream;
        Ins: InStream;
        TempBlob: Codeunit "Temp Blob";
        ToFile: Text;
        NumberOfChars: Integer;
        CRLF: Text;
    begin
        CRLF[1] := 13;
        CRLF[2] := 10;
        while NumberOfChars <= 200 do begin
            NumberOfChars += 1;
            if not (NumberOfChars in [13, 10]) then begin
                TestText += StrSubstNo('%1 : ', Format(NumberOfChars));
                TestText[StrLen(TestText) + 1] := NumberOfChars;
                TestText += CRLF;
            end
        end;

        TempBlob.CreateOutStream(Outs, TextEncoding::UTF8);
        Outs.WriteText(TestText);
        TempBlob.CreateInStream(Ins);
        ToFile := 'Test Text Array/Char.txt';
        DownloadFromStream(Ins, '', '', '', ToFile);
    end;
}