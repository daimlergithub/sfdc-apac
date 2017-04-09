/*
    Type:       Extension for AccountMerge Visualforce page 
    Purpose:    Merget the Master Account Record and Suspect Duplicate Account
    User Story: US-DD-002
    Used By:    SelectSlaveAccount.page and AccountMerge Page
    Modified By: Mohammed Touseef Ahmed
    ---------------------------------------------------------------
    History:    
    1. Mouse Created on 2013-3-05
    2. Modified on 1-dec-2015    
    3. Modified on 15th March 2017
*/

public with sharing class AccountMergeController{
    
    public List<Accountwrapper> AccountwrapperList {get; set;}
    public List<Accountwrapper> wraps {get; set;}
    public String selectAllParam   {get; set;}
    public Account selectedSlaveAccount {get;set;}
    public Account selectedMasterAccount {get;set;}
    private Map<String, Schema.SObjectField> fieldNamesMap = Account.sObjectType.getDescribe().fields.getMap();
    public Account Master {get; set;}
    public Account Slave  {get; set;}
    public Account Acct  {get; set;}
    public set<string> SoqlFieldset;
    public Boolean hasSuspectAccounts{get;set;}
    public List<Address__C> MasterAddresses {get; set;}
    public List<Address__C> SlaveAddresses  {get; set;}
    public List<AddressWrapper> AddWrapList {get; set;}
    
     /** 
     * @Description : Constructor would be called to get the Master and Slave record
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)      
     */    
     public AccountMergeController(){
           Id RecordTypeIdPersonSoftDeleted=UtilRecordType.getRecordTypeIdByName('Account',UtilConstant.RECORDTYPE_PERSON_ACCOUNT_SOFT_DELETED); 
           Id recordTypeIdCompanySoftdeleted=UtilRecordType.getRecordTypeIdByName('Account','CompanySoftDeleted');
           hasSuspectAccounts=false;
           if(AccountwrapperList == null) {
               AccountwrapperList = new List<Accountwrapper>();             
               Acct = [Select Id,name,DUPNumber__c,Master_Record__c,RecordtypeId,RecordType.Name,RecordType.DeveloperName,(Select Name from Account_Links1__r),PersonMobilePhone,
                       PersonOtherPhone,PersonHomePhone,Phone,PersonEmail,Dup_Reason__c from Account where Id=:Apexpages.currentPage().getParameters().get('id')];  
               if(Acct.DUPNumber__c!=Null){
                AccountwrapperList.add(new Accountwrapper(Acct));  
                for(Account a: [Select Name,recordType.developerName,Master_Record__c,Dup_Reason__c,PersonMobilePhone,PersonOtherPhone,PersonHomePhone,Phone,PersonEmail,
                      DUPNumber__c,Id,(Select Name from Account_Links1__r) FROM Account
                      WHERE DUPNumber__c =:Acct.DUPNumber__c  AND RecordtypeId=:Acct.RecordTypeId AND ID!=:Acct.Id AND Master_Record__c!=:Acct.Master_Record__c  LIMIT 1]) {
                    // As each Account is processed we create a new Accountwrapper object and add it to the AccountwrapperList
                    AccountwrapperList.add(new Accountwrapper(a));
                 }  
                 if(AccountwrapperList.size()==1){
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'You should have aleast one master and one slave record to merge the duplicates'));
                   }  
               } 
             else{
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'No record found'));
              }
            }
            if(AccountwrapperList.size()!=2){
                hasSuspectAccounts=true;
               }          
            SoqlFieldset = new set<string>();
            SoqlFieldset.addAll(this.getFieldsListByFieldSet('AccountMergeFieldsCompany'));
            SoqlFieldset.addAll(this.getFieldsListByFieldSet('AccountMergeFieldsPerson'));
            SoqlFieldset.addAll(this.getFieldsListByFieldSet('AccountMergeReadonlyCompany'));
            SoqlFieldset.addAll(this.getFieldsListByFieldSet('AccountMergeReadonlyPerson')); 
        try{
           if(Apexpages.currentPage().getParameters().get('selectedSlaveAccount')!=Null && Apexpages.currentPage().getParameters().get('selectedMasterAccount')!=Null){
               Slave = this.getQueriedAccount(Apexpages.currentPage().getParameters().get('selectedSlaveAccount')); 
               Master =  this.getQueriedAccount(Apexpages.currentPage().getParameters().get('selectedMasterAccount'));    
            }
         }
        Catch(Exception e){
         //hasMessage=true;
          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'No master record found for duplicate merge'));         
        }  
                       
        wraps = new List<Accountwrapper>();
          If(master!=Null && slave!=Null){
               this.populateAccountWrappers();
            }
       }
       
     public PageReference processSelected() {    
         Integer hasSlaveAccount=0;
         Integer hasMasterAccount=0;
         for(Accountwrapper AccountwrapperObj : AccountwrapperList) {          
            if(AccountwrapperObj.selected == true) {
                selectedSlaveAccount=AccountwrapperObj.acc;
                hasSlaveAccount++;
            }           
            if(AccountwrapperObj.acc.Master_Record__c== true)
            {
                selectedMasterAccount=AccountwrapperObj.acc;
                hasMasterAccount++;
            }
         }
           if(hasMasterAccount==0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,System.Label.Please_select_only_one_Master_Record));   
                return Null;           
            } 
            if(hasSlaveAccount==0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Please select only one slave Record'));   
                return Null; 
            }
         if(selectedSlaveAccount.Id==selectedMasterAccount.Id){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Master and Slave can not have same Id'));
               return null;        
          }
          PageReference pr = new PageReference('/apex/Accountmerge?selectedMasterAccount='+selectedMasterAccount.Id+'&selectedSlaveAccount='+selectedSlaveAccount.Id+'&Id='+Acct.Id);
          pr.setRedirect(true);
          return pr;
      }
     /** 
     * @Description : Reject duplicate Accouts and create new log by creating record on "Rejected_Duplicate_Log__c".
       @            : Update slave "DUPNumber__c" and "Dup_Reason__c" as Null and choosen MasterId on Slave Account
       @            : Update master "DUPNumber__c" as "Null" and Master_Record__c as "False"
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)   
     * @return : Master account record would be appeared.
     * @see GeneratePDF Page
     */
    public PageReference rejectDup() {           
            Integer hasSlaveAccount=0;
            Integer hasMasterAccount=0;
            for(Accountwrapper AccountwrapperObj : AccountwrapperList) {          
                if(AccountwrapperObj.selected == true) {
                    selectedSlaveAccount=AccountwrapperObj.acc;
                    hasSlaveAccount++;
                }           
                if(AccountwrapperObj.acc.Master_Record__c== true)
                {
                    selectedMasterAccount=AccountwrapperObj.acc;
                    hasMasterAccount++;
                }
            }
            if(hasMasterAccount>=2 || hasMasterAccount==0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,System.Label.Please_select_only_one_Master_Record));   
                return Null;           
            } 
            if(hasSlaveAccount>=2 || hasSlaveAccount==0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Please select only one slave Record'));   
                return Null; 
            }
            if(selectedSlaveAccount.Id==selectedMasterAccount.Id){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Master and Slave can not have same Id'));
            return null;        
          }
            Rejected_Duplicate_Log__c duplicateLog = new Rejected_Duplicate_Log__c(
            Master_Account__c = selectedMasterAccount.Id,
            Duplicate_Account__c = selectedSlaveAccount.Id,
            Duplicate_Reason_Code__c = selectedMasterAccount.Dup_Reason__c,
            DUPNumber__c = selectedMasterAccount.DUPNumber__c,Status__c=System.Label.Rejected);
        
           // Update Master and Slave record 
            selectedSlaveAccount.DUPNumber__c='';
            selectedSlaveAccount.Dup_Reason__c ='';
            selectedSlaveAccount.Master_Account_Id__c=selectedMasterAccount.Id;
            selectedMasterAccount.DUPNumber__c='';
            selectedMasterAccount.Master_Record__c=false;
            
            try {
            insert duplicateLog; 
            update selectedMasterAccount;
            update selectedSlaveAccount;                      
              }
        Catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 
                e.getDMLMessage(0)));      
            return null;     
        }             
             
        PageReference pr = new PageReference(system.Label.apex_SelectSlaveAccount+selectedMasterAccount.Id);
        pr.setRedirect(true);
        return pr;
    }
    public PageReference mergeAccount() {       
        User usr;
          try {
               usr = [SELECT Id FROM User 
                   WHERE Profile.Name = 
                   :UtilConstant.PROFILE_PERSON_ACCOUNT_SOFT_DELETED  And IsActive = true 
                   LIMIT 1];
           }
          catch (QueryException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 
                Label.CP_No_User_Found));
            return null;
          }
         // Update Master
         for (AccountWrapper wrap : wraps) {           
           if (wrap.isSlaveChecked) {
                master.put(wrap.fieldAPI, slave.get(wrap.fieldAPI));
              }
          }
         
        // Update Slave RecordTypeId and Owner
          if
          (slave.RecordType.developerName == 'PersonAccount' && master.RecordType.developerName == 'PersonAccount')
          {
            slave.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Account',UtilConstant.RECORDTYPE_PERSON_ACCOUNT_SOFT_DELETED); 
            slave.OwnerId = usr.Id;       
            slave.Master_Account_Id__c = master.Id;
            master.DUPNumber__c='';
            master.Master_Record__c=false;
          }
            else if
            (slave.RecordType.developerName == 'Company' && master.RecordType.developerName == 'Company')                       
            {
             slave.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Account','CompanySoftDeleted'); 
             slave.OwnerId = usr.Id;       
             slave.Master_Account_Id__c = master.Id; 
             master.DUPNumber__c='';
             master.Master_Record__c=false;                
         }
        
        // If the merged record is the last suspected duplicate to the master record, 
        // after merge, also remove master record (checkbox) and Dup Number 
        // from the master record.
             
         Rejected_Duplicate_Log__c duplicateLog = new Rejected_Duplicate_Log__c(
         Master_Account__c = master.Id,
         Duplicate_Account__c = slave.Id ,
         Duplicate_Reason_Code__c = slave.Dup_Reason__c,
         Status__c=system.label.Confirmed);
        // Set SavePoint, if slave DML failed, master DML should be rollback .
        SavePoint sp = Database.setSavepoint();        
        try {
            insert duplicateLog;
            update master;
            update slave;
        }
        catch (DMLException e) {
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 
                e.getDMLMessage(0)));
            return null;
        }        
        return new PageReference('/' + master.Id);
    }    
    /** 
     * @Description : Populate fieldLabel and fieldAPI 
       @           // 1. If master field value is same with slave's, just choose master value
                  // as default value
                 // 2. User can't change the master record.
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)      
     */ 
    private void populateAccountWrappers() {
        wraps = new List<Accountwrapper>(); 
        List<string> TotalFieldset = new list<string>();
        set<string> readonlyset = (Acct.recordType.developerName == 'PersonAccount'? getFieldssetByFieldSet('AccountMergeReadonlyPerson') : getFieldssetByFieldSet('AccountMergeReadonlyCompany'));
        TotalFieldset.addAll(fieldAPIList);
     //   TotalFieldset.addAll(readonlyset);
        
        for (String fieldAPI : TotalFieldset) {
            Accountwrapper wrap = new Accountwrapper();
            
            // Populate fieldLabel and fieldAPI
            wrap.fieldAPI = fieldAPI;
            wrap.fieldLabel = fieldNamesMap.get(fieldAPI).getDescribe().getLabel();
            
            // Get the Master Value and Slave Value by fieldAPI
            Object masterFieldValue = master.get(fieldAPI);
            Object slaveFieldValue = slave.get(fieldAPI);
     
            // Populate isMasterNull and isSlaveNull
            wrap.isMasterNull = (masterFieldValue == null);
            wrap.isSlaveNull = (slaveFieldValue == null);
         
           if ((masterFieldValue != null && masterFieldValue == slaveFieldValue) ||
                    fieldAPI == 'Master_Record__c' ) {
                wrap.isSame = true;
                wrap.isMasterChecked = true;
                wrap.isSlaveChecked = false;
                wraps.add(wrap);               
                continue;
            }
            
            // Populate isSame
            wrap.isSame = ( masterFieldValue == slaveFieldValue);
            
            // When one value is null, the other is default value
            wrap.isSlaveChecked = (masterFieldValue == null && 
                slaveFieldValue != null);
            wrap.isMasterChecked = (slaveFieldValue == null && 
                masterFieldValue != null);                
                        
            wraps.add(wrap);           
        }        
    } 
      /** 
     * @Description : Get quried account with fields list in AccountMergeFields FieldSet by accId
     *              : N.B. SOQL Field List = FieldSet Members + FieldMappingConstant.PHONE_DMS_FIELDS_MAPPING.values().
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)      
     */    
        private Account getQueriedAccount(Id accId) {
            
            
            String soql = 'SELECT ' + getSOQLFieldList(SoqlFieldset) /*+ 
               this.getSOQLFieldList(FieldMappingConstant.PHONE_DMS_FIELDS_MAPPING.values())*/;
            
            // Prevent duplicate Master_Record__c and DUPNumber__c in SOQL Field List,
            if (!soql.contains('Master_Record__c')) {
               soql += 'Master_Record__c, ';
            }
            
            if (!soql.contains('DUPNumber__c')) {
               soql += 'DUPNumber__c, ';
            }
            
            if (!soql.contains('Dup_Reason__c')) {
               soql += 'Dup_Reason__c, ';
            }
            
            
            return Database.query(soql + 
                ' IsPersonAccount,phone,Id,PersonEmail,recordType.developerName,RecordTypeId FROM Account WHERE Id =\''+accId+'\'');
        }
      public List<String> fieldAPIList {            
            get {                
                if(Acct.recordType.developerName == 'PersonAccount')
                {
                return this.getFieldsListByFieldSet('AccountMergeFieldsPerson');
                }
                else
                {
                    return this.getFieldsListByFieldSet('AccountMergeFieldsCompany');
                }
            }
            set;
        } 
    /** 
     * @Description : Get the SOQL Expr by fieldList
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)      
     */      
     private String getSOQLFieldList(set<String> fieldList) {
            String SOQLFieldList = '';
            for (String field : fieldList) {
                SOQLFieldList += field + ', ';
            }
            
            return SOQLFieldList;
        }      
     private List<String> getFieldsListByFieldSet(String fieldSetName) {
        List<String> fieldsList = new List<String>();
        List<Schema.FieldSetMember> fieldsetMembers = SObjectType.Account.FieldSets.getMap().
            get(fieldSetName).getFields();
        for (Schema.FieldSetMember member : fieldsetMembers) {
            fieldsList.add(member.getFieldPath());
        }
        return fieldsList;
     } 
     private set<String> getFieldssetByFieldSet(String fieldSetName) {
        set<String> fieldsList = new set<String>();
        List<Schema.FieldSetMember> fieldsetMembers = SObjectType.Account.FieldSets.getMap().
            get(fieldSetName).getFields();
        for (Schema.FieldSetMember member : fieldsetMembers) {
            fieldsList.add(member.getFieldPath());
        }
        return fieldsList;
     } 
     /** 
     * @Description : Return to the previous page by retURL
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy) 
     * @returns "SelectSlaveAccount" page with choosen master and slave record Id as  parameters.     
     */  
      public PageReference previous() {      
        PageReference pr = new PageReference('/apex/SelectSlaveAccount?id='+Apexpages.currentPage().getParameters().get('Id'));
        pr.setRedirect(true);
        return pr;
      }    
     /** 
     * @Description : Check all radio by selectAllParam
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)     
     */  
      public void selectAll() {       
        if (selectAllParam == System.Label.master) {
            for (Accountwrapper wrap : wraps) {
                if (!wrap.isMasterNull) {
                    wrap.isMasterChecked = true;
                    wrap.isSlaveChecked = false;
                }
            }
        }
        else if (selectAllParam == System.Label.slave) {
            for (Accountwrapper wrap : wraps) {
                if (!wrap.isSlaveNull) {
                    wrap.isSlaveChecked = true;
                    wrap.isMasterChecked = false;
                }
            }
        }
    }
    /** 
     * @Description : Get the Parameter value by Parameter Name
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy) 
     * @returns parameter value.     
     */     
    private String getParameter(String param) {
        return ApexPages.currentPage().getParameters().get(param);
    }
    /** 
     * @Description : Click Cancel to return the master detail page
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)     
     */ 
    public PageReference cancel() {
        return new PageReference('/' + master.Id);
    }
    /** 
     * @Description : Inner Wrapper Class       
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)      
     */ 
     // This is our wrapper/container class. In this example a wrapper class contains both the standard salesforce object Account and a Boolean value
    public class Accountwrapper {
        public Account acc {get; set;}
        public Boolean selected {get; set;}
        public String fieldLabel            {get; set;}
        public String fieldAPI              {get; set;}
        public Boolean isMasterNull         {get; set;}
        public Boolean isSlaveNull          {get; set;}
        public Boolean isSame               {get; set;}
       public Boolean isMasterChecked      {get; set;}
       public Boolean isSlaveChecked       {get; set;}
        public Accountwrapper(){
        }
        public Accountwrapper(Account a) {
            acc = a;
            selected = false;
        }
    }
    public class AddressWrapper
    {
        public Address__c MasterAddress {get; set;}
        public Address__c SlaveAddress {get; set;}
        
    }
}