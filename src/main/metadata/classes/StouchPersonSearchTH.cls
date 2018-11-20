public class StouchPersonSearchTH {
    public static List<Object> personSearchResultsTH(list<String> accountlinklist1){       
        List<Object> personResultsList=new List<Object>();       
         list<Account_link__c> accountlinklist=[select toRole__r.Name, toRole__r.Salutation__c, Retail_Mobile__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_ID_Number__c,Retail_UCID__c,Retail_Salutation__c, RecordType.Name,Ownerid from account_link__c where id=:accountlinklist1 order by Retail_LastName__c];
        List<id> userIds=new List<Id>();
        for(Account_link__c ac:accountlinklist){
            userIds.add(ac.OwnerId);
        }
        Map<Id,User> users=new map<Id,User>([select id,federationIdentifier from user where id in :userIds]);
        system.debug('@@'+accountlinklist);
        for(Account_link__c acclink:accountlinklist){
           Map<String,Object> PersonResults=new Map<String,Object>();
           personResults.put('PersonMobilePhone',string.ISBlank(acclink.Retail_Mobile__c)? ' ' : acclink.Retail_Mobile__c.remove('-'));
           personResults.put('PersonEmail',string.ISBlank(acclink.Retail_Email__c)? ' '  : acclink.Retail_Email__c);
           personResults.put('HomePhone',string.ISBlank(acclink.Retail_Individual_Home_Phone__c)? ' ' : acclink.Retail_Individual_Home_Phone__c.remove('-'));
           personResults.put('WorkPhone',string.ISBlank(acclink.Retail_Work_Phone__c)? ' '  : acclink.Retail_Work_Phone__c.remove('-'));
           //personResults.put('Salutation',string.ISBlank(acclink.Retail_Salutation__c)? ' '  : acclink.Retail_Salutation__c);
           personResults.put('Salutation',string.ISBlank(acclink.toRole__r.Salutation__c)? ' ' : acclink.toRole__r.Salutation__c);
           personResults.put('AccountName',string.ISBlank(acclink.toRole__r.Name)? ' ' : acclink.toRole__r.Name);
           personResults.put('IDNumber',string.ISBlank(acclink.Retail_ID_Number__c)? ' '  : acclink.Retail_ID_Number__c);
           personResults.put('Personal_UCID__c',string.ISBlank(acclink.Retail_UCID__c)? ' '  : acclink.Retail_UCID__c);
           personResults.put('RecordType',string.ISBlank(acclink.RecordType.Name)? ' '  : acclink.RecordType.Name);
           personResults.put('Owner',string.ISBlank(users.get(acclink.Ownerid).federationIdentifier)?' ':users.get(acclink.Ownerid).federationIdentifier);
           personResultsList.add(personResults);    
        }
        return personResultsList;
    }
}