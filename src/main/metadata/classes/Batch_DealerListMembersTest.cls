@isTest
public class Batch_DealerListMembersTest
{
    static String DealerAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    static String PersonAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    static Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(); 
    
    static testmethod void afterInsertEvent()
    {
    test.starttest();
        Account De=new Account();
        De.RecordtypeId=DealerAcc;
        De.Name = 'メルセ';
        De.Type='Personal';
        De.Status__c='Active';
        De.Province__c='Province1';
        De.City__c='Test';
        De.Email__c='test@mbj.com';
        De.Mobile__c ='0435488899';
        De.Dealer_Rollout_Status__c = 'Done';
        De.Dealer_GC_Code__c = 'GC1234';
        //De.Market__c= 'JP';
        insert De;
        
        Account De1=new Account();
        De1.RecordtypeId=DealerAcc;
        De1.Name = 'メル';
        De1.Type='Personal';
        De1.Status__c='Active';
        De1.Province__c='Province1';
        De1.City__c='Test';
        De1.Email__c='test@mbj.com';
        De1.Mobile__c ='0435488899';
        De1.Dealer_Rollout_Status__c = 'Done';
        De1.Dealer_GC_Code__c = 'GC3444';
        //De1.Market__c= 'JP';
        insert De1;
        
        Account  Per= new Account();
        Per.RecordtypeId=PersonAcc;
        Per.LastName='Test Person 1st';
        //Per.Type='Personal';
        Per.Status__c='Active';
        Per.Province__c='Province1';
        Per.City__c='Test';
        Per.ZipCode__c = '1004235';
        Per.Email__c='test@mbj.com';
        Per.Mobile__c ='0435488899';
        Per.Phone = '08022420181';
        Per.Main_Dealer__c = De.id;
        Per.Customer_Lifecycle_Phase__c = 'Care';
       // per.Market__c= 'JP';
        
        insert Per;
        
         Account_Link__c al1= new Account_Link__c(Name='new al',toRole__c=Per.id,fromrole__c =De1.id, Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
        insert al1;
        
       Participating_Dealer__c pd = new Participating_Dealer__c();
       pd.Dealer__c = De.id;

       insert pd;
       
       Dealer_list_member__c dl= new Dealer_list_member__c();
       dl.Participating_Dealer__c = pd.id;
       dl.NewAccount__c = Per.id;
      // dl.MD__c= 'JP';
       insert dl;
     
      
       
          // createTestData();
     Batch_DealerListMembers batcher = new Batch_DealerListMembers();
            Database.executeBatch(batcher, 200);
           
        
           test.stoptest(); 
        
    }
   
}