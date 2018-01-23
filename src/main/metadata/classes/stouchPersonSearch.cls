@RestResource(urlMapping='/stouchPersonSearch/*')
global without sharing class stouchPersonSearch {
    @HttpPost
    global static JSON2ApexStouch PersonSearchResult()
    { 
        String jsonText = RestContext.request.requestBody.toString();
        Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonText);
        List<Object> obj=(List<Object>)cObjMap.get('Input_IDS');
        String count=(String)cObjMap.get('Rec_count');
        system.debug('@@'+obj);
        list<String> accountlinklist1=new  list<String>();
        list<map<string,string>> newmap1=new  list<map<string,string>>();
        for(Object ob:obj)
        {
            accountlinklist1.add((String)ob);
        }
        list<Account_link__c> accountlinklist=[select toRole__r.MBK_Data_Source__c,Retail_PersonBirthdate__c,Retail_LastName__c,Retail_Mobile__c,Retail_Email__c,Retail_UCID__c,RecordTypeid,Ownerid from account_link__c where id=:accountlinklist1] ;
        JSON2ApexStouch ja= new JSON2ApexStouch();
        ja.record_count=count;
        for(Account_link__c ac:accountlinklist)
        {
            JSON2ApexStouch.Person jaw=new JSON2ApexStouch.Person(ac);
            ja.Output_IDS.add(jaw);
        }   
        return ja; 
    }
}