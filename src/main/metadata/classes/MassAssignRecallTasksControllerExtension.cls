/*
    Type:       Extension for MassAssignRecallTasks Visualforce page 
    Purpose:    Mass Assign or Recall Tasks
    User Story: US-Task-002, US-Task-003, US-Task-008, US-Task-009,
                US-Task-013, US-Task-014,
    Used By:    MassAssignRecallTasks .page
    ---------------------------------------------------------------
    History:
    
    1. Chris Created on 2013-05-30
    2. Patrick Zhang modified on 2013-11-11
    3. Chaos Edit on 2013-12-05  CR-000136  CR-000216 CR-000265
    4. Shuang Li Edit on 2014-03-17  US-SMART_SSI-007
*/
public class MassAssignRecallTasksControllerExtension {
    
    private Id PERSONACCOUNTRTID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    // Please select Evenly Location or input By Number first.
    public static final String ERROR_MSG_1 = Label.Mass_Assign_Recall_Tasks_ErrorMsg1;
    // 'XX Tasks have been assigned.'
    public static final String ERROR_MSG_2 = Label.Mass_Assign_Recall_Tasks_ErrorMsg2;
    // Please Select CSR and Assign Rules.(Please select CSR and distribution.)
    public static final String ERROR_MSG_3 = Label.Mass_Assign_Recall_Tasks_ErrorMsg3;
    Transient Set<String> whatIds; // For soql statement generated.
    private Datetime fd;
    private Datetime td;
    //ADD CHAOS CR-000216 2013/12/9
    private Date nrd;
    private List<Account> accounts;
    private List<SSI__c> ssis;
    
    public Boolean isSSITask {get; set;}    
    public Boolean isCACData {get; set;}    
    public OB_Task_Handing__c th {get;set;}    
    private ApexPages.standardController controller {get;set;}
    public string campaign {get;set;}    
    public string assignment {get;set;}    
    public Boolean hasQueryResult {get; set;}    
    public string csrIds {get;set;}    
    //ADD START CHAOS CR-000136 2013/12/5
    public String taskOwnerIds{get; set;}
    //ADD END CHAOS CR-000136 2013/12/5    
    public Boolean canByNum {get; set;}
    public Boolean byAccount {get; set;}
    
