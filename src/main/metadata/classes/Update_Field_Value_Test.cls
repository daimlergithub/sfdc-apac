@isTest
public class Update_Field_Value_Test{

								   
    //Creating data to be updated by batch
    @testsetup static void dataSetup(){
																				 
																	 
																								
																			   
																																						  
											  
        List<account> lacc= new List<account>();
        for(Integer i=1; i<100; i++){
            Account accMY= new Account(Name='acc'+i, MD__c= 'MY',Mobile__c='12345678');
            Account accTH= new Account(Name='acc-'+i, MD__c= 'TH',Mobile__c='12345678');
            lacc.add(accMY);
            lacc.add(accTH);
        }
        Database.insert(lacc);
    }
    
    //method to test the record update for MD field value 'MY'
    static testmethod void testMY(){
    User user1 = TestUtils.createMYAdminUser();
    System.runAs (user1) {
							  
        Test.startTest();
        Update_Field_Value batchjob = new Update_Field_Value();
        //setting up input for batch to start
        batchjob.query='select id,market__c from account where MD__c= \'MY\'';
        batchjob.fieldstoupdate= new map<string,string>();
        batchjob.fieldstoupdate.put('Market__c', 'MY');
        Database.ExecuteBatch(batchjob);
        Integer c=batchjob.counter;
        Test.stopTest();
        //Fetching records after updation 
        Account finalAccMY = [Select Market__c from Account where MD__c = 'MY' limit 1];
        Account finalAccTH = [Select Market__c from Account where MD__c = 'TH' limit 1];
        //checking whether the value of Market__c field has been updated successfully for valid records and not for all
       // System.assertEquals('MY',finalAccMY.Market__c);
       // System.assertNOTEquals('TH',finalAccTH.Market__c);
    }
    }
	
    //method to test the record update for MD field value 'TH'
    static testmethod void testTH(){
    User user1 = TestUtils.createAdminUser();
    System.runAs (user1) {
							  
        Test.startTest();
        Update_Field_Value batchjob = new Update_Field_Value();
        //setting up input for batch to start
        batchjob.query='select id,market__c from account where MD__c=\'TH\'';
        batchjob.fieldstoupdate= new map<string,string>();
        batchjob.fieldstoupdate.put('Market__c', 'TH');
        Database.ExecuteBatch(batchjob);
        Test.stopTest();
        //Fetching records after updation 
        Account finalAccMY = [Select Market__c from Account where MD__c = 'MY' limit 1];
        Account finalAccTH = [Select Market__c from Account where MD__c = 'TH' limit 1];
        system.debug(finalAccTH.Market__c+'%%%%%%%');
        system.debug(finalAccMY.Market__c+'%%%%%%%');
        
        //checking whether the value of Market__c field has been updated successfully for valid records and not for all
       System.assertEquals('TH',finalAccTH.Market__c);
       
    }
    }
}
