@isTest
public class IndividualEmailResultHelperTHTest {
	Private static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); // Person Account.
	IndividualEmailResultHelperTH testhelper = new IndividualEmailResultHelperTH();
    static testMethod void testAccAssignment(){ 
		Trigger__C casetrigger=new Trigger__C(name='IndividualEmailResult',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='TriggerIndividualEmailResultHandlerTH',Trigger_Name__c='TriggerIndividualEmailResult',update__c=true);
		insert casetrigger;	
		Profile p1 = [select id from profile where Name='System Administrator' limit 1];
		User user1 = new User(LastName='User',Market__c='TH',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='Mcain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01'+String.valueof(DateTime.now().getTime()));
		insert user1;
		system.runas(user1){    
			Test.startTest();
			List<account> acc=new List<account>();
			List<contact> con=new List<contact>();
			et4ae5__SendDefinition__c es=new et4ae5__SendDefinition__c();
			insert es;
			List<et4ae5__IndividualEmailResult__c> em=new List<et4ae5__IndividualEmailResult__c>();
			acc.add(new Account(Md__c='TH',UCID__c='989898989',RecordTypeId = accPerson_RecordTypeId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605', Individual_Home_Phone__c='+6698857857'));
			acc.add(new Account(Md__c='TH',UCID__c='989898989',RecordTypeId = accPerson_RecordTypeId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605', Individual_Home_Phone__c='+6698858578'));
			insert acc;
			for(Account ac:[select id,personcontactid from account where id in:acc]){
				em.add(new et4ae5__IndividualEmailResult__c(et4ae5__SendDefinition__c=es.id,et4ae5__Contact__c=ac.personcontactid,et4ae5__SoftBounce__c=true,et4ae5__HardBounce__c=true));
			}
			insert em;
			em[0].et4ae5__SoftBounce__c=false;
			update em;
			
			em[0].et4ae5__SoftBounce__c=true;
			em[0].et4ae5__HardBounce__c=false;
			update em;
			
			em[0].et4ae5__SoftBounce__c=false;
			em[0].et4ae5__HardBounce__c=false;
			update em;
			Test.stopTest();
		}
    }  
}