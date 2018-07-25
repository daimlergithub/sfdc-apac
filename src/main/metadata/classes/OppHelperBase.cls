/**
* Utility for Trigger on Opportunity for all regions
* It will handle the lead reassinment funtionality and validation rules of all markets
* Author: Honey
* Created Date : 2017-10-10
*/
public without sharing class OppHelperBase{
    public static boolean booleanCampaignUpdate = true;
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

    //it will handle the lead reassign functionality before inserting the lead  
    public void updateOwnerwithDealer(List<Opportunity> leads, string Market){  
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
            if((l.RecordTypeId==salesRecordTypeId || l.RecordTypeId==afterSalesRecordTypeId) && l.md__c==Market){               
                Boolean checkSAS= true;
                if((string.isnotblank(l.assigned_dealer__c))){
                    if (userInfo.getUserType() != 'PowerPartner' ) {
                        l.Assigned_Date_Time__c = System.now();
                        l.stageName = 'Assigned';
                    }
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

    //it will handle the lead reassign functionality before updating the lead  
    public void updateOwner(List<Opportunity> leads, string Market){  
        List<Opportunity> ldowner = new List<Opportunity>();
        Set<ID> sConid = new Set<ID>();
        Map<ID,ID> mConToUsr = new Map<ID,ID>();
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
                else if((((Opportunity)Trigger.newMap.get(l.id)).assigned_dealer__c ==null && ((Opportunity)Trigger.oldMap.get(l.id)).assigned_dealer__c !=null)){
                    l.ownerId=l.createdbyId;
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

    //this method is common for before update and before insert of leadreassigning functionality   
    public Static void updateOwnership(set<id> acc, List<Opportunity> leadlist, string Market){
        Map<id, id> accUserMap = new Map<id, id>();
        if(acc.size()>0){
            accUserMap = getAccountToDLGKUser(acc);
        }
        for(Opportunity lists:leadlist){
            if(accUserMap.get(lists.assigned_dealer__c) !=null && lists.md__c==Market){
                lists.ownerID = accUserMap.get(lists.assigned_dealer__c); 
            } 
            else if(lists.assigned_dealer__c!=null &&  accUserMap.get(lists.assigned_dealer__c) ==null){
                //  lists.addError('The Dealer Lead Gate Keeper user is either not present or is inactive.');
            }                             
        }
    }
    
    public Static Map<ID, ID> getAccountToDLGKUser(Set<ID> Accid){
        Map<ID,ID> mAccToDLGKUser = new Map<ID,ID>();
        Map<ID,ID> mContactToUsr = new Map<ID,ID>();
        for(User user : [Select id, contact.AccountID, ContactID from user where contact.AccountID in :Accid and isActive = true]){
            mContactToUsr.put(user.contactID, user.id);
        }
        for(Contact con : [Select id, AccountID from contact where AccountID in :Accid and Dealer_Lead_Gate_Keeper__c = true]){
            mAccToDLGKUser.put(con.AccountID, mContactToUsr.get(con.id));
        }
        return mAccToDLGKUser;
    }                                

    public static void updatemarket(List<Opportunity> leadList){       
        for(Opportunity leadRec : leadList){
            if(Test.isRunningTest()){
                leadRec.isTestRunning__c=true;
            }
            if(leadRec.Market__c =='' || leadRec.Market__c==NULL){
                leadRec.Market__c=leadRec.MD__c;
            }  
        }       
    }
    
    //Call informatica web service
    public void CdmLeadcreate(List < Opportunity > leadlist, map < id, Opportunity > leadOldMap,string market) {
        Set < Id > LeadIdinsert = new Set < Id > ();
        Set < Id > LeadIdupdate = new Set < Id > ();
        Map < Id, Opportunity > ldmap = new Map < Id, Opportunity > ([select id, Account.Ucid__c, Retail_Contact__r.Retail_DMS_Customer_ID__c, Assigned_Dealer__c from Opportunity where id in: leadOldMap.keyset()]);
        for (Opportunity le: leadlist) {
            if (ldmap.containskey(le.Id)) {
                if (ldmap.get(le.Id).Account.Ucid__c != '' && ldmap.get(le.Id).Retail_Contact__r.Retail_DMS_Customer_ID__c != '' && le.Assigned_Dealer__c != null && le.Assigned_Dealer__c == leadOldMap.get(le.id).Assigned_Dealer__c && le.MD__c == market && le.StageName != leadOldMap.get(le.id).StageName && le.StageName == 'Accepted') {
                    LeadIdinsert.add(le.Id);
                }
            }
        }
        if (LeadIdinsert.size() > 0)
            //call informatica service
            CDMInformatica_Services.createLead(LeadIdinsert, market, 'insert');
        
    }
    
    //Added to get a dynamic Url in Email For Dealer Gate Keeper to login to Dealer Community  
    public static String getCommunityURL(){
        String communityName='Dealer Community Malaysia';
        String commubaseurl='';
        boolean flag1;
        List<Network>  myNetwork = [SELECT Id,Name FROM Network];
        for(Network net:myNetwork){
            if(net.name==communityName){
                flag1=true;
                commubaseurl=Network.getLoginUrl(net.id);
                break;
            }
        }
        return commubaseurl.replace('login','');
    } 
    
    //To Share Lead Record With Delaers
    public void ShareRecordswithDealers(List < Opportunity > leadlist, Boolean flag,string Market) {
        Set < String > dealerndcodeset = new Set < String > ();
        set < Opportunity > lstlead = new set < Opportunity > ();
        set < OpportunityShare > leadshare = new set < OpportunityShare > ();
        set < id > leadsharingtorevoke = new set < id > ();
        set < String > sharingrevokefromgroups = new set < String > ();
        List < Opportunity > leadlisttoiterat = [select id, createdby.usertype, createdby.Dealer_nd_code__c, assigned_dealer__c, assigned_dealer__r.Dealer_nd_code__c,assigned_dealer__r.MD__c,createdby.Market__c,MD__c from Opportunity where id IN: leadlist];
        //below if part will work at the time of insert
        for (Opportunity leadsrec: leadlisttoiterat) {
            if (!flag) {
                //if created by is Dealer then share those records with under that Dealer depends on dealer nd code
                if (leadsrec.createdby.usertype == 'PowerPartner' && leadsrec.createdby.Dealer_nd_code__c != null) {
                    string GrpName=leadsrec.createdby.Market__c+leadsrec.createdby.Dealer_nd_code__c;
                    dealerndcodeset.add(GrpName);
                    lstlead.add(leadsrec);
                } else if (leadsrec.assigned_dealer__c != null && leadsrec.assigned_dealer__r.Dealer_nd_code__c != null) {
                    string GrpName=leadsrec.assigned_dealer__r.MD__c+leadsrec.assigned_dealer__r.Dealer_nd_code__c;
                    dealerndcodeset.add(GrpName);
                    lstlead.add(leadsrec);
                }
            } else {
                //if trigger new map value is filled and  oldmap assigned dealer is null then share records with new assigned value
                if (((Opportunity) trigger.newmap.get(leadsrec.id)).assigned_dealer__c != null && ((Opportunity) trigger.oldMap.get(leadsrec.id)).assigned_dealer__c == null && leadsrec.assigned_dealer__r.Dealer_nd_code__c != null) {
                    string GrpName=leadsrec.assigned_dealer__r.MD__c+leadsrec.assigned_dealer__r.Dealer_nd_code__c;
                    dealerndcodeset.add(GrpName);
                    lstlead.add(leadsrec);
                }
                //if trigger old is not equal to trigger new  then give access to new dealer and then revoke access from old dealer
                else if (((Opportunity) trigger.newmap.get(leadsrec.id)).assigned_dealer__c != null && ((Opportunity) trigger.oldMap.get(leadsrec.id)).assigned_dealer__c != null && ((Opportunity) trigger.newmap.get(leadsrec.id)).assigned_dealer__c != ((Opportunity) trigger.oldmap.get(leadsrec.id)).assigned_dealer__c && leadsrec.assigned_dealer__r.Dealer_nd_code__c != null) {
                    string GrpName=leadsrec.assigned_dealer__r.MD__c+leadsrec.assigned_dealer__r.Dealer_nd_code__c;
                    dealerndcodeset.add(GrpName);
                    lstlead.add(leadsrec);
                    //will revoke record access depends on dealer nd code  if we change the assigned dealer
                    if (((Opportunity) trigger.newmap.get(leadsrec.id)).assigned_dealer__r.Dealer_nd_code__c != null) {
                        sharingrevokefromgroups.add(((Opportunity) trigger.oldmap.get(leadsrec.id)).MD__c+((Opportunity) trigger.oldmap.get(leadsrec.id)).assigned_dealer__r.Dealer_nd_code__c);
                        leadsharingtorevoke.add(((Opportunity) trigger.oldmap.get(leadsrec.id)).id);
                    }
                }
                //if trigger old value is filled and new value did not filled then revoke access from old Dealer
                else if (((Opportunity) trigger.oldmap.get(leadsrec.id)).assigned_dealer__c != null && ((Opportunity) trigger.newmap.get(leadsrec.id)).assigned_dealer__c == null) {
                    sharingrevokefromgroups.add(leadsrec.MD__c+((Opportunity) trigger.oldmap.get(leadsrec.id)).assigned_dealer__r.Dealer_nd_code__c);
                    leadsharingtorevoke.add(((Opportunity) trigger.oldmap.get(leadsrec.id)).id);
                }
            }
        }
        for (Group gp: [select id, name from Group where name IN: dealerndcodeset]) {
            for (Opportunity leadid: lstlead) {
                //this if part will applicable for Salesforce users
                string grpname=(leadid.MD__c+leadid.assigned_dealer__r.Dealer_nd_code__c);
                string grpCname=(leadid.createdby.Market__c+leadid.createdby.Dealer_nd_code__c );
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
        LeadUtil.leadAccountlnktrigger = false;
        set < String > actlnkids = new set < String > ();
        set < String > dealerId = new set < String > ();
        set < String > AcclinkContactId = new set < String > ();
        set < String > CompanyId = new set < String > ();
        Map < Id, Opportunity > leadupdate = new Map < Id, Opportunity > ();
        List < Opportunity > leadLst = [select Id, Retail_Contact__c, AccountID, Assigned_Dealer__c, Account.LastName, Account.FirstName, Account.LastName_Native_1__c,Account.ID_Type__c,Account.ID_Number__c,Account.country__c,
                                        Account.FirstName_Native_1__c, Account.PersonBirthdate, Account.Special_Care__c, Account.Individual_Home_Phone__c, Account.Work_Phone__c, Account.Primary_Address_Reference__r.Sub_District__c,
                                        Account.Mobile__c, Account.Fax, Account.Email__c, Account.Primary_Address_Reference__r.City__c, Account.Primary_Address_Reference__r.District__c,Account.createdDate,Account.lastmodifieddate,
                                        Account.Primary_Address_Reference__r.Block__c, Account.Primary_Address_Reference__r.Address_Line_1__c,Account.preferred_language__c,
                                        Account.Primary_Address_Reference__r.Address_Line_2__c, Account.Primary_Address_Reference__r.ZipCode__c,Account.Primary_Address_Reference__r.Address_Line_3__c,
                                        Account.Primary_Address_Reference__r.CreatedDate, Account.Primary_Address_Reference__r.LastModifiedDate,Account.Title__c,
                                        Account.gender__c, Account.Occupation__c,Account.Primary_Phone__c, Account.Industry, 
                                        Account.Special_Needs_Class__c, Account.Allow_Data_Sharing2__c, Account.Primary_Address_Reference__r.Address_Type__c,
                                        Account.Primary_Address_Reference__r.Province__c, Account.Preferred_Contact_Method__c, MD__c,
                                        Account.UCID__c,Account.Salutation__c, Account.RecordtypeId, Account.Name, Account.Company_Name_Native_1__c, Account.Foundation_Date__c,Account.Primary_Address_Reference__r.Foreign_Nationals__c,
                                        Account.Website, Account.Vat_No__c, Account.DMS_Customer_ID__c, Account.Complaint_Amount__c, Account.Sales_Sanction__c, Account.Allow_Data_Sharing__c, Account.PersonEmail, Account.PersonHasOptedOutOfEmail, Account.PersonHasOptedOutOfFax, Account.Primary_Phone_Display__c, Account.PersonDoNotCall, Account.Postal_Opt_Out__c, Account.Job__c, Account.Personal_Agreement__c, Account.Personal_Information_Third_Party_Release__c, Account.Personal_Abroad_Agreement__c, Account.Agreement_to_commit_info_processing__c, Account.Commercial_Reg_No__c, Account.Company_Name__c, Account.Visit_Opt_Out__c,Assigned_Dealer__r.Dealer_Rollout_Status__c
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
                        acclnk.Retail_Address_Type__c = led.Account.Primary_Address_Reference__r.Address_Type__c;
                        acclnk.Retail_ZipCode__c = led.Account.Primary_Address_Reference__r.ZipCode__c;
                        acclnk.Retail_Address_CreatedDate__c = date.newinstance(led.Account.Primary_Address_Reference__r.CreatedDate.year(), led.Account.Primary_Address_Reference__r.CreatedDate.month(), led.Account.Primary_Address_Reference__r.CreatedDate.day());
                        acclnk.Retail_Address_LastModifiedDate__c = date.newinstance(led.Account.Primary_Address_Reference__r.Lastmodifieddate.year(), led.Account.Primary_Address_Reference__r.Lastmodifieddate.month(), led.Account.Primary_Address_Reference__r.Lastmodifieddate.day());
                    }
                    acclnk.Retail_Country__c = led.Account.country__c;
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
                        cacclnk.Retail_Address_Type__c = led.Account.Primary_Address_Reference__r.Address_Type__c;
                        cacclnk.Retail_ZipCode__c = led.Account.Primary_Address_Reference__r.ZipCode__c;
                        cacclnk.Retail_Address_CreatedDate__c = date.newinstance(led.Account.Primary_Address_Reference__r.CreatedDate.year(), led.Account.Primary_Address_Reference__r.CreatedDate.month(), led.Account.Primary_Address_Reference__r.CreatedDate.day());
                        cacclnk.Retail_Address_LastModifiedDate__c = date.newinstance(led.Account.Primary_Address_Reference__r.Lastmodifieddate.year(), led.Account.Primary_Address_Reference__r.Lastmodifieddate.month(), led.Account.Primary_Address_Reference__r.Lastmodifieddate.day());
                    }
                    cacclnk.Retail_Country__c = led.Account.country__c;
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
            if (string.isnotblank(le.Assigned_Dealer__c) && le.MD__c== Market) {
                if ( (isInsert && string.isnotblank(le.Assigned_Dealer__c))|| (isUpdate && le.Assigned_Dealer__c != leadOldMap.get(le.id).Assigned_Dealer__c)) {
                    if(string.isnotblank(le.AccountId)?existingRC.containskey(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.AccountId)):False){
                        le.Retail_Contact__c=existingRC.get(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.AccountId));
                    }
                    if(string.isnotblank(le.AccountID)?existingRC.containskey(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.AccountID)):False){
                        le.Retail_Company__c=existingRC.get(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.AccountID));
                    }
                    leadupdate.put(le.id, le);    
                }
                else if(isUpdate && (le.AccountId != leadOldMap.get(le.id).AccountId)){
                    if(string.isnotblank(le.AccountId)?existingRC.containskey(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.AccountId)):False){
                        le.Retail_Contact__c=existingRC.get(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.AccountId));            
                    }
                    leadupdate.put(le.id, le);
                }
                else if(isUpdate && (le.AccountID!= leadOldMap.get(le.id).AccountID)){
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
  

    //This method will be used to empty the retial copy field lookup of company and person
    public static void updateRetailLookups(List<Opportunity> Leadlist, String Market){
        for(Opportunity le:Leadlist){
            if (string.isblank(le.Assigned_Dealer__c) && le.MD__c== Market) {
                le.Retail_Contact__c=NULL;
                le.Retail_Company__c=NULL;
            }
        } 
    }
    
    public static void mapCarModelToOpportunity(Map<Id,Opportunity> mapIdOpportunity)
    {
        CarModelMappingUtility.mapIdOpportunity = mapIdOpportunity;
        CarModelMappingUtility.mapCarModelOpportunity();
    }
}