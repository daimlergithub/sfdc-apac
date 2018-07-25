@isTest
public class stouchPersonAndCompanyDetailsTest 
{
public static final Id retailPersonId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
public static final Id retailCompanyId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
public static final Id DealerId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
public static Account acc=new Account();
public static Account dealer=new Account();
public static Account_link__c alk=new Account_link__c();
public static Account_link__c alkcmp=new Account_link__c();
public static Address__c add=new Address__c ();
public static Lead__c ld=new Lead__c ();
public static date fromdate=date.valueOf('2017-11-23T10:56:01.000+0000');
public static date todate=date.valueOf('2017-11-24T10:56:01.000+0000');

 public static void createTestrecordforPersondetail(){      
     Profile p=[select id from Profile where name='IntegrationAPI'];
     Acc=new Account(ucid__c='KSP25487555l09',firstname='Stouch',lastname='person',mobile__c='010-5478-2365',md__c='KR',mbk_data_source__c='  Mercedes-Benz');
     dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c='KR',Individual_Home_Phone__c='010-9885-7857', RecordTypeId = dealerid, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='12345');
     User user = new User(LastName='Rajesh',country='Korea',ProfileId=p.Id,Alias='ain12342',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='test@infosys.com',UserName='test22@infosys.com',market__c='KR',FederationIdentifier='Dh54785');
     insert new List<Sobject>{acc,dealer,user};
     alk=new Account_link__c (toRole__c=acc.id,Name='new link',Md__c='KR',Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_UCID__c='KSP25487555l',recordtypeid=retailPersonId,ownerid=user.id);
     alkcmp=new Account_link__c (toRole__c=acc.id,Name='new test link',Md__c='KR',Retail_LastName__c='testing',Retail_Full_Name__c='Company Test',Retail_UCID__c='KSP76487555l',recordtypeid=retailCompanyId,ownerid=user.id);
     add=new Address__c(address_type__c='Home',Customer__c=acc.id);
     ld=new lead__c(contact__c=acc.id,Assigned_dealer__c=dealer.id,CAC_Lead_Status__c='Lost',Preferred_Contact_Time__c=date.today());
     insert new List<Sobject>{alk,alkcmp,add,ld};
  }
     public static void createTestrecordforPersondetailTh(){      
     Profile p=[select id from Profile where name='IntegrationAPI'];
     Acc=new Account(ucid__c='KSP25487555l08',firstname='Stouch',lastname='person',mobile__c='010-5478-2365',md__c='TH',mbk_data_source__c='  Mercedes-Benz');
     dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c='TH',Individual_Home_Phone__c='010-9885-7857', RecordTypeId = dealerid, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='12345');
     User user = new User(LastName='Rajesh',country='Thailand',ProfileId=p.Id,Alias='ain12342',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='test@infosys.com',UserName='test22@infosys.com',market__c='TH',FederationIdentifier='Dh54785');
     insert new List<Sobject>{acc,dealer,user};
     alk=new Account_link__c (toRole__c=acc.id,Name='new link',Md__c='TH',Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_UCID__c='KSP25487555l',recordtypeid=retailPersonId,ownerid=user.id);
     alkcmp=new Account_link__c (toRole__c=acc.id,Name='new test link',Md__c='TH',Retail_LastName__c='testing',Retail_Full_Name__c='Company Test',Retail_UCID__c='KSP76487555l',recordtypeid=retailCompanyId,ownerid=user.id);
     add=new Address__c(address_type__c='Home',Customer__c=acc.id);
     ld=new lead__c(contact__c=acc.id,Assigned_dealer__c=dealer.id,CAC_Lead_Status__c='Lost',Preferred_Contact_Time__c=date.today());
     insert new List<Sobject>{alk,alkcmp,add,ld};
  }
              
 @istest static void PersonSearchDetailsTestMethod(){
        user u1=TestUtils.IntegrationAPIUser();
        test.starttest();
        system.runas(u1)
        {
         createTestrecordforPersondetail();
          RestRequest request = new RestRequest();
            request.requestUri =
                'https://test.salesforce.com/services/apexrest/stouchPersonDetails/';
            request.httpMethod = 'POST';
            request.addHeader('Content-Type', 'application/json');
            request.requestBody = Blob.valueOf('{"Personal_UCID__c":"'+acc.UCID__c+'","fromDate":"'+fromdate+'","toDate":"'+todate+'"}');
            RestContext.request = request;
            stouchPersonDetails.getPersonDetails();
            ld.contact__c=null;
            update ld;
            stouchPersonDetails.getPersonDetails();
            request.requestBody = Blob.valueOf('{"Company_UCID__c":"'+acc.UCID__c+'","fromDate":"'+fromdate+'","toDate":"'+todate+'"}');
            stouchCompanyDetails.getPersonDetails();
        }
          test.stopTest();
    }
    @istest static void ThPersonSearchDetailsTestMethod(){
        user u1=TestUtils.IntegrationAPIUser();
        test.starttest();
        system.runas(u1)
        {
         createTestrecordforPersondetailTh();
          RestRequest request = new RestRequest();
            request.requestUri =
                'https://test.salesforce.com/services/apexrest/stouchPersonDetails/';
            request.httpMethod = 'POST';
            request.addHeader('Content-Type', 'application/json');
            request.requestBody = Blob.valueOf('{"Personal_UCID__c":"'+acc.UCID__c+'","fromDate":"'+fromdate+'","toDate":"'+todate+'","MD__c":"TH"}');
            RestContext.request = request;
            stouchPersonDetails.getPersonDetails();
            ld.contact__c=null;
            update ld;
            stouchPersonDetails.getPersonDetails();
            request.requestUri =
                'https://test.salesforce.com/services/apexrest/stouchCompanyDetails/';
            request.httpMethod = 'POST';
            request.addHeader('Content-Type', 'application/json');
            request.requestBody = Blob.valueOf('{"Company_UCID__c":"'+acc.UCID__c+'","fromDate":"'+fromdate+'","toDate":"'+todate+'","MD__c":"TH"}');
            RestContext.request = request;
            stouchCompanyDetails.getPersonDetails();
        }
          test.stopTest();
    }
  }