/**
* Utility for Trigger on Campaign for TH(Thailand)
* Author: Bhushan K
* Created Date : 2017-03-02
*/



public class CampaignHelperTH {
    
    private static String pending ='Pending';
    public static Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Campaign.getRecordTypeInfosByName();    // Campaign Record Type MAP
    public static Map<String, Schema.RecordTypeInfo> tkRecordTypeMap = Schema.SObjectType.Task.getRecordTypeInfosByName();
    public static string CacCampaign ='CAC Campaign';
    
  
    
    public static void afterInsertUpdateEvents(list<Campaign> campaignNew,map<id,Campaign> campaignOldMap, boolean isUpdate)
    {

        /* START Variable Definition    */
        Set<ID> cpIdSet = new Set<ID>(); // Campaign ID Set       
        List<Campaign> cpAccList = new List<Campaign>(); // Campaign Exection List by Contact 
        List<Campaign> cpLeadList = new List<Campaign>();  // Campaign Exection List by Lead 
        List<Campaign> cpVehicleList = new List<Campaign>(); // Campaign Exection List by Vehicle
        List<Campaign> cpCaseList = new List<Campaign>(); // Campaign Exection List by Case
        
        // Batch Job String Ids
        String cpAccIds = UtilConstant.Empty; // Campaign Id String
        String cpLeadIds = UtilConstant.Empty;
        String cpVehicleIds = UtilConstant.Empty;
        String cpCaseIds = UtilConstant.Empty;
        Batch_Job__c accJob = new Batch_Job__c(Batch_Type__c='Contact', Status__c=pending);
        Batch_Job__c leadJob = new Batch_Job__c(Batch_Type__c='Lead', Status__c=pending);
        Batch_Job__c vehJob = new Batch_Job__c(Batch_Type__c='Vehicle', Status__c=pending);
        Batch_Job__c caseJob = new Batch_Job__c(Batch_Type__c='Case', Status__c=pending);
        /* END Variable Definition  */
         
        /* START Iterate Campaign to relevant campaign list */
        for(Campaign cp : campaignNew) {
            // All Activated Campaign Execution
        
            if(cp.Create_Task__c && (isUpdate && !campaignOldMap.get(cp.Id).Create_Task__c) && 
                (cp.RecordTypeId == cpRecordTypeMap.get('Campaign Execution - Complex').getRecordTypeId() || 
                cp.RecordTypeId == cpRecordTypeMap.get('Campaign Execution - Simple').getRecordTypeId())) {
                
                if(cp.Task_Created_By__c == 'Contact') {
                    // Campaign Exection List by Contact 
                    cpAccList.add(cp); 
                  
                    // Batch Job Ids String
                    cpAccIds = cpAccIds + ';' + String.valueof(cp.Id);
                } else if(cp.Task_Created_By__c == 'Lead') {
                    // Campaign Exection List by Lead
                    cpLeadList.add(cp);
                    // Batch Job Ids String
                    cpLeadIds = cpLeadIds + ';' + String.valueof(cp.Id);
                } else if(cp.Task_Created_By__c == 'Vehicle') {
                    // Campaign Exection List by Vehicle
                    cpVehicleList.add(cp);
                    // Batch Job Ids String
                    cpVehicleIds = cpVehicleIds + ';' + String.valueof(cp.Id);
                } else if(cp.Task_Created_By__c == 'Case') {
                    // Campaign Exection List by Case
                    cpCaseList.add(cp);
                    // Batch Job Ids String
                    cpCaseIds = cpCaseIds + ';' + String.valueof(cp.Id);
                }
            } else if (isUpdate && cp.isActive && !campaignOldMap.get(cp.Id).isActive && cp.RecordTypeId == cpRecordTypeMap.get(CacCampaign).getRecordTypeId()) {     
                // CAC Campaign List
                cpIdSet.add(cp.id);
                 
             
                List<Campaign> childCmpList = new List<Campaign>(); 
               for(Campaign childCAC : [Select Id From Campaign Where ParentId=:cp.Id And isActive=false And RecordTypeId=:cpRecordTypeMap.get(CacCampaign).getRecordTypeId()]){
                 
                   childCAC.isActive = true;
                   
                    childCmpList.add(childCAC);
                    
                } 
                
                try{
                    update childCmpList;
                }catch(DmlException ex){
                    cp.addError('You can not activate a campaign without any execution.');
                }

            }
        }
        /* END Iterate Campaign to relevant campaign list */
        
        /* START Campaign Excution create task update */
        List<Campaign> cpExeList = new List<Campaign>();
        
        if(!cpIdSet.isEmpty()) {
            for(Campaign cpExe : [select id, Create_Task__c from Campaign where ParentId in :cpIdSet ]) {
                cpExeList.add(new Campaign(id = cpExe.Id, Create_Task__c = true));
            }
        }

        if(!cpExeList.IsEmpty()) update cpExeList;
        /* END Campaign Excution create task update */
        
        
        /* START Batch Execution */
        if(!cpAccList.isEmpty()) {          
            database.executeBatch(new UtilCampaignTaskGenerationByAccount(cpAccList), 200);
            accJob.Campaign_Set__c = cpAccIds;
        
            if(accJob!=Null){
            insert accJob;
            }
        }
        
        if(!cpLeadList.isEmpty()) {         
            //database.executeBatch(new UtilCampaignTaskGenerationByLeads(cpLeadList), 200);
            leadJob.Campaign_Set__c = cpLeadIds;
            if(leadJob!=Null){
             insert leadJob;       
            }  
        }
        if(!cpVehicleList.isEmpty()) {          
            //database.executeBatch(new UtilCampaignTaskGenerationByVehicle(cpVehicleList), 200); 
            vehJob.Campaign_Set__c = cpVehicleIds;
            insert vehJob; 
        }
        if(!cpCaseList.isEmpty()) {          
            //database.executeBatch(new UtilCampaignTaskGenerationByCase(cpCaseList), 200); 
            caseJob.Campaign_Set__c = cpCaseIds;
            insert caseJob; 
        }
        /* END Batch Execution */
    
    }
    
    
      
