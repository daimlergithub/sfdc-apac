/*
    Type:       controller
    Purpose:    TaskSMSSendResult General Controller
    User Story: Central Interactive SMS Workbook

    Used By:    VF Page - TaskSMSSendResult.page
    ---------------------------------------------------------------
    History:

    20-Nov-2013 Chaos Huang (Nttdata)    Created
*/

public class TaskSMSControllerExtension 
{
    /* Public Properties */
    public SMS__c sms { get; set; }
    public String templateId { get; set; }
    public String templateMessage { get; set; }
    public Account customer {get;set;}

    // You have to select one customer before send SMS.
    public static final String ERROR_MSG_1 = Label.Task_SMS_Send_ErrorMsg1;
    // Please collect Customer\'s Mobile number first.
    public static final String ERROR_MSG_2 = Label.Task_SMS_Send_ErrorMsg2;
    // You have to select one SMS template.
    public static final String ERROR_MSG_3 = Label.Task_SMS_Send_ErrorMsg3;
    // SMS Preview is blank, Please fulfill it.
    public static final String ERROR_MSG_4 = Label.Task_SMS_Send_ErrorMsg4;
    // There are some typo problems with the field(s) displayed as "ERROR" below,
    // please go back to the relevant SMS template and try again.
    public static final String ERROR_MSG_5 = Label.Task_SMS_Send_ErrorMsg5;
    
    /* Private Properties */
    @TestVisible private Task taskObject {get;set;}
    private Contact contact {get;set;}
    private Map<String, String> templateMap { get; set; }
    private Map<String, String> templateNameMap { get; set; }
    private ApexPages.standardController controller {get;set;}

    /* Public Methods */
    
    /**
  *@Description : Creates Task if CustomerPhone number ,templateId and Template msg is not null.
  *@Date : 4/11/2015
  *@param: None
  *@return:PageReference

  */
    public PageReference send() 
    {
        system.debug('------' + customer );
        system.debug('-------' + templateId );
        system.debug('--------' + templateMessage );
        if(customer == null)
        {
            // You have to select one customer before send SMS.
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_MSG_1));
            return null;
        }
        else if(customer.PersonOtherPhone == null && customer.PersonMobilePhone == null)
        {
            // Please collect Customer\'s Mobile number first.
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_MSG_2));
        }
        if(templateId == null || templateId == '' || templateId == 'None')
        {
            // You have to select one SMS template.
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_MSG_3));
            return null;
        }
        if(templateMessage == '' || templateMessage == null)
        {
            // SMS Preview is blank, Please fulfill it.
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_MSG_4));
            return null;
        }
        
        // create task
        createActivity();
        return null;
    }


/**
  *@Description :  sets value to template message
  *@Date : 4/11/2015
  *@param: None
  *@return:PageReference

  */
    
    public PageReference parseTemplateMessage()
    {
        system.debug('-------------' + templateMap);
        system.debug('---------' + templateId);
        if(templateMap.containsKey(templateId)) 
        {
           templateMessage = optimzeContent(templateMap.get(templateId));
           system.debug('------templateMessage ' + templateMessage );
        }
        else
        {
            // You have to select one SMS template.
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_MSG_3));
            templateMessage = '';
        }
        return null;
    }

/**
  *@Description :  parses merge fields for message
  *@Date : 4/11/2015
  *@param: String
  *@return:String

  */
    
    public String optimzeContent(String msg)
    {
        // merge contact name
        if(contact.Name != null){
            msg = msg.replace('{CONTACT_NAME}', contact.Name);
        }
        // merge contact salutation
        String cnSalutation = 'His Excellency';
        if(customer != null){
            if(customer.Gender__c == 'Male'){
                cnSalutation = 'Mr';
            }else if(customer.Gender__c == 'Female'){
                cnSalutation = 'Ms';
            }
        }
        msg = msg.replace('{CONTACT_SALUTATION}', cnSalutation);
        
        // If a field can not be merged, display ERROR.
        Integer mergeIndexStart = -1;
        Integer mergeIndexEnd = -1;
        Boolean errFlg = false;
        // If the set of '{XXX}' still exist, change it to ERROR.
        if((msg.indexOf('{') != -1) && (msg.indexOf('{') < msg.indexOf('}'))){
            do
            {
                mergeIndexStart = msg.indexOf('{');
                mergeIndexEnd = msg.indexOf('}');
                msg = msg.subString(0, mergeIndexStart) + 'ERROR' + msg.subString(mergeIndexEnd + 1);
                errFlg = true;
            }while((msg.indexOf('{') != -1) && (msg.indexOf('{') < msg.indexOf('}')));
        }
        // Change single '{' to ERROR.
        if(msg.indexOf('{') != -1){
            msg = msg.replace('{', 'ERROR');
            errFlg = true;
        }
        // Change single '}' to ERROR.
        if(msg.indexOf('}') != -1){
            msg = msg.replace('}', 'ERROR');
            errFlg = true;
        }
        // Display the error message if some parts were changed to ERROR.
        if(errFlg){
            // 'There are some typo problems with the field(s) displayed as "ERROR" below, 
            // please go back to the relevant SMS template and try again.'
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_MSG_5));
        }
        return msg;
    } 

