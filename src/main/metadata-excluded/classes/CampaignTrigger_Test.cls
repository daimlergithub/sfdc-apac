/*
    Type:       Test Class
    Purpose:    Test On Campaign Trigger Coding
    ---------------------------------------------------------------
    History:

    20-May-2013 Stephano Shi (Breakingpoint)    Created
    28-Sept-2013 Tony Li (Breakingpoint)    Modify

*/
@isTest(SeeAllData=false)
public class CampaignTrigger_Test{

    //TriggerCampaign Test Method
    static testMethod void runTriggerCampaign_Trigger(){
        
        /* START: Data Preparation: Cenral Campaign; CAC Campaign; Campaign Execution */
        // Campaign Record Type Id Search
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap_test = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> taskRecordTypeMap_test = Schema.SObjectType.Task.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> temRecordTypeMap_test = Schema.SObjectType.Template__c.getRecordTypeInfosByName();
        Id cca_RecordTypeId = cpRecordTypeMap_test.get('Central Marketing Campaign').getRecordTypeId();         // Central Campaign
        Id cac_RecordTypeId = cpRecordTypeMap_test.get('CAC Campaign').getRecordTypeId();                       // CAC Campaign
        Id caeCom_RecordTypeId = cpRecordTypeMap_test.get('Campaign Execution - Complex').getRecordTypeId();    // Campaign Execution - Complex
        Id caeSim_RecordTypeId = cpRecordTypeMap_test.get('Campaign Execution - Simple').getRecordTypeId();     // Campaign Execution - Simple
        Id smsTem_RecordTypeId = temRecordTypeMap_test.get('SMS').getRecordTypeId();
        Id edmTem_RecordTypeId = temRecordTypeMap_test.get('eDM').getRecordTypeId();
        
        
        // Central Campaign Inital
        Campaign TestData_CCA = new Campaign(Name='TestData_CCA_Campaign',
                                             Campaign_Code__c='Code_CCA',
                                             Type='Other',
                                             Campaign_Objectives__c='Objectives',
                                             Description='Description',
                                             Status='Confirmed',
                                             StartDate=date.newinstance(2013, 5, 17),
                                             EndDate=date.newinstance(2013, 10, 17),
                                             RecordTypeId=cca_RecordTypeId);
        // Database.insert(TestData_CCA);
        
        // CAC Campaign Inital
        Campaign TestData_CAC = new Campaign(Name='TestData_CAC_Campaign',
                                             Campaign_Code__c='Code_CAC',
                                             ParentId=TestData_CCA.Id,
                                             RecordTypeId=cac_RecordTypeId);
        // Database.insert(TestData_CAC);
        Database.insert(TestData_CCA);
        Database.insert(TestData_CAC);
        
        // Campaign Execution Inital
        // 1.Simple; OB Call; Contact
        Campaign TestData_CAE_OBC = new Campaign(Name='TestData_CAE_OB_SIM_C',
                                                Campaign_Code__c='code exe ob sim testc',
                                                Execution_Type__c='OB Call',
                                                Task_Created_By__c='Contact',
                                                ParentId=TestData_CAC.Id,
                                                RecordTypeId=caeSim_RecordTypeId);
        
        // SMS/eDM/DM Template
        Template__c tcSMS = new Template__c(Name='TEST CAMPAIGN TEMPLATE', RecordTypeId=smsTem_RecordTypeId, Active__c=True, Type__c='Price List', Car_Series__c='A-Class', Template_ID__c='a0lO0000000LOKq');
        Template__c tceDM = new Template__c(Name='TEST CAMPAIGN TEMPLATE', RecordTypeId=edmTem_RecordTypeId, Active__c=True, Type__c='Price List', Car_Series__c='A-Class', Template_ID__c='a0lO0000000LOKq');        
        DM_Material__c tcDM = new DM_Material__c(Name='TEST-CAMPAIGN-TEMPLATE',Type__c='Flyer');        
        insert tcDM;
        insert tcSMS;
        insert tceDM;
        
        // 2.Simple; SMS; Contact
        Campaign TestData_CAE_SMSC = new Campaign(Name='TestData_CAE_SMS_SIM_C',
                                                Campaign_Code__c='code exe sms sim testc',
                                                Execution_Type__c='SMS',
                                                Task_Created_By__c='Contact',
                                                ParentId=TestData_CAC.Id,
                                                RecordTypeId=caeSim_RecordTypeId,
                                                Template__c=tcSMS.Id);
        // 3.Simple; eDM; Contact 
        Campaign TestData_CAE_EDMC = new Campaign(Name='TestData_CAE_eDM_SIM_C',
                                                Campaign_Code__c='code exe edm sim testc',
                                                Execution_Type__c='eDM',
                                                Task_Created_By__c='Contact',
                                                ParentId=TestData_CAC.Id,
                                                RecordTypeId=caeSim_RecordTypeId,
                                                Template__c=tceDM.Id);
        // 4.Simple; DM; Contact 
        Campaign TestData_CAE_DMC = new Campaign(Name='TestData_CAE_DM_SIM_C',
                                                Campaign_Code__c='code exe em sim testc',
                                                Execution_Type__c='DM',
                                                Task_Created_By__c='Contact',
                                                ParentId=TestData_CAC.Id,
                                                RecordTypeId=caeSim_RecordTypeId,
                                                DM_Material__c=tcDM.Id);
        // 1.Simple; OB Call; Lead
        Campaign TestData_CAE_OBL = new Campaign(Name='TestData_CAE_OB_SIM_L',
                                                Campaign_Code__c='code exe ob sim testl',
                                                Execution_Type__c='OB Call',
                                                Task_Created_By__c='Lead',
                                                Parent=TestData_CAC,
                                                RecordTypeId=caeSim_RecordTypeId);
        // 2.Simple; SMS; Lead
        Campaign TestData_CAE_SMSL = new Campaign(Name='TestData_CAE_SMS_SIM_L',
                                                Campaign_Code__c='code exe sms sim testl',
                                                Execution_Type__c='SMS',
                                                Task_Created_By__c='Lead',
                                                ParentId=TestData_CAC.Id,
                                                RecordTypeId=caeSim_RecordTypeId,
                                                Template__c=tcSMS.Id);
        // 3.Simple; eDM; Lead 
        Campaign TestData_CAE_EDML = new Campaign(Name='TestData_CAE_eDM_SIM_L',
                                                Campaign_Code__c='code exe edm sim testl',
                                                Execution_Type__c='eDM',
                                                Task_Created_By__c='Lead',
                                                ParentId=TestData_CAC.Id,
                                                RecordTypeId=caeSim_RecordTypeId,
                                                Template__c=tceDM.Id);
        // 4.Simple; DM; Lead 
        Campaign TestData_CAE_DML = new Campaign(Name='TestData_CAE_DM_SIM_L',
                                                Campaign_Code__c='code exe em sim testl',
                                                Execution_Type__c='DM',
                                                Task_Created_By__c='Lead',
                                                ParentId=TestData_CAC.Id,
                                                RecordTypeId=caeSim_RecordTypeId,
                                                DM_Material__c=tcDM.Id);
        
        /* END: Data Preparation: Cenral Campaign; CAC Campaign; Campaign Execution */
        
        /* START: Execution Campaign Database Operation */
        // Insert All Campaigns Prepared Before.

        Database.insert(TestData_CAE_OBC);
        Database.insert(TestData_CAE_SMSC);
        Database.insert(TestData_CAE_EDMC);
        Database.insert(TestData_CAE_DMC);   
        Database.insert(TestData_CAE_OBL);
        Database.insert(TestData_CAE_SMSL);
        Database.insert(TestData_CAE_EDML);
        Database.insert(TestData_CAE_DML);
        System.debug('CAC ID >>>>>' + TestData_CAC.Id);
        System.debug('Parent ID >>>>>' + TestData_CAE_OBC.ParentId);
        /*
        // Testing Taks Generation When Campaign Execution is Activated.(For limitation that 5 Batchs could be excuted)
        Test.startTest();
        // Simple;OB;Contact
        TestData_CAE_OBC.Create_Task__c=true;
        Database.update(TestData_CAE_OBC);
        // Simple;SMS;Contact
        TestData_CAE_SMSC.Create_Task__c=true;
        Database.update(TestData_CAE_SMSC);
        // Simple;EDM;Contact
        TestData_CAE_EDMC.Create_Task__c=true;
        Database.update(TestData_CAE_EDMC);
        // Simple;DM;Contact
        TestData_CAE_DMC.Create_Task__c=true;
        Database.update(TestData_CAE_DMC);
        // Simple;OB;Lead
        TestData_CAE_OBL.Create_Task__c=true;
        Database.update(TestData_CAE_OBL);
        Test.stopTest();
        
        // Testing Taks Generation When Campaign Execution is Activated.(For other 3 type campaign exectuion)
        // Simple;SMS;Lead
        TestData_CAE_SMSL.Create_Task__c=true;
        Database.update(TestData_CAE_SMSL);
        // Simple;EDM;Lead
        TestData_CAE_EDML.Create_Task__c=true;
        Database.update(TestData_CAE_EDML);
        // Simple;DM;Lead
        TestData_CAE_DML.Create_Task__c=true;
        Database.update(TestData_CAE_DML);
        */ 
        
        // Testing Task Generation When CAC Campaign is Activated
        Test.startTest();
        TestData_CAC.IsActive=true;
        Database.update(TestData_CAC);
        Test.stopTest();
        /* END: Execution Campaign Database Operation */ 
    }
    
