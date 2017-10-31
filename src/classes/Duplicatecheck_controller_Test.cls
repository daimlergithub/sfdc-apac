@isTest 
private class   Duplicatecheck_controller_Test{
    static testMethod void Invokemeth(){
    
    Account ac = new Account(lastname='testlastname',phone='0123456789',Portal_Email__c='test@gmail.com',Email2__c = 'testemail2@test1.com') ;
        insert ac; 
       
       //crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse response1= new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse();
        ApexPages.StandardController sc = new ApexPages.StandardController(ac);
        ApexPages.currentPage().getParameters().put('id', ac.Id);
Duplicatecheck_controller  Duplicateobj = new Duplicatecheck_controller(sc);

//Duplicateobj.response.CustomerIdentificationResponseMessage.add(response1.CustomerIdentificationResponseMessage[0]);
}

}