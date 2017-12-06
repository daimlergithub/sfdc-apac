/**
 * Class Name	: MBKMessageScheduleSendKRDFWBatch.cls
 * Function		: MBK Message Schedule Send Schedule
 * VFPage		: N/A
 * Author		: I2MAX
 * Date			: 2017.09.29
 * Description	: 예약발송 메시지 인포메티카로 전송, 컨셉(정시 배치 동작 30분 마다 메시지 인포 메티카로 발송)
*/
global class MBKMessageScheduleSendKRDFWBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
	global String channel{get;set;}
	global String query{get;set;}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		datetime nowTime = system.now().addMinutes(30);
		String year = String.valueOf(nowTime.year());
		String month = nowTime.month() < 10 ? '0'+String.valueOf(nowTime.month()) : String.valueOf(nowTime.month());
		String day = nowTime.day() < 10 ? '0'+String.valueOf(nowTime.day()) : String.valueOf(nowTime.day());
		String hour = nowTime.hour() < 10 ? '0'+String.valueOf(nowTime.hour()) : String.valueOf(nowTime.hour());
		String minute = nowTime.minute() < 10 ? '0'+String.valueOf(nowTime.minute()) : String.valueOf(nowTime.minute());
		String second  = nowTime.second() < 10 ? '0'+String.valueOf(nowTime.second()) : String.valueOf(nowTime.second());
		String queryDate = year+'-'+month+'-'+day+'T'+hour+':'+minute+':'+second+'Z'; 	
		
		query = 'SELECT Account__c, Account_Name__c, Campaign_Member__c, Case__c, KaKaoTalk_ID__c, '
				+' Leads__c, MBKMessageTemplate__c, Name, Id, Set_Sending_Time__c, Status__c, UCID__c, altCode__c, '
				+' altMsg__c, channel__c, code__c, custGubun__c, AttachmentImages__c, message__c, phoneNum__c, '
				+' processed__c, reqDtm__c, senderKey__c, sn__c, sndDtm__c, subject__c, templateCode__c '
				+' FROM MBK_Messages__c WHERE Status__c = \'Reserved\' AND processed__c = false '
				+' AND Set_Sending_Time__c <=' +queryDate+'AND channel__c = \''+channel+'\'';
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		//인포메티카로 전송
		List<MBK_Messages__c> mbkMessages = (List<MBK_Messages__c>)scope;
		map<Id, List<Attachment>> messageImages = new map<Id, List<Attachment>>();			
		Set<Id> ParentIds = new Set<Id>();
		if(channel == 'M'){
			Id compId = null;
			List<Attachment> tempList = null;
			//이미지 첨부
			for(MBK_Messages__c temp:mbkMessages){
				ParentIds.add(temp.Id);
			}
			List<Attachment> Attachments = [SELECT Id, Body, Name, ParentId FROM Attachment WHERE ParentId IN: ParentIds];
			for(Attachment temp:Attachments){
				if(compId <> temp.Id){
					tempList = new List<Attachment>();
					messageImages.put(temp.ParentId, tempList);
					compId = temp.Id;
				}
				tempList.add(temp);			
			}	
		}			
		
		JSONGenerator g = JSON.createGenerator(true);
		g.writeStartArray();					
		//인포메디카로 전송
		for(MBK_Messages__c MBK:mbkMessages){
			MBK.Status__c = 'Send';
			String myDate = '';
			g.writeStartObject();
						
			//MBK.channel 분리
			if(MBK.channel__c == 'S'){
				g.writeStringField('smsSndNum', notNull(system.label.MBK_Message_Sender_Phone));	//발송번호
				g.writeStringField('smsMessage', notNull(MBK.message__c));							//발송메시지
			}else if(MBK.channel__c == 'A'){
				//알림톡
				g.writeStringField('templateCode', notNull(MBK.templateCode__c));					//발신 템플릿코드
				g.writeStringField('subject', notNull(MBK.subject__c));				
				g.writeStringField('smsMessage', notNull(MBK.message__c));							//발송메시지
				g.writeStringField('message', notNull(MBK.message__c));								//발송메시지				
				g.writeStringField('smsSndNum', notNull(system.label.MBK_Message_Sender_Phone));	//발송번호
				g.writeStringField('smsKind', 'L');												//전환발송 구분
								
				if(MBK.templateCode__c == system.label.MBK_Message_Survey){
					JSONGenerator buttong = JSON.createGenerator(true);
					buttong.writeStartArray();
					buttong.writeStartObject();
					buttong.writeStringField('name', system.label.MBK_Message_Button_Name);	
					buttong.writeStringField('type', 'WL');
					buttong.writeStringField('url_mobile', system.label.MBK_Message_SurveyURL);
					buttong.writeEndObject();					
					
					buttong.writeEndArray();
					String dataButtonJson = buttong.getAsString();
					g.writeStringField('button', dataButtonJson);	
				}					
			}else if(MBK.channel__c == 'M'){
				g.writeStringField('message', notNull(MBK.message__c));								//발송메시지
				g.writeStringField('subject', notNull(MBK.subject__c));
				g.writeStringField('smsSndNum', notNull(system.label.MBK_Message_Sender_Phone));	//발송번호
				//첨부파일 처리(MMS)
				List<Attachment> MBKAtts = messageImages.get(MBK.Id);
				Integer i = 1; 
				if(MBKAtts <> null && MBKAtts.size() > 0)
				{ 
					List<files> jsonfiles = new List<files>();  
					for(Attachment att:MBKAtts){
						files subf = new files();
						subf.seq = String.valueOf(i);
						subf.file = EncodingUtil.base64Encode(att.Body);
						subf.ext = 	att.Name.right(3);
						jsonfiles.add(subf); 			
						i++;
					} 
					g.writeObjectField('files',jsonfiles);	
				}
			}
			
			//데이터 공통부
			myDate = MBK.Set_Sending_Time__c == null ? myDate : MBK.Set_Sending_Time__c.format('YYYYMMddHHmmss');
			g.writeStringField('senderKey', notNull(MBK.senderKey__c));							//발신프로필키
			g.writeStringField('phoneNum', notNull(MBK.phoneNum__c));							//수신자휴대폰번호
			g.writeStringField('custGubun', notNull(MBK.custGubun__c));							//고객사구분값
			g.writeStringField('channel', notNull(MBK.channel__c));								//채널[A:알림톡, C:친구톡]
			g.writeStringField('custMsgSn', notNull(MBK.custGubun__c)+'_'+notNull(MBK.Id));		//메시지 일련번호/ 키값
			g.writeStringField('reqDtm', myDate);	
					
			g.writeEndObject(); 
		}
		g.writeEndArray();
		Http			http	= new Http();
		HttpRequest		req		= new HttpRequest();
		HttpResponse	res		= new HttpResponse();
		String			errMsg	= '';
		String dataJson = '{"Data":'+g.getAsString()+'}';
		String endpointUrl = UtilCustomSettings.getMBKMessageServiceUrl('SfdcMBKMessageURL');
		String ContentType = system.label.MBK_Message_ContentType;
		String Accept = system.label.MBK_Message_ContentType;
		req.setEndpoint(endpointUrl);
		req.setHeader('Content-Type', ContentType);
		req.setHeader('Accept', Accept);
		req.setMethod('POST');
		req.setBody(dataJson);		
		req.setTimeout(60000);
		res = http.send(req);
		
		//Send로 상태 업데이트
		update mbkMessages;

		integer statusCode = res.getStatusCode();
		List<Object> ReturnDatas = new List<Object>();
		if(statusCode != 200) 
		{
			//API 전송실패
			errMsg = res.getStatus();					
			for(MBK_Messages__c temp:MBKMessages)
			{
				temp.code__c = String.valueOf(statusCode);
				temp.altMsg__c = errMsg;
				temp.processed__c = true;
				temp.Status__c = 'Fail';
			}
		}else{
			String jsonBody = String.valueOf(res.getBody());
			ReturnDatas = (List<Object>)JSON.deserializeUntyped(jsonBody);
			for(Object rData:ReturnDatas)
			{
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
				for(MBK_Messages__c temp:mbkMessages)
				{
					if(custMsgSn == String.valueOf(temp.Id))
					{
						temp.sn__c = sn;
						temp.code__c = code;
						temp.altCode__c = altCode;
						temp.altMsg__c = altMsg;
						temp.sndDtm__c = sndDtm;
						//temp.smsCode__c = smsCode;
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
		}
        update mbkMessages;
	}
	
	global void finish(Database.BatchableContext BC) {
	}
	 
	private static String notNull(String str){
		if(str == null) return '';
		else return str; 		
	}
	public class files{
		public String seq{get;set;}
		public String file{get;set;}
		public String ext{get;set;} 
	}	
}