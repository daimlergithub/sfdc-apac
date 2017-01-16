@isTest
private with sharing class SSIDataCleanTest {
Private static Account customer;
Private static String original='original';
Private static String valid='valid';
Private static String Inprocess='In process';
Private static String testcustomer='test-customer';
Private static String accept='accept';
Private static String allvalid='all valid';
Private static List<Account> accList;
Private static Id dealerid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();

public static void preparedTestData()
{

         accList = new List<Account>();
        
        for(Integer i=0; i<21; i++){
               customer = new Account(
                Name = 'Test-00000' + i,
                Phone = '1234567', 
                ZipCode__c = '123456',
                Recordtypeid = dealerid,
                Dealer_SSI_Participation__c = true,
                Dealer_DMS_SR_Code__c = 'Test-00000' + i,
                Dealer_DMS_SR_Code_2__c = 'Test-00000-' + i
            );
            
            accList.add(customer);
        }
        
        insert accList;
        
        accList = [Select Id, Name, Dealer_DMS_SR_Code__c, Dealer_DMS_SR_Code_2__c From Account Where Id = :accList];
        
        // runDealerRule
        
        List<SSI__c> ssiList = new List<SSI__c>();
        
        SSI__c s1 = new SSI__c(Status__c = 'Invalid', InvoiceDate__c = date.newInstance(2013,10,1));
        insert s1;
        ssiList.add(s1);
        
        SSI__c s2 = new SSI__c(Status__c = original, InvoiceDate__c = date.newInstance(2013,10,1));
        insert s2;
        ssiList.add(s2);
        
        SSI__c s3 = new SSI__c(Dealer__c = accList[0].Dealer_DMS_SR_Code__c, Status__c = original, 
                               InvoiceDate__c = date.newInstance(2013,10,1));
        insert s3;
        ssiList.add(s3);
        
        Schema.DescribeFieldResult fieldResult = Vehicle__c.Model__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        SSI__c s4 = new SSI__c(Dealer__c = accList[0].Dealer_DMS_SR_Code_2__c, VehicleDesc__c = ple[0].getLabel(), 
                               Status__c = original, InvoiceDate__c = date.newInstance(2013,10,1));
        insert s4;
        ssiList.add(s4);
        
        SSI__c s5 = new SSI__c(Dealer__c = accList[0].Dealer_DMS_SR_Code_2__c + '-ERROR', Status__c = original, 
                               InvoiceDate__c = date.newInstance(2013,10,1));
        insert s5;
        ssiList.add(s5);
        
        SSIDataClean.runDealerRule(null,date.newInstance(2013,1,1),date.newInstance(2014,10,11));
        
        // runCarModelRule
        SSI__c s7 = new SSI__c(
            Dealer__c = accList[0].Dealer_DMS_SR_Code_2__c, 
            VehicleModel__c = ple[0].getLabel(),
            //VehicleDesc__c = ple[0].getLabel(), 
            DealerCheck_Status__c = valid,
            Status__c = Inprocess);
        insert s7;
        
        SSI__c s8 = new SSI__c(
            Dealer__c = accList[0].Dealer_DMS_SR_Code_2__c, 
            //VehicleDesc__c = ple[0].getLabel() + '-ERROR', 
            DealerCheck_Status__c = valid,
            Status__c = Inprocess);
        insert s8;
        
          // run rest rule
        Account dms = new Account(
            LastName = testcustomer,
            Phone = '1234567', 
            ZipCode__c = '123456',
            Area_Code__c = '101',
            Recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()
        );
        insert dms;
        Vehicle__c veh = new Vehicle__c(UsVIN__c = 'NUNFO004324942821', EuroVIN__c = 'ASFOTI09842713RFDS');
        insert veh;
        Vehicle_Relationship__c vr = new Vehicle_Relationship__c(Contact__c = dms.Id, Vehicle_ID__c = veh.Id);
        insert vr;
        
         
        
}

    static testMethod void TestrunRestRule() {
        preparedTestData();
        
        SSIDataClean.runCarModelRule(null, false);
        
      
        List<SSI__c> rests = new List<SSI__c>();
      //  Date d1 = Date.today().toStartOfMonth().addMonths(-1);
      //  Date d2 = Date.today().toStartOfMonth().addMonths(-2);
        Date d3 = Date.today().toStartOfMonth().addMonths(-3);
        Date d4 = Date.today().toStartOfMonth();
        
        SSI__c valid_W_1 = new SSI__c();
        valid_W_1.InvoiceDate__c = d4;
        valid_W_1.HandoverDate__c = d4;
        valid_W_1.CustomerName__c = testcustomer;
        valid_W_1.OfficePhone__c = '13011111112';
        valid_W_1.HomeMobilePhone__c = '13011111111';
        valid_W_1.VehicleUSvin__c = 'NUNFO004324942821';
        valid_W_1.OriginalCustomerName__c = 'testcustomer2';
        valid_W_1.Original_HomeMobilePhone__c = '13011111121';
        valid_W_1.OriginalOfficePhone__c = '13011111122';
        valid_W_1.DealerCheck_Status__c = accept;
        valid_W_1.CarModelCheck_Status__c = accept;
        valid_W_1.Status__c = Inprocess;
        rests.add(valid_W_1);
        
        SSI__c valid_1_nossi = new SSI__c();
        valid_1_nossi.InvoiceDate__c = d4;
        valid_1_nossi.HandoverDate__c = d4;
        valid_1_nossi.CustomerName__c = 'testcustomer-Error';
        valid_1_nossi.HomeMobilePhone__c = '13011121112'; 
        valid_1_nossi.DealerCheck_Status__c = accept;
        valid_1_nossi.CarModelCheck_Status__c = accept;
        valid_1_nossi.Status__c = Inprocess;
        valid_1_nossi.Original_HomeMobilePhone__c = '13011111121';
        valid_1_nossi.OriginalOfficePhone__c = '13011111122';       
        rests.add(valid_1_nossi);
        
        SSI__c valid_1_unmatchssi = new SSI__c();
        valid_1_unmatchssi.InvoiceDate__c = d4;
        valid_1_unmatchssi.HandoverDate__c = d4;
        valid_1_unmatchssi.CustomerName__c = testcustomer;
        valid_1_unmatchssi.OfficePhone__c = '13031111112';
        valid_1_unmatchssi.HomeMobilePhone__c = '13011111113';
        valid_1_unmatchssi.VehicleUSvin__c = 'NUNFO004324942821-Error';
        valid_1_unmatchssi.DealerCheck_Status__c = accept;
        valid_1_unmatchssi.CarModelCheck_Status__c = accept;
        valid_1_unmatchssi.Status__c = Inprocess;
        valid_1_unmatchssi.Original_HomeMobilePhone__c = '13011111121';
        valid_1_unmatchssi.OriginalOfficePhone__c = '13011111122';  
        rests.add(valid_1_unmatchssi); 
  
        // rule 1 
        SSI__c rule1failure = new SSI__c();
        rule1failure.DealerCheck_Status__c = accept;
        rule1failure.CarModelCheck_Status__c = accept;
        rule1failure.Status__c = Inprocess;     
        rests.add(rule1failure);
        
        SSI__c rule1failure1 = new SSI__c();
        rule1failure1.DealerCheck_Status__c = accept;
        rule1failure1.CarModelCheck_Status__c = accept;
        rule1failure1.Status__c = Inprocess;
        rule1failure1.InvoiceDate__c = d4;
        rule1failure1.HandoverDate__c = d3;        
        rests.add(rule1failure1);
        
        SSI__c rule1pass = new SSI__c();
        rule1pass.InvoiceDate__c = d4;
        rule1pass.HandoverDate__c = d4;
        rule1pass.DealerCheck_Status__c = accept;
        rule1pass.CarModelCheck_Status__c = accept;
        rule1pass.Status__c = Inprocess;
        rests.add(rule1pass);
        
        // rule 2
        SSI__c rule2failure = rule1pass.clone();
        rests.add(rule2failure);
        SSI__c rule2pass1 = rule1pass.clone();
        rule2pass1.HomeMobilePhone__c = '13022222222';
        rule2pass1.Original_HomeMobilePhone__c = '13022222232';
        rests.add(rule2pass1);
        SSI__c rule2pass2 = rule1pass.clone();
        rule2pass2.OfficePhone__c = '13022222223';
        rule2pass2.OriginalOfficePhone__c = '13022222233';
        rests.add(rule2pass2);
        SSI__c rule2pass3 = rule1pass.clone();
        rule2pass3.OfficePhone__c = '13581709501';
        rule2pass3.OriginalOfficePhone__c = '13581709502';
        rule2pass3.HomeMobilePhone__c = '13581709503';
        rule2pass3.Original_HomeMobilePhone__c = '13581709504';
        rests.add(rule2pass3);
        
        // rule 3
        SSI__c rule3failure1 = rule2pass3.clone();
        rests.add(rule3failure1);
        SSI__c rule3pass1 = rule2pass3.clone();
        rule3pass1.VehicleUSvin__c = 'rule3pass1-VIN';
        rests.add(rule3pass1);    
        SSI__c rule3failure2 = rule2pass3.clone();
        rule3failure2.VehicleUSvin__c = 'rule3pass-VIN';
        rule3failure2.Status__c = allvalid;
        rests.add(rule3failure2);   
        SSI__c rule3failure22 = rule2pass3.clone();
        rule3failure22.VehicleUSvin__c = 'rule3pass-VIN';
        rests.add(rule3failure22);     
        SSI__c rule3pass2 = rule2pass3.clone();
        rule3pass2.VehicleUSvin__c = 'rule3pass2-VIN';
        rule3pass2.InvoiceDate__c = d3;
        rests.add(rule3pass2);    
            
       // run rest rule
        Account dms2 = new Account(LastName = 'd1-customer-name1-8888a',PersonMobilePhone = '1301111111',PersonOtherPhone = '1301111122',ZipCode__c = '123456',
            Recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()
        );
        insert dms2;
        Vehicle__c veh2 = new Vehicle__c(UsVIN__c = 'NUNF1888899996666', EuroVIN__c = 'ASFOTI09842713RFDS');
        insert veh2;
        Vehicle_Relationship__c vr2 = new Vehicle_Relationship__c(Contact__c = dms2.Id, Vehicle_ID__c = veh2.Id);
        insert vr2;

      
       // insert periodList;        
        insert rests;
        
        Test.startTest();                         
        SSIDataClean.runRestRule(null, false);  
        Test.stopTest();
        system.assert(!accList.isEmpty());
    }
}