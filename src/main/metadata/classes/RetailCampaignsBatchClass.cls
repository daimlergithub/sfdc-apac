global class RetailCampaignsBatchClass implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            [select id from Retail_Campaign__c where Execution_Type__c='OB Call']
        );
    }

    global void execute(Database.BatchableContext bc, List<Retail_Campaign__c> RetailCampaign){
    list<Campaign_Member__c> CampaginMember=[select id,OwnerId,Name,Retail_Campaign_Id__c,Company_Name__c,Contract_Phone2_2__c,Contract_Phone1_1__c,Contact_Id__c,Vehicle__c,Campaign_ID__c,Contract__c  from Campaign_Member__c where Retail_Campaign_Id__c=:RetailCampaign]; 
    list<Task> AddTask=new list<Task>();
    List<Campaign_Member__c> cmUpdate =new List<Campaign_Member__c>();
    for(Campaign_Member__c CM: CampaginMember)
    {
       cm.Auto_creation_of_tasks__c=true;
       AddTask.add(new Task(
                            Subject = 'Campaign Member Task is Assigned to you',
                            ActivityDate = System.today() + 3,
                            ownerid=CM.ownerid,
                            whatid = CM.id,
                            Contract__c =CM.Contract__c,
                            Related_Vehicle__c=CM.Vehicle__c,
                            Account_Name__c =CM.Company_Name__c,
                            Phone__c=CM.Contract_Phone1_1__c,
                            Phone_number__c=CM.Contract_Phone2_2__c,
                            Campaign_Member_ID__c=CM.Name
                            
                            ));
                           
                            
    
    }
    insert AddTask;
    update CampaginMember;
    }    

    global void finish(Database.BatchableContext bc){

    }    

}