    public static void beforeUpdateEvents(list<Campaign> campaignNew,map<id,Campaign> campaignOldMap)
    {
      
        Id cmpExeReTpIdS = cpRecordTypeMap.get('Campaign Execution - Simple').getRecordTypeId();
        Id cmpExeReTpIdC = cpRecordTypeMap.get('Campaign Execution - Complex').getRecordTypeId();
        Set<Id> campaignIds = new Set<Id>();
        for(Campaign cp : campaignNew) {
            if (cp.isActive && !campaignOldMap.get(cp.Id).isActive && cp.RecordTypeId == cpRecordTypeMap.get(CacCampaign).getRecordTypeId())
            {
                 campaignIds.add(cp.Id);
            }
        }
        
        Map<Id, Integer> CampaignCMPExes = new Map<Id, Integer>();
        for(Campaign cmp : [Select Id, ParentId from Campaign Where ParentId in :campaignIds And (RecordTypeId=:cmpExeReTpIdS Or RecordTypeId=:cmpExeReTpIdC)])
        {
            if(!CampaignCMPExes.containsKey(cmp.ParentId))
            {
                 CampaignCMPExes.put(cmp.ParentId, 0);
            }
            CampaignCMPExes.put(cmp.ParentId, CampaignCMPExes.get(cmp.ParentId) + 1);
        }
        
        for(Campaign cp : campaignNew)
         {
            if(CampaignCMPExes.get(cp.Id)==null)
                CampaignCMPExes.put(cp.id,0);
            if ((cp.isActive && !campaignOldMap.get(cp.Id).isActive && cp.RecordTypeId == cpRecordTypeMap.get(CacCampaign).getRecordTypeId()) && (CampaignCMPExes.get(cp.Id) < 1 ))
            {
                
                    cp.addError('You can not activate a campaign without any execution.');
                                
            }
        }
    }
    
  
}