/* Purpose: Batch class hosting code to be executed for Malaysia. Updates Account status based on Campaign Member status.
   Date: 01/02/2018
   Created By: Sushma */

global class CampaignBouncebackStatusBatchUpdateMY implements Database.batchable<Sobject>,schedulable, Database.Stateful{

    set<Account> acctoupdate=new set<Account>();
    String market=System.Label.MarketMY;
    CampaignBouncebackStatusBatchUpdate cbs=new CampaignBouncebackStatusBatchUpdate();
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return cbs.queryMethod(bc, market);
    }
    
    global void execute(Database.BatchableContext bc,List<Retail_Campaign__c> retailCampaign){
        List<Campaign_Member__c> campmembertoupdate=new List<Campaign_Member__c>();
        
        for(Retail_Campaign__c retcamp:retailCampaign){
            for(Campaign_member__c campmember:retcamp.campaign_members__r){
                campmember.status__c='Not Responded';
                campmembertoupdate.add(campmember);
                if(campmember.Contact_Id__c !=null){
                
                    campmember.Contact_Id__r.Email_Status__c='Bounce-Back';
                    acctoupdate.add(campmember.contact_id__r);
                }
            }
        }
        if(campmembertoupdate.size()>0){
            
            DMLManagerService.updateAsSystem(campmembertoupdate);
            //update campmembertoupdate;
            
        }
    }
    
    global void finish(Database.BatchableContext bc){
        if(acctoupdate.size()>0){
                List<Account> acclst=new List<Account>();
                acclst.addall(acctoupdate);
                //AsyncExecutionExample asc=
                System.enqueuejob(new AsyncExecutionQueue(acclst));
                }         
            }
            
    global void execute(SchedulableContext ctx) 
        {
            Database.Executebatch(new CampaignBouncebackStatusBatchUpdateMY());                
        }
}