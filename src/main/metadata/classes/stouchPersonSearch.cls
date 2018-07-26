@RestResource(urlMapping='/stouchPersonSearch/*')
global without sharing class stouchPersonSearch {

    global interface stouchPersonSearchInterface{
    }
    private class stouchPersonSearchClass implements stouchPersonSearchInterface{
        public String RecordCount;
        public List<Object> O_customerdetails;
    }
    @HttpPost
    global static stouchPersonSearchInterface PersonSearchResult()
    {
        String jsonText = RestContext.request.requestBody.toString();
        Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonText);
        List<Object> obj=(List<Object>)cObjMap.get('Input_IDS');
        String count=(String)cObjMap.get('Rec_count');
		String market=(String)cObjMap.get('MD__c');
        system.debug('@@'+obj);
        list<String> accountlinklist1=new  list<String>();
        List<Object> PersonResultsList=new List<Object>();
        for(Object ob:obj){
            accountlinklist1.add((String)ob);
        }
        system.debug('@@@'+market);
		if(String.isBlank(market)){
            list<Account_link__c> accountlinklist=[select toRole__r.MBK_Data_Source__c,Retail_PersonBirthdate__c,Retail_LastName__c,Retail_Mobile__c,Retail_Email__c,Retail_UCID__c,RecordTypeid,Ownerid from account_link__c where id=:accountlinklist1 order by Retail_LastName__c];
            List<id> userIds=new List<Id>();
            for(Account_link__c ac:accountlinklist){
                userIds.add(ac.OwnerId);
            }
            Map<Id,User> users=new map<Id,User>([select id,federationIdentifier from user where id in :userIds]);
            system.debug('@@'+accountlinklist);
            for(Account_link__c acclink:accountlinklist){
               Map<String,Object> PersonResults=new Map<String,Object>();
               PersonResults.put('LastName',string.ISBlank(acclink.Retail_LastName__c)? ' ' : acclink.Retail_LastName__c);
               PersonResults.put('PersonMobilePhone',string.ISBlank(acclink.Retail_Mobile__c)? ' ' : acclink.Retail_Mobile__c.remove('-'));
               PersonResults.put('PersonEmail',string.ISBlank(acclink.Retail_Email__c)? ' '  : acclink.Retail_Email__c);
               PersonResults.put('Personal_UCID__c',string.ISBlank(acclink.Retail_UCID__c)? ' '  : acclink.Retail_UCID__c);
               PersonResults.put('Owner',string.ISBlank(users.get(acclink.Ownerid).federationIdentifier)?' ':users.get(acclink.Ownerid).federationIdentifier);
               PersonResults.put('MBK_Data_Source__c',string.ISBlank(acclink.toRole__r.MBK_Data_Source__c)? ' '  : acclink.toRole__r.MBK_Data_Source__c);
               PersonResults.put('Birthdate',string.valueOf(acclink.Retail_PersonBirthdate__c));
               if(acclink.Retail_PersonBirthdate__c==null)
                 PersonResults.put('Birthdate',' ');
               PersonResultsList.add(PersonResults);  
            }
		}
        else if(market=='TH'){
            PersonResultsList=StouchPersonSearchTH.personSearchResultsTH(accountlinklist1);
        }

        
        stouchPersonSearchClass sp=new stouchPersonSearchClass();
        sp.RecordCount=count;
        sp.O_customerdetails=PersonResultsList;
        return sp;  
    }       
}