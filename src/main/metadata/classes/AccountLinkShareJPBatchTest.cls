@isTest
public class AccountLinkShareJPBatchTest {
    
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
         try{ 
        test.starttest();
     
        retperalk =  new Account_Link__c ();
         Account dealer =  new Account(RecordTypeId = accDealer_RecordTypeId, Name = 'test dealer',Dealer_GC_Code__c = 'GC0011422',Dealer_Type__c='Company',Dealer_ND_Code__c='MBK09Shq',MD__C='JP'); 
         insert dealer;
         Group g1= new Group();
     g1.Name = 'test dealer';
     insert g1;
      KR_Switch__c krswitch=new KR_Switch__c(Name='AccountLinkhelperSwitch',Enable_Flag__c=True);
   List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
   lsttrgt.add(krswitch);
   insert lsttrgt;
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountLinkhelperSwitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountLinkhelperSwitch').Enable_Flag__c;
        }
        Account personAcc13;
          if (!KRSwitchEnabledFlag ) {
     personAcc13 = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '010-999-0000',Home_Phone_2__c = '010-999-0000',Work_Phone__c = '010-999-0000',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '010-999-0000',
                                Mobile2__c = '010-999-0000',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'KR',
                                MBK_Data_Source__c='Advertisement',
                                Foundation_Date__c=system.today()-1,
                                Commercial_Reg_No__c='1567',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
                                }
                  else{
                       personAcc13 = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c =  '+82-51-999-0000',Home_Phone_2__c = '010-999-0000',Work_Phone__c =  '+82-51-999-0000',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c =  '+82-11-999-0000',
                                Mobile2__c = '010-999-0000',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'KR',
                                MBK_Data_Source__c='Advertisement',
                                Foundation_Date__c=system.today()-1,
                                Commercial_Reg_No__c='1567',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());  
                                
                      }
                                
       
     insert personAcc13;
      
       Account_Link__c  accLink= new Account_Link__c(RecordTypeId = retailPerson_RecordTypeId,fromRole__c=dealer.id,toRole__c=personAcc13.id,MD__C='JP');
         insert accLink;
           
        
        AccountLinkShareJPBatch db = new AccountLinkShareJPBatch();
        database.executeBatch(db,1);
         test.stopTest();
       }
        catch(Exception e)
        {
        } 
        
    }
    

}