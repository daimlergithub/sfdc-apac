public class AccountRecallUpdate {
    /*Author:Tejbir Singh
    Used for Market: TH
    Date of creation:8/12/2017
    Usage:Update Recall field value of account once its related Vehicle Recall field value gets updated.
    */
    @InvocableMethod
    public static void updateRecall(List<Vehicle__c> lstVehicle)
    {
        List<Id> lstVehicleId=new List<Id>();
        for(Vehicle__c vehObj:lstVehicle)
        {
            lstVehicleId.add(vehObj.Id);
        }
        List<Vehicle_Relationship__c> lstVehicleRelationship=[select Contact__c from Vehicle_Relationship__c where Vehicle_ID__c IN:lstVehicleId and Market__c='TH'];
        Set<Account> accSet=new Set<Account>();
        List<Account> accLst=new List<Account>();
        
        if(lstVehicleRelationship!=null && lstVehicleRelationship.size()>0)
        {
            for(Vehicle_Relationship__c vrObj:lstVehicleRelationship)
            {
                Account acc=new Account(Id=vrObj.contact__c);
                Acc.Recall__c=true;
                accSet.add(acc);
            }
            if(accSet!=null && accSet.size()>0)
            accLst.addAll(accSet);
        }
        
        if(accLst!=null && accLst.size()>0)
            DMLManagerService.updateAsSystem(accLst);
    }
}