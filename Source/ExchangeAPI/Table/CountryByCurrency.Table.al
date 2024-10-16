namespace ExchangeTest.ExchangeAPI;

using Microsoft.Foundation.Address;

table 50101 "Country By Currency"
{
    Caption = 'Country By Currency';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }

        field(2; "Code"; Code[5])
        {
            Caption = 'Code';
            TableRelation = "Country/Region";
            ValidateTableRelation = false;
        }
        field(3; "Country/Region Name"; Text[50])
        {
            Caption = 'Country/Region Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Country/Region".Name where(Code = field(Code)));
            Editable = false;
        }
        field(4; "Country/Region ISO Code"; Text[50])
        {
            Caption = 'Country/Region ISO Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Country/Region"."ISO Code" where(Code = field(Code)));
            Editable = false;
        }

    }
    keys
    {
        key(PK; "Currency Code", "Code")
        {
            Clustered = true;
        }
    }
}
