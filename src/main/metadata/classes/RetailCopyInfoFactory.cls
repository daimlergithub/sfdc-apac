/**************************************************************************************************************************************************************************** 
* File Name     : RetailCopyInfoFactory
* Description   : This Class is part of the Factory model and controls the logic that needs to be executed for each and every market
* Description   : This class along with RetailCopyInfo,RetailCopyInfoDefault are part of the Factory model along with Market specific Classes. 
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Sarath & 22/08/2018
******************************************************************************************************************************************************************/ 
public class RetailCopyInfoFactory{  
    private static RetailCopyInfo retInstance{get;set;}
    private static Factory_Fields__mdt metaRec;
    public static RetailCopyInfo fetchInstance(String componentName,String market) {  
        try{
            metaRec=FactoryHelper.getMetaDataRec(market,componentName);
            if (metaRec.Class_Name__c != null && metaRec.Class_Name__c != '') 
            {
                retInstance = (RetailCopyInfo)Type.forName(metaRec.Class_Name__c).newInstance();    
            } else {
                retInstance = new RetailCopyInfoDefault();
            }
            retInstance.setMetaRec(metaRec);
            return retInstance; 
        }catch(Exception e){
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(e.getMessage());
            throw auraExceptionObj;  
        } 
    }
}