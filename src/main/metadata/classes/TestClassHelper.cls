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
}