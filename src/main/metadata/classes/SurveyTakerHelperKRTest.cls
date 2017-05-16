@isTest
public class SurveyTakerHelperKRTest 
{
    Public static Id retailPersonRectypeId = Schema.SObjectType.Account_Link__c.getRecordtypeInfosByName().get('Retail Person').getRecordTypeId();
    Public static Id personrectypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    Public static SurveyTaker__c surveytkr;
    Public static Account acc;
    public static Account dlrAcc;
    Public static Lead__c lead;
    Public static Account_Link__c retailcopy;
    public static Group accGrp;
    
    static testmethod void test_shareSurverTakertoDealer()
    {
        test.startTest();
        createTestData();
        test.stopTest();
    }
    
	static void createTestData()
    {
        Trigger__c TriggerSurveyTakerKR=new Trigger__c(Name='TriggerSurveyTakerKR',Trigger_Name__c='TriggerSurveyTaker',Trigger_Handler__c='TriggerSurveyTakerTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
        insert TriggerSurveyTakerKR;
        
        dlrAcc = (Account)UtilTestData.createSobject(new Account(mobile__c='010-6363-8383',Dealer_ND_Code__c = 'MBK0463'), UTilTestData.ACCOUNT_RT_DEALER); 
        
        accGrp = new group();
        accGrp.Name = dlrAcc.Dealer_ND_Code__c;
        insert accGrp;
        
        acc = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Area_code__c = '0101',
                               LastName = 'galaxy1',
                          	   MBK_Data_Source__c = 'Mercedes Call Catalogue',
                               FirstName = 'First Name',
                               Salutation = 'Unknown',
                               Mobile__c = '011-2833-1222',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               MD__c = 'KR',
                               Industry = 'Other',
                          	   ownerId = userinfo.getUserId(),
                               RecordTypeId = personrectypeId);
        insert acc;
        
        retailcopy = new Account_Link__c();
        retailcopy.RecordTypeId = retailPersonRectypeId;
        retailcopy.toRole__c = acc.id;
        retailcopy.fromRole__c = dlrAcc.Id;
        insert retailcopy;
        
        surveytkr = new SurveyTaker__c();
        surveytkr.Account__c = acc.id;
        insert surveytkr;
    }
}