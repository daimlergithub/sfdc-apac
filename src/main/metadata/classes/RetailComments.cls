public class RetailComments {
    
    @Auraenabled
    public static String retailComments(String customerId)
    {
        	Id DealeAccId;
       		List<Account_Link__c> Accountlinklist= new list <Account_Link__c>();
            User CurrentUsr = [SELECT Market__c, DMS_UserID__c, IsPortalEnabled, contactid, Id FROM User WHERE Id =: UserInfo.getUserId()];         
           	if (CurrentUsr.ContactId != null) {
            User Usr = [SELECT Market__c, contactId, IsPortalEnabled, Id, contact.AccountId, contact.Account.Dealer_ND_Code__c, Dealer_ND_Code__c FROM User WHERE Id =: UserInfo.getUserId() and User.Profile.UserLicense.Name = 'Partner Community'];

            if (Usr.ContactId != null) {
                List <contact> contactList = [Select id, AccountId from Contact where id =: usr.ContactId];

                If(contactList != null) {
                    for (Contact con: contactList) {
                        DealeAccId = con.AccountId;
                    }
                }
                if(CurrentUsr.Market__c == 'AU' || CurrentUsr.Market__c == 'NZ'){
				Accountlinklist = [select id, IsDeleted__c,fromRole__c, toRole__c, Retail_Duplicate_Flag__c, Retail_Delete_Flag__c from Account_Link__c WHERE fromRole__c =: DealeAccId AND toRole__c =:CustomerId AND Retail_Duplicate_Flag__c = false ORDER BY createdDate];
			
                }
            }
            }
        	return Accountlinklist[0].id;
     /*   User usr = [Select id,name,AccountId,Dealer_ND_Code__c from user where id = :userInfo.getUserId()];    
                // AND Profile.Name='MBANZ Dealer User'
        //Account dealerAcc = [Select id from account where Dealer_ND_Code__c = :usr.Dealer_ND_Code__c];
        List<Account_Link__c> RetailerCopy= [Select id, fromRole__c from account_link__C where toRole__C = :CustomerId order by createdDate];
       // if(usr.Name.contains('Madhusudhan'))
      
        return RetailerCopy[0].Id;
        //if(usr.Name.contains('Bala'))
    	//return RetailerCopy[1].Id;        
        //return null;
        /* 
        Account_Link__c accReturn = new Account_Link__c();
        
        for(Account_link__c accLink : RetailerCopy)  {
            if(accLink.fromRole__c == usr.AccountId){
                accReturn.id = accLink.id;
            }
        }
        
        return accReturn;
		*/ 
    }
}