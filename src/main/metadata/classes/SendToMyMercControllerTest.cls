@isTest 
private class   SendToMyMercControllerTest{
static testMethod void InvokeMeth(){
RecordType recCom = [select id from RecordType where sObjecttype = 'Account' AND Name = 'Company' limit 1];
RecordType recPer = [select id from RecordType where sObjecttype = 'Account' AND Name = 'Person Account' limit 1];
Account acc =   new Account();
        acc.Phone='09844650654';
        acc.FirstName = 'Test';
        acc.Mobile__c = '023482832';
        acc.Data_Source__c  = 'Test4';
        acc.personBirthdate = system.today();
        acc.LastName_Native_1__c = 'ァアィイゥウェエォオカガ';
        acc.Gender__c='Male';
        acc= (Account)UtilTestData.createSobject(acc,UtilConstant.person_Account); //new Account(name='TestAcc',phone='0123456789',RecordtypeId = recCom.Id,Portal_Email__c='test@gmail.com',LastName_Native_1__c = 'ァアィイゥウェエォオカガ',Email2__c = 'testemail2@test1.com');
Account acc1 =   new Account();
        acc1.Phone='09844650654';
        acc1.FirstName = 'Test';
        acc1.Mobile__c = '023482832';
        acc1.Data_Source__c  = 'Test4';
        acc1.personBirthdate = system.today();
        acc1.LastName_Native_1__c = 'ァアィイゥウェエォオカガ';
        acc1.Gender__c='Male';
        acc1 = (Account)UtilTestData.createSobject(acc1,UtilConstant.person_Account); //new Account(name='TestAc1c',phone='0123456789',RecordtypeId = recPer.Id, Portal_Email__c='test@gmail.com',LastName_Native_1__c = 'ァアィイゥウェエォオカガ',Email2__c = 'testemail2@test1.com',Gender__c='Male');

//Insert acc1;
//Insert acc;
Account_Link__c acclinkobj = new Account_Link__c(toRole__c = acc.Id,System__c = 'My Mercedes',Primary__c = True);
insert acclinkobj;
Account_Link__c acclinkobj1 = new Account_Link__c(toRole__c = acc1.Id,System__c = 'My Mercedes',Primary__c = True);
insert acclinkobj1;
Vehicle__c vehicalobj = new Vehicle__c(Related_Dealer__c = acc.Id);
insert vehicalobj;
Vehicle__c vehicalobj1 = new Vehicle__c(Related_Dealer__c = acc1.Id);
insert vehicalobj1;
Vehicle_Relationship__c vehicalrelobj = new Vehicle_Relationship__c(Vehicle_ID__c = vehicalobj.Id,Contact__c = acc.Id);
insert  vehicalrelobj;
Vehicle_Relationship__c vehicalrelobj1 = new Vehicle_Relationship__c(Vehicle_ID__c = vehicalobj.Id,Contact__c = acc1.Id);
insert  vehicalrelobj1;
ApexPages.StandardController sc = new ApexPages.StandardController(vehicalobj);
ApexPages.StandardController sc1 = new ApexPages.StandardController(vehicalobj1);
SendToMyMercController sendmerobj = new SendToMyMercController(sc);
SendToMyMercController sendmerobj1 = new SendToMyMercController(sc1);
ApexPages.currentPage().getParameters().put('recordID', vehicalrelobj.Id);
ApexPages.currentPage().getParameters().put('recordID', vehicalrelobj1.Id);
sendmerobj.showPopup();
sendmerobj.Submit();
//SendToMyMercController.AccountWrapper accwrapins= new SendToMyMercController.AccountWrapper (vehicalrelobj.Id,'Testemail@test.com','TestAccount','testee','test22','test33','test44','test55',acc.Id,vehicalrelobj.Id,true,true);
sendmerobj1.showPopup();
SendToMyMercController.AccountWrapper accwrapins= new SendToMyMercController.AccountWrapper (vehicalrelobj.Id,'Testemail@test.com','TestAccount','testee','test22','test33','test44','test55',acc.Id,vehicalrelobj.Id,true);
//SendToMyMercController.AccountWrapper accwrapins1= new SendToMyMercController.AccountWrapper (vehicalrelobj1.Id,'Testemail@test.com','TestAccount','testee','test22','test33','test44','test55',acc.Id,vehicalrelobj1.Id,true);
SendToMyMercController.AccountWrapper accwrapins1= new SendToMyMercController.AccountWrapper (vehicalrelobj1.Id,'Testemail@test.com','TestAccount','testee','test22','test33','test44','test55',acc.Id,null,true);

accwrapins.isSelect = true;
accwrapins1.isSelect = false;
accwrapins1.OptOutReason = 'Test';
sendmerobj.lstAccountWrapper.add(accwrapins);
sendmerobj1.lstAccountWrapper.add(accwrapins1);
sendmerobj.Submit();
sendmerobj1.Submit();
sendmerobj.closePopup();

//sendmerobj.savepop();
//sendmerobj.cancel();


sendmerobj1.closePopup();
sendmerobj1.Submit();
//sendmerobj.savepop();
//sendmerobj.cancel();


}
}