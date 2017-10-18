@RestResource(urlMapping='/stouchUtilForAccountLink/*')
global class stouchUtilForAccountLink {
	@HttpPost
    global static Map<String,String> AccountLinkIfnoSendToAL(){
        String jsonText = RestContext.request.requestBody.toString();
        Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonText);
        Object res=cObjMap.get('data');
        Map<String,Object> obj= (Map<String,Object>)res;
        String RTCustomerId=(String)obj.get('RTCustomerId');
        String DealerID=(String)obj.get('DealerID');
        String CorrelationId=(String)obj.get('CorrelationId');
        String resultmsg=null;
        map<String,String> response=new Map<String,String>();
        try{
            resultmsg=UtilWebservice.AccountLinkIfnoSendToAL(RTCustomerId, DealerID, CorrelationId);
            if(resultmsg.contains('Unknown organization ID')){
                response.put('Message', system.Label.Web_service_callout_failed);
            }
            else{
                response.put('Message', system.Label.Successfully_Sent_Information_to_AutoLine);
                if(CorrelationId=='' || CorrelationId==null || CorrelationId==' '){
                Account_Link__c alk= new Account_Link__c();
                alk.id=RTCustomerId;
                alk.CorrelationID__c=' ';
                update alk;
            	}
            } 
        }
        catch(exception e){
            response.put('Message', system.Label.Web_service_callout_failed);
        }
        return response;
    }
}