@isTest
Public class stouchPersonAndCompanySearchTest {
    Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
    public static Account dealer=new Account();
    public static Account_link__c alk=new Account_link__c();
    public static Account_link__c alk2=new Account_link__c();
    public static void createTestrecord(){
        Profile p=[select id from Profile where name='MBK Dealer HQ CS/ CR'];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c='KR',Individual_Home_Phone__c='010-9885-7857', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='12345');
        insert dealer;
        Contact dealerContact = new Contact(FirstName = 'Test',Md__c='KR', Lastname = 'Narendra', AccountId = dealer.Id, Email = 'test@test.com', Federation_ID__c='ab12345');
        insert dealerContact;
        User user = new User(LastName='Narendra',contactid=dealerContact.id,country='Korea',ProfileId=p.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='test@infosys.com',UserName='test@infosys.com.123',market__c='KR',FederationIdentifier='ab12345');
        insert user;
        Account cmp = new Account(Md__c='KR',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId(),Name = 'Mercedez',Allow_Data_Sharing__c='Yes',Mobile__c ='010-9885-7857', MBK_Data_Source__c='Mercedez',Owner=user, Commercial_Reg_No__c='1234' );
        Account cmp2 = new Account(Md__c='KR',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId(),Name = 'Mercedez',Allow_Data_Sharing__c='Yes',Mobile__c ='010-9885-7857', MBK_Data_Source__c='Mercedez',Owner=user, Commercial_Reg_No__c='1234' );
        Account accObj1 = new Account(Md__c='KR',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Mobile__c ='010-9885-7857', MBK_Data_Source__c='Mercedez');
        insert new List<Sobject>{cmp,cmp2,accobj1};
        alk= new Account_Link__c(Name='new al',Md__c='KR',toRole__c=cmp.id,fromrole__c=dealer.id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
                                 RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female',OwnerId=user.id);
        alk2= new Account_Link__c(Name='new al',Md__c='KR',toRole__c=cmp2.id,fromrole__c=dealer.id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
                                 RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female',OwnerId=user.id);
        
        Account_link__c alk3= new Account_Link__c(Name='new al',Md__c='KR',toRole__c=accobj1.id,fromrole__c=cmp.id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
                                 RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female',OwnerId=user.id);
        insert new List<Sobject>{alk,alk2,alk3};
       
    }
    @istest static void stouchCompanySearchTestMethod(){
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        user u=TestUtils.IntegrationAPIUser();
        u.UserRoleId=r.Id;
        update u;
        test.startTest();
        system.runas(u){
            createTestrecord();
            RestRequest request = new RestRequest();
            request.requestUri =
                'https://test.salesforce.com/services/apexrest/stouchPersonSearch/';
            request.httpMethod = 'POST';
            request.addHeader('Content-Type', 'application/json');
            
            request.requestBody = Blob.valueOf('{"Input_IDS":["'+alk.id+'","'+alk2.id+'"],"Rec_count":"1"}');
            RestContext.request = request;
            String jsonText=JSON.serialize(stouchCompanySearch.PersonSearchResult());
            Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonText);
            List<Object> list1=(List<Object>)(cObjMap.get('Out_CompanyDetails'));
            Map<String,Object> map1=(Map<String,Object>)list1[0];
            system.debug(map1);
            system.debug(map1.get('Company_Name__c'));
        }
        test.stopTest();
    }
    @istest static void PersonSearchResultTestMethod(){
        user u1=TestUtils.IntegrationAPIUser();
        Account_link__c akpl=new Account_link__c ( Name='new al',Md__c='KR',Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',OwnerId=u1.id);
        insert akpl;
       
        test.starttest();
        system.runas(u1){
            RestRequest request = new RestRequest();
            request.requestUri =
                'https://test.salesforce.com/services/apexrest/stouchPersonSearch/';
            request.httpMethod = 'POST';
            request.addHeader('Content-Type', 'application/json');
            
            request.requestBody = Blob.valueOf('{"Input_IDS":["'+akpl.id+'"],"Rec_count":"1"}');
            RestContext.request = request;
            stouchPersonSearch.PersonSearchResult();
        }
          test.stopTest();
    }  
     
}