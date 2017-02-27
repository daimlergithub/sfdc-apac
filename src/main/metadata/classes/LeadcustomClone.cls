/**
** Class for Lead Custom Clone 
** 
** Created By: Ramana
** Date: 26-11-2016
** Modified By : Venky
** Modified date : 27/2/2017
** Description : Changes related to SFDCJP-1760.
**/

global class LeadcustomClone
{
    private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
    webservice static id cloneLead(Id LeadId) // you can pass parameters
    {        
       Lead__c acc = [SELECT ID, Name ,Contact__c ,RecordtypeId ,Wholesale_Comment__c,Retail_Contact__c,Dealer_DMS_Comments__c,Visited_Showroom_Date__c,Next_Contact_Customer_Date__c,Next_Contact_Contents__c,Dealer_Comment__c,Contact_Date__c,Questionnair__c,Dealer_Comments__c,Collectioner_Notes__c,Opportunity_Name__c,Payment_Mode__c,Portal_Request_ID__c,Accepted_Date_Time__c,Assigned_Date_Time__c,Drop_off_Time__c,Company_Account__c,Customer_Type__c,Service_Advisor__c,Assigned_Dealer__c,Case__c,Expected_Close_Date__c,Lead_Possibility_text__c,Related_Leads__c,Source_Campaign__c,Lead_DataSource__c FROM Lead__c WHERE Id = : LeadId];              
           Lead__c accCopy = acc.clone(false, false, false, false);
               if(acc.RecordtypeId == salesRecordTypeId){
                accCopy.RecordtypeId = afterSalesRecordTypeId ;
               }
               if(acc.RecordtypeId == afterSalesRecordTypeId ){
               accCopy.RecordtypeId = salesRecordTypeId;
               }
               accCopy.Contact__c = acc.Contact__c; 
               accCopy.Related_Leads__c = acc.Id; 
               accCopy.Lead_DataSource__c =Acc.Lead_DataSource__c;
               accCopy.Source_Campaign__c =Acc.Source_Campaign__c;
               accCopy.Lead_Possibility_text__c =Acc.Lead_Possibility_text__c;
               accCopy.Expected_Close_Date__c =Acc.Expected_Close_Date__c;
               accCopy.Case__c =Acc.Case__c;
               accCopy.Assigned_Dealer__c =Acc.Assigned_Dealer__c;
               accCopy.Service_Advisor__c  =Acc.Service_Advisor__c;        
               accCopy.Customer_Type__c =Acc.Customer_Type__c;
               accCopy.Company_Account__c =Acc.Company_Account__c;
               accCopy.Drop_off_Time__c =Acc.Drop_off_Time__c;
               accCopy.Assigned_Date_Time__c =Acc.Assigned_Date_Time__c;
               accCopy.Portal_Request_ID__c =Acc.Portal_Request_ID__c;
               accCopy.Accepted_Date_Time__c =Acc.Accepted_Date_Time__c; 
               accCopy.Payment_Mode__c =Acc.Payment_Mode__c;
               accCopy.Opportunity_Name__c =Acc.Opportunity_Name__c;
               accCopy.Dealer_Comments__c =Acc.Dealer_Comments__c;
               accCopy.Collectioner_Notes__c =Acc.Collectioner_Notes__c;
               accCopy.Questionnair__c =Acc.Questionnair__c;
               accCopy.Dealer_Comment__c =Acc.Dealer_Comment__c;
               accCopy.Contact_Date__c =Acc.Contact_Date__c;
               accCopy.Next_Contact_Contents__c =Acc.Next_Contact_Contents__c;
               accCopy.Next_Contact_Customer_Date__c =Acc.Next_Contact_Customer_Date__c;
               accCopy.Visited_Showroom_Date__c =Acc.Visited_Showroom_Date__c;
               accCopy.Dealer_DMS_Comments__c =Acc.Dealer_DMS_Comments__c;
               accCopy.Wholesale_Comment__c =Acc.Wholesale_Comment__c;               
               accCopy.Retail_Contact__c=Acc.Retail_Contact__c;
               
                     
               insert accCopy;
               acc.Related_Leads__c = accCopy.Id;
               acc.Dealer_Lead_Status__c = 'Lost';
               acc.Dealer_Lost_Reason__c = 'Other reasons';
               acc.Lost_Situation__c = 'Others';
               acc.Lost_Comment__c = 'Converted to After-Sales Leads';
               update acc; 
               return accCopy.id;         
    }
}