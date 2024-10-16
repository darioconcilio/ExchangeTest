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
}
