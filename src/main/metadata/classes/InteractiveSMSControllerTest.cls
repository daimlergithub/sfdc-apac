/*
    Type:       Page Controller
    ---------------------------------------------------------------
    History:
    
    1. 2014-2-27 Created By Justin Yu
*/
@isTest
public class InteractiveSMSControllerTest {
	@isTest public static void testInteractiveSMSController(){
		Account person = new Account(
			RecordTypeId = '01290000000fpFD',
			PersonMobilePhone = '18610011001',
			FirstName = 'First',
			LastName = 'Last',
			PersonEmail = 'test@test.com'
		);
		insert person;
		Person = [select PersonMobilePhone, Name, PersonEmail, PersonContactId from Account where Id = :person.Id];
		
		Case aCase = new Case(
			Subject = 'Case Subject',
			AccountId = person.Id,
			Case_Class__c = 'Pre-Sales',
			Car_Type__c = 'Dealer contact method',
			Case_SubType__c = 'Dealership Contacts',
			Status = 'Open'
		);
		insert aCase;
		
		Task ibCallTask = new Task(
			RecordTypeId = InteractiveSMSController.ibCallTask_RecordTypeId, 
			Subject = 'Call',
			Start_call_time__c = Datetime.now(),
			WhoId = person.PersonContactId, 
			WhatId = aCase.Id, 
			Phone__c = '18610011001',
			Status = 'Closed',
			Priority = 'Middle'
		);
		insert ibCallTask;
		
		InteractiveSMSController controller = new InteractiveSMSController();
	}
}