    //UtilCampaignTaskGenerationByAccount Test Method
    static testMethod void runUtilCampaignTaskGenerationByAccount_Class(){
                
        /* START: Data Preparation: Cenral Campaign; CAC Campaign; Campaign Execution */
        // Campaign Record Type Id Search
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap_test = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> taskRecordTypeMap_test = Schema.SObjectType.Task.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> accRecordTypeMap_test = Schema.SObjectType.Account.getRecordTypeInfosByName();
        Id cca_RecordTypeId = cpRecordTypeMap_test.get('Central Marketing Campaign').getRecordTypeId();         // Central Campaign
        Id cac_RecordTypeId = cpRecordTypeMap_test.get('CAC Campaign').getRecordTypeId();                       // CAC Campaign
        Id caeCom_RecordTypeId = cpRecordTypeMap_test.get('Campaign Execution - Complex').getRecordTypeId();    // Campaign Execution - Complex
        Id caeSim_RecordTypeId = cpRecordTypeMap_test.get('Campaign Execution - Simple').getRecordTypeId();     // Campaign Execution - Simple
        Id accPerson_RecordTypeId = accRecordTypeMap_test.get('Person Account').getRecordTypeId();     // Person Account.
        
        // Campaign Execution Inital
        // 1.Simple; OB Call; Contact
        Campaign TestData_CAE_OBC = new Campaign(Name='TestData_CAE_OB_SIM_C',
                                                Campaign_Code__c='code exe ob sim testc',
                                                Execution_Type__c='OB Call',
                                                Task_Created_By__c='Contact',
                                                RecordTypeId=caeSim_RecordTypeId);
    // SMS Template
         Map<String, Schema.RecordTypeInfo> temRecordTypeMap_test = Schema.SObjectType.Template__c.getRecordTypeInfosByName();
        Id smsTem_RecordTypeId = temRecordTypeMap_test.get('SMS').getRecordTypeId();
        Id edmTem_RecordTypeId = temRecordTypeMap_test.get('eDM').getRecordTypeId();
        Template__c tcSMS = new Template__c(Name='TEST CAMPAIGN TEMPLATE', RecordTypeId=smsTem_RecordTypeId, Active__c=True, Type__c='Price List', Car_Series__c='A-Class', Template_ID__c='a0lO0000000LOKq');
        Template__c tceDM = new Template__c(Name='TEST CAMPAIGN TEMPLATE', RecordTypeId=edmTem_RecordTypeId, Active__c=True, Type__c='Price List', Car_Series__c='A-Class', Template_ID__c='a0lO0000000LOKq');        
        DM_Material__c tcDM = new DM_Material__c(Name='TEST-CAMPAIGN-TEMPLATE',Type__c='Flyer');        
        insert tcDM;
        insert tcSMS;
        insert tceDM;
        
        // 2.Simple; SMS; Contact
        Campaign TestData_CAE_SMSC = new Campaign(Name='TestData_CAE_SMS_SIM_C',
                                                Campaign_Code__c='code exe sms sim testc',
                                                Execution_Type__c='SMS',
                                                Task_Created_By__c='Contact',
                                                RecordTypeId=caeSim_RecordTypeId,
                                                Template__c=tcSMS.Id);
        // 3.Simple; eDM; Contact 
        Campaign TestData_CAE_EDMC = new Campaign(Name='TestData_CAE_eDM_SIM_C',
                                                Campaign_Code__c='code exe edm sim testc',
                                                Execution_Type__c='eDM',
                                                Task_Created_By__c='Contact',
                                                RecordTypeId=caeSim_RecordTypeId,
                                                Template__c=tceDM.Id);
        // 4.Simple; DM; Contact 
        Campaign TestData_CAE_DMC = new Campaign(Name='TestData_CAE_DM_SIM_C',
                                                Campaign_Code__c='code exe em sim testc',
                                                Execution_Type__c='DM',
                                                Task_Created_By__c='Contact',
                                                RecordTypeId=caeSim_RecordTypeId,
                                                DM_Material__c=tcDM.Id);
        
        insert(TestData_CAE_OBC);
        insert(TestData_CAE_SMSC);
        insert(TestData_CAE_EDMC);
        insert(TestData_CAE_DMC);
        
        // Contact 
        Account testPerAcc = new Account(LastName='TEST ACC',
                                      Type='Company',
                                      Status__c='VIP',
                                      Province__c='Shanghai',
                                      City_CN__c='宝山区',
                                      ZipCode__c='123456',
                                      PersonMobilePhone='12345678910',
                                      RecordTypeId=accPerson_RecordTypeId
                                     );
        
        Contact testPerCon = new Contact(LastName='TEST ACC',
                                         AccountId = testPerAcc.Id,
                                         email = '11@11.com',
                                         Phone='12345678910');
        insert(testPerAcc);
        insert(testPerCon);                                 

        
        // Campaign Member Initial
        CampaignMember cm1 = new CampaignMember(CampaignId = TestData_CAE_OBC.Id,
                                                Status ='Sent',
                                                ContactId = testPerCon.Id
                                                );
        CampaignMember cm2 = new CampaignMember(CampaignId = TestData_CAE_SMSC.Id,
                                                Status ='Sent',
                                                ContactId = testPerCon.Id
                                                );
        CampaignMember cm3 = new CampaignMember(CampaignId = TestData_CAE_EDMC.Id,
                                                Status ='Sent',
                                                ContactId = testPerCon.Id
                                                );
        CampaignMember cm4 = new CampaignMember(CampaignId = TestData_CAE_DMC.Id,
                                                Status ='Sent',
                                                ContactId = testPerCon.Id
                                                );        
        insert(cm1);
        insert(cm2);
        insert(cm3);
        insert(cm4);        
        
        List<Campaign> cpAccList = new List<Campaign>();
        cpAccList.add(TestData_CAE_OBC);
        cpAccList.add(TestData_CAE_SMSC);
        cpAccList.add(TestData_CAE_EDMC);
        cpAccList.add(TestData_CAE_DMC);
        Test.startTest();
        //Batch_Job__c ba = new Batch_Job__c(Batch_Type__c='Contact');
        TestData_CAE_OBC.Create_Task__c = true;
        TestData_CAE_SMSC.Create_Task__c = true;
        TestData_CAE_EDMC.Create_Task__c = true;
        TestData_CAE_DMC.Create_Task__c = true;
        update TestData_CAE_OBC;
        update TestData_CAE_SMSC;
        update TestData_CAE_EDMC;
        update TestData_CAE_DMC;
        //database.executeBatch(new UtilCampaignTaskGenerationByAccount(cpAccList), 200);
        Test.stopTest();
    }
    
