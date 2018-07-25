public class DownloadCaseAttachmentsController {

    public Id caseId{get;set;}
    public String endpoint{get;set;}
    public String ticketId{get;set;}
    public String secretKey{get;set;}
    public DownloadCaseAttachmentsController(ApexPages.StandardController controller)
    {
        User userObj=[Select market__c from user where id=:UserInfo.getUserId()];
        if(userObj.Market__c=='TH')
        {
            caseId=controller.getId();
            Case caseObj=[select COS_Ticket_Number__c from case where id=:caseId];
            ticketId=caseObj.COS_Ticket_Number__c;
            if(ticketId!=null && !String.isEmpty(ticketId))
            {
                ticketId=ticketId.substring(1);
                List<SecretKey__mdt> secretKeyMdtLst=[select value__c from SecretKey__mdt where DeveloperName='AttachmentSecretKey'];
                List<AttachmentEndpointCOS__mdt> attachmentEndpointMdtLst=[select value__c from AttachmentEndpointCOS__mdt where DeveloperName='AttachmentEndpointTH'];
                if(secretKeyMdtLst!=null && secretKeyMdtLst.size()>0 && attachmentEndpointMdtLst!=null && attachmentEndpointMdtLst.size()>0)
                {
                    secretKey = secretKeyMdtLst[0].value__c;
                    endpoint = attachmentEndpointMdtLst[0].value__c;
                }
            }
        }
    }
}