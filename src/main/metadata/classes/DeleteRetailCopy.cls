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
    public void updateRetailCopy(){    
    
        Account_Link__c acclnk = [select id,Retail_Delete_Flag__c, fromRole__c from  Account_Link__c WHERE Id = : ApexPages.currentPage().getParameters().get('id')];
        acclnk.Retail_Delete_Flag__c = true;
        update acclnk;
        
        //update new Account_Link__c(id = ApexPages.currentPage().getParameters().get('id'), Retail_Delete_Flag__c = true);
        
        List<Account_Link__Share> sharesToDelete = [SELECT Id 
                                                FROM Account_Link__Share
                                                WHERE ParentId =: ApexPages.currentPage().getParameters().get('id') AND UserOrGroupId =: acclnk.fromRole__c];
                                            //AND RowCause = 'Manual'];
        system.debug('sharesToDelete --->'+sharesToDelete );   
        if(!sharesToDelete.isEmpty()){
            System.debug('Deleting the Share');
            Database.Delete(sharesToDelete, false);
        }
        
    }  
}