@isTest
public class sendLeadInfoToAutoLineKR_Test {
    public static testMethod void testMethodOne(){
        String dealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
        String LeadObjectRecordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
        
        List<KR_Switch__c> KRSwitchList = new List<KR_Switch__c>();
        KR_Switch__c KRSwitchEnable= new KR_Switch__c();
        KRSwitchEnable.Name = 'Autoline Lead Management Switch';
        KRSwitchEnable.Enable_Flag__c = true;
        KRSwitchList.add(KRSwitchEnable);
        
        KR_Switch__c KRSwitchConditionCheck= new KR_Switch__c();
        KRSwitchConditionCheck.Name = 'Enable Autoline Flag Check';
        KRSwitchConditionCheck.Enable_Flag__c = true;
        KRSwitchList.add(KRSwitchConditionCheck);
        
        //inserting the custom setting records.
        insert KRSwitchList;
        User KRUSer;
        Profile adminProfile = [SELECT id,name FROM profile WHERE Name='System Administrator'];  
        KRUSer = new User(Alias = 'stand123', Email='testUser@testorg.com', 
                             EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = adminProfile.Id, Market__c='KR',
                             TimeZoneSidKey='America/Los_Angeles', UserName='testuserKR123@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        insert KRUSer;
        
        System.RunAs(KRUSer){
        try{
            Account personAccount = new Account();
            Account dealerAccount = new Account();
            Lead__c ld = new Lead__c();
            List<Account> accList = new List<Account>();
            
            //setting person account values.
            personAccount= new Account();
            personAccount.RecordtypeId=personAccRecordTypeId;
            personAccount.LastName='Test Person 1st';
            personAccount.Status__c='Prospect';
            personAccount.Province__c='Province1';
            personAccount.City__c='Test';
            personAccount.ZipCode__c = '1004235';
            personAccount.Email__c='test@mbj.com';
            personAccount.Mobile__c ='+82-00-000-0000';
           // personAccount.Phone = '08022420181';
            personAccount.Main_Dealer__c = dealerAccount.id;
            personAccount.Customer_Lifecycle_Phase__c = 'Care';
            personAccount.MBK_Data_Source__c='Mercedes-Benz';
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
            dealerAccount.Mobile__c ='+82-00-000-0000';
            dealerAccount.Dealer_Rollout_Status__c = 'Done';
            accList.add(dealerAccount);
            
            insert accList;
            
            //setting the lead values.
            ld = new lead__C();
            ld.Market__c = 'KR';
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
    
            sendLeadInfoToAutoLineKRController sl = new sendLeadInfoToAutoLineKRController(sc);
            sl.callInformaticaService();
            
            ld.Dealer_Lead_Status__c = 'Purchased(Only Non BDC)';
            update ld;
            // list<lead> leadList=[Select id,Name from lead];
           // System.assertEquals(1, leadList.size());
            sl.callInformaticaService();
            sl.doCancel();
        }
        catch(Exception e)
        {
        }
        }
    }
}