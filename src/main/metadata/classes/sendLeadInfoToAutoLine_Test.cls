/*
Created By: Dheeraj
Created Date: 02/08/2018
Description: This is a test class for sendLeadInfoToAutoLine.

Modification History:
Last Modified By:                   Last Modified Date:                         Description:

*/
@isTest
public class sendLeadInfoToAutoLine_Test{
    public static testMethod void testMethodOne(){
        String dealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
        String LeadObjectRecordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
        
        List<JP_Switch__c> jpSwitchList = new List<JP_Switch__c>();
        JP_Switch__c jpSwitchEnable= new JP_Switch__c();
        jpSwitchEnable.Name = 'Autoline Lead Management Switch';
        jpSwitchEnable.Enable_Flag__c = true;
        jpSwitchList.add(jpSwitchEnable);
        
        JP_Switch__c jpSwitchConditionCheck= new JP_Switch__c();
        jpSwitchConditionCheck.Name = 'Enable Autoline Flag Check';
        jpSwitchConditionCheck.Enable_Flag__c = true;
        jpSwitchList.add(jpSwitchConditionCheck);
        
        //inserting the custom setting records.
        insert jpSwitchList;
        User jpUSer;
        Profile adminProfile = [SELECT id,name FROM profile WHERE Name='System Administrator'];  
        jpUSer = new User(Alias = 'stand123', Email='testUser@testorg.com', 
                             EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = adminProfile.Id, Market__c='JP',
                             TimeZoneSidKey='America/Los_Angeles', UserName='testuserJP123@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        insert jpUSer;
        
        System.RunAs(jpUser){
            Account personAccount = new Account();
            Account dealerAccount = new Account();
            Lead__c ld = new Lead__c();
            List<Account> accList = new List<Account>();
            
            //setting person account values.
            personAccount= new Account();
            personAccount.RecordtypeId=personAccRecordTypeId;
            personAccount.LastName='Test Person 1st';
            personAccount.Status__c='Active';
            personAccount.Province__c='Province1';
            personAccount.City__c='Test';
            personAccount.ZipCode__c = '1004235';
            personAccount.Email__c='test@mbj.com';
            personAccount.Mobile__c ='0435488899';
            personAccount.Phone = '08022420181';
            personAccount.Main_Dealer__c = dealerAccount.id;
            personAccount.Customer_Lifecycle_Phase__c = 'Care';
            accList.add(personAccount);
            
            //setting dealer account values.
            dealerAccount= new Account();
            dealerAccount.RecordtypeId=dealerAccRecordTypeId;
            dealerAccount.Name='Test Person 1st';
            dealerAccount.Type='Personal';
            dealerAccount.Status__c='Active';
            dealerAccount.Province__c='Province1';
            dealerAccount.City__c='Test';
            dealerAccount.Email__c='test@mbj.com';
            dealerAccount.Mobile__c ='0435488899';
            dealerAccount.Dealer_Rollout_Status__c = 'Done';
            accList.add(dealerAccount);
            
            insert accList;
            
            //setting the lead values.
            ld = new lead__C();
            ld.Market__c = 'JP';
            ld.Contact__c = personAccount.id;
            ld.Assigned_Dealer__c = dealerAccount.id;
            ld.CAC_Lead_Status__c = 'New';
            ld.recordTypeId = LeadObjectRecordTypeId;
            insert ld;
            
            //setting the page parameters.
            Test.setCurrentPageReference(new PageReference('Page.sendLeadInfoToAutoline')); 
            System.currentPageReference().getParameters().put('id', ld.Id);
            
            //assigning the standard controllers.
            ApexPages.StandardController sc = new ApexPages.StandardController(ld);
    
            sendLeadInfoToAutoLine sl = new sendLeadInfoToAutoLine(sc);
            sl.callInformaticaService();
            
            ld.Dealer_Lead_Status__c = 'Purchased(Only Non BDC)';
            update ld;
            
            sl.callInformaticaService();
            sl.doCancel();
        }
    }
}//end of test class send lead info to autoline.