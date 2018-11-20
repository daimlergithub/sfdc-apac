/************************************************************************************
* Project:RCP Indonesia : Dealer Community Indonesia
* Created By:Narendra.I
* Created Date:25-Oct-2018
* Company:Infosys Ltd
* Description:Class to send email alerts to subscribed users related to recent Events.
* **********************************************************************************/
global class batchClassForEventsSubscribers Implements Schedulable{
    global void execute(SchedulableContext sc)
    {
        sendmail();
    }
    public void sendmail()
    {
        List<Events__c> eventList = new List<Events__c>();
        List<Events__c> ceventList = new List<Events__c>();
        eventList = [SELECT Id,Name,Start_Time__c,End_Time__c,Location__c,Details__c,Agenda__c,CreatedDate,Registration_Start_Time__c FROM Events__c where Expired__c = false and Mail_Sent__c = false ORDER BY createdDate DESC LIMIT 5];        
        ceventList = [SELECT Id,Name,Start_Time__c,End_Time__c,Location__c,Details__c,Agenda__c,CreatedDate,Registration_Start_Time__c FROM Events__c where Expired__c = false and Mail_Sent__c = false ORDER BY createdDate DESC];        
        if(eventList != null && eventList.size() > 0){    
            List<User> eventSubscribedUsers = new List<User>();
            eventSubscribedUsers = [select id,Email from user where isActive = true and Subscribed_To_Event__c = true];
            if(eventSubscribedUsers != null && eventSubscribedUsers.size() > 0){
                List<String> emailList = new List<String>();
                for(User usr : eventSubscribedUsers){
                    emailList.add(usr.Email);                    
                } 
                System.debug('emailList'+emailList);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();      
                mail.setToAddresses(emailList);             
                mail.setSubject('Latest Events on Daimler South East Asia Pte Ltd - Asia org');                
                string body = 'Below are the latest Events in our RCP<br/><br/><table style="border:1px solid black;border-collapse:collapse;"><tr><th style="border:1px solid black;border-collapse:collapse;text-align:center;">Title</th><th style="border:1px solid black;border-collapse:collapse;text-align:center;">Location</th><th style="border:1px solid black;border-collapse:collapse;text-align:center;">Registration Start Time</th><th style="border:1px solid black;border-collapse:collapse;text-align:center;">URL</th></tr>';                
                for(Events__c event : eventList){
                    body = body + '<tr><td style="border:1px solid black;border-collapse:collapse;text-align:left;padding: 5px;">'+event.Name+'</td><td style="border:1px solid black;border-collapse:collapse;text-align:left;padding: 5px;">'+event.Location__c+'</td><td style="border:1px solid black;border-collapse:collapse;text-align:left;padding: 5px;">'+event.Registration_Start_Time__c+'</td><td style="border:1px solid black;border-collapse:collapse;text-align:left;padding: 5px;"><a href="'+Label.Indonesia_Community_URL_RCP+event.Id+'">Link</a></td></tr>';
                }
                if(ceventList.size() > 5){
                    body = body+'</table><br/><br/>For more Events please click here <a href="'+Label.Indonesia_Community_Events_URL+'">Click here</a><br/><br/>Regards,<br/>DCP';
                }
                else
                    body = body+'</table><br/><br/>Regards,<br/>DCP';                
                mail.setHtmlBody(body);
                System.debug('body '+body);            
                List<Messaging.SendEmailResult> mailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                List<Events__c> updateEventsList = new List<Events__c>();
                for(Events__c event : ceventList){
                    event.Mail_Sent__c = true;
                    updateEventsList.add(event);
                }
                update updateEventsList;
            }
        }
    }
    
}