@isTest
Public Class SubmitSurveyTakenTest
{
    public Static Survey__c survey {get;set;}
   
    public Static Account acc {get;set;}
    public Static Contact contact {get;set;}
    public Static Vehicle_Relationship__c VR {get;set;}
    
   // public static String DealerRecordtypeid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static Id VehicleMBRecordtypeid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
    Public static String VRRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();
    Public Static Void SubmitTestdata()
    {
        survey = new Survey__c(Name='Surveytest',Survey_Header__c='Test',Thank_You_Text__c='Test',Submit_Response__c='Response',Survey_Question_1__c='How is the car condition?',Survey_Question_2__c='anyfeedback',Selected_Questions_to_Display__c='1');
        insert survey;

         Account acc= new Account(Dealer_Default_Flag__c=false,
                           Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '000-0000-9642',Home_Phone_2__c = '000-0000-9642',Work_Phone__c = '000-0000-9642',
                           Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                           City__c='Beijing',
                           Gender__c = 'Male',
                           Phone = '000-0000-9642',
                           Area_code__c = '0101',
                           MD__c = 'KR',
                           LastName = 'galaxy1',
                           FirstName = 'First Name',
                           Salutation = 'Unknown',      
                           Province__c = 'Shanghai',
                           ZipCode__c= '1002347',
                           MBK_Data_Source__c='Email',
                           Mobile__c = '000-0000-9642',
                           Mobile2__c = '000-0000-9642',
                           Primary_Email__c = 'Email1',
                           Primary_Fax__c = 'FAX2',
                           Primary_Phone__c ='Other2',
                           RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
         insert acc;
        
      
        Vehicle__c vehicles = new Vehicle__c(RecordTypeId = VehicleMBRecordtypeid,Recall__c = FALSE,EuroVIN__c = '12345678901111111',UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',
        FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class',Competitor_Brand__c='Audi',Purchase_Year__c='2016',RegistrationNo__c='45878');
        insert vehicles;
        
        Vehicle_Relationship__c vr= new Vehicle_Relationship__c(RecordTypeId = VRRecordTypeId,Recall__c = FALSE, Car_Relation__c = 'User',Contact__c = acc.id,Vehicle_ID__c = vehicles.id);
        insert vr;
    }
     public static testMethod void testsurvey() 
     {
        SubmitTestdata();
        test.startTest();   
        SubmitSuveryTaken st = new SubmitSuveryTaken();
        st.surveyids=survey.id;
        st.getsurvrid();
        st.getsurveys();
        st.Previous();
        st.getsurveys();
        survey.Survey_Response_1__c='good';
        st.saveandbre();
        //st.Cancelreturn();
        test.stopTest();
    }  
}