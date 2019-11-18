pageextension 50145 "AWR_EmployeeList" extends "Employee List"
{
    actions
    {
        addlast(Reporting)
        {
            action("AWR_SendCongratulation")
            {
                ApplicationArea = All;
                Image = SendMail;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Send Congratulation';

                trigger OnAction()
                var
                    Client: HttpClient;
                    Url: Text;
                    Content: HttpContent;
                    Response: HttpResponseMessage;
                    ResponseText: Text;
                begin
                    Url := 'https://<<APP Name>>.azurewebsites.net/api/<<Function Name>>';
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
        Text002_Err: Label 'The web service returned an error message:\ Status code: %1\ Description: %2';
        Message_Txt: Label 'Today is Happy Birthday of %1 %2! Do not forget to congratulate!';
}