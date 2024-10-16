namespace ExchangeTest.ExchangeAPI;

using Microsoft.Finance.Currency;

pageextension 50101 "Currency Utility" extends Currencies
{
    actions
    {
        addlast("F&unctions")
        {
            action(GetCurrencyInfoByCurrencyAPI)
            {
                Caption = 'Additional Info';
                ToolTip = 'Additional Info by Currency API Service';
                Image = Web;
                ApplicationArea = All;

                trigger OnAction()
                var
                    CurrencyInfoCard: page "Currency Info Card";
                begin
                    CurrencyInfoCard.SetCurrencyCode(Rec.Code);
                    CurrencyInfoCard.Run();
                end;
            }
        }

    }
}
