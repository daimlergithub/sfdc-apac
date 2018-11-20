/**************************************************************************************************************************************************************************** 
* File Name     : LeadDetailsFactory
* Description   : This Class is part of the Factory model and controls the logic that needs to be executed for each and every market
* Description   : This class along with LeadDetails,LeadDetailsDefault are part of the Factory model along with Market specific Classes. 
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Harshit & 31/08/2018
******************************************************************************************************************************************************************/ 
public class LeadDetailsFactory {

    private static LeadDetails retInstance{get;set;}
    private static Factory_Fields__mdt metaRec {get;set;}
    public static LeadDetails fetchInstance(String obj,String market, String recordType, String componentName) {  
        metaRec=FactoryHelper.getMetaDataRec(obj,market,recordType,componentName);
        
        if (metaRec.Class_Name__c != null && metaRec.Class_Name__c != '') 
        {
          retInstance = (LeadDetails)Type.forName(metaRec.Class_Name__c).newInstance();
        } else {
            retInstance = new LeadDetailsDefault();
        }
        retInstance.setmdRec(metaRec);
        return retInstance;   
    } 
}