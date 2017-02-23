/*
    Type:       test class
    Purpose:    SMSControllerExtension test class
    User Story: US-SMS-001 - Send SMS content to customer

    Used By:    SMSControllerExtension
    ---------------------------------------------------------------
    History:

    07-Mar-2013 Sinow zhang (Nttdata)    Created
*/
@isTest(SeeAllData=false)
public class SMSControllerExtensionTest {
    //RecordType Declaration
    static String personAccountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    static String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    static String templateRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
    static String templateRecordTypeId_MMS = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('MMS').getRecordTypeId();   
    static String inquiryRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get(UtilConstant.Enquiry).getRecordTypeId();
   // Variable Declaration
    static SMSControllerExtension extension;
    static Case cas; 
    static  Account customer_PersonMobilePhone;
    static  Account customer_PersonOtherPhone;
    static  Account customer;
    static Account dealer;
    static List<Account> accountList=new List<Account>();
    static Template__c tem1;
    static Template__c tem2;
    static Template__c tem3;
    static Template__c tem4;    
    static List<Template__c> listTemplate=new List<Template__c>();
    //Created Record
    private static void init(){
          customer = new Account(Area_Code__c = '010',firstname='test acme',Salutation='Brother',LastName = 'Acme Customer', Phone = '8888888', RecordTypeId = personAccountRecordTypeId,Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413');
          accountList.add(customer);    
          
          customer_PersonMobilePhone = new Account(Area_Code__c = '010', LastName = 'Acme Customer',firstname='test acme',Salutation='Brother', Phone = '8888888', RecordTypeId = personAccountRecordTypeId,PersonMobilePhone = '1301111111',Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413');
          accountList.add(customer_PersonMobilePhone);
          
          customer_PersonOtherPhone = new Account(Area_Code__c = '010', LastName = 'Acme Customer',firstname='test acme',Salutation='Brother', Phone = '8888888', RecordTypeId = personAccountRecordTypeId,PersonOtherPhone = '1301111111',Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413');
          accountList.add(customer_PersonOtherPhone);   
          
          dealer = new Account(Name = 'Acme Dealer', Phone = '8888888', RecordTypeId = dealerRecordTypeId,Dealer_Address_CN__c = 'chaoyang', City__c = 'beijing', Province__c = '151',Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413');
          accountList.add(dealer);
          
          insert accountList;
          //Record for Case
          cas= new Case(AccountId = customer.Id, Subject = 'acme', RecordTypeId = inquiryRecordTypeId,Case_Dealer__c=dealer.Id);
          insert cas;
          //Records for Templates         
          tem1 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true,
                                           Name = 'lai', Message_Detail__c = '{DEALER_NAME}');
          listTemplate.add(tem1); 
                                          
          tem2 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true,
                                            Name = 'lai', Message_Detail__c = '{MMS_Tempate_DEALER_NAME}');
          listTemplate.add(tem2); 
                    
          tem3= new Template__c(RecordTypeId =templateRecordTypeId_MMS, Active__c = true,
                                           Name = 'lai', Message_Detail__c = '{DEALER_ADDRESS}');
          listTemplate.add(tem3);
           
          tem4= new Template__c(RecordTypeId =templateRecordTypeId, Active__c = true,
                                           Name = 'lai', Message_Detail__c = '{DEALER_ADDRESS}');
          listTemplate.add(tem4); 
                              
          insert listTemplate;  
    }
      Private static void test_SMSControllerExtensionConstructor(){
           init(); 
           extension = new SMSControllerExtension(new ApexPages.standardController(new SMS__c())); 
           ApexPages.currentPage().getParameters().put('type','SMS'); 
           ApexPages.currentPage().getParameters().put('accountId',customer.Id);
           extension = new SMSControllerExtension(new ApexPages.standardController(new SMS__c())); 
           ApexPages.currentPage().getParameters().put('accountId',customer_PersonMobilePhone.Id); 
           extension = new SMSControllerExtension(new ApexPages.standardController(new SMS__c())); 
           ApexPages.currentPage().getParameters().put('accountId',customer_PersonOtherPhone.Id);   
           extension = new SMSControllerExtension(new ApexPages.standardController(new SMS__c())); 
           ApexPages.currentPage().getParameters().put('caseId', cas.Id);  
           extension = new SMSControllerExtension(new ApexPages.standardController(new SMS__c())); 
      }
     public static testMethod void test_getTemplates() 
      {
         Test.startTest();    
            test_SMSControllerExtensionConstructor();   
            extension.templateId = tem1.id;
            extension.sms.Dealer__c = dealer.Id;   
            List<SelectOption> Templates = extension.getTemplates();                     
         Test.stopTest(); 
            set<Id> set_tems = new set<Id>(); 
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('None','--None--'));
            for(Template__c temp:listTemplate){
                  set_tems.add(temp.Id);        
            }           
            for(Template__c tem : [select Id, Name, Message_Detail__c from Template__c where RecordType.SObjectType='Template__c' 
                                  and RecordTypeId = :templateRecordTypeId  AND Active__c = true AND Id IN:set_tems])
             {            
                  options.add(new SelectOption(tem.Id, tem.Name));
             } 
            system.assertEquals(extension.sms.Dealer__c,cas.Case_Dealer__c); 
      }
     //Tempate Recordtype does not 'SMS'
     public static testMethod void test_parseTemplateMessage_NOTSMS() 
       {
        Test.startTest();
            test_SMSControllerExtensionConstructor();        
            extension.templateId = tem3.id;
            List<SelectOption> Templates_MMS = extension.getTemplates();      
            extension.parseTemplateMessage();
        Test.stopTest();
          List<Apexpages.Message> msgs = ApexPages.getMessages();
          boolean success = false;
          for(Apexpages.Message msg:msgs){
                if (msg.getDetail().contains('You have to select one template.')) success = true;
          }
          system.assertEquals(extension.templateMessage,'');          
          system.assert(success);
          system.assertEquals(extension.sms.Dealer__c,cas.Case_Dealer__c); 
      }       
     //If the templateId's Message Detail does not start with DEALER
      public static testMethod void test_parseTemplateMessage_NOTDEALER() 
         {  
          Test.startTest();   
            test_SMSControllerExtensionConstructor();  
            extension.templateId = tem2.id;
            List<SelectOption> Templates_Not_DEALER = extension.getTemplates();      
            extension.parseTemplateMessage();
          Test.stopTest();             
          system.assertEquals(tem2.Message_Detail__c,extension.templateMessage);
          system.assertEquals(extension.sms.Dealer__c,cas.Case_Dealer__c); 
        }       
        //if sms Dealer equals to Null  
       public static testMethod void test_parseTemplateMessage_Not_SMS_Dealer() 
         {  
           Test.startTest(); 
            test_SMSControllerExtensionConstructor();
            extension.templateId = tem1.id;
            List<SelectOption> Templates_SMS = extension.getTemplates(); 
            extension.sms.Dealer__c = null; 
            extension.parseTemplateMessage(); 
           Test.stopTest(); 
           List<Apexpages.Message> msgs = ApexPages.getMessages();
           boolean success = false;
           for(Apexpages.Message msg:msgs){
                if (msg.getDetail().contains('You have to select one Dealer.')) success = true;
           }
           system.assert(success);           
         }
       //if sms Dealer does not equals to Null    
       public static testMethod void test_parseTemplateMessage_SMS_Dealer() 
         { 
           Test.startTest(); 
               test_SMSControllerExtensionConstructor(); 
               extension.templateId = tem1.Id;
               List<SelectOption> Templates_SMS = extension.getTemplates();       
               extension.sms.Dealer__c = dealer.Id; 
               extension.parseTemplateMessage(); 
           Test.stopTest(); 
           system.assert(extension.templateMessage!=Null);
           String handledContent =tem1.Message_Detail__c;    
           Integer mergeIndexStart = handledContent.indexOf('{');
           Integer mergeIndexEnd = handledContent.indexOf('}');
           String mergeObjectField = handledContent.subString(mergeIndexStart+1,mergeIndexEnd);
            if(mergeObjectField.indexOf('_') != -1)
                {
                    String mergeObject = mergeObjectField.subString(0, mergeObjectField.indexOf('_'));
                    String mergeField = mergeObjectField.subString(mergeObjectField.indexOf('_') + 1);
                    if(mergeObject == 'DEALER' && extension.sms.Dealer__c != null)
                    {
                        if(mergeField != 'ADDRESS')
                        {  
                        String dealerQuery = 'select ' + mergeField + ' from Account where Id = \'' + extension.sms.Dealer__c + '\' limit 1';
                            List<Account> dealerQuerys = Database.query(dealerQuery);
                            If(dealerQuerys[0].get(mergeField) != null) {
                                handledContent = handledContent.subString(0, mergeIndexStart) + dealerQuerys[0].get(mergeField)
                                               + handledContent.subString(mergeIndexEnd + 1);
                            }                            
                        }
                   } 
                }
              system.assertEquals(handledContent,extension.templateMessage);  
              system.assertEquals(extension.sms.Dealer__c,cas.Case_Dealer__c);    
         }
         public static testMethod void test_parseTemplateMessage_Templates_ADDRESS() 
         { 
            Test.startTest(); 
               test_SMSControllerExtensionConstructor();
               extension.templateId = tem4.id;
               extension.sms.Dealer__c = dealer.Id;   
               List<SelectOption> Templates_ADDRESS = extension.getTemplates(); 
               extension.parseTemplateMessage();
           Test.stopTest();  
           system.debug('extension.templateMessage>>>>'+extension.templateMessage); 
           String handledContent =tem4.Message_Detail__c;    
           Integer mergeIndexStart = handledContent.indexOf('{');
           Integer mergeIndexEnd = handledContent.indexOf('}');
           String mergeObjectField = handledContent.subString(mergeIndexStart+1,mergeIndexEnd);
            if(mergeObjectField.indexOf('_') != -1)
                {
                    String mergeObject = mergeObjectField.subString(0, mergeObjectField.indexOf('_'));
                    String mergeField = mergeObjectField.subString(mergeObjectField.indexOf('_') + 1);
                    if(mergeObject == 'DEALER' && extension.sms.Dealer__c != null)
                    {
                        if(mergeField == 'ADDRESS')
                        {   
                            Account dealerInfo = [select Dealer_Address_CN__c, City__c, Province__c from Account where Id = :extension.sms.Dealer__c limit 1];
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
             }
             system.assertEquals(handledContent,extension.templateMessage);  
             system.assertEquals(extension.sms.Dealer__c,cas.Case_Dealer__c); 
        }
      public static testMethod void test_sendmail() 
       { 
        Test.startTest();           
            extension = new SMSControllerExtension(new ApexPages.standardController(new SMS__c()));      
            extension.send(); 
            extension.customer=new Account();     
            extension.customer.Name='Account';           
            extension.send();   
            extension.templateId='';
            extension.send();   
            extension.taskType=ApexPages.currentPage().getParameters().put('type','SMS');   
            test_SMSControllerExtensionConstructor();      
            extension.templateId = tem1.id;
            extension.sms.Dealer__c = dealer.Id;   
            List<SelectOption> Templates1 = extension.getTemplates(); 
            extension.parseTemplateMessage();   
            extension.send();    
            system.assertEquals(extension.sms.Dealer__c,cas.Case_Dealer__c); 
        Test.stopTest();
       }
     
}