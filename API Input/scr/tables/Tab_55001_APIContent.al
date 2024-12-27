table 55001 "API Content"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Name; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
            Editable = false;
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
        key(PK; Name, No)
        {
            Clustered = true;
        }
    }
}