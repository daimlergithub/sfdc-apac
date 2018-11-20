@isTest
public class RetailCopyInfoAUNZ_Test {
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
            Address__c adds = new Address__c(Customer__c=acc.id, State_City__c = 'VIC', Address_Line_1__c='Test',ZipCode__c='123', Address_Type__c='Business', recordtypeID=RecordTypeIdAdd); 
            insert adds;
            test.startTest();
            Account_Link__c accLink = new Account_Link__c(Name='Test');
            insert accLink;
            try{
                accLink.fromRole__c=acc.id;
                accLink.toRole__c=acc.id;
                update accLink;
                RetailCopyInfoAUNZ retcopy =new RetailCopyInfoAUNZ();
                retcopy.createLinkRecordAdditionalFields(acc, accLink, 
                                                         adds, RecordTypeIdAcc, 
                                                         RecordTypeDealerIdAcc, true);
            }
            catch(Exception e){
                
            }
            
            try{
                RetailCopyInfoAUNZ retcopy =new RetailCopyInfoAUNZ();
                retcopy.createLinkRecordAdditionalFields(null, null, null, null, null, false);
            }
            catch(Exception e){
                
            }
            test.stopTest();
        }
    }
}