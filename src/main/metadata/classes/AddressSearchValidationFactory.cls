/**************************************************************************************************************************************************************************** 
* File Name     : AddressSearchValidationFactory
* Description   : This Class is part of the Factory model and controls the logic that needs to be executed for each and every market
* Description   : This class along with AddressSearchValidation,AddressSearchValidationDefault are part of the Factory model along with Market specific Classes. 
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Sravani & 22/08/2018
******************************************************************************************************************************************************************/ 
public class AddressSearchValidationFactory{
    private static AddressSearchValidation retInstance{get;set;}
    private static Factory_Fields__mdt metaRec {get;set;}
    public static AddressSearchValidation retrieveFieldSetValidate(String market,String recordType, String componentName) {
        try{
            metaRec=FactoryHelper.getMetaDataRec(market,recordType,componentName);
            if (metaRec.Class_Name__c != null && metaRec.Class_Name__c != ''){
                retInstance = (AddressSearchValidation)Type.forName(metaRec.Class_Name__c).newInstance();    
            } else {
                retInstance = new AddressSearchValidationDefault();
            }
            retInstance.setmdRec(metaRec);
            return retInstance;  
        }
        catch (Exception e) {
            system.debug('message 2' +e.getMessage());
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(Label.ErrorCheck_Lightning + 'Error Details :  '+ e.getStackTraceString());
            throw auraExceptionObj;
        }
    }
}