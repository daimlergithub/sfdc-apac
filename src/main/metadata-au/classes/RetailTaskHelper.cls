public with sharing class RetailTaskHelper 
{
    public static Set<ID> vehicleIds = new Set<ID>();
    public static Set<ID> customerIds = new Set<ID>();
    public static Id servicerecordId = Schema.sObjectType.Retail_task__c.getRecordTypeInfosByName().get('Service').getRecordTypeId();
    private static final String OrgWideEmailAddressId= [Select id from OrgWideEmailAddress where Address =: UtilCustomSettings.getOrgWideDefaultAddress(UtilConstant.ORGWIDE_EMAIL_ADDRESS_DEFAULT)].Id;
    public static void au_After_Insert_Update_Events(list<Retail_Task__c> lstRTNew,map<id,Retail_Task__c> rtNewMap,map<id,Retail_Task__c> rtOldMap,boolean isInsert,boolean isUpdate)
    {
        List<Retail_Task__c> insertCvrs = new List<Retail_Task__c>();
        
        // For US_AU-CD-019
        Set<String> contractIds = new Set<String>();
        
        for(Retail_Task__c cvr : lstRTNew) {
            if(isInsert || isUpdate){
                customerIds.add(cvr.Account__c);
                vehicleIds.add(cvr.Related_Vehicle__c);
                insertCvrs.add(cvr);
            }
            contractIds.add(cvr.Id);
        }
        
        // US_AU-CD-001 & 2 No.11
        if(customerIds.size()>0 && vehicleIds.size()>0){
            updataWhenCreateCCR(vehicleIds, customerIds, insertCvrs);
        }
        
        // US_AU-CD-019, If the borrower is company, create a Company Individual Relationship.
        if(contractIds.size() > 0){
            createCompanyIndividualRelationship(contractIds);
        }
    
        // Added by Polaris Yu 2013-8-23; For User Story: 
        //    US_AU-Lead-011, US_AU-Lead-012
        if(isUpdate){
            // Auto create leads for contracts at 150 days before the
            //    end date
       
            autoCreateLeads(rtNewMap, rtOldMap);
        }
    }
    
    //US-CD-001
    //Get vehiches Vehicle_Group__c by vehicle id
    public static Map<id,Vehicle__c> getVehichles(set<Id> ids){
        return new Map<id,Vehicle__c>(
        [select id,
               Vehicle_Group__c
        from Vehicle__c 
        where Id in :ids]);
    }
       
    //US-CD-001 No.11
    //When PA gets a Customer_Contract_Relationship__c
    public static void updataWhenCreateCCR(Set<Id> vehicleId ,Set<Id> customerId, List<Retail_Task__c> cvrs){
        // Modified by Polaris Yu 2013-10-22, changed 'List<Account>' to 'Set<Account>'
        List<Account> accounts = new List<Account>();
        set<id> rtaskId = new set<id>();
        List<Retail_Task__c> retailTaskList = new List<Retail_Task__c>();
        Map<id,Account> accs = AccountHelper.getCustomerInfos(customerId);
        Map<id,Account> accountsForUpdate = new Map<id,Account>();
        Map<id,Vehicle__c> vehichles = getVehichles(vehicleId);
        for(Retail_Task__c r: cvrs)
        {            
            if(r.RecordTypeId != servicerecordId)
            {
                rtaskId.add(r.Id);
            }
        }
        
        retailTaskList = [select id,Account__c,Related_Vehicle__c from Retail_Task__c where ID IN :rtaskId];

        if(!retailTaskList.isEmpty() && retailTaskList != null)
        {                    
            for(Retail_Task__c curCcr: retailTaskList)
            {
                if(!String.isblank(curCcr.Account__c)){
                    Account acc = accs.get(curCcr.Account__c);
                    if(vehichles.get(curCcr.Related_Vehicle__c) != null){
                        if (vehichles.get(curCcr.Related_Vehicle__c).Vehicle_Group__c == 'PC' ){
                            if(acc.PC_Status__c == 'Customer'){
                               continue;
                            }else{
                               acc.PC_Status__c = 'Customer';
                            }
                        }
                        if (vehichles.get(curCcr.Related_Vehicle__c).Vehicle_Group__c == 'CV'){
                            if(acc.CV_Status__c == 'Customer'){
                               continue;
                            }else{
                               acc.CV_Status__c = 'Customer';
                            }
                        }
                        if (vehichles.get(curCcr.Related_Vehicle__c).Vehicle_Group__c == 'Van'){
                            if(acc.VAN_Status__c == 'Customer'){
                               continue;
                            }else{
                               acc.VAN_Status__c = 'Customer';
                            }
                        }
                    }
                    accountsForUpdate.put(acc.Id, acc);
                }
            }
        }
        
        DBUtil.updateSobjects(accountsForUpdate.values());
        // End of Added Part, Polaris Yu 2013-10-22
    }    
    
    // For US-CD-019 NO.2
    public static void createCompanyIndividualRelationship(Set<String> contractIds){
        List<Account> personAccounts = new List<Account>();
        //Barney lai 2014-3-13 start
        Map<Id, Account> idPersonAccounts = new Map<Id, Account>();
        //Barney lai 2014-3-13 end
        for(Retail_Task__c contract : [select Account__c, Signer__c, Account__r.RecordType.Name, Signer__r.Company__c
                                 from Retail_Task__c where Id in :contractIds]){
            if(contract.Account__r.RecordType.Name == 'Company' && contract.Signer__c != null){
                contract.Signer__r.Company__c = contract.Account__c;
                //Barney lai 2014-3-13 start
                idPersonAccounts.put(contract.Signer__r.id, contract.Signer__r);
                //Barney lai 2014-3-13 end
            }
        }
        //Barney lai 2014-3-13 start
        personAccounts = idPersonAccounts.values();
        //Barney lai 2014-3-13 end
        update personAccounts;
    }

    // Auto Create Leads
    // Added by Polaris Yu 2013-8-23; For User Story: 
    //    US_AU-Lead-011, US_AU-Lead-012
    public static void autoCreateLeads(Map<Id, Retail_Task__c> newMap
        , Map<Id, Retail_Task__c> oldMap){
        // Select the contracts that the '*150 Days Before EOC'
        //    field of which are updated to TRUE
        List<Retail_Task__c> finCntrctList = new List<Retail_Task__c>();
        List<Retail_Task__c> fltCntrctList = new List<Retail_Task__c>();
        List<Vehicle_Relationship__c> vehRelList = new List<Vehicle_Relationship__c>(); 
        Date today = Date.Today();
            
        for(Id curCntrctId : newMap.keySet()){
            system.debug('>>>>'+oldMap.get(curCntrctId).X150_Days_Before_EOC__c);
            system.debug('>>>>1'+newMap.get(curCntrctId).X150_Days_Before_EOC__c);
            if((oldMap.get(curCntrctId).X150_Days_Before_EOC__c
                != newMap.get(curCntrctId).X150_Days_Before_EOC__c)
                && newMap.get(curCntrctId).X150_Days_Before_EOC__c == TRUE && newMap.get(curCntrctId).EndDate__c > today){
                if(newMap.get(curCntrctId).Fleet__c == TRUE){
                    fltCntrctList.add(newMap.get(curCntrctId));
                }
                else{
                    
                    finCntrctList.add(newMap.get(curCntrctId));                    
                }
            }
        }

        List<Lead__c> newLeadList = new List<Lead__c>();
        // Create finance leads based on the non-fleet contracts
        if(finCntrctList.size() > 0 && !finCntrctList.isEmpty()){
            // Get the finance lead record type information
            RecordType financeLdRT = [SELECT Id, Name FROM RecordType
                                      WHERE Name = 'Finance Lead'];
            vehRelList = [Select Id, Name from Vehicle_Relationship__c 
                         where Contact__c in : customerIds and 
                         Vehicle_ID__c in : vehicleIds and Car_Relation__c = 'Owner' order by createdDate desc limit 1];
            if(financeLdRT != null){
                for(Retail_Task__c curCntrct : [select Id,Account__c, OwnerId, Related_Dealer__c, Account__r.RecordType.Name
                                 from Retail_Task__c where Id in :finCntrctList]){
                    Lead__c newLead = new Lead__c();
                    newLead.RecordTypeId = financeLdRT.Id;
                    newLead.Existing_Contract__c = curCntrct.Id;
                    newLead.Nature_of_Request__c = 'End of Contract';
                    newLead.OwnerId = curCntrct.OwnerId;
                    newLead.CAC_Lead_Status__c = 'New Enquiry';
                    newLead.Lead_Source__c = 'End of Contract';
                    if(curCntrct.Account__r.RecordType.Name == 'Person Account')
                    {
                        newLead.Contact__c = curCntrct.Account__c;
                    }
                    else if(curCntrct.Account__r.RecordType.Name == 'Company')
                    {
                        newLead.Company_Account__c = curCntrct.Account__c; 
                    }
                    if(vehRelList != null && !vehRelList.isEmpty())
                    {
                        newLead.VehicleRel_No__c = vehRelList[0].Id;
                    }
                    newLead.Assigned_Dealer__c = curCntrct.Related_Dealer__c;
                    newLead.Is_Finance_Send_Email_Before_150_Days__c = true;
                    newLead.Business_Unit__c = 'MBFS Cars';
                    newLead.Sub_BusinessUnit__c = 'Finance & Insurance';
                    //TODO
                    //newLead.CMS_Contract_Number__c = curCntrct.Contract_Id__c;
                    //TODO
                    //newLead.Vehicle__c = curCntrct.Vehicle__c;
                    newLeadList.add(newLead);
                }
            }
        }

        // Create fleet leads based on the fleet contracts
        if(fltCntrctList.size() > 0){
            // Get the fleet lead record type information
            RecordType fleetLdRT = [SELECT Id, Name FROM RecordType
                                    WHERE Name = 'Fleet Finance Lead'];
            if(fleetLdRT != null){
                for(Retail_Task__c curCntrct : fltCntrctList){
                    Lead__c newLead = new Lead__c();
                    newLead.RecordTypeId = fleetLdRT.Id;
                    newLead.Existing_Contract__c = curCntrct.Id;
                    newLead.Nature_of_Request__c = 'End of Contract';
                    newLead.OwnerId = curCntrct.OwnerId;
                    newLead.CAC_Lead_Status__c = 'New Enquiry';
                    newLead.Lead_Source__c = 'End of Contract';
                    newLead.Company_Account__c = curCntrct.Account__c;
                    newLead.Assigned_Dealer__c = curCntrct.Related_Dealer__c;
                    newLead.Business_Unit__c = 'MBFS Cars';
                    newLead.Sub_BusinessUnit__c = 'Finance & Insurance';
                    newLead.Is_Fleet_Send_Email_Before_150_Days__c = true;
                    //TODO
                    //newLead.CMS_Contract_Number__c = curCntrct.Contract_Id__c;
                    //TODO
                    //newLead.Vehicle__c = curCntrct.Vehicle__c;
                    newLeadList.add(newLead);
                }
            }
        }

        // Insert the new leads into the system
        if(newLeadList.size() > 0){
            try{
               
                insert newLeadList;
               
                // Send email notifications to corresponding recipients
                //US_AU_CR-000171 Modified by Bing Start
                //LeadHelper.sendEOCEmailNotifications(newLeadList);
                LeadHelper.send171Email(newLeadList);
               
                //US_AU_CR-000171 Modified by Bing End
            }
            catch(DMLException e){
                Trigger.new[0].addError('Error: ' + e);
            }
        }
    }
    
    public static void sentEmailAfterStatusToCurrent(List<Retail_Task__c> retailTasklst,Map<Id,Retail_Task__c> oldMap,Map<Id,Retail_Task__c>newMap,Boolean isInsert,Boolean isUpdate){
          Set<Id> dealerIds = new Set<Id>();
            for(Retail_Task__c retailtaskObj : retailTasklst){
                if(retailtaskObj.Status__c == UtilConstant.CURRENT || retailtaskObj.Status__c == UtilConstant.IRREGULAR|| retailtaskObj.Status__c == UtilConstant.REGULARCOMPILED){
                    dealerIds.add(retailtaskObj.Related_Dealer__c);
                }
            }
            if(dealerIds != null && dealerIds.size() > 0){
                List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
                String[] businessUserEmailAddress = new String[]{};
                
                for(Account accountObj : [Select Id,(Select Id,Email FROM Contacts where Job_Title__c ='Management - F&I Business Manager') FROM Account where Id IN:dealerIds]){
                    for(Contact contactObj : accountObj.Contacts)
                    {
                        if(contactObj.Email != null)
                        {
                            businessUserEmailAddress.add(contactObj.Email);
                            businessUserEmailAddress.add(contactObj.Email);
                        }
                    }
                 }
                 
                 EmailTemplate emailTemplateObj = [Select Subject,Body FROM EmailTemplate where isActive = true and DeveloperName ='Settlement_Email_Template'];
                 EmailTemplate emailTemplateObjForRegular  = [Select Subject,Body FROM EmailTemplate where isActive = true and DeveloperName ='Irregular_Contract'];
                 if(emailTemplateObj != null){
                     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                     
                     String body;
                     Map<Id,Account> acclst = new Map<Id,Account>([SELECT Name,Id FROM Account where Id IN:dealerIds]);
                     for(Retail_Task__c retailTaskObj : retailTasklst){
                        
                            String subject ='';
                            String plainBody ='';
                            if(retailtaskObj.Status__c == UtilConstant.CURRENT && oldMap.get(retailtaskObj.Id).status__c != UtilConstant.CURRENT){
                              subject  = emailTemplateObj.Subject;
                              plainBody = emailTemplateObj.Body ;
                            }else if((retailtaskObj.Status__c == UtilConstant.IRREGULAR && oldMap.get(retailtaskObj.Id).status__c != UtilConstant.IRREGULAR) || (retailtaskObj.Status__c == UtilConstant.REGULARCOMPILED
                                   &&  oldMap.get(retailtaskObj.Id).status__c != UtilConstant.REGULARCOMPILED)) {
                                subject  = emailTemplateObjForRegular.Subject;
                                plainBody = emailTemplateObjForRegular.Body ;
                            }
   //                         system.debug();

                            if(subject != null && subject != '' && plainBody != null && plainBody!= '' && !businessUserEmailAddress.isEmpty()){
                                mail.setToAddresses(businessUserEmailAddress);
                                if(acclst !=null && !acclst.isempty() && acclst.containsKey(retailTaskObj.Related_Dealer__c))
                                {
                                    if(retailTaskObj.Related_Dealer__c!= null)
                                    {
                                        subject  = subject.replace('{!Account.Name}',acclst.get(retailTaskObj.Related_Dealer__c).Name);
                                    }
                                    else
                                    {
                                        subject = subject.replace('{!Account.Name}', '');
                                    }
                                    if(retailTaskObj.Related_Dealer__c != null)
                                    {
                                        plainBody  = plainBody .replace('{!Account.Name}',acclst.get(retailTaskObj.Related_Dealer__c).Name);
                                    }
                                    else
                                    {
                                        plainBody  = plainBody .replace('{!Account.Name}','');
                                    }
                                    if(retailTaskObj.ContractNumber__c != null)
                                    {
                                        plainBody  = plainBody.replace('{!RetailTask.ContractNumber}',retailTaskObj.ContractNumber__c);
                                    }
                                    else
                                    {
                                        plainBody  = plainBody.replace('{!RetailTask.ContractNumber}','');
                                    }
                                    if(retailTaskObj.Amount_Financed__c != null)
                                    {
                                        plainBody  = plainBody.replace('{!RetailTask.FINANCED}',String.valueOf(retailTaskObj.Amount_Financed__c));
                                    }
                                    else
                                    {
                                        plainBody  = plainBody.replace('{!RetailTask.FINANCED}','');
                                    }
                                    if(retailtaskObj.Status__c == UtilConstant.IRREGULAR || retailtaskObj.Status__c == UtilConstant.REGULARCOMPILED){
                                       if(retailTaskObj.Settlement_Officer__c != null){
                                          plainBody  = plainBody.replace('(Settlement officer)',retailTaskObj.Settlement_Officer__c);
                                       }else{
                                           plainBody  = plainBody.replace('(Settlement officer)','');
                                       }
                                       if(retailTaskObj.Compliance_Comment__c != null){
                                           plainBody  = plainBody.replace('(Compliance comment)',retailTaskObj.Compliance_Comment__c);
                                       }else{
                                           plainBody  = plainBody.replace('(Compliance comment)','');
                                       }
                                    }
                              
                                    mail.setSubject(subject);
                                    mail.setPlainTextBody(plainBody);
                                    mail.setOrgWideEmailAddressId(OrgWideEmailAddressId);
                                    mails.add(mail);
                                    
                                    system.debug('::Eneter here:'+subject);
                                     system.debug('::Eneter here:'+plainBody );
                               }
                            }
                    }
                     
                      
                     // Messaging.sendEmail(mails);
                }
    
    // End of added part, Polaris Yu 2013-8-23
            }
        }
    //Update Finance and Insurance Status of Account
    public static void upadteAccountFinancstatusafterInsertUpadte(List<Retail_task__c> retasklist)
    {
        set<id> accid = new set<id>();
        List<Account> acclist = new List<Account>();
        List<Account> updateacclist = new List<Account>();
        map<id,Account> accountMap = new map<id,Account>();
        Id insurancerecordId = Schema.sObjectType.Retail_task__c.getRecordTypeInfosByName().get('Insurance').getRecordTypeId();
        for(Retail_task__c r : retasklist)
        {
            if(r.RecordTypeId == insurancerecordId)
               {
                   if(!UtilConstant.Recursivefire)
                   accid.add(r.Account__c);
               }            
        }
        if(!accid.isEmpty())
        {
            acclist = [select id,Insurance_Status__c from Account where ID IN: accid];
        }
        if(!acclist.isEmpty())
        {
            for(Account a : acclist)
            {
                a.Insurance_Status__c = 'Customer';
                updateacclist.add(a);
            }
        }
        if(!updateacclist.isEmpty() && updateacclist != null)
        {
            for(Account acc:updateacclist)
            {
                accountMap.put(acc.Id, acc);
            }            
        }
        if(accountMap.values()!=null && !accountMap.values().isEmpty() && System.IsBatch() == false && System.isFuture() == false)   
          { 
            UtilConstant.Recursivefire=true;
            String JSONString = JSON.serialize(accountMap.values());
            updateaccounts(JSONString);
          }
    }
        
    @future
    public static void updateaccounts(String account)
    {
        system.debug('accountvalues>>>>>>'+account);
        List<Account> futureAccountList=(List<Account>)JSON.deserialize(account,List<Account>.class);
        UtilDB.updateSobjects(futureAccountList);
    }
    
    //Update PC,CV,Van Status of Account
    public static void upadteAccountafterInsertUpadte(List<Retail_task__c> tasklist)
    {
        set<id> accountid = new set<id>();
        set<id> vehicleid = new set<id>();
        string vehiclegroup;
        List<Vehicle__c> vechlist = new List<Vehicle__c>();
        List<Account> acclist = new List<Account>();
        List<Account> updateacclist = new List<Account>();
        map<id,string> vehgroupmap = new map<id,string>();        
        for(Retail_task__c r : tasklist)
        {
            if(r.RecordTypeId == servicerecordId)
            {
                accountid.add(r.Account__c);
                vehicleid.add(r.Related_Vehicle__c);
            }
        }
        if(!vehicleid.isEmpty())
        {
            vechlist = [select id,Vehicle_group__c from vehicle__c where ID IN : vehicleid];
        }
        if(!accountid.isEmpty())
        {
            acclist = [select id, PC_Status__c, VAN_Status__c, CV_Status__c from Account where ID IN :accountid];
        }
        if(!vechlist.isEmpty())
        {
            for(vehicle__c v :vechlist)
            {
                vehgroupmap.put(v.Id ,v.Vehicle_Group__c);
            }
        }
        for(Account acc : acclist)
        {
            for(Retail_Task__c re : tasklist)
            {
                if(re.Account__c == acc.Id)
                {
                    vehiclegroup = vehgroupmap.get(re.Related_Vehicle__c);
                    if(vehiclegroup == 'PC' && acc.PC_Status__c != 'Customer')
                    {
                        acc.PC_Status__c = 'Service Only';
                    }
                    else if(vehiclegroup == 'CV' && acc.CV_Status__c != 'Customer')
                    {
                        acc.CV_Status__c = 'Service Only';
                    }
                    else if(vehiclegroup == 'Van' && acc.VAN_Status__c != 'Customer')
                    {
                        acc.VAN_Status__c = 'Service Only';
                    }
                    updateacclist.add(acc);
                }
            }
        }
        update updateacclist;
    }
    
    /* To Share Account and Related Objects with Service Dealers*/
    
    public static void sharewithServiceDealers(list<Retail_Task__c> retailtaskList)
    {
        set<id> rtaskid = new set<id>();
        set<string> groupid = new set<string>();
        set<id> shraccid = new set<id>();
        set<id> relatedvechId = new set<id>();
        map<string,id> groupMap = new map<string,id>();
        map<id,id> dealermap = new map<id,id>();
        map<id,id> acclinkmap = new map<id,id>();
        map<id,id> vehMap = new map<id,id>();
        map<id,id> chkduplicateShareMap = new map<id,id>();
        map<id,map<id,id>> accvechmMap = new map<id,map<id,id>>();
        map<id,List<Vehicle_Relationship__c>> vrMap = new map<id,List<Vehicle_Relationship__c>>();
        List<Vehicle_Relationship__c> vrelList = new List<Vehicle_Relationship__c>();
        List<Accountshare> duplisharedList = new List<AccountShare>();
        List<Account_Link__c> acclinkList = new List<Account_Link__c>();
        List<Retail_Task__c> rtasklist = new List<Retail_Task__c>();
        List<Vehicle_Relationship__c> sharedVrlist = new List<Vehicle_Relationship__c>();
        List<Group> groupList = new List<Group>();
        List<sobject> shareList = new List<sobject>();
        for(Retail_Task__c rtask : retailtaskList)
        {
            if(rtask.RecordTypeId == servicerecordId && rtask.Service_Dealer__c != null && rtask.Related_Vehicle__c != null)
            {
                rtaskid.add(rtask.Id);
				relatedvechId.add(rtask.Related_Vehicle__c);                
            }
        }
        
        if(!rtaskid.isEmpty() && rtaskid != null)
        {
            rtasklist = [select id , Account__c, Related_Vehicle__c, Service_Dealer__c , Service_Dealer__r.Name from Retail_Task__c where id =:rtaskid];
        }
        if(!relatedvechId.isEmpty() && relatedvechId != null)
        {
            sharedVrlist = [select id , Contact__c , Vehicle_ID__c from Vehicle_Relationship__c where Vehicle_ID__c =:relatedvechId ORDER BY CreatedDate DESC];                        
        }
        system.debug('sharedVrlist>>>>>' + sharedVrlist);
        
        if(!sharedVrlist.isEmpty() && sharedVrlist != null)
        {            
            for(Vehicle_Relationship__c shVr : sharedVrlist)
            {
                vrelList.add(shVr);
                vrMap.put(shVr.Vehicle_ID__c , vrelList);
                vehMap.put(shVr.Id, shVr.Vehicle_ID__c);
                accvechmMap.put(shVr.Contact__c, vehmap);
            }
        }
        system.debug('VehiclerelationList Size>>>>>' + vrelList.size());
        system.debug('VehiclerelationList>>>>>' + vrelList);
        
        if(!rtasklist.isEmpty() && rtasklist != null)
        {
            for(Retail_Task__c rts : rtasklist)
            {
                groupid.add(rts.Service_Dealer__r.Name);
                shraccid.add(vrMap.get(rts.Related_Vehicle__c).get(0).contact__c);                
            }
        }
		if(!shraccid.isEmpty() && shraccid != null)
        {
            duplisharedList =[select AccountId, UserOrGroupId, AccountAccessLevel from AccountShare where AccountId =:shraccid];
            acclinkList = [select id , toRole__c,fromRole__c from Account_Link__c where toRole__c =:shraccid];
        }
        
        if(!rtasklist.isEmpty() && rtasklist != null)
        {
            for(Retail_Task__c acrts : rtasklist)
            {
                if(!acclinkList.isEmpty() && acclinkList != null)
                {
                    for(Account_Link__c alink : acclinkList)
                    {
                        if(acrts.Service_Dealer__c == alink.fromRole__c)
                        {
                            acclinkmap.put(alink.toRole__c , alink.id);
                        }
                    }
                }
            }
        }
        system.debug('duplisharedList>>>' + duplisharedList);
        if(!duplisharedList.isEmpty() && duplisharedList != null)
        {
            for(AccountShare accsh : duplisharedList)
            {
                chkduplicateShareMap.put(accsh.AccountId , accsh.UserOrGroupId);                    
            }
        }
        
        if(!groupid.isEmpty() && groupid != null)
        {
            groupList = [select id ,DeveloperName ,Name ,Type from Group where Name =:groupid];            
        }
        if(!groupList.isEmpty() && groupList != null)
        {
            for(Group g : groupList)
            {
                groupMap.put(g.Name, g.Id);
            }            
        }
        
        system.debug('chkduplicateShareMap>>>>' + chkduplicateShareMap);
        system.debug('groupMap>>>>' + groupMap);
        for(Retail_Task__c rtk : rtasklist)
        {
            if(!groupMap.isEmpty() && groupMap != null && groupMap.get(rtk.Service_Dealer__r.Name) != null)
               {
                   system.debug('chkduplicateShareMap>>>>' + chkduplicateShareMap.get(rtk.Account__c));
                   system.debug('groupMap>>>>' + groupMap.get(rtk.Service_Dealer__r.Name));
                   Retail_Task__Share rtshare = new Retail_Task__Share();
                   rtshare.ParentId = rtk.Id;
                   rtshare.UserOrGroupId = groupMap.get(rtk.Service_Dealer__r.Name);
                   rtshare.AccessLevel = 'Read';
                   shareList.add(rtshare);
                   if(chkduplicateShareMap.get(rtk.Account__c) != groupMap.get(rtk.Service_Dealer__r.Name))
                   {
                       if(!sharedVrlist.isEmpty() && sharedVrlist != null)
                       {
                           system.debug('Duplicate Share');
                           AccountShare accShare = new AccountShare();
                           accShare.AccountId =vrMap.get(rtk.Related_Vehicle__c).get(0).contact__c;
                           accShare.UserOrGroupId = groupMap.get(rtk.Service_Dealer__r.Name);
                           accShare.AccountAccessLevel = 'Edit';
                           accshare.OpportunityAccessLevel = 'None';
                           accshare.CaseAccessLevel = 'None';
                           shareList.add(accShare);
                           
                           if(!acclinkmap.isEmpty() && acclinkmap.get(rtk.Account__c) != null)
                           {
                               Account_Link__Share alinkShare = new Account_Link__Share();
                               alinkShare.ParentId = acclinkmap.get(vrMap.get(rtk.Related_Vehicle__c).get(0).contact__c);
                               alinkShare.UserOrGroupId = groupMap.get(rtk.Service_Dealer__r.Name);
                               alinkShare.AccessLevel = 'Edit';
                               shareList.add(alinkShare);
                           }
                                                  
                           system.debug('RelatedVehicleAccount>>>>>>' + vrMap.get(rtk.Related_Vehicle__c).get(0).Contact__c);

                           if(!vrMap.isEmpty() && vrMap.get(rtk.Related_Vehicle__c) != null)
                           {
                               Vehicle_Relationship__Share vrShare = new Vehicle_Relationship__Share();
                               vrShare.ParentId = vrMap.get(rtk.Related_Vehicle__c).get(0).id;
                               vrShare.UserOrGroupId = groupMap.get(rtk.Service_Dealer__r.Name);
                               vrShare.AccessLevel = 'Edit';
                               shareList.add(vrShare);
                               
                               Vehicle__Share shrVehicle = new Vehicle__Share();
                               shrVehicle.ParentId = rtk.Related_Vehicle__c;
                               shrVehicle.UserOrGroupId = groupMap.get(rtk.Service_Dealer__r.Name);
                               shrVehicle.AccessLevel = 'Edit';
                               shareList.add(shrVehicle);
                           }                         
                       }
                   }
               }
        }        
        system.debug('shareList>>>>>' + shareList.size());
        if(!shareList.isEmpty() && shareList != null)
        {
            insert shareList;
        }
    }
    
    /* To Share Account and Related Objects with Related Dealers*/
    
    public static void sharewithRelatedDealers(list<Retail_Task__c> relatedRTList)
    {
        set<id> rtIds = new set<id>();
        map<id,id> acccnrtMap = new map<id,id>();
        map<id,id> vechcnrtMap = new map<id,id>();
        set<string> relateddlrgroup = new set<string>();
        List<group> relgroupList = new List<group>();
        map<string,id> relgroupMap = new map<string,id>();
        List<Retail_Task__c> delaerRtList = new List<Retail_Task__c>();
        List<sobject> relshareList = new List<sobject>();
        for(Retail_Task__c rtsks : relatedRTList)
        {
            if(rtsks.Account__c != null && rtsks.Related_Dealer__c != null && rtsks.RecordTypeId != servicerecordId)
            {
                rtIds.add(rtsks.Id);
            }
        }
        
        if(!rtIds.isEmpty() && rtIds != null)
        {
            delaerRtList = [select id, Account__c, Related_Dealer__c,Related_Vehicle__c, Related_Dealer__r.Name from Retail_Task__c where Id =:rtIds];
        }
        if(delaerRtList.isEmpty() && delaerRtList != null)
        {
            for(Retail_Task__c rt : delaerRtList)
            {
                acccnrtMap.put(rt.id, rt.Account__c);
                vechcnrtMap.put(rt.Id, rt.Related_Vehicle__c);
                relateddlrgroup.add(rt.Related_Dealer__r.Name);
            }
        }
        relgroupList = [select id ,DeveloperName ,Name ,Type from Group where Name =:relateddlrgroup];
        for(Group grp : relgroupList)
        {
            relgroupMap.put(grp.Name, grp.Id);
        }
        if(delaerRtList.isEmpty() && delaerRtList != null)
        {       
            for(Retail_Task__c shrrt : delaerRtList)
            {
                if(!relgroupMap.isEmpty() && relgroupMap.get(shrrt.Related_Dealer__r.Name) != null)
                {
                    AccountShare relaccShare = new AccountShare();
                    relaccShare.AccountId =acccnrtMap.get(shrrt.Id);
                    relaccShare.UserOrGroupId = relgroupMap.get(shrrt.Related_Dealer__r.Name);
                    relaccShare.AccountAccessLevel = 'Read';
                    relaccShare.OpportunityAccessLevel = 'None';
                    relaccShare.CaseAccessLevel = 'None';
                    relshareList.add(relaccShare);
                    
                    Vehicle__Share relVehicle = new Vehicle__Share();
                    relVehicle.ParentId = shrrt.Related_Vehicle__c;
                    relVehicle.UserOrGroupId = relgroupMap.get(shrrt.Related_Dealer__r.Name);
                    relVehicle.AccessLevel = 'Read';
                    relshareList.add(relVehicle);
                }
            }
        }
        if(!relshareList.isEmpty() && relshareList != null)
        {
            insert relshareList;
        }
    }
}