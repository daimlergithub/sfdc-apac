@isTest(SeeAllData=false)
public class updateDateLeadCreateJPBatchScheduleTest {
    public static testmethod void oneTimeScheduleBatchTest(){
        updateDateLeadCreateJPBatchSchedule lus= new updateDateLeadCreateJPBatchSchedule();
        Test.startTest();
        lus.oneTimeScheduleBatch();
        Test.stopTest();
        
    }
    
    
    @testSetUp
    public static void createTestData() {
        Account accobj;
        Contact contobj;
        Lead__c leadobj,leadobj1,leadobj2;
        List<Lead__c> leadlist;
        map<id,Lead__c> leadOldMap;
        Account_Link__c acclink;
        Date daysBack90 = System.today();
        String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
        Id DealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(); 
        Id companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId(); 
        Id salesleadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
        Id afterSalesleadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
        Id retailpersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(); 
        Id ContactSectorRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('ContactSector').getRecordTypeId(); 
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System administrator' LIMIT 1];
        
        User u = new User(LastName = 'testUser',
                          FirstName='first',
                          Alias = 'fTest',
                          Email = 'testUser@test.com',
                          Username = 'integration.inf@infosys.com.test',
                          ProfileId = profileId.id,
                          TimeZoneSidKey = 'GMT',
                          LanguageLocaleKey = 'en_US',
                          EmailEncodingKey = 'UTF-8',
                          LocaleSidKey = 'en_US'
                         );
        
        insert u;  
         system.runas(u){
            accobj = new Account();
            accobj.RecordTypeId = DealerRecordTypeId;
            accobj.Name = 'testaccount';
            accobj.Phone = '000-0000-9642';
            accobj.MBK_Data_Source__c='Email';
            accobj.Mobile__c = '000-0000-9642';
            accobj.ZipCode__c= '1002347';
            accobj.OwnerId = UserInfo.getUserId();
            accobj.Dealer_ND_Code__c ='01350';
            accobj.Dealer_Group__c ='Yanase';
            accobj.Data_Source__c='Dealer';
            insert accobj;   
        
        
        leadlist = new LIst<Lead__c>();
        
        for(Integer i=1; i<=9;i++){
            leadobj = new Lead__c();
            leadobj.RecordTypeId = salesleadRecordTypeId;
            leadobj.CAC_Lead_Status__c = 'Allocated';
            leadobj.Lead_Type__c = 'New Car';
            leadobj.MD__c = 'JP';
            leadobj.Assigned_Dealer__c = accobj.Id; 
            leadobj.CreatedDate=daysBack90;
            leadobj.Dealer_Lead_Status__c='On-Going';
            leadobj.Lead_DataSource__c='Dealer Outlet';
            if(i>0 && i<=3){
                leadobj.Lead_Latest_Phase__c='Quotation';
                leadobj.Quotation_Amount__c='45000';
                leadobj.Quotation_Date__c = System.today().addDays(-80);
                leadobj.Quotation_Number__c='QN1234';
                leadobj.Quotation_Print_Date__c=System.today().addDays(-79);
            }
            if(i>3 && i<=6){
                leadobj.Lead_Latest_Phase__c='CA Submission';
                leadobj.CA_Updated_Date__c=System.today().addDays(-85);
            }
            if(i>6 && i<=9){
                leadobj.Lead_Latest_Phase__c='Finance Quotation';  
                leadobj.Finance_Quotation_Date__c=System.today().addDays(-83);
            }
            leadlist.add(leadobj); 
        }    

         insert leadlist;  
   } 
    }
    
}