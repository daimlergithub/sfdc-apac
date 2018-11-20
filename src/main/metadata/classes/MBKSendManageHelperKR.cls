/**
 * Created by user on 2018-06-21.
 */

public class MBKSendManageHelperKR {
    private static User helperUser;
    public class Times{
        public Integer pre;
        public Integer post;

        public Times(Integer a, Integer b){
            pre = a;
            post = b;
        }
    }

    private static User getMBKUser(){
        User temp =  [SELECT Id, Name, ContactId, Contact.Account.Name, Contact.Account.Dealer_Address_CN__c FROM User WHERE Id =: userinfo.getUserId()];
        return temp;
    }

    public static void insertUpdateMessageManage(List<MBKSendManage__c> LstnewMag){

        List<MBKSendManage__c> manageList = [SELECT Id, Name, Target_Object__c, SendTiming__c, PreviousHour__c, PreviousMinute__c, PostHour__c, PostMinute__c, Active__c, Record_Type__c, Update_Status__c FROM MBKSendManage__c];
        for(MBKSendManage__c newManage : LstnewMag) {
            String PreHour = newManage.PreviousHour__c;
            String PreMinute = newManage.PreviousMinute__c;

            if (PreMinute.length() == 1) PreMinute = '0' + PreMinute;
            String PostHour = newManage.PostHour__c;
            String PostMinute = newManage.PostMinute__c;
            if (PostMinute.length() == 1) PostMinute = '0' + PostMinute;

            for (MBKSendManage__c existManage : manageList) {
                String ePreHour = existManage.PreviousHour__c;
                String ePreMinute = existManage.PreviousMinute__c;

                if (ePreMinute.length() == 1) ePreMinute = '0' + ePreMinute;
                String ePostHour = existManage.PostHour__c;
                String ePostMinute = existManage.PostMinute__c;
                if (ePostMinute.length() == 1) ePostMinute = '0' + ePostMinute;

                if (((newManage.Target_Object__c == existManage.Target_Object__c) && (newManage.SendTiming__c == existManage.SendTiming__c)
                        && (newManage.Record_Type__c == existManage.Record_Type__c) && (newManage.Update_Status__c == existManage.Update_Status__c))) {
                    Integer preHm = Integer.valueOf(PreHour + PreMinute);
                    Integer postHm = Integer.valueOf(PostHour + PostMinute);
                    Integer ePreHm = Integer.valueOf(ePreHour + ePreMinute);
                    Integer ePostHm = Integer.valueOf(ePostHour + ePostMinute);

                    List<Times> newString = new List<Times>();
                    List<Times> exString = new List<Times>();

                    Boolean isDup = false;
                    if (preHm <= postHm) {
                        newString.add(new Times(preHm, postHm));
                    } else {
                        newString.add(new Times(preHm, 2359));
                        newString.add(new Times(0, postHm));
                    }
                    if (ePreHm <= ePostHm) {
                        exString.add(new Times(ePreHm, ePostHm));
                    } else {
                        exString.add(new Times(ePreHm, 2359));
                        exString.add(new Times(0, ePostHm));
                    }

                    for (Times newT : newString) {
                        for (Times exT : exString) {
                            if (!(exT.pre > newT.post || exT.post < newT.pre)) {
                                if(newManage.Id <> existManage.Id) newManage.addError('시간이 겹치는 조건이 존재합니다. 해당 조건의 이름 : ' + existManage.Name);
                            }
                        }
                    }
                }

            }

        }
    }

