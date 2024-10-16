permissionset 50100 ExchangeTest
{
    Caption = 'Exchange Test';

    Assignable = true;
    Permissions = tabledata "Country By Currency" = RIMD,
        tabledata "Exchange Currency Info" = RIMD,
        table "Country By Currency" = X,
        table "Exchange Currency Info" = X,
        codeunit "Exchange AI Settings" = X,
        codeunit "Exchange Capabilities" = X,
        codeunit "Exchange Copilot" = X,
        codeunit "Exchange Utilities" = X,
        codeunit "Install Management" = X,
        page "Countries By Currency SubPage" = X,
        page "Currency Info Card" = X;
}