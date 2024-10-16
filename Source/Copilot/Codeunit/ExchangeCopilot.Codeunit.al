namespace ExchangeTest.Copilot;

using System.AI;
using ExchangeTest.ExchangeTest;
using System.Environment;

codeunit 50101 "Exchange Copilot"
{
    procedure Chat(SystemPrompt: Text; ChatUserPrompt: Text) Result: Text
    var
        AzureOpenAI: Codeunit "Azure OpenAI";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        AOAIToken: Codeunit "AOAI Token";

        ExchangeAISettings: Codeunit "Exchange AI Settings";

        Endpoint: Text;
        Deployment: Text;
        ApiKey: SecretText;

        MaxModelRequestTokensErr: Label 'Token limit exceeded';
    begin

        Endpoint := ExchangeAISettings.GetEndpointUrl();
        Deployment := ExchangeAISettings.GetDeployment();
        ApiKey := ExchangeAISettings.GetSecretKey();

        //Impostazione del servizio Open AI
        AzureOpenAI.SetAuthorization(Enum::"AOAI Model Type"::"Chat Completions",
                                     Endpoint,
                                     Deployment,
                                     ApiKey);

        //Numero massimo di token da utilizzare
        AOAIChatCompletionParams.SetMaxTokens(1500);

        //Livello di "intelligenza"
        AOAIChatCompletionParams.SetTemperature(0);

        AzureOpenAI.SetCopilotCapability(Enum::"Copilot Capability"::Exchange);

        //Esecuzione della chiamata
        if AOAIToken.GetGPT35TokenCount(SystemPrompt) + AOAIToken.GetGPT35TokenCount(ChatUserPrompt) <= MaxModelRequestTokens() then begin

            //Preparazione del contesto
            AOAIChatMessages.SetPrimarySystemMessage(SystemPrompt);

            //Richiesta dell'utente
            AOAIChatMessages.AddUserMessage(ChatUserPrompt);

            AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);
            if AOAIOperationResponse.IsSuccess() then
                Result := AOAIChatMessages.GetLastMessage();
            exit(Result);
        end else
            Error(MaxModelRequestTokensErr);

        //Gestione dell'esito
        if AOAIOperationResponse.IsSuccess() then
            Result := AOAIChatMessages.GetLastMessage()
        else
            Error(AOAIOperationResponse.GetError());

        exit(Result);
    end;

    local procedure MaxModelRequestTokens(): integer
    begin
        exit(2500)
    end;
}
