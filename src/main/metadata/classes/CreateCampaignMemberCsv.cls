/***********************************************************************************
Created By          :    Venky  
Created Date        :    2018.07.31
Company             :    NTT Data,Inc.
Usage               :    The functionality of this class to get the retail campign attachment based on RT campaign id, 
After getting the attachmment parse the csv file and create child campaign member records.
JIRA NO             :                                                  
Bug JIRA NO         :     

MODIFICATION DETAILS:

1. Modified By      :    
Modifide Date    :    
************************************************************************************/

    global class CreateCampaignMemberCsv{
        // public string nameFile{get;set;}
          //  public Blob contentFile{get;set;}
            
         webservice static void FileUpload(String camid){
             
             if(Label.CreateCMMRecords=='Batch_CreateCMMObjectRecord')
            {
            if(!Test.isRunningTest()){
            Batch_CreateCMMRecord ob=new Batch_CreateCMMRecord(camid);
            Database.executeBatch(ob);
            }
            }
            if(Label.CreateCMMRecords=='CustomIterableBatchForCampaignMember')
            {
            CustomIterableBatchForCampaignMember ob=new CustomIterableBatchForCampaignMember(camid);
            Database.executeBatch(ob);
            }
             
            
         }
           
}