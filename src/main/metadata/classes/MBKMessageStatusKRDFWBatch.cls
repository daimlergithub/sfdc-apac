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

			req.setEndpoint(system.label.MBK_Message_URL);
			req.setHeader('Content-Type', system.label.MBK_Message_ContentType);
			req.setHeader('Accept', system.label.MBK_Message_ContentType);
			req.setMethod('POST');
			req.setBody(dataJson);		
			req.setTimeout(60000);
			res = http.send(req);
		
			integer statusCode = res.getStatusCode();
			Map<String, Object> ReturnDatas = new Map<String, Object>();
			if(statusCode != 200) {
				//API 전송실패
				errMsg = res.getStatus();
				ReturnDatas = (Map<String, Object>)JSON.deserializeUntyped(String.valueOf(res.getBody()));
	System.debug('statusCode error: '+ ReturnDatas);	
				//step1
				map<String, Object> error = (map<String, Object>)ReturnDatas.get('error');
				//step2
				Integer code = (Integer)error.get('code');
				String message = (String)error.get('message');
				map<String, Object> details = (map<String, Object>)error.get('details');
				//step3
				String extra = String.valueOf(details.get('extra'));						
				for(MBK_Messages__c temp:mbkMessages){
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
				String rcptDtm = (String)ReturnDatas.get('rcptDtm'); 
				//Step2
				Integer altCode = (Integer)Out.get('sndDtm');
				String altMsg = (String)Out.get('altMsg');
	system.debug('ReturnDatas:'+ReturnDatas);
				for(MBK_Messages__c temp:mbkMessages){
					temp.sn__c = '';
					temp.code__c = String.valueOf(statusCode);
					temp.altCode__c = String.valueOf(altCode);
					temp.altMsg__c = altMsg;
					temp.sndDtm__c = sndDtm;
					temp.rcptDtm__c = rcptDtm;
					temp.processed__c = true;
					temp.Status__c = 'Completed';
				}		
			}
	        update mbkMessages;	

   	}

	global void finish(Database.BatchableContext BC) {
	} 
}