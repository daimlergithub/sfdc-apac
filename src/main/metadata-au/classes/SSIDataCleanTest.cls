/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class SSIDataCleanTest {

    static testMethod void myUnitTest() {
        
        List<Account> accList = new List<Account>();
        Id dealerid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        for(Integer i=0; i<21; i++){
            Account customer = new Account(
                Name = 'Test-00000' + i,
                Phone = '1234567', 
                ZipCode__c = '123456',
                Recordtypeid = dealerid,
                Dealer_SSI_Participation__c = true,
                Dealer_DMS_SR_Code__c = 'Test-00000' + i,
                Dealer_DMS_SR_Code_2__c = 'Test-00000-' + i
            );
            //customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_DEALER);
            accList.add(customer);
        }
        
        insert accList;
        
        accList = [Select Id, Name, Dealer_DMS_SR_Code__c, Dealer_DMS_SR_Code_2__c From Account Where Id = :accList];
        
        // runDealerRule
        
        List<SSI__c> ssiList = new List<SSI__c>();
        
        SSI__c s1 = new SSI__c(Status__c = 'Invalid', InvoiceDate__c = date.newInstance(2013,10,1));
        insert s1;
        ssiList.add(s1);
        
        SSI__c s2 = new SSI__c(Status__c = 'Original', InvoiceDate__c = date.newInstance(2013,10,1));
        insert s2;
        ssiList.add(s2);
        
        SSI__c s3 = new SSI__c(Dealer__c = accList[0].Dealer_DMS_SR_Code__c, Status__c = 'Original', 
                               InvoiceDate__c = date.newInstance(2013,10,1));
        insert s3;
        ssiList.add(s3);
        
        Schema.DescribeFieldResult fieldResult = Vehicle__c.Model__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        SSI__c s4 = new SSI__c(Dealer__c = accList[0].Dealer_DMS_SR_Code_2__c, VehicleDesc__c = ple[0].getLabel(), 
                               Status__c = 'Original', InvoiceDate__c = date.newInstance(2013,10,1));
        insert s4;
        ssiList.add(s4);
        
        SSI__c s5 = new SSI__c(Dealer__c = accList[0].Dealer_DMS_SR_Code_2__c + '-ERROR', Status__c = 'Original', 
                               InvoiceDate__c = date.newInstance(2013,10,1));
        insert s5;
        ssiList.add(s5);
        
        SSIDataClean.runDealerRule(null,date.newInstance(2013,1,1),date.newInstance(2014,10,11));
        
        // runCarModelRule
        SSI__c s7 = new SSI__c(
            Dealer__c = accList[0].Dealer_DMS_SR_Code_2__c, 
            VehicleModel__c = ple[0].getLabel(),
            //VehicleDesc__c = ple[0].getLabel(), 
            DealerCheck_Status__c = 'Valid',
            Status__c = 'In Process');
        insert s7;
        
        SSI__c s8 = new SSI__c(
            Dealer__c = accList[0].Dealer_DMS_SR_Code_2__c, 
            //VehicleDesc__c = ple[0].getLabel() + '-ERROR', 
            DealerCheck_Status__c = 'Valid',
            Status__c = 'In Process');
        insert s8;
        
        SSIDataClean.runCarModelRule(null, false);
        
        // run rest rule
        Account dms = new Account(
            LastName = 'Test-Customer',
            Phone = '1234567', 
            ZipCode__c = '123456',
            Area_Code__c = '101',
            firstname='test acme',
            Salutation='Brother',
            Recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()
        );
        insert dms;
        Vehicle__c veh = new Vehicle__c(UsVIN__c = 'NUNFO004324942821', EuroVIN__c = 'ASFOTI09842713RFDS');
        insert veh;
        Vehicle_Relationship__c vr = new Vehicle_Relationship__c(Contact__c = dms.Id, Vehicle_ID__c = veh.Id);
        insert vr;
        
        List<SSI__c> rests = new List<SSI__c>();
        Date d1 = Date.today().toStartOfMonth().addMonths(-1);
        Date d2 = Date.today().toStartOfMonth().addMonths(-2);
        Date d3 = Date.today().toStartOfMonth().addMonths(-3);
        Date d4 = Date.today().toStartOfMonth();
        
        SSI__c valid_W_1 = new SSI__c();
        valid_W_1.InvoiceDate__c = d4;
        valid_W_1.HandoverDate__c = d4;
        valid_W_1.CustomerName__c = 'Test-Customer';
        valid_W_1.OfficePhone__c = '13011111112';
        valid_W_1.HomeMobilePhone__c = '13011111111';
        valid_W_1.VehicleUSvin__c = 'NUNFO004324942821';
        valid_W_1.OriginalCustomerName__c = 'Test-Customer2';
        valid_W_1.Original_HomeMobilePhone__c = '13011111121';
        valid_W_1.OriginalOfficePhone__c = '13011111122';
        valid_W_1.DealerCheck_Status__c = 'Accept';
        valid_W_1.CarModelCheck_Status__c = 'Accept';
        valid_W_1.Status__c = 'In Process';
        rests.add(valid_W_1);
        
        SSI__c valid_1_nossi = new SSI__c();
        valid_1_nossi.InvoiceDate__c = d4;
        valid_1_nossi.HandoverDate__c = d4;
        valid_1_nossi.CustomerName__c = 'Test-Customer-Error';
        valid_1_nossi.HomeMobilePhone__c = '13011111111'; 
        valid_1_nossi.DealerCheck_Status__c = 'Accept';
        valid_1_nossi.CarModelCheck_Status__c = 'Accept';
        valid_1_nossi.Status__c = 'In Process';
        valid_1_nossi.Original_HomeMobilePhone__c = '13011111121';
        valid_1_nossi.OriginalOfficePhone__c = '13011111122';       
        rests.add(valid_1_nossi);
        
        SSI__c valid_1_unmatchssi = new SSI__c();
        valid_1_unmatchssi.InvoiceDate__c = d4;
        valid_1_unmatchssi.HandoverDate__c = d4;
        valid_1_unmatchssi.CustomerName__c = 'Test-Customer';
        valid_1_unmatchssi.OfficePhone__c = '13011111112';
        valid_1_unmatchssi.HomeMobilePhone__c = '13011111111';
        valid_1_unmatchssi.VehicleUSvin__c = 'NUNFO004324942821-Error';
        valid_1_unmatchssi.DealerCheck_Status__c = 'Accept';
        valid_1_unmatchssi.CarModelCheck_Status__c = 'Accept';
        valid_1_unmatchssi.Status__c = 'In Process';
        valid_1_unmatchssi.Original_HomeMobilePhone__c = '13011111121';
        valid_1_unmatchssi.OriginalOfficePhone__c = '13011111122';  
        rests.add(valid_1_unmatchssi); 
  
        // rule 1 
        SSI__c rule1failure = new SSI__c();
        rule1failure.DealerCheck_Status__c = 'Accept';
        rule1failure.CarModelCheck_Status__c = 'Accept';
        rule1failure.Status__c = 'In Process';     
        rests.add(rule1failure);
        
        SSI__c rule1failure1 = new SSI__c();
        rule1failure1.DealerCheck_Status__c = 'Accept';
        rule1failure1.CarModelCheck_Status__c = 'Accept';
        rule1failure1.Status__c = 'In Process';
        rule1failure1.InvoiceDate__c = d4;
        rule1failure1.HandoverDate__c = d3;        
        rests.add(rule1failure1);
        
        SSI__c rule1pass = new SSI__c();
        rule1pass.InvoiceDate__c = d4;
        rule1pass.HandoverDate__c = d4;
        rule1pass.DealerCheck_Status__c = 'Accept';
        rule1pass.CarModelCheck_Status__c = 'Accept';
        rule1pass.Status__c = 'In Process';
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
        rule3failure2.Status__c = 'All Valid';
        rests.add(rule3failure2);   
        SSI__c rule3failure22 = rule2pass3.clone();
        rule3failure22.VehicleUSvin__c = 'rule3pass-VIN';
        rests.add(rule3failure22);     
        SSI__c rule3pass2 = rule2pass3.clone();
        rule3pass2.VehicleUSvin__c = 'rule3pass2-VIN';
        rule3pass2.InvoiceDate__c = d3;
        rests.add(rule3pass2);    
        
        // rule 4
        SSI__c rule4failuer1 = rule3pass1.clone();
        rule4failuer1.HomeMobilePhone__c = '13011111111';
        rests.add(rule4failuer1);
        SSI__c rule4failuer2 = rule3pass1.clone();
        rule4failuer2.OfficePhone__c = '13011111112';
        rests.add(rule4failuer2);
        SSI__c rule4pass = rule3pass1.clone();
        rule4pass .OfficePhone__c = '13911951112';
        rule4pass .HomeMobilePhone__c = '13911951113';
        rests.add(rule4pass);
        
        // rule 5
        SSI__c rule5failuer1 = rule4pass.clone();
        rests.add(rule5failuer1);
        SSI__c rule5failuer2 = rule4pass.clone();
        rule5failuer2.CustomerName__c = 'Ministry of National Security';
        rule5failuer2.VehicleUSvin__c = 'rule5pass2-VIN';
        rule5failuer2.OfficePhone__c = '13911955112';
        rule5failuer2.HomeMobilePhone__c = '13911955113';
        rests.add(rule5failuer2);
        SSI__c rule5pass = rule4pass.clone();
        rule5pass.CustomerName__c = 'Test customer';
        rule5pass.OriginalCustomerName__c = 'Test-Customer';
        rule5pass.Original_HomeMobilePhone__c = '13044111111';
        rule5pass.OriginalOfficePhone__c = '13044111112';
        rule5pass.OfficePhone__c = '13911955512';
        rule5pass.HomeMobilePhone__c = '13911955513';
        rule5pass.VehicleUSvin__c = 'rule5pass-VIN';
        rests.add(rule5pass);
        
        // rule 6
        SSI__c rule6failuer1 = rule5pass.clone();
        rule6failuer1.OfficePhone__c = '13012411112';
        rule6failuer1.HomeMobilePhone__c = '13012441112';
        rule6failuer1.OriginalCustomerName__c = 'Test-Customer1';
        rule6failuer1.Original_HomeMobilePhone__c = '13011111113';
        rule6failuer1.OriginalOfficePhone__c = '13011111114';
        rule6failuer1.CustomerName__c = 'Test company1';
        rule6failuer1.VehicleUSvin__c = 'rule6pass1-VIN';
        rests.add(rule6failuer1);
        SSI__c rule6failuer2 = rule6failuer1.clone();
        rule6failuer2.CompanyName__c = 'Star of Mercedes-Benz';
        rests.add(rule6failuer2);
        SSI__c rule6failuer3 = rule6failuer1.clone();
        rule6failuer3.CustomerName__c = 'Tong and Mercedes-Benz';
        rests.add(rule6failuer3);
        SSI__c rule6pass = rule5pass.clone();
        rule6pass.CompanyName__c = 'Test company';
        rule6pass.VehicleUSvin__c = 'rule6pass-VIN';
        rests.add(rule6pass);
        
    
        // period data     
        List<SSI__c> periodList = new List<SSI__c>();
  
        String vinkey1 = 'NUNFO004324941111';
        String cnkey1 = 'd1-customer-name1';
        String mobilekey1 = '13800001111';
        String phonekey1 = '13800002222';
        String orimobilekey1 = '13800003333';
        String oriphonekey1 = '13800004444';

        SSI__c ppassd1 = rule6pass.clone();
        ppassd1.InvoiceDate__c = d1;
        ppassd1.CustomerName__c = cnkey1;
        ppassd1.Status__c = 'All Valid';
        ppassd1.VehicleUSvin__c = vinkey1;
        ppassd1.HomeMobilePhone__c = mobilekey1;
        ppassd1.OfficePhone__c = phonekey1;
        ppassd1.OriginalCustomerName__c = cnkey1;
        ppassd1.Original_HomeMobilePhone__c = orimobilekey1;
        ppassd1.OriginalOfficePhone__c = oriphonekey1;
        periodList.add(ppassd1);

        String vinkey2 = 'NUNFO004324942222';
        String cnkey2 = 'd1-customer-name2';
        String mobilekey2 = '13810001111';
        String phonekey2 = '13810002222';
        String orimobilekey2 = '13810003333';
        String oriphonekey2 = '13810004444';

        SSI__c ppassd2 = rule6pass.clone();
        ppassd2.InvoiceDate__c = d2;
        ppassd2.CustomerName__c = cnkey2;
        ppassd2.Status__c = 'All Valid';
        ppassd2.VehicleUSvin__c = vinkey2;
        ppassd2.HomeMobilePhone__c = mobilekey2;
        ppassd2.OfficePhone__c = phonekey2;
        ppassd2.OriginalCustomerName__c = cnkey2;
        ppassd2.Original_HomeMobilePhone__c = orimobilekey2;
        ppassd2.OriginalOfficePhone__c = oriphonekey2;
        periodList.add(ppassd2);

        String vinkey3 = 'NUNFO004324943333';
        String cnkey3 = 'd1-customer-name3';
        String mobilekey3 = '13820001111';
        String phonekey3 = '13820002222';
        String orimobilekey3 = '13820003333';
        String oriphonekey3 = '13820004444';

        SSI__c ppassd3 = rule6pass.clone();
        ppassd3.InvoiceDate__c = d3;
        ppassd3.CustomerName__c = cnkey3;
        ppassd3.Status__c = 'All Valid';
        ppassd3.VehicleUSvin__c = vinkey3;
        ppassd3.HomeMobilePhone__c = mobilekey3;
        ppassd3.OfficePhone__c = phonekey3;
        ppassd2.OriginalCustomerName__c = cnkey3;
        ppassd3.Original_HomeMobilePhone__c = orimobilekey3;
        ppassd3.OriginalOfficePhone__c = oriphonekey3;
        periodList.add(ppassd3);
       
        // rule 7        
        SSI__c rule7failuer1 = rule6pass.clone();
        rule7failuer1.VehicleUSvin__c = vinkey1;
        rule7failuer1.CustomerName__c = cnkey1;
        rule7failuer1.Status__c = 'In Process';
        rule7failuer1.OfficePhone__c = '13911957101';
        rule7failuer1.HomeMobilePhone__c = '13911957102';
        rests.add(rule7failuer1);
        
        SSI__c rule7failuer2 = rule6pass.clone();
        rule7failuer2.VehicleUSvin__c = vinkey2;
        rule7failuer2.CustomerName__c = cnkey2; 
        rule7failuer2.Status__c = 'In Process';
        rule7failuer2.OfficePhone__c = '13911957201';
        rule7failuer2.HomeMobilePhone__c = '13911957202';  
        rests.add(rule7failuer2);
  
        SSI__c rule7failuer3 = rule6pass.clone();
        rule7failuer3.VehicleUSvin__c = vinkey3;
        rule7failuer3.CustomerName__c = cnkey3;
        rule7failuer3.Status__c = 'In Process'; 
        rule7failuer3.OfficePhone__c = '13911957301';
        rule7failuer3.HomeMobilePhone__c = '13911957302';
        rests.add(rule7failuer3);
        
        SSI__c rule7failuer4 = rule6pass.clone();
        rule7failuer4.VehicleUSvin__c = vinkey2;
        rule7failuer4.CustomerName__c = cnkey1;
        rule7failuer4.Status__c = 'In Process';
        rests.add(rule7failuer4);
        
        SSI__c rule7failuer5 = rule6pass.clone();
        rule7failuer5.VehicleUSvin__c = vinkey3;
        rule7failuer5.CustomerName__c = cnkey2; 
        rule7failuer5.Status__c = 'In Process';  
        rests.add(rule7failuer5);
  
        SSI__c rule7failuer6 = rule6pass.clone();
        rule7failuer6.VehicleUSvin__c = vinkey1;
        rule7failuer6.CustomerName__c = cnkey3;
        rule7failuer6.Status__c = 'In Process'; 
        rests.add(rule7failuer6);
        
        // rule 8        
        SSI__c rule8failuer1 = rule6pass.clone();
        rule8failuer1.VehicleUSvin__c = vinkey1;
        rule8failuer1.CustomerName__c = cnkey2;
        rule8failuer1.Status__c = 'In Process';
        rests.add(rule8failuer1);
        
        SSI__c rule8failuer2= rule6pass.clone();
        rule8failuer2.VehicleUSvin__c = vinkey2;
        rule8failuer2.CustomerName__c = cnkey3; 
        rule8failuer2.Status__c = 'In Process';  
        rests.add(rule8failuer2);
  
        SSI__c rule8failuer3 = rule6pass.clone();
        rule8failuer3.VehicleUSvin__c = vinkey3;
        rule8failuer3.CustomerName__c = cnkey1; 
        rule8failuer3.Status__c = 'In Process';
        rests.add(rule8failuer3);
        
        // rule 9
        
        SSI__c rule9failuer1 = rule6pass.clone();
        rule9failuer1.VehicleUSvin__c = 'NUNFO004399991111';
        rule9failuer1.HomeMobilePhone__c = '13911959001';
        rule9failuer1.CustomerName__c = cnkey1;
        rule9failuer1.OriginalCustomerName__c = cnkey1;
        rule9failuer1.Original_HomeMobilePhone__c = mobilekey1;
        rule9failuer1.OriginalOfficePhone__c = mobilekey1;
        rule9failuer1.Status__c = 'In Process';        
        rests.add(rule9failuer1);
        
        SSI__c rule9failuer2 = rule6pass.clone();
        rule9failuer2.VehicleUSvin__c = 'NUNFO004399992222';
        rule9failuer2.HomeMobilePhone__c = '13911959002';
        rule9failuer2.CustomerName__c = cnkey2;  
        rule9failuer2.OriginalCustomerName__c = cnkey2;
        rule9failuer2.Original_HomeMobilePhone__c = mobilekey2;
        rule9failuer2.OriginalOfficePhone__c = mobilekey2;
        rule9failuer2.Status__c = 'In Process';           
        rests.add(rule9failuer2);
        
        SSI__c rule9failuer3 = rule6pass.clone();
        rule9failuer3.VehicleUSvin__c = 'NUNFO004399993333';
        rule9failuer3.HomeMobilePhone__c = '13911959003';
        rule9failuer3.CustomerName__c = cnkey3; 
        rule9failuer3.OriginalCustomerName__c = cnkey3;
        rule9failuer3.Original_HomeMobilePhone__c = mobilekey3;
        rule9failuer3.OriginalOfficePhone__c = '13011111114'; 
        rule9failuer3.Status__c = 'In Process';   
        rests.add(rule9failuer3);     
         
        SSI__c rule9failuer4 = rule6pass.clone();
        rule9failuer4.VehicleUSvin__c = 'NUNFO004399994444';
        rule9failuer4.OfficePhone__c = phonekey1;
        rule9failuer4.CustomerName__c = cnkey1;
        rule9failuer4.OriginalCustomerName__c = cnkey1;
        rule9failuer4.Original_HomeMobilePhone__c = '13011111114';
        rule9failuer4.OriginalOfficePhone__c = phonekey1; 
        rule9failuer4.Status__c = 'In Process';         
        rests.add(rule9failuer4);
        
        SSI__c rule9failuer5 = rule6pass.clone();
        rule9failuer5.VehicleUSvin__c = 'NUNFO004399995555';
        rule9failuer5.OfficePhone__c = phonekey2;
        rule9failuer5.CustomerName__c = cnkey2; 
        rule9failuer5.OriginalCustomerName__c = cnkey2;
        rule9failuer5.Original_HomeMobilePhone__c = '13011111114';
        rule9failuer5.OriginalOfficePhone__c = phonekey2;  
        rule9failuer5.Status__c = 'In Process';          
        rests.add(rule9failuer5);
  
        SSI__c rule9failuer6= rule6pass.clone();
        rule9failuer6.VehicleUSvin__c = 'NUNFO004399996666';
        rule9failuer6.OfficePhone__c = phonekey3;
        rule9failuer6.CustomerName__c = cnkey3;
        rule9failuer6.OriginalCustomerName__c = cnkey2;
        rule9failuer6.Original_HomeMobilePhone__c = '13011111114';
        rule9failuer6.OriginalOfficePhone__c = phonekey2;
        rule9failuer6.Status__c = 'In Process';     
        rests.add(rule9failuer6);    

        // rule 10
        
        SSI__c rule10failuer1 = rule6pass.clone();
        rule10failuer1.VehicleUSvin__c = 'NUNFO004399991111';
        rule10failuer1.HomeMobilePhone__c = mobilekey1;
        rule10failuer1.CustomerName__c = cnkey2;
        rule10failuer1.OriginalCustomerName__c = cnkey2;
        rule10failuer1.Original_HomeMobilePhone__c = mobilekey1;
        rule10failuer1.OriginalOfficePhone__c = phonekey1;
        rests.add(rule10failuer1);
        
        SSI__c rule10failuer2= rule6pass.clone();
        rule10failuer2.VehicleUSvin__c = 'NUNFO004399992222';
        rule10failuer2.HomeMobilePhone__c = mobilekey2;
        rule10failuer2.CustomerName__c = cnkey3;  
        rule10failuer2.OriginalCustomerName__c = cnkey3;
        rule10failuer2.Original_HomeMobilePhone__c = mobilekey2;
        rule10failuer2.OriginalOfficePhone__c = phonekey1;          
        rests.add(rule10failuer2);
  
        SSI__c rule10failuer3= rule6pass.clone();
        rule10failuer3.VehicleUSvin__c = 'NUNFO004399993333';
        rule10failuer3.HomeMobilePhone__c = mobilekey3;
        rule10failuer3.CustomerName__c = cnkey1;   
        rule10failuer3.OriginalCustomerName__c = cnkey1;
        rule10failuer3.Original_HomeMobilePhone__c = mobilekey3;
        rule10failuer3.OriginalOfficePhone__c = phonekey1;        
        rests.add(rule10failuer3);     
         
        SSI__c rule10failuer4 = rule6pass.clone();
        rule10failuer4.VehicleUSvin__c = 'NUNFO004399994444';
        rule10failuer4.OfficePhone__c = phonekey1;
        rule10failuer4.CustomerName__c = cnkey2;
        rule10failuer4.OriginalCustomerName__c = cnkey2;
        rule10failuer4.Original_HomeMobilePhone__c = mobilekey2;
        rule10failuer4.OriginalOfficePhone__c = phonekey1;        
        rests.add(rule10failuer4);
        
        SSI__c rule10failuer5 = rule6pass.clone();
        rule10failuer5.VehicleUSvin__c = 'NUNFO004399995555';
        rule10failuer5.OfficePhone__c = phonekey2;
        rule10failuer5.CustomerName__c = cnkey3;
        rule10failuer5.OriginalCustomerName__c = cnkey3;
        rule10failuer5.Original_HomeMobilePhone__c = mobilekey2;
        rule10failuer5.OriginalOfficePhone__c = phonekey2;           
        rests.add(rule10failuer5);
  
        SSI__c rule10failuer6= rule6pass.clone();
        rule10failuer6.VehicleUSvin__c = 'NUNFO004399996666';
        rule10failuer6.OfficePhone__c = phonekey3;
        rule10failuer6.CustomerName__c = cnkey1;  
        rule10failuer6.OriginalCustomerName__c = cnkey1;
        rule10failuer6.Original_HomeMobilePhone__c = mobilekey3;
        rule10failuer6.OriginalOfficePhone__c = phonekey3;         
        rests.add(rule10failuer6); 

        SSI__c rule10pass1 = rule6pass.clone();
        rule10pass1.VehicleUSvin__c = 'NUNFO004100001111';
        rule10pass1.OfficePhone__c = phonekey3;
        rule10pass1.HomeMobilePhone__c = mobilekey3;
        rule10pass1.CustomerName__c = cnkey1;
        rule10pass1.OriginalCustomerName__c = cnkey2; 
        rests.add(rule10pass1); 
        
        SSI__c rule10pass2 = rule6pass.clone();
        rule10pass2.VehicleUSvin__c = 'NUNFO004324942821';
        rule10pass2.OfficePhone__c = '1234567';
        rule10pass2.CustomerName__c = 'Test-Customer'; 
        rule10pass2.OriginalCustomerName__c = 'Test-Customer';         
        rests.add(rule10pass2); 
        
        // cover current period
        SSI__c rule3periodfailure = rule10pass1.clone();
        rests.add(rule3periodfailure);
                     
        SSI__c rule4periodfailure1 = rule10pass1.clone();
        rule4periodfailure1.VehicleUSvin__c = 'NUNFO444400001111';
        rule4periodfailure1.HomeMobilePhone__c = '13044441111';
        rests.add(rule4periodfailure1);    
        
        SSI__c rule4periodfailure2= rule10pass1.clone();
        rule4periodfailure2.VehicleUSvin__c = 'NUNFO444400002222';
        rule4periodfailure2.OfficePhone__c = '1304444';
        rests.add(rule4periodfailure2);    

        SSI__c rule10failuer7 = new SSI__c();
        rule10failuer7.VehicleUSvin__c = 'NUNFO888899994444';
        rule10failuer7.OfficePhone__c = '13201309041';
        rule10failuer7.HandoverDate__c = d1;
        rule10failuer7.InvoiceDate__c = d1;
        rule10failuer7.CustomerName__c = cnkey2 + '-8888';
        rule10failuer7.Status__c = 'In Process';
        rule10failuer7.DealerCheck_Status__c = 'Valid';
        rule10failuer7.CarModelCheck_Status__c = 'Valid';
        rests.add(rule10failuer7);

        SSI__c rule10failuer7a = new SSI__c();
        rule10failuer7a.VehicleUSvin__c = 'NUNF1888899994444';
        rule10failuer7a.OfficePhone__c = '13201309041';
        rule10failuer7a.HandoverDate__c = d1.addMonths(-3);
        rule10failuer7a.InvoiceDate__c = d1.addMonths(-3);
        rule10failuer7a.CustomerName__c = cnkey2 + '-8888a';
        rule10failuer7a.Status__c = 'In Process';
        rule10failuer7a.DealerCheck_Status__c = 'Valid';
        rule10failuer7a.CarModelCheck_Status__c = 'Valid';
        rests.add(rule10failuer7a);
        
        SSI__c rule10failuer8 = new SSI__c();
        rule10failuer8.VehicleUSvin__c = 'NUNFO888899995555';
        rule10failuer8.OfficePhone__c = '13201309042';
        rule10failuer8.HandoverDate__c = d2;
        rule10failuer8.InvoiceDate__c = d2;
        rule10failuer8.CustomerName__c = cnkey3 + '-8888';
        rule10failuer8.Status__c = 'In Process';
        rule10failuer8.DealerCheck_Status__c = 'Valid';
        rule10failuer8.CarModelCheck_Status__c = 'Valid';
        rests.add(rule10failuer8);

        SSI__c rule10failuer8a = new SSI__c();
        rule10failuer8a.VehicleUSvin__c = 'NUNF1888899995555';
        rule10failuer8a.OfficePhone__c = '13201309042';
        rule10failuer8a.HandoverDate__c = d2.addMonths(-2);
        rule10failuer8a.InvoiceDate__c = d2.addMonths(-2);
        rule10failuer8a.CustomerName__c = cnkey3 + '-8888a';
        rule10failuer8a.Status__c = 'In Process';
        rule10failuer8a.DealerCheck_Status__c = 'Valid';
        rule10failuer8a.CarModelCheck_Status__c = 'Valid';
        rests.add(rule10failuer8a);
  
        SSI__c rule10failuer9= new SSI__c();
        rule10failuer9.VehicleUSvin__c = 'NUNFO888899996666';
        rule10failuer9.OfficePhone__c = '13201309043';
        rule10failuer9.HandoverDate__c = d3;
        rule10failuer9.InvoiceDate__c = d3;
        rule10failuer9.CustomerName__c = cnkey1 + '-8888';
        rule10failuer9.Status__c = 'In Process';
        rule10failuer9.DealerCheck_Status__c = 'Valid';
        rule10failuer9.CarModelCheck_Status__c = 'Valid';
        rests.add(rule10failuer9); 
        
        SSI__c rule10failuer9a = new SSI__c();
        rule10failuer9a.VehicleUSvin__c = 'NUNF1888899996666';
        rule10failuer9a.OfficePhone__c = '13201309043';
        rule10failuer9a.HandoverDate__c = d3.addMonths(-1);
        rule10failuer9a.InvoiceDate__c = d3.addMonths(-1);
        rule10failuer9a.CustomerName__c = cnkey1 + '-8888a';
        rule10failuer9a.Status__c = 'In Process';
        rule10failuer9a.DealerCheck_Status__c = 'Valid';
        rule10failuer9a.CarModelCheck_Status__c = 'Valid';
        rests.add(rule10failuer9a); 
         
        // run rest rule
        Account dms2 = new Account(
            LastName = 'd1-customer-name1-8888a',
           PersonMobilePhone = '1301111111',
           PersonOtherPhone = '1301111122', 
            ZipCode__c = '123456',
            firstname='test acme',
            Salutation='Brother',
            Recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()
        );
        insert dms2;
        Vehicle__c veh2 = new Vehicle__c(UsVIN__c = 'NUNF1888899996666', EuroVIN__c = 'ASFOTI09842713RFDS');
        insert veh2;
        Vehicle_Relationship__c vr2 = new Vehicle_Relationship__c(Contact__c = dms2.Id, Vehicle_ID__c = veh2.Id);
        insert vr2;

        insert periodList;        
        insert rests;
        
        Test.startTest();    
          
            
        SSIDataClean.runRestRule(null, false);    

        Test.stopTest();
    }
}