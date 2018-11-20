/************************************************************************************
* Project:RCP Indonesia : Dealer Community Indonesia
* Created By:Narendra.I
* Created Date:12-July-2018
* Company:Infosys Ltd
* Description:Class to return recent Event records.
* **********************************************************************************/
public without sharing class eventController {
    @AuraEnabled
    public Events__c event;    
    @AuraEnabled
    public List<String> timebool;
    /*Method to return recent Event records.*/
    @Auraenabled
    public static List<Events__c> LatestEvents(){
        List<Events__c> evntList = new List<Events__c>();
        Date dt = Date.today();
        evntList = [SELECT Id,Name,Start_Time__c,End_Time__c,Location__c,Details__c,Agenda__c,CreatedDate FROM Events__c where Start_Time__c >=:dt and Expired__c = false ORDER BY Start_Time__c DESC];
        return evntList;        
    }   
    // Method to subscibe/unsubscibe for events
    @AuraEnabled
    public static void SubscribeEvents(Boolean Subs){
        System.debug('Subs '+Subs);
        Id userId = UserInfo.getUserId();
        User usr = [select id,Subscribed_To_Event__c from User where Id=:userId];
        usr.Subscribed_To_Event__c = Subs;
        update usr;        
    }
    /*Method to check if user is subscribed or not. */
    @AuraEnabled
    public static Boolean getSubscribeEvent(){
        Boolean sub = false;
        Id userId = UserInfo.getUserId();        
        sub = [select Subscribed_To_Event__c from User where Id=:userId].Subscribed_To_Event__c;
        return sub;
    }
    /*Method to get Event validation based on recordId plus returning EVENT DETAILS also*/
    @Auraenabled
    public static eventController validate(String eventId){
        eventController eC= new eventController();
        
        if(eventId != null)
            ec.event = [SELECT Id,Name,Start_Time__c,End_Time__c,Location__c,Details__c,Agenda__c,CreatedDate,Expired__c,Number_of_Registrations__c,Registration_End_Time__c,Registration_Start_Time__c,(SELECT Id FROM Event_Registrations__r ) FROM Events__c where Id =:eventId];        
        
        eC.timebool = new List<String> { 'false', 'false' };
        DateTime dt = DateTime.now();
        Datetime startDate = datetime.valueOf(ec.event.Registration_Start_Time__c);
        Datetime endDate = datetime.valueOf(ec.event.Registration_End_Time__c);
        if(dt>startDate){
            eC.timebool[0] ='true';
            if(dt < endDate){
                eC.timebool[1] ='true';
            }
            else{
                eC.timebool[1] ='false';
            }
        }
        else{
            eC.timebool[0] ='false';
        }
        return eC;        
    }
    
}