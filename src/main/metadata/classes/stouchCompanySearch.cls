/**
* @author Narendra Nimmana
* @date 1/30/2018
*/
@RestResource(urlMapping='/stouchCompanySearch/*')
global without sharing class stouchCompanySearch {
    public static final Id contactToContactRecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
	//Http methods do not support return type of Object so here taken interface instance to retun the data
    global interface stouchCompanySearchInterface {
    }

    private class stouchCompanySearchClass implements stouchCompanySearchInterface {
        public String RecordCount;
        public List<Object> Out_CompanyDetails;
    }
    
    @HttpPost
    global static stouchCompanySearchInterface PersonSearchResult(){
        String jsonText = RestContext.request.requestBody.toString();
        Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonText);
        List<Object> obj=(List<Object>)cObjMap.get('Input_IDS');
        String count=(String)cObjMap.get('Rec_count');
        list<String> accountlinkIds=new  list<String>();
        for(Object ob:obj){
            accountlinkIds.add((String)ob);
        }
        
        list<Account_link__c> accountlinklist=[select toRole__c,toRole__r.MBK_Data_Source__c,toRole__r.Company_Name__c,toRole__r.Company__c,toRole__r.Mobile__c,toRole__r.Email__c,toRole__r.UCID__c,RecordTypeid,Ownerid from account_link__c where id=:accountlinkIds order by toRole__r.Company_Name__c];
        List<id> userIds=new List<Id>();
        List<id> AccountIds=new List<Id>();
        for(Account_link__c ac:accountlinklist){
            userIds.add(ac.OwnerId);
            AccountIds.add(ac.toRole__c);
        }
        
        Map<Id,Account> Accounts= new map<Id,Account>([select id,(select toRole__r.MBK_Data_Source__c,OwnerId,toRole__r.PersonBirthdate,toRole__r.LastName,toRole__r.Mobile__c,toRole__r.Email__c,toRole__r.UCID__c,RecordTypeid,toRole__r.Ownerid from Account_Links1__r where RecordTypeid=:contactToContactRecordTypeId limit 3) from Account where id in :AccountIds]);
        for(Account acc:Accounts.values()){
            for(Account_link__c alc:acc.Account_Links1__r){
                userIds.add(alc.OwnerId);
            }
        }
        Map<Id,User> users=new map<Id,User>([select id,federationIdentifier from user where id in :userIds]);
        List<Object> companyResultsList=new List<Object>();
        
        for(Account_link__c ac:accountlinklist){
            Map<String,Object> companyResults=new Map<String,Object>();
            companyResults.put('Company_Name__c', string.ISBlank(ac.toRole__r.Company_Name__c)?' ':ac.toRole__r.Company_Name__c);
            companyResults.put('Company__c', string.ISBlank(ac.toRole__r.Company__c)?' ':ac.toRole__r.Company__c);
            companyResults.put('Company_UCID__c', string.ISBlank(ac.toRole__r.UCID__c)? ' ':ac.toRole__r.UCID__c);
            List<Object> contacts=new List<Object>();
            
            if(accounts.get(ac.toRole__c).Account_Links1__r.size()==0){
                Map<String,Object> personResults=new Map<String,Object>();
                personResults.put('Personal_UCID__c', ' ');
                personResults.put('LastName', ' ');
                personResults.put('PersonalMobilePhone', ' ');
                personResults.put('MBK_Data_Source__c', ' ');
                personResults.put('Birthdate', ' ');
                personResults.put('PersonEmail', ' ');
                personResults.put('Owner', ' ');
                contacts.add(personResults);
            }
            
            for(Account_link__c al:accounts.get(ac.toRole__c).Account_Links1__r){
                Map<String,Object> personResults=new Map<String,Object>();
                personResults.put('Personal_UCID__c', string.ISBlank(al.toRole__r.UCID__c)?' ':al.toRole__r.UCID__c);
                personResults.put('LastName', string.ISBlank(al.toRole__r.LastName)? ' ':al.toRole__r.LastName);
                personResults.put('PersonalMobilePhone', string.ISBlank(al.toRole__r.Mobile__c)?' ':al.toRole__r.Mobile__c.remove('-'));
                personResults.put('MBK_Data_Source__c', string.ISBlank(al.toRole__r.MBK_Data_Source__c)?' ':al.toRole__r.MBK_Data_Source__c);
                personResults.put('Birthdate', al.toRole__r.PersonBirthdate);
                if(al.toRole__r.PersonBirthdate==null)
                    personResults.put('Birthdate', ' ');
                personResults.put('PersonEmail', string.ISBlank(al.toRole__r.Email__c)?' ':al.toRole__r.Email__c);
                personResults.put('Owner', string.ISBlank(users.get(al.Ownerid).federationIdentifier)?' ':users.get(al.Ownerid).federationIdentifier);
                contacts.add(personResults);
            }
            
            companyResults.put('Contacts', contacts);
            companyResults.put('Owner', string.ISBlank(users.get(ac.OwnerId).federationIdentifier)?' ':users.get(ac.OwnerId).federationIdentifier);
            companyResults.put('MBK_Data_Source__c', string.ISBlank(ac.toRole__r.MBK_Data_Source__c)?' ':ac.toRole__r.MBK_Data_Source__c);
            companyResults.put('CompanyEmail', string.ISBlank(ac.toRole__r.Email__c)?' ':ac.toRole__r.Email__c);
            companyResults.put('CompanyMobile', string.ISBlank(ac.toRole__r.Mobile__c)?' ':ac.toRole__r.Mobile__c.remove('-'));
            companyResultsList.add(companyResults);
        }
        stouchCompanySearchClass scsc =new stouchCompanySearchClass();
        scsc.RecordCount=count;
        scsc.Out_CompanyDetails=companyResultsList;
    	return scsc;
    }
        
}