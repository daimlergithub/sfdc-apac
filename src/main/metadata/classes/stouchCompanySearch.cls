/**  
* Class Name: stouchCompanySearch
* Description : This class is for 'KR' (Korea) Market Company Search API for Stouch App.
*               -If MD__c is not passed in request then It will be treated as 'KR'
*               -If MD__c is passsed in request and if it equals 'TH' it will be treated as TH and stouchCompanySearchTh will be called.
* Author : Narendra Nimmana
* Date : 1/30/2018
* Modification Log *
=============================================================================================================================================== 
Ver         Date                Author                      Modification --- ---- ------ -------------
C1.0        25/07/2018          Ashish Jadhav               ITSSTOUCH-2237 : hyphens should not be removed from phone numbers (KR - market).
                                                            Confirmed in mail from Supriyo and Srinivasan.
=============================================================================================================================================== 
* */ 
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
        String market=(String)cObjMap.get('MD__c');
        list<String> accountlinkIds=new  list<String>();
        for(Object ob:obj){
            accountlinkIds.add((String)ob);
        }
         List<Object> companyResultsList=new List<Object>();
        if(String.isBlank(market)){
        
        list<Account_link__c> accountlinklist=[select toRole__c,fromRole__c, fromRole__r.Name,toRole__r.MBK_Data_Source__c,Retail_Company_Name__c,toRole__r.Company__c,Retail_Mobile__c,Retail_Email__c,Retail_UCID__c,Ownerid,toRole__r.mobile__c,toRole__r.email__c,
                                              (select id,toRole__c,fromRole__c,fromRole__r.Name, toRole__r.MBK_Data_Source__c,Retail_LastName__c,toRole__r.Company__c,Retail_Mobile__c,Retail_Email__c,Retail_UCID__c,Ownerid,toRole__r.PersonBirthdate from Account_Link__r limit 3) 
                                               from account_link__c where id=:accountlinkIds order by Retail_Company_Name__c];
        List<id> userIds=new List<Id>();
        for(Account_link__c ac:accountlinklist){
            userIds.add(ac.OwnerId);
            for(Account_link__c alc:ac.Account_Link__r){
                userIds.add(alc.OwnerId);
            }
        }
        
        Map<Id,User> users=new map<Id,User>([select id,federationIdentifier from user where id in :userIds]);
       
        
        for(Account_link__c ac:accountlinklist){
            Map<String,Object> companyResults=new Map<String,Object>();
            companyResults.put('Company_Name__c', string.ISBlank(ac.Retail_Company_Name__c)?' ':ac.Retail_Company_Name__c);
            companyResults.put('Company__c', string.ISBlank(ac.toRole__r.Company__c)?' ':ac.toRole__r.Company__c);
            companyResults.put('Company_UCID__c', string.ISBlank(ac.Retail_UCID__c)? ' ':ac.Retail_UCID__c);
            List<Object> contacts=new List<Object>();
            
            /*if(ac.Account_Link__r.size()==0){
                Map<String,Object> personResults=getBlankPersonResultMap();
                contacts.add(personResults);
            }*/
            
            for(Account_link__c al:ac.Account_Link__r){
                Map<String,Object> personResults=new Map<String,Object>();
                // Added below condition by Ashish Jadhav as per comments on Jira ITSSTOUCH-2554 (dealer should be same).
                if(al.fromRole__c == ac.fromRole__c) {
                    personResults.put('Personal_UCID__c', string.ISBlank(al.Retail_UCID__c)?' ':al.Retail_UCID__c);
                    personResults.put('LastName', string.ISBlank(al.Retail_LastName__c)? ' ':al.Retail_LastName__c);
                    //personResults.put('PersonalMobilePhone', string.ISBlank(al.Retail_Mobile__c)?' ':al.Retail_Mobile__c.remove('-'));
                    personResults.put('PersonalMobilePhone', string.ISBlank(al.Retail_Mobile__c)?' ':al.Retail_Mobile__c);
                    personResults.put('MBK_Data_Source__c', string.ISBlank(al.toRole__r.MBK_Data_Source__c)?' ':al.toRole__r.MBK_Data_Source__c);
                    personResults.put('Birthdate', al.toRole__r.PersonBirthdate);
                    if(al.toRole__r.PersonBirthdate==null)
                        personResults.put('Birthdate', ' ');
                    personResults.put('PersonEmail', string.ISBlank(al.Retail_Email__c)?' ':al.Retail_Email__c);
                    personResults.put('Owner', string.ISBlank(users.get(al.Ownerid).federationIdentifier)?' ':users.get(al.Ownerid).federationIdentifier);
                    contacts.add(personResults);
                }
                
            }
            if(contacts.isEmpty()) {
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
            companyResults.put('Contacts', contacts);
            companyResults.put('Owner', string.ISBlank(users.get(ac.OwnerId).federationIdentifier)?' ':users.get(ac.OwnerId).federationIdentifier);
            companyResults.put('MBK_Data_Source__c', string.ISBlank(ac.toRole__r.MBK_Data_Source__c)?' ':ac.toRole__r.MBK_Data_Source__c);
            companyResults.put('CompanyEmail', string.ISBlank(ac.toRole__r.Email__c)?' ':ac.toRole__r.Email__c);
            //companyResults.put('CompanyMobile', string.ISBlank(ac.toRole__r.mobile__c)?' ':ac.toRole__r.mobile__c.remove('-'));
            companyResults.put('CompanyMobile', string.ISBlank(ac.toRole__r.mobile__c)?' ':ac.toRole__r.mobile__c);
            companyResults.put('Account1', (ac.fromRole__c == null && string.ISBlank(ac.fromRole__r.Name)) ?' ':ac.fromRole__r.Name);
            companyResultsList.add(companyResults);
        }
        }
        else if(market=='TH'){
            companyResultsList=StouchCompanySearchTH.companySearchResultsTH(accountlinkIds,contactToContactRecordTypeId);
        }
        else if(market=='MY'){
            companyResultsList=StouchCompanySearchMY.companySearchResultsMY(accountlinkIds);
        }
        stouchCompanySearchClass scsc =new stouchCompanySearchClass();
        scsc.RecordCount=count;
        scsc.Out_CompanyDetails=companyResultsList;
        return scsc;
    }
    
}