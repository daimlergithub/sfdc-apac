/**
** Controller is used by ALKDeleteConformationpage 
** This will update the Retail Delete Flag
** Remove the sharing access to Dealer user
** Created By: Kiran P 
** Date: 15-12-2016
** Release : JP-3.0
** Modified By : 
** Modified date :
**/
public class DeleteRetailCopy{
        static Boolean isDeleted = false;
        static Boolean isRetail_Delete = false;
        static List<User> integrationUser = [select id,name, profile.Name from user WHERE profile.Name = 'IntegrationAPI' AND ISActive = true LIMIT 1];
    public static void updateRetailCopy(){    
       
        Account_Link__c acclnk = [select id,Retail_Delete_Flag__c, fromRole__c,toRole__c from  Account_Link__c WHERE Id = : ApexPages.currentPage().getParameters().get('id')];
        acclnk.Retail_Delete_Flag__c = true;
        acclnk.ownerId = integrationUser[0].id;
        update acclnk;
        system.debug('acclnk--->'+acclnk.Id); 
        set<Id> dealerId = new set<Id> ();
        dealerId.add(acclnk.toRole__c);
        if(!dealerId.isEmpty()){
            updateAccoutOwner(dealerId); 
        }
        //update new Account_Link__c(id = ApexPages.currentPage().getParameters().get('id'), Retail_Delete_Flag__c = true);
        
        List<Account_Link__Share> sharesToDelete = [SELECT Id FROM Account_Link__Share WHERE ParentId =: acclnk.Id];
        system.debug('sharesToDelete --->'+sharesToDelete );   
        if(!sharesToDelete.isEmpty()){
            System.debug('Deleting the Share');
            Database.Delete(sharesToDelete, false);            
        }        
    }  
    public static void updateAccoutOwner(set<Id> dealerId){
        List<AccountShare> AccountsharesToDelete = new  List<AccountShare>();
        List<Account> accountupdateList = new List<Account>();
        //List<Account_Link__c> accountlink = [select id,fromRole__c from Account_Link__c WHERE toRole__c = : dealerId];
        for(Account_Link__c acc : [select id,Retail_Delete_Flag__c, fromRole__c from Account_Link__c WHERE toRole__c = : dealerId AND (RecordType.Developername = 'Retail_Company' OR RecordType.Developername = 'Retail_Person')]){
            if(acc.Retail_Delete_Flag__c){
                isDeleted = true;
            }
            if(!acc.Retail_Delete_Flag__c){
                isRetail_Delete = true;            
            }
          }  
            if(isDeleted && !isRetail_Delete){
              // Account act = new Account(id=dealerId, ownerid = integrationUser[0].id );
               //accountupdateList .add(act);
               
               //Commented as part of SFDCJP-2593
                for(Account act : [Select id , Ownerid,CreatedById,CreatedBy.Profile.Name from Account where id in:dealerId]){
                    System.debug('act.CreatedBy.Profile.Name'+act.CreatedBy.Profile.Name);                    
                    if(act.CreatedBy.Profile.Name.Contains('Japan Dealer')){
                        act.OwnerID = integrationUser[0].id;
                       accountupdateList .add(act);
                   }
                }
                 AccountsharesToDelete = [SELECT Id FROM AccountShare WHERE AccountId IN : dealerId ];
            }
    
        if(!accountupdateList.isEmpty())
        update accountupdateList;
        
        if(!AccountsharesToDelete.isEmpty())
        database.delete(AccountsharesToDelete,false);
   }
}