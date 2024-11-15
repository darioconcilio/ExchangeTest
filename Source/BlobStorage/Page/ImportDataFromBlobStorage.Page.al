namespace ExchangeTest.ExchangeTest;

using Microsoft.Foundation.Address;

page 50102 "Import Data From BlobStorage"
{
    ApplicationArea = All;
    Caption = 'Import Data From BlobStorage (Temp)';
    PageType = List;
    SourceTable = "Country/Region";
    UsageCategory = Lists;
    SourceTableTemporary = true;
    AdditionalSearchTerms = 'import,azure,storage,blob,country,countries';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field("ISO Code"; Rec."ISO Code")
                {
                    ToolTip = 'Specifies a two-letter country code defined in ISO 3166-1.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Utility)
            {
                action(ImportData)
                {
                    Caption = 'Import Data';
                    ToolTip = 'Import data from Azure BLOB Storage';
                    Image = Import;

                    trigger OnAction()
                    var
                        BlobStorageMnt: Codeunit "BlobStorage Management";
                    begin
                        BlobStorageMnt.ImportTo(Rec);
                        CurrPage.Update();
                    end;
                }
            }
        }
    }
}
