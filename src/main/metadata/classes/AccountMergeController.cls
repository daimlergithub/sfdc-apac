/*
    Type:       Extension for AccountMerge Visualforce page 
    Purpose:    Merget the Master Account Record and Suspect Duplicate Account
    User Story: US-DD-002
    Used By:    SelectSlaveAccount.page and AccountMerge Page
    Modified By: Sneha
    ---------------------------------------------------------------
    History:    
    1. Mouse Created on 2013-3-05
    2. Modified on 1-dec-2015    
*/

public with sharing class AccountMergeController{
    // AccountMerge Page Variable
    public Account master                   {get; set;}
    public Account slave                    {get; set;}
    public List<AccountWrapper> wraps       {get; set;}
    public String selectAllParam            {get; set;}
    public Boolean hasMessage               {get; set;}
    // SelectSlaveAccount Page Variable
    public Boolean hasSuspectAccounts       {get; set;}
    public List<Account> slaves             {get; set;}    
    public String chosenSlaveId             {get; set;}
    public String chosenMasterId            {get; set;}
    public String chosenDupReason           {get; set;}      
        
    // Get All Account fields Describe
    private Map<String, Schema.SObjectField> fieldNamesMap = Account.sObjectType.getDescribe().fields.getMap();
    private ApexPages.StandardController controller;
    /** 
     * @Description : Reject duplicate Accouts and create new log by creating record on "Rejected_Duplicate_Log__c".
       @            : Update slave "DUP_Number__pc" and "Dup_Reason__c" as Null and choosen MasterId on Slave Account
       @            : Update master "DUP_Number__pc" as "Null" and Master_Record__c as "False"
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)   
     * @return : Master account record would be appeared.
     * @see GeneratePDF Page
     */
    public PageReference rejectDup() {
          if(getcountMasterRecord()>=2 || getcountMasterRecord()==0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,System.Label.Please_select_only_one_Master_Record));   
            return Null;           
            } else{  
            getMasterAndslaveId();               
           Rejected_Duplicate_Log__c duplicateLog = new Rejected_Duplicate_Log__c(
            Master_Account__c = master.Id,
            Duplicate_Account__c = chosenSlaveId ,
            Duplicate_Reason_Code__c = chosenDupReason 
          );
        // If this rejected account is the last one, just return master record
        // detail page
        Integer dupCount = [SELECT COUNT() FROM Account 
                                 WHERE DUP_Number__pc = :master.DUP_Number__pc 
                                 AND Master_Record__c = False];
        SavePoint sp = Database.setSavepoint();
       
        try {
            insert duplicateLog;            
        }
        catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 
                e.getDMLMessage(0)));
            Database.rollback(sp);
            return null;
        }             
        if (dupCount == 1) {
            return new PageReference('/' + master.Id);
        }        
        PageReference pr = new PageReference(system.Label.apex_SelectSlaveAccount+controller.getId());
        pr.setRedirect(true);
        return pr;
     }
    }
    /** 
     * @Description Counts selected master records. 
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)  
     * @return : Number of selected master records.
     */
   public Integer getcountMasterRecord(){
      Integer hasMasterRecord=0;
       for(Account acc:Slaves){
           if(acc.Master_Record__c){
              hasMasterRecord++;
           } 
         } 
       return hasMasterRecord;
   }
   /** 
     * @Description : Merging duplicates Account having same "Dup Number" ,If Selected master records would be more than one ,user will get an warning message.
       @Comments : While Merging,Selected master record will be updated on the respective "Account".
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)  
     * @return : "AccountMerge" page will be appeared with choosen "Master Record".
     */
   public PageReference mergeDup() {    
       if(getcountMasterRecord()>=2 || getcountMasterRecord()==0){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,System.Label.Please_select_only_one_Master_Record));   
          return Null;           
        }else{  
          getMasterAndslaveId();
          master=getQueriedAccount(chosenMasterId);
          master.Master_Record__c=true;
          slave=getQueriedAccount(chosenSlaveId);   
          slave.Master_Record__c=false;  
          update slave;
          update master;                          
          PageReference pr = new PageReference(System.label.apex_AccountMerge_Id+chosenMasterId+System.Label.slaveId+chosenSlaveId+system.Label.retURL_apex_SelectSlaveAccount_Id+chosenSlaveId);
          pr.setRedirect(true);
          return pr;
         }
     }
     /** 
     * @Description : Get the id of choosen Master and Slave accounts.       
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)    
     */ 
     public void getMasterAndslaveId(){    
         for(Account acct:Slaves){            
           if(!acct.Master_Record__c)
           {  
               chosenSlaveId=acct.id;
               chosenDupReason=acct.Dup_Reason__c;           
           } 
           if(acct.Master_Record__c){
               chosenMasterId=acct.Id;               
           }
        }                   
     }
     /** 
     * @Description : Getting the list of Master and Slave records.      
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)      
     */      
    public AccountMergeController(ApexPages.StandardController con) {
        controller = con;  
        Account acc = this.getQueriedAccount(con.getId());
        // Populate dupNummer used in  soql
        String dupNummer = acc.DUP_Number__pc;       
        slaves=new List<Account>();
        slaves=  [Select Name,Master_Record__c,Dup_Reason__c,PersonMobilePhone,PersonOtherPhone,PersonHomePhone,Phone,PersonEmail,
                 DUP_Number__pc,Id,(Select Name from Account_Links1__r) FROM Account
                 WHERE DUP_Number__pc =:dupNummer AND DUP_Number__pc != null];            
          
         
        // Initiate hasMessage and wraps
        hasMessage = false;
        wraps = new List<AccountWrapper>();
        getMasterAndslaveId();
        try{           
          master = Database.query('SELECT ' + this.getSOQLFieldList(this.fieldAPIList) +                
                ' Phone,IsPersonAccount,DUP_Number__pc, Name,Id FROM Account ' +
                ' WHERE DUP_Number__pc =\''+dupNummer+'\''+
                ' AND Master_Record__c = true');
         slave = this.getQueriedAccount(chosenSlaveId);      
                }
        Catch(Exception e){
          hasMessage=true;
          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'No master record found for duplicate merge'));
        }               
        // Populate Inner class List
        If(master!=Null && slave!=Null){
           // If we can continue merge work, slaves must have one master account and 
           // one suspect account at least
           hasSuspectAccounts = Slaves.size() > 1;            
            if (!hasSuspectAccounts) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 
                                       Label.CP_No_Search_Result));
            } 
           this.populateAccountWrappers();
          }
    }
     /** 
     * @Description : Get quried account with fields list in AccountMergeFields FieldSet by accId
     *              : N.B. SOQL Field List = FieldSet Members + FieldMappingConstant.PHONE_DMS_FIELDS_MAPPING.values().
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)      
     */    
    private Account getQueriedAccount(Id accId) {
        String soql = 'SELECT ' + this.getSOQLFieldList(this.fieldAPIList) /*+ 
           this.getSOQLFieldList(FieldMappingConstant.PHONE_DMS_FIELDS_MAPPING.values())*/;
        
        // Prevent duplicate Master_Record__c and DUP_Number__pc in SOQL Field List,
        if (!soql.contains('Master_Record__c')) {
           soql += 'Master_Record__c, ';
        }
        
        if (!soql.contains('DUP_Number__pc')) {
           soql += 'DUP_Number__pc, ';
        }
        
        if (!soql.contains('Dup_Reason__c')) {
           soql += 'Dup_Reason__c, ';
        }
        
        return Database.query(soql + 
            ' IsPersonAccount,phone,Name,Id,PersonEmail  FROM Account WHERE Id =\''+accId+'\'');
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
        wraps = new List<AccountWrapper>();         
        for (String fieldAPI : this.fieldAPIList) {
            AccountWrapper wrap = new AccountWrapper();
            
            // Populate fieldLabel and fieldAPI
            wrap.fieldAPI = fieldAPI;
            wrap.fieldLabel = fieldNamesMap.get(fieldAPI).getDescribe().getLabel();
            
            // Get the Master Value and Slave Value by fieldAPI
            Object masterFieldValue = master.get(fieldAPI);
            Object slaveFieldValue = slave.get(fieldAPI);
     
            // Populate isMasterNull and isSlaveNull
            wrap.isMasterNull = (masterFieldValue == null);
            wrap.isSlaveNull = (slaveFieldValue == null);
            
            // If two values are both null, so,
            if (masterFieldValue == null && slaveFieldValue == null) {
                wrap.isSame = true;
                wrap.isMasterChecked = false;
                wrap.isSlaveChecked = false;
                wraps.add(wrap);
                continue;
            }
         
            if ((masterFieldValue != null && masterFieldValue == slaveFieldValue) ||
                    fieldAPI == 'Master_Record__c') {
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
     * @Description : // Get the Fields List that will be displayed in the pageBlockTable from fieldSet
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)      
     */     
    public List<String> fieldAPIList {
        get {
            return this.getFieldsListByFieldSet(System.Label.AccountMergeFields);
        }
        set;
    }    
     /** 
     * @Description : Get the SOQL Expr by fieldList
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)      
     */   
    private String getSOQLFieldList(List<String> fieldList) {
        String SOQLFieldList = '';
        for (String field : fieldList) {
            SOQLFieldList += field + ', ';
        }
        
        return SOQLFieldList;
    }    
    /** 
     * @Description : Get the Field Set Member
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)      
     */ 
    private List<String> getFieldsListByFieldSet(String fieldSetName) {
        List<String> fieldsList = new List<String>();
        List<Schema.FieldSetMember> fieldsetMembers = SObjectType.Account.FieldSets.getMap().
            get(fieldSetName).getFields();
        for (Schema.FieldSetMember member : fieldsetMembers) {
            fieldsList.add(member.getFieldPath());
        }
        return fieldsList;
    }    
    /** 
     * @Description : Inner Wrapper Class       
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)      
     */ 
    public class AccountWrapper {
        public String fieldLabel            {get; set;}
        public String fieldAPI              {get; set;}
        public Boolean isMasterNull         {get; set;}
        public Boolean isSlaveNull          {get; set;}
        public Boolean isSame               {get; set;}
        public Boolean isMasterChecked      {get; set;}
        public Boolean isSlaveChecked       {get; set;}
        
        public AccountWrapper() {}
    }
    /** 
     * @Description : Get the User in the Data Service Specialist UserRole and  update RecordType, Assigned Owner on slave    
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)   
     * @Comments  : 1. If isSlaveChecked is true, it means we choose 
                    2. slave field value to merge into master,
                    3. If isMasterChecked is true, it means master value doesn't need to change.   
     * @returns : Master record page will be appeared.
     */    
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
        slave.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Account', 
            UtilConstant.RECORDTYPE_PERSON_ACCOUNT_SOFT_DELETED); 
        slave.OwnerId = usr.Id;       
        slave.Master_Account_Id__c = master.Id;              
      
        // Set SavePoint, if slave DML failed, master DML should be rollback .
        SavePoint sp = Database.setSavepoint();
        try {
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
     * @Description : Get the Parameter value by Parameter Name
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy) 
     * @returns parameter value.     
     */     
    private String getParameter(String param) {
        return ApexPages.currentPage().getParameters().get(param);
    }
    /** 
     * @Description : Return to the previous page by retURL
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy) 
     * @returns "SelectSlaveAccount" page with choosen master and slave record Id as  parameters.     
     */  
    public PageReference previous() {      
        PageReference pr = new PageReference(this.getParameter(system.Label.retURL));
        pr.setRedirect(true);
        return pr;
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
     * @Description : Check all radio by selectAllParam
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)     
     */  
    public void selectAll() {       
        if (selectAllParam == System.Label.master) {
            for (AccountWrapper wrap : wraps) {
                if (!wrap.isMasterNull) {
                    wrap.isMasterChecked = true;
                    wrap.isSlaveChecked = false;
                }
            }
        }
        else if (selectAllParam == System.Label.slave) {
            for (AccountWrapper wrap : wraps) {
                if (!wrap.isSlaveNull) {
                    wrap.isSlaveChecked = true;
                    wrap.isMasterChecked = false;
                }
            }
        }
    }
}