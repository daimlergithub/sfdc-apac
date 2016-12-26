@isTest
public class ServiceRetailTaskTest
{
    public static Retail_Task__c Ser;
    public static Account accobj;
    static Testmethod void ValidateService()
        {
            accobj= new Account();
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
            
            Ser=new Retail_Task__c();
            Ser.Service_Total_Amount__c=10000;
            Ser.Service_Parts_Amount__c=2000;
            Ser.Service_Labour_Amount__c=2000;
            Ser.Service_Currency__c ='2000';
            Ser.Related_Contact__c=accobj.id;
            insert Ser;
                Test.StartTest();
                ApexPages.currentPage().getParameters().put('Id',Ser.id);
                ApexPages.StandardController controller = new ApexPages.StandardController(Ser);
                ServiceRetailtask s= new ServiceRetailTask(controller);
                Test.StopTest();
        }
}