    public static void messageManageValidationCheck(List<String> objectIds, String objectName, String action){
        List<Lead__c> leads = new List<Lead__c>();
        List<Account> accounts = new List<Account>();
        List<Case> cases = new List<Case>();
        List<Task> tasks = new List<Task>();
        List<SurveyQuestionResponse__c> sqrList = new List<SurveyQuestionResponse__c>();
        Set<Id> attachIds = new Set<Id>();
        List<MBK_Messages__c> inseMessages = new List<MBK_Messages__c>();
        map<Id, Attachment> manAttachs = new map<Id, Attachment>();
        Datetime myDate = null;
        GlobalUtilityDFW gu = GlobalUtilityDFW.getInstance();
        List<MBKSendManage__c> sendManages = new List<MBKSendManage__c>();
        map<id, Template__c> retTemplatesOrg;
        If(objectIds.size() > 0) helperUser = getMBKUser();

        //발송 가능 시간 체크
        Datetime Dt = Datetime.now().addHours(9);
        String hr = String.valueOf(Dt.hour());
        String min = String.valueOf(Dt.minute());
        if (min.length() == 1) min = '0' + min;
        Integer nowHm = Integer.valueOf(hr + min);

        //각 개체의 데이터가 Manage에 포함되는지 체크
        if(objectName == 'Lead'){
            If(objectIds.size() > 0) {
                retTemplatesOrg = new map<Id, Template__c>([SELECT Id, Subject__c, Message_Detail__c, Template_ID__c, RecordType.Name
                                                FROM Template__c WHERE Active__c = true AND (RecordType.Name = 'KakaoTalk' Or RecordType.Name = 'SMS' Or RecordType.Name = 'MMS')]);
                sendManages = [SELECT Id, Name, Target_Object__c, SendTiming__c, PreviousHour__c, PreviousMinute__c, PostHour__c, PostMinute__c, Active__c, Template__c, SendType__c, Update_Status__c, Record_Type__c
                                FROM MBKSendManage__c WHERE Active__c = true AND SendTiming__c =: action AND Target_Object__c =: objectName];
                for(Template__c temp:retTemplatesOrg.values()){
                    if(temp.RecordType.Name == 'MMS') attachIds.add(temp.Id);
                }
                //MMS일 경우 파일 가져 오기
                List<Attachment> Attachments = [SELECT Id, Body, Name,ParentId FROM Attachment WHERE ParentId IN: attachIds];
                for(Attachment temp:Attachments){
                    manAttachs.put(temp.ParentId, temp);
                }
                //리밋 대비 초기화.
                Attachments = new List<Attachment>();

                leads = [
                        SELECT Id, Name, Contact__c, Contact__r.UCID__c, Contact__r.Mobile__c, Contact__r.Name, Contact__r.Opt_In_SMS__c, Contact__r.KaKao_Talk_ID__c, Contact__r.Personal_Agreement__c,
                                Contact__r.Personal_Information_Third_Party_Release__c, Contact__r.Personal_Abroad_Agreement__c, Contact__r.Agreement_to_commit_info_processing__c,
                                Lead_Latest_Phase__c, Dealer_Lead_Status__c, RecordType.Name, Assigned_Dealer__r.Name, Assigned_Dealer__r.Dealer_Address_CN__c, Appointment_DateTime__c, Requested_Service_DateTime1__c, Requested_Service_DateTime2__c
                        FROM Lead__c
                        WHERE Id IN:objectIds AND MD__c = 'KR'
                ];
            }
            for(MBKSendManage__c msm:sendManages){
                for(Lead__c lead:leads){
                    //발송조건 비교 후 발송조건 충족 하면 전송개체 생성.
                    //Insert조건 : action=Insert & Update_Status__c=Always & RecordType.Name
                    //Update조건 : action=Update & (Update_Status__c=Always || Update_Status__c) & RecordType.Name
                    Boolean isProcessed = false;
                    if(action == 'Insert'){
                        if(msm.Update_Status__c == 'Always' && (lead.RecordType.Name == msm.Record_Type__c)) isProcessed = true;
                    }else{
                        if(msm.Update_Status__c == 'Always' && (lead.RecordType.Name == msm.Record_Type__c)) isProcessed = true;
                        else if(msm.Update_Status__c == lead.Lead_Latest_Phase__c && lead.RecordType.Name == msm.Record_Type__c) isProcessed = true;
                        else if(msm.Update_Status__c == lead.Dealer_Lead_Status__c && lead.RecordType.Name == msm.Record_Type__c) isProcessed = true;
                    }

                    if(lead.RecordType.Name == msm.Record_Type__c){
                        Template__c setTemplate = retTemplatesOrg.get(msm.Template__c);
                        //현재 시간이 발송 시간안에 있으면 실시간 전송, 아님 예약 시간(내일 오전9시) 입력 후 전송
                        if (nowHm > Integer.valueOf(msm.PreviousHour__c + msm.PreviousMinute__c) && nowHm < Integer.valueOf(msm.PostHour__c + msm.PostMinute__c)) {
                            myDate = Dt;
                        } else {
                            Dt = Dt.addDays(1);
                            myDate = Datetime.newInstance(Dt.year(), Dt.month(), Dt.day(), 09, 00, 00);
                        }

                        Account acc = lead.Contact__r;
                        MBK_Messages__c viewObject = new MBK_Messages__c();
                        viewObject.Leads__c = lead.Id;
                        viewObject.Account_Name__c = acc.Name;
                        viewObject.Opt_In_SMS__c = acc.Opt_In_SMS__c;
                        viewObject.Personal_Agreement__c = acc.Personal_Agreement__c;
                        viewObject.Personal_Information_Third_Party_Release__c = acc.Personal_Information_Third_Party_Release__c;
                        viewObject.Personal_Abroad_Agreement__c = acc.Personal_Abroad_Agreement__c;
                        viewObject.Agreement_to_commit_info_processing__c = acc.Agreement_to_commit_info_processing__c;
                        viewObject.KaKaoTalk_ID__c = acc.KaKao_Talk_ID__c;
                        viewObject.UCID__c = acc.UCID__c;
                        viewObject.phoneNum__c = acc.Mobile__c;

                        viewObject.MBKMessageTemplate__c = setTemplate.Id;
                        viewObject.templateCode__c = setTemplate.Template_ID__c;

                        if(msm.SendType__c == 'KakaoTalk') viewObject.channel__c = system.label.MBK_Message_Channel_KaKao;
                        else if(msm.SendType__c == 'SMS') viewObject.channel__c = system.label.MBK_Message_Channel_SMS;
                        else if(msm.SendType__c == 'LMS') viewObject.channel__c = system.label.MBK_Message_Channel_LMS;
                        else if(msm.SendType__c == 'MMS'){
                            viewObject.AttachmentImages__c = true;
                            viewObject.channel__c = system.label.MBK_Message_Channel_MMS;
                        }
                        viewObject.message__c = setTemplate.Message_Detail__c;
                        viewObject.subject__c = setTemplate.Subject__c;

                        viewObject.message__c = setChangeStr(viewObject, lead.Assigned_Dealer__r.Name, lead.Assigned_Dealer__r.Dealer_Address_CN__c, lead.Appointment_DateTime__c, lead.Requested_Service_DateTime1__c, lead.Requested_Service_DateTime2__c);
                        viewObject.custGubun__c  = system.label.MBK_Message_custGubun;
                        viewObject.senderKey__c = system.label.MBK_Message_SenderKey;
                        viewObject.Status__c = 'Reserved';
                        viewObject.Set_Sending_Time__c = myDate;
                        viewObject.currentCallerId__c = system.label.MBK_Message_Sender_Phone;
                        inseMessages.add(viewObject);
                    }
                }
            }

        }else if(objectName == 'Account'){
            If(objectIds.size() > 0) {
                retTemplatesOrg = new map<Id, Template__c>([SELECT Id, Subject__c, Message_Detail__c, Template_ID__c, RecordType.Name
                                                FROM Template__c WHERE Active__c = true AND (RecordType.Name = 'KakaoTalk' Or RecordType.Name = 'SMS' Or RecordType.Name = 'MMS')]);
                sendManages = [SELECT Id, Name, Target_Object__c, SendTiming__c, PreviousHour__c, PreviousMinute__c, PostHour__c, PostMinute__c, Active__c, Template__c, SendType__c, Update_Status__c, Record_Type__c
                                FROM MBKSendManage__c WHERE Active__c = true AND SendTiming__c =: action AND Target_Object__c =: objectName];
                for(Template__c temp:retTemplatesOrg.values()){
                    if(temp.RecordType.Name == 'MMS') attachIds.add(temp.Id);
                }
                //MMS일 경우 파일 가져 오기
                List<Attachment> Attachments = [SELECT Id, Body, Name,ParentId FROM Attachment WHERE ParentId IN: attachIds];
                for(Attachment temp:Attachments){
                    manAttachs.put(temp.ParentId, temp);
                }
                //리밋 대비 초기화.
                Attachments = new List<Attachment>();

                accounts = [
                        SELECT Id, Name, UCID__c, Mobile__c, Opt_In_SMS__c, KaKao_Talk_ID__c, Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Personal_Abroad_Agreement__c,
                                Agreement_to_commit_info_processing__c, Status__c, RecordType.Name
                        FROM Account
                        WHERE Id IN:objectIds AND MD__c = 'KR'
                ];
            }
            for(MBKSendManage__c msm:sendManages) {
                for(Account acc:accounts){
                    //발송조건 비교 후 발송조건 충족 하면 전송개체 생성.
                    //Insert조건 : action=Insert & Update_Status__c=Always
                    //Update조건 : action=Update & (Update_Status__c=Always || Update_Status__c)
                    Boolean isProcessed = false;
                    if(action == 'Insert'){
                        if(msm.Update_Status__c == 'Always') isProcessed = true;
                    }else{
                        if(msm.Update_Status__c == 'Always') isProcessed = true;
                        else if(msm.Update_Status__c == acc.Status__c) isProcessed = true;
                    }

                    if(isProcessed)
                    {
                        Template__c setTemplate = retTemplatesOrg.get(msm.Template__c);
                        //현재 시간이 발송 시간안에 있으면 실시간 전송, 아님 예약 시간(내일 오전9시) 입력 후 전송
                        if (nowHm > Integer.valueOf(msm.PreviousHour__c + msm.PreviousMinute__c) && nowHm < Integer.valueOf(msm.PostHour__c + msm.PostMinute__c)) {
                            myDate = Dt;
                        } else {
                            Dt = Dt.addDays(1);
                            myDate = Datetime.newInstance(Dt.year(), Dt.month(), Dt.day(), 09, 00, 00);
                        }

                        MBK_Messages__c viewObject = new MBK_Messages__c();
                        viewObject.Account__c = acc.Id;
                        viewObject.Account_Name__c = acc.Name;
                        viewObject.Opt_In_SMS__c  = acc.Opt_In_SMS__c;
                        viewObject.Personal_Agreement__c = acc.Personal_Agreement__c;
                        viewObject.Personal_Information_Third_Party_Release__c = acc.Personal_Information_Third_Party_Release__c;
                        viewObject.Personal_Abroad_Agreement__c = acc.Personal_Abroad_Agreement__c;
                        viewObject.Agreement_to_commit_info_processing__c = acc.Agreement_to_commit_info_processing__c;
                        viewObject.KaKaoTalk_ID__c = acc.KaKao_Talk_ID__c;
                        viewObject.UCID__c = acc.UCID__c;
                        viewObject.phoneNum__c = acc.Mobile__c;

                        viewObject.MBKMessageTemplate__c = setTemplate.Id;
                        viewObject.templateCode__c = setTemplate.Template_ID__c;

                        if(msm.SendType__c == 'KakaoTalk') viewObject.channel__c = system.label.MBK_Message_Channel_KaKao;
                        else if(msm.SendType__c == 'SMS') viewObject.channel__c = system.label.MBK_Message_Channel_SMS;
                        else if(msm.SendType__c == 'LMS') viewObject.channel__c = system.label.MBK_Message_Channel_LMS;
                        else if(msm.SendType__c == 'MMS'){
                            viewObject.AttachmentImages__c = true;
                            viewObject.channel__c = system.label.MBK_Message_Channel_MMS;
                        }
                        viewObject.message__c = setTemplate.Message_Detail__c;
                        viewObject.subject__c = setTemplate.Subject__c;

                        String DealerName = null;
                        if(helperUser.ContactId <> null) DealerName = helperUser.Contact.Account.Name;
                        String DealerAddress = null;
                        if(helperUser.ContactId <> null) DealerAddress = helperUser.Contact.Account.Dealer_Address_CN__c;

                        viewObject.message__c = setChangeStr(viewObject, DealerName, DealerAddress, null, null, null);
                        viewObject.custGubun__c  = system.label.MBK_Message_custGubun;
                        viewObject.senderKey__c = system.label.MBK_Message_SenderKey;
                        viewObject.Status__c = 'Reserved';
                        viewObject.Set_Sending_Time__c = myDate;
                        viewObject.currentCallerId__c = system.label.MBK_Message_Sender_Phone;
                        inseMessages.add(viewObject);
                    }
                }
            }
        }else if(objectName == 'Case'){
            If(objectIds.size() > 0) {
                retTemplatesOrg = new map<Id, Template__c>([SELECT Id, Subject__c, Message_Detail__c, Template_ID__c, RecordType.Name
                                                FROM Template__c WHERE Active__c = true AND (RecordType.Name = 'KakaoTalk' Or RecordType.Name = 'SMS' Or RecordType.Name = 'MMS')]);
                sendManages = [SELECT Id, Name, Target_Object__c, SendTiming__c, PreviousHour__c, PreviousMinute__c, PostHour__c, PostMinute__c, Active__c, Template__c, SendType__c, Update_Status__c, Record_Type__c
                                FROM MBKSendManage__c WHERE Active__c = true AND SendTiming__c =: action AND Target_Object__c =: objectName];
                for(Template__c temp:retTemplatesOrg.values()){
                    if(temp.RecordType.Name == 'MMS') attachIds.add(temp.Id);
                }
                //MMS일 경우 파일 가져 오기
                List<Attachment> Attachments = [SELECT Id, Body, Name,ParentId FROM Attachment WHERE ParentId IN: attachIds];
                for(Attachment temp:Attachments){
                    manAttachs.put(temp.ParentId, temp);
                }
                //리밋 대비 초기화.
                Attachments = new List<Attachment>();

                cases = [
                        SELECT Id, Contact.Account.Id, Contact.Account.UCID__c, Contact.Account.Mobile__c, Contact.Account.Name, Contact.Account.Opt_In_SMS__c, Contact.Account.KaKao_Talk_ID__c,
                                Contact.Account.Personal_Agreement__c, Contact.Account.Personal_Information_Third_Party_Release__c, Contact.Account.Personal_Abroad_Agreement__c, Contact.Account.Agreement_to_commit_info_processing__c,
                                Status, RecordType.Name, Case_Dealer__r.Name, Case_Dealer__r.Dealer_Address_CN__c, Case_Dealer__c
                        FROM Case
                        WHERE Id IN:objectIds AND MD__c = 'KR'
                ];
            }
            for(MBKSendManage__c msm:sendManages) {
                for(Case temp:cases){
                    //발송조건 비교 후 발송조건 충족 하면 전송개체 생성.
                    //Insert조건 : action=Insert & Update_Status__c=Always & RecordType.Name
                    //Update조건 : action=Update & (Update_Status__c=Always || Update_Status__c) & RecordType.Name
                    Boolean isProcessed = false;
                    if(action == 'Insert'){
                        if(msm.Update_Status__c == 'Always' && (temp.RecordType.Name == msm.Record_Type__c)) isProcessed = true;
                    }else{
                        if(msm.Update_Status__c == 'Always' && (temp.RecordType.Name == msm.Record_Type__c)) isProcessed = true;
                        else if(msm.Update_Status__c == temp.Status && temp.RecordType.Name == msm.Record_Type__c) isProcessed = true;
                    }

                    if(isProcessed)
                    {
                        Template__c setTemplate = retTemplatesOrg.get(msm.Template__c);
                        //현재 시간이 발송 시간안에 있으면 실시간 전송, 아님 예약 시간(내일 오전9시) 입력 후 전송
                        if (nowHm > Integer.valueOf(msm.PreviousHour__c + msm.PreviousMinute__c) && nowHm < Integer.valueOf(msm.PostHour__c + msm.PostMinute__c)) {
                            myDate = Dt;
                        } else {
                            Dt = Dt.addDays(1);
                            myDate = Datetime.newInstance(Dt.year(), Dt.month(), Dt.day(), 09, 00, 00);
                        }

                        Account acc = temp.Contact.Account;
                        MBK_Messages__c viewObject = new MBK_Messages__c();
                        viewObject.Case__c = temp.Id;
                        viewObject.Account_Name__c = acc.Name;
                        viewObject.Opt_In_SMS__c  = acc.Opt_In_SMS__c;
                        viewObject.Personal_Agreement__c = acc.Personal_Agreement__c;
                        viewObject.Personal_Information_Third_Party_Release__c = acc.Personal_Information_Third_Party_Release__c;
                        viewObject.Personal_Abroad_Agreement__c = acc.Personal_Abroad_Agreement__c;
                        viewObject.Agreement_to_commit_info_processing__c = acc.Agreement_to_commit_info_processing__c;
                        viewObject.KaKaoTalk_ID__c = acc.KaKao_Talk_ID__c;
                        viewObject.UCID__c = acc.UCID__c;
                        viewObject.phoneNum__c = acc.Mobile__c;

                        viewObject.MBKMessageTemplate__c = setTemplate.Id;
                        viewObject.templateCode__c = setTemplate.Template_ID__c;

                        if(msm.SendType__c == 'KakaoTalk') viewObject.channel__c = system.label.MBK_Message_Channel_KaKao;
                        else if(msm.SendType__c == 'SMS') viewObject.channel__c = system.label.MBK_Message_Channel_SMS;
                        else if(msm.SendType__c == 'LMS') viewObject.channel__c = system.label.MBK_Message_Channel_LMS;
                        else if(msm.SendType__c == 'MMS'){
                            viewObject.AttachmentImages__c = true;
                            viewObject.channel__c = system.label.MBK_Message_Channel_MMS;
                        }
                        viewObject.message__c = setTemplate.Message_Detail__c;
                        viewObject.subject__c = setTemplate.Subject__c;

                        viewObject.message__c = setChangeStr(viewObject, temp.Case_Dealer__r.Name, temp.Case_Dealer__r.Dealer_Address_CN__c, null, null, null);
                        viewObject.custGubun__c  = system.label.MBK_Message_custGubun;
                        viewObject.senderKey__c = system.label.MBK_Message_SenderKey;
                        viewObject.Status__c = 'Reserved';
                        viewObject.Set_Sending_Time__c = myDate;
                        viewObject.currentCallerId__c = system.label.MBK_Message_Sender_Phone;
                        inseMessages.add(viewObject);
                    }
                }
            }
        }else if(objectName == 'Task') {
            If(objectIds.size() > 0) {
                retTemplatesOrg = new map<Id, Template__c>([SELECT Id, Subject__c, Message_Detail__c, Template_ID__c, RecordType.Name
                                                FROM Template__c WHERE Active__c = true AND (RecordType.Name = 'KakaoTalk' Or RecordType.Name = 'SMS' Or RecordType.Name = 'MMS')]);
                sendManages = [SELECT Id, Name, Target_Object__c, SendTiming__c, PreviousHour__c, PreviousMinute__c, PostHour__c, PostMinute__c, Active__c, Template__c, SendType__c, Update_Status__c, Record_Type__c
                                FROM MBKSendManage__c WHERE Active__c = true AND SendTiming__c =: action AND Target_Object__c =: objectName];
                for(Template__c temp:retTemplatesOrg.values()){
                    if(temp.RecordType.Name == 'MMS') attachIds.add(temp.Id);
                }
                //MMS일 경우 파일 가져 오기
                List<Attachment> Attachments = [SELECT Id, Body, Name,ParentId FROM Attachment WHERE ParentId IN: attachIds];
                for(Attachment temp:Attachments){
                    manAttachs.put(temp.ParentId, temp);
                }
                //리밋 대비 초기화.
                Attachments = new List<Attachment>();

                tasks = [SELECT Id, UCID__c, Phone__c, Account_Name__c, Status__c, Status, Subject, RecordType.Name FROM Task WHERE Id IN:objectIds AND MD__c = 'KR'];
            }
            for(MBKSendManage__c msm:sendManages) {
                for(Task temp:tasks){
                    //발송조건 비교 후 발송조건 충족 하면 전송개체 생성.
                    if(temp.Phone__c <> null) { //메시지 로그는 발송 안함.
                        //Insert조건 : action=Insert & Update_Status__c=Always
                        //Update조건 : action=Update & (Update_Status__c=Always || Update_Status__c)
                        Boolean isProcessed = false;
                        if(action == 'Insert'){
                            if(msm.Update_Status__c == 'Always') isProcessed = true;
                        }else{
                            if(msm.Update_Status__c == 'Always') isProcessed = true;
                            else if(msm.Update_Status__c == temp.Status__c) isProcessed = true;
                        }

                        if (isProcessed) {
                            Template__c setTemplate = retTemplatesOrg.get(msm.Template__c);
                            //현재 시간이 발송 시간안에 있으면 실시간 전송, 아님 예약 시간(내일 오전9시) 입력 후 전송
                            if (nowHm > Integer.valueOf(msm.PreviousHour__c + msm.PreviousMinute__c) && nowHm < Integer.valueOf(msm.PostHour__c + msm.PostMinute__c)) {
                                myDate = Dt;
                            } else {
                                Dt = Dt.addDays(1);
                                myDate = Datetime.newInstance(Dt.year(), Dt.month(), Dt.day(), 09, 00, 00);
                            }

                            MBK_Messages__c viewObject = new MBK_Messages__c();
                            viewObject.Account_Name__c = temp.Account_Name__c;
                            viewObject.UCID__c = temp.UCID__c;
                            viewObject.phoneNum__c = temp.Phone__c;

                            viewObject.MBKMessageTemplate__c = setTemplate.Id;
                            viewObject.templateCode__c = setTemplate.Template_ID__c;

                            if (msm.SendType__c == 'KakaoTalk') viewObject.channel__c = system.label.MBK_Message_Channel_KaKao;
                            else if (msm.SendType__c == 'SMS') viewObject.channel__c = system.label.MBK_Message_Channel_SMS;
                            else if (msm.SendType__c == 'LMS') viewObject.channel__c = system.label.MBK_Message_Channel_LMS;
                            else if(msm.SendType__c == 'MMS'){
                                viewObject.AttachmentImages__c = true;
                                viewObject.channel__c = system.label.MBK_Message_Channel_MMS;
                            }
                            viewObject.message__c = setTemplate.Message_Detail__c;
                            viewObject.subject__c = setTemplate.Subject__c;

                            viewObject.message__c = setChangeStr(viewObject, '','',null, null, null);
                            viewObject.custGubun__c = system.label.MBK_Message_custGubun;
                            viewObject.senderKey__c = system.label.MBK_Message_SenderKey;
                            viewObject.Status__c = 'Reserved';
                            viewObject.Set_Sending_Time__c = myDate;
                            viewObject.currentCallerId__c = system.label.MBK_Message_Sender_Phone;
                            inseMessages.add(viewObject);
                        }
                    }
                }
            }
        }
        if(inseMessages.size() > 0) {
            insert inseMessages;
            //MMS이미지 연결
            List<Attachment> insertAttachments = new List<Attachment>();
            for (MBK_Messages__c temp : inseMessages) {
                if (temp.channel__c == system.label.MBK_Message_Channel_MMS) {
                    Attachment tmpAttach = manAttachs.get(temp.MBKMessageTemplate__c).clone();
                    tmpAttach.ParentId = temp.Id;
                    insertAttachments.add(tmpAttach);
                }
            }
            if (insertAttachments.size() > 0) {
                insert insertAttachments;
                insertAttachments = new List<Attachment>();
            }
            List<String> messageIds = new List<String>();
            for (MBK_Messages__c temp : inseMessages) {
                messageIds.add(temp.Id);
            }
            CtrlMessageAPIKRDFW.MBKMessageDirectSender(messageIds);
            if (objectName == 'Task') {
                CtrlMessageAPIKRDFW.MBKMessageLogging(messageIds);
            }
        }
    }

