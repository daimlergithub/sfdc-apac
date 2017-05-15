/*
  1.New Account Link record will create when assigned dealer is populated.
  Created By: Kiran
  Date: 2016-9-23
*/
public class LeadHelperAccountLinkCreateJP 
{
    private static final String alkCompanyRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    private static final String alkpersonRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    private static final String alkContactSectorRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('ContactSector').getRecordTypeId();
    private static final String PersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static final String AccountCompanyId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    
    static user usr = [select id,profileId,profile.Name from User WHERE Id =: userInfo.getUserId()];   
    public static void leadAccountDetails(list<Lead__c> leadlst, map<id,Lead__c> leadOldMap, boolean isInsert, boolean isUpdate){
        
        if(leadutil.leadAccountDetails)
        {
            
            set<String> contactId = new set<String>();
            set<Id> OldDealerID= new set<Id>();
            set<Id> NewDealerID= new set<Id>();
            
            
            for(Lead__c le : leadlst)
            {
                if(le.MD__c == label.MarketJP)
                {
                    if(le.Assigned_Dealer__c != null && ((le.CAC_Lead_Status__c == 'Approved' || (le.CAC_Lead_Status__c == 'Allocated' && leadOldMap.get(le.id).CAC_Lead_Status__c == 'Approved')) ||  
                                                         (le.CAC_Lead_Status__c == 'Approved' || le.CAC_Lead_Status__c == 'Allocated' && (le.Assigned_Dealer__c !=null || leadOldMap.get(le.id).Assigned_Dealer__c  != le.Assigned_Dealer__c))))
                    {
                        if(isInsert || ((isUpdate && le.CAC_Lead_Status__c != leadOldMap.get(le.id).CAC_Lead_Status__c) ||  (isUpdate && leadOldMap.get(le.id).Assigned_Dealer__c !=le.Assigned_Dealer__c || leadOldMap.get(le.id).Contact__c !=le.Contact__c))) 
                        {
                            System.debug('Is Insert OR Update called -----:::::');
                            contactId.add(le.id);
                            if(leadOldMap.get(le.id).Assigned_Dealer__c !=le.Assigned_Dealer__c || leadOldMap.get(le.id).Contact__c !=le.Contact__c)
                            {
                                System.debug('^&^&^&^&&^ l');
                                contactId.add(le.id); 
                            }
                        }
                    }
                    if(le.Assigned_Dealer__c != null && isUpdate && ((le.CAC_Lead_Status__c == 'Approved' || (le.CAC_Lead_Status__c == 'Allocated')) || (le.CAC_Lead_Status__c == 'Approved' || (le.CAC_Lead_Status__c == 'Allocated') && (leadOldMap.get(le.id).Assigned_Dealer__c  != le.Assigned_Dealer__c  ) || leadOldMap.get(le.id).Contact__c !=le.Contact__c)) && (userinfo.getusertype()=='Powerpartner')) 
                    {   
                        contactId.add(le.id);
                        
                        if(leadOldMap.get(le.id).Assigned_Dealer__c !=le.Assigned_Dealer__c  || leadOldMap.get(le.id).Contact__c !=le.Contact__c)
                        {
                            contactId.add(le.id); 
                        }
                    }
                }
                else if(le.Assigned_Dealer__c != null && le.MD__c == Label.MarketKR)
                {
                    if(isInsert || (isUpdate && le.Assigned_Dealer__c != leadOldMap.get(le.id).Assigned_Dealer__c))
                    {
                        System.debug('Is Insert OR Update called -----:::::');
                        contactId.add(le.id);
                    }
                }
                
            }
        System.debug('^&^&^&^&&^ contactId'+contactId);
        if(! contactId.isEmpty() ){
            createAccountLinkRecord(contactId);
        }
     }  
		if(usr.profile.Name.contains('Japan Dealer'))    
     leadutil.leadAccountDetails = false;  
    }
    