    //runUtilCampaignTaskGenerationByVehicle_Class Test Method
    static testMethod void runUtilCampaignTaskGenerationByVehicle_Class(){
                
        /* START: Data Preparation: Cenral Campaign; CAC Campaign; Campaign Execution */
        // Campaign Record Type Id Search
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap_test = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> taskRecordTypeMap_test = Schema.SObjectType.Task.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> accRecordTypeMap_test = Schema.SObjectType.Account.getRecordTypeInfosByName();
        Id cca_RecordTypeId = cpRecordTypeMap_test.get('Central Marketing Campaign').getRecordTypeId();         // Central Campaign
        Id cac_RecordTypeId = cpRecordTypeMap_test.get('CAC Campaign').getRecordTypeId();                       // CAC Campaign
        Id caeCom_RecordTypeId = cpRecordTypeMap_test.get('Campaign Execution - Complex').getRecordTypeId();    // Campaign Execution - Complex
        Id caeSim_RecordTypeId = cpRecordTypeMap_test.get('Campaign Execution - Simple').getRecordTypeId();     // Campaign Execution - Simple
        Id accPerson_RecordTypeId = accRecordTypeMap_test.get('Person Account').getRecordTypeId();     // Person Account.
        
        // Campaign Execution Inital
        // 1.Simple; OB Call; Vehicle
        Campaign TestData_CAE_OBC = new Campaign(Name='TestData_CAE_OB_SIM_C',
                                                Campaign_Code__c='code exe ob sim testc',
                                                Execution_Type__c='OB Call',
                                                Task_Created_By__c='Vehicle',
                                                RecordTypeId=caeSim_RecordTypeId);
    // SMS Template
         Map<String, Schema.RecordTypeInfo> temRecordTypeMap_test = Schema.SObjectType.Template__c.getRecordTypeInfosByName();
        Id smsTem_RecordTypeId = temRecordTypeMap_test.get('SMS').getRecordTypeId();
        Id edmTem_RecordTypeId = temRecordTypeMap_test.get('eDM').getRecordTypeId();
        Template__c tcSMS = new Template__c(Name='TEST CAMPAIGN TEMPLATE', RecordTypeId=smsTem_RecordTypeId, Active__c=True, Type__c='Price List', Car_Series__c='A-Class', Template_ID__c='a0lO0000000LOKq');
        Template__c tceDM = new Template__c(Name='TEST CAMPAIGN TEMPLATE', RecordTypeId=edmTem_RecordTypeId, Active__c=True, Type__c='Price List', Car_Series__c='A-Class', Template_ID__c='a0lO0000000LOKq');        
        DM_Material__c tcDM = new DM_Material__c(Name='TEST-CAMPAIGN-TEMPLATE',Type__c='Flyer');        
        insert tcDM;
        insert tcSMS;
        insert tceDM;
        
        // 2.Simple; SMS; Vehicle
        Campaign TestData_CAE_SMSC = new Campaign(Name='TestData_CAE_SMS_SIM_C',
                                                Campaign_Code__c='code exe sms sim testc',
                                                Execution_Type__c='SMS',
                                                Task_Created_By__c='Vehicle',
                                                RecordTypeId=caeSim_RecordTypeId,
                                                Template__c=tcSMS.Id);
        // 3.Simple; eDM; Vehicle 
        Campaign TestData_CAE_EDMC = new Campaign(Name='TestData_CAE_eDM_SIM_C',
                                                Campaign_Code__c='code exe edm sim testc',
                                                Execution_Type__c='eDM',
                                                Task_Created_By__c='Vehicle',
                                                RecordTypeId=caeSim_RecordTypeId,
                                                Template__c=tceDM.Id);
        // 4.Simple; DM; Vehicle 
        Campaign TestData_CAE_DMC = new Campaign(Name='TestData_CAE_DM_SIM_C',
                                                Campaign_Code__c='code exe em sim testc',
                                                Execution_Type__c='DM',
                                                Task_Created_By__c='Vehicle',
                                                RecordTypeId=caeSim_RecordTypeId,
                                                DM_Material__c=tcDM.Id);
        
        insert(TestData_CAE_OBC);
        insert(TestData_CAE_SMSC);
        insert(TestData_CAE_EDMC);
        insert(TestData_CAE_DMC);
        
        // Contact 
        Account testPerAcc = new Account(LastName='TEST ACC',
                                      Type='Company',
                                      Status__c='VIP',
                                      Province__c='Shanghai',
                                      City_CN__c='宝山区',
                                      ZipCode__c='123456',
                                      PersonMobilePhone='12345678910',
                                      RecordTypeId=accPerson_RecordTypeId
                                     );
        
        Contact testPerCon = new Contact(LastName='TEST ACC',
                                         AccountId = testPerAcc.Id,
                                         email = '11@11.com',
                                         Phone='12345678910');
        insert(testPerAcc);
        insert(testPerCon);        
        
        // Vehicle
        Vehicle__c vc1 = new Vehicle__c(Brand__c='Smart',
                                        Class__c='A-Class',
                                        Model__c='A160',
                                        EuroVIN__c ='11111222221111122',
                                        UsVIN__c='11111222221111122');
        
        Vehicle__c vc2 = new Vehicle__c(Brand__c='AMG',
                                        Class__c='S-Class',
                                        Model__c='BENZ',
                                        EuroVIN__c ='11111222221111122',
                                        UsVIN__c='11111222221111122');
        
        // Vehicle Relationship
        Vehicle_Relationship__c vr1 = new Vehicle_Relationship__c(Contact__c=testPerAcc.Id,
                                                                 Vehicle_ID__c=vc1.Id,
                                                                 Car_Relation__c='user');
        
        Vehicle_Relationship__c vr2 = new Vehicle_Relationship__c(Contact__c=testPerAcc.Id,
                                                                 Vehicle_ID__c=vc2.Id,
                                                                 Car_Relation__c='user');
        insert(vc1);
        insert(vc2);
        insert(vr1);
        insert(vr2);
        
        // Campaign Member Initial
        CampaignMember cm1 = new CampaignMember(CampaignId = TestData_CAE_OBC.Id,
                                                Status ='Sent',
                                                Vehicle_Case_ID__c = vr1.Id+';'+vr2.Id,
                                                ContactId = testPerCon.Id
                                                );
        CampaignMember cm2 = new CampaignMember(CampaignId = TestData_CAE_SMSC.Id,
                                                Status ='Sent',
                                                Vehicle_Case_ID__c=vr1.Id+';'+vr2.Id,                                                
                                                ContactId = testPerCon.Id
                                                );
        CampaignMember cm3 = new CampaignMember(CampaignId = TestData_CAE_EDMC.Id,
                                                Status ='Sent',
                                                Vehicle_Case_ID__c=vr1.Id+';'+vr2.Id,
                                                ContactId = testPerCon.Id
                                                );
        CampaignMember cm4 = new CampaignMember(CampaignId = TestData_CAE_DMC.Id,
                                                Status ='Sent',
                                                Vehicle_Case_ID__c=vr1.Id+';'+vr2.Id,
                                                ContactId = testPerCon.Id
                                                );        
        insert(cm1);
        insert(cm2);
        insert(cm3);
        insert(cm4);        
        
        List<Campaign> cpVehList = new List<Campaign>();
        cpVehList.add(TestData_CAE_OBC);
        cpVehList.add(TestData_CAE_SMSC);
        cpVehList.add(TestData_CAE_EDMC);
        cpVehList.add(TestData_CAE_DMC);
        Test.startTest();
        TestData_CAE_OBC.Create_Task__c=true;
        TestData_CAE_SMSC.Create_Task__c=true;
        TestData_CAE_EDMC.Create_Task__c=true;
        TestData_CAE_DMC.Create_Task__c=true;
        update TestData_CAE_OBC;
        update TestData_CAE_SMSC;
        update TestData_CAE_EDMC;
        update TestData_CAE_DMC;
        //update cpVehList;
        //database.executeBatch(new UtilCampaignTaskGenerationByVehicle(cpVehList), 200);
        Test.stopTest();
    }
    
