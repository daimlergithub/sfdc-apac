global class C2C_AccountlinkShareJPBatch implements Database.batchable<sObject>{
    global id AccountLink_Contact2ContactRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId(); 
    global id AccountLink_VehicleExternalLinkRecordTypeId= Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId(); 
    global id AccountLink_PersonRecordTypeId= Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(); 
    global id AccountLink_CompanyRecordTypeId= Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId(); 
    global id AccountLink_IndividualCustomerExternalLinkRecordTypeId= Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId();
    global Id DealerAccid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    global Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    global Id accCompany_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();

    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Id userId =[select id from user where username like '%integration.inf@infosys.com%' limit 1].Id;        
        String query='Select id,fromRole__c,Retail_Delete_Flag__c ,toRole__c,fromRole__r.Name,fromRole__r.MD__c,fromRole__r.Dealer_GC_Code__c,RecordTypeId,RecordType.Name,MD__c,Name from Account_Link__c  where  createdDate = LAST_N_DAYS:2 AND createdById =\''+userId +'\' AND (RecordTypeId =\''+AccountLink_Contact2ContactRecordTypeId+'\' OR RecordTypeId =\''+AccountLink_VehicleExternalLinkRecordTypeId +'\' OR RecordTypeId =\''+AccountLink_PersonRecordTypeId +'\' OR RecordTypeId =\''+AccountLink_CompanyRecordTypeId +'\' OR RecordTypeId =\''+AccountLink_IndividualCustomerExternalLinkRecordTypeId +'\') AND (MD__c=\'JP\' OR Market__c=\'JP\')';        
        system.debug('hello'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        List<Account_Link__c>  accountLinkList = (List<Account_Link__c>)scope;
        set<Account_Link__Share> Sharealk= new set<Account_Link__Share>();
        set<AccountShare> accShare= new set<AccountShare>();
        Set<Id> accIdC2CSet = new Set<Id>();
        Set<Id> accIdVELSet = new Set<Id>();
        Set<Id> accIdRetailPersonSet = new Set<Id>();
        Set<Id> accIdRetailCompanySet = new Set<Id>();
        Set<Id> accIdIndividualCustomerLinkSet = new Set<Id>();
        Set<id> retailRecords = new set<id>();
        List<Account_Link__c> C2Clist= new List<Account_Link__c>();
        string allids='';
        for(Account_Link__c al:accountLinkList){
            if(al.RecordType.name == 'Contact2Contact'){
                accIdC2CSet.add(al.fromRole__c);
                accIdC2CSet.add(al.toRole__c);
                C2Clist.add(al);
            }
            if(al.RecordType.name == 'Vehicle External Link'){
                accIdVELSet.add(al.id); 
                                
            }
            if(al.RecordType.name == 'Retail Person'){
                accIdRetailPersonSet.add(al.id); 
                
            }
            if(al.RecordType.name == 'Retail Company'){
                accIdRetailCompanySet.add(al.id);     
                                
            }
            if(al.RecordType.name == 'Individual Customer External Link'){
                accIdIndividualCustomerLinkSet.add(al.id);
            }
            allids=allids+al.id+'-';
        }
        
        List<Account_Link__c> alC2CList = new List<Account_Link__c>();
        List<Account_Link__c> alVELList = new List<Account_Link__c>();
        List<Account_Link__c> alRetailList = new List<Account_Link__c>();
        List<Account_Link__c> alList = new List<Account_Link__c>();
        List<Account_Link__c> alIndividualCustExtLink = new List<Account_Link__c>();
        List<String> customLabelGCcode =Label.JPYanasedealerGCCode.split(',');
        Set<id> RetailCopy = new set<id>();
        set<id> WSAccount= new Set<id>();
        Map<String,Map<id,account>> dealerAccMap= new Map<string,Map<id,account>>();
        Map<string,set<id>> gcCodeList = new Map<string,Set<id>>();
        
        if(accIdVELSet.size()> 0 || accIdVELSet != null)
        {    system.debug(accIdVELSet);
            alVELList=[Select id,fromRole__r.Name,recordtypeid, fromRole__r.Dealer_GC_Code__c,fromRole__r.MD__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,MD__c,toRole__c  from Account_Link__c where id In :accIdVELSet AND fromRole__r.Dealer_Group__c='Yanase'];
            for(Account_Link__c al:alVELList){
                alList.add(al);
            }
        }  
        if(accIdRetailPersonSet.size()> 0 || accIdRetailPersonSet != null || accIdRetailCompanySet.size()> 0 || accIdRetailCompanySet != null )
        {   system.debug(accIdRetailPersonSet ); 
            system.debug(accIdRetailCompanySet ); 
            alRetailList=[Select id,fromRole__r.Name,recordtypeid,toRole__r.recordtypeid,fromRole__r.MD__c, fromRole__r.Dealer_GC_Code__c,Retail_Delete_Flag__c,MD__c  from Account_Link__c where (id In :accIdRetailPersonSet OR id in :accIdRetailCompanySet) AND fromRole__r.Dealer_Group__c='Yanase' AND Retail_Duplicate_Flag__c=false AND To_Be_Deleted__c=false];
            for(Account_Link__c al:alRetailList){
                alList.add(al);
                if(al.toRole__r.recordtypeid==accPerson_RecordTypeId || al.torole__r.RecordTypeId==accCompany_RecordTypeId) WSAccount.add(al.torole__c);
            }
        } 
        if(accIdC2CSet.size()> 0 || accIdC2CSet != null)
        {
            alC2CList=[Select id,fromRole__r.Name,fromRole__c,toRole__c,fromRole__r.MD__c,fromRole__r.Dealer_GC_Code__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,MD__c,Name  from Account_Link__c where toRole__c in:accIdC2CSet and (recordtypeid =: AccountLink_PersonRecordTypeId OR recordtypeid =:AccountLink_CompanyRecordTypeId) AND fromRole__r.Dealer_Group__c='Yanase'];
 			for(Account_Link__c al:alC2CList){     
                RetailCopy.add(al.torole__c);
                
                if(string.isnotblank(al.fromRole__r.Dealer_GC_Code__c)? Label.JPYanasedealerGCCode.contains(al.fromRole__r.Dealer_GC_Code__c):false){  
                    if(!gcCodeList.containskey(al.fromRole__r.MD__c+al.fromRole__r.Dealer_GC_Code__c))
                        gcCodeList.put((al.fromRole__r.MD__c+al.fromRole__r.Dealer_GC_Code__c),new set<id>{al.toRole__c});
                    else{
                       // gcCodeList.put((al.fromRole__r.MD__c+al.fromRole__r.Dealer_GC_Code__c),new set<id>{al.id});
                        gcCodeList.get((al.fromRole__r.MD__c+al.fromRole__r.Dealer_GC_Code__c)).add(al.toRole__c);
                    }
                    
                }
                else{
                    //gcCodeList.add(als.fromRole__r.Name);
                    if(!gcCodeList.containskey(al.fromRole__r.Name))
                        gcCodeList.put((al.fromRole__r.Name),new set<id>{al.toRole__c});
                    else{
                       // gcCodeList.put((al.fromRole__r.Name),new set<id>{al.id});
                        gcCodeList.get((al.fromRole__r.Name)).add(al.toRole__c);
                    }
                }
            }
       
            
            for(Account_Link__c al: C2Clist){
                 alList.add(al);
            }
        }
        
        List<Id> acIdList = new List<Id>();
        if(accIdIndividualCustomerLinkSet.size()> 0 || accIdIndividualCustomerLinkSet != null){
            
            alIndividualCustExtLink =[Select Id,toRole__c from Account_Link__c where id in :accIdIndividualCustomerLinkSet];            
            for(Account_Link__c al:alIndividualCustExtLink ){
                acIdList.add(al.toRole__c);
            }
            
            List<Account_Link__c> acLinkList = [Select id,fromRole__c,fromRole__r.Dealer_GC_Code__c,fromRole__r.MD__c,toRole__c,Name,RecordTypeId,fromRole__r.Name from Account_Link__c where toRole__c IN :acIdList AND (recordType.Name='Retail Person' OR recordType.Name='Retail Company') AND fromRole__r.Dealer_Group__c='Yanase' ];         
            for(Account_Link__c al: acLinkList){
                 if(string.isnotblank(al.fromRole__r.Dealer_GC_Code__c)? Label.JPYanasedealerGCCode.contains(al.fromRole__r.Dealer_GC_Code__c):false){  
                    if(!gcCodeList.containskey(al.fromRole__r.MD__c+al.fromRole__r.Dealer_GC_Code__c))
                        gcCodeList.put((al.fromRole__r.MD__c+al.fromRole__r.Dealer_GC_Code__c),new set<id>{al.toRole__c});
                    else{
                       
                        gcCodeList.get((al.fromRole__r.MD__c+al.fromRole__r.Dealer_GC_Code__c)).add(al.toRole__c);
                    }
                    
                }
                else{
                    
                    if(!gcCodeList.containskey(al.fromRole__r.Name))
                        gcCodeList.put((al.fromRole__r.Name),new set<id>{al.toRole__c});
                    else{
                       
                        gcCodeList.get((al.fromRole__r.Name)).add(al.toRole__c);
                    }
                }
            
            }
            for(Account_Link__c al: acLinkList){
                 alList.add(al);
            }
        }
        
        Set<String> dealerAccountNameSet  = new Set<String>();
        for(Account_Link__c als: alList)
        {
            if(als.recordtypeid==AccountLink_VehicleExternalLinkRecordTypeId || als.recordtypeid==AccountLink_PersonRecordTypeId ||als.recordtypeid==AccountLink_CompanyRecordTypeId){
                
            if(string.isnotblank(als.fromRole__r.Dealer_GC_Code__c)? Label.JPYanasedealerGCCode.contains(als.fromRole__r.Dealer_GC_Code__c):false){                
                dealerAccountNameSet.add(als.fromRole__r.MD__c+als.fromRole__r.Dealer_GC_Code__c);
            }
            else
                dealerAccountNameSet.add(als.fromRole__r.Name);
            }
        }  
                
    system.debug(dealerAccountNameSet);    
    for(Group groupRec : [select Id, Name, Type from Group where (Name IN :dealerAccountNameSet or name in :gcCodeList.keyset())])
    {
        if(alList.size()>0 )
        {
            for(Account_Link__c aclink : alList)
            {
                if(aclink.recordtypeid==AccountLink_VehicleExternalLinkRecordTypeId || aclink.recordtypeid==AccountLink_PersonRecordTypeId ||aclink.recordtypeid==AccountLink_CompanyRecordTypeId){
                if(string.isnotblank(aclink.fromRole__r.Dealer_GC_Code__c)? Label.JPYanasedealerGCCode.contains(aclink.fromRole__r.Dealer_GC_Code__c):false){
                    if(groupRec.name== (aclink.fromRole__r.MD__c+aclink.fromRole__r.Dealer_GC_Code__c)){
                        Account_Link__Share accountLinkShare = new Account_Link__Share();
                        accountLinkShare.AccessLevel = 'Edit';
                        accountLinkShare.UserOrGroupId = groupRec.Id;
                        accountLinkShare.ParentId = aclink.id;
                        accountLinkShare.RowCause = Schema.Account_Link__Share.RowCause.Manual;
                        Sharealk.add(accountLinkShare);
                        if(string.isnotblank(aclink.torole__c)?WSAccount.contains(aclink.torole__c ):false){
                            Accountshare acs=new Accountshare();
                            acs.Accountid=aclink.torole__c;
                            acs.UserOrGroupId = groupRec.Id;
                            acs.AccountAccessLevel='edit';
                            acs.OpportunityAccessLevel ='edit';
                            acs.RowCause = Schema.Accountshare.RowCause.Manual;
                            accShare.add(acs);
                        }
                    }
                }
                else if(groupRec.name== aclink.fromRole__r.name){
                        Account_Link__Share accountLinkShare = new Account_Link__Share();
                        accountLinkShare.AccessLevel = 'Edit';
                        accountLinkShare.UserOrGroupId = groupRec.Id;
                        accountLinkShare.ParentId = aclink.id;
                        accountLinkShare.RowCause = Schema.Account_Link__Share.RowCause.Manual;
                        Sharealk.add(accountLinkShare);
                        if(string.isnotblank(aclink.torole__c)?WSAccount.contains(aclink.torole__c ):false){
                            Accountshare acs=new Accountshare();
                            acs.Accountid=aclink.torole__c;
                            acs.UserOrGroupId = groupRec.Id;
                            acs.AccountAccessLevel='edit';
                            acs.OpportunityAccessLevel ='edit';
                            acs.RowCause = Schema.Accountshare.RowCause.Manual;
                            accShare.add(acs);
                        }
                    }
                    
                }  
                else if(aclink.recordtypeid==AccountLink_Contact2ContactRecordTypeId){
                    if(gcCodeList.containskey(GroupRec.name)){
                        system.debug(groupRec.name);
                        system.debug('----'+gcCodeList.get(GroupRec.name));
                        if(gcCodeList.get(GroupRec.name).contains(aclink.toRole__c)&& gcCodeList.get(GroupRec.name).contains(aclink.fromRole__c)){
                            Account_Link__Share accountLinkShare = new Account_Link__Share();
                            accountLinkShare.AccessLevel = 'Edit';
                            accountLinkShare.UserOrGroupId = groupRec.Id;
                            accountLinkShare.ParentId = aclink.id;
                            accountLinkShare.RowCause = Schema.Account_Link__Share.RowCause.Manual;
                            Sharealk.add(accountLinkShare);
                        }                       
                    }
                    
                }
              }
            }
        }
        
       
    
    if(Sharealk.size() > 0){
        //System.debug('Size of Account Link C2C List :'+Sharealk.size());  
        //Database.insert(Sharealk, false);
         if(Sharealk.size() > 0){
            List<Account_Link__Share> list_SharingRecord = new List<Account_Link__Share>(Sharealk);   

            Database.insert(list_SharingRecord, false);
            system.debug(list_SharingRecord);
            Custom_Debug_Info__c c= new Custom_Debug_Info__c();
            c.name='C2C_AccountlinkShareJPBatchAccountlink'+string.valueof(datetime.now());
            string errorIDs='Error:';
            string SucessIDs='Success';
           // c.Logging_Date_Time__c=datetime.now();
            c.Custom_Debug_Log_Data__c='Sharing Count'+list_SharingRecord.size()+'Total Incoming Count'+accountLinkList.size()+';\n';
            c.Custom_Debug_Log_Data__c=c.Custom_Debug_Log_Data__c+'Incoming Ids'+allids+';\n';
            for(Account_Link__Share aa: list_SharingRecord){
                c.Custom_Debug_Log_Data__c=c.Custom_Debug_Log_Data__c+aa.id+'--'+aa.UserOrGroupId+'--'+ aa.ParentId+';\n';              
            }
            insert c; 
        }
    } 
    if(accShare.size() > 0){
        //System.debug('Size of Account Link C2C List :'+Sharealk.size());  
        //Database.insert(Sharealk, false);
         if(Sharealk.size() > 0){
            List<Accountshare> list_ACCSharingRecord = new List<Accountshare>(accShare);            
            Database.insert(list_AccSharingRecord, false);
            system.debug(list_AccSharingRecord);
            Custom_Debug_Info__c c= new Custom_Debug_Info__c();
            c.name='C2C_AccountlinkShareJPBatchAccount'+string.valueof(datetime.now());
          //  c.Logging_Date_Time__c=datetime.now();
            c.Custom_Debug_Log_Data__c=string.valueof(list_AccSharingRecord);
            c.Custom_Debug_Log_Data__c='Sharing Count'+list_AccSharingRecord.size()+'Total Incoming Count'+(accIdRetailPersonSet.size()+accIdRetailCompanySet.size())+';\n';
            c.Custom_Debug_Log_Data__c=c.Custom_Debug_Log_Data__c+'Incoming Ids'+allids+';\n';
            for(Accountshare aa: list_AccSharingRecord){
                c.Custom_Debug_Log_Data__c=c.Custom_Debug_Log_Data__c+aa.id+'--'+aa.UserOrGroupId+'--'+ aa.Accountid+';\n';             
            }
            insert c; 
        }
    }
    if(C2Clist.size()>0){
	    List<Account_Link__c> updateNameC2C = new List<Account_Link__c>();
        for(Account_Link__c c:C2Clist){
		  c.Name=Label.c2cNameJP;//'顧客間関係情報';		  
		     updateNameC2C.add(c);
		}
		If(!test.isRunningTest()) {
		  if(updateNameC2C.size() > 0)
		    update updateNameC2C;
		   }
    }	
    
}

global void finish(Database.BatchableContext BC){
    System.debug('Records Updated');
}


}