        public List<SelectOption> getassignmentItems() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = OB_Task_Handing__c.Assign_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();       
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getValue(),f.getLabel()));
        }
        return options;
    }
    
    
    public PageReference displayByNum(){
        if(th.Evenly_Location__c == true){
            canByNum = false;
        }else{
            canByNum = true;
        }
        return null;
    }
   
   public PageReference displayByAccount(){
       System.debug('byacc>>>>'+th.By_Account__c);
        if(th.By_Account__c == true){
         System.debug('byacc>>>>1'+th.By_Account__c);
            byAccount = false;
        }else{
         System.debug('byacc>>>>2'+th.By_Account__c);
            byAccount = true;
        }
        return null;
    }
    
    public MassAssignRecallTasksControllerExtension(Apexpages.StandardController stdController) {
        controller = stdController;               
        this.th = (OB_Task_Handing__c)stdController.getRecord();
        this.assignment = 'Assignment';
        this.canByNum = true;
        this.byAccount = true;
        String dn = ApexPages.currentPage().getParameters().get('dealername');
        if(dn!=null && dn.length()>0){
            dn = EncodingUtil.urlDecode(dn, 'UTF-8');
            this.th.Dealer_Name__c = dn;        
        }
        Profile pf = [Select Name From Profile Where Id = :UserInfo.getProfileId()];
        
        isSSITask = pf.Name.startsWith('CAC SSI') ? true : false;
        isCACData = pf.Name.startsWith('CAC Data Manager') ? true : false;
    }
    
    public PageReference applyFilters(){
        // MOD START CHAOS Ticket147654 2014/4/14
        String md='JP';
        String sql = 'Select Count() From Task Where ' + getFilters() +   'limit 40000';
         system.debug('++++++++++++++++++++++++++++'+sql);
        // MOD END CHAOS Ticket147654 2014/4/14
        th.Tasks_Found__c = Database.countQuery(sql);
        th.CSR__c = '';
        th.Evenly_Location__c = false;
        th.By_Number__c = null;
        this.canByNum = true;
        this.csrIds = null;
        
        return null;
    }

    // ADD START CHAOS CR-000265 2013/12/5  
    public PageReference closeTasks(){
        // MOD START CHAOS Ticket147654 2014/4/14
        String ctSql = 'Select Status, Id From Task Where ' + getFilters() + ' limit 40000';
        // MOD END CHAOS Ticket147654 2014/4/14
        List<task> tasks = Database.query(ctSql);
        if(tasks.size() > 0){
            Map<String, String> updateMap = new Map<String, String>();
            updateMap.put('Status', 'Closed');
    
            String queryIds = ' ';
            for( Task t : tasks){
                queryIds += '\''+ t.Id + '\'';
                queryIds += ',';
            }
            queryIds = queryIds.subString(0, queryIds.length()-1);
    
            String queryStr = 
                'Select Id, Status From Task Where Id In (' + queryIds + ') ';
                
            BatchUpdateRecords batcher = new BatchUpdateRecords(queryStr, updateMap);
            Database.executeBatch(batcher, 200);
        }
        return null;
    }
    // ADD END CHAOS CR-000265 2013/12/5
    
    private String getFilters(){
        String Market='JP';
        String sql = '   Createddate >= LAST_N_MONTHS:6 And  Status = \'Open\' ';
        
        //ADD START Shuang Li US-SMART_SSI-007
        sql += ' And RecordType.DeveloperName In (\'smart_SSI_Task\', \'SSI_Task\',\'OB_Call\', \'OB_Task\', \'Welcome_Call\')';
        //ADD END Shuang Li US-SMART_SSI-007
        
        if(th.Subject__c!=null && th.Subject__c.length()>0){
            sql += ' And Subject = \'' + th.Subject__c + '\'';
        }
        
        campaign = th.Campaign__c;

        if(campaign!=null && campaign.length()>0){
            whatIds = new Set<String>(); 
            for (Campaign_Lead__c cl : [Select Id From Campaign_Lead__c Where Campaign__c = :campaign order by createdDate desc limit 40000]){
                whatIds.add(cl.Id);
            }
            if(whatIds.size() > 0){
                sql += ' And (WhatId = \'' + campaign + '\' Or WhatId In :whatIds )';
            }
            else{
                sql += ' And WhatId = \'' + campaign + '\'';
            }
        }
        
        if(th.From__c!=null){
            //fd = Datetime.newInstance(th.From__c, Time.newInstance(0, 0, 0, 0));
            //sql += ' And CreatedDate >= :fd';
        }
        
        if(th.To__c!=null){
            td = Datetime.newInstance(th.To__c.addDays(1), Time.newInstance(0, 0, 0, 0));
            sql += ' And CreatedDate < :td';
        }
        
        if(th.Suspect_Dup__c!=null && th.Suspect_Dup__c!='All' ){
            if(th.Suspect_Dup__c=='Dup'){
                sql += ' And DUP_Number__c != Null';
            }else{
                sql += ' And DUP_Number__c = Null';
            }
        }
        
        if(th.Call_Times__c!=null){
            if(th.Call_Times__c==0){ 
                sql += ' And (OB_Call_Times__c = ' + th.Call_Times__c +' Or OB_Call_Times__c = null)';
            }else{
                sql += ' And OB_Call_Times__c = ' + th.Call_Times__c;
            }    
        }
        
        // ADD START CHAOS CR-000136 2013/12/5
        system.debug('++++++++taskOwnerIds ++++++++++++'+taskOwnerIds );
        if(taskOwnerIds != null && taskOwnerIds.length()>0){
            List<String> ownerIds = taskOwnerIds.split(';');
            for(Integer i = 0; i<ownerIds.size();i++){
                ownerIds[i] = '\'' + ownerIds[i].trim() + '\'';
            }
            sql += ' And OwnerId in ' + ownerIds;
        }
        // ADD END CHAOS CR-000136 2013/12/5

        if(isSSITask){
            String ssisql = 'Select Id From SSI__c Where Status__c In (\'Matched\', \'Unmatched\') '; 
            Boolean ssiFilter = false;            
            
            if(th.Dealer_Name__c!=null){
                ssisql += ' And DealerName__c like \'%' + th.Dealer_Name__c + '%\'';
                ssiFilter = true;
            }
            
            if(th.Customer_Name__c!=null){
                ssisql += ' And CustomerName__c like \'%' + th.Customer_Name__c + '%\'';
                ssiFilter = true;
            }
            
            if(th.Phone_Number__c!=null){
                ssisql += ' And (OfficePhone__c like \'%' + th.Phone_Number__c + '%\' ' 
                    + 'Or HomeMobilePhone__c like \'%' + th.Phone_Number__c + '%\')';
                ssiFilter = true;
            }
            
            if(ssiFilter ){
                String querySSIs = 'null';
                for(SSI__c ssi : Database.Query(ssisql)){
                    querySSIs += ',';
                    querySSIs += '\''+ ssi.Id + '\'';
                }

                sql += ' And WhatId In (' + querySSIs + ')'; 
            }
            
        }else{
            
            String accsql = 'Select PersonContactId From Account Where RecordTypeId = \'' + PERSONACCOUNTRTID + '\' '; 
            Boolean accFilter = false;            
            
            if(th.Customer_Number__c!=null){
                accsql += ' And Customer_Number__c like \'%' + th.Customer_Number__c + '%\'';
                accFilter = true;
            }
            
            if(th.Customer_Name__c!=null){
                accsql += ' And Name like \'%' + th.Customer_Name__c + '%\'';
                accFilter = true;
            }
            
            //ADD START CHAOS CR-000216 2013/12/6
            if(th.Batch_No__c!=null){
                accsql += ' And Batch_No__c = \'' + th.Batch_No__c+ '\'';
                accFilter = true;
            }
            //ADD END CHAOS CR-000216 2013/12/6
            
            if(th.Phone_Number__c!=null){
                accsql += ' And (PersonMobilePhone like \'%' + th.Phone_Number__c + '%\' ' 
                    + ' Or Phone like \'%' + th.Phone_Number__c + '%\' '
                    + ' Or PersonHomePhone like \'%' + th.Phone_Number__c + '%\' '
                    + ' Or PersonOtherPhone like \'%' + th.Phone_Number__c + '%\')';
                accFilter = true;
            }
            
            if(accFilter){
                String queryAccounts = 'null';
                for(Account acc : Database.Query(accsql)){
                    queryAccounts += ',';
                    queryAccounts += '\''+ acc.PersonContactId + '\'';
                }

                sql += ' And WhoId In (' + queryAccounts + ')';
            }
            
            //ADD START CHAOS CR-000216 2013/12/9
            String cpleadSql = 
                'Select Id, (Select Subject, Status, Task_RecordType_Name__c From OpenActivities) From Campaign_Lead__c Where '; 
            Boolean cpleadFilter = false;
            
            if(th.Network_Registration_Date__c!=null){
                nrd = th.Network_Registration_Date__c;
                cpleadSql += ' Lead__r.Network_Registration_Date__c = :nrd';
                cpleadFilter = true;
                if(campaign!=null && campaign.length()>0){
                    cpleadSql += 'And Campaign__c = \'' + campaign + '\'';
                }
            }
            // 2014-04-15 modified by Justin Yu -- exchanged the Network date with from date and to date.
            if(th.Network_Registration_Date_From__c > th.Network_Registration_Date_To__c){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.End_Time_Greater_Start_Time));
            }
            if(th.Network_Registration_Date_From__c != null){
                nrd = th.Network_Registration_Date_From__c;
                cpleadSql += ' Lead__r.Network_Registration_Date__c >= :nrd ';
                cpleadFilter = true;
            }
            if(th.Network_Registration_Date_To__c != null){
                nrd = th.Network_Registration_Date_To__c;
                cpleadSql += cpleadFilter ? ' and ' : '';
                cpleadSql += ' Lead__r.Network_Registration_Date__c < :nrd ';
                cpleadFilter = true;
            }
            
            if(cpleadFilter && campaign != null && campaign.length() > 0){
                cpleadSql += ' And Campaign__c = \'' + campaign + '\' ';
            }

            if(cpleadFilter){
                String queryCpleads = 'null';
                for(List<Campaign_Lead__c> cams : Database.Query(cpleadSql)){
                    for (Campaign_Lead__c cplead : cams) {
                        if (cplead.OpenActivities != null && cplead.OpenActivities.size() > 0) {
                            queryCpleads += ',';
                            queryCpleads += '\''+ cplead.Id + '\'';
                        }
                    }
                }
                sql += ' And WhatId In (' + queryCpleads + ')';
            }
            //ADD END CHAOS CR-000216 2013/12/9
        }
    
        Profile pf = [Select Name From Profile Where Id = :UserInfo.getProfileId()];
        List<String> profiles = new List<String>();
        String tp = '';
        if(pf.Name.startsWith('CAC') && pf.Name.length()>=7){
            tp = pf.Name.substring(0,7).trim();
        }
        if(tp.startsWith('CAC') && !tp.startsWith('CAC Dat')){
            if(assignment == 'Assignment'){
                profiles.add(tp + ' TL');
                profiles.add(tp + ' SV');
            }else{
                profiles.add(tp + ' CSR');
                profiles.add(tp + ' Trainer');
                profiles.add(tp + ' QC');
            }
        }else{
            if(assignment == 'Assignment'){
                profiles.add('CAC IB TL');
                profiles.add('CAC OB TL');
                profiles.add('CAC SSI TL');
                profiles.add('CAC IB SV');
                profiles.add('CAC OB SV');
                profiles.add('CAC SSI SV');
            }else{
                profiles.add('CAC IB CSR'); 
                profiles.add('CAC IB QC'); 
                profiles.add('CAC IB Trainer');         
                profiles.add('CAC OB CSR'); 
                profiles.add('CAC OB QC'); 
                profiles.add('CAC OB Trainer');         
                profiles.add('CAC SSI CSR'); 
                profiles.add('CAC SSI QC'); 
                profiles.add('CAC SSI Trainer');
            }
        }
        
        List<Profile> tlProfiles = [Select Id From Profile Where Name in :profiles];
        String queryProfiles = ' ';
        for(Profile p : tlProfiles){
            queryProfiles += '\''+ p.Id + '\'';
            queryProfiles += ',';
        }
        queryProfiles = queryProfiles.subString(0, queryProfiles.length()-1);
        
        //sql += ' And Owner.ProfileId In (' + queryProfiles + ')';
        return sql;
    }

    public PageReference assignTasks(){
        
        if(th.Tasks_Found__c!=null && th.Tasks_Found__c>0 && csrIds!=null && csrIds.length()>0){
            
            if(th.Evenly_Location__c == false && th.By_Number__c == null){
                // Please select Evenly Location or input By Number first.
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_MSG_1));
            }
                        if(th.By_Account__c == false && th.Evenly_Location__c == false && th.By_Number__c == null){
                // Please select by account Evenly Location or input By Number first.
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_MSG_1));
            }
        
                List<String> ids = csrIds.split(';');
            for(Integer i=0;i<ids.size();i++){
                ids[i] = ids[i].trim();
            }

            List<User> users = [Select Id From User Where Id In :ids];

            Integer perCount = Integer.valueOf(th.By_Number__c==null?0:th.By_Number__c);
            
            if(th.Evenly_Location__c==true){
                perCount = (Integer)th.Tasks_Found__c / users.size();
            }
            
            List<Task> allTasks = new List<Task>();
            List<Task> assignTasks = new List<Task>();
            // MOD START CHAOS Ticket147654 2014/4/14
            String sql = 'Select Id, OwnerId, WhatId, What.Type,UCID__c From Task Where ' + getFilters() + ' Order By Dealer_Name__c'  + ' limit 40000';
            allTasks = Database.query(sql);
            //for(List<Task> tasks : Database.query(sql)){
            //    allTasks.addAll(tasks);
            //}
            // MOD END CHAOS Ticket147654 2014/4/14
            
            Integer totalCount = perCount * users.size();
            Integer size = 0;
            Integer userIndex = 0;
            Task t1 = null;
            User csr = null;
            while(size < totalCount){
                if(allTasks.size()>0){
                    t1 = allTasks[0];
                    if (users.size() <= userIndex) {
                        userIndex = 0;      
                    }
                    csr = users.get(userIndex);
                    t1.OwnerId = csr.Id;
                    assignTasks.add(t1);
                    allTasks.remove(0);
                    userIndex++;
                    size++;
                }                
            }
            Task t2 = null;
            if(th.Evenly_Location__c == true && allTasks.size() > 0){
                for(Integer i=0; i<allTasks.size(); i++){
                    t2 = allTasks.get(i);
                    t2.OwnerId = users.size() > i? users[i].Id : users[0].Id;
                }
                assignTasks.addAll(allTasks);
            }
            if(assignTasks.size()>0){
                String queryIds = ' ';
                for(Task tkId : assignTasks){
                    queryIds += '\''+ tkId.Id + '\'';
                    queryIds += ',';
                }

                queryIds = queryIds.subString(0, queryIds.length()-1);
                String queryStr = 
                    'Select Id, OwnerId ,UCID__c From Task Where Id In (' + queryIds + ') ';
                BatchAssignTasks batcher = new BatchAssignTasks(queryStr, users);
                Database.executeBatch(batcher, 200);
                this.th.Tasks_Found__c = this.th.Tasks_Found__c - assignTasks.size();
                // 'XX Tasks have been assigned.'
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, assignTasks.size() + ERROR_MSG_2));
            }
        }else{
            // Please Select CSR and Assign Rules.(Please select the CSR and distribution patterns.)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_MSG_3));
        }
        return null;
    }
}