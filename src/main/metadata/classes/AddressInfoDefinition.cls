/**************************************************************************************************************************************************************************** 
* File Name     : AddressInfoDefinition
* Description   : This Class is part of the Factory model and is the Data Object class for the Factory default class 
* Description   : This Data Object is returned to the Lightning component. Any additions to the future markets can be accomodated within this Data Object
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Sarath & 22/08/2018
******************************************************************************************************************************************************************/ 
public class AddressInfoDefinition {     
    @AuraEnabled public Map<String,List<String>> factoryFieldsMap = new Map<String,List<String>>();
    @AuraEnabled public List<Address__c> addressList=new List<Address__c>();
    @AuraEnabled public Integer maxAddressCount;   
}