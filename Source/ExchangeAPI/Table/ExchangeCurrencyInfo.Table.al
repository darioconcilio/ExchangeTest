namespace ExchangeTest.ExchangeAPI;

using System.Azure.Functions;

table 50100 "Exchange Currency Info"
{
    Caption = 'Exchange Currency Info';
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; Symbol; Text[5])
        {
            Caption = 'Symbol';
        }
        field(2; "Name"; Text[50])
        {
            Caption = 'Name';
        }
        field(3; "Symbol Native"; Text[5])
        {
            Caption = 'Symbol Native';
        }
        field(4; "Decimal Digits"; Integer)
        {
            Caption = 'Decimal Digits';
        }
        field(5; Roundring; Integer)
        {
            Caption = 'Roundring';
        }
        field(6; Code; Code[10])
        {
            Caption = 'Code';
        }
        field(7; "Name Plural"; Text[50])
        {
            Caption = 'Name Plural';
        }
        field(8; Type; Text[50])
        {
            Caption = 'Type';
        }
        field(9; "Icon Name"; Text[50])
        {
            Caption = 'Icon Name';
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    var
        BaseUrlTxt: Label 'https://exchangeservice.azurewebsites.net', Locked = true;
        ComposedUrlTxt: Label '%1/api/%2', Locked = true;
        AuthenticationCodeNotFoundErr: Label 'Authentication Code Not Found';
        SomethingWrongErr: Label 'Error call %1', Comment = '%1 = Description of error';


    procedure UpdateInfo(CurrencyCode: Code[10])
    var
        CountriesByCurrency: Record "Country By Currency";

        AzureFunction: Codeunit "Azure Functions";
        AzureFunctionAuthentication: Codeunit "Azure Functions Authentication";
        AzureFunctionResponse: Codeunit "Azure Functions Response";
        IAzureFunctionsAuthentication: Interface "Azure Functions Authentication";

        Url: Text;
        AuthenticationCode: Text;

        ActionNameTxt: Label 'CurrencyApiWithSecrets', Locked = true;
        JsonObjectResponse: JsonObject;
        TextResponse: Text;
        DialogProcess: Dialog;
        ProcessLbl: Label 'Retrieving requested information, in progress..';

        QueryDict: Dictionary of [Text, Text];
        HttpResponseMessage: HttpResponseMessage;
        CountriesArray: JsonArray;
        CountryToken: JsonToken;
    begin

        //Recupero il codice per utilizzare la funzione
        if not IsolatedStorage.Get(ActionNameTxt, DataScope::Module, AuthenticationCode) then
            Error(AuthenticationCodeNotFoundErr);

        //Se è l'utente utilizzo la progress bar
        if GuiAllowed then
            DialogProcess.Open(ProcessLbl);

        //Composizione dell'url per contattare la funzione
        Url := StrSubstNo(ComposedUrlTxt,
                          BaseUrlTxt,
                          ActionNameTxt);

        QueryDict.Add('currency', CurrencyCode);


        //--------------------------
        //Preparazione alla chiamata
        //--------------------------

        //Configuro l'autenticazione
        IAzureFunctionsAuthentication := AzureFunctionAuthentication.CreateCodeAuth(Url, AuthenticationCode);

        //Effettuo la chiamata
        AzureFunctionResponse := AzureFunction.SendGetRequest(IAzureFunctionsAuthentication, QueryDict);

        //Se è andata a buon fine allora analizzo la risposta
        if AzureFunctionResponse.IsSuccessful() then begin

            //Recupero la risposta
            AzureFunctionResponse.GetHttpResponse(HttpResponseMessage);

            //Trasferisco la risposta in una variabile leggibile
            if HttpResponseMessage.Content.ReadAs(TextResponse) then

                //Trasferisco la Text in modalità JsonObject
                if JsonObjectResponse.ReadFrom(TextResponse) then begin

                    //LINK: https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-choosing-runtime

                    //Inserisco i dati in una tabella
                    Rec.Init();
#if CLEAN26
                    Rec.Symbol := Format(JsonObjectResponse.GetText('symbol', true), 5);
                    Rec.Name := Format(JsonObjectResponse.GetText('name', true), 50);
                    Rec."Symbol Native" := Format(JsonObjectResponse.GetText('symbol_native', true), 5);
                    Rec."Decimal Digits" := JsonObjectResponse.GetDecimal('decimal_digits', true);
                    Rec.Roundring := JsonObjectResponse.GetDecimal('rounding', true);
                    Rec.Code := Format(UpperCase(JsonObjectResponse.GetText('code', true)), 10);
                    Rec."Name Plural" := Format(JsonObjectResponse.GetText('name_plural', true), 50);
                    Rec.Type := Format(JsonObjectResponse.GetText('type', true), 50);
#else

                    Evaluate(Rec.Symbol, GetValueByToken(JsonObjectResponse, 'symbol').AsValue().AsText());
                    Evaluate(Rec.Symbol, GetValueByToken(JsonObjectResponse, 'symbol').AsValue().AsText());
                    Evaluate(Rec.Name, GetValueByToken(JsonObjectResponse, 'name').AsValue().AsText());
                    Evaluate(Rec."Symbol Native", GetValueByToken(JsonObjectResponse, 'symbol_native').AsValue().AsText());
                    Evaluate(Rec."Decimal Digits", GetValueByToken(JsonObjectResponse, 'decimal_digits').AsValue().AsText());
                    Evaluate(Rec.Roundring, GetValueByToken(JsonObjectResponse, 'rounding').AsValue().AsText());
                    Evaluate(Rec.Code, GetValueByToken(JsonObjectResponse, 'code').AsValue().AsCode());
                    Evaluate(Rec."Name Plural", GetValueByToken(JsonObjectResponse, 'name_plural').AsValue().AsText());
                    Evaluate(Rec.Type, GetValueByToken(JsonObjectResponse, 'type').AsValue().AsText());
#endif

                    //Trick
                    if not Rec.Insert(true) then
                        Rec.Modify(true);

                    //Recupero l'array dei paesi
                    CountriesArray := GetValueByToken(JsonObjectResponse, 'countries').AsArray();

                    foreach CountryToken in CountriesArray do begin

                        CountriesByCurrency.Init();
                        CountriesByCurrency."Currency Code" := CurrencyCode;
                        Evaluate(CountriesByCurrency.Code, CountryToken.AsValue().AsCode());
                        if not CountriesByCurrency.Insert(true) then
                            CountriesByCurrency.Modify(true);

                    end;

                end;

            //Chiudo la progress bar
            if GuiAllowed then
                DialogProcess.Close();

        end else begin

            //Chiudo la progress bar
            if GuiAllowed then
                DialogProcess.Close();

            Error(SomethingWrongErr, AzureFunctionResponse.GetError());

        end;
    end;

    procedure UpdateInfoWithOauth2(CurrencyCode: Code[10])
    var
        CountriesByCurrency: Record "Country By Currency";

        AzureFunction: Codeunit "Azure Functions";
        AzureFunctionAuthentication: Codeunit "Azure Functions Authentication";
        AzureFunctionResponse: Codeunit "Azure Functions Response";
        IAzureFunctionsAuthentication: Interface "Azure Functions Authentication";

        Url: Text;
        AuthenticationCode: Text;

        ActionNameTxt: Label 'CurrencyApiWithSecrets', Locked = true;
        JsonObjectResponse: JsonObject;
        TextResponse: Text;
        DialogProcess: Dialog;
        ProcessLbl: Label 'Retrieving requested information, in progress..';

        QueryDict: Dictionary of [Text, Text];
        HttpResponseMessage: HttpResponseMessage;
        CountriesArray: JsonArray;
        CountryToken: JsonToken;
    begin

        //Recupero il codice per utilizzare la funzione
        if not IsolatedStorage.Get(ActionNameTxt, DataScope::Module, AuthenticationCode) then
            Error(AuthenticationCodeNotFoundErr);

        //Se è l'utente utilizzo la progress bar
        if GuiAllowed then
            DialogProcess.Open(ProcessLbl);

        //Composizione dell'url per contattare la funzione
        Url := StrSubstNo(ComposedUrlTxt,
                          BaseUrlTxt,
                          ActionNameTxt);

        QueryDict.Add('currency', CurrencyCode);

        //Configuro l'autenticazione
        IAzureFunctionsAuthentication := AzureFunctionAuthentication.CreateCodeAuth(Url, AuthenticationCode);

        //Effettuo la chiamata
        AzureFunctionResponse := AzureFunction.SendGetRequest(IAzureFunctionsAuthentication, QueryDict);

        //Se è andata a buon fine allora analizzo la risposta
        if AzureFunctionResponse.IsSuccessful() then begin

            //Recupero la risposta
            AzureFunctionResponse.GetHttpResponse(HttpResponseMessage);

            //Trasferisco la risposta in una variabile leggibile
            if HttpResponseMessage.Content.ReadAs(TextResponse) then

                //Trasferisco la Text in modalità JsonObject
                if JsonObjectResponse.ReadFrom(TextResponse) then begin

                    //LINK: https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-choosing-runtime

                    //Inserisco i dati in una tabella
                    Rec.Init();
#if CLEAN26
                    Rec.Symbol := Format(JsonObjectResponse.GetText('symbol', true), 5);
                    Rec.Name := Format(JsonObjectResponse.GetText('name', true), 50);
                    Rec."Symbol Native" := Format(JsonObjectResponse.GetText('symbol_native', true), 5);
                    Rec."Decimal Digits" := JsonObjectResponse.GetDecimal('decimal_digits', true);
                    Rec.Roundring := JsonObjectResponse.GetDecimal('rounding', true);
                    Rec.Code := Format(UpperCase(JsonObjectResponse.GetText('code', true)), 10);
                    Rec."Name Plural" := Format(JsonObjectResponse.GetText('name_plural', true), 50);
                    Rec.Type := Format(JsonObjectResponse.GetText('type', true), 50);
#else

                    Evaluate(Rec.Symbol, GetValueByToken(JsonObjectResponse, 'symbol').AsValue().AsText());
                    Evaluate(Rec.Symbol, GetValueByToken(JsonObjectResponse, 'symbol').AsValue().AsText());
                    Evaluate(Rec.Name, GetValueByToken(JsonObjectResponse, 'name').AsValue().AsText());
                    Evaluate(Rec."Symbol Native", GetValueByToken(JsonObjectResponse, 'symbol_native').AsValue().AsText());
                    Evaluate(Rec."Decimal Digits", GetValueByToken(JsonObjectResponse, 'decimal_digits').AsValue().AsText());
                    Evaluate(Rec.Roundring, GetValueByToken(JsonObjectResponse, 'rounding').AsValue().AsText());
                    Evaluate(Rec.Code, GetValueByToken(JsonObjectResponse, 'code').AsValue().AsCode());
                    Evaluate(Rec."Name Plural", GetValueByToken(JsonObjectResponse, 'name_plural').AsValue().AsText());
                    Evaluate(Rec.Type, GetValueByToken(JsonObjectResponse, 'type').AsValue().AsText());
#endif

                    //Trick
                    if not Rec.Insert(true) then
                        Rec.Modify(true);

                    //Recupero l'array dei paesi
                    CountriesArray := GetValueByToken(JsonObjectResponse, 'countries').AsArray();

                    foreach CountryToken in CountriesArray do begin

                        CountriesByCurrency.Init();
                        CountriesByCurrency."Currency Code" := CurrencyCode;
                        Evaluate(CountriesByCurrency.Code, CountryToken.AsValue().AsCode());
                        if not CountriesByCurrency.Insert(true) then
                            CountriesByCurrency.Modify(true);

                    end;

                end;

            //Chiudo la progress bar
            if GuiAllowed then
                DialogProcess.Close();

        end else begin

            //Chiudo la progress bar
            if GuiAllowed then
                DialogProcess.Close();

            Error(SomethingWrongErr, AzureFunctionResponse.GetError());

        end;
    end;

#if not CLEAN26
    local procedure GetValueByToken(Contect: JsonObject; KeyNameToSearch: Text) Result: JsonToken
    var
        TokenNotFoundErr: Label 'Token named %1 not found', Comment = '%1=Key Name to Search';
    begin
        if not Contect.SelectToken(KeyNameToSearch, Result) then
            Error(TokenNotFoundErr, KeyNameToSearch);
    end;
#endif

}
