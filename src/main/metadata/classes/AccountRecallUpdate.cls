public class AccountRecallUpdate {
    /*Author:Tejbir Singh
    Used for Market: TH
    Date of creation:8/12/2017
    Usage:Update Recall field value of account once its related Vehicle Recall field value gets updated.
    */
    @InvocableMethod
    public static void updateRecall(List<Vehicle__c> lstVehicleIds)
    {
        List<Vehicle_Relationship__c> lstVehicleRelationship=[select Contact__c from Vehicle_Relationship__c where Vehicle_ID__c IN:lstVehicleIds];
        System.debug('***lstVehicleRelationship'+lstVehicleRelationship);
        List<Account> acclst=new List<Account>();
        if(lstVehicleRelationship!=null && lstVehicleRelationship.size()>0)
        {
            for(Vehicle_Relationship__c vrObj:lstVehicleRelationship)
            {
                Account acc=new Account(Id=vrObj.contact__c);
                Acc.Recall__c=true;
                acclst.add(acc);
            }
        }
        
        if(acclst!=null && acclst.size()>0)
            DMLManagerService.updateAsSystem(acclst);
    }
}