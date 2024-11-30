namespace ExchangeTest.General;

codeunit 50100 "Install Management"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin

    end;

    trigger OnInstallAppPerDatabase()
    begin
        //Azure Function API
        IsolatedStorage.SetEncrypted('CurrencyApiWithSecrets', 'gasXQdm6xV8lDHDhVohSNuv-TcHg0_3Mm5k2MNTheTd3AzFuFCz1wA==', DataScope::Module);
        //Azure Blob Storage Service
        IsolatedStorage.SetEncrypted('BlobStorageKey', '0J32aBHEVeRvEbFwMkcX6AF226e+Yep8Z3WMaPhX+3vVUMYKqa5q/aTaHVT8KYEdFH3SBIrVjugm+ASt7CHyXA==', DataScope::Module);
        //SAS
        //ATTENZIONE E' A TEMPO!!!!!
        IsolatedStorage.SetEncrypted('SAS', 'sv=2022-11-02&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2024-12-05T14:57:52Z&st=2024-11-28T06:57:52Z&spr=https&sig=Sbx%2F5HzJuPqmUEUKpzUuQUYYGOcdH7K98hWN1vV9b6w%3D', DataScope::Module);
    end;

}
