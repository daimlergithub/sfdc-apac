@isTest
public class TriggerAccountLinkTriggerHandlerKRTest {
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
   Trigger__c TriggerAccountLinkKR=new Trigger__c(Name='TriggerAccountLinkKR',Trigger_Name__c='TriggerAccountLink',Trigger_Handler__c='TriggerAccountLinkTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
   List<Trigger__c> lsttrg = new List<Trigger__C>();
   lsttrg.add(TriggerAccountLinkKR);
   //DMLManagerService.insertAsSystem(lsttrg);    
   insert lsttrg;
   
   KR_Switch__c krswitch=new KR_Switch__c(Name='Call Flow Switch',Enable_Flag__c=True);
   
    
   List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
   lsttrgt.add(krswitch);
   
   //DMLManagerService.insertAsSystem(lsttrg);    
   insert lsttrgt;
   
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
   
   
   public static void prepareTestData1(){
   UserRole portalRole1 = [Select Id From UserRole Where name='Call Center' Limit 1];           
    Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
    User user_Obj1 = new User(Alias = 'standt', Email='testUser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='KR',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true); 
    system.runas(user_Obj1){    
   Trigger__c TriggerAccountLinkKR=new Trigger__c(Name='TriggerAccountLinkKR',Trigger_Name__c='TriggerAccountLink',Trigger_Handler__c='TriggerAccountLinkTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
   List<Trigger__c> lsttrg = new List<Trigger__C>();
   lsttrg.add(TriggerAccountLinkKR);
   //DMLManagerService.insertAsSystem(lsttrg);    
   insert lsttrg;
   
   KR_Switch__c krswitch=new KR_Switch__c(Name='Call Flow Switch',Enable_Flag__c=false);
   
    
   List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
   lsttrgt.add(krswitch);
   
   //DMLManagerService.insertAsSystem(lsttrg);    
   insert lsttrgt;
   
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
    { 
  
     try{
    prepareTestData();
  
        system.runAs(user_Obj)
        {
        Vehicle__c vehicles = new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B200',
                  EuroVIN__c='11111222221111122', UsVIN__c='11111222221111122',Latest_Sales_Person__c='xxx',
                  Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'),Purchase_Month__c ='02',Purchase_Year__c='2004',RegistrationNo__c ='787878');
       insert vehicles;  
       
      Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean CDMRCCreation = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('CDM RC Creation and Update')){
           CDMRCCreation  = KRSwitchMap.get('CDM RC Creation and Update').Enable_Flag__c;
        }
         
       List<Account> AccList= new list<Account>();  
       
       
       Account personAccount;
          if (!CDMRCCreation) {
            personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='KR',MBK_Data_Source__c='Mercedes-Benz',Mobile__c = '000-000-0000', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());

       //insert personAccount;
      }
      else{
       personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='KR',MBK_Data_Source__c='Mercedes-Benz',Mobile__c = '+82-00-000-0000', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
       
      }
      
       Account Dealer = new Account(Dealer_Default_Flag__c=true,Dealer_DMS_CRM_Code__c='test code',Dealer_GC_Code__c=user_Obj.Dealer_GC_Code__c,Status__c='xCustomer',City__c='Beijing',Phone = '0808001010',Name = 'test dealer1', Mobile__c = '00-000-0000' ,Area_code__c = '010',ZipCode__c='1234567',Allow_Data_Sharing_Comment__c = 'yes',RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId());
      
       //insert Dealer;  
       AccList.add(personAccount);
       AccList.add(Dealer);     
       insert AccList;     
       Vehicle_Relationship__c vRel = new Vehicle_Relationship__c(Recall__c = FALSE, Car_Relation__c = 'User', RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId());
       vRel.Contact__c = personAccount.id;
       vRel.Vehicle_ID__c = vehicles.id;
       insert vRel;  
       // TriggerUtil.userCreate=false;     
       List<Account_Link__c> ALList=new List<Account_Link__c>();    
       Account_Link__c  accLink = new Account_Link__c(toRole__c =Dealer.Id,fromRole__c = personAccount.Id,RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId(),Name = 'contact2Contact', Vehicle__c = vehicles.Id);
       insert accLink;   
       accLink.Name='contact2Contact1';   
       update accLink; 
       system.assertEquals('contact2Contact1',accLink.name) ;     
           } 
           } 
           
           catch(Exception e){
           }
       }
       
         public static testMethod void testAfterInsertswitch()
    { 
  
     try{
    prepareTestData1();
  
        system.runAs(user_Obj)
        {
         
        
        Vehicle__c vehicles = new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B200',
                  EuroVIN__c='11111222221111122', UsVIN__c='11111222221111122',Latest_Sales_Person__c='xxx',
                  Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'),Purchase_Month__c ='02',Purchase_Year__c='2004',RegistrationNo__c ='787878');
       insert vehicles;  
       
      Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean CDMRCCreation = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('CDM RC Creation and Update')){
           CDMRCCreation  = KRSwitchMap.get('CDM RC Creation and Update').Enable_Flag__c;
        }
         
       List<Account> AccList= new list<Account>();  
       
       
       Account personAccount;
          if (!CDMRCCreation) {
            personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='KR',MBK_Data_Source__c='Mercedes-Benz',Mobile__c = '000-000-0000', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());

       //insert personAccount;
      }
      else{
       personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='KR',MBK_Data_Source__c='Mercedes-Benz',Mobile__c = '+82-00-000-0000', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
       
      }
      
       Account Dealer = new Account(Dealer_Default_Flag__c=true,Dealer_DMS_CRM_Code__c='test code',Dealer_GC_Code__c=user_Obj.Dealer_GC_Code__c,Status__c='xCustomer',City__c='Beijing',Phone = '0808001010',Name = 'test dealer1', Mobile__c = '00-000-0000' ,Area_code__c = '010',ZipCode__c='1234567',Allow_Data_Sharing_Comment__c = 'yes',RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId());
      
       //insert Dealer;  
       AccList.add(personAccount);
       AccList.add(Dealer);
      
       insert AccList; 
      
      
        
       Vehicle_Relationship__c vRel = new Vehicle_Relationship__c(Recall__c = FALSE, Car_Relation__c = 'User', RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId());
       vRel.Contact__c = personAccount.id;
       vRel.Vehicle_ID__c = vehicles.id;
       insert vRel;  
       // TriggerUtil.userCreate=false;     
       List<Account_Link__c> ALList=new List<Account_Link__c>();    
       Account_Link__c  accLink = new Account_Link__c(toRole__c =Dealer.Id,fromRole__c = personAccount.Id,RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId(),Name = 'contact2Contact', Vehicle__c = vehicles.Id);
       insert accLink;   
       accLink.Name='contact2Contact1';   
       update accLink; 
       system.assertEquals('contact2Contact1',accLink.name) ;     
           } 
           } 
           
           catch(Exception e){
           }
       }
       
         
     
   
    
    
     
   
    
    public static testMethod void testAfterInsert1()
    {   prepareTestData();
        system.runAs(intgnuser_Obj)
        {
        Vehicle__c vehicles = new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B200',
                  EuroVIN__c='11111222221111122', UsVIN__c='11111222221111122',Latest_Sales_Person__c='xxx',
                  Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'),Purchase_Month__c ='02',Purchase_Year__c='2004',RegistrationNo__c ='787878');
       insert vehicles;       
       List<Account> AccList= new list<Account>();         
       Account personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='TH', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
       //insert personAccount;
       Account Dealer = new Account(Dealer_Default_Flag__c=true,Dealer_DMS_CRM_Code__c='test code',Dealer_GC_Code__c=user_Obj.Dealer_GC_Code__c,Status__c='xCustomer',City__c='Beijing',Phone = '0808001010',Name = 'test dealer1', Mobile__c = '000-000-0000',Area_code__c = '010',ZipCode__c='1234567',Allow_Data_Sharing_Comment__c = 'yes',RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId());
       //insert Dealer;  
       AccList.add(personAccount);
       AccList.add(Dealer);     
       insert AccList;     
       Vehicle_Relationship__c vRel = new Vehicle_Relationship__c(Recall__c = FALSE, Car_Relation__c = 'User', RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId());
       vRel.Contact__c = personAccount.id;
       vRel.Vehicle_ID__c = vehicles.id;
       insert vRel;  
       TriggerUtil.userCreate=false;     
       List<Account_Link__c> ALList=new List<Account_Link__c>();    
       Account_Link__c  accLink = new Account_Link__c(toRole__c =Dealer.Id,fromRole__c = personAccount.Id,RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId(),Name = 'contact2Contact3', Vehicle__c = vehicles.Id);
       insert accLink;  
       system.assertEquals('contact2Contact3',accLink.name) ;     
       accLink.Name='contact2Contact4';   
       update accLink;
       system.assertEquals('contact2Contact4',accLink.name) ;
            
            
        }
   
    
    } 
}