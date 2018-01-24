/**
* Utility for Trigger on Lead__c for all regions
*It will handle the lead reassinment funtionality and validation rules of all markets
* Author: Honey
* Created Date : 2017-10-10
*/
public without sharing class  LeadHelperBase{
    public static boolean booleanCampaignUpdate = true;
    private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
    private static final String retailSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.RETAIL_SALES_LEADS).getRecordTypeId();
	private static final String PersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static final String AccountCompanyId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    private static final String alkCompanyRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    private static final String alkpersonRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    private static final String alkContactSectorRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('ContactSector').getRecordTypeId();
    set<id> accId = new set<id>();
    set<id> newmapid= new set<id>();
    Map<id, id> accUserMap = new Map<id, id>();

    //it will handle the lead reassign functionality befor insert the lead  
    public void updateOwnerwithDealer(List<lead__c> leads, string Market){  
        List<lead__c> leadslist=new List<lead__c>();
        for(Lead__c lead:leads){
            if((lead.RecordTypeId==salesRecordTypeId || lead.RecordTypeId==afterSalesRecordTypeId || lead.RecordTypeId==retailSalesRecordTypeId) && lead.md__c==Market){
                accId.add(lead.assigned_dealer__c);    
            }
        }
        List<Account> accList = new List<Account>();
        accList = [Select Dealer_Lead_Gate_Keeper__c from Account where id=:accId ];
        if (accList.size()>0){
            for(Account acc:accList){
                if (acc.Dealer_Lead_Gate_Keeper__c != null){
                    accUserMap.put(acc.id, acc.Dealer_Lead_Gate_Keeper__c); 
                }
            }
        }
        for(Lead__c lead:leads){
            if((lead.RecordTypeId==salesRecordTypeId || lead.RecordTypeId==afterSalesRecordTypeId || lead.RecordTypeId==retailSalesRecordTypeId) && lead.md__c==Market){
                if(accUserMap.get(lead.assigned_dealer__c) !=null){
                    lead.ownerID = accUserMap.get(lead.assigned_dealer__c); 
                }   
            }
        }
    }
    
    //this will update dealername once the dealer is assigned.
    public void updateAllWorkflowsActionsAfterInsert(List<lead__c> leads,boolean flag, string Market){
        List<Lead__c> leadlist=[select id,RecordTypeID,md__c,assigned_dealer__c,Assigned_Dealer__r.Name from Lead__c where id=:leads];
        List<lead__c> updatelist=new List<lead__c>();
        for(Lead__c leadlst:leadlist){
            if(leadlst.md__c==Market){
                if(leadlst.assigned_dealer__c!=null){
                    if(leadlst.RecordTypeId==salesRecordTypeId || leadlst.RecordTypeId==afterSalesRecordTypeId || leadlst.RecordTypeId==retailSalesRecordTypeId){
                        leadlst.MBTH_Assigned_Dealer_Name__c=leadlst.Assigned_Dealer__c;
                        updatelist.add(leadlst);
                    }
                }
            }
        }
        if(updatelist.size()>0 && !flag ){
            DMLManagerService.updateAsSystem(updatelist);      
        }
    }

    //it will handle the lead reassign functionality befor update the lead  
    public void updateOwner(List<lead__c> leads, string Market){  
        for(Lead__c l:leads){
            if(l.md__c==Market){
                if(((Lead__c)Trigger.newMap.get(l.id)).assigned_dealer__c!=((Lead__c)Trigger.oldMap.get(l.id)).assigned_dealer__c  &&(l.RecordTypeId==salesRecordTypeId || l.RecordTypeId==afterSalesRecordTypeId || l.RecordTypeId==retailSalesRecordTypeId)){
                    if(((Lead__c)Trigger.newMap.get(l.id)).assigned_dealer__c!=null){
                        newmapid.add(((Lead__c)Trigger.newMap.get(l.id)).assigned_dealer__c);
                        l.Received_Date_Time__c=null;
                        l.Accepted_Date_Time__c=null;
                        l.dealer_lead_status__c='';
                    }
                    else{
                        l.assigned_dealer__c=null;
                        l.ownerId=l.createdbyId;
                    }
                }
                else if(((Lead__c)Trigger.newMap.get(l.id)).ownerid!=((Lead__c)Trigger.oldMap.get(l.id)).ownerid && (l.RecordTypeId==salesRecordTypeId || l.RecordTypeId==afterSalesRecordTypeId || l.RecordTypeId==retailSalesRecordTypeId)){
                    l.ownerID=((Lead__c)Trigger.newMap.get(l.id)).ownerid;
                }
                else if((l.RecordTypeId==salesRecordTypeId || l.RecordTypeId==afterSalesRecordTypeId || l.RecordTypeId==retailSalesRecordTypeId)){
                    if(l.assigned_dealer__c==null){
                        l.ownerID=l.createdbyId;
                    }
                    else{
                        if(l.assigned_dealer__c!=null && l.Received_Date_Time__c!=null&&l.Accepted_Date_Time__c!=null){
                            if(l.dealer_lead_status__c!=System.label.Accepted){
                                l.ownerID=l.createdbyId;
                                l.assigned_dealer__c=null;
                            }
                        }

                    }
                }
            }
            if(newmapid.size()>0){
                updateOwnership(newmapid,leads,market);
            }
        }
    }
    
    //it will handle all SARI validations of lead module
    public  void leadValidation(List<lead__c> leadlist, string Market){
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        for(Lead__c listlead:leadlist){
            if(listlead.md__c==Market){
                if((listlead.recordtypeid==afterSalesRecordTypeId || listlead.recordtypeid==salesRecordTypeId)&& profileName!='IntegrationAPI'){
                    if(listlead.CAC_Lead_Status__c==System.label.Purchased && listlead.Purchased_CAC_Date__c==null ){
                        listlead.CAC_Lead_Status__c.adderror(system.label.TH_CACPurchaseddateRequired_Error);
                    }
                    if(listlead.recordtypeid==salesRecordTypeId && listlead.CAC_Lead_Status__c==System.label.Purchased && (listlead.Purchased_CAC_Date__c==null||listlead.Bought_Vehicle_Brand__c==null||listlead.Bought_Vehicle_Class__c==null||listlead.Bought_Vehicle_Model__c==null) ){
                        listlead.CAC_Lead_Status__c.adderror(system.label.TH_CAC_LeadstatusPurchasedError);
                    }
                }
                if((listlead.recordtypeid==retailSalesRecordTypeId||listlead.recordtypeid==afterSalesRecordTypeId || listlead.recordtypeid==salesRecordTypeId) && profileName!='IntegrationAPI'){
                    if(listlead.Dealer_Lead_Status__c=='Order Placed' && listlead.Order_Placed_Date__c==null&&listlead.recordtypeid!=retailSalesRecordTypeId){
                        listlead.Order_Placed_Date__c.adderror(system.label.TH_SARI_DealerOrderplacedError);
                    }
                    if(listlead.Dealer_Lead_Status__c==System.label.Purchased && listlead.Purchased_Date__c==null){
                        listlead.Dealer_Lead_Status__c.adderror(system.label.TH_SARIDealerlead_status_error);
                    } 
                }
            }
        }
    }

    //this method is common for before update and before insert of leadreassigning functionality   
    public Static void updateOwnership(set<id> acc,List<Lead__c> leadlist, string Market){
        Map<id, id> accUserMap = new Map<id, id>();
        if(acc.size()>0){
            List<Account> accountList=[select Dealer_Lead_Gate_Keeper__c from Account where id=:acc];
            for(Account ac:accountList){
                if(ac.Dealer_Lead_Gate_Keeper__c!=null){
                    accUserMap.put(ac.id,ac.Dealer_Lead_Gate_Keeper__c);
                }
            }
        }
        for(Lead__c lists:leadlist){
            if(accUserMap.get(lists.assigned_dealer__c) !=null && lists.md__c==Market){
                lists.ownerID = accUserMap.get(lists.assigned_dealer__c); 
            } 
        }
    }
    /* Data Migration Explicit Fix - Santosh Mohanty */
    public static void updatemarket(List<Lead__c> leadList){       
        
               for(Lead__c leadRec : leadList){
                    if(Test.isRunningTest()){
                        leadRec.isTestRunning__c=true;
                    }
                   if(leadRec.Market__c =='' || leadRec.Market__c==NULL){
                      leadRec.Market__c=leadRec.MD__c;
                  }  
              }       
    }
    
    //Create retail copy
    //Mohammed Touseef Ahmed
    //01-19-18
   /* Public void CreateRetailCopy(List < Lead__c > leadlist, map < id, Lead__c > leadOldMap, boolean isInsert, boolean isUpdate) {
        set < String > contactId = new set < String > ();
        for (Lead__c le: leadlist) {
            if (le.Assigned_Dealer__c != null && le.MD__c == 'MY') {
                if (isInsert || (isUpdate && le.Assigned_Dealer__c != leadOldMap.get(le.id).Assigned_Dealer__c)) {
                    contactId.add(le.id);
                }
            }
        }
        if (contactId.size() > 0) {
            LeadHelperAccountLinkCreateJP.createAccountLinkRecord(contactId);
        }
    } */
    
    
    //Call informatica web service
    //Mohammed Touseef Ahmed
    //01-19-18
    public void CdmLeadcreate(List < Lead__c > leadlist, map < id, Lead__c > leadOldMap) {
        Set < Id > LeadIdinsert = new Set < Id > ();
        Set < Id > LeadIdupdate = new Set < Id > ();
        Map < Id, Lead__c > ldmap = new Map < Id, Lead__c > ([select id, Contact__r.Ucid__c, Retail_Contact__r.Retail_DMS_Customer_ID__c, Assigned_Dealer__c from Lead__c where id in: leadOldMap.keyset()]);
        for (Lead__c le: leadlist) {
            if (ldmap.containskey(le.Id)) {
                if (ldmap.get(le.Id).Contact__r.Ucid__c != '' && ldmap.get(le.Id).Retail_Contact__r.Retail_DMS_Customer_ID__c != '' && le.Assigned_Dealer__c != null && le.Assigned_Dealer__c == leadOldMap.get(le.id).Assigned_Dealer__c && le.MD__c == 'MY' && le.CAC_Lead_Status__c != leadOldMap.get(le.id).CAC_Lead_Status__c && le.CAC_Lead_Status__c == 'Accepted') {

                    LeadIdinsert.add(le.Id);
                }
            }
        }
        if (LeadIdinsert.size() > 0)
            //call informatica service
            CDMInformatica_Services.createLead(LeadIdinsert, 'MY', 'insert');

    }    
	    //Added by Asish Nanda to get a dynamic Url in Email For Dealer Gate Keeper to login to Malaysia Dealer Community  
    
    /* public static String getCommunityURL(){
        String communityName='Daimler Community Malaysia';
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
    } */
    // Added by Asish Nanda to get a dynamic Url in Email For Dealer Gate Keeper to login to Malaysia Dealer Community  
   /* public static void updatecommunityurl(List<Lead__c> Leadlist, String Market){
    String commURLMY=getCommunityURL();
    for(Lead__c le:Leadlist){
        if(le.md__c == Market)
        le.Others__c = commURLMY;
    }
    
} */  
/*
Added by : Asish Nanda
Test Cases : Conditions having When to Share Lead Record With Delaers
*/
  public void ShareRecordswithDealers(List < Lead__c > leadlist, Boolean flag,string Market) {
        Set < String > dealerndcodeset = new Set < String > ();
        set < Lead__c > lstlead = new set < Lead__c > ();
        set < Lead__Share > leadshare = new set < Lead__share > ();
        set < id > leadsharingtorevoke = new set < id > ();
        set < String > sharingrevokefromgroups = new set < String > ();
        List < Lead__c > leadlisttoiterat = [select id, createdby.usertype, createdby.Dealer_nd_code__c, assigned_dealer__c, assigned_dealer__r.Dealer_nd_code__c from Lead__C where id IN: leadlist];
        //System.debug('***leadlisttoiterat' + leadlisttoiterat[0].assigned_dealer__r + '---' + leadlisttoiterat[0].createdby.usertype);
        //below if part will work at the time of insert
        for (Lead__c leadsrec: leadlisttoiterat) {
            if (!flag) {
                //if created by is Dealer then share those records with under that Dealer depends on dealer nd code
                if (leadsrec.createdby.usertype == 'PowerPartner' && leadsrec.createdby.Dealer_nd_code__c != null) {
                    dealerndcodeset.add(leadsrec.createdby.Dealer_nd_code__c);
                    lstlead.add(leadsrec);
                } else if (leadsrec.assigned_dealer__c != null && leadsrec.assigned_dealer__r.Dealer_nd_code__c != null) {
                    dealerndcodeset.add(leadsrec.assigned_dealer__r.Dealer_nd_code__c);
                    lstlead.add(leadsrec);
                }
            } else {
                System.debug('***lead values' + ((Lead__c) trigger.newmap.get(leadsrec.id)).assigned_dealer__c + '--' + ((Lead__c) trigger.oldMap.get(leadsrec.id)).assigned_dealer__c + '---' + leadsrec.assigned_dealer__r);
                //if trigger new map value is filled and  oldmap assigned dealer is null then share records with new assigned value
                if (((Lead__c) trigger.newmap.get(leadsrec.id)).assigned_dealer__c != null && ((Lead__c) trigger.oldMap.get(leadsrec.id)).assigned_dealer__c == null && leadsrec.assigned_dealer__r.Dealer_nd_code__c != null) {
                    dealerndcodeset.add(leadsrec.assigned_dealer__r.Dealer_nd_code__c);
                    lstlead.add(leadsrec);
                }
                //if trigger old is not equal to trigger new  then give access to new dealer and then revoke access from old dealer
                else if (((Lead__c) trigger.newmap.get(leadsrec.id)).assigned_dealer__c != null && ((Lead__c) trigger.oldMap.get(leadsrec.id)).assigned_dealer__c != null && ((Lead__c) trigger.newmap.get(leadsrec.id)).assigned_dealer__c != ((Lead__c) trigger.oldmap.get(leadsrec.id)).assigned_dealer__c && leadsrec.assigned_dealer__r.Dealer_nd_code__c != null) {
                    dealerndcodeset.add(leadsrec.assigned_dealer__r.Dealer_nd_code__c);
                    lstlead.add(leadsrec);
                    //will revoke record access depends on dealer nd code  if we change the assigned dealer
                    if (((Lead__c) trigger.newmap.get(leadsrec.id)).assigned_dealer__r.Dealer_nd_code__c != null) {
                        sharingrevokefromgroups.add(((Lead__c) trigger.oldmap.get(leadsrec.id)).assigned_dealer__r.Dealer_nd_code__c);
                        leadsharingtorevoke.add(((Lead__c) trigger.oldmap.get(leadsrec.id)).id);
                    }
                }
                //if trigger old value is filled and new value did not filled then revoke access from old Dealer
                else if (((Lead__c) trigger.oldmap.get(leadsrec.id)).assigned_dealer__c != null && ((Lead__c) trigger.newmap.get(leadsrec.id)).assigned_dealer__c == null) {
                    sharingrevokefromgroups.add(((Lead__c) trigger.oldmap.get(leadsrec.id)).assigned_dealer__r.Dealer_nd_code__c);
                    leadsharingtorevoke.add(((Lead__c) trigger.oldmap.get(leadsrec.id)).id);
                }
                /*
                Added by Asish Nanda  
                Test Case- If CAC_Lead_Status__c will be Set to Purchased, Then Lead record will be Shared with Other Dealers , those who belong to Dealer_nd_code__c
                */
                else if(((Lead__c)Trigger.newMap.get(leadsrec.id)).CAC_Lead_Status__c != ((Lead__c)Trigger.oldMap.get(leadsrec.id)).CAC_Lead_Status__c && ((Lead__c)Trigger.newMap.get(leadsrec.id)).CAC_Lead_Status__c == 'Purchased'){
                    sharingrevokefromgroups.add(((Lead__c) trigger.oldmap.get(leadsrec.id)).assigned_dealer__r.Dealer_nd_code__c);
                    leadsharingtorevoke.add(((Lead__c) trigger.oldmap.get(leadsrec.id)).id);
                }
            }
        }
        for (Group gp: [select id, name from Group where name IN: dealerndcodeset]) {
            for (Lead__C leadid: lstlead) {
                //this if part will applicable for Salesforce users
                if (gp.name == leadid.assigned_dealer__r.Dealer_nd_code__c) {
                    leadshare.add(new Lead__Share(parentid = leadid.id, UserOrGroupId = gp.id, RowCause = Schema.Lead__share.Rowcause.manual, AccessLevel = 'EDIT'));
                } //this else part will applicable for Dealer users
                else if (gp.name == leadid.createdby.Dealer_nd_code__c && leadid.createdby.Usertype == 'PowerPartner') {
                    leadshare.add(new Lead__Share(parentid = leadid.id, UserOrGroupId = gp.id, RowCause = Schema.Lead__share.Rowcause.manual, AccessLevel = 'EDIT'));
                }
            }
        }

        //else part will work at the time of Update

        if (leadshare.size() > 0) {
            List < Lead__share > leadshareList = new List < Lead__share > ();
            leadshareList.addall(leadshare);
            Database.insert(leadshareList);
            if (leadsharingtorevoke.size() > 0) {
                database.delete([select id from Lead__share where parentid IN: leadsharingtorevoke and UserOrGroupId IN: sharingrevokefromgroups]);
            }
        }

    }
	/*
    Added by : Asish Nanda
    Test Case : A retail Copy (Reatil Person/ Retail Company)Will be Created in Dealer account automatically , if a dealer will be assigned to Lead 
    */
       public static void createAccountLinkRecord(set < String > contactId) {
        LeadUtil.leadAccountlnktrigger = false;
        set < String > actlnkids = new set < String > ();
        set < String > dealerId = new set < String > ();
        set < String > AcclinkContactId = new set < String > ();
        set < String > CompanyId = new set < String > ();
        Map < Id, Lead__c > leadupdate = new Map < Id, Lead__C > ();
        List < Lead__c > leadLst = [select Id, Retail_Contact__c, Company_Account__c, Contact__c, Assigned_Dealer__c, Contact__r.LastName, Contact__r.FirstName, Contact__r.LastName_Native_1__c,Contact__r.ID_Type__c,Contact__r.ID_Number__c,contact__r.country__c,
            Contact__r.FirstName_Native_1__c, Contact__r.PersonBirthdate, Contact__r.Special_Care__c, Contact__r.Individual_Home_Phone__c, Contact__r.Work_Phone__c, Contact__r.Primary_Address_Reference__r.Sub_District__c,
            Contact__r.Mobile__c, Contact__r.Fax, Contact__r.Email__c, Contact__r.Primary_Address_Reference__r.City__c, Contact__r.Primary_Address_Reference__r.District__c,Contact__r.createdDate,Contact__r.lastmodifieddate,
            Contact__r.Primary_Address_Reference__r.Block__c, Contact__r.Primary_Address_Reference__r.Address_Line_1__c,
            Contact__r.Primary_Address_Reference__r.Address_Line_2__c, Contact__r.Primary_Address_Reference__r.ZipCode__c,
            Contact__r.Primary_Address_Reference__r.CreatedDate, Contact__r.Primary_Address_Reference__r.LastModifiedDate,
            Contact__r.gender__c, contact__r.Occupation__c,Contact__r.Primary_Phone__c, Contact__r.Industry, Contact__r.Preferred_Language__c,
            Contact__r.Special_Needs_Class__c, Contact__r.Allow_Data_Sharing2__c, Contact__r.Primary_Address_Reference__r.Address_Type__c,
            Contact__r.Primary_Address_Reference__r.Province__c, Contact__r.Preferred_Contact_Method__c, MD__c,
            Contact__r.UCID__c,Contact__r.Salutation__c, Contact__r.RecordtypeId, Contact__r.Name, Contact__r.Company_Name_Native_1__c, Contact__r.Foundation_Date__c,Contact__r.Primary_Address_Reference__r.Foreign_Nationals__c,
            Contact__r.Website, Contact__r.Vat_No__c, Contact__r.DMS_Customer_ID__c, Contact__r.Complaint_Amount__c, Contact__r.Sales_Sanction__c, Contact__r.Allow_Data_Sharing__c, Contact__r.PersonEmail, Contact__r.PersonHasOptedOutOfEmail, Contact__r.PersonHasOptedOutOfFax, Contact__r.Primary_Phone_Display__c, Contact__r.PersonDoNotCall, Contact__r.Postal_Opt_Out__c, Contact__r.Job__c, Contact__r.Personal_Agreement__c, Contact__r.Personal_Information_Third_Party_Release__c, Contact__r.Personal_Abroad_Agreement__c, Contact__r.Agreement_to_commit_info_processing__c, Contact__r.Commercial_Reg_No__c, Contact__r.Company_Name__c, Contact__r.Visit_Opt_Out__c, Company_Account__r.FirstName, Company_Account__r.LastName_Native_1__c,Company_Account__r.ID_Type__c,Company_Account__r.ID_Number__c,Company_Account__r.country__c,
            Company_Account__r.FirstName_Native_1__c, Company_Account__r.PersonBirthdate, Company_Account__r.Special_Care__c, Company_Account__r.Individual_Home_Phone__c, Company_Account__r.Work_Phone__c, Company_Account__r.Primary_Address_Reference__r.Sub_District__c,
            Company_Account__r.Mobile__c, Company_Account__r.Fax, Company_Account__r.Email__c, Company_Account__r.Primary_Address_Reference__r.City__c, Company_Account__r.Primary_Address_Reference__r.District__c,Company_Account__r.createdDate,Company_Account__r.lastmodifieddate,
            Company_Account__r.Primary_Address_Reference__r.Block__c, Company_Account__r.Primary_Address_Reference__r.Address_Line_1__c,
            Company_Account__r.Primary_Address_Reference__r.Address_Line_2__c, Company_Account__r.Primary_Address_Reference__r.ZipCode__c,
            Company_Account__r.Primary_Address_Reference__r.CreatedDate, Company_Account__r.Primary_Address_Reference__r.LastModifiedDate,
            Company_Account__r.gender__c, Company_Account__r.Occupation__c,Company_Account__r.Primary_Phone__c, Company_Account__r.Industry, Company_Account__r.Preferred_Language__c,
            Company_Account__r.Special_Needs_Class__c, Company_Account__r.Allow_Data_Sharing2__c, Company_Account__r.Primary_Address_Reference__r.Address_Type__c,
            Company_Account__r.Primary_Address_Reference__r.Province__c, Company_Account__r.Preferred_Contact_Method__c,
            Company_Account__r.UCID__c,Company_Account__r.Salutation__c, Company_Account__r.RecordtypeId, Company_Account__r.Name, Company_Account__r.Company_Name_Native_1__c, Company_Account__r.Foundation_Date__c,Company_Account__r.Primary_Address_Reference__r.Foreign_Nationals__c,
            Company_Account__r.Website, Company_Account__r.Vat_No__c, Company_Account__r.DMS_Customer_ID__c, Company_Account__r.Complaint_Amount__c, Company_Account__r.Sales_Sanction__c, Company_Account__r.Allow_Data_Sharing__c, Company_Account__r.PersonEmail, Company_Account__r.PersonHasOptedOutOfEmail, Company_Account__r.PersonHasOptedOutOfFax, Company_Account__r.Primary_Phone_Display__c, Company_Account__r.PersonDoNotCall, Company_Account__r.Postal_Opt_Out__c, Company_Account__r.Job__c, Company_Account__r.Personal_Agreement__c, Company_Account__r.Personal_Information_Third_Party_Release__c, Company_Account__r.Personal_Abroad_Agreement__c, Company_Account__r.Agreement_to_commit_info_processing__c, Company_Account__r.Commercial_Reg_No__c, Company_Account__r.Company_Name__c, Company_Account__r.Visit_Opt_Out__c
            from Lead__c WHERE id IN: contactId];
        List < Account_Link__c > accLst = new List < Account_Link__c > ();

        for (Lead__c dealerLead: leadLst) {
            if (dealerLead.Assigned_Dealer__c != null)
                dealerId.add(dealerLead.Assigned_Dealer__c);
            if (dealerLead.Contact__c != null)
                AcclinkContactId.add(dealerLead.Contact__c);

        }

        List < Account_Link__c > dealercount = [select id from Account_Link__c WHERE fromRole__c IN: dealerId AND(toRole__c IN: AcclinkContactId OR toRole__c IN: CompanyId) AND(RecordTypeId =: alkCompanyRecordTypeId OR RecordTypeId =: alkpersonRecordTypeId) AND(Retail_Delete_Flag__c = false AND Retail_Duplicate_Flag__c = false)];
        system.debug('########' + dealercount);
        for (Lead__c led: leadlst) {
            if (led.Assigned_Dealer__c != null && (dealercount.isEmpty() || dealercount == null || dealercount.size() == 0)) {
                Account_Link__c acclnk = new Account_Link__c(RecordTypeId = alkContactSectorRecordTypeId, toRole__c = led.Contact__c, fromRole__c = led.Assigned_Dealer__c);
                accLst.add(acclnk);
                if (led.Contact__r.RecordTypeId == PersonRecordTypeId) {

                    acclnk = new Account_Link__c(RecordTypeId = alkpersonRecordTypeId, toRole__c = led.Contact__c, fromRole__c = led.Assigned_Dealer__c);
                    if (led.Contact__r.Primary_Address_Reference__c != null) {
                            acclnk.Retail_Province__c = led.Contact__r.Primary_Address_Reference__r.Province__c;
                            acclnk.Retail_City__c = led.Contact__r.Primary_Address_Reference__r.Sub_District__c;
                            acclnk.Retail_Distinct__c = led.Contact__r.Primary_Address_Reference__r.District__c;
                            
                                
                            acclnk.Retail_Address_Line_1__c = led.Contact__r.Primary_Address_Reference__r.Address_Line_1__c;
                            acclnk.Retail_Address_Line_2__c = led.Contact__r.Primary_Address_Reference__r.Address_Line_2__c;
                            acclnk.Retail_Address_Type__c = led.Contact__r.Primary_Address_Reference__r.Address_Type__c;
                            acclnk.Retail_ZipCode__c = led.Contact__r.Primary_Address_Reference__r.ZipCode__c;
                            acclnk.Retail_Address_CreatedDate__c = date.newinstance(led.Contact__r.Primary_Address_Reference__r.CreatedDate.year(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.month(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.day());

                            acclnk.Retail_Address_LastModifiedDate__c = date.newinstance(led.Contact__r.Primary_Address_Reference__r.Lastmodifieddate.year(), led.Contact__r.Primary_Address_Reference__r.Lastmodifieddate.month(), led.Contact__r.Primary_Address_Reference__r.Lastmodifieddate.day());
                            System.debug('**prprpr*'+acclnk.Retail_Address_CreatedDate__c + acclnk.Retail_Address_LastModifiedDate__c + date.newinstance(led.Contact__r.Primary_Address_Reference__r.CreatedDate.year(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.month(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.day()));
                        }
                        acclnk.Retail_Country__c = led.contact__r.country__c;
                        acclnk.Retail_Full_Name_Title__c = led.contact__r.Salutation__c + ' '+led.Contact__r.LastName + ' ' + led.Contact__r.FirstName;
                        acclnk.Retail_Salutation__c=led.Contact__r.Salutation__c;
                        acclnk.Retail_Special_Care__c=led.Contact__r.Special_Care__c;
                        acclnk.createddate__c = led.Contact__r.createdDate;
                        acclnk.Retail_ID_Type__c = led.Contact__r.ID_Type__c;
                        acclnk.Retail_ID_Number__c = led.Contact__r.ID_Number__c;
                        acclnk.LastModifiedDate__c = led.Contact__r.LastmodifiedDate;
                        acclnk.Retail_LastName_Native__c=led.Contact__r.LastName_Native_1__c;
                        acclnk.Retail_FirstName_Native__c = led.Contact__r.FirstName_Native_1__c;
                        acclnk.Retail_Primary_Phone__c =led.Contact__r.Primary_Phone__c;
                        acclnk.Retail_DMS_Customer_ID__c = led.Contact__r.DMS_Customer_ID__c;
                        acclnk.Retail_DMS_Customer_ID__c = led.Contact__r.DMS_Customer_ID__c;
                        acclnk.Retail_Full_Name__c = led.Contact__r.LastName + ' ' + led.Contact__r.FirstName;
                        acclnk.Retail_LastName__c = led.Contact__r.LastName;
                        acclnk.Retail_FirstName__c = led.Contact__r.FirstName;
                        acclnk.Retail_Complaint_Amount__c = led.Contact__r.Complaint_Amount__c;
                        acclnk.Retail_Sales_Sanction__c = led.Contact__r.Sales_Sanction__c;
                        acclnk.Retail_UCID__c = led.Contact__r.UCID__c;
                        acclnk.Retail_Allow_Data_Sharing__c = led.Contact__r.Allow_Data_Sharing__c;
                        acclnk.Retail_Mobile__c = led.Contact__r.Mobile__c;
                        acclnk.Retail_Individual_Home_Phone__c = led.Contact__r.Individual_Home_Phone__c;
                        acclnk.Retail_Work_Phone__c = led.Contact__r.Work_Phone__c;
                        acclnk.Retail_Email__c = led.Contact__r.PersonEmail;
                        acclnk.Retail_Fax__c = led.Contact__r.Fax;
                        acclnk.Retail_Preferred_Contact_Method__c = led.Contact__r.Preferred_Contact_Method__c;
                        acclnk.Retail_Email_OptOut__c = led.Contact__r.PersonHasOptedOutOfEmail;
                        acclnk.Retail_Fax_OptOut__c = led.Contact__r.PersonHasOptedOutOfFax;
                        //acclnk.Retail_Primary_Phone__c = led.Contact__r.Primary_Phone_Display__c;
                        acclnk.Retail_Phone_OptOut__c = led.Contact__r.PersonDoNotCall;
                        acclnk.Retail_Postal_OptOut__c = led.Contact__r.Postal_Opt_Out__c;
                        acclnk.Retail_Visit_OptOut__c = led.Contact__r.Visit_Opt_Out__c;
                        acclnk.Retail_PersonBirthdate__c = led.Contact__r.PersonBirthdate;
                        acclnk.Retail_Occupation__c = led.Contact__r.Occupation__c;
                        acclnk.Retail_Position__c = led.Contact__r.Job__c;
                        acclnk.Retail_Preferred_Language__c = 'Thai';
                        acclnk.Retail_Gender__c = led.Contact__r.Gender__c;
                        acclnk.Retail_Industry__c = led.Contact__r.industry;
                        acclnk.Retail_WebSite__c = led.Contact__r.Website;
                        acclnk.Retail_Company_Name_Native1__c = led.Contact__r.Company_Name_Native_1__c;
                        acclnk.Retail_Commercial_Reg_No__c = led.Contact__r.Commercial_Reg_No__c;
                        
                        acclnk.Retail_Agreement__c = led.Contact__r.Personal_Agreement__c;
                        acclnk.Retail_Information_Third_Party_Release__c = led.Contact__r.Personal_Information_Third_Party_Release__c;
                        acclnk.Retail_Abroad_Agreement__c = led.Contact__r.Personal_Abroad_Agreement__c;
                        acclnk.Retail_Agreement_Info_Processing__c = led.Contact__r.Agreement_to_commit_info_processing__c;
                        acclnk.Retail_Vat_No__c = led.Contact__r.Vat_No__c;
                } else if (led.Company_Account__r.RecordTypeId == AccountCompanyId) {
                    acclnk = new Account_Link__c(RecordTypeId = alkCompanyRecordTypeId, Name = led.Company_Account__r.UCID__c, toRole__c = led.Company_Account__c, fromRole__c = led.Assigned_Dealer__c);
                    if (led.Company_Account__r.Primary_Address_Reference__c != null) {
                            acclnk.Retail_Province__c = led.Company_Account__r.Primary_Address_Reference__r.Province__c;
                            acclnk.Retail_City__c = led.Company_Account__r.Primary_Address_Reference__r.Sub_District__c;
                            acclnk.Retail_Distinct__c = led.Company_Account__r.Primary_Address_Reference__r.District__c;
                            acclnk.Retail_Address_Line_1__c = led.Company_Account__r.Primary_Address_Reference__r.Address_Line_1__c;
                            acclnk.Retail_Address_Line_2__c = led.Company_Account__r.Primary_Address_Reference__r.Address_Line_2__c;
                            acclnk.Retail_Address_Type__c = led.Company_Account__r.Primary_Address_Reference__r.Address_Type__c;
                            acclnk.Retail_ZipCode__c = led.Company_Account__r.Primary_Address_Reference__r.ZipCode__c;
                            acclnk.Retail_Address_CreatedDate__c = date.newinstance(led.Company_Account__r.Primary_Address_Reference__r.CreatedDate.year(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.month(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.day());
                            //System.debug(date.newinstance(led.Contact__r.Primary_Address_Reference__r.CreatedDate.year(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.month(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.day()));
                            acclnk.Retail_Address_LastModifiedDate__c = date.newinstance(led.Company_Account__r.Primary_Address_Reference__r.Lastmodifieddate.year(), led.Contact__r.Primary_Address_Reference__r.Lastmodifieddate.month(), led.Contact__r.Primary_Address_Reference__r.Lastmodifieddate.day());
                        }
                        acclnk.Retail_Country__c = led.Company_Account__r.country__c;
                        acclnk.Retail_UCID__c = led.Company_Account__r.UCID__c;
                        acclnk.Retail_DMS_Customer_ID__c = led.Company_Account__r.DMS_Customer_ID__c;
                        acclnk.Retail_Company_Name__c = led.Company_Account__r.name;
                        acclnk.createddate__c = led.Company_Account__r.createdDate;
                        acclnk.LastModifiedDate__c = led.Company_Account__r.LastmodifiedDate;
                        acclnk.Retail_Company_Phone__c = led.Company_Account__r.Individual_Home_Phone__c;
                        acclnk.Retail_Company_Other_Phone__c = led.Company_Account__r.Work_Phone__c;
                        acclnk.Retail_Mobile__c = led.Company_Account__r.Mobile__c;
                        acclnk.Retail_Email_OptOut__c = led.Company_Account__r.PersonHasOptedOutOfEmail;
                        acclnk.Retail_Fax_OptOut__c = led.Company_Account__r.PersonHasOptedOutOfFax;
                        acclnk.Retail_Primary_Phone__c = led.Company_Account__r.Primary_Phone__c;
                        acclnk.Retail_Sales_Sanction__c = led.Company_Account__r.Sales_Sanction__c;
                        acclnk.Retail_Phone_OptOut__c = led.Company_Account__r.PersonDoNotCall;
                        acclnk.Retail_Postal_OptOut__c = led.Company_Account__r.Postal_Opt_Out__c;
                        acclnk.Retail_Visit_OptOut__c = led.Company_Account__r.Visit_Opt_Out__c;
                        acclnk.Retail_Fax__c = led.Company_Account__r.fax;
                        acclnk.Retail_Industry__c = led.Company_Account__r.Industry;
                        acclnk.Retail_Commercial_Reg_No__c = led.Company_Account__r.Commercial_Reg_No__c;
                        acclnk.Retail_Vat_No__c = led.Company_Account__r.Vat_No__c;
                        acclnk.Retail_WebSite__c = led.Company_Account__r.Website;
                        acclnk.Retail_Agreement__c = led.Company_Account__r.Personal_Agreement__c;
                        acclnk.Retail_Information_Third_Party_Release__c = led.Company_Account__r.Personal_Information_Third_Party_Release__c;
                        acclnk.Retail_Abroad_Agreement__c = led.Company_Account__r.Personal_Abroad_Agreement__c;
                        acclnk.Retail_Agreement_Info_Processing__c = led.Company_Account__r.Agreement_to_commit_info_processing__c;
                }
                if(led.MD__c == Label.MarketMY){
                    acclnk.Retail_Country__c = 'Malaysia';
                }       
 
                if (led.Contact__r.Primary_Address_Reference__c != null) {
                    acclnk.Retail_Address_Reference__c = led.Contact__r.Primary_Address_Reference__c;

                }
                else if(led.Company_Account__r.Primary_Address_Reference__c != null) {
                   acclnk.Retail_Address_Reference__c = led.Company_Account__r.Primary_Address_Reference__c;
                    
                }
                accLst.add(acclnk);
            }
        }
       
        if (!accLst.isEmpty()) {
            insert accLst;

            Database.SaveResult[] srList = Database.insert(accLst, false);
            for (Database.SaveResult sr: srList) {
                if (sr.isSuccess()) {
                    {
                        actlnkids.add(sr.getid());
                    }

                }
            }

            Account_link__c acclink = new Account_link__c();
            if (!actlnkids.isEmpty()) {
             
                if (contactId != null && actlnkids != null) {
                  acclink = [select id,Name, RecordType.DeveloperName from Account_Link__c WHERE id IN: actlnkids  AND (RecordTypeId=:alkCompanyRecordTypeId  OR RecordTypeId =:alkpersonRecordTypeId ) limit 1];
                   if(acclink !=null)
                  {
                    for (Account_link__c al: accLst) {
                        for (Lead__c ld: leadLst) {
                            if(al.RecordTypeId == alkpersonRecordTypeId)
                            ld.Retail_Contact__c = al.id;
                            else if(al.RecordTypeId == alkCompanyRecordTypeId)
                            ld.Retail_Company__c = al.id;
                            leadupdate.put(ld.id, ld);
                        }
                    }
                }
            }
        }

        Set < string > leadrecId = new set < string > ();
        Set < string > accountlnkid = new set < string > ();
        for (Lead__c leds: leadlst) {
            if (leds.Assigned_Dealer__c != null && dealercount.size() == 1) {
                for (Account_Link__c alk: dealercount) {
                    accountlnkid.add(alk.id);
                    leadrecId.add(leds.id);
                    if (accountlnkid != null && leadrecId != null) {
                        leds.Retail_Contact__c = alk.id;
                        leadupdate.put(leds.id, leds);
                    }
                }
            }
        }
  if (LeadUtil.createAccountLinkRecord) {
            
            if (leadupdate != null && leadupdate.Size() > 0) {
                LeadUtil.createAccountLinkRecord = false;
                Update leadupdate.Values();
 }
    
    }
 
       }
}
}