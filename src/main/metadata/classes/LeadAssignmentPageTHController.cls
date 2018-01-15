public without sharing class LeadAssignmentPageTHController {
public Lead__c le{set;get;}   
  private String [] arrObjIds;  
  public LeadAssignmentPageTHController(){
      le=new Lead__c();
        Map<String, String> params = ApexPages.currentPage().getParameters();        
        String strObjIds = params.get('objIds');  
        system.debug('Array of ids'+strobjids);      
        arrObjIds = strObjIds.split(','); 
        }
    public PageReference assignToOwnerClick() {
         if(le.OwnerId==null){            
            Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR,'New Owner Cannot be null.'));            
           // return;    
        }   
        system.debug('test'+le);
    List<Lead__c> tasks = [Select Id, OwnerId,Retail_Campaign_Name__c From Lead__c Where Id=:arrObjIds];        
        for(Lead__c t : tasks){         
            t.OwnerId = le.OwnerId;               
        }                
        if(tasks.size()>0){                        
            update tasks;
            sendNotificationToNewOwner(le.ownerid,tasks);
            } 
        return new PageReference('/' + tasks[0].Retail_campaign_Name__c);
    }
         private void sendNotificationToNewOwner(Id newOwnerId, List<Lead__c> tasks) {
         String wholesaleDealerStr = '';
         String dealerStr = '';
         //String emailBody = 'Hi' +newOwnerId+',<br/><br/>Following Leads are assigned to you - <br/>';
		 String emailBody =  'Hi,<br/><br/>Following Task are assigned to you - <br/>';
         String thCommURL='';
        //EmailTemplate templateRec = [Select Id, Name from EmailTemplate where DeveloperName = 'test_email'];
        thCommURL=RetailCampaignHelperTH.getCommunityURL();
            User usr = [select Profile.Name,market__c,usertype from User where Id =: newOwnerId];
            for(Integer i = 1; i <= tasks.size(); i++) {
              wholesaleDealerStr += '(' + i +') ' + URL.getSalesforceBaseUrl().toExternalForm()+'/'+ tasks[i-1].Id + '<br/>';
              dealerStr += '(' + i +') ' + thCommURL+ tasks[i-1].Id + '<br/>';   
            }
                if(usr.usertype=='PowerPartner'){
                
                    emailBody += '<br/>If you are dealer user, please use the link<br/>';
                   emailBody += dealerStr;
                   system.debug('i am dealer');
                }else{
                  emailBody += '<br/> If you are wholesale user, please use the link<br/>';
                  emailBody += wholesaleDealerStr;
                }
                emailBody += '<br/>Thanks<br/>Salesforce';
              List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.SetsaveAsActivity(false); 
        //msg.setTemplateId(templateRec.Id);
        msg.setTargetObjectId(newOwnerId);  
        msg.setHTMLBody(emailBody);
        msg.subject = 'Lead Assignment Notification';
        msgList.add(msg);
        Messaging.sendEmail(msgList);
            }
    


}