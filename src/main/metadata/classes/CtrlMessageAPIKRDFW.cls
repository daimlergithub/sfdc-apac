/**
 * Class Name	: CtrlMessageAPIKRDFW.cls
 * Function		: MBK Message Send API Controller
 * VFPage		: N/A
 * Author		: I2MAX
 * Date			: 2017.09.29
 * Description	: 메시지 전송, Task log)	
*/
global class CtrlMessageAPIKRDFW {

	//*** 실시간 전송 ***//
	@future(callout=true)	
	public static void MBKMessageDirectSender(List<String> MessageIds){
		map<Id, MBK_Messages__c> mapMBKs = new map<Id, MBK_Messages__c>([SELECT Account__c, Account_Name__c, Campaign_Member__c, Case__c, KaKaoTalk_ID__c,  
												Leads__c, MBKMessageTemplate__c, Name, Id, Set_Sending_Time__c, Status__c, UCID__c, altCode__c ,
												altMsg__c, channel__c, code__c, custGubun__c, AttachmentImages__c, message__c, phoneNum__c, 
												processed__c, reqDtm__c, senderKey__c, sn__c, sndDtm__c, subject__c, templateCode__c 
											FROM MBK_Messages__c WHERE Id IN: MessageIds]);
		List<MBK_Messages__c> MBKMessages = mapMBKs.values();
		map<Id, List<Attachment>> messageImages = new map<Id, List<Attachment>>();
		List<Attachment> Attachments = [SELECT Id, Body, Name,ParentId FROM Attachment WHERE ParentId IN: messageIds];
		List<Attachment> tempList = null;
		Id compId = null;
		for(Attachment temp:Attachments){
			if(compId <> temp.Id){
				tempList = new List<Attachment>();
				messageImages.put(temp.ParentId, tempList);
				compId = temp.Id;
			}
			tempList.add(temp);			
		}	
		Http			http	= new Http();
		HttpRequest		req		= new HttpRequest();
		HttpResponse	res		= new HttpResponse();
		String			errMsg	= '';
		String dataJson = '';
		
		JSONGenerator g = JSON.createGenerator(true);
		g.writeStartArray();
			for(MBK_Messages__c MBK:MBKMessages){
				MBK.Status__c = 'Send';
				List<Attachment> MBKAtts = messageImages.get(MBK.Id);
				Datetime myDT = Datetime.now();
				String myDate = myDT.format('YYYYMMddHHmmss');				  
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
					Integer i = 1; 
					if(MBKAtts <> null && MBKAtts.size() > 0){ 
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
				g.writeStringField('reqDtm', myDate);												//메시지 발송 요청시간
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
	
		//Status Send로 업데이트
		GlobalUtilityDFW gu = GlobalUtilityDFW.getInstance();
		gu.debug('[dataJson]'+dataJson);		
		try {			
			res = http.send(req);		
			update MBKMessages;
			Integer statusCode = res.getStatusCode();
			map<String, object> resData;
			if(statusCode != 200) {
				//API 전송실패
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
					resData = (map<String, object>)JSON.deserializeUntyped(String.valueOf(res.getBody()));
				}
				//step1
				if(resData <> null){
					//Step2
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
						//temp.smsCode__c = smsCode;
						temp.smsMsg__c = smsMsg;
						temp.rcptDtm__c = rcptDtm;
						temp.processed__c = true;
						if(code <> 'AS' && code <> 'SS') temp.Status__c = 'Completed';
						else if(code <> 'EW') temp.Status__c = 'Send';
						else if(altCode == '0000') temp.Status__c = 'Completed';
						else temp.Status__c = 'Fail';
					}	

				}else{
					for(MBK_Messages__c temp:MBKMessages){
						temp.processed__c = true;
						temp.Status__c = 'Fail';
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
	
	@future
	public static void MBKMessageLogging(List<String> MBKMessageIds){
		List<MBK_Messages__c> MBKMessages = [SELECT Account__c, Account_Name__c, Campaign_Member__c, Case__c, KaKaoTalk_ID__c,  
												Leads__c, MBKMessageTemplate__c, Name, Id, Set_Sending_Time__c, Status__c, UCID__c, altCode__c ,
												altMsg__c, channel__c, code__c, custGubun__c, AttachmentImages__c, message__c, phoneNum__c, 
												processed__c, reqDtm__c, senderKey__c, sn__c, sndDtm__c, subject__c, templateCode__c,
												LastModifiedDate, Campaign__c
											 FROM MBK_Messages__c WHERE Id IN: MBKMessageIds];
		List<Task> insertTasks = new List<Task>();
		for(MBK_Messages__c temp:MBKMessages){
			Task log = new Task();
			if(temp.Account__c <> null) log.WhatId = temp.Account__c;
			else if(temp.Case__c <> null) log.WhatId = temp.Case__c;
			else if(temp.Leads__c <> null) log.WhatId = temp.Leads__c;
			
			String sendType = '';
			if(temp.channel__c == 'A') sendType = 'KakaoTalk';
			else if(temp.channel__c == 'M') sendType = 'MMS';
			else sendType = 'SMS';
			RecordType rectype = [SELECT Id FROM RecordType WHERE SobjectType = 'Task' AND Name =: sendType];
			log.RecordTypeId = rectype.Id;						
			log.Subject = '[MBK]'+temp.LastModifiedDate+'/'+temp.Set_Sending_Time__c+'/'+temp.sndDtm__c+'/'+sendType+'/'+temp.subject__c;
			log.Status = 'Closed';			
			insertTasks.add(log);	
		}
		insert insertTasks;	
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