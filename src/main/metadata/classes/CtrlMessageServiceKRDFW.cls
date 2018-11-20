/**
* Class Name  : CtrlMessageServiceKRDFW.cls
* Function       : MBK Message Popup Controller
* VFPage     : PageMessagePopupKRDFW.page
* Author     : I2MAX
* Date          : 2017.09.29
* Description : 메시지전송 팝업 관리 컨트롤러(템플릿, 전송대상자(싱글용/멀티용), 전송개체저장)
*/
public with sharing class CtrlMessageServiceKRDFW {
    public Boolean isBulk{get;set;}
    public Boolean doc{get;set;}
    public Boolean IsSend{get;set;}
    public String TargetID{get;set;}
    public String actionType{get;set;}
    public String Mtype{get;set;}
    public String socLabel{get;set;}
    public String bulkSocName{get;set;}
    public String pageBulkMessageId{get;set;}
    public MBK_Messages__c viewObject{get;set;}
    public Attachment mmsFile1{get;set;}
    public Attachment mmsFile2{get;set;}
    public Attachment mmsFile3{get;set;}
    public Integer fileSize1{get;set;}
    public Integer fileSize2{get;set;}
    public Integer fileSize3{get;set;}
    public Integer MemberCount{get;set;}
    public Integer TargetCount{get;set;}
    public ApexPages.StandardSetController MessageStcon{get;set;}
    public Integer NoOfRecords {get;set;}
    public Integer TemplateSize {get;set;}
    public String SendTemplateId{get;set;}
    public String dealerId{get;set;}
    public String AccountId{get;set;}
    public List<SelectOption> callerIds{get;set;}
    public Boolean isPartner{get;set;}
    public String CallerId{get;set;}
    private User loginUser{get;set;}
    private Lead__c tlead{get;set;}
    //Template 변경
    public List<Template__c> MessageTemplatesOrg{get;set;}
    private map<Id, Template__c> retTemplatesOrg{get;set;}

    private static Map<String, Schema.SObjectType> sObjectTypes = Schema.getGlobalDescribe();
    private MBK_Bulk_Message__c BulkMessage{get;set;}

    public CtrlMessageServiceKRDFW(){
        tlead = new Lead__c();
        callerIds = new List<SelectOption>();
        dealerId = '';
        AccountId = '';
        IsSend = false;
        isBulk = false;
        doc = false;
        socLabel = system.Label.MBK_Page_Label_Mass_Send;
        TargetID = Apexpages.currentPage().getParameters().get('id');
        actionType = Apexpages.currentPage().getParameters().get('action');
        pageBulkMessageId = Apexpages.currentPage().getParameters().get('bulkMessageId');
        if(Mtype == null) Mtype = 'SMS/MMS';
        mmsFile1 = new Attachment ();
        mmsFile2 = new Attachment ();
        mmsFile3 = new Attachment ();

        MessageTemplatesOrg = new List<Template__c>();
        viewObject = new MBK_Messages__c();
        fileSize1 = 0;
        fileSize2 = 0;
        fileSize3 = 0;
        TemplateSize = 0;
        NoOfRecords = 0;

        if(TargetID <> null){
            if(actionType == system.label.MBK_MessageType_Edit) getMBKMessage();         //Message
            else if(TargetID.left(3) == getObjectPrefix('Lead__c')) getTargetLead();      //leads
            else if(TargetID.left(3) == getObjectPrefix('Account')) getTargetAccount();       //Account
            else if(TargetID.left(3) == getObjectPrefix('Task')) getTargetTask();        //Task
            else if(TargetID.left(3) == getObjectPrefix('Case')) getTargetCase();        //Case
            else if(TargetID.left(3) == getObjectPrefix('Campaign')) getTargetCampaign();  //Campaign
            else if(TargetID.left(3) == getObjectPrefix('Survey__c')) getTargetSurvey();   //Survey
            else if(TargetID.left(3) == getObjectPrefix('User')) getTargetUser();        //User , 커뮤니티 사용자에게 발송
        }else if(pageBulkMessageId <> null){
            BulkMessage = new MBK_Bulk_Message__c();
            getPageBulkMessages();
        }
        isPartner = getIsParnter();
        if(isPartner){
            if(loginUser.MobilePhone <> null) callerIds.add(new SelectOption(loginUser.MobilePhone,loginUser.MobilePhone));
        }else{
            callerIds.add(new SelectOption(system.label.MBK_Message_Sender_Phone, system.label.MBK_Message_Sender_Phone));
            if(loginUser.MobilePhone <> null) callerIds.add(new SelectOption(loginUser.MobilePhone,loginUser.MobilePhone));
        }
        TypeOfTemplates();
    }

    private Boolean getIsParnter(){
        loginUser = [SELECT Id, AccountId, MobilePhone, User.Profile.Name FROM User WHERE Id =: userinfo.getuserid()];
        if(loginUser.AccountId == null) return false;
        else return true;
    }

    private String getObjectPrefix(String objectName){
        Schema.SObjectType sObjectType = sObjectTypes.get(objectName) ;
        Schema.DescribeSObjectResult result = sObjectType.getDescribe() ;
        String keyPrefix = result.getKeyPrefix();
        return keyPrefix;
    }

    /* get Message Templates, param:Mtype */
    public void TypeOfTemplates() {
        String query = ' SELECT Id, Subject__c, Message_Detail__c, Template_ID__c, RecordType.Name '
                            + 'FROM Template__c WHERE Active__c = true ';
        if(Mtype == 'KaKao') query += 'AND RecordType.Name = \'KakaoTalk\' ';
        else query += 'AND (RecordType.Name = \'SMS\' Or RecordType.Name = \'MMS\') ';
        List<Template__c> temps = Database.query(query);
        retTemplatesOrg = new map<Id, Template__c>();

        for(Template__c temp:temps){
            retTemplatesOrg.put(temp.Id, temp);
        }

        TemplateSize = 5;
        MessageStcon = new ApexPages.StandardSetController(retTemplatesOrg.values());
        MessageStcon.setPageSize(TemplateSize);
        if(NoOfRecords == null) NoOfRecords = 0;
        else NoOfRecords = MessageStcon.getResultSize();
        MessageTemplatesOrg = getTemplatesOrg();

        viewObject.subject__c = null;
        viewObject.message__c = null;
        viewObject.Set_Sending_Time__c = null;
    }

    // Template__c pagging
    public List<Template__c> getTemplatesOrg(){
        List<Template__c> lList = new List<Template__c>();
        for(Template__c l : (List<Template__c>)MessageStcon.getRecords()){
            lList.add(l);
        }

        if(lList.size() < 5){
            integer cnt = 5-lList.size();
            for(integer i = 0; i < cnt; i++){
                Template__c tempInsert = new Template__c();
                lList.add(tempInsert);
            }
        }
        return lList;
    }

    public Boolean TemplateHasNext{
        get{
            if(MessageStcon == null) return false;
            else return MessageStcon.getHasNext();
        }
        set;
    }

    public Boolean TemplateHasPrevious{
        get{
            if(MessageStcon == null) return false;
            else return MessageStcon.getHasPrevious();
        }
        set;
    }

    public Integer TemplatePageNumber{
        get{
            if(MessageStcon == null) return 1;
            else return MessageStcon.getPageNumber();
        }
        set;
    }

    public void TemplateFirst(){
        if(MessageStcon <> null){
            MessageStcon.first();
            MessageTemplatesOrg = getTemplatesOrg();
        }
    }

    public void TemplateLast(){
        if(MessageStcon <> null){
            MessageStcon.last();
            MessageTemplatesOrg = getTemplatesOrg();
        }
    }

    public void TemplatePrevious(){
        if(MessageStcon <> null){
            MessageStcon.previous();
            MessageTemplatesOrg = getTemplatesOrg();
        }
    }

    public void TemplateNext(){
        if(MessageStcon <> null){
            MessageStcon.next();
            MessageTemplatesOrg = getTemplatesOrg();
        }
    }
    // MBK_Message_Template pagging

    private void getTargetLead(){
        Lead__c target = [SELECT Id, Name, Contact__c, Contact__r.UCID__c, Contact__r.Mobile__c, Contact__r.PersonEmail, Assigned_Dealer__c,
                            Contact__r.Name, Contact__r.Email2__c, Contact__r.Opt_In_SMS__c, Contact__r.KaKao_Talk_ID__c,
                            Appointment_DateTime__c, Requested_Service_DateTime1__c, Requested_Service_DateTime2__c,

                            Contact__r.Personal_Agreement__c, Contact__r.Personal_Information_Third_Party_Release__c,
                            Contact__r.Personal_Abroad_Agreement__c, Contact__r.Agreement_to_commit_info_processing__c,
                            Contact__r.General_Personal_Information_Mandatory__c, Contact__r.General_Personal_InfoThirdParty_Optional__c, Contact__r.Targeted_Advertising_Info_Optional__c,
                            Contact__r.General_Personal_Info_Mandatory__c, Contact__r.Targeted_Advert_Info_Optional_STCCC__c,
                            Contact__r.Agreement_to_commit_info_proces_CC_Old__c, Contact__r.Personal_Agreement_CC_Old__c, Contact__r.Personal_Info_Third_Party_Release_CC_Old__c

                        FROM Lead__c WHERE Id =: TargetID];
        tlead =  target;
        AccountId = target.Contact__c;
        viewObject.Leads__c = target.Id;
        viewObject.Account_Name__c = target.Contact__r.Name;
        //Doc 체크 4개(1개라도 통과하면 발송 함)
        //1. CCC Consent (old)
        //Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Agreement_to_commit_info_processing__c
        if(target.Contact__r.Personal_Agreement__c == 'Yes' && target.Contact__r.Personal_Information_Third_Party_Release__c == 'Yes' && target.Contact__r.Agreement_to_commit_info_processing__c == 'Yes') doc = true;

        //2. Contact Method and Customer Consent (Old)
        //General_Personal_Information_Mandator__c, General_Personal_InfoThirdParty_Optional__c, Targeted_Advertising_Info_Optional__c
        if(target.Contact__r.General_Personal_Information_Mandatory__c == 'Yes' && target.Contact__r.General_Personal_InfoThirdParty_Optional__c == 'Yes' && target.Contact__r.Targeted_Advertising_Info_Optional__c == 'Yes') doc = true;

        //3. Contact Method and Customer Consent (Old)
        //Agreement_to_commit_info_proces_CC_Old__c, Personal_Agreement_CC_Old__c, Personal_Info_Third_Party_Release_CC_Old__c
        if(target.Contact__r.Agreement_to_commit_info_proces_CC_Old__c == 'Yes' && target.Contact__r.Personal_Agreement_CC_Old__c == 'Yes' && target.Contact__r.Personal_Info_Third_Party_Release_CC_Old__c == 'Yes') doc = true;

        //4. SalesTouch & CCC Consent (new)
        //General_Personal_Info_Mandatory__c, 	Targeted_Advert_Info_Optional_STCCC__c
        if(target.Contact__r.General_Personal_Info_Mandatory__c == 'Yes' && target.Contact__r.Targeted_Advert_Info_Optional_STCCC__c == 'Yes') doc = true;

        viewObject.General_Personal_Information_Mandatory__c = target.Contact__r.General_Personal_Information_Mandatory__c;
        viewObject.General_Personal_InfoThirdParty_Optional__c = target.Contact__r.General_Personal_InfoThirdParty_Optional__c;
        viewObject.Targeted_Advertising_Info_Optional__c = target.Contact__r.Targeted_Advertising_Info_Optional__c;
        viewObject.General_Personal_Info_Mandatory__c = target.Contact__r.General_Personal_Info_Mandatory__c;
        viewObject.Targeted_Advert_Info_Optional_STCCC__c = target.Contact__r.Targeted_Advert_Info_Optional_STCCC__c;

        viewObject.Agreement_to_commit_info_proces_CC_Old__c = target.Contact__r.Agreement_to_commit_info_proces_CC_Old__c;
        viewObject.Personal_Agreement_CC_Old__c = target.Contact__r.Personal_Agreement_CC_Old__c;
        viewObject.Personal_Info_Third_Party_Release_CC_Old__c = target.Contact__r.Personal_Info_Third_Party_Release_CC_Old__c;

        viewObject.Opt_In_SMS__c  = target.Contact__r.Opt_In_SMS__c;
        viewObject.Personal_Agreement__c = target.Contact__r.Personal_Agreement__c;
        viewObject.Personal_Information_Third_Party_Release__c = target.Contact__r.Personal_Information_Third_Party_Release__c;
        viewObject.Personal_Abroad_Agreement__c = target.Contact__r.Personal_Abroad_Agreement__c;
        viewObject.Agreement_to_commit_info_processing__c = target.Contact__r.Agreement_to_commit_info_processing__c;
        viewObject.KaKaoTalk_ID__c = target.Contact__r.KaKao_Talk_ID__c;
        viewObject.UCID__c = target.Contact__r.UCID__c;
        viewObject.phoneNum__c = target.Contact__r.Mobile__c;

        dealerId = target.Assigned_Dealer__c;
    }

    private void getTargetAccount(){
        Account target = [SELECT Id, Name, UCID__c, Mobile__c, PersonEmail, Opt_In_SMS__c, KaKao_Talk_ID__c,
                                Personal_Agreement__c, Personal_Information_Third_Party_Release__c,
                                Personal_Abroad_Agreement__c, Agreement_to_commit_info_processing__c,
                                General_Personal_Information_Mandatory__c, General_Personal_InfoThirdParty_Optional__c, Targeted_Advertising_Info_Optional__c,
                                General_Personal_Info_Mandatory__c, Targeted_Advert_Info_Optional_STCCC__c,
                                Agreement_to_commit_info_proces_CC_Old__c, Personal_Agreement_CC_Old__c, Personal_Info_Third_Party_Release_CC_Old__c
                        FROM Account WHERE Id =: TargetID];
        AccountId = target.ID;
        viewObject.Account__c = target.Id;
        viewObject.Account_Name__c = target.Name;

        //Doc 체크 4개(1개라도 통과하면 발송 함)
        //1. CCC Consent (old)
        //Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Agreement_to_commit_info_processing__c
        if(target.Personal_Agreement__c == 'Yes' && target.Personal_Information_Third_Party_Release__c == 'Yes' && target.Agreement_to_commit_info_processing__c == 'Yes') doc = true;

        //2. Contact Method and Customer Consent (Old)
        //General_Personal_Information_Mandator__c, General_Personal_InfoThirdParty_Optional__c, Targeted_Advertising_Info_Optional__c
        if(target.General_Personal_Information_Mandatory__c == 'Yes' && target.General_Personal_InfoThirdParty_Optional__c == 'Yes' && target.Targeted_Advertising_Info_Optional__c == 'Yes') doc = true;

        //3. Contact Method and Customer Consent (Old)
        //Agreement_to_commit_info_proces_CC_Old__c, Personal_Agreement_CC_Old__c, Personal_Info_Third_Party_Release_CC_Old__c
        if(target.Agreement_to_commit_info_proces_CC_Old__c == 'Yes' && target.Personal_Agreement_CC_Old__c == 'Yes' && target.Personal_Info_Third_Party_Release_CC_Old__c == 'Yes') doc = true;

        //4. SalesTouch & CCC Consent (new)
        //General_Personal_Info_Mandatory__c, 	Targeted_Advert_Info_Optional_STCCC__c
        if(target.General_Personal_Info_Mandatory__c == 'Yes' && target.Targeted_Advert_Info_Optional_STCCC__c == 'Yes') doc = true;

        viewObject.General_Personal_Information_Mandatory__c = target.General_Personal_Information_Mandatory__c;
        viewObject.General_Personal_InfoThirdParty_Optional__c = target.General_Personal_InfoThirdParty_Optional__c;
        viewObject.Targeted_Advertising_Info_Optional__c = target.Targeted_Advertising_Info_Optional__c;
        viewObject.General_Personal_Info_Mandatory__c = target.General_Personal_Info_Mandatory__c;
        viewObject.Targeted_Advert_Info_Optional_STCCC__c = target.Targeted_Advert_Info_Optional_STCCC__c;

        viewObject.Agreement_to_commit_info_proces_CC_Old__c = target.Agreement_to_commit_info_proces_CC_Old__c;
        viewObject.Personal_Agreement_CC_Old__c = target.Personal_Agreement_CC_Old__c;
        viewObject.Personal_Info_Third_Party_Release_CC_Old__c = target.Personal_Info_Third_Party_Release_CC_Old__c;

        viewObject.Opt_In_SMS__c  = target.Opt_In_SMS__c;
        viewObject.Personal_Agreement__c = target.Personal_Agreement__c;
        viewObject.Personal_Information_Third_Party_Release__c = target.Personal_Information_Third_Party_Release__c;
        viewObject.Personal_Abroad_Agreement__c = target.Personal_Abroad_Agreement__c;
        viewObject.Agreement_to_commit_info_processing__c = target.Agreement_to_commit_info_processing__c;
        viewObject.KaKaoTalk_ID__c = target.KaKao_Talk_ID__c;
        viewObject.UCID__c = target.UCID__c;
        viewObject.phoneNum__c = target.Mobile__c;
    }

    private void getTargetTask(){
        Task target = [SELECT Id, Account_Name__c, CustomerName__c, UCID__c, Email_Address__c, Phone__c FROM Task WHERE Id =: TargetID];

        viewObject.Account_Name__c = target.Account_Name__c;
        doc = true; //확인
        viewObject.UCID__c = target.UCID__c;
        viewObject.phoneNum__c = target.Phone__c;
    }

    private void getTargetCase(){
        Case target = [SELECT Id, Account.Id, Account.UCID__c, Account.Mobile__c, Account.PersonEmail, Case_Dealer__c,
                        Account.Name, Account.Email2__c, Account.Opt_In_SMS__c, Account.KaKao_Talk_ID__c,
                        Account.Personal_Agreement__c, Account.Personal_Information_Third_Party_Release__c,
                        Account.Personal_Abroad_Agreement__c, Account.Agreement_to_commit_info_processing__c,
                        Account.General_Personal_Information_Mandatory__c, Account.General_Personal_InfoThirdParty_Optional__c, Account.Targeted_Advertising_Info_Optional__c,
                        Account.General_Personal_Info_Mandatory__c, Account.Targeted_Advert_Info_Optional_STCCC__c,
                        Account.Agreement_to_commit_info_proces_CC_Old__c, Account.Personal_Agreement_CC_Old__c, Account.Personal_Info_Third_Party_Release_CC_Old__c
                    FROM Case WHERE Id =: TargetID];
        AccountId = target.Account.Id;
        viewObject.Case__c = target.Id;
        viewObject.Account_Name__c = target.Account.Name;

        //Doc 체크 4개(1개라도 통과하면 발송 함)
        //1. CCC Consent (old)
        //Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Agreement_to_commit_info_processing__c
        if(target.Account.Personal_Agreement__c == 'Yes' && target.Account.Personal_Information_Third_Party_Release__c == 'Yes' && target.Account.Agreement_to_commit_info_processing__c == 'Yes') doc = true;

        //2. Contact Method and Customer Consent (Old)
        //General_Personal_Information_Mandator__c, General_Personal_InfoThirdParty_Optional__c, Targeted_Advertising_Info_Optional__c
        if(target.Account.General_Personal_Information_Mandatory__c == 'Yes' && target.Account.General_Personal_InfoThirdParty_Optional__c == 'Yes' && target.Account.Targeted_Advertising_Info_Optional__c == 'Yes') doc = true;

        //3. Contact Method and Customer Consent (Old)
        //Agreement_to_commit_info_proces_CC_Old__c, Personal_Agreement_CC_Old__c, Personal_Info_Third_Party_Release_CC_Old__c
        if(target.Account.Agreement_to_commit_info_proces_CC_Old__c == 'Yes' && target.Account.Personal_Agreement_CC_Old__c == 'Yes' && target.Account.Personal_Info_Third_Party_Release_CC_Old__c == 'Yes') doc = true;

        //4. SalesTouch & CCC Consent (new)
        //General_Personal_Info_Mandatory__c, 	Targeted_Advert_Info_Optional_STCCC__c
        if(target.Account.General_Personal_Info_Mandatory__c == 'Yes' && target.Account.Targeted_Advert_Info_Optional_STCCC__c == 'Yes') doc = true;

        viewObject.General_Personal_Information_Mandatory__c = target.Account.General_Personal_Information_Mandatory__c;
        viewObject.General_Personal_InfoThirdParty_Optional__c = target.Account.General_Personal_InfoThirdParty_Optional__c;
        viewObject.Targeted_Advertising_Info_Optional__c = target.Account.Targeted_Advertising_Info_Optional__c;
        viewObject.General_Personal_Info_Mandatory__c = target.Account.General_Personal_Info_Mandatory__c;
        viewObject.Targeted_Advert_Info_Optional_STCCC__c = target.Account.Targeted_Advert_Info_Optional_STCCC__c;
        viewObject.Agreement_to_commit_info_proces_CC_Old__c = target.Account.Agreement_to_commit_info_proces_CC_Old__c;
        viewObject.Personal_Agreement_CC_Old__c = target.Account.Personal_Agreement_CC_Old__c;
        viewObject.Personal_Info_Third_Party_Release_CC_Old__c = target.Account.Personal_Info_Third_Party_Release_CC_Old__c;

        viewObject.Opt_In_SMS__c  = target.Account.Opt_In_SMS__c;
        viewObject.Personal_Agreement__c = target.Account.Personal_Agreement__c;
        viewObject.Personal_Information_Third_Party_Release__c = target.Account.Personal_Information_Third_Party_Release__c;
        viewObject.Personal_Abroad_Agreement__c = target.Account.Personal_Abroad_Agreement__c;
        viewObject.Agreement_to_commit_info_processing__c = target.Account.Agreement_to_commit_info_processing__c;
        viewObject.KaKaoTalk_ID__c = target.Account.KaKao_Talk_ID__c;
        viewObject.UCID__c = target.Account.UCID__c;
        viewObject.phoneNum__c = target.Account.Mobile__c;

        dealerId = target.Case_Dealer__c;
    }

    private void getTargetCampaign(){
        bulkSocName = [SELECT Name FROM Campaign WHERE Id =: TargetID].Name;
        AggregateResult[] memberResults = [SELECT Count(Id)cnt FROM CampaignMember WHERE CampaignId =: TargetID];
        AggregateResult[] targetResults1 = [SELECT Count(Id)cnt FROM CampaignMember WHERE CampaignId =: TargetID
                                            AND Contact.Account.Personal_Agreement__c = 'Yes' AND Contact.Account.Personal_Information_Third_Party_Release__c = 'Yes' AND Contact.Account.Agreement_to_commit_info_processing__c = 'Yes' ];

        AggregateResult[] targetResults2 = [SELECT Count(Id)cnt FROM CampaignMember WHERE CampaignId =: TargetID
                                            AND Contact.Account.General_Personal_Information_Mandatory__c = 'Yes' AND Contact.Account.General_Personal_InfoThirdParty_Optional__c = 'Yes' AND Contact.Account.Targeted_Advertising_Info_Optional__c = 'Yes' ];

        AggregateResult[] targetResults3 = [SELECT Count(Id)cnt FROM CampaignMember WHERE CampaignId =: TargetID
                                            AND Contact.Account.General_Personal_Info_Mandatory__c = 'Yes' AND Contact.Account.Targeted_Advert_Info_Optional_STCCC__c = 'Yes'];

        AggregateResult[] targetResults4 = [SELECT Count(Id)cnt FROM CampaignMember WHERE CampaignId =: TargetID
                                            AND Contact.Account.Agreement_to_commit_info_proces_CC_Old__c = 'Yes' AND Contact.Account.Personal_Agreement_CC_Old__c = 'Yes' AND Contact.Account.Personal_Info_Third_Party_Release_CC_Old__c = 'Yes'];

        MemberCount = Integer.valueOf(memberResults[0].get('cnt'));
        TargetCount = Integer.valueOf(targetResults1[0].get('cnt')) + Integer.valueOf(targetResults2[0].get('cnt')) + Integer.valueOf(targetResults3[0].get('cnt')) + Integer.valueOf(targetResults4[0].get('cnt'));
        isBulk = true;
        socLabel = system.Label.MBK_Page_Label_Campaign;
    }

    private void getTargetSurvey(){
        isBulk = true;
        socLabel = system.Label.MBK_Page_Label_Suvey;
    }

    private void getTargetUser(){
        User target = [SELECT Id, Name, MobilePhone FROM User WHERE Id =: TargetID];

        //viewObject.Leads__c = target.Id;
        viewObject.Account_Name__c = target.Name;
        doc = true;
        viewObject.phoneNum__c = target.MobilePhone;
    }

    private void getPageBulkMessages(){
        BulkMessage = [SELECT Id, PageSearch__c, PageSearchCount__c, PageSearchIDs__c FROM MBK_Bulk_Message__c WHERE Id =: pageBulkMessageId];
        MemberCount = integer.valueOf(BulkMessage.PageSearchCount__c);
        TargetCount = integer.valueOf(BulkMessage.PageSearchCount__c);
        isBulk = true;
        socLabel = system.Label.MBK_Page_Label_Mass_Send;
    }

    private void getMBKMessage(){
        viewObject = [SELECT Account__c, Account_Name__c, Case__c, KaKaoTalk_ID__c, IsModify__c, CampaignMember__c, Leads__c, MBKMessageTemplate__c, Name, Id, Set_Sending_Time__c, Status__c, UCID__c, altCode__c ,
                            altMsg__c, channel__c, code__c, custGubun__c, AttachmentImages__c, message__c, phoneNum__c, processed__c, reqDtm__c, senderKey__c, sn__c, sndDtm__c, subject__c, templateCode__c,
                            Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Personal_Abroad_Agreement__c, Agreement_to_commit_info_processing__c, Opt_In_SMS__c,
                            General_Personal_Information_Mandatory__c, General_Personal_InfoThirdParty_Optional__c, Targeted_Advertising_Info_Optional__c, General_Personal_Info_Mandatory__c, Targeted_Advert_Info_Optional_STCCC__c,
                            Agreement_to_commit_info_proces_CC_Old__c, Personal_Agreement_CC_Old__c, Personal_Info_Third_Party_Release_CC_Old__c
                        FROM MBK_Messages__c WHERE Id =: TargetID];
        SendTemplateId = viewObject.MBKMessageTemplate__c;
        List<Attachment> Attachments;
        if(viewObject.AttachmentImages__c){
            Attachments = [SELECT Id, Body, Name FROM Attachment WHERE ParentId =: TargetID];
            if(Attachments.size() >= 1) mmsFile1 = Attachments[0];
            if(Attachments.size() >= 2) mmsFile2 = Attachments[1];
            if(Attachments.size() == 3)    mmsFile3 = Attachments[2];
        }
        if(viewObject.channel__c == 'A') Mtype = 'KaKao';

        if(viewObject.Leads__c <> null) dealerId = viewObject.Leads__c;
        else if(viewObject.Case__c <> null) dealerId = viewObject.Case__c;
    }

    /**
    * SMS/LMS/MMS/KaKao Sending
    **/
    public PageReference SendingMessage(){
        // Create a savepoint
        Savepoint sp = Database.setSavepoint();
        GlobalUtilityDFW gu = GlobalUtilityDFW.getInstance();
        try{
            SendTemplateId = Apexpages.currentPage().getParameters().get('SendTemplate');
            String messagebyte = Apexpages.currentPage().getParameters().get('messagebyte');
            //VC
            if(Mtype == 'KaKao' && (SendTemplateId == null || SendTemplateId == '')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'KaKao Talk Error, Select Template'));
                return null;
            }else{
                MBK_Messages__c insertObject = viewObject.clone();
                //Sending Object Field Setting
                if(SendTemplateId <> null && SendTemplateId <> ''){
                    //MBK_Message_Template__c setTemplate = retTemplates.get(SendTemplateId);
                    Template__c setTemplate = retTemplatesOrg.get(SendTemplateId);
                    insertObject.MBKMessageTemplate__c = setTemplate.Id;
                    insertObject.templateCode__c = setTemplate.Template_ID__c;
                }
                if(mmsFile1.Name <> null || mmsFile2.Name <> null || mmsFile3.Name <> null){
                    insertObject.AttachmentImages__c = true;
                }
                if(Mtype == 'KaKao') insertObject.channel__c = system.label.MBK_Message_Channel_KaKao;
                else if(Mtype == 'SMS/MMS'){
                    if((messagebyte <> null && integer.valueOf(messagebyte) > 80) || insertObject.AttachmentImages__c){
                        insertObject.channel__c = system.label.MBK_Message_Channel_MMS;
                    }else{
                        insertObject.channel__c = system.label.MBK_Message_Channel_SMS;
                    }
                }

                insertObject.message__c = setChangeStr(insertObject, dealerId);
                insertObject.currentCallerId__c = CallerId; //grant
                insertObject.custGubun__c  = system.label.MBK_Message_custGubun;
                //MMS파일 처리(Attachment)

                insertObject.senderKey__c = system.label.MBK_Message_SenderKey;
                insertObject.Status__c = 'Reserved';
                if(insertObject.Set_Sending_Time__c == null) insertObject.Set_Sending_Time__c = Datetime.now();
                //Send
                List<MBK_Messages__c> sendObjects = new List<MBK_Messages__c>();
                sendObjects.add(insertObject);
                insert sendObjects;
                List<Attachment> insertAttachments = new List<Attachment>();
                if(mmsFile1.Name <> null){
                    mmsFile1.ParentId = insertObject.Id;
                    insertAttachments.add(mmsFile1);
                }
                if(mmsFile2.Name <> null){
                    mmsFile2.ParentId = insertObject.Id;
                    insertAttachments.add(mmsFile2);
                }
                if(mmsFile3.Name <> null){
                    mmsFile3.ParentId = insertObject.Id;
                    insertAttachments.add(mmsFile3);
                }
                if(insertAttachments.size() > 0){
                    insert insertAttachments;
                    mmsFile1 = new Attachment();
                    mmsFile2 = new Attachment();
                    mmsFile3 = new Attachment();
                }

                insertObject = [SELECT Account__c, Account_Name__c, Case__c, KaKaoTalk_ID__c, IsModify__c, CampaignMember__c,
                                    Leads__c, MBKMessageTemplate__c, Name, Id, Set_Sending_Time__c, Status__c, UCID__c, altCode__c ,
                                    altMsg__c, channel__c, code__c, custGubun__c, AttachmentImages__c, message__c, phoneNum__c,
                                    processed__c, reqDtm__c, senderKey__c, sn__c, sndDtm__c, subject__c, templateCode__c,
                                    Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Personal_Abroad_Agreement__c,
                                    Agreement_to_commit_info_processing__c, Opt_In_SMS__c, currentCallerId__c
                                FROM MBK_Messages__c WHERE Id =: insertObject.Id];
                if(!insertObject.IsModify__c){
                    List<String> messageIds = new List<String>();
                    messageIds.add(insertObject.Id);
                    CtrlMessageAPIKRDFW.MBKMessageDirectSender(messageIds);
                    if(TargetID.left(3) <> getObjectPrefix('Task')){
                        //log
                        CtrlMessageAPIKRDFW.MBKMessageLogging(messageIds);
                    }
                }
                gu.debug('[insertObject]'+insertObject);
            }

            gu.debug('['+Mtype+'] transfer has been requested.');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, '['+Mtype+'] transfer has been requested.'));
            IsSend = true;
        }catch(Exception e){
            Database.rollback(sp);
            gu.DebugException(e,userinfo.getUserId());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'System Error:'+e));
        }
        return null;
    }

    /* bulk Sending */
    public PageReference BulkSendingMessage(){
        // Create a savepoint
        Savepoint sp = Database.setSavepoint();
        GlobalUtilityDFW gu = GlobalUtilityDFW.getInstance();
        try{
            String SendTemplateId = Apexpages.currentPage().getParameters().get('SendTemplate');
            String messagebyte = Apexpages.currentPage().getParameters().get('messagebyte');
            //VC
            if(Mtype == 'KaKao' && (SendTemplateId == null || SendTemplateId == '')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No KaKaoTalk Template'));
                return null;
            }else{
                if(socLabel == 'Page Bulk Message'){
                    BulkMessage.Source_Object__c = 'Page';
                    BulkMessage.Source_Object_Id__c = pageBulkMessageId;
                }else{
                    BulkMessage = new MBK_Bulk_Message__c();
                    system.debug('TargetID : ' + TargetID);
                    system.debug('BulkMessage : ' + BulkMessage);
                    if(TargetID.left(3) == getObjectPrefix('Campaign')) BulkMessage.Source_Object__c = 'Campaign';
                    else if(TargetID.left(3) == getObjectPrefix('Survey__c')) BulkMessage.Source_Object__c = 'Survey__c';
                    BulkMessage.Source_Object_Id__c = TargetID;
                }
                if(SendTemplateId <> null && SendTemplateId <> ''){
                    Template__c setTemplate = retTemplatesOrg.get(SendTemplateId);
                    BulkMessage.Template_ID__c = setTemplate.Id;
                    BulkMessage.Template_Code__c = setTemplate.Template_ID__c;
                }
                BulkMessage.Set_Sending_Time__c = viewObject.Set_Sending_Time__c == null ? Datetime.now() : viewObject.Set_Sending_Time__c;
                BulkMessage.Message__c = viewObject.message__c;
                BulkMessage.Subject__c = viewObject.subject__c;
                Boolean AttachmentImages = false;
                if(mmsFile1.Name <> null || mmsFile2.Name <> null || mmsFile3.Name <> null){
                    AttachmentImages = true;
                }
                if(Mtype == 'KaKao') BulkMessage.channel__c = system.label.MBK_Message_Channel_KaKao;
                else if(Mtype == 'SMS/MMS'){
                    if((messagebyte <> null && integer.valueOf(messagebyte) > 80) || AttachmentImages){
                        BulkMessage.channel__c = system.label.MBK_Message_Channel_MMS;
                    }else{
                        BulkMessage.channel__c = system.label.MBK_Message_Channel_SMS;
                    }
                }

                upsert BulkMessage;
                if(BulkMessage.channel__c == 'M'){
                    //MMS파일 처리(Attachment)
                    List<Attachment> insertAttachments = new List<Attachment>();
                    if(mmsFile1.Name <> null){
                        mmsFile1.ParentId = BulkMessage.Id;
                        insertAttachments.add(mmsFile1);
                    }
                    if(mmsFile2.Name <> null){
                        mmsFile2.ParentId = BulkMessage.Id;
                        insertAttachments.add(mmsFile2);
                    }
                    if(mmsFile3.Name <> null){
                        mmsFile3.ParentId = BulkMessage.Id;
                        insertAttachments.add(mmsFile3);
                    }
                    if(insertAttachments.size() > 0){
                        insert insertAttachments;
                        mmsFile1 = new Attachment();
                        mmsFile2 = new Attachment();
                        mmsFile3 = new Attachment();
                    }
                }
            }
            //대량발송 전송데이터 생성 Batch 실행
            MBKBulkMessageCreateKRDFWBatch bulkBatch = new MBKBulkMessageCreateKRDFWBatch();
            if(BulkMessage.Source_Object__c == 'Page'){
                bulkBatch.batchId = BulkMessage.Id;
                bulkBatch.batchType = 'Page';
            }else{
                bulkBatch.batchId = BulkMessage.Id;
                bulkBatch.batchType = BulkMessage.Source_Object__c;
            }
            database.executeBatch(bulkBatch);

            gu.debug('['+Mtype+'] transfer has been requested.');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, 'Bulk ['+Mtype+'] transfer has been requested.'));
            IsSend = true;
            return null;
        }catch(Exception e){
            Database.rollback(sp);
            system.debug(userinfo.getUserId());
            gu.DebugException(e,userinfo.getUserId());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'System Error : '+e));
        }
        return null;
    }

    /* Message update */
    public PageReference updateMessage(){
        // Create a savepoint
        Savepoint sp = Database.setSavepoint();
        GlobalUtilityDFW gu = GlobalUtilityDFW.getInstance();
        try{
            SendTemplateId = Apexpages.currentPage().getParameters().get('SendTemplate');
            String messagebyte = Apexpages.currentPage().getParameters().get('messagebyte');
            //VC
            if(Mtype == 'KaKao' && (SendTemplateId == null || SendTemplateId == '')){
                gu.debug('No KaKaoTalk Template');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, 'No KaKaoTalk Template'));
                return null;
            }else{
                //Sending Object Field Setting
                if(SendTemplateId <> null && SendTemplateId <> ''){
                    //MBK_Message_Template__c setTemplate = retTemplates.get(SendTemplateId);
                    Template__c setTemplate = retTemplatesOrg.get(SendTemplateId);
                    viewObject.MBKMessageTemplate__c = setTemplate.Id;
                    viewObject.templateCode__c = setTemplate.Template_ID__c;
                }

                if(Mtype == 'KaKao') viewObject.channel__c = system.label.MBK_Message_Channel_KaKao;
                else if(Mtype == 'SMS/MMS'){
                    if(messagebyte <> null && integer.valueOf(messagebyte) > 80){
                        viewObject.channel__c = system.label.MBK_Message_Channel_MMS;
                    }else{
                        viewObject.channel__c = system.label.MBK_Message_Channel_SMS;
                    }
                }

                viewObject.message__c = setChangeStr(viewObject, dealerId);
                viewObject.currentCallerId__c = CallerId; //grant
                viewObject.custGubun__c  = system.label.MBK_Message_custGubun;
                //MMS파일 처리(Attachment)
                if(mmsFile1.Name <> null || mmsFile2.Name <> null || mmsFile3.Name <> null){
                    viewObject.AttachmentImages__c = true;
                }
                viewObject.senderKey__c = system.label.MBK_Message_SenderKey;

                //Send
                List<MBK_Messages__c> sendObjects = new List<MBK_Messages__c>();
                sendObjects.add(viewObject);
                update sendObjects;
                List<Attachment> insertAttachments = new List<Attachment>();
                if(mmsFile1.Name <> null){
                    mmsFile1.ParentId = viewObject.Id;
                    insertAttachments.add(mmsFile1);
                }
                if(mmsFile2.Name <> null){
                    mmsFile2.ParentId = viewObject.Id;
                    insertAttachments.add(mmsFile2);
                }
                if(mmsFile3.Name <> null){
                    mmsFile3.ParentId = viewObject.Id;
                    insertAttachments.add(mmsFile3);
                }

                //Mtype변경시 이미지가 있으면 삭제
                if(Mtype <> 'MMS'){
                    List<Attachment> delImgs = [SELECT Id FROM Attachment WHERE ParentId =: viewObject.Id];
                    if(delImgs.size() > 0) delete delImgs;
                }

                if(insertAttachments.size() > 0){
                    insert insertAttachments;
                    mmsFile1 = new Attachment();
                    mmsFile2 = new Attachment();
                    mmsFile3 = new Attachment();
                }

                viewObject = [SELECT Account__c, Account_Name__c, Case__c, KaKaoTalk_ID__c, IsModify__c, CampaignMember__c,
                                    Leads__c, MBKMessageTemplate__c, Name, Id, Set_Sending_Time__c, Status__c, UCID__c, altCode__c ,
                                    altMsg__c, channel__c, code__c, custGubun__c, AttachmentImages__c, message__c, phoneNum__c,
                                    processed__c, reqDtm__c, senderKey__c, sn__c, sndDtm__c, subject__c, templateCode__c,
                                    Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Personal_Abroad_Agreement__c,
                                    Agreement_to_commit_info_processing__c, Opt_In_SMS__c, currentCallerId__c
                                FROM MBK_Messages__c WHERE Id =: viewObject.Id];

                if(!viewObject.IsModify__c){
                    List<String> messageIds = new List<String>();
                    messageIds.add(viewObject.Id);
                    CtrlMessageAPIKRDFW.MBKMessageDirectSender(messageIds);
                    if(TargetID.left(3) <> getObjectPrefix('Task')){
                        //log
                        CtrlMessageAPIKRDFW.MBKMessageLogging(messageIds);
                    }
                }
            }

            gu.debug('['+Mtype+'] transfer has been requested.');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, '['+Mtype+'] transfer has been requested.'));
            return null;
        }catch(Exception e){
            Database.rollback(sp);
            gu.DebugException(e,userinfo.getUserId());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'System Error : '+e));
        }
        return null;
    }

    private String setChangeStr(MBK_Messages__c MBKmessage, String ids){
        String message = MBKmessage.message__c;
        if(MBKmessage <> null && MBKmessage.message__c <> null){
            if(MBKmessage.Account_Name__c <> null && MBKmessage.Account_Name__c <> '') message = message.replaceAll('#\\{고객명\\}',MBKmessage.Account_Name__c);  //고객명
            message = message.replaceAll('#\\{회사명\\}', '메르세데스 벤츠 코리아');

            if(MBKmessage.templateCode__c == 'benz_01' && tlead.Appointment_DateTime__c <> null){
                String resDate = String.valueOf( tlead.Appointment_DateTime__c.format('YYYY년 MM월 dd일 HH시mm분')  );
                message = message.replaceAll('#\\{예약시간\\}', resDate);  // #{예약시간}
            }
            if(MBKmessage.templateCode__c == 'benz_02' && tlead.Requested_Service_DateTime1__c <> null || tlead.Requested_Service_DateTime2__c <> null){
                String resDate = '';
                if(tlead.Requested_Service_DateTime1__c <> null) resDate = String.valueOf( tlead.Requested_Service_DateTime1__c.format('YYYY년 MM월 dd일 HH시mm분')  );
                else if(tlead.Requested_Service_DateTime2__c <> null) resDate = String.valueOf( tlead.Requested_Service_DateTime2__c.format('YYYY년 MM월 dd일 HH시mm분')  );
                message = message.replaceAll('#\\{예약시간\\}', resDate);  // #{예약시간}
            }

            if(MBKmessage.templateCode__c == 'benz_06'){
                List<Vehicle_Relationship__c> Vehicles = [SELECT Vehicle_Model__c FROM Vehicle_Relationship__c WHERE Contact__c =: AccountId ];
                message = message.replaceAll('#\\{고객센터\\}', system.label.MBK_Message_Sender_Phone);  // #{고객센터}
                if(Vehicles.size() > 0) message = message.replaceAll('#\\{모델명\\}', Vehicles[0].Vehicle_Model__c);  // #{고객센터}
            }

            if(ids <> '' && ids <> null){
                List<Account> accs = [SELECT Id, Name, Dealer_Address_CN__c FROM Account WHERE Id =: ids];
                if(accs.size() > 0){
                    Account acc = accs[0];
                    if(loginUser.Profile.Name.contains('MBK')){
                        if(acc.Name <> null && acc.Name <> '') message = message.replaceAll('#\\{회사명\\}', acc.Name);   //회사명
                    }else message = message.replaceAll('#\\{회사명\\}', '메르세데스 벤츠 코리아');   //회사명
                    if(acc.Dealer_Address_CN__c <> null && acc.Dealer_Address_CN__c <> '') message = message.replaceAll('#\\{센터주소\\}', acc.Dealer_Address_CN__c);  //센터주소
                    if(acc.Name <> null && acc.Name <> '') message = message.replaceAll('#\\{센터명\\}', acc.Name);  //센터명
                    if(acc.Dealer_Address_CN__c <> null && acc.Dealer_Address_CN__c <> '') message = message.replaceAll('#\\{전시장주소\\}', acc.Dealer_Address_CN__c);  //전시장주소
                }
            }
        }
        return message;
    }
}