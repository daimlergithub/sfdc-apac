@isTest
public class TriggerAddressTriggerHandlerKRTest {

   public static User user_Obj; 
   public static User intgnuser_Obj;
   public static void prepareTestData(){
   UserRole portalRole1 = [Select Id From UserRole Where name='Call Center' Limit 1];           
    Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
    User user_Obj1 = new User(Alias = 'standt', Email='testUser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='KR',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true); 
    system.runas(user_Obj1){    
   Trigger__c TriggerAddressKR=new Trigger__c(Name='TriggerAddressKR',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
   List<Trigger__c> lsttrg = new List<Trigger__C>();
   lsttrg.add(TriggerAddressKR);
   //DMLManagerService.insertAsSystem(lsttrg);    
   insert lsttrg;
   // UserRole portalRole1 = [Select Id From UserRole Where name='Call Center' Limit 1];           
   // Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
    user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='KR',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);   
    //DMLManagerService.insertAsSystem(user_Obj);   
    insert user_Obj;
    Profile p2 = [select id,name from profile WHERE Name='IntegrationAPI'];      
    intgnuser_Obj= new User(Alias = 'stawdt', Email='testUser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                          LocaleSidKey='en_US', ProfileId = p2.Id, Market__c='KR',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser21@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);   
    //DMLManagerService.insertAsSystem(user_Obj);   
    insert intgnuser_Obj;
        
    }    
   }    
   
       public static testMethod void testAfterInsert()
    {   prepareTestData();
        system.runAs(user_Obj)
        {
        
       List<Account> AccList= new list<Account>();         
          KR_Switch__c krswitch=new KR_Switch__c(Name='AccountHelperswitch',Enable_Flag__c=True);
   List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
   lsttrgt.add(krswitch);
   insert lsttrgt;
       Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
         
       Account personAccount;
       
         if (!KRSwitchEnabledFlag ) {       
        personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='TH', Individual_Home_Phone__c='000-000-000', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
        }
        else{
           personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='TH', Individual_Home_Phone__c='+82-51-1234-1234', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());

        }
       //insert personAccount;
       Account Dealer = new Account(Dealer_Default_Flag__c=true,Dealer_DMS_CRM_Code__c='test code',Dealer_GC_Code__c=user_Obj.Dealer_GC_Code__c,Status__c='xCustomer',City__c='Beijing',Phone = '0808001010',Name = 'test dealer1', Mobile__c = '000-000-0000',Area_code__c = '010',ZipCode__c='1234567',Allow_Data_Sharing_Comment__c = 'yes',RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId());
       //insert Dealer;  
       AccList.add(personAccount);
       AccList.add(Dealer);     
       insert AccList;     
       
        Address__c address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=personAccount.id;
        address.TitleOfHonor__c = 'To Person'; 
        address.Preferred__c = true;
        address.country__c = 'Korea';
        address.ZipCode__c = '12345';
        insert address;
        system.assertNotEquals(null, address.id);
        address.City__c='Hyderabad';
        update address;
        system.assertEquals('Hyderabad', address.City__c);    
        delete address;    
            
        }
    }
    public static testMethod void testAfterInsert1()
    {   prepareTestData();
        system.runAs(intgnuser_Obj)
        {
        
            
         //system.assertEquals('contact2Contact4',accLink.name) ;
            
            
        }
   
    
    }    
    
    
}