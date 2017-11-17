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
												Leads__c, SendTemplate__c, Name, Id, Set_Sending_Time__c, Status__c, UCID__c, altCode__c ,
												altMsg__c, channel__c, code__c, custGubun__c, AttachmentImages__c, message__c, phoneNum__c, 
												processed__c, reqDtm__c, senderKey__c, sn__c, sndDtm__c, subject__c, templateCode__c 
											FROM MBK_Messages__c WHERE Id IN: MessageIds]);
		List<MBK_Messages__c> MBKMessages = mapMBKs.values();
		system.debug('MessageIds:'+MessageIds);
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
		system.debug('messageImages:'+messageImages);
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
				g.writeStringField('custMsgSn', notNull(MBK.Id));								//메시지 일련번호/ 키값  
				g.writeStringField('channel', notNull(MBK.channel__c));							//채널[A:알림톡, C:친구톡]
				g.writeStringField('custGubun', notNull(MBK.custGubun__c));						//고객사구분값
				g.writeStringField('subject', notNull(MBK.subject__c));
				g.writeStringField('senderKey', notNull(MBK.senderKey__c));						//발신프로필키
				g.writeStringField('templateCode', notNull(MBK.templateCode__c));				//발신 템플릿코드
				g.writeStringField('phoneNum', notNull(MBK.phoneNum__c));						//수신자휴대폰번호			
				g.writeStringField('smsMessage', notNull(MBK.message__c));						//발송메시지
				g.writeStringField('message', notNull(MBK.message__c));							//발송메시지				
				g.writeStringField('smsSndNum', notNull(system.label.MBK_Message_Sender_Phone));//발송번호
				g.writeStringField('smsKind', 'L');	//전환발송 구분
				myDate = MBK.Set_Sending_Time__c == null ? myDate : MBK.Set_Sending_Time__c.format('YYYYMMddHHmmss');
				
				//첨부파일 처리
				Integer i = 1; 
				if(MBKAtts <> null && MBKAtts.size() > 0){ 
					JSONGenerator subg = JSON.createGenerator(true);
					subg.writeStartArray();
					for(Attachment att:MBKAtts){					
						subg.writeStartObject();
						subg.writeStringField('seq', String.valueOf(i));	
						subg.writeStringField('data', EncodingUtil.base64Encode(att.Body));
						subg.writeStringField('ext', att.Name.right(3));
						subg.writeEndObject();
						i++;
					} 
					subg.writeEndArray();
					String dataSubJson = subg.getAsString();
					g.writeStringField('files', dataSubJson);	
				}
				g.writeStringField('reqDtm', myDate);			//메시지 발송 요청시간
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
				g.writeEndObject(); 
			}
		g.writeEndArray();
		dataJson = '{"Data":'+g.getAsString()+'}';
		req.setEndpoint(system.label.MBK_Message_URL);
		req.setHeader('Content-Type', system.label.MBK_Message_ContentType);
		req.setHeader('Accept', system.label.MBK_Message_ContentType);
		req.setMethod('POST');
		req.setBody(dataJson);		
		req.setTimeout(60000);
system.debug('dataJson:'+dataJson);
		//Status Send로 업데이트
		try {			
			res = http.send(req);
system.debug(res.getBody());
			update MBKMessages;
			Integer statusCode = res.getStatusCode();
			Map<String, Object> ReturnDatas = new Map<String, Object>();
			if(statusCode != 200) {
				//API 전송실패
				errMsg = res.getStatus();
				ReturnDatas = (Map<String, Object>)JSON.deserializeUntyped(String.valueOf(res.getBody()));
system.debug('statusCode error: '+ ReturnDatas);	
				//step1
				map<String, Object> error = (map<String, Object>)ReturnDatas.get('error');
				//step2
				Integer code = (Integer)error.get('code');
				String message = (String)error.get('message');
				map<String, Object> details = (map<String, Object>)error.get('details');
				//step3
				String extra = String.valueOf(details.get('extra'));						
				for(MBK_Messages__c temp:MBKMessages){
					temp.code__c = String.valueOf(code);
					temp.altMsg__c = message+':'+extra;
					temp.processed__c = true;
					temp.Status__c = 'Fail';
				}
			}else{
system.debug('res:'+res.getBody());
				ReturnDatas = (Map<String, Object>)JSON.deserializeUntyped(String.valueOf(res.getBody()));
				//step1
				map<String, Object> Out = (map<String, Object>)ReturnDatas.get('Out');
				String sndDtm = (String)ReturnDatas.get('sndDtm');
				//Step2
				String altCode = (String)Out.get('altCode');
				String altMsg = (String)Out.get('altMsg');
				String custMsgSn = (String)Out.get('custMsgSn');
				String smsMsg = (String)Out.get('smsMsg');
system.debug('ReturnDatas:'+ReturnDatas);
				for(MBK_Messages__c temp:MBKMessages){
					
					temp.sn__c = '';
					temp.code__c = String.valueOf(statusCode);
					temp.altCode__c = String.valueOf(altCode);
					temp.altMsg__c = altMsg;
					temp.sndDtm__c = sndDtm;
					temp.smsMsg__c = smsMsg;
					temp.custMsgSn__c = custMsgSn;
					temp.processed__c = true;
					if(String.valueOf(altCode) <> '0000') temp.Status__c = 'Fail';
					else temp.Status__c = 'Completed';
				}		
			}
			update MBKMessages;
		} catch(System.CalloutException e) {
			System.debug('Callout error: '+ e);
			System.debug(res.toString());
			System.debug('statusCode error: '+ e.getMessage());
			for(MBK_Messages__c temp:MBKMessages){
				temp.Status__c = 'Fail';
			}
			update MBKMessages;
		} catch(System.JSONException e){
			for(MBK_Messages__c temp:MBKMessages){
				temp.Status__c = 'Fail';
			}
			update MBKMessages;
			System.debug('JSON error: '+ e);
			System.debug(res.toString());
			System.debug('statusCode error: '+ e.getMessage());
		}
		
		System.debug(LoggingLevel.DEBUG, '=============== HttpResponse: '+ res);
		System.debug(LoggingLevel.DEBUG, '=============== res.getBody(): '+ res.getBody());	
	}
	
	@future
	public static void MBKMessageLogging(List<String> MBKMessageIds){
		List<MBK_Messages__c> MBKMessages = [SELECT Account__c, Account_Name__c, Campaign_Member__c, Case__c, KaKaoTalk_ID__c,  
												Leads__c, SendTemplate__c, Name, Id, Set_Sending_Time__c, Status__c, UCID__c, altCode__c ,
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
			if(temp.channel__c == 'A') sendType = 'kaKao';
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

}