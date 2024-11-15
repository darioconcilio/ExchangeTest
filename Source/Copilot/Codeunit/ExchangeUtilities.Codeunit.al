namespace ExchangeTest.Copilot;
using ExchangeTest.ExchangeAPI;
using Microsoft.Foundation.Address;

codeunit 50104 "Exchange Utilities"
{
    var
        ExchangeCopilot: codeunit "Exchange Copilot";

    procedure GetCountries(var rCountries: Record "Country By Currency")
    var
        CountryRegion: Record "Country/Region";
        Request: Text;
        Result: Text;
        JsonArray: JsonArray;
        Countries: Text;
        ResultModel: Text;
        ResultJsonArray: JsonArray;
        ResultJsonToken: JsonToken;
        ResultJsonObject: JsonObject;
        Win: Dialog;
        ChattingTxt: Label 'IA: Generating...';
    begin

        Win.Open(ChattingTxt);

        //Genero un json array per elencare i paesi che serve recuperare
        rCountries.SetRange("Country/Region Name", '');
        if rCountries.FindFirst() then
            repeat

                JsonArray.Add(rCountries.Code);

            until rCountries.Next() = 0;

        //Preparo la prima parte della richiesta
        Request := 'Give me info about these countriers ';

        //Aggiungo l'elenco dei paesi da cercare
        JsonArray.WriteTo(Countries);
        Request += Countries;

        //Ecco la richiesta vera e propria
        Request += ' these are ISO-2 Code. ';

        //Fornisco il modello in formato json che mi aspetto come risultato
        Request += 'Use this model json for response ';

        //Il parametro true serve per ricevedere il json senza valori
        CountryRegion.GetJson(true).WriteTo(ResultModel);
        Request += ResultModel;

        //Puntualizzazioni
        Request += ' For the result use array of object. ';
        //Request += ' You have to response only in json format, You don''t ever response adding comment.';

        //Piccolo trick, in generale aiuta IA a ragionare passo passo, aiuta a "ragionare" prima di fornire il risultato. 
        //Ma.........occhio ai token!!!!
        //Request += 'Proceed step by step. '; //SERVE SE DEVE PROCEDERE PER LOGICA IN DIVERSI PASSAGGI

        Result := ExchangeCopilot.Chat(GetSystemPrompt(), Request);

        //Message(Result);

        //ResultJsonObject.ReadFrom(Result);
        ResultJsonArray.ReadFrom(Result);
        /*if not ResultJsonObject.Get('countries', ResultJsonToken) then begin
            Win.Close();
            Error(Result);
        end;*/

        //ResultJsonArray := ResultJsonObject.AsToken().AsArray();

        foreach ResultJsonToken in ResultJsonArray do begin
            ResultJsonObject := ResultJsonToken.AsObject();
            CountryRegion.InsertFromJson(ResultJsonObject);
        end;

        Win.Close();

    end;

    local procedure GetSystemPrompt() SystemPrompt: Text
    begin
        SystemPrompt := 'You are an assistant expert relative currency, ';
        SystemPrompt += 'response information about currencies and countries. ';
        SystemPrompt += 'You have to response only in json format, You don''t ever response adding comment.';
    end;
}
