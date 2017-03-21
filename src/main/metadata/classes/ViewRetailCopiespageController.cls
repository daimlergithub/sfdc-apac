public without sharing class ViewRetailCopiespageController {
    public List<Account_Link__c> accLnkList{get;set;}
    public ViewRetailCopiespageController(ApexPages.StandardController controller) {
        Id RecordId = ApexPages.currentPage().getParameters().get('Id');
        system.debug('RecordId :'+RecordId );
        Id devRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId();
        //accLnkList = [select id,Name,RecordType.Name,MD__c,fromRole__c,toRole__c from Account_Link__c where fromRole__c =:RecordId];
        accLnkList = [select id,Name,RecordType.Name,MD__c,fromRole__c,toRole__c from Account_Link__c where toRole__c =:RecordId and RecordType.Id !=: devRecordTypeId ];
        system.debug('accLnkList :'+accLnkList );
   }
}