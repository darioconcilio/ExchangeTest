namespace ExchangeTest.ExchangeTest;

using System.Azure.Storage;
using ExchangeTest.ExchangeAPI;
using Microsoft.Foundation.Address;

codeunit 50105 "BlobStorage Management"
{

    local procedure InitConnection()
    begin

        //Recupero la ShareKey per accedere ad Azure Blob Storage
        IsolatedStorage.Get(IsolatedStorageNameShareKeyTxt, SharedKey);

        //Init dell'autorizzazione di accesso
        Authorization := StorageServiceAuthorization.CreateSharedKey(SharedKey);

        //Init per il collegamento al container
        ABSBlobClient.Initialize(StorageAccountTxt, ContainerTxt, Authorization);
    end;

    procedure LoadBlobByCurrency(ExchangeCurrencyInfo: Record "Exchange Currency Info")
    var

        CountryByCurrency: Record "Country By Currency";
        CountryRegion: Record "Country/Region";

        CountryArray: JsonArray;
        Content: Text;
        DoneMsg: Label 'Countries stored into Azure Blob Storage!';
        BlobNameTxt: Label 'countries_%1.json', Comment = '%1=currency code';
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

        Response := ABSBlobClient.PutBlobBlockBlobText(StrSubstNo(BlobNameTxt, CountryByCurrency."Currency Code"), Content);

        if not Response.IsSuccessful() then
            Error(Response.GetError());

        Message(DoneMsg);
    end;

    procedure LoadFileByUser()
    var
        FileNameToUpload: Text;
        FiltroFileTxt: Label 'All files (*.*)|*.*|Json files (*.json)|*.json';
        SelectFileLbl: Label 'Select file to upload';
        FileInStream: InStream;
        UploadOkMsg: Label 'File "%1" uploaded correctly in Azure Blob Storage', Comment = '%1=Uploaded file name';
        NotUploadedErr: Label 'Error dureing uploading of file "%1" in Azure Blob Storage', Comment = '%1=Uploaded file name';
        UploadCancelledMsg: Label 'Upload cancelled';
    begin

        if UploadIntoStream(SelectFileLbl, '', FiltroFileTxt, FileNameToUpload, FileInStream) then begin

            InitConnection();

            // Carica il file nel container specificato
            //Risposta := ABSBlobClient.UploadBlob(ContainerName, FileNameToUpload, FileInStream);
            Response := ABSBlobClient.PutBlobBlockBlobStream(FileNameToUpload, FileInStream);

            if Response.IsSuccessful() then
                Message(UploadOkMsg, FileNameToUpload)
            else
                Message(NotUploadedErr, FileNameToUpload);
        end else
            Message(UploadCancelledMsg);
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
        IsolatedStorageNameShareKeyTxt: Label 'BlobStorageKey', Locked = true;
        StorageAccountTxt: Label 'vdsblobexample', Locked = true;
        ContainerTxt: Label 'contenitoretest', Locked = true;
}
