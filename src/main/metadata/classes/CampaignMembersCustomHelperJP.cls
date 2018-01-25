/*
    Type:       Trigger
    Purpose:    CampaignMemberCustomHelper
    User Story:     
    Used By:    
    ---------------------------------------------------------------
    History:
    
    
*/
public  class CampaignMembersCustomHelperJP {
    
    /*  1.
        * Added By: Siva Krishna
        * Desc: trigger handler code for Custom Campaignmember
        * Updated: February 2, 2017
        2.
        Last modified by : Lokesh
        date   : 15th Mar, 2017
        Desc : if campaign members status is 'responded or not responded or bounced' then update the reated execution campaing status to 'Response collection'(if the status is not in 'completed')
        */
             public static Id da=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Dealer').getRecordTypeId();
   
    public static Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
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
        
        try{
        
            Database.Update(updateList,false);
            }
            Catch(Exception e)
            {
            }
        }
    }
    
    
    
    Public static void addSalesCampaignMember(List<Campaign_Member__c> camMember){
    
       Set<id> campaignid = New Set<id>();
       List<Campaign_Member__c> camList = New List<Campaign_Member__c>();
       
       For(Campaign_Member__c camMem : camMember){
       
              campaignid.add(camMem.Id);
            
            }
            
       List<Campaign_Member__c> camMemList =[Select id,Add_Sales_Staff__c,Add_Campaign_Member_ID__c,Add_Service_Staff__c,Campaign_ID__r.Add_Sales_Staff__c,Campaign_ID__r.Add_Service_Staff__c,Campaign_ID__r.Add_Campaign_Member_ID__c From Campaign_Member__c Where Id =:campaignid ]; 
            
       if(camMemList.size() >0){
       
           for(Campaign_Member__c cam : camMemList ){
           
            if(cam.Campaign_ID__r.Add_Sales_Staff__c == true){
            
                  cam.Add_Sales_Staff__c = true;
            
            }
            if(cam.Campaign_ID__r.Add_Service_Staff__c == true){
            
                   cam.Add_Service_Staff__c = true;
            
            }
            if(cam.Campaign_ID__r.Add_Campaign_Member_ID__c == true){
            
            
                   cam.Add_Campaign_Member_ID__c = true;
            }
              
              camList.add(cam); 
           } 
           
           update camList;
            
      }       
             
    }
    
    
        /* Added below method as part of changes related to SFDCJP-3089
    Written below method to share the campaign members records to dealer user in case of campaign members Retail_Campaign_Id__r.Dealer_Name__c ==null*/
    
    public static void CmSharingForDealer(List<Campaign_Member__c> newList)
    {
        Set<Id> recordIds = New Set<id>();
        Map<Id,String> UserMap = New Map<Id,String>();
        Set<String> dealerCode = New Set<String>();
        Set<String> accountName = New Set<String>();
        List<Campaign_Member__Share> RetailCampaignShare = New List<Campaign_Member__Share>();
        List<User> UserList;
        
                for(Campaign_Member__c RetMem : newList)
                {
                    If( RetMem.Retail_Campaign_Id__r.dealer_name__c != null)
                    {                     
                     recordIds.add(RetMem.Id);
                    }           
                }
        
                 if(recordIds != null)
                 {
                    UserList =[select id,Contact.Id,Dealer_GC_Code__c From User Where Id =: UserInfo.getUserId()];
                 }
                    
                    
                for(User u : UserList){
                    
                    If(u.ContactId != null){    
                        UserMap.put(u.id,u.Dealer_GC_Code__c);  
                        dealerCode.add(u.Dealer_GC_Code__c);
                    }   
                }
                List<Account> dealerAccList = [select Name,Dealer_GC_Code__c from Account where Dealer_GC_Code__c =:dealerCode AND RecordtypeId=:da];
                for(Account acc :dealerAccList){
                    accountName.add(acc.Name);
                }
        
                    List<Group>groupList = [select Id, Name, Type from Group where Name =: accountName];
                    if(recordIds.size()>0 && accountName != null){
                        
                       For(Campaign_Member__c RetMem : newList){
                      
                       for(Group groupRec : groupList){
                        Campaign_Member__Share RetShare = new Campaign_Member__Share();
                                        RetShare.AccessLevel = 'Edit';
                                        RetShare.UserOrGroupId = groupRec.Id;
                                        RetShare.ParentId = RetMem.Id;
                                        RetShare.RowCause = Schema.Campaign_Member__Share.RowCause.Manual;
                                        RetailCampaignShare.add(RetShare);
                                    }               
                       }
                    }
        
        
        
                            If(RetailCampaignShare.size()>0)
                            {
                            insert RetailCampaignShare;
                            }
    }
    
    public static void afterInsertSharing(List<Campaign_Member__c> newList){

Set<Id> recordIds = New Set<id>();
Map<Id,String> UserMap = New Map<Id,String>();
Set<String> dealerCode = New Set<String>();
Set<String> accountName = New Set<String>();
set<Campaign_Member__Share> campMemShare = New set<Campaign_Member__Share>();
Id da=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Dealer').getRecordTypeId();
For(Campaign_Member__c camMem : newList){
    If(CamMem.Retail_Campaign_Id__c != null && CamMem.MD__c == 'JP'){
     
     recordIds.add(camMem.Id);
    }
    
       If( CamMem.Retail_Campaign_Id__r.dealer_name__c != null)
                    {                     
                     recordIds.add(CamMem.Id);
                    }    
}

List<User> UserList =[select id,Contact.Id,Dealer_GC_Code__c From User Where Id =: UserInfo.getUserId()];

For(User u : UserList){
If(u.ContactId != null){    
UserMap.put(u.id,u.Dealer_GC_Code__c);  
dealerCode.add(u.Dealer_GC_Code__c);
}   
}
if(dealerCode.size()>0 && dealerCode != null){
List<Account> dealerAccList = [select Name,MD__c,Dealer_GC_Code__c from Account where Dealer_GC_Code__c =:dealerCode AND MD__c ='JP' AND RecordtypeId=:da];
For(Account acc :dealerAccList){
    accountName.add(acc.Name);
}
}
List<Group>grList = [select Id, Name, Type from Group where Name =: accountName];

if(recordIds.size()>0 && accountName != null){
    
   For(Campaign_Member__c camMem : newList){
  
   for(Group groupRec : grList){
    Campaign_Member__Share campShare = new Campaign_Member__Share();
                    campShare.AccessLevel = 'Edit';
                    campShare.UserOrGroupId = groupRec.Id;
                    campShare.ParentId = camMem.Id;
                    campShare.RowCause = Schema.Campaign_Member__Share.RowCause.Manual;
                    campMemShare.add(campShare);
                }
    
    
    
}
}
If(campMemShare.size()>0){
list<Campaign_Member__Share> campMemShareList = new list<Campaign_Member__Share>(campMemShare);
insert campMemShareList;
}
}

     public static void wholesaleCampaignSharing(List<Campaign_Member__c>newlist)
    {
        List<Campaign_Member__c>campaignmemberlist = [select id,name,Retail_Campaign_Id__r.Dealer_Name__c,Campaign_ID__r.Share_Campaign_Participation_Flag__c,Preferred_Dealer__c,Preferred_Dealer__r.name,Contact_Id__c from Campaign_Member__c where id IN:newlist];
        Map<Id, List<Id>> mapCamapignMember = new Map<Id, List<Id>>();
        Map<Id, List<Id>> mapCheckingType = new Map<Id, List<Id>>();
        List<Campaign_Member__share> list_SharingRecord = new List<Campaign_Member__share>();
        Set<Id> set_CampaignMemberId = new Set<Id>();
        List<Account_Link__c> ListAlk=new List<Account_Link__c>();
        //List<User> list_User = new List<User>();
        List<String> accNames=new List<String>();
        List<String> GcNames=new List<String>();
        Set<Id> set_AccountId = new Set<Id>();
        Set<Id> set_LinkId = new Set<Id>();
        Set<Id> set_CustomerId = new Set<Id>();
        List<Id> list_CamMemberId = new List<Id>();
        
        
        for(Campaign_Member__c vc : campaignmemberlist )
        {
           if( vc.Campaign_ID__r.Share_Campaign_Participation_Flag__c == true && vc.Preferred_Dealer__c == null && vc.contact_Id__c != null)
            {
             
                    if(!mapCheckingType.containsKey(vc.contact_Id__c))
                    {
                        mapCheckingType.put(vc.contact_Id__c, new List<Id>());
                    }
                    mapCheckingType.get(vc.contact_Id__c).add(vc.Id);
                    set_CampaignMemberId.add(vc.id);
                    set_CustomerId.add(vc.contact_Id__c);
            }
           if( vc.Retail_Campaign_Id__r.dealer_name__c != null && vc.Retail_Campaign_Id__c != null)
            {
             
                    if(!mapCheckingType.containsKey(vc.Retail_Campaign_Id__r.dealer_name__c))
                    {
                        mapCheckingType.put(vc.Retail_Campaign_Id__r.dealer_name__c, new List<Id>());
                    }
                    mapCheckingType.get(vc.Retail_Campaign_Id__r.dealer_name__c).add(vc.Id);
                    //set_CampaignMemberId.add(vc.id);
                   set_CampaignMemberId.add(vc.id);
            }
            if(vc.Campaign_ID__r.Share_Campaign_Participation_Flag__c == true && vc.Preferred_Dealer__c != null  )
            {
               
                if(!mapCamapignMember.containsKey(vc.Preferred_Dealer__c)){
                      mapCamapignMember.put(vc.Preferred_Dealer__c, new List<Id>());
                  }
                  mapCamapignMember.get(vc.Preferred_Dealer__c).add(vc.Id);
                  set_AccountId.add(vc.Preferred_Dealer__c);
            }
        }  
            if(set_AccountId.size() > 0)
            {
               
                List<Account> accName = [select Name,Dealer_GC_Code__c from Account where Id IN:set_AccountId];
                for(Account acc : accName)
                {
                    GcNames.add(acc.Dealer_GC_Code__c );
                 //   accNames.add(acc.Name);
                    system.debug('++++++++++++++'+'True');
                } 
                List<Account> accGCode = [select Name,Dealer_GC_Code__c from Account where Dealer_GC_Code__c  IN: GcNames AND RecordTypeId =: Dealer_RecordTypeId];
                for(Account accs : accGCode )
                {
                  accNames.add(accs.Name);  
                }
            } else if(set_CustomerId.size() >0)
            {
                system.debug('++++++++++++++'+'False');
                ListAlk=[select id,fromRole__c,toRole__c from Account_Link__c where toRole__c=:set_CustomerId];
                if(ListAlk.size() > 0)
                {
         
                    for(Account_Link__c  alk:ListAlk)
                    {
                        if(alk.fromRole__c!=null && alk.toRole__c!=null)
                        {
                            set_LinkId.add(alk.fromRole__c);
                        }     
                    }
                    List<Account> accName = [select Name,Dealer_GC_Code__c from Account where Id IN:set_LinkId];
                    for(Account acc : accName)
                    {
                         accNames.add(acc.Name);
                        GcNames.add(acc.Dealer_GC_Code__c );
            
                    }
                     List<Account> accGCode = [select Name,Dealer_GC_Code__c from Account where Dealer_GC_Code__c  IN: GcNames AND RecordTypeId =: Dealer_RecordTypeId];
                    for(Account accs : accGCode )
                    {
                        accNames.add(accs.Name);  
                
                    } 
            
                } 
            }
         
              system.debug('++++++++++++++'+accNames);
            
            
            List<Group> list_User = new List<Group>( [select Id, Name, Type from Group where Name IN:accNames]);
            system.debug('+++++++++++'+list_User);
          
        
        
        if(mapCamapignMember.size() > 0){
            
            list_SharingRecord.addAll(createDealerAccountSharing(mapCamapignMember));
        }
        
        if(mapCheckingType.size() > 0){
            list_SharingRecord.addAll(createPersonOrCompanyAccountSharing(mapCheckingType,set_CampaignMemberId));
            
        }
        
        if(list_SharingRecord.size() > 0){
            Database.insert(list_SharingRecord, false);
        }
        system.debug('++++++++++++++'+list_SharingRecord);
    }
    
    // Get all the Dealer Account with Same GC Code -
    private static Map<Id, Set<Id>> getAllDealerAccountWithSameGCCode(Set<Id> dealerAccountIdSet) {
        
         system.debug('dealerAccountIdSet&*&*&*&*&*'+dealerAccountIdSet);
        List<Account> dealerAccList = [select Id, Dealer_GC_Code__c from Account where Id =: dealerAccountIdSet AND RecordTypeId =: Dealer_RecordTypeId ];
      system.debug('dealerAccList&*&*&*&*&*'+dealerAccList);
        Map<String, Id> gcCodeToDealerAccIdMap = new Map<String, Id>();
        for(Account accRec : dealerAccList) {
            gcCodeToDealerAccIdMap.put(accRec.Dealer_GC_Code__c, accRec.Id);
        }
        
        Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = new Map<Id, Set<Id>>();
        if(dealerAccList.size() > 0) {
            List<Account> similarGCCodeDealerAccountList = [select Id, Dealer_GC_Code__c from Account where Dealer_GC_Code__c IN: gcCodeToDealerAccIdMap.keySet()
                                                                    AND RecordTypeId =: Dealer_RecordTypeId ];
                                                                    
                       system.debug('+++++++++++++++++++'+similarGCCodeDealerAccountList);
            for(Account accRec : similarGCCodeDealerAccountList) {
                if(!dealerIdToSimilarGCCodeDealerAccountIdsMap.containsKey(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c))) {
                    dealerIdToSimilarGCCodeDealerAccountIdsMap.put(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c), new Set<Id>());
                }
                dealerIdToSimilarGCCodeDealerAccountIdsMap.get(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c)).add(accRec.Id);
            }                                                       
        }
        return dealerIdToSimilarGCCodeDealerAccountIdsMap;
    }
    
    
    private static List<Campaign_Member__share> createDealerAccountSharing(Map<Id, List<Id>> mapCamapignMember){
    // START: Adding Similar GC Code related Account To Map which is sharing already.
       /* Set<Id> dealerAccIdSet = new Set<Id>();
        for(Id dealerAccId : mapCamapignMember.keySet()) {
            dealerAccIdSet.add(dealerAccId);
        }
        Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = getAllDealerAccountWithSameGCCode(dealerAccIdSet);
        
        for(Id dealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.keySet()) {
            if(mapCamapignMember.containsKey(dealerId)) {
                List<Id> vrIdList = mapCamapignMember.get(dealerId);
                for(Id similarGCCodeDealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.get(dealerId)) {
                    mapCamapignMember.put(similarGCCodeDealerId, vrIdList);
                }
            }
        }*/
        // Changing Sharing from User to Public Group
        List<Account> dealerAccList = [select Name from Account where Id IN: mapCamapignMember.keySet()];
        Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        for(Account dealerRec : dealerAccList) {
            dealerAccNameSet.add(dealerRec.Name);
            accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
        }

        // END: Adding Similar GC Code related Account To Map which is sharing already.
        List<Campaign_Member__share> list_SharingRecord = new List<Campaign_Member__share>();
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]){
            if(accNameToAccIdMap.containsKey(groupRec.Name) && mapCamapignMember.containsKey(accNameToAccIdMap.get(groupRec.Name))){
                for(Id acId : mapCamapignMember.get(accNameToAccIdMap.get(groupRec.Name))){
                    Campaign_Member__share dmRequestShare = new Campaign_Member__share();
                    dmRequestShare.AccessLevel = 'Edit';
                    dmRequestShare.UserOrGroupId = groupRec.Id;
                    dmRequestShare.ParentId = acId;
                    dmRequestShare.RowCause = Schema.Campaign_Member__share.RowCause.Manual;
                    list_SharingRecord.add(dmRequestShare);
                }
            }
        }
        return list_SharingRecord;
    }
    
    
    private static List<Campaign_Member__share> createPersonOrCompanyAccountSharing(Map<Id, List<Id>> mapCheckingType,Set<Id> set_CampaignMemberId)
    {
        List<Account_Link__c> ListAlk=new List<Account_Link__c>();
        Set<Id> DealerAccId=new Set<Id>();
        Set<Id> VrID=new Set<Id>();
        system.debug('%^%^%^%^^%^%^% mapCheckingType'+mapCheckingType);
        ListAlk = [select id,fromRole__c,toRole__c from Account_Link__c where toRole__c=:mapCheckingType.keySet() Or fromRole__c=:mapCheckingType.keySet()];
         system.debug('%^%^%^%^^%^%^% ListAlk '+ListAlk );
        for(Account_Link__c alk:ListAlk) {
            DealerAccId.add(alk.fromRole__c);
        }
        system.debug('%^%^%^%^^%^%^% DealerAccId'+DealerAccId);
        DealerAccId.remove(null);
         system.debug('%^%^%^%^^%^%^% DealerAccId'+DealerAccId);
        // Start: Share with all Dealer Account with same GC Code
        Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = getAllDealerAccountWithSameGCCode(DealerAccId);
        for(Id dealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.keySet()) {
            for(Id similarGCCodeDealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.get(dealerId)) {
                DealerAccId.add(similarGCCodeDealerId);
            }
        }
        // Finish: Share with all Dealer Account with same GC Code
        
        
        // Changing Sharing from User to Public Group
        List<Account> dealerAccList = [select Name from Account where Id IN: DealerAccId];
        Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        for(Account dealerRec : dealerAccList) {
            dealerAccNameSet.add(dealerRec.Name);
            accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
        }
        
        
        System.debug('DealerAccId  newList'+DealerAccId);

        List<Campaign_Member__share> list_SharingRecord = new List<Campaign_Member__share>();
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet])
        {
            if(set_CampaignMemberId != null)
            {
                for(Id ids:set_CampaignMemberId)
                {
                    Campaign_Member__share dmRequestShare = new Campaign_Member__share();
                    dmRequestShare.AccessLevel = 'Edit';
                    dmRequestShare.UserOrGroupId = groupRec.Id;
                    dmRequestShare.ParentId = ids;
                    dmRequestShare.RowCause = Schema.Campaign_Member__share.RowCause.Manual;
                    list_SharingRecord.add(dmRequestShare);
                }
            }
        }
        return list_SharingRecord;
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
                //newAccounts.add(accnt);    
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
    public static void afterUpdateCampaignMembers(List<Campaign_Member__c> afterCampMembers){
        Set<Id> parentRetailCampIds = new Set<Id>();
        Set<String> campaignMemberStatusSet = new Set<String>{'Bounced', 'Responded','Not Responded'};
        for(Campaign_Member__c campMem : afterCampMembers ){
            
                if(campMem.Retail_Campaign_Id__c != null)
                    parentRetailCampIds.add(campMem.Retail_Campaign_Id__c);
                       
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
    
   public static void SegmentationSharingForDealer(List<Segmentation_Criteria__c> newList)
    {
        Set<Id> recordIds = New Set<id>();
        Map<Id,String> UserMap = New Map<Id,String>();
        Set<String> dealerCode = New Set<String>();
        Set<String> accountName = New Set<String>();
        List<Segmentation_Criteria__Share> RetailCampaignShare = New List<Segmentation_Criteria__Share>();
        List<User> UserList;
        
                for(Segmentation_Criteria__c RetMem : newList)
                {
                    If( RetMem.Ownerid != null)
                    {                     
                     recordIds.add(RetMem.OwnerId);
                    }           
                }
        
                 if(recordIds != null)
                 {
                    UserList =[select id,Contact.Id,Dealer_GC_Code__c From User Where Id =:recordIds ];
                 }
                    
                    
                for(User u : UserList){
                    
                    If(u.ContactId != null){    
                        UserMap.put(u.id,u.Dealer_GC_Code__c);  
                        dealerCode.add(u.Dealer_GC_Code__c);
                    }   
                }
                List<Account> dealerAccList = [select Name,Dealer_GC_Code__c from Account where Dealer_GC_Code__c =:dealerCode AND RecordtypeId=:da];
                for(Account acc :dealerAccList){
                    accountName.add(acc.Name);
                }
        
                    List<Group>groupList = [select Id, Name, Type from Group where Name =: accountName];
                    if(recordIds.size()>0 && accountName != null){
                        
                       For(Segmentation_Criteria__c RetMem : newList){
                      
                       for(Group groupRec : groupList){
                        Segmentation_Criteria__Share RetShare = new Segmentation_Criteria__Share();
                                        RetShare.AccessLevel = 'Edit';
                                        RetShare.UserOrGroupId = groupRec.Id;
                                        RetShare.ParentId = RetMem.Id;
                                        RetShare.RowCause = Schema.Segmentation_Criteria__Share.RowCause.Manual;
                                        RetailCampaignShare.add(RetShare);
                                    }               
                       }
                    }
        
        
        
                            If(RetailCampaignShare.size()>0)
                            {
                            insert RetailCampaignShare;
                            }
    } 
    
}