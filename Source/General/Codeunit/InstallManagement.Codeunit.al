namespace ExchangeTest.General;

codeunit 50100 "Install Management"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin

    end;

    trigger OnInstallAppPerDatabase()
    begin
        IsolatedStorage.SetEncrypted('CurrencyApiWithSecrets', 'gasXQdm6xV8lDHDhVohSNuv-TcHg0_3Mm5k2MNTheTd3AzFuFCz1wA==', DataScope::Module);
    end;
}
