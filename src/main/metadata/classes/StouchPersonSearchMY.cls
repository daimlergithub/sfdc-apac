/**  
* Class Name: StouchPersonSearchMY
* Description : This class is for 'MY' (Malaysia) Market Person Search API for Stouch App.
* Author : Vinod Kumar G
* Modification Log *
===============================================================
Ver     Date            Author              Modification
=============================================================== 
* */
public class StouchPersonSearchMY {
    Public static List<Object> personSearchResultsMY(List<string> accountlinklist1){
        List<Object> personResultsList = new List<Object>();
        List<Account_Link__c> accountlinklist=[select Retail_FirstName__c,Retail_LastName__c,
                                               Retail_Mobile__c,Retail_Email__c,Retail_Individual_Home_Phone__c,
                                               Retail_Work_Phone__c,Retail_UCID__c,RecordType.Name,
                                               OwnerID,toRole__c, toRole__r.Status__c from Account_Link__c where id=:accountlinklist1 order by Retail_LastName__c];
        List<id> userIds=new List<Id>();
        for(Account_link__c ac:accountlinklist){
            userIds.add(ac.OwnerId);
        }
        Map<Id,User> users=new map<Id,User>([select id,federationIdentifier from user where id in :userIds]);
        
        for(Account_Link__c acclink:accountlinklist){
            Map<String,Object> PersonSearchResults=new Map<String,Object>();
            PersonSearchResults.put('PersonMobilePhone',string.isBlank(acclink.Retail_Mobile__c)? ' ': acclink.Retail_Mobile__c);
            PersonSearchResults.put('PersonEmail',string.isBlank(acclink.Retail_Email__c)? ' ': acclink.Retail_Email__c);
            PersonSearchResults.put('Home_Phone',string.isBlank(acclink.Retail_Individual_Home_Phone__c)? ' ': acclink.Retail_Individual_Home_Phone__c);
            PersonSearchResults.put('Work_Phone',string.isBlank(acclink.Retail_Work_Phone__c)? ' ': acclink.Retail_Work_Phone__c);
            PersonSearchResults.put('First_Name',string.isBlank(acclink.Retail_FirstName__c)? ' ': acclink.Retail_FirstName__c);
            PersonSearchResults.put('Last_Name',string.isBlank(acclink.Retail_LastName__c)? ' ': acclink.Retail_LastName__c);
            PersonSearchResults.put('Status',(String.ISBlank(acclink.toRole__c) || String.ISBlank(acclink.toRole__r.Status__c)) ?' ':acclink.toRole__r.Status__c);
            PersonSearchResults.put('Personal_UCID__c',string.isBlank(acclink.Retail_UCID__c)? ' ': acclink.Retail_UCID__c);
            PersonSearchResults.put('RecordType',string.isBlank(acclink.RecordType.Name)? ' ': acclink.RecordType.Name);
            PersonSearchResults.put('Owner',string.isBlank(users.get(acclink.Ownerid).federationIdentifier)?' ':users.get(acclink.Ownerid).federationIdentifier);
            personResultsList.add(PersonSearchResults);
        }
        return personResultsList;
    }
}