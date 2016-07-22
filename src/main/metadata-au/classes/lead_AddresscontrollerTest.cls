@isTest
public class lead_AddresscontrollerTest {
    private static lead__c objLead;
     private static Address__c objAddress;
    private static Account objAccount;
     
      private static String leadRecordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Finance Lead').getRecordTypeId();
      private static Id dealerRTId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
   
      public static testMethod void testGetaddressList_details()
  {    
    

       init();
      
      
      test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objlead.id);
        ApexPages.StandardController objSc = new ApexPages.StandardController(objlead);
        lead_Addresscontroller objlead_Addresscontroller= new lead_Addresscontroller(objSc);
        objlead_Addresscontroller.getaddressList_details();
        test.stopTest();
         list<Address__c> addresslist=new list<Address__c>();
         addresslist=[select id,Name,MD__c,Customer__c,Preferred__c,Address_Type__c,Address_Line_1__c,Address_Line_2__c,Country__c,ZipCode__c,Province__c,Status__c,District__c 
                            from Address__c Where  Preferred__c=:true Limit 1]; 
        System.assertEquals(addresslist[0],objlead_Addresscontroller.getaddressList_details());
        
      
  } 
     public static testMethod void testGetlead_List()
  {
     
    

       init();
      
      
      test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objlead.id);
        ApexPages.StandardController objSc = new ApexPages.StandardController(objlead);
        lead_Addresscontroller objlead_Addresscontroller= new lead_Addresscontroller(objSc);
        objlead_Addresscontroller.getlead_List();  
        objlead_Addresscontroller.Save();
      /*objlead_Addresscontroller.getemail();
      objlead_Addresscontroller.getworkPhone();
      objlead_Addresscontroller.gethomePhone();
      objlead_Addresscontroller.getMobileNum();*/
        test.stopTest();
      
       list<lead__c> leadList=new list<lead__c>();
       leadList=[select id,Company_Account__c,Home_Phone__c,Work_Phone__c,Email__c,Mobile__c from Lead__c where id=:objLead.id]; 
      //System.assertEquals(leadList[0],objlead_Addresscontroller.getlead_List());
      //system.assertNotEquals(objlead_Addresscontroller.getemail(),null);
        
      
  }   
    
   
     static void init()
    {           
        
        
        
             objAccount= new Account();
                    objAccount.RecordtypeId=dealerRTId;
                    objAccount.Firstname='Test Person 1st';
                    objAccount.LastName='Test Person';
                    objAccount.salutation='Mr.';
                    objAccount.Type='Personal';
                    objAccount.Status__c='Active';
                    objAccount.Province__c='Province1';
                    objAccount.City__c='Test';
                    objAccount.Email__c='test@mbau.com';
                    objAccount.Email2__c = 'testemail2@test.com';
                    objAccount.Home_Phone_2__c = '98765413';    
                    objAccount.PersonMobilePhone ='8884545243';
                    objAccount.Partner_Surname__c='Test Person';
                    insert objAccount;
        
        
                  objAddress= new Address__c();
                  objAddress.Customer__c=objAccount.Id; 
                  objAddress.Preferred__c=true;
                  objAddress.Province__c='ACT';
                 insert objAddress;
               
      
        Contract contract1 = new Contract ( AccountId = objAccount.Id,
                                            StartDate = Date.Today(),
                                            ContractTerm = 2,
                                            Status = 'Draft');
                                            
        insert contract1;
         objLead= new Lead__c ( RecordTypeId = leadRecordTypeId,
                                      Contact__c = objAccount.id,
                                      Lead_Source__c = 'End of Contract',
                                      Nature_of_Request__c = 'Key2Key',
                                      Company_Account__c=objAccount.id, 
                                      Business_Unit__c = 'Cars',
                                      Sub_BusinessUnit__c = 'Sales',
                                      CAC_Lead_Status__c = 'New Enquiry'
                                     
                                      );
                                      
        insert objLead;
        
    }
    

}