@isTest
Public Class SubmitSurveyTakenTest
{
    public Static Survey__c survey {get;set;}
   
    public Static Account acc {get;set;}
    public Static Contact contact {get;set;}
    public Static Vehicle_Relationship__c VR {get;set;}
    Public static Task tk{get;set;}
    public static CampaignMember campMbr{get;set;}
    public static Campaign top1{get;set;}
    public static Campaign cac{get;set;}
    public static Campaign testCampaign1{get;set;}
    public static Contact con{get;set;}
    public static SurveyTaker__c st1{get;set;}
   // public static String DealerRecordtypeid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static Id VehicleMBRecordtypeid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
    Public static String VRRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();
    public static string topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
     public static String complex = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution - Complex').getRecordTypeId();
    public static String cacCampaign = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CAC Campaign').getRecordTypeId();
    public static String taskk = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Survey').getRecordTypeId();
    Public Static Void SubmitTestdata()
    {
        survey = new Survey__c(Name='Surveytest',MD__c = 'KR',Survey_Header__c='Test',Thank_You_Text__c='Test',Submit_Response__c='Response',Survey_Question_1__c='How is the car condition?',Survey_Question_3__c='How is the car condition?',Survey_Question_4__c='How is the car condition?',Survey_Question_2__c='anyfeedback',Survey_Response_Options_1__c='Free Text',Survey_Response_Options_2__c='Yes;No',Survey_Response_Options_3__c='Jaya',Survey_Response_Options_4__c='1;2;3;4;5;6;7;8;9',Survey_Response_Options_5__c='1;2;3;4;5;6;7;8;9',Survey_Response_Options_6__c='1;2;3;4;5;6;7;8;9',Survey_Response_Options_7__c='1;2;3;4;5;6;7;8;9',Survey_Response_Options_8__c='1;2;3;4;5;6;7;8;9',Survey_Response_Options_9__c='1;2;3;4;5;6;7;8;9',Survey_Response_Options_10__c='1;2;3;4;5;6;7;8;9',Survey_Response_Options_11__c='1;2;3;4;5;6;7;8;9',Survey_Response_Options_12__c='1;2;3;4;5;6;7;8;9',Survey_Response_Options_13__c='1;2;3;4;5;6;7;8;9',Survey_Response_Options_14__c='1;2;3;4;5;6;7;8;9',Survey_Response_Options_15__c='1;2;3;4;5;6;7;8;9',Selected_Questions_to_Display__c='1;2;3;4;5;6;7;8;9;10;11;12;13;14;15');
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
         Account dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(), Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_ND_Code__c='1234');
        insert dealer;
       Contact con = new Contact(AccountId = dealer.Id, LastName = 'b', Phone = '123', email = 's@s.s',Federation_ID__c='1234');
        insert con; 
          top1 = new Campaign(          
            Name = 'top', 
            Status = 'Started', 
            Type='Other',
            StartDate = System.today(), 
            EndDate = System.today()+1,
            RecordTypeId = topCampRecordTypeId,
            Campaign_Objectives__c='Test',
            Description='Test',
            MD__c = 'KR',Questionnaire__c = survey.id 
            
        );
        insert top1;
                    
          cac= new Campaign(           
            Name = 'topcac', 
            Status = 'Started', 
            Repeat_From__c = System.today(), 
            Repeat_End__c = System.today()+10,
            CAC_Frequency_Category__c ='Ad Hoc',
            RecordTypeId = cacCampaign,
            ParentId = top1.Id,
            MD__c = 'KR',Questionnaire__c = survey.id
        );
        insert cac;
        
           testCampaign1 = new Campaign(
            IsActive = true, 
            Name = 'Test Campaign Exe', 
            Task_Created_By__c = 'Contact',
            Execution_Type__c= 'OB call', 
            ParentId = cac.id,
            MD__c='KR',Questionnaire__c = survey.id,
            RecordTypeId = complex
        );
        insert testCampaign1;
        
          campMbr = new CampaignMember();
          campMbr.CampaignId = testCampaign1.Id;
          campMbr.Status = 'Send';
          campMbr.Task_Generated__c = true;
          campMbr.MD__c='KR';
          campMbr.Contactid=con.id;
          
          insert campMbr;
          st1=new SurveyTaker__c(Survey_Taking_Status__c = 'In Process',Survey_Taken_Date_Time__c = system.Now(),Survey__c=survey.id);
        insert st1;
        
        tk = new Task();
        tk.Status = 'Open';
        tk.Result__c= 'Solved';
        tk.WhatId = top1.id;
        tk.WhoId = con.id;
        tk.Priority='General';
        tk.RecordTypeId = taskk;
        tk.MD__c='KR';
        tk.Survey__c=survey.id;
        tk.Survey_Taken__c=st1.id;
        insert tk;
        
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
        string tskid;
            tskid=tk.id;
            PageReference pageRef = Page.SubmitSurveyKR;
            pageRef.getParameters().put('tskid',tk.Id);
           
            Test.setCurrentPage(pageRef); 
            
        ApexPages.StandardController objSc = new ApexPages.StandardController(st1);
        SubmitSuveryTaken st = new SubmitSuveryTaken(objSc);
         
        
        st.getsurveys();
        st.getsurvrid();
        st.Previous();
        st.getsurveys();
        st.saveandbre();
        st.Cancelreturn();
        test.stopTest();
    }  
}