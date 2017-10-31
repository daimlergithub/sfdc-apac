/*
    Type:       controller
    Purpose:    DMSendResult General Controller
    User Story: US-DM-002 - Send DM content to customer

    Used By:    VF Page - DMSendResult.page
    ---------------------------------------------------------------
    History:

    28-Mar-2013 Chris Huang (Breakingpoint)    Created

*/
/**
** Wrap service for retail tasks to share.
** 1. DM Send Page controller
** Created By: Chris Huang
** Date: 2013-3-28
**/


public class DMControllerExtension {
    /* Public Properties */
    public DM_Request__c dm {get;set;}

    /* Private Properties */
    private Account accountObject {get;set;}
    private Case caseObject {get;set;}
    private ApexPages.standardController controller {get;set;}
    
     /* Constructors */
     
    /* Public Methods */
    public PageReference send(){
       /**      
     * @Description By checking the Customer_Name field the dm request is inserted using standard controller.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  
                * @return null
                 * @see PageReference send  
                */     
        dm = (DM_Request__c)controller.getRecord();
        if(dm.Customer_Name__c!=null){
            insert dm;
            createActivity();
        }

        return null;
    }
  
  
    /* Private Methods */
  
    private void createActivity(){
   /**      
     * @Description the WhatId and WhoId is being created of the dm task. 
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  
                * @return DmTask is inserted. 
                 * @see   createActivity.
                */    

        DMTask.WhatId = dm.Id;
        
        if(accountObject!=null){
            List<Contact> contactList = [Select Id From Contact Where accountId = :accountObject.Id];           
            if(contactList!=null && contactList.size()>0){
                DMTask.WhoId = contactList[0].Id;
            }    
        }
        
        DMTask.RecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('DM').getRecordTypeId();
        
        insert DMTask;  
    }
  
    private Task DMTask {
        get{
            if (DMTask == null){
                Task t = new Task();
                t.Subject = 'DM';
                t.IsReminderSet = false;
                t.Status = 'Closed';
                t.Activity_Status__c = 'Open';
                DMTask = t;
            }
            return DMTask ;
        }
        set;
    } 

    /* Static initialisers */
  
    public DMControllerExtension(ApexPages.StandardController stdController) {
       /**      
     * @Description From page parameters through the account set the customer_name is being fetched and validated.
     * @Description case is being set if the dm request comes from the case.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  retailTasks is a list having all the new records of Retail_Task Object.
                * @return Dm Send.
                 * @see   DMControllerExtension
                */    
    
        controller = stdController;       
        this.dm = (DM_Request__c)stdController.getRecord();

        //set account
        String accountId = ApexPages.currentPage().getParameters().get('accountId');
        
        if(accountId != null && accountId != ''){
            List<Account> aList = [Select Id,Province__c, City__c, Primary_Address__c From Account Where Id = :accountId];

            if(aList!=null && aList.size()>0){
                accountObject = aList[0];
            }               
            
            if(accountObject!=null){
                dm.Customer_Name__c = accountObject.Id;
            
                if(accountObject.Province__c == null || accountObject.City__c == null || accountObject.Primary_Address__c == null){                    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Customer address is not entirety, please fill it first.'));                
                }
            }
        }
        
        if(accountObject==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Customer does not exist, you cannot send this DM Request.'));
        } 
        String caseId = ApexPages.currentPage().getParameters().get('caseId');

        if(caseId != null && caseId != ''){
           caseObject = [Select Id,CaseNumber,Campaign__c From Case Where Id = :caseId];
           dm.Case_Number__c = caseId;
           dm.Campaign__c = caseObject.Campaign__c;
       }
    }
}