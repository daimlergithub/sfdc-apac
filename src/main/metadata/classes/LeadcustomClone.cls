/**
** Class for Lead Custom Clone 
** 
** Created By: Ramana
** Date: 26-11-2016
** Modified By : 
** Modified date :
**/

global class LeadcustomClone
{
    private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
    webservice static id cloneLead(Id LeadId) // you can pass parameters
    {        
       Lead__c acc = [SELECT ID, Name ,Contact__c ,RecordtypeId ,Related_Leads__c FROM Lead__c WHERE Id = : LeadId];              
           Lead__c accCopy = acc.clone(false, false, false, false);
               if(acc.RecordtypeId == salesRecordTypeId){
                accCopy.RecordtypeId = afterSalesRecordTypeId ;
               }
               if(acc.RecordtypeId == afterSalesRecordTypeId ){
               accCopy.RecordtypeId = salesRecordTypeId;
               }
               accCopy.Contact__c = acc.Contact__c; 
               accCopy.Related_Leads__c = acc.Id;             
               insert accCopy;
               acc.Related_Leads__c = accCopy.Id;
               acc.CAC_Lead_Status__c = 'Lost(CAC)';
               acc.Lost_Comment__c = 'Converted to After-Sales Leads';
               update acc; 
               return accCopy.id;         
    }
}