/**
  *@Description :  returns list options of templates
  *@Date : 4/11/2015
  *@param: None
  *@return:List of Select Options

  */
    
    public List<SelectOption> getTemplates() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--None--'));
        templateNameMap = new Map<String, String>();
        templateMap = new Map<String, String>();

        if (taskObject != null) {
            // Only Master SMS templates that are linked to the Task Campaign are available
            String compaignId = taskObject.WhatId;
            Schema.DescribeSobjectResult res=Campaign_Lead__c.sObjectType.getDescribe();
            string prefix=res.getKeyPrefix();

           // if (compaignId.substring(0,3) == 'a0t'){
           if (compaignId.startsWith(prefix)){
                // Campaign Lead
                compaignId = [select Campaign__c from Campaign_Lead__c where Id = :taskObject.WhatId].Campaign__c;
                
            }
                system.debug('>>>>>>>>>>>>>> compaignId'+compaignId);

            // Get the template Id from Campaign's OBSMSTemplate__c field.
            Id tempId = [select OBSMSTemplate__c from Campaign where Id = :compaignId].OBSMSTemplate__c;
           
            for(Template__c tem : [select Id, Name, Message_Detail__c from Template__c 
                                                    where Id = :tempId and Active__c = true])
            {
                options.add(new SelectOption(tem.Id, tem.Name));
                templateNameMap.put(tem.Id, tem.Name);
                templateMap.put(tem.Id, tem.Message_Detail__c);
            }
        }
        return options;
    }

    /* Private Methods */
    /**
  *@Description : Creates Activity(Task) 
  *@Date : 4/11/2015
  *@param: None
  *@return:None

  */
  @TestVisible  private void createActivity()
    {
        if(taskObject != null)
        {
            smsTask.SMSTemplateID__c = templateId;
            smsTask.WhatId = taskObject.WhatId;
            smsTask.Campaign_Name__c = taskObject.Campaign_Name__c;
            if(customer != null)
            {
                Contact personContact = [select Id from Contact where AccountId = :customer.Id limit 1];
                smsTask.WhoId = personContact.Id;
            }
        }

        List<User> epUserList = [SELECT Id FROM User WHERE Name = 'ep.user1' AND isActive = true  limit 1];
        if(epUserList.Size() > 0){
            smsTask.OwnerId = epUserList[0].Id;
        }
        smsTask.SMS_Content__c = templateMessage;
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
    
   @TestVisible private Task smsTask 
    {
        get
        {
            if(smsTask == null)
            {
                smsTask = new Task();
                smsTask.Subject = 'SMS';
                smsTask.Status = 'Closed';
                smsTask.Activity_Status__c = 'Sent';
                smsTask.Priority = 'High';
                smsTask.RecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
            }
            return smsTask;
        }
        set;
    }

    /* Static initialisers */
  
  /**
  *@Description :onstructor 
  *@Date : 4/11/2015
  *@param: None
  *@return:None

  */
    public TaskSMSControllerExtension(ApexPages.StandardController stdController) 
    {
        // constructor
        controller = stdController;       
        this.sms = (SMS__c)stdController.getRecord();
        if(sms == null)
        {
            sms = new SMS__c();
        }

        // set taskObject
        String accountId = '';
        String whoId = '';
        String taskId = ApexPages.currentPage().getParameters().get('taskId');
        
        if(taskId != null && taskId != '')
        {
            List<Task> tList = [Select Id, WhatId, WhoId, Campaign_Name__c From Task Where Id = :taskId];
            if(tList.size() == 1)
            {
                taskObject = tList[0];
                whoId = taskObject.whoId;
                if((whoId != null) && (whoId.length()>= 3) &&(whoId.substring(0,3).equals('003'))) {
                    // contact
                    contact = [Select Id, AccountId, Name, Salutation From Contact Where Id = :whoId];
                    accountId = contact.AccountId;
                } 
            }
        }
        if(accountId != null && accountId != '')
        {
            List<Account> aList = 
                [Select Id, Name, PersonMobilePhone, PersonOtherPhone, Gender__c From Account Where Id = :accountId];
            if(aList.size() == 1)
            {
                customer = aList[0];
                sms.CustomerName__c = customer.Name;
                if(customer.PersonOtherPhone == null && customer.PersonMobilePhone == null)
                {
                    // Please collect Customer\'s Mobile number first.
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_MSG_2));
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
            // You have to select one customer before send SMS.
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_MSG_1));
        }
    }
}