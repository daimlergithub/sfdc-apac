/**  
* Class Name: StouchCompanySearchTH
* Description : This class is for 'TH' (Thiland) Market Company Search API for Stouch App.
* Author : Narendra Nimmana
* Modification Log *
=============================================================== 
Ver 	Date 			Author 				Modification --- ---- ------ -------------
C1.0     24/07/2018		Ashish Jadhav		Added the Fields to response:- Commercial Register Number : Account.Commercial_Reg_No__c
																		   Mobile :Account_link__c.Retail_Mobile__c
											Removed Fields from response:- Fax : Account_link__c.Retail_Fax__c
=============================================================== 
* */ 
public class StouchCompanySearchTH {
    public static List<Object> companySearchResultsTH(list<String> accountlinkIds, Id contactToContactRecordTypeId){
        list<Account_link__c> accountlinklist=[select Retail_Company_Name__c,Retail_Email__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Fax__c,Retail_Company_Other_Phone__c,toRole__c,toRole__r.Name,Retail_UCID__c,Retail_Related_Company__c,Ownerid,
                                               //Added below field in query as per changes recommended by FE team approved by Shini   BY:Ashish Jadhav date:20th July 2018.
                                               toRole__r.Data_Source__c,toRole__r.Commercial_Reg_No__c,
                                              (select id,toRole__c,toRole__r.LastName,Retail_Mobile__c,Retail_Email__c,Retail_UCID__c,Ownerid,Retail_ID_Type__c,Retail_Work_Phone__c,Retail_Full_Name__c  from Account_Link__r limit 3) 
                                               from account_link__c where id=:accountlinkIds order by Retail_Company_Name__c];
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
            companyResults.put('Company_Name__c', string.ISBlank(ac.Retail_Company_Name__c)?' ':ac.Retail_Company_Name__c);
            companyResults.put('Email', string.ISBlank(ac.Retail_Email__c )?' ':ac.Retail_Email__c);
            companyResults.put('HomePhone', string.ISBlank(ac.Retail_Company_Phone__c )? ' ':ac.Retail_Company_Phone__c );
            //companyResults.put('Fax', string.ISBlank(ac.Retail_Fax__c )?' ':ac.Retail_Fax__c);
            companyResults.put('WorkPhone', string.ISBlank(ac.Retail_Company_Other_Phone__c)?' ':ac.Retail_Company_Other_Phone__c);
            companyResults.put('AccountName', string.ISBlank(ac.toRole__r.Name)? ' ':ac.toRole__r.Name);
            companyResults.put('Company__c', string.ISBlank(ac.Retail_Related_Company__c)? ' ':ac.Retail_Related_Company__c);
            companyResults.put('Company_UCID__c', string.ISBlank(ac.Retail_UCID__c)? ' ':ac.Retail_UCID__c);  
            //Added below field in query as per changes recommended by FE team approved by Shini   BY:Ashish Jadhav date:20th July 2018.
            companyResults.put('Data_Source__c', string.ISBlank(ac.toRole__r.Data_Source__c)? ' ':ac.toRole__r.Data_Source__c);
            companyResults.put('Commercial Register Number', string.ISBlank(ac.toRole__r.Commercial_Reg_No__c)? ' ':ac.toRole__r.Commercial_Reg_No__c); 
            companyResults.put('Mobile', string.ISBlank(ac.Retail_Mobile__c)? ' ':ac.Retail_Mobile__c); 
            List<Object> contacts=new List<Object>();
            
            if(ac.Account_Link__r.size()==0){
                Map<String,Object> personResults=new Map<String,Object>();
                
                personResults.put('Personal_UCID__c', ' ');
                personResults.put('Account Name', ' ');
                personResults.put('PersonalMobilePhone', ' ');
                personResults.put('Owner', ' ');
                personResults.put('IDNumber', ' ');
                personResults.put('PersonEmail', ' ');
                personResults.put('WorkPhone', ' ');
                contacts.add(personResults);
            }
            
            //Changed/Added some params in Contact setion on market request  date:18th July 2018 by Ashish Jadhav.
            for(Account_link__c al:ac.Account_Link__r){
                Map<String,Object> personResults=new Map<String,Object>();
                personResults.put('Personal_UCID__c', string.ISBlank(al.Retail_UCID__c)?' ':al.Retail_UCID__c);
                personResults.put('AccountName', string.ISBlank(al.Retail_Full_Name__c)? ' ':al.Retail_Full_Name__c);
                personResults.put('PersonalMobilePhone', string.ISBlank(al.Retail_Mobile__c)?' ':al.Retail_Mobile__c.remove('-'));
                personResults.put('IDNumber', string.ISBlank(al.Retail_ID_Type__c)?' ':al.Retail_ID_Type__c);  
                personResults.put('PersonEmail', string.ISBlank(al.Retail_Email__c)?' ':al.Retail_Email__c);
                personResults.put('WorkPhone', string.ISBlank(al.Retail_Work_Phone__c)?' ':al.Retail_Work_Phone__c);   
                personResults.put('Owner', string.ISBlank(users.get(al.Ownerid).federationIdentifier)?' ':users.get(al.Ownerid).federationIdentifier);
                contacts.add(personResults);
            }
            
            companyResults.put('Contacts', contacts);
            companyResults.put('Owner', string.ISBlank(users.get(ac.Ownerid).federationIdentifier)?' ':users.get(ac.Ownerid).federationIdentifier);
            companyResultsList.add(companyResults);
        }
        
        return companyResultsList;
        
    }
    
}