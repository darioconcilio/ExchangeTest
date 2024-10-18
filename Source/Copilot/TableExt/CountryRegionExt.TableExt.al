namespace ExchangeTest.Copilot;

using Microsoft.Foundation.Address;

tableextension 50100 "Country/Region Ext." extends "Country/Region"
{
    procedure GetJson() Result: JsonObject;
    begin

        Clear(Result);

        Result.Add(Rec.FieldName(Code).ToLower(), '');
        Result.Add(Rec.FieldName(Name).ToLower(), '');
        Result.Add(Rec.FieldName("ISO Code").ToLower(), '');
        Result.Add(Rec.FieldName("ISO Numeric Code").ToLower(), 0);
        Result.Add(Rec.FieldName("EU Country/Region Code").ToLower(), '');
        Result.Add(Rec.FieldName("Intrastat Code").ToLower(), '');
        Result.Add(Rec.FieldName("Address Format").ToLower(), '');
        Result.Add(Rec.FieldName("VAT Scheme").ToLower(), '');
        Result.Add(Rec.FieldName("Foreign Country/Region Code").ToLower(), '');

    end;

    procedure InsertFromJson(CountryToAdd: JsonObject)
    begin

        Rec.Init();
        Rec.Code := Format(UpperCase(GetfromToken(CountryToAdd, Rec.FieldName(Code).ToLower())), 10);
        Rec.Name := Format(GetfromToken(CountryToAdd, Rec.FieldName(Name).ToLower()), 10);
        Rec."ISO Code" := Format(GetfromToken(CountryToAdd, Rec.FieldName("ISO Code").ToLower()), 2);
        Rec."ISO Numeric Code" := Format(GetfromToken(CountryToAdd, Rec.FieldName("ISO Numeric Code").ToLower()), 3);

        if not Rec.Insert() then
            Rec.Modify();
    end;

    local procedure GetfromToken(CountryToAdd: JsonObject; KeyName: Text): Text
    var
        FieldJsonToken: JsonToken;
    begin
        if CountryToAdd.Get(KeyName, FieldJsonToken) then
            exit(FieldJsonToken.AsValue().AsText());

        exit('');
    end;
}
