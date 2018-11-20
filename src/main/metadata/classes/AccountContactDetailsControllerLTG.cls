/* File Name   : AccountContactDetailsControllerLTG -->
<!-- Description : AccountContactTableLCController apex class Server side controller for AccountContactTableLC -->
<!-- Copyright   : Infosys Limited Copyright (c) 2018  -->
<!-- @author     : Sarath -->
<!-- Author Modification & Ver.Date : Sarath & 10-July-2018  */
public class AccountContactDetailsControllerLTG {
    @AuraEnabled
    public static AccountContactDetailsDefinition fetchFields(String componentName){
        
        try
        {
            string userId=UserInfo.getUserId();
            AccountContactInfo valObj = AccountContactInfoFactory.fetchInstance(userId,componentName); 
            AccountContactDetailsDefinition resultFields = valObj.getFields();
            system.debug('resultFields' +resultFields);
            return resultFields; 
        }
        catch (Exception e) 
        {
            system.debug('message 3' +e.getMessage());
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(Label.ErrorCheck_Lightning + e.getMessage());
            throw auraExceptionObj; 
        }
    }
}