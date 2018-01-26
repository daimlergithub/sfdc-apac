global class CampaignMemberDisribution{

public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id accCompany_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    webservice static void cmDistributionToDealer(String camid){
    
     
     Batch_DistributionDealer  batcher = New Batch_DistributionDealer (camid);
       Database.executeBatch(batcher, 50);
    
    
    }






}