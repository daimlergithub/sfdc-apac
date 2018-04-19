@isTest(seeAllData=false)
public class LeadUpdateToLostJPScheduleTest {
    public static testmethod void oneTimeScheduleBatchTest(){
        LeadUpdateToLostJPSchedule lus= new LeadUpdateToLostJPSchedule();
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
        Date daysBack30 = System.today().addDays(-30);
        Date daysBack60 = System.today().addDays(-60);
        Date daysBack90 = System.today().addDays(-90);
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
                          Username = 'testclassdata-daimler-APAC'+System.now().millisecond()+'@test.com',
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
        }  
        
        leadlist = new LIst<Lead__c>();
        
        //Scenario:1
        //(Dealer_Lead_Status__c != \'Order Placed\' OR Dealer_Lead_Status__c != \'Lost\' OR Dealer_Lead_Status__c != \'Purchased(Only Non BDC)\') AND (RecordType.Name =\'Sales Leads\' AND (Lead_Latest_Phase__c = \'Quotation\' OR Lead_Latest_Phase__c = \'CA Submission\' OR Lead_Latest_Phase__c = \'Finance Quotation\') AND LastModifiedDate  <= :daysBack90) limit 5';
        for(Integer i=1; i<=9;i++){
            leadobj = new Lead__c();
            leadobj.RecordTypeId = salesleadRecordTypeId;
            leadobj.CAC_Lead_Status__c = 'Allocated';
            leadobj.Lead_Type__c = 'New Car';
            leadobj.MD__c = 'JP';
            leadobj.Assigned_Dealer__c = accobj.Id; 
            leadobj.CreatedDate=daysBack90;
      //      Test.setCreatedDate(a.Id, DateTime.newInstance(2012,12,12));
      //      leadobj.LastModifiedDate=daysBack30;
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
        
      
     //Scenario:2 
     // (Dealer_Lead_Status__c != \'Order Placed\' OR Dealer_Lead_Status__c != \'Lost\' OR Dealer_Lead_Status__c != \'Purchased(Only Non BDC)\') AND (RecordType.Name =\'Sales Leads\' AND Lead_Latest_Phase__c =\'Order Placed\' AND LastModifiedDate  <= :daysBack60)';
        for(Integer i=1; i<=9;i++){
            leadobj1 = new Lead__c();
            leadobj1.RecordTypeId = salesleadRecordTypeId;
            leadobj1.CAC_Lead_Status__c = 'Allocated';
            leadobj1.Lead_Type__c = 'New Car';
            leadobj1.MD__c = 'JP';
            leadobj1.Assigned_Dealer__c = accobj.Id; 
         //   leadobj1.CreatedDate=daysBack90;
          //  leadobj1.LastModifiedDate=daysBack60;
            leadobj1.Dealer_Lead_Status__c='On-Going';
            leadobj1.Lead_DataSource__c='Dealer Outlet';
                leadobj1.Lead_Latest_Phase__c='Order Placed';
                leadobj1.Quotation_Amount__c='45000';
                leadobj1.Quotation_Date__c = System.today().addDays(-80);
                leadobj1.Quotation_Number__c='QN1234';
                leadobj1.Quotation_Print_Date__c=System.today().addDays(-79);
                leadobj1.CA_Updated_Date__c=System.today().addDays(-85);
                leadobj1.Finance_Quotation_Date__c=System.today().addDays(-83);
                leadobj1.Order_Placed_Date__c=System.today().addDays(-75);
                leadobj1.Order_Print_Date__c=System.today().addDays(-75);
                leadobj1.Order_No__c='ON1234'+i;
                
           
            
            leadlist.add(leadobj1); 
        }
      
     //Scenario:3
     // RecordType.Name =\'Aftersales Leads\' AND Appointment_DateTime__c != null AND Appointment_DateTime__c <= :daysBack30';     
      for(Integer i=1; i<=9;i++){
            leadobj2 = new Lead__c();
            leadobj2.RecordTypeId = afterSalesleadRecordTypeId;
            leadobj2.CAC_Lead_Status__c = 'Allocated';
            leadobj2.Lead_Type__c = 'Service';
            leadobj2.MD__c = 'JP';
            leadobj2.Assigned_Dealer__c = accobj.Id; 
            leadobj2.Lead_DataSource__c='Dealer Outlet';
     //       leadobj2.CreatedDate=daysBack90;
            leadobj2.Appointment_DateTime__c=daysBack30;
            leadobj2.Dealer_Lead_Status__c='On-Going';            
            leadlist.add(leadobj2); 
        }

         insert leadlist;  
  /*      System.debug('@@@leadlist Size : '+leadlist.size());
        for(Lead__c l:leadlist){
            Test.setCreatedDate(l.id, DateTime.newInstance(2016,10,11));
            String leadJSON = '{"attributes":{"type":"Lead__c","url":"/services/data/v41.0/sobjects/Lead__c/'+l.Id+'},"Id":"'+l.Id+'","LastModifiedDate":"2018-01-19T06:14:51.000+0000","CreatedDate":"2018-01-12T10:10:35.000+0000"}';
            System.debug('@@@@@leadJSON'+leadJSON);
            Lead__c c = (Lead__c) JSON.deserialize(leadJSON, Lead__c.class ); 
            System.debug('Test case:' + c.createdDate); 
            System.debug('@@Created Date'+l.CreatedDate+'@@Modified Date'+l.LastModifiedDate);
        }

        update leadlist;
        */
    }
    
    
}