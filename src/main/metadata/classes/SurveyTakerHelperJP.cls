/*
Created by suryavarma
date:1/11/2017
*/


public class SurveyTakerHelperJP {


    public static Id rpa=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id rca=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Company').getRecordTypeId();
    public static Id da=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Dealer').getRecordTypeId();
   
    public static void afterInsertOrUpdateEvent(List<SurveyTaker__c> surTakList,Map<Id,SurveyTaker__c> oldMap)
    {
        set<id> percomAccoID = new set<id>();
        set<id> userId = new set<id>();
        set<id> dealerID = new set<id>();
        set<id> surveytakID = new set<id>();
        set<id> accntId = new set<id>();
        set<String> GCCode = new set<String>();
        List<SurveyTaker__c> surveyTakerList = new List<SurveyTaker__c>();
        string query;
		
        List<AccountShare> accShareList = new List<AccountShare>();
        List<AccountShare> dealerAccShareList = new List<AccountShare>();
        List<User> userShareList = new List<User>();
        List<Account_Link__c>accountLinkList=new List<Account_Link__c>();
        list<account>alist=new list<account>();
        list<account>newacntlist=new list<account>();
         list<group>assignGroupList=new list<group>();
         map<string,id> assgroupMap = new map<string,id>();
         list<string>assignlist=new list<string>();
         list<String> AccountNAme = new List<String>();
        List<SurveyTaker__share> surveyTkrShareList = new List<SurveyTaker__share>();
        List<Survey__share> surveyShareList = new List<Survey__share>();
        Map<id,id> accountMap = new Map<id,id>();
        Map<id,id> dealerAccountMap = new Map<id,id>();
        Map<id,id> userMap = new Map<id,id>();
        for(SurveyTaker__c sur : surTakList)
        {
            if(sur.Account__c != null || sur.User__c != null || sur.Dealer_Account__c != null)
            {
                surveytakID.add(sur.Id);
            }
            if(sur.Account__c != null)
            {
                percomAccoID.add(sur.Account__c);
               
            }
            if(sur.User__c != null)
            {
                userId.add(sur.User__c);
               
            }
            if(sur.Dealer_Account__c != null)
            {
                dealerID.add(sur.Dealer_Account__c);
            }
        }
        system.debug('percomAccoID>>>>' + percomAccoID);
        system.debug('userId>>>>' + userId);
        system.debug('dealerID>>>>' + dealerID);
        
        if(!surveytakID.isEmpty() && surveytakID != null)
        {
            surveyTakerList = [select id,Account__c,User__c,Dealer_Account__c,survey__c,view_by_all__c from SurveyTaker__c where id =:surveytakID ];
        }
        
        if(!percomAccoID.isEmpty() && percomAccoID != null)
        {
          //  accShareList = [select id,AccountId,AccountAccessLevel,userorGroupId from AccountShare where AccountID =:percomAccoID];
            accountLinkList=[select id,fromrole__c,torole__c from Account_link__c where torole__c=:percomAccoID];
            if(accountLinkList!=null){
            for(account_link__c acs:accountLinkList)
            { 
                system.debug('accountLinkList>>>>'+accountLinkList);
                accntid.add(acs.fromrole__c);
            }
            }
        }
       else if(!userId.isEmpty() && userId != null)
        {
            userShareList = [select id,AccountId from User where Id =:userId];
            for(User ucs:userShareList)
            {
                accntid.add(ucs.accountid);
            }
        }
       else if(!dealerID.isEmpty() && dealerID != null)
        {
            dealerAccShareList = [select id,AccountId,AccountAccessLevel,userorGroupId from AccountShare where AccountID =:dealerID];
            for(AccountShare a:dealerAccShareList)
            {
                accntid.add(a.accountid);
            }
        }
        if(accntid!=null)
        {
          alist=[select id,name,Dealer_GC_Code__c from account where id IN:accntid];  
        }
        if(alist!=null)
        {
            for(account a:alist)
            { 
                System.debug('DGCCode>>>>>'+a.Dealer_GC_Code__c);
                GCCode.add(a.Dealer_GC_Code__c);
                assignlist.add(a.name);
            }
        }
        if(GCCode!=null)
        {
            newacntlist=[select id,recordtypeid,name,Dealer_GC_Code__c from account where Dealer_GC_Code__c IN:GCCode and recordtypeid=:da ];

            
            if(newacntlist!=null)
            {
               for(account a:newacntlist)
              {
                  System.debug('a.name>>>>>>>>'+a.name);
                AccountNAme.add(a.name);
               
              }
            }
        }
         list<Group>grplist=new list<Group>([select id ,Name ,Type from Group where Name IN:assignlist OR Name IN: AccountNAme]);
        for(Group assg:grplist)
        {
            system.debug('grplist>>>>>>>>'+grplist);
            assgroupMap.put(assg.Name, assg.id);
            system.debug('assg.Name'+assg.Name);

        }
        if(!accountLinkList.isEmpty() && accountLinkList != null)
        {
            System.debug('aclist'+accountLinkList);
            for(Account_link__c accshre : accountLinkList)
            {
                system.debug('inserting>>>percomp');
                accountMap.put(accshre.torole__c , accshre.fromrole__c);
            }
        }
        if(!dealerAccShareList.isEmpty() && dealerAccShareList != null)
        {
            for(AccountShare daccshre : dealerAccShareList)
            {
                dealerAccountMap.put(daccshre.AccountId , daccshre.UserOrGroupId);
            }
        }
        if(!userShareList.isEmpty() && userShareList != null)
        {
            System.debug('uShareList>>>>>>>>>>'+userShareList);
            for(User usrshre : userShareList)
            {
                userMap.put(usrshre.Id , usrshre.AccountId);
            }
        }
        system.debug('accountMap>>>' + accountMap);
        system.debug('dealerAccountMap>>>' + dealerAccountMap);
        system.debug('userMap>>>' + userMap);
        for(SurveyTaker__c surtak : surveyTakerList)
        {
            if(surtak.Account__c != null && !accountMap.isEmpty() && accountMap.get(surtak.Account__c) != null)
            {
                
                for(id m:assgroupMap.values()){
                SurveyTaker__Share sharestaker = new SurveyTaker__Share();
                sharestaker.ParentId = surtak.Id;
                sharestaker.UserOrGroupId = m;
                sharestaker.AccessLevel = 'Edit';
                sharestaker.RowCause = Schema.SurveyTaker__share.RowCause.Manual;
                surveyTkrShareList.add(sharestaker);
                Survey__Share surShare=new Survey__Share();
                surShare.ParentId = surtak.survey__c;
                System.debug('survey>>>>>>>>>>>>'+surtak.survey__c);
                surShare.UserOrGroupId = m;
                surShare.AccessLevel = 'Read';
                surShare.RowCause = Schema.Survey__Share.RowCause.Manual;
                surveyShareList.add(surShare);
                     }
            }                
            if(surtak.Dealer_Account__c != null && !dealerAccountMap.isEmpty() && dealerAccountMap.get(surtak.Dealer_Account__c) != null)
            {  
                for(id m:assgroupMap.values())
                {
                    SurveyTaker__Share sharestaker = new SurveyTaker__Share();
                    sharestaker.ParentId = surtak.Id;
                    sharestaker.UserOrGroupId = m;
                    sharestaker.AccessLevel = 'Edit';
                    sharestaker.RowCause = Schema.SurveyTaker__share.RowCause.Manual;
                    surveyTkrShareList.add(sharestaker);
                    Survey__Share surShare=new Survey__Share();
                surShare.ParentId = surtak.survey__c;
                System.debug('survey>>>>>>>>>>>>'+surtak.survey__c);
                surShare.UserOrGroupId = m;
                surShare.AccessLevel = 'Read';
                surShare.RowCause = Schema.Survey__Share.RowCause.Manual;
                surveyShareList.add(surShare);
                }
            }
            if(surtak.User__c != null && !userMap.isEmpty() && userMap.get(surtak.User__c) != null)
            {
                for(id m:assgroupMap.values())
                {
                SurveyTaker__Share sharestaker = new SurveyTaker__Share();
                sharestaker.ParentId = surtak.Id;
                sharestaker.UserOrGroupId = m;
                sharestaker.AccessLevel = 'Edit';
                sharestaker.RowCause = Schema.SurveyTaker__share.RowCause.Manual;
                surveyTkrShareList.add(sharestaker);
                Survey__Share surShare=new Survey__Share();
                surShare.ParentId = surtak.survey__c;
                System.debug('survey>>>>>>>>>>>>'+surtak.survey__c);
                surShare.UserOrGroupId = m;
                surShare.AccessLevel = 'Read';
                surShare.RowCause = Schema.Survey__Share.RowCause.Manual;
                surveyShareList.add(surShare);
                }
            }
            if(surtak.Account__c != null && !accountMap.isEmpty() && accountMap.get(surtak.Account__c) != null && surtak.view_by_all__c == true)
            {
                
                for(id m:assgroupMap.values()){
                SurveyTaker__Share sharestaker = new SurveyTaker__Share();
                sharestaker.ParentId = surtak.Id;
                sharestaker.UserOrGroupId = m;
                sharestaker.AccessLevel = 'Edit';
                sharestaker.RowCause = Schema.SurveyTaker__share.RowCause.Manual;
                surveyTkrShareList.add(sharestaker);
                Survey__Share surShare=new Survey__Share();
                surShare.ParentId = surtak.survey__c;
                System.debug('survey>>>>>>>>>>>>'+surtak.survey__c);
                surShare.UserOrGroupId = m;
                surShare.AccessLevel = 'Read';
                surShare.RowCause = Schema.Survey__Share.RowCause.Manual;
                surveyShareList.add(surShare);
                     }
            }      
        }
        
        if(!surveyTkrShareList.isEmpty() && surveyTkrShareList != null)
        {
            if(!surveyShareList.isEmpty() && surveyShareList != null)
            {
            insert surveyShareList;
            }
            system.debug('surveyTkrShareList>>>>' + surveyTkrShareList);
            insert surveyTkrShareList;
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