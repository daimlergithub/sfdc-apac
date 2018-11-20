/* Purpose: Helper class for Retail Task trigger for MY
   Date: 01/02/2018
   Created By: Sushma */

public class RetailTaskHelperBase{

    public static void  shareRetailTasksNDCode(List<Retail_Task__c> retailTasks, String Market){
    List<Retail_Task__c> retailT= new LIst<Retail_Task__c>();
    if(retailTasks.SIZe()>0){
        for(Retail_Task__c r :retailTasks){
         //Rajesh - changed to use RecordTypeAccessService to use cached recordtype data instead of Schema describe for each record
         //if(UtilRecordType.getRecordTypeIdByName('Retail_Task__c','Service').equalsIgnoreCase(r.RecordTypeId)) retailT.add(r);
         if(RecordTypeAccessService.getRecordTypeId('Retail_Task__c','Service') == r.RecordTypeId) retailT.add(r);
        }
        if(retailT.size()>0){
            Set<string> grpNameSet= new set<string>();
            list <Retail_Task__Share> RetailTaskShare = new List<Retail_Task__Share>();
            Map<string,id> grpMap= new map<string,id>();
            List<Retail_Task__c> retailTasksLst=[select Id,Related_Dealer__c,Related_Vehicle__c,Related_Dealer__r.Dealer_ND_Code__c,Related_Dealer__r.Dealer_GC_Code__c,Service_Dealer__c,Service_Dealer__r.Dealer_ND_Code__c,Service_Dealer__r.Dealer_GC_Code__c,MD__c from Retail_Task__c where Id IN:retailT];
            for(Retail_Task__c retailTask : retailTasksLst) {   
                String grpName=retailTask.md__c+retailTask.Service_Dealer__r.Dealer_ND_Code__c;
                grpNameSet.add(grpName);
            }
            for(Group grpObj: [select Id,Name from Group where Name in :grpNameSet]) {
                grpMap.put(grpObj.name,grpObj.id);
            }
            for(Retail_Task__c retailTask : retailTasksLst) {
                String grpName=retailTask.md__c+retailTask.Service_Dealer__r.Dealer_ND_Code__c;
                if(grpMap.get(grpName) != null){
                      RetailTaskShare.add(new Retail_Task__Share(ParentId=retailTask.id,AccessLevel='Read',RowCause=Schema.Retail_Task__Share.RowCause.Service_Share__c,UserOrGroupId=grpMap.get(grpName)));
                      
                }
            }
            if(RetailTaskShare.size()>0){
                database.upsert(RetailTaskShare,false);
            }       
            
        }
    }
  }
  

 public static void  shareRetailTasksNDCodeEdit(List<Retail_Task__c> retailTasks, String Market){
    List<Retail_Task__c> retailT= new LIst<Retail_Task__c>();
    if(retailTasks.SIZe()>0){
        for(Retail_Task__c r :retailTasks){
         //Rajesh - changed to use RecordTypeAccessService to use cached recordtype data instead of Schema describe for each record
         //if(UtilRecordType.getRecordTypeIdByName('Retail_Task__c','Service').equalsIgnoreCase(r.RecordTypeId)) retailT.add(r);
         if(RecordTypeAccessService.getRecordTypeId('Retail_Task__c','Service') == r.RecordTypeId) retailT.add(r);
        }
        if(retailT.size()>0){
            Set<string> grpNameSet= new set<string>();
            list <Retail_Task__Share> RetailTaskShare = new List<Retail_Task__Share>();
            Map<string,id> grpMap= new map<string,id>();
            List<Retail_Task__c> retailTasksLst=[select Id,Related_Dealer__c,Related_Vehicle__c,Related_Dealer__r.Dealer_ND_Code__c,Related_Dealer__r.Dealer_GC_Code__c,Service_Dealer__c,Service_Dealer__r.Dealer_ND_Code__c,Service_Dealer__r.Dealer_GC_Code__c,MD__c from Retail_Task__c where Id IN:retailT];
            for(Retail_Task__c retailTask : retailTasksLst) {   
                String grpName=retailTask.md__c+retailTask.Service_Dealer__r.Dealer_ND_Code__c;
                grpNameSet.add(grpName);
            }
            for(Group grpObj: [select Id,Name from Group where Name in :grpNameSet]) {
                grpMap.put(grpObj.name,grpObj.id);
            }
            for(Retail_Task__c retailTask : retailTasksLst) {
                String grpName=retailTask.md__c+retailTask.Service_Dealer__r.Dealer_ND_Code__c;
                if(grpMap.get(grpName) != null){
                      RetailTaskShare.add(new Retail_Task__Share(ParentId=retailTask.id,AccessLevel='Edit',RowCause=Schema.Retail_Task__Share.RowCause.Service_Share__c,UserOrGroupId=grpMap.get(grpName)));
                      
                }
            }
            if(RetailTaskShare.size()>0){
                database.upsert(RetailTaskShare,false);
            }       
            
        }
    }
  }
    
}