global class Batch_VRSharingJP implements Database.Batchable<sObject>, Database.Stateful{
    global final Set<Id> setmainId;
    global final Map<Id, List<Id>> InsertMap;
    global final Set<String> dealerAccount;
    global Batch_VRSharingJP(Set<String> dealerAccNameSet,Map<Id, List<Id>> map_FromAccountIdAndListToAccountId, Set<Id> set_ToAccountId){
    
        InsertMap = map_FromAccountIdAndListToAccountId;
        setmainId = set_ToAccountId;
        dealerAccount = dealerAccNameSet;
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Contact__c FROM Vehicle_Relationship__c WHERE Contact__c IN: InsertMap.keySet() ]);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Vehicle_Relationship__c> scope){
    
   
       Map<Id, List<Id>> map_AccountIdListUser = new Map<Id, List<Id>>();
       
        set<Vehicle_Relationship__Share> set_SharingRecord = new set<Vehicle_Relationship__Share>();
       // List<Vehicle_Relationship__c> list_VehicleRelationRecord = new List<Vehicle_Relationship__c>([SELECT Id, Contact__c 
                                                                                                       // FROM Vehicle_Relationship__c 
                                                                                                        //WHERE Contact__c IN: InsertMap.keySet()]);
       
         List<Group>groupList=[select Id, Name, Type from Group where Name IN: dealerAccount ];
            
            for(Group groupRec : groupList){
                for(Vehicle_Relationship__c vehicleR : scope){
                    if(InsertMap.containsKey(vehicleR.Contact__c)){
                      //  for(Id toAccId : map_FromAccountIdAndListToAccountId.get(vehicleR.Contact__c)){                           
                                    System.debug('ssize1');
                                    Vehicle_Relationship__Share vehicleRelationShare = new Vehicle_Relationship__Share();
                                    vehicleRelationShare.AccessLevel = 'Edit';
                                    vehicleRelationShare.UserOrGroupId = groupRec.id;
                                    vehicleRelationShare.ParentId = vehicleR.Id;
                                    vehicleRelationShare.RowCause = Schema.Vehicle_Relationship__Share.RowCause.Manual;
                                    set_SharingRecord.add(vehicleRelationShare);                                
                             
                       // }
                    }
                }
            }
            System.debug('setsize'+set_SharingRecord.size());
            if(set_SharingRecord.size() > 0){
                 list<Vehicle_Relationship__Share> list_SharingRecord = new List<Vehicle_Relationship__Share>(set_SharingRecord);
                Database.insert(list_SharingRecord, false);
            }
    
    
    }
    
    global void finish(Database.BatchableContext BC){
    
    }

}