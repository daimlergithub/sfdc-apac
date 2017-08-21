@isTest
Public Class SubmitSurveyTakenTest
{
    public Static Survey__c survey {get;set;}
    public Static SurveyTaker__c staker {get;set;}
    public Static Account acc {get;set;}
    public Static Contact contact {get;set;}
    public Static Vehicle_Relationship__c VR {get;set;}
    public static String accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
	public static String DealerRecordtypeid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static string VehicleMBRecordtypeid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
    Public static String VRRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();
    Public Static Void SubmitTestdata()
    {
        survey = new Survey__c(Name='Surveytest',Survey_Header__c='Test',Thank_You_Text__c='Test',Submit_Response__c='Response',Survey_Question_1__c='How is the car condition?',Survey_Response_1__c = 'Good');
        insert survey;

        insert staker;
        Account acc = new Account(Dealer_Default_Flag__c=true,Dealer_DMS_SR_Code__c='Test_SR_Code1',City__c='Beijing',Phone = '080801010',Area_Code__c = '010',ZipCode__c='1003457',
        lastname = 'Beijing XING Limited',MBK_Data_Source__c='Advertisement',Mobile__c='0000000000',RecordTypeId = 'accPerson_RecordTypeId');
        insert acc;
        Contact contact = new Contact();
        contact.FirstName = 'a';
        contact.LastName = 'b';
        contact.Email = 'sysAdmin1@dialmer.com';
        contact.Phone = '1212313';
        contact.Title = 'contact title';
        contact.Name_English__c = 'c';
        contact.AccountId = acc.Id;
        insert contact;
        Vehicle__c vehicles = new Vehicle__c(RecordTypeId = 'VehicleMBRecordtypeid',Recall__c = FALSE,EuroVIN__c = '12345678901111111',UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',
        FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class',Competitor_Brand__c='Audi',Purchase_Year__c='2016',RegistrationNo__c='45878');
        insert vehicles;
        
        Vehicle_Relationship__c VR = new Vehicle_Relationship__c(RecordTypeId = 'VRRecordTypeId',Recall__c = FALSE, Car_Relation__c = 'User',Contact__c = acc.id,Vehicle_ID__c = vehicles.id);
        insert vr;
    }
     public static testMethod void testsurvey() 
     {
        test.startTest();   
        ApexPages.currentPage().getParameters().put('Id',staker.id);
        ApexPages.StandardController sur = new ApexPages.StandardController(staker);
        SubmitSuveryTaken surveytaker = new SubmitSuveryTaken(sur);
        PageReference pg = surveytaker.saveandbre();
        test.stopTest();
    }  
}