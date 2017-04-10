@isTest
Public class PrintPDFcontrollerTest  {
    public static Lead__c objLead;
    public static Lead__c objLead1;
    public static Account objAccPer;
    public static Account objAccComp;
    public static Address__c CompanyAdd;
    public static Address__c PersonAdd;
    public static Task objTaskonLead;
    public static Vehicle__c testVehicleMB;
    public static Vehicle_Relationship__c testVR;
    
    public static Id AccCompRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    public static Id GeneralTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('General Task').getRecordTypeId();
    public static Id usrId;
    public static testMethod void GenerateTest()
    {
        init();
        //Start test
        Test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objLead.id);     
        ApexPages.StandardController objSc = new ApexPages.StandardController(objLead);
        PrintPDFcontroller  objLeadController = new PrintPDFcontroller(objSc);
        //Stop Test
        Test.stopTest();
        
    }
    // creating record for Case
    public static void init()
    {  
         usrId = UserInfo.getUserId();
        //Person Account creation with Address
        objAccPer = (Account)UtilTestData.createSobject(new Account(mobile__c='09865234152'),UtilConstant.person_Account); 
        
        PersonAdd = new Address__c(Customer__c=objAccPer.Id,Address_Type__c='Business',Province__c='Iwate',City__c='testCity1',District__c='testDist1',Company_Name__c='CompanyName');
         insert PersonAdd;
       //Company Account creation with Address  
        objAccComp = new Account(Name='TestComp',email__c='test@ntt.com',recordTypeId=AccCompRecordTypeId); 
        insert objAccComp;
        
        CompanyAdd = new Address__c(Customer__c=objAccComp.Id
                                   ,Address_Type__c='Home'
                                   ,Province__c='Aomori'
                                   ,City__c='testCity'
                                   ,District__c='testDist'
                                   ,Block__c='Block'
                                   ,Address_Line_1__c='Address Line 1'
                                   ,Address_Line_2__c='Address Line 2');
         insert CompanyAdd;
        
        
        //Lead creation relted to person and Company account 
       objLead= (Lead__C)UtilTestData.createSobject(new Lead__c(Lead_Type__c = 'New Car',CAC_Lead_Status__c='New'), UtilConstant.SALES_LEADS); 
       objLead.contact__c=objAccPer.id;
        objLead.Company_Account__c = objAccComp.Id;
        update  objLead; 
       
      //Task for Lead       
       objTaskonLead = new Task();
         objTaskonLead.Subject='Call';
         objTaskonLead.Intention_Status__c='Contact';
         objTaskonLead.WhatId= objLead.Id;
         objTaskonLead.RecordTypeId=GeneralTaskRecordTypeId;
         objTaskonLead.Status ='Open';
         objTaskonLead.OwnerId =usrId; 
       insert objTaskonLead; 
        
      //Vehicle Creation For creating VR
      testVehicleMB = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE
                                                                            ,EuroVIN__c = '12345678901111111'
                                                                            ,UsVIN__c = '12345678902222222'
                                                                            ,Brand__c ='Mercedes-Benz'
                                                                            ,FirstRegistrationDate__c = date.today()
                                                                            ,Purchase_Month__c ='02'
                                                                            ,Model__c = 'R350L 4MATIC'
                                                                            ,Class__c = 'A-Class'
                                                                            ,Purchase_Year__c = '2004'
                                                                            ,RegistrationNo__c = '12345'
                                                                            ,Range__c='Range'
                                                                            ,CurrentMileage__c = 15
                                                                            ,NextInspectionDate__c = System.today() + 60)
                                                             , UtilConstant.MB);
       testVR  =  new Vehicle_Relationship__c(Contact__c = objAccPer.Id
                                             ,Vehicle_ID__c = testVehicleMB.Id
                                             ,Car_Relation__c ='Purchaser'
                                             ,Validity__c = 'Yes'
                                             ,Registration_Date__c = System.today()
                                             ,MOT_USER_NAME__c= 'MOT User'
                                             ,Finance_Method__c= 'Loan');
        insert testVR;  
      
         
    }  
}