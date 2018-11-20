/**************************************************************************************************************************************************************************** 
* File Name     : AccountContactDetailsDefinition
* Description   : This Class is part of the Factory model and is the Data Object class for the Factory default class 
* Description   : This Data Object is returned to the Lightning component. Any additions to the future markets can be accomodated within this Data Object
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Sarath & 22/08/2018
******************************************************************************************************************************************************************/ 
public class AccountContactDetailsDefinition { 
    
    @AuraEnabled public Map<string,list<string>> inputFieldsMap=new Map<string,list<string>>();
    @AuraEnabled public Map<string,list<string>> outputFieldsMap=new Map<string,list<string>>();
    @AuraEnabled public Map<string,list<string>> labelTHMap=new Map<string,list<string>>();
    @AuraEnabled public Map<string,string> iconTHMap=new Map<string,string>();
    @AuraEnabled public Map<string,string> apiLabelMap=new Map<string,string>();
    @AuraEnabled public list<string> thList = new list<string>();
}