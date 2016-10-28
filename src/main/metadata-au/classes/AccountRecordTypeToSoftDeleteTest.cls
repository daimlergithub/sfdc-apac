@isTest
public class AccountRecordTypeToSoftDeleteTest {
        
        static testMethod void updatePersonAccountTest(){
        AccountRecordTypeToSoftDelete acc = new AccountRecordTypeToSoftDelete();
        RecordType personRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'account' AND Name = 'person account'];
        RecordType leadRecordTypeFinance = [SELECT Id FROM RecordType WHERE SObjectType = 'Lead__c' AND Name = 'Finance Lead'];
        List<Account> perAccList = new List<Account>();
        List<Lead__c> perLeadList = new List<Lead__c>();
        Test.startTest();
        for(integer i=0;i<201;i++){
             Account curAcc = new Account(Salutation = 'chief',firstname = 'test Account'+i, lastname='last'+i, recordtypeId = personRecordType.Id, mobile__c='040123456',PC_Status__c = 'Prospect',VAN_Status__c = 'Prospect',Insurance_Status__c = 'Prospect' );
             perAccList.add(curAcc);
        }
        insert perAccList;
        for(integer j=0;j<201;j++){
             lead__c curLead = new lead__c(Contact__c = perAccList[j].id ,Nature_of_Request__c = 'campaign', Lead_Source__c = 'campaign', 	CAC_Lead_Status__c = 'Lost', Business_Unit__c = 'Fleet', Sub_BusinessUnit__c = 'Sales', CAC_Lost_Reason__c = 'Lost Competitor', RecordTypeId = leadRecordTypeFinance.Id);
             perLeadList.add(curLead);
        }
        insert perLeadList;
        String sch = '0 0 23 * * ?'; 
	    system.schedule('Test Territory Check', sch, acc); 
        Test.stopTest();
        Account result= [SELECT Recordtype.Name FROM Account WHERE ID =: perAccList[66].Id];
        System.assertEquals('Person Account Soft Deleted', result.Recordtype.name);
    }
        
    static testMethod void updateCompanyAccountTest(){
        AccountRecordTypeToSoftDelete acc = new AccountRecordTypeToSoftDelete();
        RecordType companyRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Company'];
        RecordType leadRecordTypeVehicle = [SELECT Id FROM RecordType WHERE SObjectType = 'Lead__c' AND Name = 'Vehicle Lead'];
        List<Account> comAccList = new List<Account>();
        List<Lead__c> comLeadList = new List<Lead__c>();
        Test.startTest();
        for(integer i=0;i<201;i++){
             Account curAcc = new Account(Name= 'TestAccount'+i, recordTypeId = companyRecordType.Id, Mobile__c='040123456',PC_Status__c = 'Prospect',VAN_Status__c = 'Prospect',Insurance_Status__c = 'Prospect' );
             comAccList.add(curAcc);
        }
        insert comAccList;
        for(integer j=0;j<201;j++){
             lead__c curLead = new lead__c(Company_Account__c = comAccList[j].id ,Nature_of_Request__c = 'campaign', Lead_Source__c = 'campaign', 	CAC_Lead_Status__c = 'Lost', Business_Unit__c = 'Fleet', Sub_BusinessUnit__c = 'Sales', CAC_Lost_Reason__c = 'Lost Competitor', RecordTypeId = leadRecordTypeVehicle.Id);
             comLeadList.add(curLead);
        }
        insert comLeadList;
        String sch = '0 0 23 * * ?'; 
	    system.schedule('Test Territory Check', sch, acc); 
        Test.stopTest();
        Account result = [SELECT Recordtype.Name FROM Account WHERE ID =: comAccList[199].Id];
        System.assertEquals('Company Soft Deleted', result.Recordtype.name);
    }
}