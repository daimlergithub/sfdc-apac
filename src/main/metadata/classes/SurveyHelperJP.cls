/*
Created by suryavarma
date:1/11/2017
*/

public class SurveyHelperJP{
 public static void handleInsertOrUpdateEvent(List<Survey__c> newList,Map<Id,Survey__c> oldMap)
 {
   list<survey__c>surveyList=new list<survey__c>();
   set<surveytaker__c>surveytakerList=new set<surveytaker__c>();
   set<id>surveyTakerIds=new set<id>();
   surveyList=[select id,name,(select id,account__c from SurveyTakers1__r) from survey__c where ID IN:newList];
   for(survey__c survey:surveyList){
      for(surveytaker__c st: survey.SurveyTakers1__r)
         {
            if(st.account__c!=null){
                  surveytakerList.add(st);
                  surveyTakerIds.add(st.account__c);
                }
         }
   }
   if(surveytakerList.size()>0 && surveyTakerIds.size()>0){
        List<Survey__share> surveyShareList= new List<Survey__share>();
        for(User usr : [SELECT Id, AccountId FROM User WHERE AccountId IN:surveyTakerIds
                                            AND IsPortalEnabled = true ]){
           
            if(surveyTakerIds.contains(usr.AccountId)){
                System.debug('Inserting4');
                for(survey__c s:surveyList){
                            Survey__share surt=new Survey__share();
                                 surt.ParentId=s.id;
                                 surt.UserOrGroupId=usr.Id;
                                 surt.AccessLevel='read only';
                                 surt.RowCause = Schema.Survey__share.RowCause.Manual;
                                surveyShareList.add(surt);
                   
                }
                
 } 

}
if(surveyShareList.size()>0){
 insert surveylist;
}
}
}
}