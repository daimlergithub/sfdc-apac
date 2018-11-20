/**
Type:       Apex class for Event Emails    
Purpose:    1. Send email alerts to Users

User Story: RCP-83
Used By:    
---------------------------------------------------------------
History:

05-Sep-2018 Infosys Ltd  Created
*/
public class EventsEmail {
    /*This method will take List of Registration records to 
	to send email about Event */
    public static void eventsRegHandle(List<Registration__c> reg){
		set<Id> regIds= new set<Id>();
        for(Registration__c r: reg){
            regIds.add(r.Id);
        }
		List<Registration__c> lstReg= [select Id,Email_Id__c,Related_Event__r.Name,Related_Event__r.Start_Time__c,Related_Event__r.End_Time__c,Related_Event__r.Location__c,Related_Event__r.Details__c,Related_Event__r.Agenda__c from Registration__c where Id IN:regIds];        
        eventsEmail('create',lstReg);
    }
    /*This method will take List of Events records updated to 
	to send email about Event to all registered users */
    public static void eventsHandle(List<Events__c> events, List<Events__c> oldEvents){
        set<Id> eventIds= new set<Id>();
        for(Events__c e: events){
            for(Events__c old: oldEvents){
            if(e.Expired__c == false && e.Id == old.Id && (e.Name != old.Name || e.Location__c != old.Location__c || e.Start_Time__c != old.Start_Time__c || e.End_Time__c != old.End_Time__c || e.Details__c != old.Details__c || e.Agenda__c != old.Agenda__c))
            	eventIds.add(e.Id);
            }
        }
        List<Registration__c> reg= [select Id,Email_Id__c,Related_Event__r.Name,Related_Event__r.Start_Time__c,Related_Event__r.End_Time__c,Related_Event__r.Location__c,Related_Event__r.Details__c,Related_Event__r.Agenda__c from Registration__c where Related_Event__c IN:eventIds];
        eventsEmail('edit',reg);
    }
     /*This method is used to send email alerts to users*/
    public static void eventsEmail(string eType,List<Registration__c> reg){
        List<String> errorMessages = new List<String>();
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        String strValue;
        String strSubject;
        if(eType == 'create'){
            strValue = 'You are successfully registered for below Event.';
            strSubject = 'Successfully registered for an Event.';
        }
        else if(eType == 'edit'){
            strValue = 'Your registered Event has been updated.';
            strSubject = 'Your Registered Event has been updated.';
        }
        
        for (Registration__c r: reg){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            String[] toAddress = new String[] {};
                toAddress.add(r.Email_Id__c);
            Message.setToAddresses(toAddress);            
            Message.SaveAsActivity = false;            
            String emailBody = 'Hello, <br/><br/>';
            emailBody += strValue+' <br/><br/>';
            emailBody += 'Below are the Event Details: <br/><br/>';
            emailBody += '<b>Event Name : </b>' +r.Related_Event__r.Name+'<br/>';
            emailBody += '<b>Start Time : </b>' +r.Related_Event__r.Start_Time__c.format()+'<br/>';
            emailBody += '<b>End Time : </b>' +r.Related_Event__r.End_Time__c.format()+'<br/>';
            emailBody += '<b>Location : </b>' +r.Related_Event__r.Location__c +'<br/>';
            emailBody += '<b>Details : </b>' +r.Related_Event__r.Details__c +'<br/><br/>';
            emailBody += '<b>Agenda : </b>' +r.Related_Event__r.Agenda__c +'<br/><br/>';
            
            system.debug('emailBody: '+emailBody);
            Message.setSubject(strSubject);
            Message.setHtmlBody(emailBody);
            mailList.add(Message);
            
        }
        if(!mailList.isEmpty()) {
            try{
                Messaging.sendEmail(mailList);
				System.debug('You have made ' + Limits.getEmailInvocations() + ' email calls out of ' + Limits.getLimitEmailInvocations() + ' allowed');                
            }
            catch (Exception ex) {
                errorMessages.add('Unable to send email: '+ ex.getMessage());
                system.debug('errorMessages '+errorMessages);
            }
        }
        
    }
}