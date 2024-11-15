namespace ExchangeTest.ExchangeTest;

using System.Azure.Storage;
using ExchangeTest.ExchangeAPI;
using Microsoft.Foundation.Address;

codeunit 50105 "BlobStorage Management"
{

    local procedure InitConnection()
    begin
        //DATI HARDCODED ILLEGALE!!!!!!
        SharedKey := SecretText.SecretStrSubstNo('0J32aBHEVeRvEbFwMkcX6AF226e+Yep8Z3WMaPhX+3vVUMYKqa5q/aTaHVT8KYEdFH3SBIrVjugm+ASt7CHyXA==');

        Authorization := StorageServiceAuthorization.CreateSharedKey(SharedKey);

        //DATI HARDCODED ILLEGALE!!!!!!
        ABSBlobClient.Initialize('vdsblobexample', 'contenitoretest', Authorization);
    end;

    procedure CreateMyFirstBlob(ExchangeCurrencyInfo: Record "Exchange Currency Info")
    var

        CountryByCurrency: Record "Country By Currency";
        CountryRegion: Record "Country/Region";

        CountryArray: JsonArray;
        Content: Text;
        DoneMsg: Label 'Countries stored into Azure Blob Storage!';
    begin

        InitConnection();

        //ABSContainerClient.Initialize('vdsblobexample', Authorization);
        //ABSContainerClient.CreateContainer('contenitoretest');

        CountryByCurrency.SetRange("Currency Code", ExchangeCurrencyInfo.Code);
        if CountryByCurrency.FindSet() then
            repeat

                if CountryRegion.Get(CountryByCurrency.Code) then
                    //GetJson è una procedura custom!!!!    
                    //Il parametro false serve per ricevere il json compreso dei dati del record corrente
                    CountryArray.Add(CountryRegion.GetJson(false));

            until CountryByCurrency.Next() = 0;

        CountryArray.WriteTo(Content);

        Response := ABSBlobClient.PutBlobBlockBlobText('countries', Content);

        if not Response.IsSuccessful() then
            Error(Response.GetError());

        Message(DoneMsg);
    end;

    procedure ImportTo(var CountryRegionTemp: Record "Country/Region" temporary)
    var
        DoneMsg: Label 'Data Imported!';
        CountryArray: JsonArray;
        CountryToken: JsonToken;
        CountryObject: JsonObject;
        Content: Text;
    begin

        InitConnection();

        if not CountryRegionTemp.IsEmpty() then
            CountryRegionTemp.DeleteAll();

        Response := ABSBlobClient.GetBlobAsText('newcountries.json', Content);

        if not Response.IsSuccessful() then
            Error(Response.GetError());

        CountryArray.ReadFrom(Content);

        foreach CountryToken in CountryArray do begin
            CountryObject := CountryToken.AsObject();
            CountryRegionTemp.InsertFromJson(CountryObject); //InsertFromJson è una procedura custom!!!!
        end;

        Message(DoneMsg);
    end;

    var
        //ABSContainerClient: Codeunit "ABS Container Client";
        ABSBlobClient: Codeunit "ABS Blob Client";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        Response: Codeunit "ABS Operation Response";
        Authorization: Interface "Storage Service Authorization";
        SharedKey: SecretText;
}
