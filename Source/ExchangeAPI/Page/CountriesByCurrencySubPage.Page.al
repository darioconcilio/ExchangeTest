namespace ExchangeTest.ExchangeAPI;

page 50100 "Countries By Currency SubPage"
{
    ApplicationArea = All;
    Caption = 'Countries By Currency';
    PageType = ListPart;
    SourceTable = "Country By Currency";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field("Country/Region Name"; Rec."Country/Region Name")
                {
                    ToolTip = 'Specifies the value of the Country/Region Name field.';
                }
                field("Country/Region ISO Code"; Rec."Country/Region ISO Code")
                {
                    ToolTip = 'Specifies the value of the Country/Region ISO Code field.';

                }
            }
        }
    }
}