    static testMethod void runUtilCampaignTaskGenerationOBSMSByCase_Class(){
                
        /* START: Data Preparation: Cenral Campaign; CAC Campaign; Campaign Execution */
        // Campaign Record Type Id Search
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap_test = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> taskRecordTypeMap_test = Schema.SObjectType.Task.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> accRecordTypeMap_test = Schema.SObjectType.Account.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> caseRecordTypeMap_test = Schema.SObjectType.Case.getRecordTypeInfosByName();
        Id cca_RecordTypeId = cpRecordTypeMap_test.get('Central Marketing Campaign').getRecordTypeId();         // Central Campaign
        Id cac_RecordTypeId = cpRecordTypeMap_test.get('CAC Campaign').getRecordTypeId();                       // CAC Campaign
        Id caeCom_RecordTypeId = cpRecordTypeMap_test.get('Campaign Execution - Complex').getRecordTypeId();    // Campaign Execution - Complex
        Id caeSim_RecordTypeId = cpRecordTypeMap_test.get('Campaign Execution - Simple').getRecordTypeId();     // Campaign Execution - Simple
        Id accPerson_RecordTypeId = accRecordTypeMap_test.get('Person Account').getRecordTypeId();     // Person Account.
        Id case_RecordTypeId = caseRecordTypeMap_test.get('Inquiry').getRecordTypeId();     // Case.
        
        // Campaign Execution Inital
        // 1.Simple; OB Call; Case
        Campaign TestData_CAE_OBC = new Campaign(Name='TestData_CAE_OB_SIM_C',
                                                Campaign_Code__c='code exe ob sim testc',
                                                Execution_Type__c='OB Call',
                                                Task_Created_By__c='Case',
                                                RecordTypeId=caeSim_RecordTypeId);
        // SMS Template
        Map<String, Schema.RecordTypeInfo> temRecordTypeMap_test = Schema.SObjectType.Template__c.getRecordTypeInfosByName();
        Id smsTem_RecordTypeId = temRecordTypeMap_test.get('SMS').getRecordTypeId();
        Template__c tcSMS = new Template__c(Name='TEST CAMPAIGN TEMPLATE', RecordTypeId=smsTem_RecordTypeId, Active__c=True, Type__c='Price List', Car_Series__c='A-Class', Template_ID__c='a0lO0000000LOKq');
        insert tcSMS ;
        
        // 2.Simple; SMS; Case
        Campaign TestData_CAE_SMSC = new Campaign(Name='TestData_CAE_SMS_SIM_C',
                                                Campaign_Code__c='code exe sms sim testc',
                                                Execution_Type__c='SMS',
                                                Task_Created_By__c='Case',
                                                RecordTypeId=caeSim_RecordTypeId,
                                                Template__c=tcSMS.Id);
        
        insert(TestData_CAE_OBC);
        insert(TestData_CAE_SMSC);
        
        // Contact 
        Account testPerAcc = new Account(LastName='TEST ACC',
                                      Type='Company',
                                      Status__c='VIP',
                                      Province__c='Shanghai',
                                      City_CN__c='宝山区',
                                      ZipCode__c='123456',
                                      PersonMobilePhone='12345678910',
                                      RecordTypeId=accPerson_RecordTypeId
                                     );
        
        Contact testPerCon = new Contact(LastName='TEST ACC',
                                         AccountId = testPerAcc.Id,
                                         email = '11@11.com',
                                         Phone='12345678910');
        insert(testPerAcc);
        insert(testPerCon);        
        
        // Case
        Case case1 = new Case(RecordTypeId=case_RecordTypeId,
                            AccountId=testPerAcc.Id,
                            Case_Class__c='Pre-Sales',
                            Case_Type__c='Dealer contact method',
                            Case_SubType__c='Dealership Contacts',
                            Status='Open');
                            
        Case case2 = new Case(RecordTypeId=case_RecordTypeId,
                            AccountId=testPerAcc.Id,
                            Case_Class__c='After-Sales',
                            Case_Type__c='Finance & Insurance',
                            Case_SubType__c='Finance & Insurance',
                            Status='Open');
                            
        insert(case1);
        insert(case2);
        
        // Campaign Member Initial
        CampaignMember cm1 = new CampaignMember(CampaignId = TestData_CAE_OBC.Id,
                                                Status ='Sent',
                                                Vehicle_Case_ID__c=case1.Id+';'+case2.Id,
                                                ContactId = testPerCon.Id
                                                );
        CampaignMember cm2 = new CampaignMember(CampaignId = TestData_CAE_SMSC.Id,
                                                Status ='Sent',
                                                Vehicle_Case_ID__c=case1.Id+';'+case2.Id,                                                
                                                ContactId = testPerCon.Id
                                                );
        insert(cm1);
        insert(cm2);      
        
        List<Campaign> cpCaseList = new List<Campaign>();
        cpCaseList.add(TestData_CAE_OBC);
        cpCaseList.add(TestData_CAE_SMSC);
        Test.startTest();
        TestData_CAE_OBC.Create_Task__c=true;
        TestData_CAE_SMSC.Create_Task__c=true;
        update TestData_CAE_OBC;
        update TestData_CAE_SMSC;
        //update cpCaseList;
        //database.executeBatch(new UtilCampaignTaskGenerationByCase(cpCaseList), 200);
        Test.stopTest();
    }
    
