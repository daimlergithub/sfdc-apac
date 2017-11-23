@isTest
public class stouchUtilForLeadandAccntLnkTest {
    Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
    public static String salesRecordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    public static Account dealer=new Account();
    public static Account_link__c alk=new Account_link__c();
    public static  Lead__c lead = new Lead__c();
    public static void createTestrecord(){
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c='KR',Individual_Home_Phone__c='010-9885-7857', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='12345');
        insert dealer;
        Account accObj1 = new Account(Md__c='KR',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Mobile__c ='010-9885-7857', MBK_Data_Source__c='Mercedez');
        insert accobj1;
        alk= new Account_Link__c(Name='new al',Md__c='KR',toRole__c=accobj1.id,fromrole__c=dealer.id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
        										RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
		insert alk;
        
        
        lead.Contact__c = accobj1.Id;
        lead.CAC_Lead_Status__c = 'Qualified';
        lead.Dealer_Lead_Status__c='Won';
        lead.Lead_Type__c = 'New Car';
        lead.Relation_With_The_Leads__c = 'testR';
        lead.Lead_Desired_Service__c = 'Trade-In';
        lead.Purchase_Time__c = '0 - 3 months';
        lead.Interested_Vehicle_Brand__c = 'testI';
        lead.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead.Trade_In_Vehicle_Brand__c = 'c230';
        lead.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead.Trade_In_Other_Vehicle_Model__c = 'testT';
        lead.Interested_Vehicle_Brand__c = 'Smart';
        lead.md__c='KR';
        lead.Received_Date_Time__c=system.today();
        lead.Accepted_Date_Time__c=system.today();
        lead.RecordTypeId=salesRecordTypeId;
        lead.Assigned_Dealer__c = dealer.id;
        lead.Retail_Contact__c=alk.id;
        insert lead;
    }
    @istest static void AccountLinkIfnoSendToAL(){
        user u1=TestUtils.IntegrationAPIUser();
        system.runas(u1){
            createTestrecord();
            Test.setMock(WebServiceMock.class, new WebServiceMockImplsar());
            RestRequest request = new RestRequest();
            request.requestUri =
                'https://test.salesforce.com/services/apexrest/stouchUtilForAccountLink/';
            request.httpMethod = 'POST';
            request.addHeader('Content-Type', 'application/json');
            
            request.requestBody = Blob.valueOf('{"data":{"RTCustomerId" : "'+alk.id+'","DealerID" : "'+lead.Assigned_Dealer__c+'","CorrelationId" : "'+lead.Retail_Contact__c+'"}}');
            RestContext.request = request;
            Map<String,String> res1 = stouchUtilForAccountLink.AccountLinkIfnoSendToAL();
            System.assertEquals(res1.get('Message') , system.Label.Web_service_callout_failed);
        }
    }
    @isTest static void LeadIfnoSendToALTestMethod(){
        user u1=TestUtils.IntegrationAPIUser();
        system.runas(u1){
            createTestrecord();
            RestRequest request = new RestRequest();
            request.requestUri =
                'https://test.salesforce.com/services/apexrest/stouchUtilForLead/';
            request.httpMethod = 'POST';
            request.addHeader('Content-Type', 'application/json');
            
            request.requestBody = Blob.valueOf('{"data":{"LeadId" : "'+lead.id+'","DealerID" : "'+lead.Assigned_Dealer__c+'","AccountLinkId" : "'+lead.Retail_Contact__c+'"}}');
            RestContext.request = request;
            Map<String,String> res1 = stouchUtilForLead.LeadIfnoSendToAL();
            lead.Dealer_Lead_Status__c='Lost';
            lead.Lost_To__c='Non Daimler Group';
            lead.Assigned_Dealer__c=null;
            update lead;
            Map<String,String> res2 = stouchUtilForLead.LeadIfnoSendToAL();
            System.assertEquals(res2.get('Message') , system.Label.This_Lead_cannot_be_send_to_Autoline);
            System.assertEquals(res1.get('Message') , system.Label.Web_service_callout_failed);
        }
    }
}