/*
    Type:      class
    Purpose:   Test class for AddressHelperJp
    Create By: Sriram kalluri
*/
@isTest
public class AddressHelperJPTest {
     private static Account account;
     private static Address__c address;
     private static User user1;
     private static  profile ProfileAdmin = [select Id from Profile where Name = 'System Administrator'];
     public static Map<Id,Address__c> newmap = new Map<Id,Address__c>();
     public static List<Address__c> addresslist =new List<Address__c>();
    
    public static testMethod void testUpdatePrimaryAddressOnAccount(){
       //create test data
        Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAddress',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
        upsert TriggerAddress;
        
        
        account= new Account();
        account.Phone='09844650654';
        account.FirstName = 'Test';        
        account.MBK_Data_Source__c ='Email';
        account.Data_Source__c  = 'Test4';
        account.Dealer_Rollout_Status__c = 'Done';
        account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account);        
        
      
        address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=account.id;
        address.TitleOfHonor__c = 'To Person'; 
         
            
        insert address;
        
        addresslist.add(address);
        newmap.putAll(addresslist);
        account.Primary_Address_Reference__c=address.id;
        update account;
        
         Account_Link__c al=new Account_Link__c(Name='new al',
          //toRole__c=account.id,
          fromRole__c=account.id,
          Retail_Address_Reference__c=addresslist[0].id,
         RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
      );
   
       insert al;
         //start test        
        test.startTest();
        address.Address_Type__c='Business';
        try{
         update address;}catch(Exception e){}
         delete address;
        test.stopTest();
        
        //verify
        account = [select Primary_Address_Display__c from Account where id =:address.Customer__c ];
        //system.assertEquals(account.Primary_Address_Display__c, address.Province__c+address.City__c+address.District__c+address.Block__c+address.Address_Line_1__c+address.Address_Line_2__c);
           
       }
         public static testMethod void testUpdatePrimaryAddressOnAccount1(){
         
        
       
        User u =[select id,name from user where profile.name='IntegrationAPI' limit 1];
        
        system.runas(u){
        Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAddress',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
        upsert TriggerAddress;
        
        account= new Account();
        account.Phone='09844650654';
        account.FirstName = 'Test';        
        account.MBK_Data_Source__c ='Email';
        account.Data_Source__c  = 'Test4';
        account.Dealer_Rollout_Status__c = 'Done';
        account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account);        
        
      
        address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=account.id;
        address.TitleOfHonor__c = 'To Person'; 
         
            
        insert address;
        
        addresslist.add(address);
        newmap.putAll(addresslist);
        account.Primary_Address_Reference__c=address.id;
        update account;
        
         Account_Link__c al=new Account_Link__c(Name='new al',
          //toRole__c=account.id,
          fromRole__c=account.id,
          Retail_Address_Reference__c=addresslist[0].id,
         RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
      );
   
       insert al;
         //start test        
        test.startTest();
        address.Address_Type__c='Business';
        try{
         update address;}catch(Exception e){}
         delete address;
        test.stopTest();
        
        //verify
        account = [select Primary_Address_Display__c from Account where id =:address.Customer__c ];
        //system.assertEquals(account.Primary_Address_Display__c, address.Province__c+address.City__c+address.District__c+address.Block__c+address.Address_Line_1__c+address.Address_Line_2__c);
          } 
       }
       
      
       
    }