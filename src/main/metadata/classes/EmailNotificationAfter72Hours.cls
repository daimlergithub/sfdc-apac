/**
** This class is created as part of case Escalation after 72 hours if dealer has not contatcted the customer

** Created By: Hildaa.
** Date:  
**/
public class EmailNotificationAfter72Hours{
    
   @InvocableMethod
    public static void SendEmails(List<String> ListID){ 
        List<String> ToAdd=new List<String>();
        List<String> cCAdd=new List<String>();
        List<String> desiredService=new List<String>();
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        EmailTemplate temp=(EmailTemplate)[select id,Body,subject from emailtemplate where name=:'Case escalation_Inquiry after 72 hours_TR' limit 1];
        message.setTemplateId(temp.id);
        
       
        List<Case> CaseList=[select id,CaseNumber,LastModifiedDate,Owner.Email,Send_Email_To__c,Case_Owner_manager__c from Case where id=:ListId ];
        
        String body='';
        String Sub='';
        String  caseLastModifieddate= CaseList[0].LastModifiedDate.format('MM/dd/yyyy hh:mm:ss a');
        body = temp.Body.replace('{!Case.LastModifiedDate}',caseLastModifieddate);  
        Sub = temp.Subject.replace('{!Case.CaseNumber}',CaseList[0].CaseNumber);  
        message.setSubject(sub); 
        message.setPlainTextBody(body);
        message.setCharset('UTF-8');
        if(CaseList[0].Owner.Email != null)
            ToAdd.add(CaseList[0].Owner.Email);
        if(CaseList[0].Send_Email_To__c != null)
            cCAdd.add(CaseList[0].Send_Email_To__c);
        if(CaseList[0].Case_Owner_manager__c != null)
            cCAdd.add(CaseList[0].Case_Owner_manager__c);
        if(ToAdd.size()>0)
            message.setToAddresses(ToAdd);
        if(cCAdd.size()>0)
            message.setccAddresses(cCAdd);
        Messaging.SendEmailResult[] m2=Messaging.SendEmail(new Messaging.SingleEmailMessage[]{message});                
    }
}