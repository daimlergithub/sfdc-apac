/*
    Type:       Trigger
    Purpose:    CampaignMemberCustomHelper
    User Story:     
    Used By:    
    ---------------------------------------------------------------
    History:
    
    
*/
public with sharing class CampaignMembersCustomHelperJP {
    
    /*
        * Added By: Siva Krishna
        * Desc: trigger handler code for Custom Campaignmember
        * Updated: February 2, 2017
        */
    
    public static void afterUpdateOperation(Map<Id, Campaign_Member__c> oldMap, Map<Id, Campaign_Member__c> newMap, List<Campaign_Member__c> newList) {
        Set<Id> campaignIdSet = new Set<Id>(); 
        String FINAL_CAMPAIGN_STATUS = 'Response collection';
        Set<String> campaignMemberStatusSet = new Set<String>{'Bounced', 'Responded', 'Not Responded'};
        for(Campaign_Member__c campaignMemberRec : newList) {
            if(oldMap.get(campaignMemberRec.Id).Status__c == 'Executed' && campaignMemberStatusSet.contains(newMap.get(campaignMemberRec.Id).Status__c)) {
                campaignIdSet.add(campaignMemberRec.Campaign_ID__c);
            }
        }
        
        List<Campaign> campaignList = [select Name, Child_Campaign_Status__c from Campaign where Id =: campaignIdSet]; 
        for(Campaign campaignRec : campaignList) {
            campaignRec.Child_Campaign_Status__c = FINAL_CAMPAIGN_STATUS;
        }
        if(campaignList.size() > 0) {
            update campaignList;
        }
    }
    
    
    /*
     Added by : Lokesh 
     trigger : After Insert Campaign member
     Desc  : For new campaign member if conatac_id__c is empty then assign the account which is exist based on 'Response firstname, response lastname, response lastname', then assign
             that account to new campaign member or create new account based on the above fields and assign that account to campaign member.
    */
    public static void updateCampaignMemberStatusResponseCollection(List<campaign_member__c> newList){
        Set<Id> camMemSet = new Set<Id>();
        List<campaign_member__c> newAccCampMem = new List<campaign_member__C>();
        List<String> firstName = new List<String>();
        List<String> lastName = new List<String>();
        List<String> email = new List<String>();
        List<Account> accList = new List<Account>();
        List<campaign_member__C> campmembers = new List<campaign_member__c>();
        List<campaign_member__c> camMemList = new List<campaign_member__C>();
        List<campaign_member__c> updateCampList = new List<campaign_member__C>();
        List<Account> newAccounts = new List<Account>();
        RecordType perAccRecType =  [select id from RecordType where sObjecttype = 'Account' AND Name = 'Person Account' limit 1];
        Boolean accFind = false;
        
        
        for(campaign_member__c curMem : newList){
            camMemSet.add(curMem.Id);   
        }
        campMembers = [SELECT Id,Name,Status__c,Response_email__c, Response_firstName__c,response_lastName__c,contact_id__c,campaign_id__c FROM Campaign_member__c WHERE Id IN: camMemSet];
        for(Campaign_Member__c cm : campMembers){
            if(cm.contact_Id__c == NULL && cm.Response_FirstName__c != NULL && cm.Response_LastName__c != NULL && cm.Response_Email__c != NULL){
                camMemList.add(cm);
                firstName.add(cm.Response_FirstName__c);
                lastName.add(cm.Response_LastName__c);
                email.add(cm.Response_Email__c);
            }
        }
        accList = [SELECT Id,Name,FirstName,LastName,Email__C FROM Account WHERE FirstName IN: firstName AND lastName IN: lastName AND Email__c IN: email AND RecordTypeId =: perAccRecType.Id];
        System.debug('Acclist'+accList);
        if(accList != NULL && !accLIst.isEmpty()){
            for(campaign_member__c c : camMemList){
                System.debug('CampMember'+c);
                for(Account acc : accList){
                    System.Debug('account'+acc);
                    if(c.Response_Email__c == acc.Email__c && c.Response_FirstName__c == acc.FirstName && c.Response_LastName__c == acc.LastName){
                        c.Contact_Id__c = acc.Id;
                        System.debug('AccountFoundCampaign'+c);
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
                System.debug('Enter to else acc'+acc);
                newAccounts.add(acc);
                newAccCampMem.add(c);
            }
            
        }
        System.debug('newAccount'+newAccounts);
        if(newAccounts != NULL && !newAccounts.isEmpty()){
            insert newAccounts;
            for(campaign_member__c camp : newAccCampMem){
                for(Account acct : newAccounts){
                    System.debug('========'+camp.Response_Email__c +'=='+ acct.PersonEmail +'=='+ camp.Response_FirstName__c +'=='+ acct.FirstName+'='+  camp.Response_LastName__c +'=='+ acct.LastName);
                    if(camp.Response_Email__c == acct.Email__c && camp.Response_FirstName__c == acct.FirstName && camp.Response_LastName__c == acct.LastName){    
                        camp.contact_Id__c = acct.Id;
                        camp.Status__c= 'Responded';
                        System.debug('AccountNotFoundcampaing'+camp);
                        updateCampList.add(camp);
                    }
                }
            }
        }
        try{
            if(updateCampList != NULL && !updateCampList.isEmpty()){
                update updateCampList;
            }
        }
        catch(Exception e){
            System.debug('Error occured'+e);
            System.debug('Error Line'+e.getLineNumber());
        }
    }
}
       /*
         Added By: Siva Krishna
        */