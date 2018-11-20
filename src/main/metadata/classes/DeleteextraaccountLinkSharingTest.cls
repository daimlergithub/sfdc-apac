@isTest
public class DeleteextraaccountLinkSharingTest {
    
    private static Account_Link__c retperalk;
    private static Account_Link__c retcomalk;
   
     public static Account_Link__c accLink; 
      public static Account personAcc;
      public Static Account Dealer;
    
   public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
      public static Id accDealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
      public static Id retailPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
      public static Id retailCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
       
    public static testmethod void TestAccountLinkShareJPBatch()
    {
     String dupnumber=label.Alk_Last_Modified_Date;
        Integer dup=Integer.valueOf(dupnumber);
        Date todaydate=system.today();
        Date lastmodifedDupNum=todaydate.adddays(-dup);
        System.debug('---------->>>>>>>>>>'+lastmodifedDupNum);
          String las=label.Alk_Last_Modified_By_Alias;
        
        test.starttest();
     
        retperalk =  new Account_Link__c ();
         Account dealer =  new Account(RecordTypeId = accDealer_RecordTypeId, Name = 'test dealer',Dealer_GC_Code__c = 'GC0011422',Dealer_Type__c='Company',Dealer_ND_Code__c='MBK09Shq',MD__C='JP'); 
         insert dealer;
         Group g1= new Group();
     g1.Name = 'test dealer';
     insert g1;
    
     Account personAcc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801110',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                LastName = '刈乾冠寒刊勘',
                                FirstName = '刈乾冠寒刊勘',
                                Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1002347',
                                Mobile__c = '023482832',
                                Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'JP',
                                Industry = 'Other', 
                                DUPNumber__c='123443', 
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
            insert personAcc;
      
       Account_Link__c  accLink= new Account_Link__c(RecordTypeId = retailPerson_RecordTypeId,fromRole__c=dealer.id,toRole__c=personAcc.id,MD__C='JP');
         insert accLink;
           
        
        DeleteextraaccountLinkSharing db = new DeleteextraaccountLinkSharing();
        database.executeBatch(db,1);
         test.stopTest();
        
        
    }
    

}
