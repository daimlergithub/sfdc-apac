/**
** SMSSendLeadResult General Controller
** Created By: Sinow
** Date: 2013-5-20
**/

public with sharing class SMSSendLeadResultExtension 
{
    /* Public Properties */
    public SMS__c sms { get; set; }
    public String templateId { get; set; }
    public String templateMessage { get; set; }
    public Lead__c leadInfo {get;set;}
  
    
    /* Private Properties */
    private Map<String, String> templateMap { get; set; }
    private Map<String, String> templateNameMap { get; set; }
    private ApexPages.standardController controller {get;set;}
      private Task smsTask 
    {
        get
        {
            if(smsTask == null)
            {
                smsTask = new Task();
                smsTask.Subject = 'SMS';
                smsTask.Status = 'Closed';
                smsTask.Activity_Status__c = 'Sent';
                smsTask.RecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
            }
            return smsTask;
        }
        set;
    }

    /* Public Methods */
       /**      
     * @Description standard controller performs the save and redirect, and all the validation rules are there with their error messages.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  
                * @return the controller
                 * @see   send
                */    
    
    public PageReference send() 
    {
        if(leadInfo.Contact__r.PersonOtherPhone == null && leadInfo.Contact__r.PersonMobilePhone == null)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please collect Customer\'s Mobile number first.'));
        }
        if(templateId == null || templateId == '' || templateId == 'None')
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You have to select one SMS template.'));
            return null;
        }
        if(templateMessage == '' || templateMessage == null)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'SMS Preview is blank, Please fulfill it.'));
            return null;
        }
        
        createActivity();

        return controller.cancel();
    }

    
     /**      
     * @Description value is set for the template message, and the validation rules with error messages.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  
                * @return null
                 * @see   parseTemplateMessage
                */   
    public PageReference parseTemplateMessage()
    {
        if(templateMap.containsKey(templateId)) 
        {
            if(templateMap.get(templateId).indexOf('{DEALER_')!= -1)
            {
                templateMessage = templateMap.get(templateId);
              
            }
            else
            {
                if(sms.Dealer__c == null)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You have to select one Dealer.'));
                    return null;
                }
                templateMessage = optimzeContent(templateMap.get(templateId));
            }
        }
        
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You have to select one SMS template.'));
            templateMessage = '';
        }
        return null;
    }
    /**      
     * @Description fields are merged for the message.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  temporary string
                * @return content
                 * @see   optimzeContent
                */ 
    public String optimzeContent(String temp)
    {
        String handledContent = temp;
        if(handledContent.indexOf('{') != -1)
        {
            do
            {
                Integer mergeIndexStart = handledContent.indexOf('{');
                Integer mergeIndexEnd = handledContent.indexOf('}');
                String mergeObjectField = handledContent.subString(mergeIndexStart + 1, mergeIndexEnd);
                if(mergeObjectField.indexOf('_') != -1)
                {
                   handledContent = handledContent.subString(0, mergeIndexStart) + ' ' + handledContent.subString(mergeIndexEnd + 1); 
                }
                else
                {
                    String mergeObject = mergeObjectField.subString(0, mergeObjectField.indexOf('_'));
                    String mergeField = mergeObjectField.subString(mergeObjectField.indexOf('_') + 1);
                    if(mergeObject == 'DEALER' && sms.Dealer__c != null)
                    {
                        if(mergeField != 'ADDRESS')
                        {
                           Account dealerInfo = [select Dealer_Address_CN__c, City__c, Province__c from Account where Id = :sms.Dealer__c limit 1];
                            String dealerAddress = '';
                            if(dealerInfo.Province__c != null) {
                                dealerAddress += dealerInfo.Province__c;
                            }
                            if(dealerInfo.City__c != null) {
                                dealerAddress += dealerInfo.City__c;
                            }
                            if(dealerInfo.Dealer_Address_CN__c != null) {
                                dealerAddress += dealerInfo.Dealer_Address_CN__c;
                            }
                            handledContent = handledContent.subString(0, mergeIndexStart) + dealerAddress + handledContent.subString(mergeIndexEnd + 1);
                        }
                        else
                        {
                            String dealerQuery = 'select ' + mergeField + ' from Account where Id = \'' + sms.Dealer__c + '\'';

                            List<Account> dealerQuerys = Database.query(dealerQuery);
                            If(dealerQuerys[0].get(mergeField) != null) {
                                handledContent = handledContent.subString(0, mergeIndexStart) + dealerQuerys[0].get(mergeField) + handledContent.subString(mergeIndexEnd + 1);
                            }
                        }
                    }
                    else
                    {
                        handledContent = handledContent.subString(0, mergeIndexStart) + ' ' + handledContent.subString(mergeIndexEnd + 1);
                    }
                }
            }while(handledContent.indexOf('{') != -1);
        }
        return handledContent;
    }   

    
    /**      
     * @Description list of options of sms templates are returned.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  temporary string
                * @return template options.
                 * @see   getTemplates
                */ 
    public List<SelectOption> getTemplates() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--None--'));
        templateNameMap = new Map<String, String>();
        templateMap = new Map<String, String>();
        for(Template__c tem : [select Id, Name, Message_Detail__c from Template__c where RecordType.SObjectType='Template__c' and RecordType.Name='SMS' and Active__c = true])
        {
            options.add(new SelectOption(tem.Id, tem.Name));
            templateNameMap.put(tem.Id, tem.Name);
            templateMap.put(tem.Id, tem.Message_Detail__c);
        }
        return options;
    }
     /**      
     * @Description sms task activity is created.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  
                * @return smstask is inserted.
                 * @see   createActivity
                */ 
    private void createActivity()
    {
        smsTask.WhatId = leadInfo.Id;
        Contact personContact = [select Id from Contact where AccountId = :leadInfo.Contact__c limit 1];
        smsTask.WhoId = personContact.Id;
        
        if(sms.Dealer__c != null)
        {
            Account tempDealer = [select Id, Name from Account where Id = :sms.Dealer__c];
            smsTask.Dealer_Name__c = tempDealer.Name;
        }
        smsTask.SMS_Content__c = templateMessage;
        if(sms.Mobile__c)
        {
            smsTask.Phone__c = leadInfo.Contact__r.PersonMobilePhone;
        }
        else if(sms.Secondary_Mobile__c)
        {
            smsTask.Phone__c = leadInfo.Contact__r.PersonOtherPhone;
        }

        try
        {
            insert smsTask;
        }
        catch(Exception e)
        {
            ApexPages.addMessages(e);
        }
    }
   /**      
     * @Description the constructor method of the class for sending the sms.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  standard controller.
                * @return sms is ent
                 * @see   SMSSendLeadResultExtension
                */ 
    public SMSSendLeadResultExtension(ApexPages.StandardController stdController) 
    {
        // constructor
        controller = stdController;       
        this.sms = (SMS__c)stdController.getRecord();
        if(sms == null)
        {
            sms = new SMS__c();
        }        
        
        //set account
        String leadId = ApexPages.currentPage().getParameters().get('leadId');

        if(leadId != null && leadId != '')
        {
             List<Lead__c> aList = [Select Id, Name, Contact__c, Contact__r.PersonMobilePhone, Contact__r.PersonOtherPhone, Assigned_Dealer__c, Assigned_Dealer__r.Name From Lead__c Where Id = :leadId];
            if(aList.size() == 1)
            {
                leadInfo = aList[0];
                if(leadInfo.Assigned_Dealer__c != null)
                {
                    sms.Dealer__c = leadInfo.Assigned_Dealer__c;
                }   
                if(leadInfo.Contact__r.PersonOtherPhone == null && leadInfo.Contact__r.PersonMobilePhone == null)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please collect Customer\'s Mobile number first.'));
                }
                if(leadInfo.Contact__r.PersonMobilePhone != null && leadInfo.Contact__r.PersonMobilePhone != '')
                {
                    sms.Mobile__c = true;
                }
                else if(leadInfo.Contact__r.PersonOtherPhone != null && leadInfo.Contact__r.PersonOtherPhone != '')
                {
                    sms.Secondary_Mobile__c = true;
                }
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You have to select one lead before send SMS.'));
        }
    }
}