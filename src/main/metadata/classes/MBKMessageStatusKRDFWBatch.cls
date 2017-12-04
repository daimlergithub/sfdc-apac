/**
 * Class Name	: MBKMessageStatusKRDFWBatch.cls
 * Function		: MBK Message Status Check Schedule
 * VFPage		: N/A
 * Author		: I2MAX
 * Date			: 2017.11.04
 * Description	: 상태체크 배치
*/
global class MBKMessageStatusKRDFWBatch implements Database.AllowsCallouts, Database.Batchable<sObject>{

	global Database.QueryLocator start(Database.BatchableContext BC) {
		datetime nowTime = system.now().addMinutes(30);
		String year = String.valueOf(nowTime.year());
		String month = nowTime.month() < 10 ? '0'+String.valueOf(nowTime.month()) : String.valueOf(nowTime.month());
		String day = nowTime.day() < 10 ? '0'+String.valueOf(nowTime.day()) : String.valueOf(nowTime.day());
		String hour = nowTime.hour() < 10 ? '0'+String.valueOf(nowTime.hour()) : String.valueOf(nowTime.hour());
		String minute = nowTime.minute() < 10 ? '0'+String.valueOf(nowTime.minute()) : String.valueOf(nowTime.minute());
		String second  = nowTime.second() < 10 ? '0'+String.valueOf(nowTime.second()) : String.valueOf(nowTime.second());
		String queryDate = year+'-'+month+'-'+day+'T'+hour+':'+minute+':'+second+'Z'; 	
		
		String query = 'SELECT Id, Status__c, altCode__c, altMsg__c, code__c, custGubun__c, '
				+' processed__c, reqDtm__c, senderKey__c, sn__c, sndDtm__c '
				+' FROM MBK_Messages__c WHERE Status__c = \'Send\' AND processed__c = false '
				+' AND Set_Sending_Time__c <=' +queryDate;
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		//인포메티카로 전송
		List<MBK_Messages__c> mbkMessages = (List<MBK_Messages__c>)scope;
		
		JSONGenerator g = JSON.createGenerator(true);
			g.writeStartArray();					
			//인포메디카로 전송
			for(MBK_Messages__c MBK:mbkMessages){
				g.writeStartObject();
				g.writeStringField('custMsgSn', MBK.Id);	//메시지 일련번호/ 키값  
				g.writeStringField('sn', MBK.sn__c);		//M&Wise 키값		
				g.writeEndObject(); 
			}
			g.writeEndArray();
			Http			http	= new Http();
			HttpRequest		req		= new HttpRequest();
			HttpResponse	res		= new HttpResponse();
			String			errMsg	= '';
			String dataJson = '{"Data":'+g.getAsString()+'}';

			req.setEndpoint(UtilCustomSettings.getMBKMessageServiceUrl('SfdcMBKMessageURL'));
			req.setHeader('Content-Type', system.label.MBK_Message_ContentType);
			req.setHeader('Accept', system.label.MBK_Message_ContentType);
			req.setMethod('POST');
			req.setBody(dataJson);		
			req.setTimeout(60000);
			res = http.send(req);
		
			integer statusCode = res.getStatusCode();
			List<Object> ReturnDatas = new List<Object>();
			if(statusCode != 200) {
				//API 전송실패
				errMsg = res.getStatus();				
				for(MBK_Messages__c temp:mbkMessages){
					temp.code__c = String.valueOf(statusCode);
					temp.altMsg__c = errMsg;
					temp.processed__c = true;
					temp.Status__c = 'Fail';
				}
			}else{
				ReturnDatas = (List<Object>)JSON.deserializeUntyped(String.valueOf(res.getBody()));
				for(Object rData:ReturnDatas){
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
					for(MBK_Messages__c temp:mbkMessages){
						if(custMsgSn == String.valueOf(temp.Id)){
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
}