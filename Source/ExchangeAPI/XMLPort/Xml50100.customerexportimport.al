namespace ExchangeTest.ExchangeTest;

using Microsoft.Sales.Customer;

xmlport 50100 "customer export/import"
{
    Caption = 'customer export/import';

    Direction = Both;
    schema
    {
        textelement(RootNodeName)
        {
            tableelement(Customer; Customer)
            {
                fieldelement(No; Customer."No.")
                {
                }
                fieldelement(Name; Customer.Name)
                {
                }
                fieldelement(Address; Customer.Address)
                {
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
