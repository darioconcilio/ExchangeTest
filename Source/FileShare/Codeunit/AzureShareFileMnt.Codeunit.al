namespace ExchangeTest.ExchangeTest;

using System.Azure.Storage;
using System.Azure.Storage.Files;

codeunit 50106 "Azure Share File Mnt"
{
    procedure UploadFileToFileShare(FullName: Text; InStreamFile: InStream)
    begin
        InitConnection();

        AFSOperationResponse := AFSFileClient.CreateFile(FullName, InStreamFile);

        if not AFSOperationResponse.IsSuccessful() then
            Error(AFSOperationResponse.GetError());

        AFSOperationResponse := AFSFileClient.PutFileStream(FullName, InStreamFile);
        if not AFSOperationResponse.IsSuccessful() then
            Error(AFSOperationResponse.GetError());

    end;

    procedure GetFileFromFileShare(FullName: Text; var WriteToBCOutStream: OutStream)
    var
        ReadFromFileShareInStream: InStream;
    begin

        InitConnection();

        AFSOperationResponse := AFSFileClient.GetFileAsStream(FullName, ReadFromFileShareInStream);
        if not AFSOperationResponse.IsSuccessful() then
            Error(AFSOperationResponse.GetError());

        CopyStream(WriteToBCOutStream, ReadFromFileShareInStream);
    end;

    local procedure InitConnection()
    begin

        //Recupero la ShareKey per accedere ad Azure Blob Storage
        IsolatedStorage.Get(SASTxt, SASToken);

        ISASAuthorization := SASAuthorization.UseReadySAS(SASToken);

        AFSFileClient.Initialize(StorageAccountTxt, SharedFileTxt, ISASAuthorization);
    end;

    var
        AFSFileClient: Codeunit "AFS File Client";
        AFSOperationResponse: Codeunit "AFS Operation Response";
        SASAuthorization: Codeunit "Storage Service Authorization";
        ISASAuthorization: Interface "Storage Service Authorization";
        SASToken: Text;
        SASTxt: Label 'SAS', Locked = true;
        StorageAccountTxt: Label 'vdsblobexample', Locked = true;
        SharedFileTxt: Label 'electronicinvoices', Locked = true;
}
