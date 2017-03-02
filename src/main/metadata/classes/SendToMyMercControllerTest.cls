@isTest 
private class   SendToMyMercControllerTest{
static testMethod void InvokeMeth(){
RecordType recCom = [select id from RecordType where sObjecttype = 'Account' AND Name = 'Company' limit 1];
Account acc = new Account(name='TestAcc',phone='0123456789',RecordtypeId = recCom.Id,Portal_Email__c='test@gmail.com',LastName_Native_1__c = 'ァアィイゥウェエォオカガ',Email2__c = 'testemail2@test1.com');
Insert acc;
Account_Link__c acclinkobj = new Account_Link__c(toRole__c = acc.Id,System__c = 'My Mercedes',Primary__c = True);
insert acclinkobj;
Vehicle__c vehicalobj = new Vehicle__c(Related_Dealer__c = acc.Id);
insert vehicalobj;
Vehicle_Relationship__c vehicalrelobj = new Vehicle_Relationship__c(Vehicle_ID__c = vehicalobj.Id,Contact__c = acc.Id);
insert  vehicalrelobj;
ApexPages.StandardController sc = new ApexPages.StandardController(vehicalobj);
SendToMyMercController sendmerobj = new SendToMyMercController(sc);
ApexPages.currentPage().getParameters().put('recordID', vehicalrelobj.Id);
sendmerobj.showPopup();
SendToMyMercController.AccountWrapper accwrapins= new SendToMyMercController.AccountWrapper (vehicalrelobj.Id,'Testemail@test.com','TestAccount','testee','test22','test33','test44','test55',acc.Id,vehicalrelobj.Id,true);
accwrapins.isSelect = true;
sendmerobj.lstAccountWrapper.add(accwrapins);
sendmerobj.Submit();
sendmerobj.closePopup();
//sendmerobj.savepop();
//sendmerobj.cancel();

}
    
}