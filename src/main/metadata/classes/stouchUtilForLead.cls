@RestResource(urlMapping='/stouchUtilForLead/*')
global without sharing class stouchUtilForLead {
    @HttpPost
    global static Map<String,String> LeadIfnoSendToAL(){
        String jsonText = RestContext.request.requestBody.toString();
        Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonText);
        Object res=cObjMap.get('data');
        Map<String,Object> obj= (Map<String,Object>)res;
        String LeadId=(String)obj.get('LeadId');
        String DealerID=(String)obj.get('DealerID');
        String AccountLinkId=(String)obj.get('AccountLinkId');
        map<String,String> response=new Map<String,String>();
        list<lead__c> ld=[select id,Dealer_Lead_Status__c,Contact__c from Lead__c where id=:LeadId];
        response.put('Message', system.Label.This_Lead_cannot_be_send_to_Autoline);
        system.debug(ld);
        if(ld.size()>0){
            if(ld[0].Dealer_Lead_Status__c=='Lost' || ld[0].Contact__c==null || ld[0].Dealer_Lead_Status__c=='Purchased(Only Non BDC)' ){
                response.put('Message', system.Label.This_Lead_cannot_be_send_to_Autoline);
            }
            else{
                try{
                    UtilWebservice.LeadIfnoSendToAL(LeadId, DealerID, AccountLinkId);
                   response.put('Message', system.Label.Successfully_Sent_Information_to_AutoLine);
                }
                catch(Exception ex){
                   response.put('Message', system.Label.Web_service_callout_failed);
                }
                
            }
        }
        return response;
    }
}