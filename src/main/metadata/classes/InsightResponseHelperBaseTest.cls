@isTest
public class InsightResponseHelperBaseTest {

    private static user us1;
    public static testMethod void invokemethIR()
    {
        Profile p = [SELECT Id,Name FROM Profile WHERE Name='IntegrationAPI'];
        us1 = new User(Alias = 'standt11', Email='testUser1@testorg.com', 
                   EmailEncodingKey='UTF-8', LastName='TestUserAU', LanguageLocaleKey='en_US', 
                   LocaleSidKey='en_US', ProfileId = p.Id, Market__c='AU',
                   TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(us1);
        system.runAs(us1 )
        {
            Account acct =  new Account(Dealer_Default_Flag__c=false,
                              Dealer_DMS_SR_Code__c='test code 2',
                              Individual_Home_Phone__c = '+61857454554',
                              Home_Phone_2__c = '1800123456',Work_Phone__c = '+61857454554',
                              Status__c='NoCustomer',Email__c = 'testemail123@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                              City__c='Beijing',
                              Gender__c = 'Male',
                              Phone = '0801801119',
                              Area_code__c = '03',
                              MD__c = 'AU',
                              LastName = 'tstLastName',
                              FirstName = 'tstFirstName',
                              Salutation = 'Unknown',
                              Postal_Opt_Out__c=True,     
                              Province__c = 'Shanghai',
                              ZipCode__c= '3270',
                              //Mobile__c = '918197597651',
                              //Mobile2__c = '918197597651',
                              Primary_Email__c = 'Email1',
                              Primary_Fax__c = 'FAX2',
                              Primary_Phone__c ='Other2',
                              PersonDoNotCall=True,
                              // ownerid=user1.id,
                              PersonHasOptedOutOfEmail=True,
                              Opt_In_Email__c=true,
                              //owner=user1,
                              PersonBirthdate=date.today(),
                              dealer_nd_code__c = '123456',
                              dealer_gc_code__c = '1234567',
                              RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
         		
            	insert acct;
            
               Vehicle__c v = new Vehicle__c(Brand__c='Mercedes-Benz',RecordTypeId=Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId());
               insert v;
            
              Vehicle_Relationship__c vr = new Vehicle_Relationship__c(RecordTypeId=Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId(),Contact__c=acct.id,	Vehicle_ID__c=v.id,Status_1__c='C');
            	insert vr;
            
        	 	List<Insights_Response__c>  refIR=new List<Insights_Response__c>();
            		Insights_Response__c r=new Insights_Response__c();
            		r.Name='Ashok response';
            		r.RecordId__c=acct.Id;
            		refIR.add(r) ;  
            
            		Insights_Response__c r1=new Insights_Response__c();
            		r1.Name='Ashok response1';
            		r1.RecordId__c=vr.Id;
            		refIR.add(r1) ;  
                insert refIR;
            
            InsightResponseHelperBase.UpdateRelation(refIR);
           System.assertEquals(acct.id,refIR[0].Customer__c);
           System.assertEquals(null,refIR[0].Vehicle_Relationship_ID__c);
            
            System.assertEquals(null,refIR[1].Customer__c);
           System.assertEquals(vr.id,refIR[1].Vehicle_Relationship_ID__c);
            
            
            InsightResponseHelperBase.afterInsertEventShareInsightResponse(refIR);
        
            
            Account acct1 =  new Account(Dealer_Default_Flag__c=false,
                              Dealer_DMS_SR_Code__c='test code 2',
                              Individual_Home_Phone__c = '+61857454554',
                              Home_Phone_2__c = '1800123456',Work_Phone__c = '+61857454554',
                              Status__c='NoCustomer',Email__c = 'testemail123@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                              City__c='Beijing',
                              Gender__c = 'Male',
                              Phone = '0801801119',
                              Area_code__c = '03',
                              MD__c = 'AU',
                              LastName = 'tstLastName',
                              FirstName = 'tstFirstName',
                              Salutation = 'Unknown',
                              Postal_Opt_Out__c=True,     
                              Province__c = 'Shanghai',
                              ZipCode__c= '3270',
                              //Mobile__c = '918197597651',
                              //Mobile2__c = '918197597651',
                              Primary_Email__c = 'Email1',
                              Primary_Fax__c = 'FAX2',
                              Primary_Phone__c ='Other2',
                              PersonDoNotCall=True,
                              // ownerid=user1.id,
                              PersonHasOptedOutOfEmail=True,
                              Opt_In_Email__c=true,
                              //owner=user1,
                              PersonBirthdate=date.today(),
                              dealer_nd_code__c = '123456',
                              dealer_gc_code__c = '1234567',
                              RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
         		
            	insert acct1;
            Account dealer = new Account(Dealer_Rollout_Status__c = 'Done', Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c = 'AU', Individual_Home_Phone__c = '+66-9885857857', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId(), Name = 'test dealer', Dealer_GC_Code__c = '123456', Dealer_nd_Code__C = '12345');
           insert dealer;
            
           Account_Link__c acclink= new Account_Link__c(
               Name = 'new al', 
               Md__c = 'AU', 
               toRole__c = acct1.id, 
               fromrole__c = dealer.id, 
               Retail_LastName__c = 'heii', 
               Retail_Full_Name__c = 'dhanu', 
               Retail_Full_Name_Title__c = 'Mrs',
               Retail_FirstName__c = 'Saru',
               RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(), 
               Retail_DMS_Customer_ID__c = '1122', 
               Retail_Gender__c = 'Female',
               Retail_Duplicate_Flag__c=False,
               Retail_Delete_Flag__c=False);
            
            insert acclink;
            
            List<Insights_Response__c>  refIR1=new List<Insights_Response__c>();
            Insights_Response__c r2=new Insights_Response__c();r.Name='Ashok response';
            		r2.RecordId__c=acct1.Id;
            		refIR1.add(r2) ;
            
            Group g = new Group();
            g.Name='AU12345';
            g.Type='Regular';
            insert g;
            
            
            InsightResponseHelperBase.afterInsertEventShareInsightResponse(refIR1);
       }
    }
        
}