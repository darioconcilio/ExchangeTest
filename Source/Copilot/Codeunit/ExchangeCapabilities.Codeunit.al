namespace ExchangeTest.Copilot;

using System.AI;
using ExchangeTest.ExchangeTest;

codeunit 50102 "Exchange Capabilities"
{
    Subtype = Install;
    InherentEntitlements = X;
    InherentPermissions = X;
    Access = Internal;

    trigger OnInstallAppPerDatabase()
    begin
        RegisterCapability();
    end;

    var
        ExchangeAISettings: Codeunit "Exchange AI Settings";
        SecretKeyTok: Label 'b32192a1f0a5420f9af781c4c24674ac', Locked = true;
        DeploymentTxt: Label 'gpt-4', Locked = true;
        EndpointUrlTxt: Label 'https://exchangetestai.openai.azure.com/', Locked = true;


    local procedure RegisterCapability()
    var
        CopilotCapability: Codeunit "Copilot Capability";
        LearnMoreUrlTxt: Label 'https://www.vitadasviluppator.it/FakeExchangeTest', Locked = true;
    begin
        if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::Exchange) then
            CopilotCapability.RegisterCapability(Enum::"Copilot Capability"::Exchange,
                                                 Enum::"Copilot Availability"::"Generally Available",
                                                 LearnMoreUrlTxt);

        ExchangeAISettings.SetEndpointUrl(EndpointUrlTxt);
        ExchangeAISettings.SetSecretKey(SecretKeyTok);
        ExchangeAISettings.SetDeployment(DeploymentTxt);

    end;

    /*[EventSubscriber(ObjectType::Page, Page::"Copilot AI Capabilities", OnRegisterCopilotCapability, '', false, false)]
    local procedure OnRegisterCopilotCapability()
    begin
        RegisterCapability();
    end;*/
}
