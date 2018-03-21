public class DMMaterialHelperBase
{
      /*************************************************************************************************************************
        Method Name  : shareDMMaterialRecordsWithDealer
        Created By   : 
        Created Date : 20th March 2018
        Project      : Daimler APAC
        Usages       : This method would share the DM Material records within the dealership based on following condition.
                       1. Records created by Dealer partner user will be shared with the dealer_nd_code__c of the corresponding dealer.
        
      ***************************************************************************************************************************/
    public static void shareDMMaterialRecordsWithDealer (list<DM_Material__c> dmMaterialList, String market)
    {
        if(userinfo.getUserType() == 'PowerPartner')
        {
            list<DM_Material__Share> insertDMMaterialShareList = new list<DM_Material__Share>();
            list<Id> userIdList = new list<Id>();
            set<string> dealerCompNdCodeSet = new set<string>();
            list<Group> dealerCompGroupList = new list<Group>();
            User currentUser = [select Id, Contact.Account.Dealer_Type__c, Contact.Account.Dealer_ND_Code__c from User where Id =: UserInfo.getUserId()];
            
            if(String.isNotBlank(currentUser.Contact.Account.Dealer_ND_Code__c)){
               String dealerndcode = currentUser.Contact.Account.Dealer_ND_Code__c;
               dealerCompGroupList = [select Id, Name from Group where Name = :dealerndcode];
               if(!dmMaterialList.isEmpty() && dmMaterialList != null)
                {
                    for(DM_Material__c dmMtrl : dmMaterialList)
                    {
                        if(!dealerCompGroupList.isEmpty() && dealerCompGroupList != null)
                        {
                            for(group grp : dealerCompGroupList)
                            {
                                DM_Material__Share dmMtrlShare = new DM_Material__Share();
                                dmMtrlShare.ParentId = dmMtrl.Id;
                                dmMtrlShare.AccessLevel = 'Edit';
                                dmMtrlShare.UserOrGroupId = grp.Id;
                                dmMtrlShare.rowcause = 'Manual';
                                insertDMMaterialShareList.add(dmMtrlShare);
                            }
                        }
                    }
                }
            }
            system.debug('*$*$*$*$* insertDMMaterialShareList  ' + insertDMMaterialShareList);
            if(!insertDMMaterialShareList.isEmpty() && insertDMMaterialShareList != null)
            {
                DMLManagerService.InsertAsSystem(insertDMMaterialShareList);
            }
        }
    }
}