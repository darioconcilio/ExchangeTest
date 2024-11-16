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
        IsolatedStorage.SetEncrypted('SAS', 'sv=2022-11-02&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2024-11-18T06:07:02Z&st=2024-11-16T22:07:02Z&spr=https&sig=RBwCSfX7fs%2FQloMb4YuDRP%2BdviJczJFjvx0jqlmkoRs%3D', DataScope::Module);
    end;
}
