/**************************************************************************************************************************************************************************** 
* File Name     : FactoryHelper
* Description   : Factory Helper Class to return MetaData record
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Sarath & 22/08/2018
******************************************************************************************************************************************************************/ 
public class FactoryHelper {   
    @TestVisible private static Factory_Fields__mdt ffRec;
    //public static AuraHandledException auraExceptionObj;
    public static Factory_Fields__mdt getMetaDataRec(String market,String componentName) 
    {
        try
        {
            String soqlString;
            soqlString = 'Select Class_Name__c,market__c,MaxAddressCount__c,Table_Columns__c,Buttons__c,Display_Fields__c,Input_Fields__c,show_records__c,Output_Fields__c,Record_Type__c,sObject__c,Tile_Heading__c from  Factory_Fields__mdt where Market__c=';
            soqlString += ':'+ 'market';
            if (componentName != null && componentName != '') {
                soqlString += ' and Component_Name__c = '+':'+'componentName';
            }
            soqlString += ' LIMIT 1';
            
            ffRec = Database.query(soqlString);
            
        }
        catch (System.QueryException qe) { 
            AuraHandledException auraExceptionObj = new AuraHandledException(qe.getMessage());
            auraExceptionObj.setMessage(Label.MetadataError_Lightning + qe.getStackTraceString());
            CustomLogUtil.CustomLoggingEntry('Error Occured ' +qe.getMessage()+ qe.getStackTraceString());
            throw auraExceptionObj; 
        }
        catch(exception e) {
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(Label.ErrorCheck_Lightning + e.getStackTraceString());
            CustomLogUtil.CustomLoggingEntry('Error Occured ' +e.getMessage()+ e.getStackTraceString());
            throw auraExceptionObj; 
        }
        return ffRec;
    }
    
    public static Factory_Fields__mdt getMetaDataRec(String obj,String market, String recordType, String componentName)
    {
        String soqlString;
        soqlString = 'Select Class_Name__c,MaxAddressCount__c,Input_Fields__c,Buttons__c,Display_Fields__c,PrePopulated_Values__c,Output_Fields__c,show_records__c,Record_Type__c,sObject__c,Tile_Heading__c,Table_Columns__c from Factory_Fields__mdt where Market__c=';
        soqlString += ':'+ 'market';
        
        if (recordType != null && recordType != '') {
            soqlString += ' and record_Type__c = '+':'+ 'recordType';
        }
        
        if (componentName != null && componentName != '') {
            soqlString += ' and Component_Name__c = '+':'+'componentName';
        }
        
        if (obj != null && obj != '') {
            soqlString += ' and sObject__c = '+':'+'obj';
        }else{
            soqlString += ' and sObject__c = null';
        }
        soqlString += ' LIMIT 1';
        try
        {
            ffRec = Database.query(soqlString);
        }
        catch (System.QueryException qe) { 
            AuraHandledException auraExceptionObj = new AuraHandledException(qe.getMessage());
            auraExceptionObj.setMessage(Label.MetadataError_Lightning + qe.getStackTraceString());
            CustomLogUtil.CustomLoggingEntry('Error Occured ' +qe.getMessage()+ qe.getStackTraceString());
            throw auraExceptionObj; 
        }
        catch(exception e) {
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(Label.ErrorCheck_Lightning +  e.getStackTraceString());
            CustomLogUtil.CustomLoggingEntry('Error Occured ' +e.getMessage()+ e.getStackTraceString());
            throw auraExceptionObj; 
        }
        return ffRec;
    }
    
    public static Factory_Fields__mdt getMetaDataRec(String market, String recordType, String componentName)
    {
        String soqlString;
        soqlString = 'Select Class_Name__c,MaxAddressCount__c,Input_Fields__c,Buttons__c,Display_Fields__c,PrePopulated_Values__c,Output_Fields__c,show_records__c,Record_Type__c,sObject__c,Tile_Heading__c,Table_Columns__c from Factory_Fields__mdt where Market__c=';
        soqlString += ':'+ 'market';
        
        if (recordType != null && recordType != '') {
            soqlString += ' and record_Type__c = '+':'+ 'recordType';
        }
        
        if (componentName != null && componentName != '') {
            soqlString += ' and Component_Name__c = '+':'+'componentName';
        }
        soqlString += ' LIMIT 1';
        try
        {
            ffRec = Database.query(soqlString);
        }
        catch (System.QueryException qe) { 
            AuraHandledException auraExceptionObj = new AuraHandledException(qe.getMessage());
            auraExceptionObj.setMessage(Label.MetadataError_Lightning + qe.getStackTraceString());
            CustomLogUtil.CustomLoggingEntry('Error Occured ' +qe.getMessage()+ qe.getStackTraceString());
            throw auraExceptionObj; 
        }
        catch(exception e) {
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(Label.ErrorCheck_Lightning +  e.getStackTraceString());
            CustomLogUtil.CustomLoggingEntry('Error Occured ' +e.getMessage()+ e.getStackTraceString());
            throw auraExceptionObj; 
        }
        return ffRec;
    }
    
}