@istest
public class LeadHelperAccountLinkCreateJPTest {
  public static Account accobj;
  public static Account accobj1;
  public static Account accobj2;
  public static Contact contobj;
  public static Contact contobj1;
  public static Contact contobj2;
  public static List<Contact> contobjlist;
  public static Lead__c leadobj;
  public static Lead__c le;
  public static List<Lead__c> leadlist;
  //public static map<id,Lead__c> leadOldMap;
  public static Account_Link__c acclink;
  public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
  public static Id AccountCompanyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
  public static Id DealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(); 
  public static Id companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId(); 
  public static Id salesleadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
  public static Id retailpersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(); 
  public static Id ContactSectorRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('ContactSector').getRecordTypeId(); 
  public static Id AddressRecordTypeId = Schema.SObjectType.Address__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId(); 
  
  static void createTestData() {
    accobj = new Account();
    accobj.RecordTypeId = DealerRecordTypeId;
    accobj.Name = 'testaccount';
    accobj.Phone = '00000009642';
    accobj.MBK_Data_Source__c='Email';
    accobj.Mobile__c = '00000009642';
    accobj.ZipCode__c= '1002347';
    insert accobj;
    system.debug('$$$$$$$$$$$$'+accobj);
    system.debug('$$$$$$$$$$$$'+accobj.id);
    
    accobj1 = new Account();
    accobj1.RecordTypeId = personAccRecordTypeId ;
    accobj1.LastName = 'testaccountone';
    accobj1.Phone = '00000009842';
    accobj1.MBK_Data_Source__c='Campaign';
    accobj1.Mobile__c = '00000009842';
    accobj1.ZipCode__c= '3332347';
    insert accobj1;
    system.debug('$$$$$$$$$$$$'+accobj1);
    system.debug('$$$$$$$$$$$$'+accobj1.id);
    
    Address__c add = new Address__c(Customer__c = accobj1.id,Address_Type__c = 'Home',City__c =  'test',Province__c = 'Tokyo');
    insert add;
    accobj1.Primary_Address_Reference__c =add.id;
    update accobj1;
    
    contobj = new Contact();
    contobj.LastName = 'contacttest';
    contobj.Phone = '1212313';
    contobj.Title = 'contact title';
    contobj.Name_English__c = 'A';
    contobj.Accountid = accobj.Id;
    insert contobj;
    system.debug('$$$$$$$$$$$$'+contobj);
    system.debug('$$$$$$$$$$$$'+contobj.id);
    //contobjlist.add(contobj);
    
    contobjlist = new List<Contact>();
    
    contobj1 = new Contact();
    contobj1.LastName = 'contacttestone';
    contobj1.Phone = '1222222';
    contobj1.Title = 'titleone';
    contobj1.Name_English__c = 'B';
    contobj1.Accountid = accobj.Id;
    contobjlist.add(contobj1);
    
    contobj2 = new Contact();
    contobj2.LastName = 'contacttesttwo';
    contobj2.Phone = '1233333';
    contobj2.Title = 'titletwo';
    contobj2.Name_English__c = 'c';
    contobj2.Accountid = accobj.Id;
    contobjlist.add(contobj2);
    
    insert contobjlist;
    system.debug('$$$$$$$$$contobjlist'+contobjlist);
    
    /*le = new Lead__c();
    le.RecordTypeId = salesleadRecordTypeId;
    le.CAC_Lead_Status__c = 'Qualified';
    le.Lead_Type__c = 'Newwww Car';
    le.MD__c = 'KR';
    le.Assigned_Dealer__c = accobj.Id;
    insert le;
    system.debug('$$$$$$$le'+le.id);
    system.debug('$$$$$$$le'+le);*/
    
    leadobj = new Lead__c();
    leadobj.RecordTypeId = salesleadRecordTypeId;
    leadobj.CAC_Lead_Status__c = 'Qualified';
    leadobj.Lead_Type__c = 'New Car';
    leadobj.MD__c = 'KR';
    leadobj.Assigned_Dealer__c = accobj.Id;
    leadobj.Contact__c = accobj1.id;
    //insert leadobj;
    system.debug('$$$$$$$$$$$$'+leadobj);
    leadlist = new LIst<Lead__c>();
    leadlist.add(leadobj);
    insert leadlist;
    system.debug('$$$$$$$$$$$$'+leadlist);
    
    //if(leadobj.RecordTypeId=='Person Account') {
    
    acclink = new Account_Link__c(); 
    acclink.RecordTypeId = retailpersonRecordTypeId;
    acclink.Name = 'testaccounlink';
    acclink.fromRole__c = accobj.Id;
    acclink.toRole__c = accobj.Id;
    acclink.Retail_PersonBirthdate__c=system.today();
    acclink.Retail_Special_Care__c='testing';
    acclink.Retail_Individual_Home_Phone__c='045878956';
    acclink.Retail_Work_Phone__c='0455862358';
    acclink.Retail_Mobile__c='076-789-1452';
    acclink.Retail_Email__c='asdfg@gmail.com';
    acclink.Retail_Gender__c='female';
    acclink.Retail_Occupation__c='Business';
    acclink.Retail_Preferred_Language__c='english';
    acclink.Retail_Preferred_Contact_Method__c='phone';
    insert acclink;
    system.debug('$$$$$$$$$$$$'+acclink);
    system.debug('$$$$$$$$$$$$'+acclink.id);
    //}
  }
 
      
  public static testmethod void createAccountLinkRecordTest() {
    createTestData();
      set<string> contactId = new set<string>();
    contactId.add(contobj.id);
    
    le = new Lead__c();
    le.RecordTypeId = salesleadRecordTypeId;
    le.CAC_Lead_Status__c = 'Approved';
    le.Lead_Type__c = 'Newwww Car';
    le.MD__c = 'JP';
    le.Assigned_Dealer__c = accobj.Id;
    insert le;
    map<id,Lead__c> leadOldMap = new map<id,Lead__c>();
    leadOldMap.put(le.id,le);
    system.debug('$$$$$$$le'+le.id);
    system.debug('$$$$$$$le'+le);
    system.debug('$$$$$$$leadlist'+leadlist);
    system.debug('$$$$$$$leadOldMap'+leadOldMap);

    test.starttest();  
      LeadHelperAccountLinkCreateJP.leadAccountDetails(leadlist,leadOldMap,true,true);
      LeadHelperAccountLinkCreateJP.updatingleadcontactDetails(leadlist,true,true);
    test.stoptest();
    system.assertEquals(leadobj.Lead_Type__c,'New Car'); 
  }   
}