        static testMethod void runUtilCampaignTaskDMeDMGenerationByCase_Class(){
                
        /* START: Data Preparation: Cenral Campaign; CAC Campaign; Campaign Execution */
        // Campaign Record Type Id Search
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap_test = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> taskRecordTypeMap_test = Schema.SObjectType.Task.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> accRecordTypeMap_test = Schema.SObjectType.Account.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> caseRecordTypeMap_test = Schema.SObjectType.Case.getRecordTypeInfosByName();
        Id cca_RecordTypeId = cpRecordTypeMap_test.get('Central Marketing Campaign').getRecordTypeId();         // Central Campaign
        Id cac_RecordTypeId = cpRecordTypeMap_test.get('CAC Campaign').getRecordTypeId();                       // CAC Campaign
        Id caeCom_RecordTypeId = cpRecordTypeMap_test.get('Campaign Execution - Complex').getRecordTypeId();    // Campaign Execution - Complex
        Id caeSim_RecordTypeId = cpRecordTypeMap_test.get('Campaign Execution - Simple').getRecordTypeId();     // Campaign Execution - Simple
        Id accPerson_RecordTypeId = accRecordTypeMap_test.get('Person Account').getRecordTypeId();     // Person Account.
        Id case_RecordTypeId = caseRecordTypeMap_test.get('Inquiry').getRecordTypeId();     // Case.
        
        // Campaign Execution Inital
        // 1.Simple; OB Call; Case
        // SMS Template
        Map<String, Schema.RecordTypeInfo> temRecordTypeMap_test = Schema.SObjectType.Template__c.getRecordTypeInfosByName();
        Id smsTem_RecordTypeId = temRecordTypeMap_test.get('SMS').getRecordTypeId();
        Id edmTem_RecordTypeId = temRecordTypeMap_test.get('eDM').getRecordTypeId();
        Template__c tceDM = new Template__c(Name='TEST CAMPAIGN TEMPLATE', RecordTypeId=edmTem_RecordTypeId, Active__c=True, Type__c='Price List', Car_Series__c='A-Class', Template_ID__c='a0lO0000000LOKq');        
        DM_Material__c tcDM = new DM_Material__c(Name='TEST-CAMPAIGN-TEMPLATE',Type__c='Flyer');        
        insert tcDM;
        insert tceDM;
        
        // 3.Simple; eDM; Case 
        Campaign TestData_CAE_EDMC = new Campaign(Name='TestData_CAE_eDM_SIM_C',
                                                Campaign_Code__c='code exe edm sim testc',
                                                Execution_Type__c='eDM',
                                                Task_Created_By__c='Case',
                                                RecordTypeId=caeSim_RecordTypeId,
                                                Template__c=tceDM.Id);
        // 4.Simple; DM; Case 
        Campaign TestData_CAE_DMC = new Campaign(Name='TestData_CAE_DM_SIM_C',
                                                Campaign_Code__c='code exe em sim testc',
                                                Execution_Type__c='DM',
                                                Task_Created_By__c='Case',
                                                RecordTypeId=caeSim_RecordTypeId,
                                                DM_Material__c=tcDM.Id);
        
        insert(TestData_CAE_EDMC);
        insert(TestData_CAE_DMC);
        
        // Contact 
        Account testPerAcc = new Account(LastName='TEST ACC',
                                      Type='Company',
                                      Status__c='VIP',
                                      Province__c='Shanghai',
                                      City_CN__c='宝山区',
                                      ZipCode__c='123456',
                                      PersonMobilePhone='12345678910',
                                      RecordTypeId=accPerson_RecordTypeId
                                     );
        
        Contact testPerCon = new Contact(LastName='TEST ACC',
                                         AccountId = testPerAcc.Id,
                                         email = '11@11.com',
                                         Phone='12345678910');
        insert(testPerAcc);
        insert(testPerCon);        
        
        // Case
        Case case1 = new Case(RecordTypeId=case_RecordTypeId,
                            AccountId=testPerAcc.Id,
                            Case_Class__c='Pre-Sales',
                            Case_Type__c='Dealer contact method',
                            Case_SubType__c='Dealership Contacts',
                            Status='Open');
                            
        Case case2 = new Case(RecordTypeId=case_RecordTypeId,
                            AccountId=testPerAcc.Id,
                            Case_Class__c='After-Sales',
                            Case_Type__c='Finance & Insurance',
                            Case_SubType__c='Finance & Insurance',
                            Status='Open');
                            
        insert(case1);
        insert(case2);
        
        // Campaign Member Initial
        CampaignMember cm3 = new CampaignMember(CampaignId = TestData_CAE_EDMC.Id,
                                                Status ='Sent',
                                                Vehicle_Case_ID__c=case1.Id+';'+case2.Id,
                                                ContactId = testPerCon.Id
                                                );
        CampaignMember cm4 = new CampaignMember(CampaignId = TestData_CAE_DMC.Id,
                                                Status ='Sent',
                                                Vehicle_Case_ID__c=case1.Id+';'+case2.Id,
                                                ContactId = testPerCon.Id
                                                );        
        insert(cm3);
        insert(cm4);        
        
        List<Campaign> cpCaseList = new List<Campaign>();
        cpCaseList.add(TestData_CAE_EDMC);
        cpCaseList.add(TestData_CAE_DMC);
        Test.startTest();
        TestData_CAE_EDMC.Create_Task__c=true;
        TestData_CAE_DMC.Create_Task__c=true;
        update TestData_CAE_EDMC;
        update TestData_CAE_DMC;
        //update cpCaseList;
        //database.executeBatch(new UtilCampaignTaskGenerationByCase(cpCaseList), 200);
        Test.stopTest();
    }
    
