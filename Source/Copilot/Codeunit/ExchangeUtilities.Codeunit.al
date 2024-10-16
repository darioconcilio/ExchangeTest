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

    begin

        //Genero un json array per elencare i paesi che serve recuperare
        rCountries.SetRange("Country/Region Name", '');
        if rCountries.FindFirst() then
            repeat

                JsonArray.Add(rCountries.Code);

            until rCountries.Next() = 0;

        //Preparo la prima parte della richiesta
        Request := 'Now retrieve the information for the countries I will provide, ';
        Request += 'I will only give you the ISO 2-character codes. ';

        //Aggiungo l'elenco dei paesi da cercare
        JsonArray.WriteTo(Countries);
        Request += Countries;

        //Ecco la richiesta vera e propria
        Request += 'I would like you to gather the information for these countries using this format. ';

        //Fornisco il modello in formato json che mi aspetto come risultato
        Request += 'This is a model for one country, use this model for every country that you find. ';
        CountryRegion.GetJson().WriteTo(ResultModel);
        Request += ResultModel;

        //Piccolo trick, in generale aiuta IA a ragionare passo passo, aiuta a "ragionare" prima di fornire il risultato. 
        //Ma.........occhio ai token!!!!
        Request += 'Now proceed step by step. ';

        //Il gran finale!!!
        Request += 'You have to give me only json result.';

        Result := ExchangeCopilot.Chat(GetSystemPrompt(), Request);

        Message(Result);

    end;

    local procedure GetSystemPrompt() SystemPrompt: Text
    begin
        SystemPrompt := 'You are working in a Business Central environment,';
        SystemPrompt += 'viewing the list of currencies managed by Business Central.';
        SystemPrompt += 'A program has been developed that retrieves information about a selected currency';
        SystemPrompt += 'and identifies the countries using that currency.';
        SystemPrompt += 'However, some of these countries might not yet be coded in Business Central.';
        SystemPrompt += 'The user will provide a list of countries using only the ISO 2-character code.';
        SystemPrompt += 'You are tasked with retrieving all the necessary information to code these missing countries';
        SystemPrompt += 'into Business Central, ensuring that the data is complete and compatible with Business Central requirements.';
        SystemPrompt += 'The output should provide all relevant details needed by Business Central.';
    end;
}
