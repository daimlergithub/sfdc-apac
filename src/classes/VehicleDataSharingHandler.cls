/**
** A handler class for Vehicle Data Sharing model.
** 1. Shares the vehicle data with user groups by using the CRM codes.
**
** Created By: CC
** Date:  
**/

public with sharing class VehicleDataSharingHandler extends SharingDataHandlerBase{
    
    private Id recordTypeRetail = 
        UtilRecordType.getRecordTypeIdByName('Vehicle_Relationship__c', 'Vehicle Relationship Retail');
    
    public VehicleDataSharingHandler() {
        super('Vehicle__c', 'Read');
    }

    /**
    *@Description :This mehtod fetches the vehicles and shares it to the user group by using the CRM Codes.
    *@Author :Shrinivas Desai.
    *@Date : 27/10/2015
    *@param:List of sObjects.
    *@return:This mehtod does not return any value.
    *@see:executeProcessByCRMCode
    */
    public override void executeProcessByCRMCode(List<sObject> scope) {
        system.debug('I am runing' +scope);
        CMap dmsAndDealer = super.filterDealer(scope);
        system.debug('dmsAndDealerKeyset...1' +dmsAndDealer.KeySet());
        dmsAndDealer.cleanLessThanTwoList();
        system.debug('dmsAndDealerKeyset...2' +dmsAndDealer.KeySet());
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
        System.debug('vehicleAndDealer@@@'+vehicleAndDealer);
        //make them use crm code
        for(String crmCode : dmsAndDealer.KeySet()){
            for(String accountid : dmsAndDealer.get(crmCode)){
                System.debug('parentIds@@@'+crmCode+'@@@@'+vehicleAndDealer.get(accountid));
                if(vehicleAndDealer.get(accountid) != null){
                  parentIds.addAll(crmCode, vehicleAndDealer.get(accountid));
                }
                if(userAndDealer.get(accountid) != null){
                   userOrGroupIds.addAll(crmCode, userAndDealer.get(accountid));
                }
            }
        }
        system.debug('vehicle-->'+parentIds+'--user--'+userOrGroupIds);
        List<sObject> shareRecs ;
        if(parentIds != null && userOrGroupIds != null ){
          shareRecs = makeInserRecords(parentIds, userOrGroupIds);
        }

        try {
            List<Database.SaveResult> result = Database.insert(shareRecs,false);  
            system.debug('Success Amount: [' + result.size() +'] |  Is :' + result);            
        } catch (DmlException e) {
            system.debug('DML Exception: ' + e.getDmlMessage(0));
        }
  
    }

}