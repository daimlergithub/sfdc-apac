/**
** Generate pdf file for a case and file should be attached in Attachment object.
** Audit Trail should be generated on downloading the pdf file.
** Created By: Sneha
** Modified BY : Sudhir
** Date: 11/06/2015(mm/dd/yy)    
**/  
public with sharing class GeneratePDFControllerKR 
{
   public Case cas{get;set;}
   public String attachmentName;
   public Vehicle_Relationship__c VehicleRelationshipList{get;set;}
   public String CustomerStatement{get;set;}
   public String PRCommentForDealer {get;set;}
   public static final Integer LINE_LENGTH = 57;
   public user usr{get;set;}

   public GeneratePDFControllerKR(ApexPages.StandardController controller) 
   {
       usr = [select id,Market__c from user where id =:userinfo.getUserId()];
       this.cas=(Case)controller.getRecord();  
       cas=[select id,Vehicle__c,CaseNumber,AccountId,Account.FirstName_Native_1__c,Account.LastName_Native_1__c,Customer_Statement__c,PR_Comment_for_Dealer__c from case Where id=:ApexPages.currentPage().getParameters().get(System.Label.Id)];         	
       system.debug('Entered>>>');
       system.debug('First Name Native>>>>>' + cas.Account.FirstName_Native_1__c + 'Last name Native' + cas.Account.LastName_Native_1__c);
       if(cas.Vehicle__c!=Null && cas.AccountId!=Null)
       {
           List<Vehicle_Relationship__c> lstVehicleRelationship=[Select id,Vehicle_ID__c,Contact__c,Selling_Dealer__c,Selling_Dealer__r.Name,Last_Service_Dealer__c,Last_Service_Dealer__r.Name,toLabel(Finance_Method__c),Registration_Date__c,Registration_Number__c
                                                                 from Vehicle_Relationship__c Where Vehicle_ID__c=:cas.Vehicle__c  AND Contact__c=:cas.AccountId limit 1];
           system.debug('lstVehicleRelationship>>>>>>' + lstVehicleRelationship);
           system.debug('lstVehicleRelationship>>>>>>' + lstVehicleRelationship[0]);
           if(lstVehicleRelationship!=null && !lstVehicleRelationship.isEmpty())
           {                                
               VehicleRelationshipList=lstVehicleRelationship[0];               
           }
       }    
   }
}