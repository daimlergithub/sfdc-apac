/**************************************************************************************************************************************************************************** 
* File Name     : AccountContactInfoFactory
* Description   : This Class is part of the Factory model and controls the logic that needs to be executed for each and every market
* Description   : This class along with AccountContactInfo,AccountContactInfoDefault are part of the Factory model along with Market specific Classes. 
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Sarath & 22/08/2018
******************************************************************************************************************************************************************/ 
public class AccountContactInfoFactory{  
    private static AccountContactInfo retInstance{get;set;}
    private static Factory_Fields__mdt metaRec;
    public static AccountContactInfo fetchInstance(String userId,String componentName) {  
        try
        {
            User user=UtilLTG.getUserRec(userId);
            metaRec=FactoryHelper.getMetaDataRec(user.market__c,componentName);
            system.debug('metaRec' +metaRec);
            if (metaRec.Class_Name__c != null && metaRec.Class_Name__c != '') 
            {
                retInstance = (AccountContactInfo)Type.forName(metaRec.Class_Name__c).newInstance();
                
            } else {
                retInstance = new AccountContactInfoDefault();
            }
            retInstance.setMetaRec(metaRec);
            return retInstance; 
        }      
        catch (exception e)
        {
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(e.getMessage());
            CustomLogUtil.CustomLoggingEntry('Error Occured ' +e.getMessage()+ e.getStackTraceString());
            throw auraExceptionObj; 
        } 
    }
    
}