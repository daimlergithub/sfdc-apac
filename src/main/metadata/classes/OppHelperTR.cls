/**
* Utility for Trigger on Opportunity for Turkey
*It will handle the lead reassinment funtionality and validation rules of MY market
* Author: Hildaa
* Created Date : 05/14/2018
**/
public without sharing  class  OppHelperTR{
   
    String Market = System.Label.TR;
    
    private static final String salesRecordTypeId = UtilRecordType.getRecordTypeIdByName('Opportunity', System.Label.Sales_Lead);
    private static final String afterSalesRecordTypeId = UtilRecordType.getRecordTypeIdByName('Opportunity', System.Label.Aftersales_Lead);
    private static final String PersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static final String AccountCompanyId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    private static final String alkCompanyRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    private static final String alkpersonRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    private static final String alkContactSectorRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('ContactSector').getRecordTypeId();
    set<id> accId = new set<id>();
    set<id> newmapid= new set<id>();
    Map<id, id> accUserMap = new Map<id, id>();
    public static boolean MBCPOSrecursioncheck= true;
    public static boolean recursioncheck= true;
    OppHelperBase helperBase = new OppHelperBase();
    //it will handle the lead reassign functionality befor insert the lead  
    //  When a Dealer Will be assigned to a Lead , CAC Lead Status will be changed to Assigned and it Will auto-populate Assigned date time
    
    public void updateassignedDealerAccount(list<Opportunity> leads){
        User usr ;
        if (userInfo.getUserType() == 'PowerPartner' ){
            usr = [select id,name,contactid,contact.AccountId from user where id = :userinfo.getuserId()];
            system.debug('---> '+usr);
        }
        if(usr != null){
            for(Opportunity op : leads){
                op.assigned_dealer__c= usr.Contact.AccountId;
            }
                
        }
    }
    public void updateOwnerwithDealer(List<Opportunity> leads){
        List<Opportunity> leadslist=new List<Opportunity>();
        List<Opportunity> ldowner = new List<Opportunity>();
        Set<ID> sConid = new Set<ID>();
        Map<ID,ID> mConToUsr = new Map<ID,ID>();
        for(Opportunity ld : leads){
            if(Ld.Sales_Consultant__c != NULL && (ld.RecordTypeId==salesRecordTypeId)){
                sConid.add(ld.Sales_Consultant__c);
            }
        }
        sConid.remove(NULL);
        for(User usr : [Select id, contactID from user where contactID in :sConid]){
            mConToUsr.put(usr.contactID, usr.ID);
        }
        for(Opportunity l : leads){
            if((l.RecordTypeId==salesRecordTypeId || l.RecordTypeId==afterSalesRecordTypeId) && l.Market__c==Market){               
                Boolean checkSAS= true;
                if((string.isnotblank(l.assigned_dealer__c))){
                    if (userInfo.getUserType() != 'PowerPartner' ) {
                        l.Assigned_Date_Time__c = System.now();
                        l.stageName = 'Assigned';
                    }
                }   
            else if (userInfo.getUserType() == 'PowerPartner' ){
                 l.Assigned_Date_Time__c = System.now();
                        l.stageName = 'Assigned';
            }
            
                if(string.isnotblank(l.Sales_Consultant__c) && l.RecordTypeId==salesRecordTypeId && string.isnotblank(l.assigned_dealer__c)){
                    l.ownerID = mConToUsr.get(L.Sales_Consultant__c);
                    checkSas=false;
                }
                else if(string.isnotblank(l.Assigned_Service_Advisor__c) && l.RecordTypeId==afterSalesRecordTypeId && string.isnotblank(l.assigned_dealer__c)){
                    l.ownerID = L.Assigned_Service_Advisor__c;
                    checkSas=false;
                }
                if(checkSas && (string.isnotblank(l.assigned_dealer__c))){
                    ldowner.add(l);
                    accId.add(l.assigned_dealer__c);    
                }
            }
        }
        if(!ldowner.isEmpty()){         
            if(accId.size()> 0){
                updateOwnership(accid,ldowner,Market);
            }
        }
    }
  
    //this method is common for before update and before insert of leadreassigning functionality   
    public Static void updateOwnership(set<id> acc, List<Opportunity> leadlist, string Market){
        Map<String, user> accUserMap = new Map<String, user>();
        Map<Id, string> AccountGCCOde = new Map<id, string>();
        for(Account acc1:[select id,name,dealer_gc_code__c from account where id in:acc and recordtype.name='Dealer' and market__c='TR'])
        {
            AccountGCCOde.put(acc1.Id,acc1.dealer_gc_code__c);
        }
        if(acc.size()>0){
            accUserMap = getAccountToDLGKUser(acc,AccountGCCOde);
        }
        for(Opportunity lists:leadlist){
            if(accUserMap !=null && lists.Market__c==Market && AccountGCCOde != null && AccountGCCOde.get(lists.assigned_dealer__c) != null && accUserMap.get(AccountGCCOde.get(lists.assigned_dealer__c)) != null){
                lists.ownerID = accUserMap.get(AccountGCCOde.get(lists.assigned_dealer__c)).Id;
                //lists.assigned_dealer__c = accUserMap.get(AccountGCCOde.get(lists.assigned_dealer__c)).contact.AccountID;
            } 
            else if(lists.assigned_dealer__c!=null &&  accUserMap.get(lists.assigned_dealer__c) ==null){
                //  lists.addError('The Dealer Lead Gate Keeper user is either not present or is inactive.');
            }                             
        }
    }
     public Static Map<String, user> getAccountToDLGKUser(Set<ID> Accid,Map<Id, string> AccountGCCOde){
        Map<String,user> mAccToDLGKUser = new Map<String,user>();
        Map<ID,user> mContactToUsr = new Map<ID,user>();
        
        for(User user : [Select id, contact.AccountID, ContactID,contact.account.dealer_gc_code__c from user where contact.account.dealer_gc_code__c in :AccountGCCOde.values() and isActive = true]){
            mContactToUsr.put(user.contactID, user);
        }
        for(Contact con : [Select id, AccountID,account.dealer_gc_code__c from contact where account.dealer_gc_code__c in :AccountGCCOde.values() and Dealer_Lead_Gate_Keeper__c = true]){
            mAccToDLGKUser.put(con.account.dealer_gc_code__c, mContactToUsr.get(con.id));
        }
        return mAccToDLGKUser;
    }       
    public void updateOwner(List<Opportunity> leads){        
           List<Opportunity> ldowner = new List<Opportunity>();
        Set<ID> sConid = new Set<ID>();
        Map<ID,ID> mConToUsr = new Map<ID,ID>();
        Opp_Escalation__mdt customDate = [Select Id,SentReminder1__c,SLAExpiryState__c,SLA_Expiry_after_2hrs__c,Reassign_Leadowner__c,Leadownerreassign__c from Opp_Escalation__mdt where market__c=:label.TR];
        for(Opportunity ld : leads){
            if(((Opportunity)Trigger.newMap.get(ld.id)).Sales_Consultant__c != NULL && ld.RecordTypeId==salesRecordTypeId){
                sConid.add(((Opportunity)Trigger.newMap.get(ld.id)).Sales_Consultant__c);
            }
        }
        sConid.remove(NULL);
        if(sConid.size()>0){
            for(User usr : [Select id, contactID from user where contactID in :sConid]){
                mConToUsr.put(usr.contactID, usr.ID);
            }                              
        }
        for(Opportunity l : leads){
            if(l.RecordTypeId==salesRecordTypeId || l.RecordTypeId==afterSalesRecordTypeId){
                if((((Opportunity)Trigger.newMap.get(l.id)).assigned_dealer__c != ((Opportunity)Trigger.oldMap.get(l.id)).assigned_dealer__c && ((Opportunity)Trigger.newMap.get(l.id)).assigned_dealer__c != NULL)){
                    if (userInfo.getUserType() != 'PowerPartner' ) {
                        l.Assigned_Date_Time__c = System.now();
                        l.StageName = 'Assigned';
                    }
                }
                if(((Opportunity)Trigger.newMap.get(l.id)).Sales_Consultant__c !=((Opportunity)Trigger.oldMap.get(l.id)).Sales_Consultant__c && ((Opportunity)Trigger.newMap.get(l.id)).Sales_Consultant__c != NULL  && (l.RecordTypeId==salesRecordTypeId) && ((Opportunity)Trigger.newMap.get(l.id)).assigned_dealer__c != NULL) {
                    l.ownerID = mConToUsr.get(((Opportunity)Trigger.newMap.get(l.id)).Sales_Consultant__c);
                }
                else if(((Opportunity)Trigger.newMap.get(l.id)).Assigned_Service_Advisor__c !=((Opportunity)Trigger.oldMap.get(l.id)).Assigned_Service_Advisor__c && ((Opportunity)Trigger.newMap.get(l.id)).Assigned_Service_Advisor__c != NULL  && ( l.RecordTypeId==afterSalesRecordTypeId) && ((Opportunity)Trigger.newMap.get(l.id)).assigned_dealer__c != NULL){
                    l.ownerID = ((Opportunity)Trigger.newMap.get(l.id)).Assigned_Service_Advisor__c;
                }
                else if((((Opportunity)Trigger.newMap.get(l.id)).assigned_dealer__c != ((Opportunity)Trigger.oldMap.get(l.id)).assigned_dealer__c && ((Opportunity)Trigger.newMap.get(l.id)).assigned_dealer__c != NULL)){
                    ldowner.add(l);
                    accId.add(l.assigned_dealer__c); 
                }
        else if((((Opportunity)Trigger.newMap.get(l.id)).assigned_dealer__c ==null && ((Opportunity)Trigger.oldMap.get(l.id)).assigned_dealer__c !=null) && (l.Lead_DataSource__c != 'Facebook' || l.Lead_DataSource__c != 'Insurance'  || l.Lead_DataSource__c != 'Instagram' )){
            if(customDate != null && customDate.Leadownerreassign__c != null)
                    l.ownerId=customDate.Leadownerreassign__c;
                    l.Assigned_Date_Time__c = NULL;
                    l.StageName = 'New';
                }
            }
            if(!ldowner.isEmpty() && userInfo.getUserType() != 'PowerPartner' ){
                
                if(accId.size()>0){
                    updateOwnership(accId,ldowner,market);
                }
            }
        }               
    }
  
   
    
    public  void ShareRecordswithDealers(List<Opportunity> leadlist,Boolean flag){
       Set < String > dealerndcodeset = new Set < String > ();
        set < Opportunity > lstlead = new set < Opportunity > ();
        set < OpportunityShare > leadshare = new set < OpportunityShare > ();
        set < id > leadsharingtorevoke = new set < id > ();
        set < String > sharingrevokefromgroups = new set < String > ();
        List < Opportunity > leadlisttoiterat = [select id, createdby.usertype, Market__c,createdby.Dealer_GC_Code__c, assigned_dealer__c, assigned_dealer__r.Dealer_GC_Code__c,assigned_dealer__r.Market__c,createdby.Market__c,MD__c from Opportunity where id IN: leadlist];
        //below if part will work at the time of insert
        for (Opportunity leadsrec: leadlisttoiterat) {
            if (!flag) {
                //if created by is Dealer then share those records with under that Dealer depends on dealer gc code
                if (leadsrec.createdby.usertype == 'PowerPartner' && leadsrec.createdby.Dealer_GC_Code__c != null) {
                    string GrpName=leadsrec.createdby.Market__c+leadsrec.createdby.Dealer_GC_Code__c;
                    dealerndcodeset.add(GrpName);
                    lstlead.add(leadsrec);
                } else if (leadsrec.assigned_dealer__c != null && leadsrec.assigned_dealer__r.Dealer_GC_Code__c != null) {
                    string GrpName=leadsrec.assigned_dealer__r.Market__c+leadsrec.assigned_dealer__r.Dealer_GC_Code__c;
                    dealerndcodeset.add(GrpName);
                    lstlead.add(leadsrec);
                }
            } else {
                //if trigger new map value is filled and  oldmap assigned dealer is null then share records with new assigned value
                if (((Opportunity) trigger.newmap.get(leadsrec.id)).assigned_dealer__c != null && ((Opportunity) trigger.oldMap.get(leadsrec.id)).assigned_dealer__c == null && leadsrec.assigned_dealer__r.Dealer_GC_Code__c != null) {
                    string GrpName=leadsrec.assigned_dealer__r.Market__c+leadsrec.assigned_dealer__r.Dealer_GC_Code__c;
                    dealerndcodeset.add(GrpName);
                    lstlead.add(leadsrec);
                }
                //if trigger old is not equal to trigger new  then give access to new dealer and then revoke access from old dealer
                else if (((Opportunity) trigger.newmap.get(leadsrec.id)).assigned_dealer__c != null && ((Opportunity) trigger.oldMap.get(leadsrec.id)).assigned_dealer__c != null && ((Opportunity) trigger.newmap.get(leadsrec.id)).assigned_dealer__c != ((Opportunity) trigger.oldmap.get(leadsrec.id)).assigned_dealer__c && leadsrec.assigned_dealer__r.Dealer_GC_Code__c != null) {
                    string GrpName=leadsrec.assigned_dealer__r.Market__c+leadsrec.assigned_dealer__r.Dealer_GC_Code__c;
                    dealerndcodeset.add(GrpName);
                    lstlead.add(leadsrec);
                    //will revoke record access depends on dealer gc code  if we change the assigned dealer
                    if (((Opportunity) trigger.newmap.get(leadsrec.id)).assigned_dealer__r.Dealer_GC_Code__c != null) {
                        sharingrevokefromgroups.add(((Opportunity) trigger.oldmap.get(leadsrec.id)).Market__c+((Opportunity) trigger.oldmap.get(leadsrec.id)).assigned_dealer__r.Dealer_GC_Code__c);
                        leadsharingtorevoke.add(((Opportunity) trigger.oldmap.get(leadsrec.id)).id);
                    }
                }
                //if trigger old value is filled and new value did not filled then revoke access from old Dealer
                else if (((Opportunity) trigger.oldmap.get(leadsrec.id)).assigned_dealer__c != null && ((Opportunity) trigger.newmap.get(leadsrec.id)).assigned_dealer__c == null) {
                    sharingrevokefromgroups.add(leadsrec.Market__c+((Opportunity) trigger.oldmap.get(leadsrec.id)).assigned_dealer__r.Dealer_GC_Code__c);
                    leadsharingtorevoke.add(((Opportunity) trigger.oldmap.get(leadsrec.id)).id);
                }
            }
        }
        for (Group gp: [select id, name from Group where name IN: dealerndcodeset]) {
            for (Opportunity leadid: lstlead) {
                //this if part will applicable for Salesforce users
                string grpname=(leadid.Market__c+leadid.assigned_dealer__r.Dealer_GC_Code__c);
                string grpCname=(leadid.createdby.Market__c+leadid.createdby.Dealer_GC_Code__c );
                if (gp.name == grpname) {
                    leadshare.add(new opportunityshare(opportunityid= leadid.id, UserOrGroupId = gp.id, RowCause = Schema.Lead__share.Rowcause.manual, OpportunityAccessLevel = 'EDIT'));
                } //this else part will applicable for Dealer users
                else if (gp.name == grpCname && leadid.createdby.Usertype == 'PowerPartner') {
                    leadshare.add(new opportunityshare(opportunityid= leadid.id, UserOrGroupId = gp.id, RowCause = Schema.Lead__share.Rowcause.manual, OpportunityAccessLevel = 'EDIT'));
                }
            }
        }
        //else part will work at the time of Update
        if (leadshare.size() > 0) {
            List < OpportunityShare > leadshareList = new List < OpportunityShare > ();
            leadshareList.addall(leadshare);
            Database.insert(leadshareList);
            if (leadsharingtorevoke.size() > 0) {
                database.delete([select id,opportunityid from OpportunityShare where opportunityid IN: leadsharingtorevoke and UserOrGroupId IN: sharingrevokefromgroups]);
            }
        }      
    }
    
	public void afterInsertEventShareAccountInt(List < Opportunity > opplist) {
        List < AccountShare > AccountShareList = new List < AccountShare > ();
        Set < String > ndCode = new Set < String > ();
        List < id > acctoshare = new List < id > ();
        List < Opportunity > opp = [select id, AccountId,Assigned_Dealer__c,Assigned_Dealer__r.Market__c,Assigned_Dealer__r.Dealer_GC_Code__c from Opportunity where AccountId != null and Assigned_Dealer__c!= null and id =: opplist];
        for (Opportunity optyrec: opp) {
            //acctoshare.add(optyrec.Assigned_Dealer__c);
            acctoshare.add(optyrec.AccountId);
            if (optyrec.Assigned_Dealer__r.Dealer_GC_Code__c != null) {
                string grpName = optyrec.Assigned_Dealer__r.Market__c + optyrec.Assigned_Dealer__r.Dealer_GC_Code__c;

                ndCode.add(grpName);
            }
        }
        if (ndCode.size() > 0) {
            for (Group groupRec: [select Id, Name, Type from Group where Name IN: ndCode]) {
                for (ID acct: acctoshare) {
                    AccountShare thisAccountShare = new AccountShare(); //a new empty OpportunityShare object
                    thisAccountShare.userorgroupid = groupRec.id;
                    thisAccountShare.accountId = acct;
                    thisAccountShare.accountaccesslevel = 'Edit';
                    thisAccountShare.RowCause = Schema.AccountShare.RowCause.Manual;
                    thisAccountShare.OpportunityAccessLevel = 'None';
                    AccountShareList.add(thisAccountShare);
                }
            }
            if (AccountShareList.size() > 0) {
                Database.insert(AccountShareList, false);

            }
        }

    }

    Public void CreateRetailCopy(List < Opportunity > leadlist, map < id, Opportunity > leadOldMap, boolean isInsert, boolean isUpdate, string market) {
        CheckRetailCopy(leadlist, leadOldMap, isInsert, isUpdate, market);
    }
    //A retail Copy (Retail Person/ Retail Company)Will be validated if existing will be updated, a dealer will be assigned to Lead 
    public static void CheckRetailCopy(List < Opportunity > leadlist, map < id, Opportunity > leadOldMap, boolean isInsert, boolean isUpdate,string market) {
        set < String > contactId = new set < String > ();
        set < String > actlnkids = new set < String > ();
        set < String > dealerId = new set < String > ();
        set < String > AcclinkContactId = new set < String > ();
        set < String > CompanyId = new set < String > ();
        for (Opportunity dealerLead: leadlist) {
            if (string.isnotblank(dealerLead.Assigned_Dealer__c) && string.isnotblank(dealerLead.AccountId)){
                dealerId.add(dealerLead.Assigned_Dealer__c);
                contactId.add(dealerlead.id);
            }
            if (string.isnotblank(dealerLead.AccountId ))
                AcclinkContactId.add(dealerLead.AccountId);
            if(string.isnotblank(dealerLead.AccountID))
                CompanyId.add(dealerLead.AccountID);
        }
        List < Account_Link__c > dealercount = new List<Account_link__c>();
        dealerCount=[select id,fromRole__c,toRole__c from Account_Link__c WHERE fromRole__c IN: dealerId AND(toRole__c IN: AcclinkContactId OR toRole__c IN: CompanyId) AND(RecordTypeId =: alkCompanyRecordTypeId OR RecordTypeId =: alkpersonRecordTypeId) AND(Retail_Delete_Flag__c = false AND Retail_Duplicate_Flag__c = false)];
        Map<string,id> CombinedId= new Map<string,id>();
        for(account_link__c accLink: dealerCount){
            if(string.isnotblank(acclink.fromRole__c) && string.isnotblank(acclink.toRole__c))
                CombinedId.put(string.valueof(acclink.fromRole__c)+string.valueof(acclink.toRole__c),acclink.id);
        }
        if (contactId.size() > 0) {
            createAccountLinkRecord(contactId,market,combinedId,IsInsert,isupdate,leadOldMap);
        }
    }

    //A retail Copy (Reatil Person/ Retail Company)Will be Created in Dealer account automatically , if a dealer will be assigned to Lead 
    public static void createAccountLinkRecord(set < String > contactId,string Market, Map<string,Id> existingRC, boolean isInsert, boolean isUpdate, map < id, Opportunity > leadOldMap){
        Map<String,string> countryMap = new map<string,string>();
        LeadUtil.leadAccountlnktrigger = false;
        set < String > actlnkids = new set < String > ();
        set < String > dealerId = new set < String > ();
        set < String > AcclinkContactId = new set < String > ();
        set < String > CompanyId = new set < String > ();
        Map < Id, Opportunity > leadupdate = new Map < Id, Opportunity > ();
         for(CountryTranslation__mdt cmdt: [select id, Country__c,Country_Translation__c,Market__c from CountryTranslation__mdt where Market__c=:Label.TR])
         {
             countryMap.put(cmdt.Country__c,cmdt.Country_Translation__c);
         }
        List < Opportunity > leadLst = [select Id, Retail_Contact__c, AccountID, Assigned_Dealer__c, Account.LastName, Account.FirstName, Account.LastName_Native_1__c,Account.ID_Type__c,Account.ID_Number__c,Account.country__c,
                                        Account.FirstName_Native_1__c, Account.PersonBirthdate, Account.Special_Care__c, Account.Individual_Home_Phone__c, Account.Work_Phone__c, Account.Primary_Address_Reference__r.Sub_District__c,
                                        Account.Mobile__c, Account.Fax, Account.Email__c, Account.Primary_Address_Reference__r.City__c, Account.Primary_Address_Reference__r.District__c,Account.createdDate,Account.lastmodifieddate,
                                        Account.Primary_Address_Reference__r.Block__c, Account.Primary_Address_Reference__r.Country__c,Account.Primary_Address_Reference__r.Address_Line_1__c,Account.preferred_language__c,
                                        Account.Primary_Address_Reference__r.Address_Line_2__c, Account.Primary_Address_Reference__r.ZipCode__c,Account.Primary_Address_Reference__r.Address_Line_3__c,
                                        Account.Primary_Address_Reference__r.CreatedDate, Account.Primary_Address_Reference__r.LastModifiedDate,Account.Title__c,
                                        Account.gender__c, Account.Occupation__c,Account.Primary_Phone__c, Account.Industry, 
                                        Account.Special_Needs_Class__c, Account.Allow_Data_Sharing2__c, Account.Primary_Address_Reference__r.Address_Type__c,
                                        Account.Primary_Address_Reference__r.Province__c, Account.Preferred_Contact_Method__c, MD__c,
                                        Account.UCID__c,Account.Salutation__c, Account.RecordtypeId, Account.Name, Account.Company_Name_Native_1__c, Account.Foundation_Date__c,Account.Primary_Address_Reference__r.Foreign_Nationals__c,
                                        Account.Website,Market__c, Account.Vat_No__c, Account.DMS_Customer_ID__c, Account.Complaint_Amount__c, Account.Sales_Sanction__c, Account.Allow_Data_Sharing__c, Account.PersonEmail, Account.PersonHasOptedOutOfEmail, Account.PersonHasOptedOutOfFax, Account.Primary_Phone_Display__c, Account.PersonDoNotCall, Account.Postal_Opt_Out__c, Account.Job__c, Account.Personal_Agreement__c, Account.Personal_Information_Third_Party_Release__c, Account.Personal_Abroad_Agreement__c, Account.Agreement_to_commit_info_processing__c, Account.Commercial_Reg_No__c, Account.Company_Name__c, Account.Visit_Opt_Out__c,Assigned_Dealer__r.Dealer_Rollout_Status__c
                                        from Opportunity WHERE id IN: contactId];
        List < Account_Link__c > accLst = new List < Account_Link__c > ();
        for (Opportunity dealerLead: leadLst) {
            if (dealerLead.Assigned_Dealer__c != null)
                dealerId.add(dealerLead.Assigned_Dealer__c);
            if (string.isnotblank(dealerLead.AccountID) && (!existingRC.containskey(string.valueof(dealerLead.Assigned_Dealer__c)+string.valueof(dealerLead.AccountId))))
                AcclinkContactId.add(dealerLead.AccountID);
            if(string.isnotblank(dealerLead.AccountID) && (!existingRC.containskey(string.valueof(dealerLead.Assigned_Dealer__c)))){
                CompanyId.add(dealerLead.AccountID);
            }
        }
        for (Opportunity led: leadlst) {
            if (led.Assigned_Dealer__c != null && String.isnotblank(led.Assigned_Dealer__r.Dealer_Rollout_Status__c)?(led.Assigned_Dealer__r.Dealer_Rollout_Status__c=='Done'):false) {
                Account_Link__c acclnk = new Account_Link__c();
                Account_Link__c cacclnk = new Account_Link__c();
                if (led.Account.RecordTypeId == PersonRecordTypeId && (!existingRC.containskey(string.valueof(led.Assigned_Dealer__c)+string.valueof(led.AccountId)))) {
                    acclnk = new Account_Link__c(RecordTypeId = alkpersonRecordTypeId, toRole__c = led.AccountId, fromRole__c = led.Assigned_Dealer__c);
                    if (led.Account.Primary_Address_Reference__c != null) {
                        acclnk.Retail_Province__c = led.Account.Primary_Address_Reference__r.Province__c;
                        acclnk.Retail_City__c = led.Account.Primary_Address_Reference__r.District__c;
                        acclnk.Retail_Distinct__c = led.Account.Primary_Address_Reference__r.Sub_District__c;
                        acclnk.Retail_Address_Line_1__c = led.Account.Primary_Address_Reference__r.Address_Line_1__c;
                        acclnk.Retail_Address_Line_2__c = led.Account.Primary_Address_Reference__r.Address_Line_2__c;
                        acclnk.Retail_Address_Line_3__c = led.Account.Primary_Address_Reference__r.Address_Line_3__c;
                        if(Market == Label.TR){
                            if(acclnk.Retail_City__c != null)
                                acclnk.Retail_City__c = led.Account.Primary_Address_Reference__r.City__c.left(17);
                            acclnk.Retail_Distinct__c = led.Account.Primary_Address_Reference__r.District__c;
                            if(acclnk.Retail_Address_Line_1__c != null)
                                acclnk.Retail_Address_Line_1__c = led.Account.Primary_Address_Reference__r.Address_Line_1__c.left(17);
                             if(acclnk.Retail_Address_Line_2__c != null)
                                acclnk.Retail_Address_Line_2__c = led.Account.Primary_Address_Reference__r.Address_Line_2__c.left(17);
                        }
                        acclnk.Retail_Address_Type__c = led.Account.Primary_Address_Reference__r.Address_Type__c;
                        acclnk.Retail_ZipCode__c = led.Account.Primary_Address_Reference__r.ZipCode__c;
                        acclnk.Retail_Address_CreatedDate__c = date.newinstance(led.Account.Primary_Address_Reference__r.CreatedDate.year(), led.Account.Primary_Address_Reference__r.CreatedDate.month(), led.Account.Primary_Address_Reference__r.CreatedDate.day());
                        acclnk.Retail_Address_LastModifiedDate__c = date.newinstance(led.Account.Primary_Address_Reference__r.Lastmodifieddate.year(), led.Account.Primary_Address_Reference__r.Lastmodifieddate.month(), led.Account.Primary_Address_Reference__r.Lastmodifieddate.day());
                        if(led.Account.Primary_Address_Reference__r.Country__c != null && countryMap != null && countryMap.containskey(led.Account.Primary_Address_Reference__r.Country__c))
                             acclnk.Retail_Country__c = countryMap.get(led.Account.Primary_Address_Reference__r.Country__c);
                         else
                            acclnk.Retail_Country__c = led.Account.Primary_Address_Reference__r.Country__c;
                    }
                    
                    acclnk.Retail_Full_Name_Title__c = led.Account.Title__c +' '+led.Account.LastName + ' ' + led.Account.FirstName;
                    acclnk.Retail_Salutation__c=led.Account.Salutation__c;
                    acclnk.Retail_Special_Care__c=led.Account.Special_Care__c;
                    acclnk.createddate__c = led.Account.createdDate;
                    acclnk.Retail_ID_Type__c = led.Account.ID_Type__c;
                    acclnk.Retail_ID_Number__c = led.Account.ID_Number__c;
                    acclnk.LastModifiedDate__c = led.Account.LastmodifiedDate;
                    acclnk.Retail_LastName_Native__c=led.Account.LastName_Native_1__c;
                    acclnk.Retail_FirstName_Native__c = led.Account.FirstName_Native_1__c;
                    acclnk.Retail_Primary_Phone__c =led.Account.Primary_Phone__c;
                    acclnk.Retail_DMS_Customer_ID__c = led.Account.DMS_Customer_ID__c;
                    acclnk.Retail_DMS_Customer_ID__c = led.Account.DMS_Customer_ID__c;
                    acclnk.Retail_Full_Name__c = led.Account.LastName + ' ' + led.Account.FirstName;
                    acclnk.Retail_LastName__c = led.Account.LastName;
                    acclnk.Retail_FirstName__c = led.Account.FirstName;
                    acclnk.Retail_Complaint_Amount__c = led.Account.Complaint_Amount__c;
                    acclnk.Retail_Sales_Sanction__c = led.Account.Sales_Sanction__c;
                    acclnk.Retail_UCID__c = led.Account.UCID__c;
                    acclnk.Retail_Allow_Data_Sharing__c = led.Account.Allow_Data_Sharing__c;
                    acclnk.Retail_Mobile__c = led.Account.Mobile__c;
                    acclnk.Retail_Individual_Home_Phone__c = led.Account.Individual_Home_Phone__c;
                    acclnk.Retail_Work_Phone__c = led.Account.Work_Phone__c;
                    acclnk.Retail_Email__c = led.Account.PersonEmail;
                    acclnk.Retail_Fax__c = led.Account.Fax;
                    acclnk.Retail_Preferred_Contact_Method__c = led.Account.Preferred_Contact_Method__c;
                    acclnk.Retail_Email_OptOut__c = led.Account.PersonHasOptedOutOfEmail;
                    acclnk.Retail_Fax_OptOut__c = led.Account.PersonHasOptedOutOfFax;
                    acclnk.Retail_Phone_OptOut__c = led.Account.PersonDoNotCall;
                    acclnk.Retail_Postal_OptOut__c = led.Account.Postal_Opt_Out__c;
                    acclnk.Retail_Visit_OptOut__c = led.Account.Visit_Opt_Out__c;
                    acclnk.Retail_PersonBirthdate__c = led.Account.PersonBirthdate;
                    acclnk.Retail_Occupation__c = led.Account.Occupation__c;
                    acclnk.Retail_Position__c = led.Account.Job__c;
                    acclnk.Retail_Preferred_Language__c = led.Account.preferred_language__c;
                    acclnk.Retail_Gender__c = led.Account.Gender__c;
                    acclnk.Retail_Industry__c = led.Account.industry;
                    acclnk.Retail_WebSite__c = led.Account.Website;
                    acclnk.Retail_Company_Name_Native1__c = led.Account.Company_Name_Native_1__c;
                    acclnk.Retail_Commercial_Reg_No__c = led.Account.Commercial_Reg_No__c;
                    acclnk.Retail_Agreement__c = led.Account.Personal_Agreement__c;
                    acclnk.Retail_Information_Third_Party_Release__c = led.Account.Personal_Information_Third_Party_Release__c;
                    acclnk.Retail_Abroad_Agreement__c = led.Account.Personal_Abroad_Agreement__c;
                    acclnk.Retail_Agreement_Info_Processing__c = led.Account.Agreement_to_commit_info_processing__c;
                    acclnk.Retail_Vat_No__c = led.Account.Vat_No__c;
                    if (led.Account.Foundation_Date__c != null)
                        acclnk.Retail_Foundation_Month__c = String.valueOf(led.Account.Foundation_Date__c.year()) + (String.ValueOf(led.Account.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(led.Account.Foundation_Date__c.month())) : String.ValueOf(led.Account.Foundation_Date__c.month())) + (String.ValueOf(led.Account.Foundation_Date__c.day()).length() == 1 ? ('0' + String.ValueOf(led.Account.Foundation_Date__c.day())) : String.ValueOf(led.Account.Foundation_Date__c.day()));
                    if (led.Account.Primary_Address_Reference__c != null) {
                        acclnk.Retail_Address_Reference__c = led.Account.Primary_Address_Reference__c;
                    }
                    accLst.add(acclnk);
                } 
                if (led.Account.RecordTypeId == AccountCompanyId && (!existingRC.containskey(string.valueof(led.Assigned_Dealer__c)+string.valueof(led.Accountid)))) {
                    cacclnk = new Account_Link__c(RecordTypeId = alkCompanyRecordTypeId, Name = led.Account.UCID__c, toRole__c = led.accountID, fromRole__c = led.Assigned_Dealer__c);
                    if (led.Account.Primary_Address_Reference__c != null) {
                        cacclnk.Retail_Province__c = led.Account.Primary_Address_Reference__r.Province__c;
                        cacclnk.Retail_City__c = led.Account.Primary_Address_Reference__r.Sub_District__c;
                        cacclnk.Retail_Distinct__c = led.Account.Primary_Address_Reference__r.District__c;
                        cacclnk.Retail_Address_Line_1__c = led.Account.Primary_Address_Reference__r.Address_Line_1__c;
                        cacclnk.Retail_Address_Line_2__c = led.Account.Primary_Address_Reference__r.Address_Line_2__c;
                        cacclnk.Retail_Address_Line_3__c = led.Account.Primary_Address_Reference__r.Address_Line_3__c;
                        if(Market == Label.TR){
                            if(acclnk.Retail_City__c != null)
                                acclnk.Retail_City__c = led.Account.Primary_Address_Reference__r.City__c.left(17);
                            acclnk.Retail_Distinct__c = led.Account.Primary_Address_Reference__r.District__c;
                            if(acclnk.Retail_Address_Line_1__c != null)
                                acclnk.Retail_Address_Line_1__c = led.Account.Primary_Address_Reference__r.Address_Line_1__c.left(17);
                            if(acclnk.Retail_Address_Line_2__c != null)
                                acclnk.Retail_Address_Line_2__c = led.Account.Primary_Address_Reference__r.Address_Line_2__c.left(17);
                        }
                        cacclnk.Retail_Address_Type__c = led.Account.Primary_Address_Reference__r.Address_Type__c;
                        cacclnk.Retail_ZipCode__c = led.Account.Primary_Address_Reference__r.ZipCode__c;
                        cacclnk.Retail_Address_CreatedDate__c = date.newinstance(led.Account.Primary_Address_Reference__r.CreatedDate.year(), led.Account.Primary_Address_Reference__r.CreatedDate.month(), led.Account.Primary_Address_Reference__r.CreatedDate.day());
                        cacclnk.Retail_Address_LastModifiedDate__c = date.newinstance(led.Account.Primary_Address_Reference__r.Lastmodifieddate.year(), led.Account.Primary_Address_Reference__r.Lastmodifieddate.month(), led.Account.Primary_Address_Reference__r.Lastmodifieddate.day());
                        if(led.Account.Primary_Address_Reference__r.Country__c != null && countryMap != null && countryMap.containskey(led.Account.Primary_Address_Reference__r.Country__c))
                             cacclnk.Retail_Country__c = countryMap.get(led.Account.Primary_Address_Reference__r.Country__c);
                         else
                            cacclnk.Retail_Country__c = led.Account.Primary_Address_Reference__r.Country__c;
                    }
                   
                    cacclnk.Retail_UCID__c = led.Account.UCID__c;
                    cacclnk.Retail_DMS_Customer_ID__c = led.Account.DMS_Customer_ID__c;
                    cacclnk.Retail_Company_Name__c = led.Account.name;
                    cacclnk.createddate__c = led.Account.createdDate;
                    cacclnk.LastModifiedDate__c = led.Account.LastmodifiedDate;
                    cacclnk.Retail_Company_Phone__c = led.Account.Individual_Home_Phone__c;
                    cacclnk.Retail_Company_Other_Phone__c = led.Account.Work_Phone__c;
                    cacclnk.Retail_Mobile__c = led.Account.Mobile__c;
                    cacclnk.Retail_Email_OptOut__c = led.Account.PersonHasOptedOutOfEmail;
                    cacclnk.Retail_Fax_OptOut__c = led.Account.PersonHasOptedOutOfFax;
                    cacclnk.Retail_Primary_Phone__c = led.Account.Primary_Phone__c;
                    cacclnk.Retail_Sales_Sanction__c = led.Account.Sales_Sanction__c;
                    cacclnk.Retail_Phone_OptOut__c = led.Account.PersonDoNotCall;
                    cacclnk.Retail_Postal_OptOut__c = led.Account.Postal_Opt_Out__c;
                    cacclnk.Retail_Visit_OptOut__c = led.Account.Visit_Opt_Out__c;
                    cacclnk.Retail_Fax__c = led.Account.fax;
                    cacclnk.Retail_Industry__c = led.Account.Industry;
                    cacclnk.Retail_Commercial_Reg_No__c = led.Account.Commercial_Reg_No__c;
                    cacclnk.Retail_Vat_No__c = led.Account.Vat_No__c;
                    cacclnk.Retail_WebSite__c = led.Account.Website;
                    cacclnk.Retail_Agreement__c = led.Account.Personal_Agreement__c;
                    cacclnk.Retail_Information_Third_Party_Release__c = led.Account.Personal_Information_Third_Party_Release__c;
                    cacclnk.Retail_Abroad_Agreement__c = led.Account.Personal_Abroad_Agreement__c;
                    cacclnk.Retail_Agreement_Info_Processing__c = led.Account.Agreement_to_commit_info_processing__c;
                    cacclnk.Retail_Country__c = led.Account.country__c;
                    if (led.Account.Foundation_Date__c != null)
                        cacclnk.Retail_Foundation_Month__c = String.valueOf(led.Account.Foundation_Date__c.year()) + (String.ValueOf(led.Account.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(led.Account.Foundation_Date__c.month())) : String.ValueOf(led.Account.Foundation_Date__c.month())) + (String.ValueOf(led.Account.Foundation_Date__c.day()).length() == 1 ? ('0' + String.ValueOf(led.Account.Foundation_Date__c.day())) : String.ValueOf(led.Account.Foundation_Date__c.day()));   
                    if(led.Account.Primary_Address_Reference__c != null) {
                        cacclnk.Retail_Address_Reference__c = led.Account.Primary_Address_Reference__c;              
                    }
                    accLst.add(cacclnk);         
                } 
            }
        }
        if (!accLst.isEmpty()) {
            Database.SaveResult[] srList = Database.insert(accLst, false);
            Integer i=0;
            for (Database.SaveResult sr: srList) {
                if (sr.isSuccess()) {
                    {
                        if(!existingRC.containskey(string.valueof(accLst[i].fromRole__c)+string.valueof(acclst[i].torole__c))){
                            existingRC.put(string.valueof(accLst[i].fromRole__c)+string.valueof(acclst[i].torole__c),sr.getid())  ;
                        }
                        actlnkids.add(sr.getid());
                    }
                }
                i++;
            }
        }
        Set < string > leadrecId = new set < string > ();
        Set < string > accountlnkid = new set < string > ();
        for (Opportunity le: leadlst) {
            if (string.isnotblank(le.Assigned_Dealer__c) && le.Market__c== Market) {
                if ( (isInsert && string.isnotblank(le.Assigned_Dealer__c))|| (isUpdate && le.Assigned_Dealer__c != leadOldMap.get(le.id).Assigned_Dealer__c)) {
                    if(le.Account.RecordTypeId == PersonRecordTypeId && string.isnotblank(le.AccountId)?existingRC.containskey(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.AccountId)):False){
                        le.Retail_Contact__c=existingRC.get(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.AccountId));
                    }
                    if(le.Account.RecordTypeId == AccountCompanyId && string.isnotblank(le.AccountID)?existingRC.containskey(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.AccountID)):False){
                        le.Retail_Company__c=existingRC.get(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.AccountID));
                    }
                    leadupdate.put(le.id, le);    
                }
                else if(le.Account.RecordTypeId == PersonRecordTypeId && isUpdate && (le.AccountId != leadOldMap.get(le.id).AccountId)){
                    if(string.isnotblank(le.AccountId)?existingRC.containskey(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.AccountId)):False){
                        le.Retail_Contact__c=existingRC.get(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.AccountId));            
                    }
                    leadupdate.put(le.id, le);
                }
                else if(le.Account.RecordTypeId == AccountCompanyId &&  isUpdate && (le.AccountID!= leadOldMap.get(le.id).AccountID)){
                    if(string.isnotblank(le.AccountID)?existingRC.containskey(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.AccountID)):False){
                        le.Retail_Company__c=existingRC.get(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.AccountID));
                    }
                    leadupdate.put(le.id, le);
                }
            }
            else if(isupdate && string.isblank(le.Assigned_Dealer__c) &&  string.isnotblank(leadOldMap.get(le.id).Assigned_Dealer__c) && le.MD__c==Market){
                le.Retail_Contact__c=NULL;
                le.Retail_Company__c=NULL;
                leadupdate.put(le.id, le);
            }
        }
        if (LeadUtil.createAccountLinkRecord) {
            if (leadupdate != null && leadupdate.Size() > 0) {
                LeadUtil.createAccountLinkRecord = false;
                Update leadupdate.Values();
            }
        }
    }

        public void CdmLeadcreate(List < Opportunity> leadlist, map < id, Opportunity> leadOldMap,string market,boolean isUpdate){
        Set < Id > LeadIdinsert = new Set < Id > ();
        for(Opportunity op : leadlist){
        if(op.RecordTypeId==salesRecordTypeId && isUpdate && op.stageName != leadOldMap.get(op.Id).StageName && op.stageName == 'Accepted' && !string.isblank(op.Assigned_Dealer__c) && oppHelperTR.MBCPOSrecursioncheck)
                LeadIdinsert.add(op.Id);
        }
	if(!LeadIdinsert.isEmpty())
        	CDMInformatica_Services.createOpportunity(LeadIdinsert,market,'insert');
	MBCPOSrecursioncheck = false;
    }
  
    public void updateRetailLookups(List < Opportunity> leadlist,string market){
    for(Opportunity le:Leadlist){
            if (string.isblank(le.Assigned_Dealer__c) && le.Market__c== Market) {
                le.Retail_Contact__c=NULL;
                le.Retail_Company__c=NULL;
            }
        } 
    }
    
    public void checkAddress(List<Opportunity> oppList){
        Set<Id> accIdSet = new Set<Id>();
        for(Opportunity o:oppList){
            accIdSet.add(o.AccountId);
        }
        Map<Id,Address__C> opAddressMap = new Map<Id,Address__C>();
        List<Address__c> addressList =[Select Address_Line_1__c, District__c, Province__c, Customer__c from Address__c where Customer__c IN :accIdSet];
        for(Address__c ad:addressList ){
           opAddressMap.put(ad.Customer__c,ad);
        }
        for(Opportunity o:oppList){
            if(o.StageName == 'Order placed' ){
               Address__c address = opAddressMap.get(o.AccountId); 
                if(address== null){
                    o.addError('Address of Related Account cannot be blank');
                }
            }
        }
    }
    
	public void changeCustomerPhase(List<Opportunity> oppList){

		Id SalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordtypeID();
		Id AfterSalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aftersales Lead').getRecordtypeID();
		//Id careRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordtypeID();
		Set<Id> accIdSet = new Set<Id>();
		Map<Id, Account> accList ;
		List<Account> accServiceToUpdate = new List<Account>();
	   
		for(Opportunity o:oppList){
			accIdSet.add(o.AccountId);
			
		} 
		
		if(accIdSet!= null){        
			accList = new Map<Id,Account>([Select Id, Customer_Lifecycle_Phase__c from Account where ID IN: accIdSet]);
		}
		
		for(Opportunity o: oppList)
		{
			if(accList.containsKey(o.AccountId) &&  (o.RecordTypeId == SalesLeadRecordTypeId || o.RecordTypeId == AfterSalesLeadRecordTypeId))
			{
				Account a = accList.get(o.AccountId);
				a.Customer_Lifecycle_Phase__c = 'Lead' ;
				accServiceToUpdate.add(a);
			}
		}
		
		if(accServiceToUpdate != null){
			update accServiceToUpdate;
		}
        
    }
    /*public void changeCustomerPhase(List<Opportunity> oppList){
        System.debug('entered Custom phase ');
        Id SalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordtypeID();
        Id AfterSalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aftersales Lead').getRecordtypeID();
        Id careRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordtypeID();
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> oIdSet = new Set<Id>();
        List<Account> accList = new List<Account>();
        Map<Id,Account> accSalesToUpdate = new Map<Id,Account>();
        Map<Id,Account> accServiceToUpdate = new Map<Id,Account>();
        Map<Id,List<Opportunity>> accOpMap= new Map<Id,List<Opportunity>>();
        List<Opportunity> opExistingList = new List<Opportunity>();
        List<account> salesList = new List<account>();
        List<account> afterSalessList = new List<account>();
        List<Case> caseList = new List<Case>();
        Map<Id,Id> mapAccCase= new Map<Id,Id>();
        for(Opportunity o:oppList){
            accIdSet.add(o.AccountId);
            //for update call
            if(o.Id!=null){
                oIdSet.add(o.Id);
            }
        }
        System.debug('entered Custom phase accIdSet '+accIdSet);
        
        if(accIdSet!= null){        
            accList = [Select Id, Customer_Lifecycle_Phase__c from Account where ID IN: accIdSet];
            opExistingList=[Select Id, Name, AccountID, RecordTypeId,StageName from Opportunity where AccountId IN:accIdSet and Id Not IN:oIdSet];
            caseList=[Select Id, AccountID, Status, RecordTypeId from Case where AccountId IN:accIdSet and Status='Open' and RecordTypeId=:careRecordTypeId];
        }
        
        for(account a:accList){
            List<Opportunity> opList = new List<Opportunity>();
            for(Case c:caseList){
                if(a.Id==c.AccountId){
                    mapAccCase.put(a.Id,c.Id);
                }
            }
            for(Opportunity o:opExistingList){
                if(a.Id==o.AccountId){
                    opList.add(o);
                }   
            }
            for(Opportunity o:oppList){
                if(a.Id==o.AccountId){
                    opList.add(o);
                } 
            }
            accOpMap.put(a.Id,opList);
            System.debug('entered Custom phase opList '+opList);
        }
        System.debug('entered Custom phase accOpMap '+accOpMap);
        for(account a:accList){
            System.debug('entered Custom phase a '+a);
            if(mapAccCase.get(a.Id)== null){
                for(Opportunity o:accOpMap.get(a.Id)){
                    System.debug('entered Custom phase o '+o);
                    if(o.RecordTypeId == SalesLeadRecordTypeId && o.StageName!= 'Closed Won' && o.StageName!='Closed Lost' ){
                        a.Customer_Lifecycle_Phase__c = 'Sales';
                        accSalesToUpdate.put(a.Id,a);
                        if(accServiceToUpdate.containsKey(o.AccountId)){
                            accServiceToUpdate.remove(a.Id);
                        }
                    }
                    else if(o.RecordTypeId == AfterSalesLeadRecordTypeId && !accSalesToUpdate.containsKey(o.AccountId)){
                        a.Customer_Lifecycle_Phase__c = 'Service';
                        accServiceToUpdate.put(a.Id,a);
                    }
                }
            }
        } 
        System.debug('entered Custom phase accSalesToUpdate '+accSalesToUpdate);
        System.debug('entered Custom phase accServiceToUpdate '+accServiceToUpdate);
        salesList = accSalesToUpdate.values();
        afterSalessList = accServiceToUpdate.values();
        if(salesList!= null){
            update salesList;
        }
        if(afterSalessList!= null){
            update afterSalessList;
        }
    }
    */
   
    public void changeActivityOwner(List<Opportunity> oppList){
        Set<Id> opSet = new Set<Id>();
        Map<Id,Id> opOwnerMap = new Map<Id,Id>();
        List<Task> taskToUpdate = new List<Task>();
        List<Event> eventToUpdate = new List<Event>();
        for(Opportunity o:oppList){
            if(Trigger.oldMap!=null){
                Opportunity oldOp = (Opportunity)Trigger.oldMap.get(o.Id);
                if(o.OwnerId != oldOp.OwnerId){
                    opSet.add(o.Id);
                    opOwnerMap.put(o.Id,o.OwnerId);
                }
            }                
        }
        List<Task> taskList = [Select Id, OwnerId, WhatId from Task where WhatID IN: opSet];
        List<Event> eventList = [Select Id, OwnerId, WhatId from Event where WhatID IN: opSet];
        for(Task t:taskList){
            t.ownerId = opOwnerMap.get(t.WhatId);
            taskToUpdate.add(t);
        }
        for(Event e:eventList){
            e.ownerId = opOwnerMap.get(e.WhatId);
            eventToUpdate.add(e);
        }
        update taskToUpdate;
        
        update eventToUpdate;
    }
    //UpdateSLATimeForOpportunity
 
 public static void calculateSLATime(List<Opportunity> oppList1)
    {   
        Set<ID> OpptyID = new Set<Id>();
        Integer hotHours;
        Integer coldHours;
        Integer warmHours;
        string country;
        Opp_Escalation__mdt customDate = [Select Id,Hot_Hours__c,Warm_Hours__c,Cold_Hours__c,BusinessHrCountry__c,Market__c from Opp_Escalation__mdt where Market__c=:Label.TR];
        hotHours=Integer.valueOf(customdate.Hot_Hours__c);        
        warmHours=Integer.valueOf(customdate.Warm_Hours__c);
        coldHours=Integer.valueOf(customdate.Cold_Hours__c);
        country=string.valueOf(customdate.BusinessHrCountry__c);
        
        try{
            for(SObject obj:Trigger.new)
            {   
                Opportunity newo=(Opportunity)obj;
                Opportunity oldo;
                
                if(trigger.isupdate){
                    oldo=(Opportunity)trigger.oldmap.get(newo.id);
                }                
                //system.debug('<<old0'+oldo+'<<dealerName'+oldo.Assigned_Dealer__c);
                //system.debug('<<newo'+newo+'<<Dealer naem' +newo.Assigned_Dealer__c);
                if( oldo!=null && newo.Assigned_Dealer__c != oldo.Assigned_Dealer__c && trigger.isupdate)
                {                    
                    OpptyID.add(newo.id); 
                }                 
                else if(trigger.isInsert && newo!=null ){
                    OpptyID.add(newo.id);
                }
            }
            System.debug('<<OpptyID'+ OpptyID);
            if(OpptyID != null && OpptyID.size()>0)
            {
                system.debug('<<Entered IF condition'); 
                List<Opportunity> OppList = new List<Opportunity>();               
                OppList=[Select id,Lead_Temperature__c,Opp_SLA_Time__c,Assigned_Date_Time__c,Assigned_Dealer__c from Opportunity where id in : OpptyID];  
                System.debug('<<OppList'+OppList);
                list<Opportunity> OpptyToUpdate = new List<Opportunity>();
                //Please xplain abt the recursive check u used.
                if(OppHelperTR.recursioncheck)
                {
                    for(Opportunity opp : OppList)
                    {
                        System.debug('<<Entered For Loop1');
                        if(opp.Assigned_Dealer__c == null)
                        {
                            opp.Assigned_Date_Time__c=null;
                            opp.Opp_SLA_Time__c =null;
                            opp.StageName='New';
                            opp.SLA_Status__c=null;
                            System.debug('<<Entered IF Condition');
                        }
                        else{   
                            System.debug('<<Enterd Else block ');
                            opp.Assigned_Date_Time__c = Datetime.now();   
                            //Datetime dt = Datetime.now();
                            Datetime dt = opp.Assigned_Date_Time__c;  
                            opp.SLA_Status__c=null;
                            opp.StageName='Assigned';
                            BusinessHours bhrs = [Select Id from BusinessHours where Name = :country]; 
                            if(opp.Lead_Temperature__c=='hot') opp.Opp_SLA_Time__c = BusinessHours.addGmt(bhrs.id, dt , hotHours * 60 * 60 * 1000L) ;    
                            else if (opp.Lead_Temperature__c=='warm')  opp.Opp_SLA_Time__c = BusinessHours.addGmt(bhrs.id, dt , warmHours * 60 * 60 * 1000L) ;
                            else if (opp.Lead_Temperature__c=='cold')  opp.Opp_SLA_Time__c = BusinessHours.addGmt(bhrs.id, dt , coldHours * 60 * 60 * 1000L) ;   
                        }    
                        OpptyToUpdate.add(opp);   
                    }
                    
                    //Opp_SLA_Time__c
                    //Opp_Assigned_time__c
                    system.debug('<<Updaed succesfully');
                    update OpptyToUpdate;
                    recursioncheck = false;
                }
            }
        }
        catch(Exception e)
        {
            System.debug('<<Some Error has Come');
            system.debug(e.getMessage());
        }
        
    }
 
 
 //RelatedOpporunitySLA
 
 public static void updaterelatedOppRecord(List<Opportunity> opplist,Map<Id,Opportunity> oldmap){
 List<Opportunity_SLA__c> oppslalist = new List<Opportunity_SLA__c>();
 try{
 for(Opportunity opp : opplist){
 if(oldmap.get(opp.Id).SLA_Status__c != opp.SLA_Status__c){
            Opportunity_SLA__c sla = new Opportunity_SLA__c();
            //sla.Name = opp.Id;
            sla.Related_Opportunity__c = opp.Id;
            sla.Dealer_Name__c = opp.Assigned_Dealer__c;
            sla.Lead_Temperature__c = opp.Lead_Temperature__c;
            sla.Market__c = opp.Market__c;
            sla.Opp_SLA_Time__c = opp.Opp_SLA_Time__c;
            sla.SLA_Expired_Count__c = opp.SLA_Expired_Count__c;
            sla.SLA_Status__c = opp.SLA_Status__c;
            oppslalist.add(sla);
        }
    }
     if(!oppslalist.isEmpty()){
        insert oppslalist;
    }
    } catch(Exception e)
        {
            System.debug('<<Some Error has Come');
            system.debug(e.getMessage());
        }
   

    }
    //method to populate the contactid for leads associated with person accounts for surveys
    public void populateContact(List < Opportunity > opplist,boolean isUpdate,Map < Id, Opportunity > oldmap)
    {
        set<Id> Accountids = new set<id>();
        set<Id> CompAccountids = new set<id>();
        Map<Id,Id> PersonAccountIds = new map<Id,Id>();
        for(Opportunity op : opplist)
        {
            if(op.AccountId != null && (!isUpdate ||(isUpdate && oldMap.get(op.Id).AccountId != op.AccountId)))
                Accountids.add(op.AccountId);
        }
        for(Account ac : [Select id,recordtypeid,personcontactid from account where id in :Accountids]){
            if(ac.recordtypeid == PersonRecordTypeId)
                PersonAccountIds.put(ac.Id, ac.personcontactid);
            if(ac.recordtypeid == AccountCompanyId)
                CompAccountids.add(ac.Id);
                
        }
        for(Opportunity op : opplist)
        {
            if(op.AccountId != null && PersonAccountIds != null && PersonAccountIds.containskey(op.AccountId))
                op.Contact__c = PersonAccountIds.get(op.AccountId);
            else if (op.AccountId != null && CompAccountids!= null && CompAccountids.contains(op.AccountId))
                op.Contact__c = null;
            if((!isUpdate && op.StageName == 'Test drive completed') || (isUpdate && oldMap.get(op.Id).StageName != op.StageName && op.StageName == 'Test drive completed'))
                op.Express_Service__c = true;
        }
    }
 //Method to get the dealer gatekeepers based on assigned Dealer at opportunity
 public static map<ID,String> findGatekeepers(Set<ID> assignedDealers)
 {
     //soql on contact/Account to get gatekeeper emails based on assigned dealer at opportunity
     Map<ID,string> dealergkemail=new Map<ID,string>();
     List<Contact> conts=[SELECT Id, Name, Email, Account.Id FROM Contact where market__c='TR'  and Account.ispartner=True and Dealer_Lead_Gate_Keeper__c=True and Account.ID in :assignedDealers];
     for(contact c:conts)
        dealergkemail.put(c.Account.ID,c.Email);
    return dealergkemail;
     
 } 
 
 public static void mapRetailCopy(list<Opportunity> oppty)
 {
     set<Id> accId = new set<Id>();
     set<Id> dealerId = new set<Id>();
     Map<String,Account_Link__c> accLinkIds = new Map<String,Account_Link__c>();
     for(Opportunity opp: oppty){
         if(opp.Assigned_dealer__c != null)
         {
             accId.add(opp.accountId);
             dealerId.add(opp.Assigned_dealer__c);
         }
         for(Account_Link__c accLink :[select id,torole__c,fromRole__c,name,recordtypeId from account_link__c where Market__c=:Label.TR and toRole__c IN :accId and fromRole__c IN :dealerId and (Recordtypeid=:alkpersonRecordTypeId or Recordtypeid=:alkCompanyRecordTypeId)])
         {
             accLinkIds.put(accLink.torole__c+''+accLink.fromRole__c,accLink);
         }
         for(Opportunity opp1: oppty){
            if(opp1.Assigned_dealer__c != null && accLinkIds != null && accLinkIds.containskey(opp1.AccountId+''+opp1.Assigned_dealer__c) && accLinkIds.get(opp1.AccountId+''+opp1.Assigned_dealer__c) != null)
            {
                if(accLinkIds.get(opp1.AccountId+''+opp1.Assigned_dealer__c).recordtypeId == alkpersonRecordTypeId)
                    Opp1.Retail_Contact__c=accLinkIds.get(opp1.AccountId+''+opp1.Assigned_dealer__c).Id;
                else if(accLinkIds.get(opp1.AccountId+''+opp1.Assigned_dealer__c).recordtypeId == alkCompanyRecordTypeId)
                    Opp1.Retail_Company__c=accLinkIds.get(opp1.AccountId+''+opp1.Assigned_dealer__c).Id;
            }
         }
     }
 }
 public void populateformAssemblyURL(list<Opportunity> opp){
     for(opportunity oppty : opp){
         oppty.Job_Card_Number__c = Label.formAssemblyURL;
     }
 }
    
}