    private static String setChangeStr(MBK_Messages__c MBKmessage, String DealerName, String DealerAddress, DateTime Appointment_DateTime, Datetime Requested_Service_DateTime1, Datetime Requested_Service_DateTime2){

        String message = MBKmessage.message__c;
        if(MBKmessage <> null && MBKmessage.message__c <> null){
            if(MBKmessage.Account_Name__c <> null && MBKmessage.Account_Name__c <> '') message = message.replaceAll('#\\{고객명\\}',MBKmessage.Account_Name__c);  //고객명
            message = message.replaceAll('#\\{회사명\\}', '메르세데스 벤츠 코리아');

            if(helperUser.ContactId <> null){
                if(DealerName <> null && DealerName <> '') message = message.replaceAll('#\\{회사명\\}', DealerName);   //회사명
            }
            if(DealerAddress <> null && DealerAddress <> '') message = message.replaceAll('#\\{센터주소\\}', DealerAddress);  //센터주소
            if(DealerName <> null && DealerName <> '') message = message.replaceAll('#\\{센터명\\}', DealerName);  //센터명
            if(DealerAddress <> null && DealerAddress <> '') message = message.replaceAll('#\\{전시장주소\\}', DealerAddress);  //전시장주소

            if(MBKmessage.templateCode__c == 'benz_01' && Appointment_DateTime <> null){
                String resDate = String.valueOf( Appointment_DateTime.format('YYYY년 MM월 dd일 HH시mm분')  );
                message = message.replaceAll('#\\{예약시간\\}', resDate);  // #{예약시간}
            }
            if(MBKmessage.templateCode__c == 'benz_02' && Requested_Service_DateTime1 <> null || Requested_Service_DateTime2 <> null){
                String resDate = '';
                if(Requested_Service_DateTime1 <> null) resDate = String.valueOf( Requested_Service_DateTime1.format('YYYY년 MM월 dd일 HH시mm분')  );
                else if(Requested_Service_DateTime2 <> null) resDate = String.valueOf(Requested_Service_DateTime2.format('YYYY년 MM월 dd일 HH시mm분')  );
                message = message.replaceAll('#\\{예약시간\\}', resDate);  // #{예약시간}
            }
        }
        return message;
    }


}