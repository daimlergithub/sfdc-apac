/*
    Type:       Test class
    Purpose:    Test Class for 
    User Story: US-CC-002, US-CC-003
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. 2013-05-20 Bing bai (NDC)  Created
*/
@isTest(seeAllData=true)
public class CaseHelperTest {
        
    final static String personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    final static String MBRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
    final static String CHRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chrysler Complaint').getRecordTypeId();
    final static String INQUIRYRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId();
    static Account acc = new Account(LastName='acme', Phone='11111222', Area_Code__c = '010' ,RecordTypeId = personRecordtypeid);
    static Vehicle__c ve1 = new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B200', EuroVIN__c='11111222221111122', UsVIN__c='11111222221111122',Latest_Sales_Person__c='xxx',Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'));
    static Vehicle__c ve2 = new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B220', EuroVIN__c='11111222222111122', UsVIN__c='11111222222111122',Latest_Sales_Person__c='xxx',Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'));
    
    public static testMethod void testUSCC002(){
        Test.startTest();
        List<Sobject> sos = new List<Sobject>();
        
        insert acc;
        insert ve1;
        insert ve2;
        
        Vehicle_Relationship__c vrData1 = new Vehicle_Relationship__c(Vehicle_ID__c=ve1.id, 
                                              Contact__c = acc.Id,Registration_Number__c ='1');
        Vehicle_Relationship__c vrData2 = new Vehicle_Relationship__c(Vehicle_ID__c=ve2.id, 
                                              Contact__c = acc.Id,Registration_Number__c ='1');
        insert vrData1;
        insert vrData2;                
        User user1 = UtilTestData.createPortalUser('Dealer','Gold Partner User');
        User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];

        Case c1 = new Case(Vehicle_Relationship__c = vrData1.Id, AccountId = acc.Id, RecordTypeId = MBRecordtypeid,
                           Case_SubType__c='Dealer-after sales service attitude', Case_Dealer__c = portalUser1.AccountId);
        sos.add(c1);
        if(sos!=null && !sos.IsEmpty())
        UtilSobject.insertSobjects(sos);
        
        c1 = [select Case_SubType__c,Subject,Vehicle_Brand__c,Vehicle_Class__c,Vehicle_Model__c,VIN_Code__c from case where id=:c1.id];
        system.assertEquals(c1.Vehicle_Brand__c,'BENZ');
        system.assertEquals(c1.Vehicle_Class__c,'class-B');
        system.assertEquals(c1.Vehicle_Model__c,'B200');
        system.assertEquals(c1.VIN_Code__c,ve1.UsVIN__c);
     
        c1.Vehicle_Relationship__c = vrData2.id;
        update c1;

        List<Complaint_Tracking__c> ctcs = [select Action__c from Complaint_Tracking__c where Case__c=:c1.id];
        system.assert(ctcs.size()>0);
     
        Test.stopTest();
      
    }
    
    public static testMethod void testUSCC003(){
        Test.startTest();
        List<Sobject> sos = new List<Sobject>();
        insert acc;
        insert ve1;
        Vehicle_Relationship__c vrData = new Vehicle_Relationship__c(Vehicle_ID__c=ve1.id, Contact__c = acc.Id,Registration_Number__c ='1');
        insert vrData;
        User user1 = UtilTestData.createPortalUser('Dealer','Gold Partner User');
        User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];
        Case c1 = new Case(Vehicle_Relationship__c = vrData.Id, AccountId = acc.Id, RecordTypeId = CHRecordtypeid,Problem1__c='ttt', Case_Dealer__c = portalUser1.AccountId);
        
        insert c1;
        
        c1.Problem1__c = 'xxx';
        sos.add(c1);
        if(sos!=null && !sos.IsEmpty())
        UtilSobject.updateSobjects(sos);
        List<Complaint_Tracking__c> ctcs = [select Action__c from Complaint_Tracking__c where Case__c=:c1.id];
        system.assert(ctcs.size()>0);        
        Test.stopTest();
    }
      public static testMethod void testUSCC004(){
        Test.startTest();
        List<Sobject> sos = new List<Sobject>();        
        acc.PersonMobilePhone = '1301111111';
        insert acc;
        insert ve1;
        Vehicle_Relationship__c vrData = new Vehicle_Relationship__c(Vehicle_ID__c=ve1.id, Contact__c =acc.Id,Registration_Number__c ='1');
        insert vrData;
        User user1 = UtilTestData.createPortalUser('Dealer','Gold Partner User');
        User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];
        Case c1 = new Case(Vehicle__c = ve1.Id, AccountId = acc.Id, RecordTypeId = MBRecordtypeid,
                           Case_SubType__c='Dealer-after sales service attitude',Case_type__c='After-Sales', Case_Dealer__c = portalUser1.AccountId);
        Case c2 = new Case(Vehicle__c = ve1.Id, AccountId = acc.Id, RecordTypeId = MBRecordtypeid,
                           Case_SubType__c='Dealer-after sales service attitude',Case_type__c='After-Sales', Case_Dealer__c = portalUser1.AccountId, Case_RepeatCause__c = 'test');
        Case c3 = new Case(Vehicle__c = ve1.Id, AccountId = acc.Id, RecordTypeId = MBRecordtypeid,
                           Case_SubType__c='Dealer-after sales service attitude',Case_type__c='After-Sales', Case_Dealer__c = portalUser1.AccountId);
        
        insert c1;
        //Complaint is a primary complaint(No Parent Case), there will be a SMS sent to customer
        List<Task> tasks = [select id from Task where Phone__c='1301111111'];
        system.assert(tasks.size()>0);
        
        //After add sub Complaint, the field in sub Complaint will auto plus 1
        c2.ParentId = c1.id;
        c2.Case_RepeatCause__c = '0=No contact with customer';
        upsert c2;
        c1 = [select Repeat_Complaint_Times__c from case where id=:c1.id];
        system.assertEquals(1,c1.Repeat_Complaint_Times__c);
        
        //If the original Complaint already has a parent complaint
        c3.ParentId = c2.id;
        try{
            insert c3;
        }catch(DMLException e){
            String msg='';
            for (Integer i = 0; i < e.getNumDml(); i++) {
                // Process exception here
                msg += string.valueOf(i) + ':'+e.getDmlMessage(i)+ '#'; 
            }            
            system.assert(msg.contains(CaseHelper.NOT_PRIMARY_REMINDER));
        }
        Test.stopTest();
    } 
    
    @isTest(seeAllData=true)
    static void testUSCC008(){
        User u = new User();
        u.Username = 'username@dddd.com';
        u.Email = 'username@dddd.com';
        u.CommunityNickname = 'communityNickname';
        insert acc;
        String accountId = acc.id;

        // lastName is a required field on user, but if it isn't specified, 
        //   the code uses the username
        String userId = Site.createPortalUser(u, accountId, '1qaz@WSX3e');
        User user1 = UtilTestData.createPortalUser('Dealer','Gold Partner User');
        User portalUser = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];

        Test.startTest();
        
        Case c = new Case(Subject='For Mail test',RecordTypeId = MBRecordtypeid);
        c.Case_Dealer__c = portalUser.AccountId;
        insert c;
        c.Dealer_Contact__c = 'YES';
        update c;
        c = [select ownerId from Case where id = :c.Id];
        
        Test.stopTest();
    }
    
    @isTest
    public static void testUSCC024() {
        Test.startTest();
        User user1 = UtilTestData.createPortalUser('Dealer','Gold Partner User');
        User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];
        Case c1 = new Case(RecordTypeId = MBRecordtypeid, Description = 'test', Case_Dealer__c = portalUser1.AccountId);
        insert c1;
        c1 = [SELECT CreatedbyId FROM Case WHERE id = :c1.id];
        System.assertEquals([SELECT id FROM Complaint_Description__c WHERE Case__c = :c1.id].size(), 1);
        Test.stopTest();
    }
  
    @isTest(seeAllData=true)
    public static void testUSCC031() { 
        Test.startTest();            
        User user1 = UtilTestData.createPortalUser('Dealer','Gold Partner User');  
        User user2=  UtilTestData.createPortalUser('Dealer','Gold Partner User');     
        User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];
        User portalUser2 = [select accountId , email from user 
                                where contact.Dealer_Complaint_Gate_Keeper__c = true and id=:user2.Id
                                and isActive = true and AccountId <> :portalUser1.AccountId limit 1];
        Case c1 = new Case(RecordTypeId = MBRecordtypeid, Description = 'test', Case_Dealer__c = portalUser1.AccountId);
        insert c1;
       
     //   c1.Support_Dealer_1__c = portalUser2.AccountId;
      //  c1.Support_Dealer_2__c = portalUser2.AccountId;
    //    c1.Support_Dealer_3__c = portalUser2.AccountId;        
   //     insert c1;
        c1.Support_Dealer_1__c = null;
        c1.Support_Dealer_2__c = null;
        update c1;
        
        c1 = [SELECT CreatedbyId FROM Case WHERE id = :c1.id];
        Complaint_Description__c cd=new Complaint_Description__c();
        cd.Case__c = c1.Id;
        cd.Created_By__c = UserInfo.getUserId();
        cd.Date_Time__c = System.now();
        cd.Action__c = 'Changed';
        insert cd;
        
        System.assertEquals([SELECT id FROM Complaint_Description__c WHERE Case__c = :c1.id].size(), 1);
        Test.stopTest();
    } 
    
    public static testMethod void testRelease11b01(){
        Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        Case cas = (Case)UtilTestData.createSobject(new Case(Case_Dealer__c = dealer.id, Others__c = 'test@163.com'), UtilTestData.CASE_RT_MB_COMPLAINT);
        
        cas.Notice_AS__c = true;
        cas.Notice_CRM__c = true;
        cas.Notice_GM__c = true;
        cas.Notice_Others__c = true;
        cas.Notice_SM__c = true;
        try {
            update cas;
        } catch (DMLException e) {
            System.debug('update case error : ' + e.getDMLMessage(0));
        }
    }
    
    public static testMethod void testRelease11b02(){
        Account dealer = (Account)UtilTestData.createSobject(new Account(Dealer_General_Manager_Email__c = 'gm@163.com', Dealer_Sales_Manager_Email__c = 'ds@163.com'), UtilTestData.ACCOUNT_RT_DEALER);
        Case cas = (Case)UtilTestData.createSobject(new Case(Case_Dealer__c = dealer.id, Others__c = 'other@163.com'), UtilTestData.CASE_RT_MB_COMPLAINT);
        
        cas.Notice_AS__c = true;
        cas.Notice_CRM__c = true;
        cas.Notice_GM__c = true;
        cas.Notice_Others__c = true;
        cas.Notice_SM__c = true;
        cas.Case_Status__c = 'In-progress';
        try {
            update cas;
        } catch (DMLException e) {
            System.debug('update case error : ' + e.getDMLMessage(0));
        }
    }
}