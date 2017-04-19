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

public class LeadMergeController{
    // AccountMerge Page Variable
    public Lead__c master                   {get; set;}
    public Lead__c slave                    {get; set;}
    public List<LeadWrapper> wraps       {get; set;}
    public String selectAllParam            {get; set;}   
    public Boolean hasMessage               {get; set;}
    public Boolean hasSuspectLeads          {get; set;}      
    public String chosenSlaveId             {get; set;}
    public String chosenMasterId            {get; set;}
    public Lead__c leads                    {get; set;} 
    public set<string> SoqlFieldset;
    public List<LeadWrapperclass> slaves{ get; set; }
    public  List<SurveyTaker__c> surtake{set;get;}
     List<DM_Request__c> dmstr{set;get;}
    public String selectedValue { get; set; } 
    public String MasterRecordTypeName;
    // Get All Account fields Describe
    private Map<String, Schema.SObjectField> fieldNamesMap = Lead__c.sObjectType.getDescribe().fields.getMap(); 
            
    
     /** 
     * @Description : Contructor Calles to get the curect page Id and Slave Id.      
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)      
     */   
      public LeadMergeController(ApexPages.StandardController con) {
       // controller = con;
       dmstr =new  List<DM_Request__c>();
     surtake= new List<SurveyTaker__c>();
        leads = [Select Id,name,Contact__c,Contact__r.Name,Service_Advisor__c ,Service_Advisor__r.Name,RecordtypeId,RecordType.Name,CAC_Lead_Status__c  from Lead__c where Id=:Apexpages.currentPage().getParameters().get('id')];  
          MasterRecordTypeName = leads.Recordtype.Name;
           if(leads.Service_Advisor__c != NULL)
        { 
        slaves = new List<LeadWrapperclass>();     
        for(Lead__c a: [select Id,Contact__c ,name,Service_Advisor__c,CAC_Lead_Status__c  from Lead__c Where Contact__c=:leads.Contact__c AND Service_Advisor__c=:leads.Service_Advisor__c AND Id!=:leads.Id AND RecordtypeId=:leads.recordtypeId]){
            slaves.add(new LeadWrapperclass(a));
          }
        }
           
        SoqlFieldset = new set<string>();
        SoqlFieldset.addAll(this.getFieldsListByFieldSet('LeadMergeFieldsSet'));    
        Lead__c leadrecord= this.getQueriedLead(leads.Id);
        boolean mastercount=true;
        boolean slavecount=true;
        // Initiate hasMessage and wraps
        hasMessage = false;
        wraps = new List<LeadWrapper>();       
        try{
        if(Apexpages.currentPage().getParameters().get('selectedValue')!=Null){
              selectedValue=Apexpages.currentPage().getParameters().get('selectedValue');             
              getMasterAndslaveId();
              master= this.getQueriedLead(leads.Id); 
              slave = this.getQueriedLead(selectedValue);                   
         }  
         }
        catch(Exception e){
          hasMessage=true;
          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'No master record found for duplicate merge'));
        }             
        // Populate Inner class List
        If(master!=Null && slave!=Null){            
          //  hasSuspectLeads = Slaves.size() < 1;            
           /* (!hasSuspectLeads){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 
                                       Label.CP_No_Search_Result));
            } */
           this.populateLeadWrappers();           
          }
    }
    
    /** 
     * @Description : Get the id of choosen Master and Slave accounts.       
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)    
     */ 
     public void getMasterAndslaveId(){  
         chosenSlaveId=selectedValue;
         chosenMasterId=leads.id;        
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
        getMasterAndslaveId();
        PageReference pr = new PageReference('/apex/SelectSlaveLead?Id='+leads.Id);
        pr.setRedirect(true);
        return pr;
     }
   /** 
     * @Description : Merging duplicates Account having same "Dup Number" ,If Selected master records would be more than one ,user will get an warning message.
       @Comments : While Merging,Selected master record will be updated on the respective "Account".
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)  
     * @return : "AccountMerge" page will be appeared with choosen "Master Record".
     */
   public PageReference mergeDup() {
          getMasterAndslaveId();
          PageReference pr = new PageReference('/apex/LeadMerge?Id='+chosenMasterId+'&'+System.Label.slaveId+'='+chosenSlaveId+'&retURL=/apex/SelectSlaveLead?Id='+chosenSlaveId+'&selectedValue='+selectedValue);
          pr.setRedirect(true);
          return pr;
         }
     /** 
     * @Description : Get quried account with fields list in AccountMergeFields FieldSet by accId
     *              : N.B. SOQL Field List = FieldSet Members + FieldMappingConstant.PHONE_DMS_FIELDS_MAPPING.values().
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)      
     */    
    private Lead__c getQueriedLead(Id leadId) {
        String soql = 'SELECT ' + getSOQLFieldList(SoqlFieldset);
        
        if (!soql.contains('Contact__c')) {
           soql += 'Contact__c, ';
        }
          if (!soql.contains('Service_Advisor__c')) {
           soql += 'Service_Advisor__c, ';
        }
        return Database.query(soql + 
            ' Id,recordType.developerName,name  FROM Lead__c WHERE Id =\''+leadId+'\''+'AND RecordtypeId=\''+leads.recordtypeId+'\'');
    }
    /** 
     * @Description : Populate fieldLabel and fieldAPI 
       @           // 1. If master field value is same with slave's, just choose master value
                  // as default value
                 // 2. User can't change the master record.
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)      
     */ 
    private void populateLeadWrappers() {
        wraps = new List<LeadWrapper>(); 
        List<string> TotalFieldset = new list<string>();
        set<string> readonlyset = new set<string>();
        readonlyset =getFieldssetByFieldSet('LeadMergeFieldsSet');
     
       // TotalFieldset.addAll(fieldAPIList);
        TotalFieldset.addAll(readonlyset);
        
        for (String fieldAPI : TotalFieldset) {
            LeadWrapper wrap = new LeadWrapper();
            
            // Populate fieldLabel and fieldAPI
            wrap.fieldAPI = fieldAPI;
            wrap.fieldLabel = fieldNamesMap.get(fieldAPI).getDescribe().getLabel();
            
            // Get the Master Value and Slave Value by fieldAPI
            Object masterFieldValue = master.get(fieldAPI);
            Object slaveFieldValue = slave.get(fieldAPI);
     
            // Populate isMasterNull and isSlaveNull
            wrap.isMasterNull = (masterFieldValue == null);
            wrap.isSlaveNull = (slaveFieldValue == null);
            
           if (masterFieldValue!=slaveFieldValue && masterFieldValue!=Null && slaveFieldValue!=Null) {
                wrap.isSame = false;
                wrap.isMasterChecked = true;
                wrap.isSlaveChecked = true;
                wraps.add(wrap);
                continue;
            }
           else if(masterFieldValue==slaveFieldValue && masterFieldValue!=Null && slaveFieldValue!=Null){
                wrap.isSame = false;
                wrap.isMasterChecked = false;
                wrap.isSlaveChecked = false;
                wraps.add(wrap);
                continue;
           }
           else if (masterFieldValue == null &&  slaveFieldValue != null)
            {
               wrap.isSame = false;
               wrap.isMasterChecked = false;
               wrap.isSlaveChecked = false;
               wraps.add(wrap);
                continue;
           }
           else if (masterFieldValue == null &&  slaveFieldValue == null)
            {
               wrap.isSame = false;
               wrap.isMasterChecked = false;
               wrap.isSlaveChecked = false;
               wraps.add(wrap);
                continue;
           }
        }         
     }
    /** 
     * @Description : // Get the Fields List that will be displayed in the pageBlockTable from fieldSet
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)      
     */     
   /* public List<String> fieldAPIList {
       get {  
           return this.getFieldsListByFieldSet('LeadMergeFieldsSet');              
            } 
          set;
      }*/
    
     /** 
     * @Description : Get the SOQL Expr by fieldList
     * @author  Sneha chail
     * @Date 12/01/2015(mm/dd/yy)      
     */   
   /* private String getSOQLFieldList(List<String> fieldList) {
        String SOQLFieldList = '';
        for (String field : fieldList) {
            SOQLFieldList += field + ', ';
        }
        
        return SOQLFieldList;
    }  */ 
    private String getSOQLFieldList(set<String> fieldList) {
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
        List<Schema.FieldSetMember> fieldsetMembers = SObjectType.Lead__c.FieldSets.getMap().
            get(fieldSetName).getFields();
        for (Schema.FieldSetMember member : fieldsetMembers) {
            fieldsList.add(member.getFieldPath());
        }
        return fieldsList;
    } 
    private set<String> getFieldssetByFieldSet(String fieldSetName) {
        set<String> fieldsList = new set<String>();
        List<Schema.FieldSetMember> fieldsetMembers = SObjectType.Lead__c.FieldSets.getMap().
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
    public class LeadWrapper {
        public String fieldLabel            {get; set;}
        public String fieldAPI              {get; set;}
        public Boolean isMasterNull         {get; set;}
        public Boolean isSlaveNull          {get; set;}
        public Boolean isSame               {get; set;}
        public Boolean isMasterChecked      {get; set;}
        public Boolean isSlaveChecked       {get; set;}
        
         public LeadWrapper(){          
        } 
    }
     public class LeadWrapperclass {
       public Lead__c acc{get; set;} 
        
        public LeadWrapperclass(Lead__c a){
            acc = a;
        }  
     }
     public PageReference MergeLead() {        
        User usr;
        try {
            usr = [SELECT Id FROM User 
                  WHERE Profile.Name =:UtilConstant.PROFILE_SALES_LEAD_SOFT_DELETED  And IsActive = true 
                   LIMIT 1];
        }
        catch (QueryException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 
                Label.CP_No_User_Found));
            return null;
        }
        // Update Master
        for (LeadWrapper wrap : wraps) {           
            if (wrap.isSlaveChecked) {
                master.put(wrap.fieldAPI, slave.get(wrap.fieldAPI));
            }
        }
         
         if(MasterRecordTypeName== 'Sales Leads'){              
          slave.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead__c', 
           UtilConstant.RECORDTYPE_SALES_LEAD_SOFT_DELETED); 
         }else{
          slave.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead__c', 
           UtilConstant.RECORDTYPE_AFTERSALES_LEAD_SOFT_DELETED); 
         } 
           slave.OwnerId = usr.Id; 
         slave.Lead_Lost_Date_Time__c=date.today();
         slave.Related_Leads__c=leads.id;
         slave.Dealer_Lead_Status__c = 'Lost';
         slave.Dealer_Lost_Reason__c = 'Lead Merge';
         slave.Lost_Situation__c = 'Lead Merge';
        
         for(DM_Request__C dm:[Select id,Lead__c from DM_Request__c Where Lead__C=:slave.Id]){
             dm.Lead__c=leads.id;
             dmstr.add(dm);
         }
            
             for(SurveyTaker__c st:[Select id,Lead__c from SurveyTaker__c Where Lead__C=:slave.Id]){
             st.Lead__c=leads.id;
             surtake.add(st); 
         }
         
        // Set SavePoint, if slave DML failed, master DML should be rollback .
        SavePoint sp = Database.setSavepoint();        
        try {          
            update master;
            update slave;
            update dmstr;
            update surtake;
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
        PageReference pr = new PageReference('/'+Apexpages.currentPage().getParameters().get('id'));
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
        if (selectAllParam ==System.Label.master) {
            for (LeadWrapper wrap : wraps) {
                if (!wrap.isMasterNull) {
                    wrap.isMasterChecked = true;
                    wrap.isSlaveChecked = false;
                }
            }
        }
        else if (selectAllParam == System.Label.slave) {
            for (LeadWrapper wrap : wraps) {
                if (!wrap.isSlaveNull) {
                    wrap.isSlaveChecked = true;
                    wrap.isMasterChecked = false;
                }
            }
        }
    }
}