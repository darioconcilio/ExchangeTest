namespace ExchangeTest.ExchangeTest;

using Microsoft.Foundation.Address;
using ExchangeTest.Copilot;
using ExchangeTest.ExchangeAPI;

pageextension 50102 "Countries/Regions IA Actions" extends "Currency Info Card"
{
    actions
    {
        addafter("F&unctions")
        {
            group(AIUtilities)
            {
                Caption = 'AI Utilities';

                action(GetMissedCountries)
                {
                    Caption = 'Get Missed Countries';
                    ToolTip = 'AI can find additional information for missing countries to create new Country/Region entries in Business Central';
                    Image = CountryRegion;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        CountryByCurrency: Record "Country By Currency";
                        ExchangeUtilities: Codeunit "Exchange Utilities";
                    begin

                        CountryByCurrency.SetRange("Currency Code", Rec.Code);
                        if CountryByCurrency.FindSet() then
                            ExchangeUtilities.GetCountries(CountryByCurrency);

                    end;
                }

            }

            group(StorageAccountUtilities)
            {
                Caption = 'Storage Account Utilities';

                action(UploadCountriesByCurrencyToBlobStorage)
                {
                    Caption = 'Upload current currency to Blob Storage';
                    ToolTip = 'Create a json file relative of countries that uses current currency and upload to Azure Blob Storage';
                    Image = Archive;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        BlobStorageMnt: codeunit "BlobStorage Management";
                    begin
                        BlobStorageMnt.LoadBlobByCurrency(Rec);
                    end;
                }

                action(UploadFilebyUser)
                {
                    Caption = 'Upload by User to Blob Storage';
                    ToolTip = 'Create a json file relative of countries that uses current currency and upload to Azure Blob Storage';
                    Image = ExportFile;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        BlobStorageMnt: codeunit "BlobStorage Management";
                    begin
                        BlobStorageMnt.LoadFileByUser();
                    end;
                }
            }
        }
    }
}
