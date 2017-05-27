@isTest 
private class   CustomerMymercInterfaceControllerTest{
    static testMethod void Invokemeth1(){
    Profile p = [select id,UserLicense.Name from profile where name='Partner Community User'];
    Account ac = new Account(name='TestAcc',phone='0123456789',Portal_Email__c='test@gmail.com',Email2__c = 'testemail2@test1.com') ;
        insert ac; 
       
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
        insert con;  
                  
        User user = new User(alias = 'test1234', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing123', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p.id, country='United States',IsActive =true,
                ContactId = con.Id,
                timezonesidkey='America/Los_Angeles', username='tester123@noemail.com');
       
        insert user;
        Account_Link__c acclinkobj = new Account_Link__c(toRole__c = ac.Id,System__c = 'My Mercedes',Primary__c = True,Portal_Email__c = 'Testporteal@test.com');
        insert acclinkobj;
        ApexPages.StandardController sc = new ApexPages.StandardController(ac);
        ApexPages.currentPage().getParameters().put('id', ac.Id);
CustomerMymercInterfaceController  custmerobj = new CustomerMymercInterfaceController(sc);
try{
System.runAs(user){
custmerobj.createContractSector();
}
custmerobj.createContractSector();
}catch(Exception e){}

        ApexPages.currentPage().getParameters().put('recordID', acclinkobj.Id);
custmerobj.closePopup();
custmerobj.showPopup();
custmerobj.savepop();
custmerobj.mymercnew();
custmerobj.saveAndReturn();



    
    }
}