/*
Created by suryavarma
date:1/11/2017
*/

public class SurveyHelperJP{
 public static void handleInsertOrUpdateEvent(List<Survey__c> newList,Map<Id,Survey__c> oldMap)
 {
   Id da=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Dealer').getRecordTypeId();
   list<survey__c>surveyList=new list<survey__c>();
   set<surveytaker__c>surveytakerList=new set<surveytaker__c>();
   set<id>surveyTakerIds=new set<id>();
   list<string>GCcode=new list<string>();
        list<String> AccountNAme = new List<String>();
        set<id>acids=new set<id>();
        map<string,id> assgroupMap = new map<string,id>();

   surveyList=[select id,name,(select id,account__c,account__r.RecordTypeId,account__r.name,account__r.Dealer_GC_Code__c from SurveyTakers1__r where account__r.RecordTypeId=:da) from survey__c where ID IN:newList];
   for(survey__c survey:surveyList){
      for(surveytaker__c st: survey.SurveyTakers1__r)
         {
            if(st.account__c!=null){
                  surveytakerList.add(st);
                  
                  surveyTakerIds.add(st.account__c);
                  GCcode.add(st.account__r.Dealer_GC_Code__c);
                  system.debug('dgccode'+st.account__r.Dealer_GC_Code__c);
                }
         }
   }
    list<account>aclist=new list<account>([select id, Name, RecordType.DeveloperName,Dealer_GC_Code__c from Account 
                                                 WHERE Dealer_GC_Code__c IN: GCCode AND RecordType.DeveloperName = 'Dealer']);
    list<string>asslist=new list<string>();
    for(account a:aclist){
          asslist.add(a.name);
          system.debug(a.name);
          surveyTakerIds.add(a.id);
    }
   if(surveytakerList.size()>0 && surveyTakerIds.size()>0){
        List<Survey__share> surveyShareList= new List<Survey__share>();
        List<User>userlist=new List<User>([SELECT Id, AccountId FROM User WHERE AccountId IN:surveyTakerIds AND IsPortalEnabled = true ]);
        
        
        for(User usr : userlist){
                 acids.add(usr.AccountId);
                                 }
       List<account>uAccount=new List<account>([select id,name from account where ID IN:acids]);
            for(account a:uAccount){
               AccountNAme.add(a.name);
            }           
             list<Group>grplist=new list<Group>([select id ,Name ,Type from Group where Name IN:asslist OR Name IN: AccountNAme]);
        for(Group assg:grplist)
        {
               
            assgroupMap.put(assg.Name, assg.id);
            system.debug('assg.Name'+assg.Name);

        
           
              
                for(survey__c s:surveyList){
                          for(surveytaker__c st:s.SurveyTakers1__r ){
                           if(assgroupMap.containskey(st.account__r.name)){
                              system.debug('inserting');
                            Survey__share surt=new Survey__share();
                                 surt.ParentId=s.id;
                                 surt.UserOrGroupId=assg.id;
                                 system.debug('assgromap'+assgroupMap.get(st.account__r.name));
                                 surt.AccessLevel='read';
                                 surt.RowCause = Schema.Survey__share.RowCause.Manual;
                                surveyShareList.add(surt);
                                }
                   
                }
                }
                
  }


if(surveyShareList.size()>0){
 insert surveySharelist;
}
}
}
}