public class VehicleDataSharingHandler extends SharingDataHandlerBase{

    private Id recordTypeRetail = 
        UtilRecordType.getRecordTypeIdByName('Vehicle_Relationship__c', 'Vehicle Relationship Retail');
    
    public VehicleDataSharingHandler() {
        super('Vehicle__c', 'Read');
    }

    public override void executeProcessByCRMCode(List<sObject> scope) {
        system.debug('I am runing');
        CMap dmsAndDealer = super.filterDealer(scope);
        dmsAndDealer.cleanLessThanTwoList();

        if(dmsAndDealer.KeySet().size() < 1){return;}
        
        Set<String> dealerIds = dmsAndDealer.values2();
        SYSTEM.debug('dmsAndDealer====:'+dmsAndDealer);

        //get user
        CMap userAndDealer = new CMap();
        for(user u : [Select u.Id, u.AccountId From User u 
                      WHERE AccountId in :dealerIds
                      and isActive = true]) {
            
            userAndDealer.add(u.AccountId, u.Id);
        }

        //get vehicle
        CMap vehicleAndDealer = new CMap();
        for(Vehicle_Relationship__c vrc: [Select v.Vehicle_ID__c, v.Owner_Dealer__c 
                                          From Vehicle_Relationship__c v
                                          WHERE recordTypeId = :recordTypeRetail
                                          and Owner_Dealer__c in :dealerIds]){
            vehicleAndDealer.add(vrc.Owner_Dealer__c, vrc.Vehicle_ID__c);
        }

        //make them use crm code
        for(String crmCode : dmsAndDealer.KeySet()){
            for(String accountid : dmsAndDealer.get(crmCode)){
                parentIds.addAll(crmCode, vehicleAndDealer.get(accountid));
                userOrGroupIds.addAll(crmCode, userAndDealer.get(accountid));
            }
        }

        List<sObject> shareRecs = makeInserRecords(parentIds, userOrGroupIds);

        try {
            List<Database.SaveResult> result = Database.insert(shareRecs,false);  
            system.debug('Success Amount: [' + result.size() +'] |  Is :' + result);            
        } catch (DmlException e) {
            system.debug('DML Exception: ' + e.getDmlMessage(0));
        }
  
    }

}