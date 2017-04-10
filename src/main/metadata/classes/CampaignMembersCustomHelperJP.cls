/*
    Type:       Trigger
    Purpose:    CampaignMemberCustomHelper
    User Story:     
    Used By:    
    ---------------------------------------------------------------
    History:
    
    
*/
public with sharing class CampaignMembersCustomHelperJP {
    
    /*  1.
        * Added By: Siva Krishna
        * Desc: trigger handler code for Custom Campaignmember
        * Updated: February 2, 2017
        2.
        Last modified by : Lokesh
        date   : 15th Mar, 2017
        Desc : if campaign members status is 'responded or not responded or bounced' then update the reated execution campaing status to 'Response collection'(if the status is not in 'completed')
        */
    
     public static void afterUpdateOperation(Map<Id, Campaign_Member__c> oldMap, Map<Id, Campaign_Member__c> newMap, List<Campaign_Member__c> newList) {
        Set<Id> campaignIdSet = new Set<Id>(); 
        Set<Id> parentIdSet = new Set<Id>();
        List<Campaign> updateList = new List<Campaign>();
        Map<Id,Id> camMemIdCamIdMap = new Map<Id,Id>();
        String FINAL_CAMPAIGN_STATUS = 'Response collection';
        Set<String> campaignMemberStatusSet = new Set<String>{'Bounced', 'Responded','Not Responded'};
        for(Campaign_Member__c campaignMemberRec : newList) {
            if(campaignMemberStatusSet.contains(newMap.get(campaignMemberRec.Id).Status__c)) {
                campaignIdSet.add(campaignMemberRec.Campaign_ID__c);
            }
        }
        if(campaignIdSet != NULL && !campaignIdSet.isEmpty()){
            List<Campaign> campaignList = [select Name,ParentId, Child_Campaign_Status__c from Campaign where Id =: campaignIdSet]; 
            for(Campaign campaignRec : campaignList) {
                if(campaignRec.Child_Campaign_Status__c != 'Response Collection' && campaignRec.Child_Campaign_Status__c != 'Completed')
                    campaignRec.Child_Campaign_Status__c = FINAL_CAMPAIGN_STATUS;
                    updateList.add(campaignRec);
            }
        }   
        if(updateList.size() > 0) {
            update updateList;
        }
    }
    
    
    /*
     Added by : Lokesh 
     trigger : After Insert Campaign member
     Desc  : For new campaign member if conatac_id__c is empty then assign the account which is exist based on 'Response firstname, response lastname, response lastname', then assign
             that account to new campaign member or create new account based on the above fields and assign that account to campaign member.
    */
     public static void updateCampaignMemberStatusResponseCollection(List<campaign_member__c> newList){
        LeadUtil.Campaigntrigger = false;
        Set<Id> camMemSet = new Set<Id>();
        List<String> firstName = new List<String>();
        List<String> lastName = new List<String>();
        List<String> email = new List<String>();
        List<Account> accList = new List<Account>();
        List<campaign_member__c> newAccCampMem = new List<campaign_member__C>();
        List<campaign_member__C> campmembers = new List<campaign_member__c>();
        List<campaign_member__c> camMemList = new List<campaign_member__C>();
        List<campaign_member__c> updateCampList = new List<campaign_member__C>();
        List<Account> newAccounts = new List<Account>();
        RecordType perAccRecType =  [select id from RecordType where sObjecttype = 'Account' AND Name = 'Person Account' limit 1];
        Boolean accFind = false;
        List<campaign_member__C> camMemWithOutCont = new List<Campaign_member__c>();
        Map<String,Campaign_member__c> nameCamMemId = new Map<String,Campaign_member__c>();
        for(campaign_member__c curMem : newList){
            camMemSet.add(curMem.Id);   
        }
        campMembers = [SELECT Id,Name,Status__c,Response_email__c, Response_FirstName__c,response_lastName__c,contact_id__c,campaign_id__c,retail_campaign_Id__c FROM Campaign_member__c WHERE Id IN: camMemSet];
        for(Campaign_Member__c cm : campMembers){
            if(cm.contact_Id__c == NULL && cm.Response_FirstName__c != NULL && cm.Response_LastName__c != NULL && cm.Response_Email__c != NULL){
                camMemList.add(cm);
                firstName.add(cm.Response_FirstName__c);
                lastName.add(cm.Response_LastName__c);
                email.add(cm.Response_Email__c);
            }
            if(cm.name != NULL && cm.contact_Id__c == NULL && cm.Response_FirstName__c == NULL && cm.Response_LastName__c == NULL && cm.Response_Email__c == NULL){
                camMemWithOutCont.add(cm); 
                nameCamMemId.put(cm.Name,cm);  
            }
        }
        if(camMemWithOutCont != NULL && !camMemWithOutCont.isEmpty()){
            for(Campaign_Member__c cMem : camMemWithOutCont){
                Account accnt = new Account();
                accnt.LastName = cMem.name;
                accnt.RecordTypeId = perAccRecType.Id;
                newAccounts.add(accnt);    
            }
        }
        accList = [SELECT Id,Name,FirstName,LastName,Email__C FROM Account WHERE FirstName IN: firstName AND lastName IN: lastName AND Email__c IN: email AND RecordTypeId =: perAccRecType.Id];
        System.debug('Acclist'+accList);
        if(accList != NULL && !accLIst.isEmpty()){
            for(campaign_member__c c : camMemList){
                for(Account acc : accList){
                    if(c.Response_Email__c == acc.Email__c && c.Response_FirstName__c == acc.FirstName && c.Response_LastName__c == acc.LastName){
                        c.Contact_Id__c = acc.Id;
                        c.Status__c = 'Responded';
                        updateCampList.add(c);
                        accFind = true;
                    }
                }
                if(accFind == false){
                    Account newAcc = new Account();
                    newAcc.FirstName = c.Response_FirstName__c;
                    newAcc.LastName = c.Response_LastName__c;
                    newAcc.Email__c = c.Response_Email__c;
                    newAcc.recordtypeId = perAccRecType.Id;
                    newAccounts.add(newAcc);
                    newAccCampMem.add(c);
                }
                accFind = false;      
            }     
        }
        else if(camMemList != NULL && !camMemList.isEmpty()){
            for(campaign_member__c c : camMemList){
                Account Acc = new Account();
                acc.Firstname = c.Response_FirstName__c;
                acc.LastName = c.Response_LastName__c;
                acc.Email__c = c.Response_Email__c;
                acc.recordtypeId = perAccRecType.Id;
                newAccounts.add(acc);
                newAccCampMem.add(c);
            }
            
        }
        System.debug('newAccount'+newAccounts);
        if(newAccounts != NULL && !newAccounts.isEmpty()){
            insert newAccounts;
        }
        
        if(nameCamMemId != NULL && !nameCamMemId.isEmpty()){
            for(Account ac : newAccounts){
                if(nameCamMemId.containsKey(ac.lastName)){
                    nameCamMemId.get(ac.lastName).Contact_Id__c = ac.Id;
                    updateCampList.add(nameCamMemId.get(ac.lastName));
                }
            }
        }
        
        if(newAccCampMem != NULL && !newAccCampMem.isEmpty()){
            for(campaign_member__c camp : newAccCampMem){
                for(Account acct : newAccounts){
                    if(camp.Response_Email__c == acct.Email__c && camp.Response_FirstName__c == acct.FirstName && camp.Response_LastName__c == acct.LastName){    
                        camp.contact_Id__c = acct.Id;
                        camp.Status__c= 'Responded';
                        updateCampList.add(camp);
                    }
                }
            }
        }
         if(updateCampList != NULL && !updateCampList.isEmpty()){
                update updateCampList;
         }
         
     }
     
     /*trigger  : After Update Campaign Members
       Added by : Lokesh 
       Desc     : If campaign member status is 'Responded' or 'Not Responded' or 'Bounced' and status not in 'completed' then update the related 
                    and retail campaign status to 'Response collection'
       date     : 15th Mar, 2017
     */
    public static void afterUpdateCampaignMembers(Map<Id,Campaign_Member__c> afterCampMembers){
        Set<Id> parentRetailCampIds = new Set<Id>();
        Set<String> campaignMemberStatusSet = new Set<String>{'Bounced', 'Responded','Not Responded'};
        for(Campaign_Member__c campMem : [SELECT Status__c, Campaign_Id__c, Retail_Campaign_Id__c FROM Campaign_Member__c WHERE ID IN: afterCampMembers.keySet()]){
            if(campaignMemberStatusSet.contains(campMem.Status__c)){
                if(campMem.Retail_Campaign_Id__c != null)
                    parentRetailCampIds.add(campMem.Retail_Campaign_Id__c);
            }            
        }

        List<Retail_Campaign__c> listRetCamp = new List<Retail_Campaign__c>();
        if(parentRetailCampIds != NULL && !parentRetailCampIds.isEmpty()){
            for(Retail_Campaign__c retCmp : [SELECT Child_Campaign_Status__c FROM Retail_Campaign__c WHERE Id IN : parentRetailCampIds]){
                if(retCmp.Child_Campaign_Status__c != 'Completed' && retCmp.Child_Campaign_Status__c != 'Response Collection'){
                    retCmp.Child_Campaign_Status__c = 'Response Collection';
                    listRetCamp.add(retCmp);
                }
            }
        }
        if(listRetCamp.size()> 0)
            update listRetCamp;
    } 
         
/* 
            Dinesh
            batch trigger for export set invalid flag
            
            */


         Public static void batchbounce(List<Campaign_Member__c> campgnm)
{
   List<Account> accMainList = New List<Account>(); 
   List<Address__c> AddNewList = New List<Address__c>();
     set<id> camAccount = new set<id>();
     for(Campaign_Member__c camp : campgnm)
                {
             
                        if(camp.Status__c =='Bounced')
                        {                                   
                                camAccount.add(camp.Contact_Id__c);
                         }
          system.debug('+++++++++++++ camp'+camp);
                } 
        
         List<Account> addList = [Select Email__c,Email_Status__c,Mobile_Status__c,Email_Last_Modified_Date__c,Mobile__c,SMS_Last_Modified_Date__c,(Select id ,Status__c ,Hardcopy_Last_Modified_Date__c From Addresses__r ) From Account Where Id =: camAccount];
        
        For(Account acc : addList )
        {
            
             for(Campaign_Member__c campCheck : campgnm)
                {
            
                        if(acc.Email_Last_Modified_Date__c < campCheck.Campaign_ID__r.Execution_Start_Date__c)
                        {
                            acc.Email_Status__c = 'Invalid';
                
                        }
                        if(acc.SMS_Last_Modified_Date__c < campCheck.Campaign_ID__r.Execution_Start_Date__c)
                        {
                                acc.Mobile_Status__c = 'Invalid';
             
                        }
                        
                        }
                
              For(Address__c add : acc.Addresses__r )
             
               {
                 system.debug('++++++++++'+acc.Addresses__r);
                 if(add.Address_Last_Modified_Date__c  < campCheck.Campaign_ID__r.Execution_Start_Date__c )
                {
                     
                     add.Status__c = 'Dead Mail';
                 }               
                   AddNewList.add(add);                   
               }
               
            
              accMainList.add(acc); 
              System.debug('++++++++++'+acc);  
              System.debug('++++++++++'+acc.Email_Status__c);
              System.debug('++++++++++'+acc.Mobile_Status__c);
                        
              }  
              
              System.debug('++++++++++'+accMainList); 
                                 
        update accMainList;
        update AddNewList;       
        
        
    }
   
    
    public static void beforeDeleteOperation(List<Campaign_Member__c> oldList) {
        List<String> CHILD_CAMPAIGN_STATUS_LIST = new List<String> {'Execution', 'Response collection', 'Completed'};
        Map<Id, Campaign_Member__c> campaignMemberMap = 
                    new Map<Id, Campaign_Member__c>([select Id from Campaign_Member__c where Id IN: oldList 
                                                                AND (Campaign_ID__r.Child_Campaign_Status__c IN: CHILD_CAMPAIGN_STATUS_LIST
                                                                      OR Retail_Campaign_Id__r.Child_Campaign_Status__c IN: CHILD_CAMPAIGN_STATUS_LIST )]);
        
        for(Campaign_Member__c campaignMemberRec : oldList) {
            if(campaignMemberMap.containsKey(campaignMemberRec.Id)) {
                campaignMemberRec.addError('You can\'t delete the Campaign Member for this Campaign Status.');
            }
        }
    }
}