    public static void createAccountLinkRecord(set<String> contactId){
   LeadUtil.leadAccountlnktrigger = false;
     set<String> actlnkids= new set<String>();
        set<String> dealerId = new set<String>();
        set<String> AcclinkContactId = new set<String>();
        set<String> CompanyId = new set<String>();
        Map<Id,Lead__c> leadupdate =new Map<Id,Lead__C>();
        List<Lead__c> leadLst = [select Id, Retail_Contact__c,Company_Account__c,Contact__c, Assigned_Dealer__c, Contact__r.LastName, Contact__r.FirstName,Contact__r.LastName_Native_1__c, 
                                 Contact__r.FirstName_Native_1__c, Contact__r.PersonBirthdate, Contact__r.Special_Care__c, Contact__r.Individual_Home_Phone__c, Contact__r.Work_Phone__c,
                                 Contact__r.Mobile__c, Contact__r.Fax, Contact__r.Email__c, Contact__r.Primary_Address_Reference__r.City__c, Contact__r.Primary_Address_Reference__r.District__c,
                                 Contact__r.Primary_Address_Reference__r.Block__c, Contact__r.Primary_Address_Reference__r.Address_Line_1__c,
                                 Contact__r.Primary_Address_Reference__r.Address_Line_2__c, Contact__r.Primary_Address_Reference__r.ZipCode__c,
                                 Contact__r.Primary_Address_Reference__r.CreatedDate, Contact__r.Primary_Address_Reference__r.LastModifiedDate,
                                 Contact__r.gender__c, contact__r.Occupation__c, Contact__r.Industry,Contact__r.Preferred_Language__c,
                                 Contact__r.Special_Needs_Class__c, Contact__r.Allow_Data_Sharing2__c, Contact__r.Primary_Address_Reference__r.Address_Type__c, 
                                 Contact__r.Primary_Address_Reference__r.Province__c, Contact__r.Preferred_Contact_Method__c,MD__c,
                                 Contact__r.UCID__c, Contact__r.RecordtypeId, Contact__r.Name, Contact__r.Company_Name_Native_1__c,Contact__r.Foundation_Date__c,
                                 Contact__r.Website,Contact__r.Vat_No__c                                                 
                                 from Lead__c WHERE id IN : contactId];
         List<Account_Link__c> accLst = new List<Account_Link__c>(); 
         
          for(Lead__c dealerLead : leadLst){
            if(dealerLead.Assigned_Dealer__c != null)
                dealerId.add(dealerLead.Assigned_Dealer__c);
            if(dealerLead.Contact__c != null)
                AcclinkContactId.add(dealerLead.Contact__c);
            
         }
         
         System.debug('@#$%%%%%% AcclinkContactId'+AcclinkContactId);
          System.debug('@#$%%%%%% CompanyId'+CompanyId);
          System.debug('@#$%%%%%% leadLst'+leadLst);
           List<Account_Link__c> dealercount = [select id from Account_Link__c WHERE fromRole__c IN : dealerId AND (toRole__c IN : AcclinkContactId OR toRole__c IN : CompanyId) AND (RecordTypeId = :alkCompanyRecordTypeId OR RecordTypeId = :alkpersonRecordTypeId)];
         system.debug('########'+dealercount); 
         for(Lead__c led : leadlst){            
            if(led.Assigned_Dealer__c != null && (dealercount.isEmpty() || dealercount==null || dealercount.size() == 0 )){
                 Account_Link__c acclnk = new Account_Link__c(RecordTypeId = alkContactSectorRecordTypeId, toRole__c = led.Contact__c, fromRole__c = led.Assigned_Dealer__c);
                 //accLst.add(acclnk);
                 if(led.Contact__r.RecordTypeId == PersonRecordTypeId){
                 acclnk = new Account_Link__c(  RecordTypeId = alkpersonRecordTypeId, toRole__c = led.Contact__c, fromRole__c = led.Assigned_Dealer__c);
                  }else if(led.Contact__r.RecordTypeId == AccountCompanyId){
                      acclnk = new Account_Link__c(  RecordTypeId = alkCompanyRecordTypeId, Name = led.Contact__r.UCID__c, toRole__c = led.Contact__c, fromRole__c = led.Assigned_Dealer__c); 
                     
                  }
                  //acclnk.Retail_Fax__c = led.Contact__r.Fax;
                  //acclnk.Retail_Industry__c = led.contact__r.Industry;
                  if(led.MD__c == Label.MarketKR){
                      acclnk.Retail_Country__c = 'Korea';   
                  }
                  else if(led.MD__c == Label.MarketJP){
                      acclnk.Retail_Country__c = 'Japan';
                  }
                  if(led.Contact__r.Primary_Address_Reference__c != null){
                  acclnk.Retail_Address_Reference__c = led.Contact__r.Primary_Address_Reference__c;
                     
                   }    
                   accLst.add(acclnk);
            }
         }  
         system.debug('$%%$%$%$$$%'+accLst);
         if(!accLst.isEmpty()){
            //insert accLst;
            
            Database.SaveResult[] srList = Database.insert(accLst,false);
            
            
            
           for(Database.SaveResult sr : srList){
           if (sr.isSuccess()){
           {
           actlnkids.add(sr.getid());
           }
                  
         }
    }
     
         Account_link__c   acclink=new  Account_link__c();
    if(! actlnkids.isEmpty() ){
    system.debug('%%^%^%^%contactId^%'+actlnkids);
    system.debug('%%^%^%contactId^%^%'+contactId);
      if(contactId !=null && actlnkids!=null )
      {
    // acclink = [select id,Name, RecordType.DeveloperName from Account_Link__c WHERE id IN: actlnkids  AND (RecordTypeId=:alkCompanyRecordTypeId  OR RecordTypeId =:alkpersonRecordTypeId ) limit 1];
    //if(acclink !=null)
    //{
    for(Account_link__c al:accLst)
    {
    for(Lead__c ld : leadLst){
          ld.Retail_Contact__c = al.id;
          leadupdate.put(ld.id,ld);          
      }
      }
      //}
             //  LeadHelperAccountLinkCreateJP.updatingleadAccountDetails(contactId, actlnkids);
               }
           }       
    }
    
    Set<string>  leadrecId=new set<string>();
   Set<string>   accountlnkid=new set<string>();
    for(Lead__c leds: leadlst){            
            if(leds.Assigned_Dealer__c != null && dealercount.size() == 1){
            for(Account_Link__c alk:dealercount)
            {
            accountlnkid.add(alk.id);
            leadrecId.add(leds.id);
            if(accountlnkid !=null && leadrecId!=null )
            {
            leds.Retail_Contact__c = alk.id;
          leadupdate.put(leds.id,leds);
            }
            }
    }
    }
          system.debug('#$%^  LeadUtil.createAccountLinkRecord'+ LeadUtil.createAccountLinkRecord);
   
         if(LeadUtil.createAccountLinkRecord)
        {
        System.debug('^&^&^&&^&^&^&^& leadupdate.Values()'+leadupdate.Values());
    if(leadupdate !=null && leadupdate.Size()>0)
    {
    Update leadupdate.Values();
    //LeadHelperAccountLinkCreateJP.updatingleadAccountDetails(leadrecId, accountlnkid);
    System.debug('^&^&^&&^&^&^&^ venky& leadupdate.Values()'+leadupdate.Values());
    }
    System.debug('^&^&^&&^&^&^&^& outside leadupdate.Values()'+leadupdate.Values());
    }
        LeadUtil.createAccountLinkRecord=false;
     system.debug('#$%^  LeadUtil.createAccountLinkRecord'+ LeadUtil.createAccountLinkRecord);
    }
    /*Update Retail_Contact__c with the record Id of retail copy of the corresponding Account linked to the Leads record that belongs to the assigned dealer
     *SFDCJP-994
     *Sivaram
     *Japan 2.0
     */
    public static void updatingleadAccountDetails(set<String> leadrecId, set<string> accountlnkid){
    
     if(LeadUtil.updatingleadAccountDetails)
     {
  list<lead__c> leadupdate = new list<lead__c>();
  Account_Link__c acclink=new Account_Link__c ();
  list<Lead__c> leadlistrecords= new list<lead__c>();
  if(leadrecId !=null)
  {
        leadlistrecords = [select id, Name from Lead__c WHERE ID IN : leadrecId];
      } 
      if(accountlnkid !=null )
      {
      system.debug('alkCompanyRecordTypeId'+alkCompanyRecordTypeId);
       system.debug('alkpersonRecordTypeId'+alkpersonRecordTypeId);
      acclink = [select id,Name, RecordType.DeveloperName from Account_Link__c WHERE id IN: accountlnkid AND (RecordTypeId=:alkCompanyRecordTypeId  OR RecordTypeId =:alkpersonRecordTypeId ) limit 1];
      
      }
      if(leadlistrecords!=null)
      {
      for(Lead__c ld : leadlistrecords ){
          ld.Retail_Contact__c = acclink.id;
          leadupdate.add(ld);          
      }
      }
      if(leadupdate!=null)
      {
      update leadupdate;
      }
      }
      LeadUtil.updatingleadAccountDetails=false;
  }
  public static void updatingleadcontactDetails(list<Lead__c> leadlst,boolean isInsert, boolean isUpdate ){
  set<String> contctid = new set<string>();
  set<String> AssignedDealer = new set<string>();
  list<lead__c> leadupdate = new list<lead__c>();
  List<Account_Link__c> acclink = new List<Account_Link__c>();
  for(Lead__C led : leadlst){
      if(led.Assigned_Dealer__c != null){
          AssignedDealer.add(led.Assigned_Dealer__c);
          contctid.add(led.contact__c);
      }    
  }
  //if(!contctid.isempty()){
   acclink = [select id,Name, RecordType.DeveloperName,fromRole__c ,Torole__c from Account_Link__c WHERE fromRole__c IN: AssignedDealer and Torole__c=:contctid and  (RecordType.DeveloperName = 'Retail_Company' OR RecordType.DeveloperName = 'Retail_Person') limit 1];
  
  for(Lead__C led : leadlst){
      if(!acclink.isEmpty())
          led.Retail_Contact__c = acclink[0].id;
      //leadupdate.add(led);
  }
 // update leadupdate;
  //}
  
 // list<Lead__c> leadlistrecords = [select id, Name from Lead__c WHERE ID IN : contactId]; 
 }
}