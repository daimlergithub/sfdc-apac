/**  
* Class Name: StouchCompanySearchMY
* Description : This class is for 'MY' (Malaysia) Market Company Search API for Stouch App.
* Author : Ashish Jadhav
* Modification Log *
=============================================================== 
Ver         Date            Author              Modification --- ---- ------ -------------
V1.0        18/09/2018      Ashish Jadhav       // response : Status in contacts needs to be confirmed    
=============================================================== 
* */ 
public class StouchCompanySearchMY {    
    
    public static final Id contactToContactRecordTypeId=RecordTypeAccessService.getRecordTypeId('Account_Link__c', 'Contact2Contact');
    public static final Id RetailCompanyRecordTypeId=RecordTypeAccessService.getRecordTypeId('Account_Link__c', 'Retail Company');
    public static final Id RetailPersonRecordTypeId=RecordTypeAccessService.getRecordTypeId('Account_Link__c', 'Retail Person');
    
    public static List<Object> companySearchResultsMY(list<String> accountlinkIds){
        list<Account_link__c> accountlinklist=[select Retail_Company_Name__c,Retail_Email__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Fax__c,Retail_Company_Other_Phone__c,
                                               toRole__c,toRole__r.Name,Retail_UCID__c,Retail_Related_Company__c,Ownerid,
                                               toRole__r.Data_Source__c,toRole__r.Commercial_Reg_No__c,fromRole__c, toRole__r.Status__c 
                                               from account_link__c where id=:accountlinkIds order by Retail_Company_Name__c];
        
        Map<Id,list<Account_link__c >>companyAccountIdandCompLinkList = new Map<Id,list<Account_link__c >>();
        Map<Id,Id>personAccIdAndCompanyAccId = new Map<Id,Id>();
        for(Account_link__c acclink : accountlinklist){
            if(companyAccountIdandCompLinkList.containsKey(acclink.toRole__c)){
                companyAccountIdandCompLinkList.get(acclink.toRole__c).add(acclink);
            }
            else{
                companyAccountIdandCompLinkList.put(acclink.toRole__c,New List<Account_link__c>{acclink});
            }
        }
        Map<id,List<Account_link__c>>compLinkIdAndPersonLinkList = new Map<id,List<Account_link__c>>();
        for(Account_link__c c2c : [select id,toRole__c,toRole__r.recordTypeId,fromRole__c,fromRole__r.recordTypeId  
                                   from Account_Link__c Where RecordTypeId =: contactToContactRecordTypeId 
                                   AND (fromRole__c IN :companyAccountIdandCompLinkList.keyset() 
                                        OR toRole__c IN : companyAccountIdandCompLinkList.keyset())]){
            personAccIdAndCompanyAccId.put((c2c.toRole__r.recordTypeId == RetailCompanyRecordTypeId) ? c2c.fromRole__c : c2c.toRole__c,(c2c.toRole__r.recordTypeId == RetailCompanyRecordTypeId) ? c2c.toRole__c : c2c.fromRole__c);
            
        }
        Map<Id,list<Account_link__c >>CompanyLinkIdAndlistOfPersonLink = new Map<Id,list<Account_link__c >>();
        for(Account_link__c personLink : [select id,fromRole__c,toRole__c,toRole__r.LastName,Retail_Mobile__c,Retail_Email__c,Retail_UCID__c, toRole__r.Status__c,
                                                       Ownerid,Retail_ID_Type__c,Retail_Work_Phone__c,Retail_Full_Name__c,Retail_FirstName__c,Retail_LastName__c  
                                                       from Account_Link__c WHERE toRole__c IN:personAccIdAndCompanyAccId.keySet() AND RecordTypeId =: RetailPersonRecordTypeId]){
            for(Account_link__c compLink : companyAccountIdandCompLinkList.get(personAccIdAndCompanyAccId.get(personLink.toRole__c))){
                if(compLink.fromRole__c == personLink.fromRole__c){
                    if(CompanyLinkIdAndlistOfPersonLink.containsKey(compLink.Id)){
                        CompanyLinkIdAndlistOfPersonLink.get(compLink.Id).add(personLink);
                    }
                    else{
                        CompanyLinkIdAndlistOfPersonLink.put(compLink.Id,New List<Account_link__c>{personLink});
                    }
                }
            }
        }
        List<id> userIds=new List<Id>();
        for(Account_link__c ac:accountlinklist){
            userIds.add(ac.OwnerId);
            for(Account_link__c alc:ac.Account_Link__r){
                userIds.add(alc.OwnerId);
            }
        }
        
        Map<Id,User> users=new map<Id,User>([select id,federationIdentifier from user where id in :userIds]);
        List<Object> companyResultsList=new List<Object>();       
        
        for(Account_link__c ac:accountlinklist){
            Map<String,Object> companyResults=new Map<String,Object>();
            companyResults.put('Email', string.ISBlank(ac.Retail_Email__c )?' ':ac.Retail_Email__c);
            companyResults.put('HomePhone', string.ISBlank(ac.Retail_Company_Phone__c )? ' ':ac.Retail_Company_Phone__c );
            companyResults.put('WorkPhone', string.ISBlank(ac.Retail_Company_Other_Phone__c)?' ':ac.Retail_Company_Other_Phone__c);
            companyResults.put('AccountName', string.ISBlank(ac.toRole__r.Name)? ' ':ac.toRole__r.Name);
            companyResults.put('Company__c', string.ISBlank(ac.Retail_Related_Company__c)? ' ':ac.Retail_Related_Company__c);
            companyResults.put('Company_UCID__c', string.ISBlank(ac.Retail_UCID__c)? ' ':ac.Retail_UCID__c); 
            companyResults.put('Data_Source__c', string.ISBlank(ac.toRole__r.Data_Source__c)? ' ':ac.toRole__r.Data_Source__c);
            
            List<Object> contacts=new List<Object>();
            
            if(CompanyLinkIdAndlistOfPersonLink == null || !CompanyLinkIdAndlistOfPersonLink.containsKey(ac.Id) || CompanyLinkIdAndlistOfPersonLink.get(ac.Id).size()==0){
                Map<String,Object> personResults=new Map<String,Object>();
                
                personResults.put('Personal_UCID__c', ' ');
                personResults.put('FirstName', ' ');
                personResults.put('LastName', ' ');
                personResults.put('Status', ' ');
                personResults.put('PersonalMobilePhone', ' ');
                personResults.put('PersonEmail', ' ');
                personResults.put('WorkPhone', ' ');
                contacts.add(personResults);
            }
            
            if(CompanyLinkIdAndlistOfPersonLink.containsKey(ac.Id) && CompanyLinkIdAndlistOfPersonLink.get(ac.Id) != null) {
                for(Account_link__c al : CompanyLinkIdAndlistOfPersonLink.get(ac.Id)) {
                    Map<String,Object> personResults=new Map<String,Object>();
                    personResults.put('Personal_UCID__c', string.ISBlank(al.Retail_UCID__c)?' ':al.Retail_UCID__c);
                    personResults.put('PersonalMobilePhone', string.ISBlank(al.Retail_Mobile__c)?' ':al.Retail_Mobile__c.remove('-'));  
                    personResults.put('PersonEmail', string.ISBlank(al.Retail_Email__c)?' ':al.Retail_Email__c);
                    personResults.put('WorkPhone', string.ISBlank(al.Retail_Work_Phone__c)?' ':al.Retail_Work_Phone__c);   
                    personResults.put('FirstName', string.ISBlank(al.Retail_FirstName__c)?' ':al.Retail_FirstName__c);
                    personResults.put('LastName', string.ISBlank(al.Retail_LastName__c)?' ':al.Retail_LastName__c);
                    personResults.put('Status', (string.ISBlank(al.toRole__c) || string.ISBlank(al.toRole__r.Status__c))?' ':al.toRole__r.Status__c);
                    contacts.add(personResults);
                }
            }
            companyResults.put('Contacts', contacts);
            companyResults.put('Owner', string.ISBlank(users.get(ac.Ownerid).federationIdentifier)?' ':users.get(ac.Ownerid).federationIdentifier);
            companyResultsList.add(companyResults);
        }
        
        return companyResultsList;
        
    }
    
}