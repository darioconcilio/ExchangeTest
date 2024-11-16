namespace ExchangeTest.ExchangeTest;

using Microsoft.Sales.History;
using Microsoft.Foundation.Reporting;
using System.Utilities;

pageextension 50103 "Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    actions
    {
        addlast(processing)
        {
            action(ArchiveToAzureFileShare)
            {
                Caption = 'Archite To Azure';
                ToolTip = 'It uploads to Azure File Share';
                Image = Archive;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ReportSelections: Record "Report Selections";
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    AzureShareFileMnt: Codeunit "Azure Share File Mnt";
                    TempBlob: Codeunit "Temp Blob";
                    SalesInvoiceRecRef: RecordRef;
                    PDFInStream: InStream;
                    PDFOutStream: OutStream;
                    PDFFileNameTxt: Label '%1 - %2.pdf', Comment = '%1=Document No.,%2=Customer Name';
                    ReportNotFoundErr: Label 'Report selection for Sales Invoice not found';
                    RenderingReportErr: Label 'Error dureing rendering report';

                begin

                    SalesInvoiceHeader := Rec;
                    SalesInvoiceHeader.SetRecFilter();

                    SalesInvoiceRecRef.GetTable(SalesInvoiceHeader);

                    if not ReportSelections.Get(ReportSelections.Usage::"S.Invoice", 1) then
                        Error(ReportNotFoundErr);

                    TempBlob.CreateOutStream(PDFOutStream);

                    if not Report.SaveAs(ReportSelections."Report ID", '', ReportFormat::Pdf, PDFOutStream, SalesInvoiceRecRef) then
                        Error(RenderingReportErr);

                    TempBlob.CreateInStream(PDFInStream);

                    AzureShareFileMnt.UploadFileToFileShare(StrSubstNo(PDFFileNameTxt,
                                                                       Format(Rec."No.").ToLower().Replace('\', '-'),
                                                                       Rec."Bill-to Name".Replace('.', '_')),
                                                            PDFInStream);
                    SalesInvoiceRecRef.Close();
                end;
            }

        }
        addlast(Category_Category6)
        {
            actionref(ArchiveToAzureFileShareRef; ArchiveToAzureFileShare)
            {

            }
        }
    }
}
