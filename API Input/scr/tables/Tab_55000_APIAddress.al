table 55000 "API Address"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Name; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(2; Url; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'URL';
        }
        field(3; Search; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Search';
        }
        field(4; No; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; Fact; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(6; Value; Text[400])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }
    procedure UrlSite() Curl: Text;
    var
        ApiSite: Record "API Address";
    begin
        // Here we just add the two things together.
        Curl := Url + Search;
    end;

}