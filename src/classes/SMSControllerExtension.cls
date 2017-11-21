/*
    Type:       controller
    Purpose:    SMSSendResult General Controller
    User Story: US-SMS-001 - Send SMS content to customer

    Used By:    VF Page - SMSSendResult.page
    ---------------------------------------------------------------
    History:

    07-Mar-2013 Sinow zhang (Nttdata)    Created
    2014-03-20 Updated by Justin Yu
*/

public class SMSControllerExtension 
{
    /* Public Properties */
    public SMS__c sms { get; set; }
    public String templateId { get; set; }
    public String templateMessage { get; set; }
    public Account customer {get;set;}
    
    /* Private Properties */
    private Case caseObject {get;set;}
    private Map<String, String> templateMap { get; set; }
    private Map<String, String> templateNameMap { get; set; }
    private ApexPages.standardController controller {get;set;}
    @testVisible private String taskType = ApexPages.currentPage().getParameters().get('type');

    /* Public Methods */
    public PageReference send() 
    {
        if(customer == null)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You have to select one customer before send SMS/MMS.'));
            return null;
        }
        else if(customer.PersonOtherPhone == null && customer.PersonMobilePhone == null)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please collect Customer\'s Mobile number first.'));
        }
        if(templateId == null || templateId == '' || templateId == 'None')
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You have to select one template.'));
            return null;
        }
        if(taskType == 'SMS' && (templateMessage == '' || templateMessage == null))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'SMS Preview is blank, Please fulfill it.'));
            return null;
        }
        
        //create task
        createActivity();
        return null;
    }

    //set value to template message
    public PageReference parseTemplateMessage()
    {

        if(templateMap.containsKey(templateId)) 
        {
            if(templateMap.get(templateId).indexOf('{DEALER_') != -1)
            {
                if(sms.Dealer__c == null)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You have to select one Dealer.'));
                    return null;
                }
                templateMessage = optimzeContent(templateMap.get(templateId));
            }
            else
            {
                templateMessage = templateMap.get(templateId);
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You have to select one template.'));
            templateMessage = '';
        }
        return null;
    }

    //parse merge fields for message
    public String optimzeContent(String temp)
    {
        String handledContent = temp;
        Boolean errFlg = false;
        if(handledContent.indexOf('{') != -1)
        {
            do
            {
                Integer mergeIndexStart = handledContent.indexOf('{');
                Integer mergeIndexEnd = handledContent.indexOf('}');
                String mergeObjectField = handledContent.subString(mergeIndexStart + 1, mergeIndexEnd);
                if(mergeObjectField.indexOf('_') != -1)
                {
                    String mergeObject = mergeObjectField.subString(0, mergeObjectField.indexOf('_'));
                    String mergeField = mergeObjectField.subString(mergeObjectField.indexOf('_') + 1);
                    if(mergeObject == 'DEALER' && sms.Dealer__c != null)
                    {
                        if(mergeField != 'ADDRESS')
                        {
                            String dealerQuery = 'select ' + mergeField + ' from Account where Id = \'' + sms.Dealer__c + '\' limit 1';
                            List<Account> dealerQuerys = Database.query(dealerQuery);
                            If(dealerQuerys[0].get(mergeField) != null) {
                                handledContent = handledContent.subString(0, mergeIndexStart) + dealerQuerys[0].get(mergeField)
                                               + handledContent.subString(mergeIndexEnd + 1);
                            }
                            else {
                                handledContent = handledContent.subString(0, mergeIndexStart) + ' '
                                               + handledContent.subString(mergeIndexEnd + 1);
                            }
                        }
                        else
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
                    }
                    else
                    {
                        handledContent = handledContent.subString(0, mergeIndexStart) + 'ERROR' + handledContent.subString(mergeIndexEnd + 1);
                        errFlg = true;
                    }
                }
                else
                {
                    handledContent = handledContent.subString(0, mergeIndexStart) + 'ERROR' + handledContent.subString(mergeIndexEnd + 1);
                    errFlg = true;
                }
            }while((handledContent.indexOf('{') != -1)&&(handledContent.indexOf('}') != -1));
        }
        
        if(errFlg){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
            'There are some typo problems with the field(s) displayed as "ERROR" below, please go back to the relevant SMS template and try again.'));
        }
        return handledContent;
    }   

    //returns list options of templates
    public List<SelectOption> getTemplates() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--None--'));
        templateNameMap = new Map<String, String>();
        templateMap = new Map<String, String>();
        for(Template__c tem : [select Id, Name, Message_Detail__c from Template__c 
                                where RecordType.SObjectType='Template__c' 
                                and RecordType.Name = :taskType and Active__c = true])
        {
            
            options.add(new SelectOption(tem.Id, tem.Name));
            templateNameMap.put(tem.Id, tem.Name);
            templateMap.put(tem.Id, tem.Message_Detail__c);
        }
        return options;
    }

    /* Private Methods */
    private void createActivity()
    {
        Template__c template = [select Type__c, Template_ID__c from Template__c where Id = :templateId];
        
        if(caseObject != null)
        {
            smsTask.WhatId = caseObject.Id;
            if(customer != null)
            {
                Contact personContact = [select Id from Contact where AccountId = :customer.Id limit 1];
                smsTask.WhoId = personContact.Id;
            }
        }
        else
        {
            smsTask.WhatId = customer.id;
            Contact personContact = [select Id from Contact where AccountId = :customer.Id limit 1];
            smsTask.WhoId = personContact.Id;
        }
        
        if(sms.Dealer__c != null)
        {
            Account tempDealer = [select Id, Name from Account where Id = :sms.Dealer__c];
            smsTask.Dealer_Name__c = tempDealer.Name;
        }
        
        smsTask.SMS_Content__c = templateMessage; 
        smsTask.SMSTemplateID__c = templateId;
        if(taskType == 'mms'){
            smsTask.eDM_Template__c = template.Template_ID__c;
        }
        
        if(sms.Mobile__c)
        {
            smsTask.Phone__c = customer.PersonMobilePhone;
        }
        else if(sms.Secondary_Mobile__c)
        {
            smsTask.Phone__c = customer.PersonOtherPhone;
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
    
    @testVisible private Task smsTask 
    {
        get
        {
            if(smsTask == null)
            {
                smsTask = new Task();
                smsTask.Subject = taskType;
                smsTask.Status = 'Closed';
                smsTask.Activity_Status__c = 'Sent';
                smsTask.RecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get(taskType).getRecordTypeId();
            }
            return smsTask;
        }
        set;
    }

    /* Static initialisers */
  
    public SMSControllerExtension(ApexPages.StandardController stdController) 
    {
        // constructor
        controller = stdController;
        taskType = taskType != null ? taskType.toUpperCase() : '';
        this.sms = (SMS__c)stdController.getRecord();
        if(sms == null)
        {
            sms = new SMS__c();
        }        
        //set account
        String accountId = ApexPages.currentPage().getParameters().get('accountId');

        if(accountId != null && accountId != '')
        {
            List<Account> aList = [Select Id, Name, PersonMobilePhone, PersonOtherPhone From Account Where Id = :accountId];
            if(aList.size() == 1)
            {
                customer = aList[0];
                sms.CustomerName__c = customer.Name;
                if(customer.PersonOtherPhone == null && customer.PersonMobilePhone == null)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please collect Customer\'s Mobile number first.'));
                }
                if(customer.PersonMobilePhone != null && customer.PersonMobilePhone != '')
                {
                    sms.Mobile__c = true;
                }
                else if(customer.PersonOtherPhone != null && customer.PersonOtherPhone != '')
                {
                    sms.Secondary_Mobile__c = true;
                }
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You have to select one customer before send SMS/MMS.'));
        }
        
        //set case if SMS from case
        String caseId = ApexPages.currentPage().getParameters().get('caseId');
        if(caseId != null && caseId != '')
        {
            caseObject = [Select Id, Account.Name, AccountId, Case_Dealer__c From Case Where Id = :caseId];
            if(caseObject.Case_Dealer__c != null)
            {
                sms.Dealer__c = caseObject.Case_Dealer__c;
            }
        }
    }
}