        //UtilCampaignTaskGenerationByLeads Test Method
    static testMethod void runUtilCampaignTaskOBSMSGenerationByLeads_Class(){
                
        /* START: Data Preparation: Cenral Campaign; CAC Campaign; Campaign Execution */
        // Campaign Record Type Id Search
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap_test = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> taskRecordTypeMap_test = Schema.SObjectType.Task.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> accRecordTypeMap_test = Schema.SObjectType.Account.getRecordTypeInfosByName();
        Id cca_RecordTypeId = cpRecordTypeMap_test.get('Central Marketing Campaign').getRecordTypeId();         // Central Campaign
        Id cac_RecordTypeId = cpRecordTypeMap_test.get('CAC Campaign').getRecordTypeId();                       // CAC Campaign
        Id caeCom_RecordTypeId = cpRecordTypeMap_test.get('Campaign Execution - Complex').getRecordTypeId();    // Campaign Execution - Complex
        Id caeSim_RecordTypeId = cpRecordTypeMap_test.get('Campaign Execution - Simple').getRecordTypeId();     // Campaign Execution - Simple
        Id accPerson_RecordTypeId = accRecordTypeMap_test.get('Person Account').getRecordTypeId();     // Person Account.
        
        // Campaign Execution Inital
        // 1.Simple; OB Call; Lead
        Campaign TestData_CAE_OBL = new Campaign(Name='TestData_CAE_OB_SIM_L',
                                                Campaign_Code__c='code exe ob sim testl',
                                                Execution_Type__c='OB Call',
                                                Task_Created_By__c='Lead',
                                                RecordTypeId=caeSim_RecordTypeId);
    // SMS Template
         Map<String, Schema.RecordTypeInfo> temRecordTypeMap_test = Schema.SObjectType.Template__c.getRecordTypeInfosByName();
        Id smsTem_RecordTypeId = temRecordTypeMap_test.get('SMS').getRecordTypeId();
        Template__c tcSMS = new Template__c(Name='TEST CAMPAIGN TEMPLATE', RecordTypeId=smsTem_RecordTypeId, Active__c=True, Type__c='Price List', Car_Series__c='A-Class', Template_ID__c='a0lO0000000LOKq');
        insert tcSMS;
        
        // 2.Simple; SMS; Lead
        Campaign TestData_CAE_SMSL = new Campaign(Name='TestData_CAE_SMS_SIM_L',
                                                Campaign_Code__c='code exe sms sim testl',
                                                Execution_Type__c='SMS',
                                                Task_Created_By__c='Lead',
                                                RecordTypeId=caeSim_RecordTypeId,
                                                Template__c=tcSMS.Id);
        
        insert(TestData_CAE_OBL);
        insert(TestData_CAE_SMSL);
        
        // Lead & Campaign Lead
        Account testPerAcc = new Account(LastName='TEST ACC',
                                      Type='Company',
                                      Status__c='VIP',
                                      Province__c='Shanghai',
                                      City_CN__c='宝山区',
                                      ZipCode__c='123456',
                                      PersonMobilePhone='12345678910',
                                      RecordTypeId=accPerson_RecordTypeId
                                     );
        
        Contact testPerCon = new Contact(LastName='TEST ACC',
                                         AccountId = testPerAcc.Id,
                                         email = '11@11.com',
                                         Phone='12345678910');
        insert(testPerAcc);
        insert(testPerCon);
        Lead__c testLead = new Lead__c(
                                       CAC_Lead_Status__c='Assigned',
                                       Lead_Type__c='New Car',
                                       Lead_Desired_Service__c='Buy',
                                       Purchase_Time__c='No Plans',
                                       Interested_Vehicle_Brand__c='Smart',
                                       Interested_Vehicle_Class__c='Smart',
                                       Interested_Vehicle_Model__c='Other',
                                       Interested_Vehicle_Tridion_Cell_Colour__c='40 黑色',
                                       Interested_Vehicle_Interior_Color__c='黑色',
                                       Contact__c=testPerAcc.Id);

        insert(testLead);
        //insert(testPerCon);                                 

        
        // Campaign Lead Initial
        Campaign_Lead__c testCamLead1 = new Campaign_Lead__c(Campaign__c = TestData_CAE_OBL.Id,Lead__c = testLead.Id);
        Campaign_Lead__c testCamLead2 = new Campaign_Lead__c(Campaign__c = TestData_CAE_SMSL.Id,Lead__c = testLead.Id);        
        
        insert(testCamLead1);
        insert(testCamLead2);
        
        List<Campaign> cpLeadList = new List<Campaign>();
        cpLeadList.add(TestData_CAE_OBL);
        cpLeadList.add(TestData_CAE_SMSL);
        Test.startTest();
        TestData_CAE_OBL.Create_Task__c=true;
        TestData_CAE_SMSL.Create_Task__c=true;
        update TestData_CAE_OBL;
        update TestData_CAE_SMSL;
        //update cpLeadList;
        //database.executeBatch(new UtilCampaignTaskGenerationByLeads(cpLeadList), 200);
        Test.stopTest();
        
    }
    
