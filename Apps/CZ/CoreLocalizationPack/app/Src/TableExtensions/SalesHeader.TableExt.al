tableextension 11703 "Sales Header CZL" extends "Sales Header"
{
    fields
    {
        field(11717; "Specific Symbol CZL"; Code[10])
        {
            Caption = 'Specific Symbol';
            CharAllowed = '09';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(11718; "Variable Symbol CZL"; Code[10])
        {
            Caption = 'Variable Symbol';
            CharAllowed = '09';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(11719; "Constant Symbol CZL"; Code[10])
        {
            Caption = 'Constant Symbol';
            CharAllowed = '09';
            TableRelation = "Constant Symbol CZL";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(11720; "Bank Account Code CZL"; Code[20])
        {
            Caption = 'Bank Account Code';
            TableRelation = if ("Document Type" = filter(Quote | Order | Invoice | "Blanket Order")) "Bank Account" else
            if ("Document Type" = filter("Credit Memo" | "Return Order")) "Customer Bank Account".Code where("Customer No." = field("Bill-to Customer No."));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                BankAccount: Record "Bank Account";
                CustomerBankAccount: Record "Customer Bank Account";
            begin
                if CurrFieldNo = Rec.FieldNo("Bank Account Code CZL") then
                    TestField(Status, Status::Open);
                if "Bank Account Code CZL" = '' then begin
                    UpdateBankInfoCZL('', '', '', '', '', '', '');
                    exit;
                end;
                case "Document Type" of
                    "Document Type"::Quote, "Document Type"::Order,
                    "Document Type"::Invoice, "Document Type"::"Blanket Order":
                        begin
                            BankAccount.Get("Bank Account Code CZL");
                            UpdateBankInfoCZL(
                              BankAccount."No.",
                              BankAccount."Bank Account No.",
                              BankAccount."Bank Branch No.",
                              BankAccount.Name,
                              BankAccount."Transit No.",
                              BankAccount.IBAN,
                              BankAccount."SWIFT Code");
                        end;
                    "Document Type"::"Credit Memo", "Document Type"::"Return Order":
                        begin
                            TestField("Bill-to Customer No.");
                            CustomerBankAccount.Get("Bill-to Customer No.", "Bank Account Code CZL");
                            UpdateBankInfoCZL(
                              CustomerBankAccount.Code,
                              CustomerBankAccount."Bank Account No.",
                              CustomerBankAccount."Bank Branch No.",
                              CustomerBankAccount.Name,
                              CustomerBankAccount."Transit No.",
                              CustomerBankAccount.IBAN,
                              CustomerBankAccount."SWIFT Code");
                        end;
                end;
            end;
        }
        field(11721; "Bank Account No. CZL"; Text[30])
        {
            Caption = 'Bank Account No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11722; "Bank Branch No. CZL"; Text[20])
        {
            Caption = 'Bank Branch No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11723; "Bank Name CZL"; Text[100])
        {
            Caption = 'Bank Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11724; "Transit No. CZL"; Text[20])
        {
            Caption = 'Transit No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11725; "IBAN CZL"; Code[50])
        {
            Caption = 'IBAN';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11726; "SWIFT Code CZL"; Code[20])
        {
            Caption = 'SWIFT Code';
            Editable = false;
            TableRelation = "SWIFT Code";
            DataClassification = CustomerContent;
        }
        field(11774; "VAT Currency Factor CZL"; Decimal)
        {
            Caption = 'VAT Currency Factor';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 15;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestField("Currency Code");
            end;
        }
        field(11775; "VAT Currency Code CZL"; Code[10])
        {
            Caption = 'VAT Currency Code';
            DataClassification = CustomerContent;
            TableRelation = Currency;
            Editable = false;

            trigger OnValidate()
            begin
                TestField("VAT Currency Code CZL", "Currency Code");
            end;
        }
        field(11780; "VAT Date CZL"; Date)
        {
            Caption = 'VAT Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                GLSetup: Record "General Ledger Setup";
            begin
                GLSetup.Get();
                if not GLSetup."Use VAT Date CZL" then
                    TestField("VAT Date CZL", "Posting Date");
                CheckCurrencyExchangeRateCZL("VAT Date CZL");
                if "VAT Currency Code CZL" <> '' then
                    VATDateUpdateVATCurrencyFactorCZL();
            end;
        }
        field(11781; "Registration No. CZL"; Text[20])
        {
            Caption = 'Registration No.';
            DataClassification = CustomerContent;
        }
        field(11782; "Tax Registration No. CZL"; Text[20])
        {
            Caption = 'Tax Registration No.';
            DataClassification = CustomerContent;
        }
        field(11786; "Credit Memo Type CZL"; Enum "Credit Memo Type CZL")
        {
            Caption = 'Credit Memo Type';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if IsCreditDocType() then
                    TestField("Credit Memo Type CZL")
                else
                    Clear("Credit Memo Type CZL");
            end;
        }
        field(31068; "Physical Transfer CZL"; Boolean)
        {
            Caption = 'Physical Transfer';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Physical Transfer CZL" then
                    if not ("Document Type" in ["Document Type"::"Credit Memo", "Document Type"::"Return Order"]) then
                        FieldError("Document Type");
                UpdateSalesLinesByFieldNo(FieldNo("Physical Transfer CZL"), false);
            end;
        }
        field(31069; "Intrastat Exclude CZL"; Boolean)
        {
            Caption = 'Intrastat Exclude';
            DataClassification = CustomerContent;
        }
        field(31072; "EU 3-Party Intermed. Role CZL"; Boolean)
        {
            Caption = 'EU 3-Party Intermediate Role';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "EU 3-Party Intermed. Role CZL" then
                    "EU 3-Party Trade" := true;
            end;
        }
        field(31112; "Original Doc. VAT Date CZL"; Date)
        {
            Caption = 'Original Document VAT Date';
            DataClassification = CustomerContent;
        }
    }

    var
        ConfirmManagement: Codeunit "Confirm Management";
        GlobalDocumentType: Enum "Sales Document Type";
        GlobalDocumentNo: Code[20];
        GlobalIsIntrastatTransaction: Boolean;

    local procedure CheckCurrencyExchangeRateCZL(CurrencyDate: Date)
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CurrExchRateNotExistsErr: Label '%1 does not exist for currency %2 and date %3.', Comment = '%1 = CurrExchRate.TableCaption, %2 = Currency Code, %3 = Date';
    begin
        if "Currency Code" = '' then
            exit;
        CurrencyExchangeRate.SetRange("Currency Code", "Currency Code");
        CurrencyExchangeRate.SetRange("Starting Date", 0D, CurrencyDate);
        if CurrencyExchangeRate.IsEmpty() then
            Error(CurrExchRateNotExistsErr)
    end;

    procedure UpdateVATCurrencyFactorCZL()
    var
        UpdateChangedFieldQst: Label 'You have changed %1. Do you want to update %2?', Comment = '%1 = field caption, %2 = field caption';
    begin
        if "Currency Code" = '' then begin
            "VAT Currency Factor CZL" := 0;
            exit;
        end;

        if ("Currency Factor" <> xRec."Currency Factor") and ("Currency Factor" <> "VAT Currency Factor CZL") and
            (("VAT Date CZL" = xRec."VAT Date CZL") or (xRec."VAT Date CZL" = 0D)) then begin
            if (xRec."Currency Factor" = "VAT Currency Factor CZL") or HideValidationDialog then begin
                Validate("VAT Currency Factor CZL", "Currency Factor");
                exit;
            end;
            if ConfirmManagement.GetResponseOrDefault(StrSubstNo(UpdateChangedFieldQst, FieldCaption("Currency Factor"), FieldCaption("VAT Currency Factor CZL")), true) then
                Validate("VAT Currency Factor CZL", "Currency Factor");
        end
    end;

    local procedure VATDateUpdateVATCurrencyFactorCZL()
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        VATCurrencyFactor: Decimal;
        UpdateChangedFieldQst: Label 'You have changed %1. Do you want to update %2?', Comment = '%1 = field caption, %2 = field caption';
    begin
        if ("VAT Currency Code CZL" <> '') and ("Currency Factor" = xRec."Currency Factor") and (xRec."Currency Factor" <> 0) then begin
            VATCurrencyFactor := CurrencyExchangeRate.ExchangeRate("VAT Date CZL", "VAT Currency Code CZL");
            if "VAT Currency Factor CZL" <> VATCurrencyFactor then
                if ConfirmManagement.GetResponseOrDefault(StrSubstNo(UpdateChangedFieldQst, FieldCaption("VAT Date CZL"), FieldCaption("VAT Currency Factor CZL")), true) then
                    Validate("VAT Currency Factor CZL", VATCurrencyFactor);
        end;
    end;

    procedure UpdateBankInfoCZL(BankAccountCode: Code[20]; BankAccountNo: Text[30]; BankBranchNo: Text[20]; BankName: Text[100]; TransitNo: Text[20]; IBANCode: Code[50]; SWIFTCode: Code[20])
    begin
        "Bank Account Code CZL" := BankAccountCode;
        "Bank Account No. CZL" := BankAccountNo;
        "Bank Branch No. CZL" := BankBranchNo;
        "Bank Name CZL" := BankName;
        "Transit No. CZL" := TransitNo;
        "IBAN CZL" := IBANCode;
        "SWIFT Code CZL" := SWIFTCode;
        OnAfterUpdateBankInfoCZL(Rec);
    end;

    procedure CheckIntrastatMandatoryFieldsCZL()
    var
        StatutoryReportingSetupCZL: Record "Statutory Reporting Setup CZL";
    begin
        if not (Ship or Receive) then
            exit;
        if IsIntrastatTransactionCZL() and ShipOrReceiveInventoriableTypeItemsCZL() then begin
            StatutoryReportingSetupCZL.Get();
            if StatutoryReportingSetupCZL."Transaction Type Mandatory" then
                TestField("Transaction Type");
            if StatutoryReportingSetupCZL."Transaction Spec. Mandatory" then
                TestField("Transaction Specification");
            if StatutoryReportingSetupCZL."Transport Method Mandatory" then
                TestField("Transport Method");
            if StatutoryReportingSetupCZL."Shipment Method Mandatory" then
                TestField("Shipment Method Code");
        end;
    end;

    procedure IsIntrastatTransactionCZL(): Boolean
    begin
        if ("Document Type" <> GlobalDocumentType) or ("No." <> GlobalDocumentNo) or ("No." = '') then begin
            GlobalDocumentType := "Document Type";
            GlobalDocumentNo := "No.";
            GlobalIsIntrastatTransaction := UpdateGlobalIsIntrastatTransaction();
        end;
        exit(GlobalIsIntrastatTransaction);
    end;

    procedure ShipOrReceiveInventoriableTypeItemsCZL(): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindSet() then
            repeat
                if ((SalesLine."Qty. to Ship" <> 0) or (SalesLine."Return Qty. to Receive" <> 0)) and SalesLine.IsInventoriableItem() then
                    exit(true);
            until SalesLine.Next() = 0;
    end;

    local procedure UpdateGlobalIsIntrastatTransaction(): Boolean
    var
        CountryRegion: Record "Country/Region";
    begin
        if "EU 3-Party Intermed. Role CZL" then
            exit(false);
        if "Intrastat Exclude CZL" then
            exit(false);
        exit(CountryRegion.IsIntrastatCZL("VAT Country/Region Code", false));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateBankInfoCZL(var SalesHeader: Record "Sales Header")
    begin
    end;
}
