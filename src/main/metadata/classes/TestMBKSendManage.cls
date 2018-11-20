/**
 * Created by user on 2018-07-07.
 */
/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestMBKSendManage {
    public static Id parentCampaign_RecordTypeID = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    public static Id OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
    final static String CHRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId();
    private static String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
    public static Id KakaoTalkRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('KakaoTalk').getRecordTypeId();
    private static final String FAKE_RESPONSE = '[{"sn":"20180419-093318976R202RS000015","custMsgSn":"benzkr_a2U0k00000011lkEAA","altCode":null,"code":"EW","altMsg":null,"smsCode":null,"smsMsg":"SMS/LMS/MMS Sending","sndDtm":"20180419093318","rcptDtm":null}]';
    private static final String FAKE_RESPONSE_FAIL = '{dasdasdasdasdsadasd}';

    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // You could assert the request content here
            HTTPResponse res = new HTTPResponse();
            res.setBody(FAKE_RESPONSE);
            res.setStatusCode(200);
            return res;
        }
    }

    private class MockFail implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // You could assert the request content here
            HTTPResponse res = new HTTPResponse();
            res.setBody(FAKE_RESPONSE);
            res.setStatusCode(500);
            return res;
        }
    }

    //Account
    static testMethod void myUnitTest() {
        Trigger__c cs = new Trigger__c();
        cs.Name = 'TriggerMBKSendManageKR';
        cs.Trigger_Handler__c = 'TriggerMBKSendManageHandlerKR';
        cs.Trigger_Name__c = 'TriggerMBKSendManage';
        cs.Market__c = 'KR';
        cs.after__c = false;
        cs.before__c = true;
        cs.enabled__c = true;
        cs.insert__c = true;
        cs.update__c = true;
        insert cs;

        Trigger__c csa = new Trigger__c();
        csa.Name = 'TriggerAccountKR';
        csa.Trigger_Handler__c = 'TriggerAccountTriggerHandlerKR';
        csa.Trigger_Name__c = 'TriggerAccount';
        csa.Market__c = 'KR';
        csa.after__c = true;
        csa.before__c = false;
        csa.enabled__c = true;
        csa.insert__c = true;
        csa.update__c = true;
        insert csa;

        Kakao_Talk_Integration_URL__c csurl = new Kakao_Talk_Integration_URL__c();
        csurl.Name = 'SfdcMBKMessageURL';
        csurl.WebService_URL_1DR__c = 'https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/I2MaxKakao';
        insert csurl;

        SystemSettingsDFW__c settings = SystemSettingsDFW__c.getOrgDefaults();
        settings.Debug__c = true;
        settings.Error__c = true;
        settings.Info__c = true;
        settings.Log_Purge__c = 10;
        settings.Warning__c = true;
        upsert settings SystemSettingsDFW__c.Id;

        Template__c tmp = new Template__c();
        tmp.RecordTypeId = KakaoTalkRecordTypeId;
        tmp.Active__c = true;
        tmp.MD__c  = 'KR';
        tmp.Message_Detail__c = '#{고객명} 고객님,시승 예약이 아래와 같이 예정되어 있습니다.- 일시: #{예약시간}- 전시장 주소: #{전시장주소}예약 변동 사항 있으면 알려주시기 바랍니다.감사합니다.#{회사명}';
        tmp.Subject__c = '시승 예약';
        tmp.Template_ID__c = 'benz_01';
        tmp.Type__c = 'Upstream & Downstream';
        insert tmp;

        MBKSendManage__c msm = new MBKSendManage__c();
        msm.Target_Object__c = 'Account';
        msm.SendTiming__c = 'Insert';
        msm.PreviousHour__c = '08';
        msm.PreviousMinute__c = '00';
        msm.PostHour__c = '20';
        msm.PostMinute__c = '00';
        msm.Active__c = true;
        msm.SendType__c = 'KakaoTalk';
        msm.Template__c = tmp.Id;
        msm.Update_Status__c = 'Always';
        insert msm;

        Test.setMock(HttpCalloutMock.class, new Mock());

        // TO DO: implement unit test
        KR_Switch__c krswitch=new KR_Switch__c(Name='AccountHelperswitch',Enable_Flag__c=True);
   List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
   lsttrgt.add(krswitch);
   insert lsttrgt;
   Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
        Account acc;
         if (!KRSwitchEnabledFlag) {
         acc = new Account(Dealer_Default_Flag__c=false,
                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '02-2643-4746',Home_Phone_2__c = '02-2643-4746',Work_Phone__c = '02-2643-4746',
                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                City__c='Beijing', Gender__c = 'Male', Phone = '02-2643-4746', Area_code__c = '0101', LastName = '刈乾冠寒刊勘', FirstName = '刈乾冠寒刊勘',
                Salutation = 'Unknown', Province__c = 'Shanghai', ZipCode__c= '1002347', Mobile__c = '010-5510-4746', Mobile2__c = '010-5510-4746',
                Primary_Email__c = 'Email1', Primary_Fax__c = 'FAX2', Primary_Phone__c ='Other2', MD__c = 'KR', Industry = 'Other',
                Personal_Agreement__c = 'Yes' ,Personal_Information_Third_Party_Release__c = 'Yes', MBK_Data_Source__c = 'Mercedes-Benz',
                Personal_Abroad_Agreement__c = 'Yes' ,Agreement_to_commit_info_processing__c = 'Yes', Market__c = 'KR', isTestRunning__c = true,
                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                }
                else{
                 acc = new Account(Dealer_Default_Flag__c=false,
                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '+82-2-2643-4746',Home_Phone_2__c = '02-2643-4746',Work_Phone__c = '+82-2-2643-4746',
                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                City__c='Beijing', Gender__c = 'Male', Phone = '02-2643-4746', Area_code__c = '0101', LastName = '刈乾冠寒刊勘', FirstName = '刈乾冠寒刊勘',
                Salutation = 'Unknown', Province__c = 'Shanghai', ZipCode__c= '1002347', Mobile__c = '+82-10-5510-4746', Mobile2__c = '010-5510-4746',
                Primary_Email__c = 'Email1', Primary_Fax__c = 'FAX2', Primary_Phone__c ='Other2', MD__c = 'KR', Industry = 'Other',
                Personal_Agreement__c = 'Yes' ,Personal_Information_Third_Party_Release__c = 'Yes', MBK_Data_Source__c = 'Mercedes-Benz',
                Personal_Abroad_Agreement__c = 'Yes' ,Agreement_to_commit_info_processing__c = 'Yes', Market__c = 'KR', isTestRunning__c = true,
                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                }
        insert acc;
    }

    //Lead
    static testMethod void myUnitTest1() {
        Trigger__c cs = new Trigger__c();
        cs.Name = 'TriggerMBKSendManageKR';
        cs.Trigger_Handler__c = 'TriggerMBKSendManageHandlerKR';
        cs.Trigger_Name__c = 'TriggerMBKSendManage';
        cs.Market__c = 'KR';
        cs.after__c = false;
        cs.before__c = true;
        cs.enabled__c = true;
        cs.insert__c = true;
        cs.update__c = true;
        insert cs;

        Trigger__c csa = new Trigger__c();
        csa.Name = 'TriggerLeadKR';
        csa.Trigger_Handler__c = 'TriggerLeadTriggerHandlerKR';
        csa.Trigger_Name__c = 'TriggerLead';
        csa.Market__c = 'KR';
        csa.after__c = true;
        csa.before__c = false;
        csa.enabled__c = true;
        csa.insert__c = true;
        csa.update__c = true;
        insert csa;

        Kakao_Talk_Integration_URL__c csurl = new Kakao_Talk_Integration_URL__c();
        csurl.Name = 'SfdcMBKMessageURL';
        csurl.WebService_URL_1DR__c = 'https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/I2MaxKakao';
        insert csurl;

        SystemSettingsDFW__c settings = SystemSettingsDFW__c.getOrgDefaults();
        settings.Debug__c = true;
        settings.Error__c = true;
        settings.Info__c = true;
        settings.Log_Purge__c = 10;
        settings.Warning__c = true;
        upsert settings SystemSettingsDFW__c.Id;

        Template__c tmp = new Template__c();
        tmp.RecordTypeId = KakaoTalkRecordTypeId;
        tmp.Active__c = true;
        tmp.MD__c  = 'KR';
        tmp.Message_Detail__c = '#{고객명} 고객님,시승 예약이 아래와 같이 예정되어 있습니다.- 일시: #{예약시간}- 전시장 주소: #{전시장주소}예약 변동 사항 있으면 알려주시기 바랍니다.감사합니다.#{회사명}';
        tmp.Subject__c = '시승 예약';
        tmp.Template_ID__c = 'benz_01';
        tmp.Type__c = 'Upstream & Downstream';
        insert tmp;

        MBKSendManage__c msm = new MBKSendManage__c();
        msm.Target_Object__c = 'Lead';
        msm.SendTiming__c = 'Insert';
        msm.PreviousHour__c = '08';
        msm.PreviousMinute__c = '00';
        msm.PostHour__c = '20';
        msm.PostMinute__c = '00';
        msm.Active__c = true;
        msm.SendType__c = 'KakaoTalk';
        msm.Template__c = tmp.Id;
        msm.Update_Status__c = 'Always';
        msm.Record_Type__c = 'Aftersales Leads';
        insert msm;

        Test.setMock(HttpCalloutMock.class, new Mock());

        // TO DO: implement unit test
        KR_Switch__c krswitch=new KR_Switch__c(Name='AccountHelperswitch',Enable_Flag__c=True);
   List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
   lsttrgt.add(krswitch);
   insert lsttrgt;
   Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
         Account acc;
         if (!KRSwitchEnabledFlag) {
       acc = new Account(Dealer_Default_Flag__c=false,
                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '02-2643-4746',Home_Phone_2__c = '02-2643-4746',Work_Phone__c = '02-2643-4746',
                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                City__c='Beijing', Gender__c = 'Male', Phone = '02-2643-4746', Area_code__c = '0101', LastName = '刈乾冠寒刊勘', FirstName = '刈乾冠寒刊勘',
                Salutation = 'Unknown', Province__c = 'Shanghai', ZipCode__c= '1002347', Mobile__c = '010-5510-4746', Mobile2__c = '010-5510-4746',
                Primary_Email__c = 'Email1', Primary_Fax__c = 'FAX2', Primary_Phone__c ='Other2', MD__c = 'KR', Industry = 'Other',
                Personal_Agreement__c = 'Yes' ,Personal_Information_Third_Party_Release__c = 'Yes', MBK_Data_Source__c = 'Mercedes-Benz',
                Personal_Abroad_Agreement__c = 'Yes' ,Agreement_to_commit_info_processing__c = 'Yes', Market__c = 'KR', isTestRunning__c = true,
                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                }
                else{
                acc = new Account(Dealer_Default_Flag__c=false,
                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '+82-2-2643-4746',Home_Phone_2__c = '02-2643-4746',Work_Phone__c = '+82-2-2643-4746',
                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                City__c='Beijing', Gender__c = 'Male', Phone = '02-2643-4746', Area_code__c = '0101', LastName = '刈乾冠寒刊勘', FirstName = '刈乾冠寒刊勘',
                Salutation = 'Unknown', Province__c = 'Shanghai', ZipCode__c= '1002347', Mobile__c = '+82-10-5510-4746', Mobile2__c = '010-5510-4746',
                Primary_Email__c = 'Email1', Primary_Fax__c = 'FAX2', Primary_Phone__c ='Other2', MD__c = 'KR', Industry = 'Other',
                Personal_Agreement__c = 'Yes' ,Personal_Information_Third_Party_Release__c = 'Yes', MBK_Data_Source__c = 'Mercedes-Benz',
                Personal_Abroad_Agreement__c = 'Yes' ,Agreement_to_commit_info_processing__c = 'Yes', Market__c = 'KR', isTestRunning__c = true,
                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                
                }
        insert acc;

        Lead__c lead = new Lead__c();
        lead.Contact__c = acc.Id;
        lead.recordTypeId =afterSalesRecordTypeId;
        lead.CAC_Lead_Status__c = 'Qualified';
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
        lead.MD__c = 'KR';
        insert lead;

    }

    //Task
    static testMethod void myUnitTest2() {
        Trigger__c cs = new Trigger__c();
        cs.Name = 'TriggerMBKSendManageKR';
        cs.Trigger_Handler__c = 'TriggerMBKSendManageHandlerKR';
        cs.Trigger_Name__c = 'TriggerMBKSendManage';
        cs.Market__c = 'KR';
        cs.after__c = false;
        cs.before__c = true;
        cs.enabled__c = true;
        cs.insert__c = true;
        cs.update__c = true;
        insert cs;

        Trigger__c csa = new Trigger__c();
        csa.Name = 'TaskTriggerKR';
        csa.Trigger_Handler__c = 'TaskTriggerHandlerKR';
        csa.Trigger_Name__c = 'TaskTrigger';
        csa.Market__c = 'KR';
        csa.after__c = true;
        csa.before__c = false;
        csa.enabled__c = true;
        csa.insert__c = true;
        csa.update__c = true;
        insert csa;

        Kakao_Talk_Integration_URL__c csurl = new Kakao_Talk_Integration_URL__c();
        csurl.Name = 'SfdcMBKMessageURL';
        csurl.WebService_URL_1DR__c = 'https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/I2MaxKakao';
        insert csurl;

        SystemSettingsDFW__c settings = SystemSettingsDFW__c.getOrgDefaults();
        settings.Debug__c = true;
        settings.Error__c = true;
        settings.Info__c = true;
        settings.Log_Purge__c = 10;
        settings.Warning__c = true;
        upsert settings SystemSettingsDFW__c.Id;

        Template__c tmp = new Template__c();
        tmp.RecordTypeId = KakaoTalkRecordTypeId;
        tmp.Active__c = true;
        tmp.MD__c  = 'KR';
        tmp.Message_Detail__c = '#{고객명} 고객님,시승 예약이 아래와 같이 예정되어 있습니다.- 일시: #{예약시간}- 전시장 주소: #{전시장주소}예약 변동 사항 있으면 알려주시기 바랍니다.감사합니다.#{회사명}';
        tmp.Subject__c = '시승 예약';
        tmp.Template_ID__c = 'benz_01';
        tmp.Type__c = 'Upstream & Downstream';
        insert tmp;

        MBKSendManage__c msm = new MBKSendManage__c();
        msm.Target_Object__c = 'Task';
        msm.SendTiming__c = 'Insert';
        msm.PreviousHour__c = '08';
        msm.PreviousMinute__c = '00';
        msm.PostHour__c = '20';
        msm.PostMinute__c = '00';
        msm.Active__c = true;
        msm.SendType__c = 'KakaoTalk';
        msm.Template__c = tmp.Id;
        msm.Update_Status__c = 'Always';
        insert msm;

        Test.setMock(HttpCalloutMock.class, new Mock());

        // TO DO: implement unit test
           KR_Switch__c krswitch=new KR_Switch__c(Name='AccountHelperswitch',Enable_Flag__c=True);
   List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
   lsttrgt.add(krswitch);
   insert lsttrgt;
   Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
         Account acc;
         if (!KRSwitchEnabledFlag) {
         acc = new Account(Dealer_Default_Flag__c=false,
                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '02-2643-4746',Home_Phone_2__c = '02-2643-4746',Work_Phone__c = '02-2643-4746',
                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                City__c='Beijing', Gender__c = 'Male', Phone = '02-2643-4746', Area_code__c = '0101', LastName = '刈乾冠寒刊勘', FirstName = '刈乾冠寒刊勘',
                Salutation = 'Unknown', Province__c = 'Shanghai', ZipCode__c= '1002347', Mobile__c = '010-5510-4746', Mobile2__c = '010-5510-4746',
                Primary_Email__c = 'Email1', Primary_Fax__c = 'FAX2', Primary_Phone__c ='Other2', MD__c = 'KR', Industry = 'Other',
                Personal_Agreement__c = 'Yes' ,Personal_Information_Third_Party_Release__c = 'Yes', MBK_Data_Source__c = 'Mercedes-Benz',
                Personal_Abroad_Agreement__c = 'Yes' ,Agreement_to_commit_info_processing__c = 'Yes', Market__c = 'KR', isTestRunning__c = true,
                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                }
                else{
                 acc = new Account(Dealer_Default_Flag__c=false,
                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '+82-2-2643-4746',Home_Phone_2__c = '02-2643-4746',Work_Phone__c = '+82-2-2643-4746',
                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                City__c='Beijing', Gender__c = 'Male', Phone = '02-2643-4746', Area_code__c = '0101', LastName = '刈乾冠寒刊勘', FirstName = '刈乾冠寒刊勘',
                Salutation = 'Unknown', Province__c = 'Shanghai', ZipCode__c= '1002347', Mobile__c = '+82-10-5510-4746', Mobile2__c = '010-5510-4746',
                Primary_Email__c = 'Email1', Primary_Fax__c = 'FAX2', Primary_Phone__c ='Other2', MD__c = 'KR', Industry = 'Other',
                Personal_Agreement__c = 'Yes' ,Personal_Information_Third_Party_Release__c = 'Yes', MBK_Data_Source__c = 'Mercedes-Benz',
                Personal_Abroad_Agreement__c = 'Yes' ,Agreement_to_commit_info_processing__c = 'Yes', Market__c = 'KR', isTestRunning__c = true,
                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                }
        insert acc;

        // TO DO: implement unit test
        Task taskobj = new Task();
        taskobj.RecordTypeId = OBTaskRecordTypeId ;
        taskobj.Status='open';
        taskobj.Activity_Status__c='Successful';
        taskobj.Generate_QC__c = true;
        taskobj.whatId = acc.Id;
        taskobj.MD__c = 'KR';
        taskobj.Account_Name__c = '이정우';
        taskobj.Phone__c = '010-5510-4746';
        insert taskobj;
    }

    //Case
    static testMethod void myUnitTest3() {
        Trigger__c cs = new Trigger__c();
        cs.Name = 'TriggerMBKSendManageKR';
        cs.Trigger_Handler__c = 'TriggerMBKSendManageHandlerKR';
        cs.Trigger_Name__c = 'TriggerMBKSendManage';
        cs.Market__c = 'KR';
        cs.after__c = false;
        cs.before__c = true;
        cs.enabled__c = true;
        cs.insert__c = true;
        cs.update__c = true;
        insert cs;

        Trigger__c csa = new Trigger__c();
        csa.Name = '    CaseTriggerKR';
        csa.Trigger_Handler__c = 'TriggerCaseTriggerHandlerKR';
        csa.Trigger_Name__c = 'CaseTrigger';
        csa.Market__c = 'KR';
        csa.after__c = true;
        csa.before__c = false;
        csa.enabled__c = true;
        csa.insert__c = true;
        csa.update__c = true;
        insert csa;

        Kakao_Talk_Integration_URL__c csurl = new Kakao_Talk_Integration_URL__c();
        csurl.Name = 'SfdcMBKMessageURL';
        csurl.WebService_URL_1DR__c = 'https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/I2MaxKakao';
        insert csurl;

        SystemSettingsDFW__c settings = SystemSettingsDFW__c.getOrgDefaults();
        settings.Debug__c = true;
        settings.Error__c = true;
        settings.Info__c = true;
        settings.Log_Purge__c = 10;
        settings.Warning__c = true;
        upsert settings SystemSettingsDFW__c.Id;

        Template__c tmp = new Template__c();
        tmp.RecordTypeId = KakaoTalkRecordTypeId;
        tmp.Active__c = true;
        tmp.MD__c  = 'KR';
        tmp.Message_Detail__c = '#{고객명} 고객님,시승 예약이 아래와 같이 예정되어 있습니다.- 일시: #{예약시간}- 전시장 주소: #{전시장주소}예약 변동 사항 있으면 알려주시기 바랍니다.감사합니다.#{회사명}';
        tmp.Subject__c = '시승 예약';
        tmp.Template_ID__c = 'benz_01';
        tmp.Type__c = 'Upstream & Downstream';
        insert tmp;

        MBKSendManage__c msm = new MBKSendManage__c();
        msm.Target_Object__c = 'Case';
        msm.SendTiming__c = 'Insert';
        msm.PreviousHour__c = '08';
        msm.PreviousMinute__c = '00';
        msm.PostHour__c = '13';
        msm.PostMinute__c = '00';
        msm.Active__c = true;
        msm.SendType__c = 'KakaoTalk';
        msm.Template__c = tmp.Id;
        msm.Update_Status__c = 'Always';
        msm.Record_Type__c = 'Inquiry';
        insert msm;

        MBKSendManage__c msm1 = new MBKSendManage__c();
        msm1.Target_Object__c = 'Case';
        msm1.SendTiming__c = 'Insert';
        msm1.PreviousHour__c = '16';
        msm1.PreviousMinute__c = '00';
        msm1.PostHour__c = '20';
        msm1.PostMinute__c = '00';
        msm1.Active__c = true;
        msm1.SendType__c = 'KakaoTalk';
        msm1.Template__c = tmp.Id;
        msm1.Update_Status__c = 'Always';
        msm1.Record_Type__c = 'Inquiry';
        insert msm1;

        Test.setMock(HttpCalloutMock.class, new Mock());

        // TO DO: implement unit test
            KR_Switch__c krswitch=new KR_Switch__c(Name='AccountHelperswitch',Enable_Flag__c=True);
   List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
   lsttrgt.add(krswitch);
   insert lsttrgt;
   Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
         Account acc;
         if (!KRSwitchEnabledFlag) {
       acc = new Account(Dealer_Default_Flag__c=false,
                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '02-2643-4746',Home_Phone_2__c = '02-2643-4746',Work_Phone__c = '02-2643-4746',
                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                City__c='Beijing', Gender__c = 'Male', Phone = '02-2643-4746', Area_code__c = '0101', LastName = '刈乾冠寒刊勘', FirstName = '刈乾冠寒刊勘',
                Salutation = 'Unknown', Province__c = 'Shanghai', ZipCode__c= '1002347', Mobile__c = '010-5510-4746', Mobile2__c = '010-5510-4746',
                Primary_Email__c = 'Email1', Primary_Fax__c = 'FAX2', Primary_Phone__c ='Other2', MD__c = 'KR', Industry = 'Other',
                Personal_Agreement__c = 'Yes' ,Personal_Information_Third_Party_Release__c = 'Yes', MBK_Data_Source__c = 'Mercedes-Benz',
                Personal_Abroad_Agreement__c = 'Yes' ,Agreement_to_commit_info_processing__c = 'Yes', Market__c = 'KR', isTestRunning__c = true,
                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                }
                else{
                acc = new Account(Dealer_Default_Flag__c=false,
                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '+82-2-2643-4746',Home_Phone_2__c = '02-2643-4746',Work_Phone__c = '+82-2-2643-4746',
                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                City__c='Beijing', Gender__c = 'Male', Phone = '02-2643-4746', Area_code__c = '0101', LastName = '刈乾冠寒刊勘', FirstName = '刈乾冠寒刊勘',
                Salutation = 'Unknown', Province__c = 'Shanghai', ZipCode__c= '1002347', Mobile__c = '+82-10-5510-4746', Mobile2__c = '010-5510-4746',
                Primary_Email__c = 'Email1', Primary_Fax__c = 'FAX2', Primary_Phone__c ='Other2', MD__c = 'KR', Industry = 'Other',
                Personal_Agreement__c = 'Yes' ,Personal_Information_Third_Party_Release__c = 'Yes', MBK_Data_Source__c = 'Mercedes-Benz',
                Personal_Abroad_Agreement__c = 'Yes' ,Agreement_to_commit_info_processing__c = 'Yes', Market__c = 'KR', isTestRunning__c = true,
                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                
                }
                
        insert acc;

        Contact con = [SELECT Id FROM Contact WHERE AccountId =: acc.id];

        Case myCase = new Case(ContactId = con.Id, AccountId = acc.Id, RecordTypeId = CHRecordtypeid, Problem1__c='ttt', Subject='trest', MD__c = 'KR');
        insert myCase;
    }

}
