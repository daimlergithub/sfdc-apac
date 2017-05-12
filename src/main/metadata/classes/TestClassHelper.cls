@isTest

public class TestClassHelper{
    public static lead__c CreateLeadRec(){
        lead__c ld = new Lead__c();
        return ld ;
    }
    
    public static Vehicle__c CreateVehicleRec(id recordTypeId){
        Vehicle__c vh = new Vehicle__c(RecordTypeId =recordTypeId );
        return vh;
    }
    
    public static Map<String,id> getRecordType(String ObjectName){
        Map<String,id> grpRt = new  Map<String,id> ();
        List<RecordType> rts = new List<RecordType>();
        rts = [Select Name, Id From RecordType where sObjectType=:ObjectName and isActive=true];
        for(RecordType rt:rts ){
            grpRt.put(rt.Name,rt.Id);
        }
        return grpRt;
    }
    
    public static Car_Model__c CreateCarModelRec(String Brand, String series, string model){
        Car_Model__c cm = new Car_Model__c(Brand__c= Brand,Name=Model,Series__c=series);
        return cm ;
    }
    
    public static Contact CreateContactRec(String LastName, String FirstName){
        Contact con = new Contact (LastName= LastName,FirstName=FirstName);
        return con ;
    }
    public static Account CreateAccRec(String Name){
        Account acc= new Account (LastName= Name);
        return acc;
    }
    public static User createUser(String lastName,Profile profileInsert,String Market){
        
        String user_Name = lastName + '@test.com';
        User newUser = new User(Alias = 'test', Email='test@testorg.com', 
                                EmailEncodingKey='UTF-8', LastName=lastName, LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = profileInsert.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName=user_Name,Market__c=Market);
        return newUser;
    }
    public static Account CreateAccount(String Md,string FirstName,String LastName){
        Account objAccount= new Account();
        objAccount.Dealer_DMS_SR_Code__c='test code 2';
        objAccount.Individual_Home_Phone__c = '000-00-000-964';
        objAccount.Home_Phone_2__c = '000-00-000-962';
        objAccount.Work_Phone__c = '000-00-000-942';
        objAccount.Status__c='NoCustomer';
        objAccount.Email__c = 'testemail@test.com';
        objAccount.Email2__c = 'testemail2@test.com';
        objAccount.Email3__c = 'testemail3@test.com';
        objAccount.City__c='Beijing';
        objAccount.Gender__c = 'Male';
        objAccount.Phone = '000-090-000-9661';
        objAccount.Mobile__c = '+66-03-777-9999';
        objAccount.Mobile2__c = '000-080-000-2644';
        objAccount.Area_code__c = '0101';
        objAccount.MD__c = Md;
        objAccount.LastName = LastName;
        objAccount.FirstName = FirstName;
        return objAccount;
    }
}