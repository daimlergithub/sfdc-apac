/**
* Class Name  : KakaoTalkBatch.cls
* Author     : Infosys Ltd.
* Date          : 2018.10.22
* Description : Automating the process of sending messages(Kakao/MMS) to the end-user.
*/
global class KakaoTalkBatch implements Database.Batchable<sObject>,Database.AllowsCallouts  {
    public String SendTemplateId;
    public String dealerId;
    public String CallerId;
    private map<Id, Template__c> retTemplatesOrg;
    private map<Id, Booking__c> retbookings;
    private map<Id, Vehicle_Relationship__c> retVehicles;
    private map<Id, Account> retAccounts;
    private map<Id, MBK_Messages__c> sendObjects;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String query = 'SELECT Account__c, Account_Name__c, Case__c, KaKaoTalk_ID__c, IsModify__c, CampaignMember__c, '+
            'Leads__c, MBKMessageTemplate__c, Name, Id, Set_Sending_Time__c, Status__c, UCID__c, altCode__c , '+
            'altMsg__c, channel__c, code__c, custGubun__c, AttachmentImages__c, message__c, phoneNum__c, '+
            'processed__c, reqDtm__c, senderKey__c, sn__c, sndDtm__c, subject__c, templateCode__c, '+
            'Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Personal_Abroad_Agreement__c, Booking__c, '+
            'Agreement_to_commit_info_processing__c,Attachment1__c,Opt_In_SMS__c, currentCallerId__c FROM MBK_Messages__c WHERE MarketingCloud__c =TRUE AND Status__c=\'\' AND CREATEDDATE = LAST_N_DAYS:1';       
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<MBK_Messages__c> scope) {
        
        GlobalUtilityDFW gu = GlobalUtilityDFW.getInstance();
        dealerId = '';
        try{
            List<String> messageIds = new List<String>();
            sendObjects =new Map<Id,MBK_Messages__c>();
            
            TypeOfTemplates();
            List<Id> bookings = new List<Id>();
            List<Id> vehicles = new List<Id>();
            List<Id> accounts = new List<Id>();
            for(MBK_Messages__c temp:scope){
                if(temp.Booking__c<>null){
                    bookings.add(temp.Booking__c);
                }
                if(temp.Account__c<>null){
                    accounts.add(temp.Account__c);
                }
            }
             retbookings = new map<Id, Booking__c>([SELECT BookingDateTimeFrom__c FROM Booking__c  WHERE Id IN:bookings]);
            retVehicles = new map<Id, Vehicle_Relationship__c>([SELECT Vehicle_Model__c FROM Vehicle_Relationship__c WHERE Contact__c IN :accounts]);
            retAccounts = new map<Id, Account>([SELECT Id, Name, Dealer_Address_CN__c FROM Account WHERE Id IN :accounts]);
            for(MBK_Messages__c temp:scope){                                                                                                                                    
                SendTemplateId = temp.MBKMessageTemplate__c;
                if(SendTemplateId <> null && SendTemplateId <> ''){  
                    Template__c setTemplate = retTemplatesOrg.get(SendTemplateId);
                    temp.templateCode__c = setTemplate.Template_ID__c;
                    temp.message__c=setTemplate.Message_Detail__c;
                    temp.subject__c=setTemplate.Subject__c;
                }
                String messagebyte = temp.message__c;
                dealerId=temp.Account__c;
                temp.message__c = setChangeStr(temp,dealerId);
                temp.currentCallerId__c = CallerId; 
                temp.custGubun__c  = system.label.MBK_Message_custGubun;
                //MMS(Attachment)
                
                temp.senderKey__c = system.label.MBK_Message_SenderKey;
                temp.Status__c = 'Reserved';
                if(temp.Set_Sending_Time__c == null) temp.Set_Sending_Time__c = Datetime.now();
                //Send
                sendObjects.put(temp.Id,temp);
                
                if(!temp.IsModify__c){ 
                    messageIds.add(temp.Id);
                    
                }
            
           
        }
        
        if(messageIds.size() > 0){
            MBKMessageDirectSender(messageIds,sendObjects);
        }
        
    }catch(Exception e){
        gu.DebugException(e,userinfo.getUserId());
    }
}
global void finish(Database.BatchableContext bc) {
}

