public class BatchJobHelper
{
    public static void afterInsertEvents()
    {
        // the # of in progress batch.
        List<Batch_Job__c> jobs = [Select Id, Name From Batch_Job__c Where Status__c='In Progress' ];
        
        // no being executed batch
        if(jobs==null || jobs.IsEmpty())
        {
            // the next pending job;
            for(Batch_Job__c nxJob : [Select Id, Name, Status__c, Campaign_Set__c, Batch_Type__c From Batch_Job__c Where Status__c='Pending' Order By Name ASC Limit 1])
            {
                if(nxJob != null)
                {
                    nxJob.Status__c = 'In Progress';
                    update nxJob;
                    
                    // Execute Batch
                    List<Campaign> cpList = new List<Campaign>();
                    List<String> str = New List<String>();
                    if(nxJob.Campaign_Set__c != null && nxJob.Campaign_Set__c != '')
                    {
                        for(String cpID : nxJob.Campaign_Set__c.split(';'))
                        {
                            if(cpId != '')
                            system.debug('+++++++++++++'+cpID);
                                //cpList.add(new Campaign(Id = (Id)cpID));
                                str.add(cpID);
                                //system.debug('+++++++++++++'+cpList);
                        }
                        
                        if(str!=null){
                        
                        List<campaign> camList =[select id From Campaign Where id =:str];
                        
                        for(Campaign cam :camList){
                        
                            cpList.add(cam);
                        }
                        
                        }
                        
                        if(nxJob.Batch_Type__c == 'Contact') 
                            database.executeBatch(new UtilCampaignTaskGenerationByAccount(cpList), 200);
                        if(nxJob.Batch_Type__c == 'Lead')        
                            database.executeBatch(new UtilCampaignTaskGenerationByLeads(cpList, nxJob.Id), 200);
                        if(nxJob.Batch_Type__c == 'Vehicle')        
                            database.executeBatch(new UtilCampaignTaskGenerationByVehicle(cpList, nxJob.Id), 200);
                        if(nxJob.Batch_Type__c == 'Case')        
                            database.executeBatch(new UtilCampaignTaskGenerationByCase(cpList, nxJob.Id), 200);    
                    }
                }
            }
        }
    }
}