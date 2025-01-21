reportextension 50000 RepExt_BanAccDetTriBal extends "Bank Acc. - Detail Trial Bal."
{
    dataset
    {
        add("Bank Account Ledger Entry")
        {
            column(CustVendName; CustVendName) { }
            column(CustVendCode; CustVendCode) { }
            column(CustVendNameLbl; CustVendNameLbl) { }
            column(CustVendCodeLbl; CustVendCodeLbl) { }
        }

        modify("Bank Account Ledger Entry")
        {
            trigger OnAfterAfterGetRecord()
            var
                Cust: Record Customer;
                Vend: Record Vendor;
            begin
                CustVendName := '';
                CustVendCode := '';
                if "Bal. Account Type" = "Bal. Account Type"::Customer then begin
                    if Cust.Get("Bal. Account No.") then begin
                        CustVendCode := Cust."No.";
                        CustVendName := Cust.Name;
                    end;
                end;
                if "Bal. Account Type" = "Bal. Account Type"::Vendor then begin
                    if Vend.Get("Bal. Account No.") then begin
                        CustVendCode := Vend."No.";
                        CustVendName := Vend.Name;
                    end;
                end;
            end;

            trigger OnBeforeAfterGetRecord()
            begin

            end;
        }
    }

    rendering
    {
        layout(BankAccDetailTrialBalTampnet)
        {
            Type = RDLC;
            LayoutFile = 'BankAccDetailTrialBalTamp.rdlc';
        }
    }

    var
        CustVendName: Text;
        CustVendCode: Code[20];
        CustVendNameLbl: Label 'Customer/Vendor Name';
        CustVendCodeLbl: Label 'Customer/Vendor Code';
}