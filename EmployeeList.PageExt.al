pageextension 50100 "AWR_EmployeeList" extends "Employee List"
{
    actions
    {
        addafter("Co&mments")
        {
            action("AWR_SendCongratulation")
            {
                ApplicationArea = All;
                Image = SendMail;
                //Promoted = true;
                //PromotedIsBig = true;
                //PromotedCategory = Report;
                Caption = 'Send Congratulation';
                ToolTip = 'Launch the message';

                trigger OnAction()
                var
                    Client: HttpClient;
                    Url: Text;
                    Content: HttpContent;
                    Response: HttpResponseMessage;
                    ResponseText: Text;
                begin
                    Url := 'https://ntd19.azurewebsites.net/api/ASB';
                    Content.WriteFrom(StrSubstNo(Message_Txt, Rec."First Name", Rec."Last Name"));

                    if not Client.Post(Url, Content, Response) then
                        Error(Text001_Err);
                    Response.Content().ReadAs(ResponseText);
                    if not Response.IsSuccessStatusCode() then
                        Error(Text002_Err, Response.HttpStatusCode(), ResponseText);
                end;
            }
        }
    }
    var
        Text001_Err: Label 'Service inaccessible';
        Text002_Err: Label 'The web service returned an error message:\ Status code: %1\ Description: %2', Comment = '%1 - Status, %2 - Description';
        Message_Txt: Label 'Today is Happy Birthday of %1 %2! Do not forget to congratulate!', Comment = '%1 - name, %2 - Last Name';
}