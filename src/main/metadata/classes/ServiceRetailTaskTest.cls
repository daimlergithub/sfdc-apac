@isTest
private class ServiceRetailTaskTest{
public static Retail_Task__c RTobj;
public static Account accobj;
public static id acc;
private static Id PersonaccRTId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
private static Id ServiceId= Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Service').getRecordTypeId();

static testMethod void validateServiceRetailTask() {
init();
    
         test.startTest();
        acc= ApexPages.currentPage().getParameters().get('id');     
        ApexPages.StandardController objSc = new ApexPages.StandardController(accobj);
        ServiceRetailTask testacc = new ServiceRetailTask(objSc);
          test.stopTest();
       
    }
      public static void init()
    {    
        accobj= new Account();
        accobj.RecordtypeId=PersonaccRTId;
        accobj.Firstname='Test Person 1st';
        accobj.LastName='Test Person';
        accobj.salutation='Mr.';
        accobj.Type='Personal';
        accobj.Status__c='Active';
        accobj.Province__c='Province1';
        accobj.City__c='Test';
        accobj.Email__c='test@mbau.com';
        accobj.Email2__c = 'testemail2@test.com';
        accobj.Home_Phone_2__c = '098765413';    
        accobj.PersonMobilePhone ='8884545243';
        accobj.Partner_Surname__c='Test Person';
        
        insert accobj;
        
        RTobj=new Retail_Task__c();
         RTobj.RecordtypeId=ServiceId;
        RTobj.Service_Total_Amount__c=10000;
        RTobj.Service_Parts_Amount__c=2000;
        RTobj.Service_Labour_Amount__c=2000;
        RTobj.Service_Currency__c ='2000';
        RTobj.Related_Contact__c=accobj.id;
       
         insert RTobj;
}

}