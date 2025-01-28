namespace ExchangeTest.ExchangeTest;

using System.AI;
using System.Telemetry;
using Microsoft.Inventory.Item;

// https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-page-type-promptdialog

page 50103 "Project AI Prompt"
{
    PageType = PromptDialog;
    Extensible = false; //Obbligatorio

    ApplicationArea = All;
    UsageCategory = Administration;

    PromptMode = Prompt;
    //PromptMode = Content; //attiva la generazione dell'output dell'interazione con Copilot
    //PromptMode = Generate; //mostra l'output dell'interazione cpm Copilot

    IsPreview = true; //true = anteprima della funzionalità (indica all'utente che l'esperienza è sperimentale...)

    layout
    {
        /// <summary>
        /// L'area Prompt è l'input per il copilota e accetta qualsiasi controllo, ad eccezione dei comandi di un Repeater
        /// Questa è la sezione di input che accetta l'input dell'utente per generare il contenuto.
        /// </summary>
        area(Prompt)
        {
            /// <summary>
            /// L'utente deve inserire l'intento del progetto
            /// </summary>
            field(ProjectDescriptionField; InputProjectDescription)
            {
                ApplicationArea = All;
                ShowCaption = false;
                MultiLine = true;
                InstructionalText = 'Describe the project you want to create with Copilot';
            }
        }

        /// <summary>
        /// L'area Contenuto è l'uscita del copilota e accetta qualsiasi controllo, ad eccezione dei comandi del Repeater
        /// Questa è la sezione di output che visualizza il contenuto generato
        /// </summary>
        area(Content)
        {

        }

        /// <summary>
        /// L'area PromptOptions è l'area delle opzioni di input e accetta solo campi di Option
        /// </summary>
        area(PromptOptions)
        {

        }


    }

    actions
    {
        /// <summary>
        /// L'area PromptGuide rappresenta un elenco di "guide" predefinite per i prompt di testo, 
        /// gli utenti possono selezionare per utilizzarle come input per generare contenuti, 
        /// invece di creare il proprio prompt da zero. Il menu della guida al prompt viene reso nel client Web 
        /// solo quando il PromptMode della pagina PromptDialog è impostato su Prompt.
        /// </summary> 
        area(PromptGuide)
        {

        }

        /// <summary>
        /// L'area SystemActions consente di definire solo un insieme fisso di azioni chiamate azioni di sistema, 
        /// che sono supportate solo da questo tipo di pagina. Le azioni di sistema sono Generate, Regenerate, Attach, Ok e Cancel.
        /// </summary> 
        area(SystemActions)
        {

        }
    }

    //Variabili
    var
        InputProjectDescription: Text;

}