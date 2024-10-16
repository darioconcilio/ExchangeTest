namespace ExchangeTest.ExchangeAPI;

page 50101 "Currency Info Card"
{
    ApplicationArea = All;
    Caption = 'Currency Info Card';
    PageType = Document;
    SourceTable = "Exchange Currency Info";
    UsageCategory = Documents;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Name Plural"; Rec."Name Plural")
                {
                    ToolTip = 'Specifies the value of the Name Plural field.', Comment = '%';
                }
                field("Decimal Digits"; Rec."Decimal Digits")
                {
                    ToolTip = 'Specifies the value of the Decimal Digits field.', Comment = '%';
                }
                field("Icon Name"; Rec."Icon Name")
                {
                    ToolTip = 'Specifies the value of the Icon Name field.', Comment = '%';
                }
                field(Roundring; Rec.Roundring)
                {
                    ToolTip = 'Specifies the value of the Roundring field.', Comment = '%';
                }
                field(Symbol; Rec.Symbol)
                {
                    ToolTip = 'Specifies the value of the Symbol field.', Comment = '%';
                }
                field("Symbol Native"; Rec."Symbol Native")
                {
                    ToolTip = 'Specifies the value of the Symbol Native field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
            }

            group(Countries)
            {
                part(CountriesByCurrency; "Countries By Currency SubPage")
                {
                    SubPageLink = "Currency Code" = field(Code);
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("F&unctions")
            {
                //Fake
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.UpdateInfo(CurrencyCode);
    end;

    procedure SetCurrencyCode(CurrencyCodeToSearch: Code[10])
    begin
        CurrencyCode := CurrencyCodeToSearch;
    end;

    var
        CurrencyCode: Code[10];

}