private String setChangeStr(MBK_Messages__c MBKmessage,String ids){
    
    String message = MBKmessage.message__c;
    if(MBKmessage <> null && MBKmessage.message__c <> null){
        if(MBKmessage.Account_Name__c <> null && MBKmessage.Account_Name__c <> '') message = message.replaceAll('#\\{고객명\\}',MBKmessage.Account_Name__c);   //???
        message = message.replaceAll('#\\{회사명\\}', '메르세데스 벤츠 코리아');
        
        if(MBKmessage.templateCode__c == 'benz_01'){
            Booking__c booking = retbookings.get(MBKmessage.Booking__c);
            if(booking <> null){
            String resDate = String.valueOf(booking.BookingDateTimeFrom__c.format('YYYY년 MM월 dd일 HH시mm분'));
            message = message.replaceAll('#\\{예약시간\\}', resDate);  //#{Reservation Time}
        }    
        }
        
        if(MBKmessage.templateCode__c == 'benz_06'){
            Vehicle_Relationship__c vehicle= retVehicles.get(MBKmessage.Account__c);
            if(vehicle <> null){
            message = message.replaceAll('#\\{고객센터\\}', system.label.MBK_Message_Sender_Phone);  //#{Service center}
            message = message.replaceAll('#\\{모델명\\}', vehicle.Vehicle_Model__c);   
        }
        }
        if(ids <> '' && ids <> null){
            Account acc= retAccounts.get(ids);
            if(acc<> null){
            if(acc.Dealer_Address_CN__c <> null && acc.Dealer_Address_CN__c <> '') message = message.replaceAll('#\\{센터주소\\}', acc.Dealer_Address_CN__c);  
            if(acc.Name <> null && acc.Name <> '') message = message.replaceAll('#\\{센터명\\}', acc.Name); 
            if(acc.Dealer_Address_CN__c <> null && acc.Dealer_Address_CN__c <> '') message = message.replaceAll('#\\{전시장주소\\}', acc.Dealer_Address_CN__c);   
            
            }
        }
    }
    return message;
}


/* get Message Templates */
public void TypeOfTemplates() {
    String query = 'SELECT Id, Subject__c, Message_Detail__c, Template_ID__c, RecordType.Name '
        + 'FROM Template__c WHERE Active__c = true AND (RecordType.Name =\'KakaoTalk\' Or RecordType.Name = \'SMS\' Or RecordType.Name = \'MMS\') ';
    List<Template__c> temps = Database.query(query);
    retTemplatesOrg = new map<Id, Template__c>();
    
    for(Template__c temp:temps){
        retTemplatesOrg.put(temp.Id, temp);
    }
}

