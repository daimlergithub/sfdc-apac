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
        
       // list<String> AccountNAme = new List<String>();
        set<String> GCCode = new set<String>();
        set<id>surveyinsurveytakeridlist=new set<id>();
        set<id>toroleidlist=new set<id>();
        set<id>userorgrplist=new set<id>();
        list<SurveyTaker__share>SurveyTakerList=new list<SurveyTaker__share>();
        Map<Id,surveytaker__c>  newsurveymap = new Map<Id,surveytaker__c>([select id,account__c,survey__c from surveytaker__c where id IN : newList]);
        Map<Id,account> AccountNAme =new Map<Id,account>();
        
        list<SurveyTaker__c> stlist= new list<SurveyTaker__c>([select id,account__c,survey__c,View_By_All__c,account__r.RecordTypeId,account__r.Dealer_GC_Code__c,
                                                                 (select id from Survey_Question_Answers__r),user__c  from surveytaker__c where id IN : newList]);
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
                GCCode.add(str.account__r.Dealer_GC_Code__c);
                system.debug('Dealer_GC_Code__c'+str.account__r.Dealer_GC_Code__c);
             }
            
            UserIdList.add(str.user__c);
            SurveyIdList.add(str.survey__c);
        }
        if(SurveyIdWithPCList.size()>0){
          for(User usr : [SELECT Id, AccountId FROM User WHERE AccountId IN:SurveyIdWithPCList 
                                            AND IsPortalEnabled = true ])
              
               map_PCAccountIdAndListSTId.put(usr.AccountId,usr);
               System.debug('mapsize'+map_PCAccountIdAndListSTId.size());
                                            
        }
        if(SurveyIdWithDList.size()>0){
          for(User usr : [SELECT Id, AccountId FROM User WHERE AccountId IN:SurveyIdWithDList 
                                            AND IsPortalEnabled = true ])
             
               map_DAccountIdAndListSTId.put(usr.AccountId,usr);
               system.debug('map_DAccountIdAndListSTId'+map_DAccountIdAndListSTId.size());
                                            
        }
        if(UserIdList.size()>0){
          for(User usr : [SELECT Id, AccountId FROM User WHERE Id IN:UserIdList
                                            AND IsPortalEnabled = true ])
             
               map_UserIdAndListSTId .put(usr.Id,usr);
                                            
        }

      
        list<survey__c>surveyList=new list<survey__c>([select id,name from survey__c where id IN:SurveyIdList]);
        list<account>aclist=new list<account>([select id, Name, RecordTypeId,Dealer_GC_Code__c from Account 
                                                 WHERE Dealer_GC_Code__c IN: GCCode AND RecordTypeId = :da]);
        list<survey__share>surveyShareList=new  list<survey__share>();
        
        map<string,list<id>> mapGC=new map<string,list<id>>();
       for(account a:aclist)
        {
             system.debug('a.id'+a.id);
             AccountNAme.put(a.id,a);
             if(!mapGC.containskey(a.Dealer_GC_Code__c)){
               List<Id> Tempids =new List<Id>();
               Tempids.add(a.id);
               mapGC.put(a.Dealer_GC_Code__c,Tempids);
             }
             else{
             List<Id> Tempids =new List<Id>();
              Tempids = mapGC.get(a.Dealer_GC_Code__c);
              TempIds.add(a.id);
              mapGC.put(a.Dealer_GC_Code__c,TempIds);
             
             }
             
        }
        for(SurveyTaker__c s:stlist)
        {
           system.debug('s.account__c'+s.account__c);
        system.debug('mpc'+map_PCAccountIdAndListSTId.containskey(s.account__c));
        system.debug('md'+map_DAccountIdAndListSTId.containskey(s.account__c));
        system.debug('muser'+map_UserIdAndListSTId.containskey(s.user__c));
        system.debug('view by all'+ (s.View_By_All__c));
            
        
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
           system.debug('map_AccountIdAndListSTId.size'+map_AccountIdAndListSTId.size());
           system.debug('map'+map_AccountIdAndListSTId);
           System.debug('AccountNAme'+AccountNAme.size());
            List<SurveyTaker__share> list_SharingRecord = new List<SurveyTaker__share>();
            Map<id,id> UseraccountidMap = new Map<id,id>();
            
            For(User u: [Select id,Accountid From User Where Accountid IN:AccountNAme.keyset()]){
                 UseraccountidMap.put(u.accountid,u.id);
                 System.debug('AccountIdUserIdddddd'+UseraccountidMap.size());
            
            }
            
            for(User usr : [SELECT Id, AccountId,Account.Dealer_GC_Code__c  FROM User WHERE AccountId IN:map_AccountIdAndListSTId.keySet()
                                            AND IsPortalEnabled = true ]){
                   system.debug('usr.id====='+usr.id);
                   system.debug('usr.accountid'+usr.accountid);
              if(AccountNAme.size()>0){    
           
                 if(map_AccountIdAndListSTId.containskey(usr.AccountId)){
                      
                      
                      for( Id vcId: map_AccountIdAndListSTId.get(usr.AccountId)){
                    
                       system.debug('Inserting2');
                        SurveyTaker__share surveyShare = new SurveyTaker__share();
                        surveyShare.AccessLevel = 'Edit';
                        surveyShare.UserOrGroupId = usr.Id;
                        surveyShare.ParentId = vcId;
                        surveyShare.RowCause = Schema.SurveyTaker__share.RowCause.Manual;
                        system.debug('mapGC'+mapGC);
                         if(mapGC.containskey(usr.account.Dealer_GC_Code__c)){
                             system.debug('usr.account.Dealer_GC_Code__c'+usr.account.Dealer_GC_Code__c);
                         for(id Accid : mapGC.get(usr.account.Dealer_GC_Code__c)){
                            if(UseraccountidMap.containskey(Accid)){
                              id usrid = UseraccountidMap.get(Accid);
                              System.debug('AccounttttUserIdddd'+usrid);     
                              SurveyTaker__share surveyShare1 = new SurveyTaker__share();
                              surveyShare1.AccessLevel = 'Edit';
                              surveyShare1.UserOrGroupId = usrId;
                              surveyShare1.ParentId = vcId;
                              surveyShare1.RowCause = Schema.SurveyTaker__share.RowCause.Manual;
                              System.debug('firstttttttt'+surveyShare1);
                           list_SharingRecord.add(surveyShare1);
                          }
                         }
                        }
                         System.debug('seconddddddddd'+surveyShare);
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
            else
            {
               if(map_AccountIdAndListSTId.containsKey(usr.AccountId))
            {
                
                for(Id vcId : map_AccountIdAndListSTId.get(usr.AccountId))
                {
                  system.debug('Inserting2');
                   SurveyTaker__share surveyShare = new SurveyTaker__share();
                    surveyShare.AccessLevel = 'Edit';
                    System.debug('userIdddddddd'+usr.Id);
                    surveyShare.UserOrGroupId = usr.Id;
                    surveyShare.ParentId = vcId;
                    surveyShare.RowCause = Schema.SurveyTaker__share.RowCause.Manual;
                    System.debug('Thirdddddddd'+surveyShare);
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
        }
           SurveyTakerList.addAll(list_SharingRecord);
           System.debug('listsharingrecordssss'+list_SharingRecord);
           if(SurveyTakerList != NULL && !SurveyTakerList.isEmpty())
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