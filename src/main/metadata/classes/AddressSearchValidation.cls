/**************************************************************************************************************************************************************************** 
* File Name     : AddressSearchValidation
* Description   : This Class is part of the Factory model
* Description   : This class along with AddressSearchValidationFactory,AddressSearchValidationDefault are part of the Factory model along with Market specific Classes. 
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Sravani & 22/08/2018
******************************************************************************************************************************************************************/ 
public interface AddressSearchValidation{
    Map<String,List<String>> retrieveFieldSet(SObject sObj, String componentName,String recordTypeId,String market);
    Map<String,List<String>> onLineDeduplication(List<sObject> sObjList, String filterName);
    Map<String,List<String>> submitForm(List<sObject> sObjList, String filterName);
    String getCDMURL(String Recordtype,Account objAccount,Boolean firstsave,String market,Address__c AddressObj);
    Factory_Fields__mdt getmdRec();
    void setmdRec(Factory_Fields__mdt rec);
}