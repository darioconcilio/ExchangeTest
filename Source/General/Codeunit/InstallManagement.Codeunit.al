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
    end;
}