    //UtilCampaignTaskGenerationByLeads Test Method
    static testMethod void runUtilCampaignEDMDMTaskGenerationByLeads_Class(){
                
        /* START: Data Preparation: Cenral Campaign; CAC Campaign; Campaign Execution */
        // Campaign Record Type Id Search
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap_test = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> taskRecordTypeMap_test = Schema.SObjectType.Task.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> accRecordTypeMap_test = Schema.SObjectType.Account.getRecordTypeInfosByName();
        Id cca_RecordTypeId = cpRecordTypeMap_test.get('Central Marketing Campaign').getRecordTypeId();         // Central Campaign
        Id cac_RecordTypeId = cpRecordTypeMap_test.get('CAC Campaign').getRecordTypeId();                       // CAC Campaign
        Id caeCom_RecordTypeId = cpRecordTypeMap_test.get('Campaign Execution - Complex').getRecordTypeId();    // Campaign Execution - Complex
        Id caeSim_RecordTypeId = cpRecordTypeMap_test.get('Campaign Execution - Simple').getRecordTypeId();     // Campaign Execution - Simple
        Id accPerson_RecordTypeId = accRecordTypeMap_test.get('Person Account').getRecordTypeId();     // Person Account.
        
    // SMS Template
         Map<String, Schema.RecordTypeInfo> temRecordTypeMap_test = Schema.SObjectType.Template__c.getRecordTypeInfosByName();
        Id edmTem_RecordTypeId = temRecordTypeMap_test.get('eDM').getRecordTypeId();
        Template__c tceDM = new Template__c(Name='TEST CAMPAIGN TEMPLATE', RecordTypeId=edmTem_RecordTypeId, Active__c=True, Type__c='Price List', Car_Series__c='A-Class', Template_ID__c='a0lO0000000LOKq');        
        DM_Material__c tcDM = new DM_Material__c(Name='TEST-CAMPAIGN-TEMPLATE',Type__c='Flyer');        
        insert tcDM;
        insert tceDM;
        
        // 3.Simple; eDM; Lead 
        Campaign TestData_CAE_EDML = new Campaign(Name='TestData_CAE_eDM_SIM_L',
                                                Campaign_Code__c='code exe edm sim testl',
                                                Execution_Type__c='eDM',
                                                Task_Created_By__c='Lead',
                                                RecordTypeId=caeSim_RecordTypeId,
                                                Template__c=tceDM.Id);
        // 4.Simple; DM; Lead 
        Campaign TestData_CAE_DML = new Campaign(Name='TestData_CAE_DM_SIM_L',
                                                Campaign_Code__c='code exe em sim testl',
                                                Execution_Type__c='DM',
                                                Task_Created_By__c='Lead',
                                                RecordTypeId=caeSim_RecordTypeId,
                                                DM_Material__c=tcDM.Id);
        
        insert(TestData_CAE_EDML);
        insert(TestData_CAE_DML);
        
        // Lead & Campaign Lead
        Account testPerAcc = new Account(LastName='TEST ACC',
                                      Type='Company',
                                      Status__c='VIP',
                                      Province__c='Shanghai',
                                      City_CN__c='宝山区',
                                      ZipCode__c='123456',
                                      PersonMobilePhone='12345678910',
                                      RecordTypeId=accPerson_RecordTypeId
                                     );
        
        Contact testPerCon = new Contact(LastName='TEST ACC',
                                         AccountId = testPerAcc.Id,
                                         email = '11@11.com',
                                         Phone='12345678910');
        insert(testPerAcc);
        insert(testPerCon);
        Lead__c testLead = new Lead__c(
                                       CAC_Lead_Status__c='Assigned',
                                       Lead_Type__c='New Car',
                                       Lead_Desired_Service__c='Buy',
                                       Purchase_Time__c='No Plans',
                                       Interested_Vehicle_Brand__c='Smart',
                                       Interested_Vehicle_Class__c='Smart',
                                       Interested_Vehicle_Model__c='Other',
                                       Interested_Vehicle_Tridion_Cell_Colour__c='40 黑色',
                                       Interested_Vehicle_Interior_Color__c='黑色',
                                       Contact__c=testPerAcc.Id);

        insert(testLead);
        //insert(testPerCon);                                 

        
        // Campaign Lead Initial
        Campaign_Lead__c testCamLead3 = new Campaign_Lead__c(Campaign__c = TestData_CAE_EDML.Id,Lead__c = testLead.Id);
        Campaign_Lead__c testCamLead4 = new Campaign_Lead__c(Campaign__c = TestData_CAE_DML.Id,Lead__c = testLead.Id);
        
        insert(testCamLead3);
        insert(testCamLead4);        
        
        List<Campaign> cpLeadList = new List<Campaign>();
        cpLeadList.add(TestData_CAE_EDML);
        cpLeadList.add(TestData_CAE_DML);
        Test.startTest();
        
        TestData_CAE_EDML.Create_Task__c=true;
        TestData_CAE_DML.Create_Task__c=true;
        update TestData_CAE_EDML;
        update TestData_CAE_DML;
        //update cpLeadList;
        //database.executeBatch(new UtilCampaignTaskGenerationByLeads(cpLeadList), 200);
        Test.stopTest();
        
    }
}