public static void MBKMessageDirectSender(List<Id>MessageIds, Map<Id,MBK_Messages__c> MsgToSend){
    map<Id, MBK_Messages__c> mapMBKs = new map<Id, MBK_Messages__c>([SELECT Account__c, Account_Name__c, Case__c, KaKaoTalk_ID__c, CampaignMember__c,  
                                                                     Leads__c, MBKMessageTemplate__c, Name, Id, Set_Sending_Time__c, Status__c, UCID__c, altCode__c ,
                                                                     altMsg__c, channel__c, code__c, custGubun__c, AttachmentImages__c, message__c, phoneNum__c, Attachment1__c,Attachment2__c, Attachment3__c,
                                                                     processed__c, reqDtm__c, senderKey__c, sn__c, sndDtm__c, subject__c, templateCode__c, currentCallerId__c
                                                                     FROM MBK_Messages__c WHERE Id IN: MessageIds]);
    List<MBK_Messages__c> MBKMessages = mapMBKs.values();
    List<MBK_Messages__c> MBKMsgs = MsgToSend.values();
    map<Id, List<Attachment>> messageImages = new map<Id, List<Attachment>>();
    List<Id> attachmentIds=new List<Id>();
    for(MBK_Messages__c mbkMsg:MBKMessages){
        if(mbkMsg.Attachment1__c<>null){
            attachmentIds.add(mbkMsg.Attachment1__c);
        }
        if(mbkMsg.Attachment2__c<>null){
            attachmentIds.add(mbkMsg.Attachment2__c);
        }
        if(mbkMsg.Attachment3__c<>null){
            attachmentIds.add(mbkMsg.Attachment3__c);
        }
    }
    
    List<Attachment> tempList = null;
    map<Id, Attachment> attIdToAttachment = new map<Id, Attachment>([SELECT Id, Body, Name FROM Attachment WHERE Id IN: attachmentIds]);    
    for(MBK_Messages__c mbkMsg:MBKMessages){
        if(messageImages.containsKey(mbkMsg.Id)){   
            Attachment att1 = attIdToAttachment.get(mbkMsg.Attachment1__c);
            Attachment att2 = attIdToAttachment.get(mbkMsg.Attachment2__c);
            Attachment att3 = attIdToAttachment.get(mbkMsg.Attachment3__c);
            if (att1<>null){
                messageImages.get(mbkMsg.id).add(att1);
            }
            if (att2<>null){
                messageImages.get(mbkMsg.id).add(att2);
            }
            if (att3<>null){
                messageImages.get(mbkMsg.id).add(att3);
            }
        }else
        {
            tempList = new List<Attachment>();
            Attachment att1 = attIdToAttachment.get(mbkMsg.Attachment1__c);
            Attachment att2 = attIdToAttachment.get(mbkMsg.Attachment2__c);
            Attachment att3 = attIdToAttachment.get(mbkMsg.Attachment3__c);
            if (att1<>null){
                tempList.add(att1);
            }
            if (att2<>null){
                tempList.add(att2);
            }
            if (att3<>null){
                tempList.add(att3);
            }
            messageImages.put(mbkMsg.id,tempList);
        }
    }
    
    Http       http  = new Http();
    HttpRequest     req    = new HttpRequest();
    HttpResponse   res    = new HttpResponse();
    String       errMsg  = '';
    String dataJson = '';
    String smsSndNum = '';
    
    JSONGenerator g = JSON.createGenerator(true);
    g.writeStartArray();
    for(MBK_Messages__c MBK:MBKMessages){
        MBK.Status__c = 'Send';
        List<Attachment> MBKAtts = messageImages.get(MBK.Id);
        Datetime myDT = Datetime.now();
        String myDate = myDT.format('YYYYMMddHHmmss');          
        g.writeStartObject();
        
        if(MBK.currentCallerId__c == '' || MBK.currentCallerId__c == null) smsSndNum = system.label.MBK_Message_Sender_Phone;     //발송번호
        else smsSndNum = MBK.currentCallerId__c;
        MBK_Messages__c msg=MsgToSend.get(MBK.Id);
        //MBK.channel 
        if(MBK.channel__c == 'S'){
            g.writeStringField('smsSndNum', notNull(smsSndNum));      //Shipping number          
            g.writeStringField('smsMessage', notNull(msg.message__c));   //Dispatch message
        }else if(MBK.channel__c == 'A'){
            //Notify
            g.writeStringField('templateCode', notNull(msg.templateCode__c));  //Outgoing template code
            g.writeStringField('subject', notNull(msg.subject__c));        
            g.writeStringField('smsMessage', notNull(msg.message__c));         //Dispatch message
            g.writeStringField('message', notNull(msg.message__c));            //Dispatch message                      
            g.writeStringField('smsSndNum', notNull(smsSndNum));               //Shipping number              
            g.writeStringField('smsKind', 'L');                                
            
            if(MBK.templateCode__c == system.label.MBK_Message_Survey){
                List<button> jsonButtons = new List<button>();
                button jsonButton = new button();
                jsonButton.name      = system.label.MBK_Message_Button_Name;
                jsonButton.type      = 'WL';
                jsonButton.url_mobile  = system.label.MBK_Message_SurveyURL;
                jsonButtons.add(jsonButton);
                g.writeObjectField('button',jsonButtons);
            }          
        }else if(MBK.channel__c == 'M'){
            g.writeStringField('message', notNull(msg.message__c));             //Dispatch message
            g.writeStringField('subject', notNull(msg.subject__c));
            g.writeStringField('smsSndNum', notNull(smsSndNum));                //Shipping number
            
            //Processing attachments(MMS)
            Integer i = 1; 
            if(MBKAtts <> null && MBKAtts.size() > 0){ 
                List<files> jsonfiles = new List<files>();  
                for(Attachment att:MBKAtts){
                    files subf = new files();
                    subf.seq = String.valueOf(i);
                    subf.file = EncodingUtil.base64Encode(att.Body);
                    subf.ext =   att.Name.right(3);
                    jsonfiles.add(subf);       
                    i++;
                } 
                g.writeObjectField('files',jsonfiles);
            }  
        }
        
        //Data common part
        myDate = MBK.Set_Sending_Time__c == null ? myDate : MBK.Set_Sending_Time__c.format('YYYYMMddHHmmss');
        g.writeStringField('senderKey', notNull(msg.senderKey__c));             //Outgoing profile key
        g.writeStringField('phoneNum', notNull(MBK.phoneNum__c));               //Recipient's mobile number
        g.writeStringField('custGubun', notNull(msg.custGubun__c));             //Value of customer division
        g.writeStringField('channel', notNull(MBK.channel__c));                 //Channel
        g.writeStringField('custMsgSn', notNull(msg.custGubun__c)+'_'+notNull(MBK.Id));    //Message serial number / key value
        g.writeStringField('reqDtm', myDate);                         //Message dispatch time
        g.writeEndObject(); 
    }
    g.writeEndArray();
    dataJson = '{"Data":'+g.getAsString()+'}';      
    req.setEndpoint(UtilCustomSettings.getMBKMessageServiceUrl('SfdcMBKMessageURL'));
    req.setHeader('Content-Type', system.label.MBK_Message_ContentType);
    req.setHeader('Accept', system.label.MBK_Message_ContentType);
    req.setMethod('POST');
    req.setBody(dataJson);   
    req.setTimeout(60000);
    
    //Status Send
    GlobalUtilityDFW gu = GlobalUtilityDFW.getInstance();
    gu.debug('[dataJson]'+dataJson);
    try {   
        res = http.send(req);
        update MBKMsgs;
        Integer statusCode = res.getStatusCode();
        List<Object> ReturnDatas = new List<Object>();
        if(statusCode != 200) {
            gu.debug('[getBody]'+res.getBody());
            //API 
            errMsg = res.getStatus();          
            for(MBK_Messages__c temp:MBKMessages){
                temp.code__c = String.valueOf(statusCode);
                temp.altMsg__c = errMsg;
                temp.processed__c = true;
                temp.Status__c = 'Fail';
            }
        }else{        
            gu.debug('[getBody]'+res.getBody());            
            if(res.getBody().length() > 0){
                String jsonBody = String.valueOf(res.getBody());
                ReturnDatas = (List<Object>)JSON.deserializeUntyped(jsonBody);
            }
            //step1
            for(Object rData:ReturnDatas){
                //Step2
                map<String, object> resData = (map<String, object>)rData;
                String sn = resData.get('sn') == null ? '' : (String)resData.get('sn');
                String custMsgSn = resData.get('custMsgSn') == null ? '' : (String)resData.get('custMsgSn');
                String code = resData.get('code') == null ? '' : (String)resData.get('code');
                String altCode = resData.get('altCode') == null ? '' : (String)resData.get('altCode');
                String altMsg = resData.get('altMsg') == null ? '' : (String)resData.get('altMsg');
                String smsCode = resData.get('smsCode') == null ? '' : (String)resData.get('smsCode');
                String smsMsg = resData.get('smsMsg') == null ? '' : (String)resData.get('smsMsg');
                String rcptDtm = resData.get('rcptDtm') == null ? '' : (String)resData.get('rcptDtm');
                String sndDtm = resData.get('sndDtm') == null ? '' : (String)resData.get('sndDtm');
                
                for(MBK_Messages__c temp:MBKMessages){
                    temp.sn__c = sn;
                    temp.code__c = code;
                    temp.altCode__c = altCode;
                    temp.altMsg__c = altMsg;
                    temp.sndDtm__c = sndDtm;
                    temp.smsMsg__c = smsMsg;
                    temp.rcptDtm__c = rcptDtm;
                    temp.processed__c = true;
                    if(code <> 'AS' && code <> 'SS') temp.Status__c = 'Completed';
                    else if(code <> 'EW') temp.Status__c = 'Send';
                    else if(altCode == '0000') temp.Status__c = 'Completed';
                    else temp.Status__c = 'Fail';
                }  
            }
        }
        update MBKMessages;
    } catch(System.CalloutException e) {  
        gu.DebugException(e,userinfo.getUserId());
        for(MBK_Messages__c temp:MBKMessages){
            temp.Status__c = 'Fail';
        }
        update MBKMessages;
    } catch(System.JSONException e){
        gu.DebugException(e,userinfo.getUserId());      
        for(MBK_Messages__c temp:MBKMessages){
            temp.Status__c = 'Fail';
        }
        update MBKMessages;
    }catch(System.Exception e){
        gu.DebugException(e,userinfo.getUserId());      
        for(MBK_Messages__c temp:MBKMessages){
            temp.Status__c = 'Fail';
        }
        update MBKMessages;
    }
}
private static String notNull(String str){
    if(str == null) return '';
    else return str;
}
public class files{
    public String seq;
    public String file;
    public String ext;
}

public class button{
    public String name;
    public String type;
    public String url_mobile;
}
}