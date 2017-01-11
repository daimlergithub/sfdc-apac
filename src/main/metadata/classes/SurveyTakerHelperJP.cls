/*
Created by suryavarma
date:1/11/2017
*/


public class SurveyTakerHelperJP {
    public static Id rpa=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id rca=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Company').getRecordTypeId();
    public static Id da=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Dealer').getRecordTypeId();
    public static void afterInsertOrUpdateEvent(List<SurveyTaker__c> newList,Map<Id,SurveyTaker__c> oldMap)
    {
    
        Map<Id, List<Id>> map_AccountIdAndListSTId = new Map<Id, List<Id>>();
        Map<Id, user> map_PCAccountIdAndListSTId = new Map<Id,user>();
        Map<Id, user> map_DAccountIdAndListSTId = new Map<Id,user>();
        Map<Id, user> map_UserIdAndListSTId = new Map<Id,user>();

        set<id>surveyinsurveytakeridlist=new set<id>();
        set<id>toroleidlist=new set<id>();
        set<id>userorgrplist=new set<id>();
        list<SurveyTaker__share>SurveyTakerList=new list<SurveyTaker__share>();
        Map<Id,surveytaker__c>  newsurveymap = new Map<Id,surveytaker__c>([select id,account__c,survey__c from surveytaker__c where id IN : newList]);
          
        
        list<SurveyTaker__c> stlist= new list<SurveyTaker__c>([select id,account__c,survey__c,View_By_All__c,account__r.RecordTypeId,(select id from Survey_Question_Answers__r),user__c  from surveytaker__c where id IN : newList]);
        set<Id>SurveyIdWithPCList=new set<Id>();
        set<Id>SurveyIdWithDList=new set<Id>();
        set<Id>UserIdList=new set<Id>();
        set<Id>SurveyIdList=new set<Id>();
        for(SurveyTaker__c str:stlist)
        {
             if((str.account__r.RecordTypeId==rpa)||(str.account__r.RecordTypeId==rca)){
                SurveyIdWithPCList.add(str.account__c);}
             else if(str.account__r.RecordTypeId==da)
             {
                SurveyIdWithDList.add(str.account__c);
             }
            
            UserIdList.add(str.user__c);
            SurveyIdList.add(str.survey__c);
        }
        if(SurveyIdWithPCList.size()>0){
          for(User usr : [SELECT Id, AccountId FROM User WHERE AccountId IN:SurveyIdWithPCList 
                                            AND IsPortalEnabled = true ])
             
               map_PCAccountIdAndListSTId.put(usr.AccountId,usr);
                                            
        }
        if(SurveyIdWithDList.size()>0){
          for(User usr : [SELECT Id, AccountId FROM User WHERE AccountId IN:SurveyIdWithDList 
                                            AND IsPortalEnabled = true ])
             
               map_DAccountIdAndListSTId.put(usr.AccountId,usr);
                                            
        }
        if(UserIdList.size()>0){
          for(User usr : [SELECT Id, AccountId FROM User WHERE Id IN:UserIdList
                                            AND IsPortalEnabled = true ])
             
               map_UserIdAndListSTId .put(usr.Id,usr);
                                            
        }

      
        list<survey__c>surveyList=new list<survey__c>([select id,name from survey__c where id IN:SurveyIdList]);
       
        list<survey__share>surveyShareList=new  list<survey__share>();
        for(SurveyTaker__c s:stlist)
        {
            
        
            if(s.account__c!=null && (oldmap == NULL || s.account__c!=oldmap.get(s.id).account__c) && ( ( (map_PCAccountIdAndListSTId.containskey(s.account__c) || map_UserIdAndListSTId.containskey(s.user__c)) && s.account__r.recordtypeid !=da) || map_DAccountIdAndListSTId.containskey(s.account__c) || s.View_By_All__c==true))
            {
                system.debug('inserting1');
                if(!map_AccountIdAndListSTId.containsKey(s.account__c))
                {
                    
                    map_AccountIdAndListSTId.put(s.account__c, new List<Id>());
                } 
                map_AccountIdAndListSTId.get(s.account__c).add(s.Id);
            }
          
        }
        if(map_AccountIdAndListSTId.size() > 0)
        {
           
            List<SurveyTaker__share> list_SharingRecord = new List<SurveyTaker__share>();
            for(User usr : [SELECT Id, AccountId FROM User WHERE AccountId IN:map_AccountIdAndListSTId.keySet() 
                                            AND IsPortalEnabled = true ]){
           
            if(map_AccountIdAndListSTId.containsKey(usr.AccountId))
            {
                
                for(Id vcId : map_AccountIdAndListSTId.get(usr.AccountId))
                {
                  system.debug('Inserting2');
                    SurveyTaker__share surveyShare = new SurveyTaker__share();
                    surveyShare .AccessLevel = 'Edit';
                    surveyShare .UserOrGroupId = usr.Id;
                    surveyShare .ParentId = vcId;
                    surveyShare .RowCause = Schema.SurveyTaker__share.RowCause.Manual;
                    list_SharingRecord.add(surveyShare);
                   
                          //checking match with current surveyid with surveyid in current survey taker record
                          if(Trigger.newmap.containskey(vcid) && newSurveymap.get(vcid).survey__c != null)
                            {
                                system.debug('Inserting2');
                                Survey__share surt=new Survey__share();
                                surt.ParentId = newSurveymap.get(vcid).survey__c;
                                surt.UserOrGroupId=usr.Id;
                                surt.AccessLevel='read';
                                surt.RowCause = Schema.Survey__share.RowCause.Manual;
                                surveyShareList.add(surt);
                            }    
                  
                }  
            } 
        }
           SurveyTakerList.addAll(list_SharingRecord);
           if(SurveyTakerList.size()>0)
            {
               
               insert SurveyTakerList;
               if(surveyShareList.size()>0)
                {
                      

                    insert surveyShareList;
                }
            }
        }
        
    }
   public static void afterDeleteEvent(List<SurveyTaker__c> oldList)
   {
        Map<Id, List<Id>> map_AccountIdAndListSTId = new Map<Id, List<Id>>();
        set<id>surveyinsurveytakeridlist=new set<id>();
        set<id>toroleidlist=new set<id>();
        set<id>userorgrplist=new set<id>();
        list<SurveyTaker__share>SurveyTakerList=new list<SurveyTaker__share>();
     // list<SurveyTaker__c>stlist= new list<SurveyTaker__c>([select id,account__c,survey__c,user__c,account__r.RecordTypeId from SurveyTaker__c where (account__r.RecordTypeId=:rpa or account__r.RecordTypeId=:rca) AND id IN : newList]);
        set<Id>SurveyIdList=new set<Id>();
        for(SurveyTaker__c str:oldlist)
        {
            SurveyIdList.add(str.survey__c);
         
        }
      
        list<survey__c>surveyList=new list<survey__c>([select id,name from survey__c   where id IN :SurveyIdList ]);
        list<survey__share>surveyShareList=new  list<survey__share>();
         Map<Id,surveytaker__c>  oldsurveymap = new Map<Id,surveytaker__c>([select id,account__c,survey__c from surveytaker__c where id IN : oldList]);
        for(SurveyTaker__c s:oldlist)
        {
        
            if(s.account__c!=null)
            {
                
                if(!map_AccountIdAndListSTId.containsKey(s.account__c))
                {
              
                    map_AccountIdAndListSTId.put(s.account__c, new List<Id>());
                } 
                    map_AccountIdAndListSTId.get(s.account__c).add(s.Id);
            }
          //toroleidlist.add(s.account__c);
        }
         if(map_AccountIdAndListSTId.size() > 0)
        {
            System.debug('Inserting3');
            List<SurveyTaker__share> list_SharingRecord = new List<SurveyTaker__share>();
            for(User usr : [SELECT Id, AccountId FROM User WHERE AccountId IN:map_AccountIdAndListSTId.keySet()
                                            AND IsPortalEnabled = true ]){
           
            if(map_AccountIdAndListSTId.containsKey(usr.AccountId))
            {
                 for(Id vcId : map_AccountIdAndListSTId.get(usr.AccountId))
                {
                        if(Trigger.oldmap.containskey(vcid) && oldSurveymap.get(vcid).survey__c != null)
                          {

                                             
                            Survey__share surt=new Survey__share();
                            surt.ParentId=oldSurveymap.get(vcid).survey__c;
                            surt.UserOrGroupId=usr.Id;
                            surt.AccessLevel='read';
                            surt.RowCause = Schema.Survey__share.RowCause.Manual;
                            surveyShareList.add(surt);
                          }
                }                     
            } 
        }
           
           
            if(surveyShareList.size()>0)
            {
                      

                insert surveyShareList;
            }
           
        }

    }
       
    
}