@isTest
public class RetailCopyInfoDefault_Test {
	@isTest
    static void testExceptions(){
        //Id p = [select id from profile where name='Partner Community User'].id;
        User u = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
        System.runAs(u) {
            Id RecordTypeDealerIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
            Account mainAcct = createRetailCopyLCControllerTest.dealerAccSetup(RecordTypeDealerIdAcc,'CompanyMainTest','1234560789', 'AU');
            Account mainAcc=[Select id from Account where id=: mainAcct.Id];
            Account acct = createRetailCopyLCControllerTest.dealerAccSetup(RecordTypeDealerIdAcc,'Test', '1234560789','AU');
            Account acc=[Select id from Account where id=: acct.Id];
            Contact contct = createRetailCopyLCControllerTest.contactSetup(mainAcc.id,'TESING','TESTING','123',
                                                                           'Phenom@pic.com','123456',false,'AU');
            Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Id RecordTypeIdAdd = Schema.SObjectType.Address__c.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            //Address__c adds = new Address__c(Customer__c=acc.id, Address_Line_1__c='Test',ZipCode__c='123', Address_Type__c='Business', recordtypeID=RecordTypeIdAdd); 
            //insert adds;
            test.startTest();
            try{
                RetailCopyInfoDefault retaildeflt=new RetailCopyInfoDefault();
                //retaildeflt.createLinkRecord(acc.id, adds, user, null);
                retaildeflt.fetchDataTableFields(acc.id, null);
            }
            catch(Exception e){
                
            }
            try{
                RetailCopyInfoDefault retaildeflt=new RetailCopyInfoDefault();
                retaildeflt.fetchCardTableFields(acc.id, null);
            }
            catch(Exception e){
                
            }
            test.stopTest();
        }
    }
}