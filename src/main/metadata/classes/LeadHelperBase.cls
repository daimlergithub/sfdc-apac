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
		List<Lead__c> ldowner = new List<Lead__c>();
        Set<ID> sConid = new Set<ID>();
        Map<ID,ID> mConToUsr = new Map<ID,ID>();
        for(Lead__c ld : leads){
            if(Ld.Sales_Consultant__c != NULL && (ld.RecordTypeId==salesRecordTypeId)){
                sConid.add(ld.Sales_Consultant__c);
            }
        }
        sConid.remove(NULL);
        for(User usr : [Select id, contactID from user where contactID in :sConid]){
            mConToUsr.put(usr.contactID, usr.ID);
        }
		
		
        for(Lead__c l : leads){
			if((l.RecordTypeId==salesRecordTypeId || l.RecordTypeId==afterSalesRecordTypeId || l.RecordTypeId==retailSalesRecordTypeId) && l.md__c==Market){               
				Boolean checkSAS= true;
				if((string.isnotblank(l.assigned_dealer__c))){
					if (userInfo.getUserType() != 'PowerPartner' ) {
						l.Assigned_Date_Time__c = System.now();
						l.CAC_Lead_Status__c = 'Assigned';
					}
						
				}				
				if(string.isnotblank(l.Sales_Consultant__c) && l.RecordTypeId==salesRecordTypeId && string.isnotblank(l.assigned_dealer__c)){
					l.ownerID = mConToUsr.get(L.Sales_Consultant__c);
					checkSas=false;
																			
				}
				else if(string.isnotblank(l.Service_Advisor__c) && l.RecordTypeId==afterSalesRecordTypeId && string.isnotblank(l.assigned_dealer__c)){
					l.ownerID = L.Service_Advisor__c;
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
		List<Lead__c> ldowner = new List<Lead__c>();
        Set<ID> sConid = new Set<ID>();
        Map<ID,ID> mConToUsr = new Map<ID,ID>();
        for(Lead__c ld : leads){
								
            if(((Lead__c)Trigger.newMap.get(ld.id)).Sales_Consultant__c != NULL && ld.RecordTypeId==salesRecordTypeId){
                sConid.add(((Lead__c)Trigger.newMap.get(ld.id)).Sales_Consultant__c);
				}
			 }
        sConid.remove(NULL);
		if(sConid.size()>0){
			for(User usr : [Select id, contactID from user where contactID in :sConid]){
				mConToUsr.put(usr.contactID, usr.ID);
			}														  
		}
        for(Lead__c l : leads){
			if(l.RecordTypeId==salesRecordTypeId || l.RecordTypeId==afterSalesRecordTypeId || l.RecordTypeId==retailSalesRecordTypeId){
			if((((Lead__c)Trigger.newMap.get(l.id)).assigned_dealer__c != ((Lead__c)Trigger.oldMap.get(l.id)).assigned_dealer__c && ((Lead__c)Trigger.newMap.get(l.id)).assigned_dealer__c != NULL)){
                if (userInfo.getUserType() != 'PowerPartner' ) {
					l.Assigned_Date_Time__c = System.now();
					l.CAC_Lead_Status__c = 'Assigned';
				}
                //ldowner.add(l);
            }
            if(((Lead__c)Trigger.newMap.get(l.id)).Sales_Consultant__c !=((Lead__c)Trigger.oldMap.get(l.id)).Sales_Consultant__c && ((Lead__c)Trigger.newMap.get(l.id)).Sales_Consultant__c != NULL  && (l.RecordTypeId==salesRecordTypeId) && ((Lead__c)Trigger.newMap.get(l.id)).assigned_dealer__c != NULL) {
                l.ownerID = mConToUsr.get(((Lead__c)Trigger.newMap.get(l.id)).Sales_Consultant__c);
            }
            else if(((Lead__c)Trigger.newMap.get(l.id)).Service_Advisor__c !=((Lead__c)Trigger.oldMap.get(l.id)).Service_Advisor__c && ((Lead__c)Trigger.newMap.get(l.id)).Service_Advisor__c != NULL  && ( l.RecordTypeId==afterSalesRecordTypeId) && ((Lead__c)Trigger.newMap.get(l.id)).assigned_dealer__c != NULL){
                l.ownerID = ((Lead__c)Trigger.newMap.get(l.id)).Service_Advisor__c;
            }
            
            else if((((Lead__c)Trigger.newMap.get(l.id)).assigned_dealer__c != ((Lead__c)Trigger.oldMap.get(l.id)).assigned_dealer__c && ((Lead__c)Trigger.newMap.get(l.id)).assigned_dealer__c != NULL)){
                ldowner.add(l);
				accId.add(l.assigned_dealer__c); 
            }
			else if((((Lead__c)Trigger.newMap.get(l.id)).assigned_dealer__c ==null && ((Lead__c)Trigger.oldMap.get(l.id)).assigned_dealer__c !=null)){
				l.ownerId=l.createdbyId;
				l.Assigned_Date_Time__c = NULL;
                l.CAC_Lead_Status__c = 'New';
			}
        }
        if(!ldowner.isEmpty() && userInfo.getUserType() != 'PowerPartner' ){
	
            if(accId.size()>0){
                updateOwnership(accId,ldowner,market);
            }
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
    public Static void updateOwnership(set<id> acc, List<Lead__c> leadlist, string Market){
        Map<id, id> accUserMap = new Map<id, id>();
        if(acc.size()>0){
            accUserMap = getAccountToDLGKUser(acc);
        }
        for(Lead__c lists:leadlist){
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
    
    //Call informatica web service
    //Mohammed Touseef Ahmed
    //01-19-18
    public void CdmLeadcreate(List < Lead__c > leadlist, map < id, Lead__c > leadOldMap,string market) {
        Set < Id > LeadIdinsert = new Set < Id > ();
        Set < Id > LeadIdupdate = new Set < Id > ();
        Map < Id, Lead__c > ldmap = new Map < Id, Lead__c > ([select id, Contact__r.Ucid__c, Retail_Contact__r.Retail_DMS_Customer_ID__c, Assigned_Dealer__c from Lead__c where id in: leadOldMap.keyset()]);
        for (Lead__c le: leadlist) {
            if (ldmap.containskey(le.Id)) {
                if (ldmap.get(le.Id).Contact__r.Ucid__c != '' && ldmap.get(le.Id).Retail_Contact__r.Retail_DMS_Customer_ID__c != '' && le.Assigned_Dealer__c != null && le.Assigned_Dealer__c == leadOldMap.get(le.id).Assigned_Dealer__c && le.MD__c == market && le.CAC_Lead_Status__c != leadOldMap.get(le.id).CAC_Lead_Status__c && le.CAC_Lead_Status__c == 'Accepted') {

                    LeadIdinsert.add(le.Id);
                }
            }
        }
        if (LeadIdinsert.size() > 0)
            //call informatica service
            CDMInformatica_Services.createLead(LeadIdinsert, 'MY', 'insert');

    }    
	    //Added by Asish Nanda to get a dynamic Url in Email For Dealer Gate Keeper to login to Malaysia Dealer Community  
    
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
    // Added by Asish Nanda to get a dynamic Url in Email For Dealer Gate Keeper to login to Malaysia Dealer Community  
    public static void updatecommunityurl(List<Lead__c> Leadlist, String Market){
    String commURLMY=getCommunityURL();
    for(Lead__c le:Leadlist){
        if(le.md__c == Market)
        le.Others__c = commURLMY;
    }
    
	}   
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
        List < Lead__c > leadlisttoiterat = [select id, createdby.usertype, createdby.Dealer_nd_code__c, assigned_dealer__c, assigned_dealer__r.Dealer_nd_code__c,assigned_dealer__r.MD__c,createdby.Market__c,MD__c from Lead__C where id IN: leadlist];
        
        //below if part will work at the time of insert
        for (Lead__c leadsrec: leadlisttoiterat) {
            if (!flag) {
                //if created by is Dealer then share those records with under that Dealer depends on dealer nd code
                if (leadsrec.createdby.usertype == 'PowerPartner' && leadsrec.createdby.Dealer_nd_code__c != null) {
                    //dealerndcodeset.add(leadsrec.createdby.Dealer_nd_code__c);
					string GrpName=leadsrec.createdby.Market__c+leadsrec.createdby.Dealer_nd_code__c;
					//dealerndcodeset.add(leadsrec.createdby.Dealer_nd_code__c);
					dealerndcodeset.add(GrpName);
                    lstlead.add(leadsrec);
                } else if (leadsrec.assigned_dealer__c != null && leadsrec.assigned_dealer__r.Dealer_nd_code__c != null) {
					string GrpName=leadsrec.assigned_dealer__r.MD__c+leadsrec.assigned_dealer__r.Dealer_nd_code__c;
                    //dealerndcodeset.add(leadsrec.assigned_dealer__r.Dealer_nd_code__c);
					dealerndcodeset.add(GrpName);
                    lstlead.add(leadsrec);
                }
            } else {
              
                //if trigger new map value is filled and  oldmap assigned dealer is null then share records with new assigned value
                if (((Lead__c) trigger.newmap.get(leadsrec.id)).assigned_dealer__c != null && ((Lead__c) trigger.oldMap.get(leadsrec.id)).assigned_dealer__c == null && leadsrec.assigned_dealer__r.Dealer_nd_code__c != null) {
                    //dealerndcodeset.add(leadsrec.assigned_dealer__r.Dealer_nd_code__c);
					string GrpName=leadsrec.assigned_dealer__r.MD__c+leadsrec.assigned_dealer__r.Dealer_nd_code__c;
					dealerndcodeset.add(GrpName);
                    lstlead.add(leadsrec);
                }
                //if trigger old is not equal to trigger new  then give access to new dealer and then revoke access from old dealer
                else if (((Lead__c) trigger.newmap.get(leadsrec.id)).assigned_dealer__c != null && ((Lead__c) trigger.oldMap.get(leadsrec.id)).assigned_dealer__c != null && ((Lead__c) trigger.newmap.get(leadsrec.id)).assigned_dealer__c != ((Lead__c) trigger.oldmap.get(leadsrec.id)).assigned_dealer__c && leadsrec.assigned_dealer__r.Dealer_nd_code__c != null) {
                   string GrpName=leadsrec.assigned_dealer__r.MD__c+leadsrec.assigned_dealer__r.Dealer_nd_code__c;
				   //dealerndcodeset.add(leadsrec.assigned_dealer__r.Dealer_nd_code__c);
				   dealerndcodeset.add(GrpName);
                    lstlead.add(leadsrec);
                    //will revoke record access depends on dealer nd code  if we change the assigned dealer
                    if (((Lead__c) trigger.newmap.get(leadsrec.id)).assigned_dealer__r.Dealer_nd_code__c != null) {
                        sharingrevokefromgroups.add(((Lead__c) trigger.oldmap.get(leadsrec.id)).MD__c+((Lead__c) trigger.oldmap.get(leadsrec.id)).assigned_dealer__r.Dealer_nd_code__c);
                        leadsharingtorevoke.add(((Lead__c) trigger.oldmap.get(leadsrec.id)).id);
                    }
                }
                //if trigger old value is filled and new value did not filled then revoke access from old Dealer
                else if (((Lead__c) trigger.oldmap.get(leadsrec.id)).assigned_dealer__c != null && ((Lead__c) trigger.newmap.get(leadsrec.id)).assigned_dealer__c == null) {
                    sharingrevokefromgroups.add(leadsrec.MD__c+((Lead__c) trigger.oldmap.get(leadsrec.id)).assigned_dealer__r.Dealer_nd_code__c);
                    leadsharingtorevoke.add(((Lead__c) trigger.oldmap.get(leadsrec.id)).id);
                }
                /*
                Added by Asish Nanda  
                Test Case- If CAC_Lead_Status__c will be Set to Purchased, Then Lead record will be Shared with Other Dealers , those who belong to Dealer_nd_code__c
                
                else if(((Lead__c)Trigger.newMap.get(leadsrec.id)).CAC_Lead_Status__c != ((Lead__c)Trigger.oldMap.get(leadsrec.id)).CAC_Lead_Status__c && ((Lead__c)Trigger.newMap.get(leadsrec.id)).CAC_Lead_Status__c == 'Purchased'){
                    sharingrevokefromgroups.add(((Lead__c) trigger.oldmap.get(leadsrec.id)).assigned_dealer__r.Dealer_nd_code__c);
                    leadsharingtorevoke.add(((Lead__c) trigger.oldmap.get(leadsrec.id)).id);
                }*/
            }
        }
        for (Group gp: [select id, name from Group where name IN: dealerndcodeset]) {
            for (Lead__C leadid: lstlead) {
                //this if part will applicable for Salesforce users
				string grpname=(leadid.MD__c+leadid.assigned_dealer__r.Dealer_nd_code__c);
				string grpCname=(leadid.createdby.Market__c+leadid.createdby.Dealer_nd_code__c );
                if (gp.name == grpname) {
                    leadshare.add(new Lead__Share(parentid = leadid.id, UserOrGroupId = gp.id, RowCause = Schema.Lead__share.Rowcause.manual, AccessLevel = 'EDIT'));
                } //this else part will applicable for Dealer users
                else if (gp.name == grpCname && leadid.createdby.Usertype == 'PowerPartner') {
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
    Test Case : A retail Copy (Reatil Person/ Retail Company)Will be validated if existing will be updated, a dealer will be assigned to Lead 
    */
	 public static void CheckRetailCopy(List < Lead__c > leadlist, map < id, Lead__c > leadOldMap, boolean isInsert, boolean isUpdate,string market) {
		set < String > contactId = new set < String > ();
		set < String > actlnkids = new set < String > ();
        set < String > dealerId = new set < String > ();
        set < String > AcclinkContactId = new set < String > ();
        set < String > CompanyId = new set < String > ();
		for (Lead__c dealerLead: leadlist) {
			
				if (string.isnotblank(dealerLead.Assigned_Dealer__c) && ((string.isnotblank(dealerLead.Contact__c )) || string.isnotblank(dealerLead.Company_Account__c))){
					dealerId.add(dealerLead.Assigned_Dealer__c);
					contactId.add(dealerlead.id);
				}
				
				if (string.isnotblank(dealerLead.Contact__c ))
					AcclinkContactId.add(dealerLead.Contact__c);
				
				if(string.isnotblank(dealerLead.Company_Account__c))
					CompanyId.add(dealerLead.Company_Account__c);
			
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
	
	/*
    Added by : Asish Nanda
    Test Case : A retail Copy (Reatil Person/ Retail Company)Will be Created in Dealer account automatically , if a dealer will be assigned to Lead 
    */
       public static void createAccountLinkRecord(set < String > contactId,string Market, Map<string,Id> existingRC, boolean isInsert, boolean isUpdate, map < id, Lead__c > leadOldMap) {
        LeadUtil.leadAccountlnktrigger = false;
        set < String > actlnkids = new set < String > ();
        set < String > dealerId = new set < String > ();
        set < String > AcclinkContactId = new set < String > ();
        set < String > CompanyId = new set < String > ();
        Map < Id, Lead__c > leadupdate = new Map < Id, Lead__C > ();
        List < Lead__c > leadLst = [select Id, Retail_Contact__c, Company_Account__c, Contact__c, Assigned_Dealer__c, Contact__r.LastName, Contact__r.FirstName, Contact__r.LastName_Native_1__c,Contact__r.ID_Type__c,Contact__r.ID_Number__c,contact__r.country__c,
            Contact__r.FirstName_Native_1__c, Contact__r.PersonBirthdate, Contact__r.Special_Care__c, Contact__r.Individual_Home_Phone__c, Contact__r.Work_Phone__c, Contact__r.Primary_Address_Reference__r.Sub_District__c,
            Contact__r.Mobile__c, Contact__r.Fax, Contact__r.Email__c, Contact__r.Primary_Address_Reference__r.City__c, Contact__r.Primary_Address_Reference__r.District__c,Contact__r.createdDate,Contact__r.lastmodifieddate,
            Contact__r.Primary_Address_Reference__r.Block__c, Contact__r.Primary_Address_Reference__r.Address_Line_1__c,contact__r.preferred_language__c,
            Contact__r.Primary_Address_Reference__r.Address_Line_2__c, Contact__r.Primary_Address_Reference__r.ZipCode__c,Contact__r.Primary_Address_Reference__r.Address_Line_3__c,
            Contact__r.Primary_Address_Reference__r.CreatedDate, Contact__r.Primary_Address_Reference__r.LastModifiedDate,Contact__r.Title__c,
            Contact__r.gender__c, contact__r.Occupation__c,Contact__r.Primary_Phone__c, Contact__r.Industry, 
            Contact__r.Special_Needs_Class__c, Contact__r.Allow_Data_Sharing2__c, Contact__r.Primary_Address_Reference__r.Address_Type__c,
            Contact__r.Primary_Address_Reference__r.Province__c, Contact__r.Preferred_Contact_Method__c, MD__c,
            Contact__r.UCID__c,Contact__r.Salutation__c, Contact__r.RecordtypeId, Contact__r.Name, Contact__r.Company_Name_Native_1__c, Contact__r.Foundation_Date__c,Contact__r.Primary_Address_Reference__r.Foreign_Nationals__c,
            Contact__r.Website, Contact__r.Vat_No__c, Contact__r.DMS_Customer_ID__c, Contact__r.Complaint_Amount__c, Contact__r.Sales_Sanction__c, Contact__r.Allow_Data_Sharing__c, Contact__r.PersonEmail, Contact__r.PersonHasOptedOutOfEmail, Contact__r.PersonHasOptedOutOfFax, Contact__r.Primary_Phone_Display__c, Contact__r.PersonDoNotCall, Contact__r.Postal_Opt_Out__c, Contact__r.Job__c, Contact__r.Personal_Agreement__c, Contact__r.Personal_Information_Third_Party_Release__c, Contact__r.Personal_Abroad_Agreement__c, Contact__r.Agreement_to_commit_info_processing__c, Contact__r.Commercial_Reg_No__c, Contact__r.Company_Name__c, Contact__r.Visit_Opt_Out__c, Company_Account__r.FirstName, Company_Account__r.LastName_Native_1__c,Company_Account__r.ID_Type__c,Company_Account__r.ID_Number__c,Company_Account__r.country__c,
            Company_Account__r.FirstName_Native_1__c, Company_Account__r.PersonBirthdate, Company_Account__r.Special_Care__c, Company_Account__r.Individual_Home_Phone__c, Company_Account__r.Work_Phone__c, Company_Account__r.Primary_Address_Reference__r.Sub_District__c,
            Company_Account__r.Mobile__c, Company_Account__r.Fax, Company_Account__r.Email__c, Company_Account__r.Primary_Address_Reference__r.City__c, Company_Account__r.Primary_Address_Reference__r.District__c,Company_Account__r.createdDate,Company_Account__r.lastmodifieddate,
            Company_Account__r.Primary_Address_Reference__r.Block__c, Company_Account__r.Primary_Address_Reference__r.Address_Line_1__c,Company_Account__r.Primary_Address_Reference__r.Address_Line_3__c,
            Company_Account__r.Primary_Address_Reference__r.Address_Line_2__c, Company_Account__r.Primary_Address_Reference__r.ZipCode__c,
            Company_Account__r.Primary_Address_Reference__r.CreatedDate, Company_Account__r.Primary_Address_Reference__r.LastModifiedDate,
            Company_Account__r.gender__c, Company_Account__r.Occupation__c,Company_Account__r.Primary_Phone__c, Company_Account__r.Industry, Company_Account__r.Preferred_Language__c,
            Company_Account__r.Special_Needs_Class__c, Company_Account__r.Allow_Data_Sharing2__c, Company_Account__r.Primary_Address_Reference__r.Address_Type__c,
            Company_Account__r.Primary_Address_Reference__r.Province__c, Company_Account__r.Preferred_Contact_Method__c,
            Company_Account__r.UCID__c,Company_Account__r.Salutation__c, Company_Account__r.RecordtypeId, Company_Account__r.Name, Company_Account__r.Company_Name_Native_1__c, Company_Account__r.Foundation_Date__c,Company_Account__r.Primary_Address_Reference__r.Foreign_Nationals__c,
            Company_Account__r.Website, Company_Account__r.Vat_No__c, Company_Account__r.DMS_Customer_ID__c, Company_Account__r.Complaint_Amount__c, Company_Account__r.Sales_Sanction__c, Company_Account__r.Allow_Data_Sharing__c, Company_Account__r.PersonEmail, Company_Account__r.PersonHasOptedOutOfEmail, Company_Account__r.PersonHasOptedOutOfFax, Company_Account__r.Primary_Phone_Display__c, Company_Account__r.PersonDoNotCall, Company_Account__r.Postal_Opt_Out__c, Company_Account__r.Job__c, Company_Account__r.Personal_Agreement__c, Company_Account__r.Personal_Information_Third_Party_Release__c, Company_Account__r.Personal_Abroad_Agreement__c, Company_Account__r.Agreement_to_commit_info_processing__c, Company_Account__r.Commercial_Reg_No__c, Company_Account__r.Company_Name__c, Company_Account__r.Visit_Opt_Out__c,Assigned_Dealer__r.Dealer_Rollout_Status__c
            from Lead__c WHERE id IN: contactId];
			
        List < Account_Link__c > accLst = new List < Account_Link__c > ();

        for (Lead__c dealerLead: leadLst) {
            if (dealerLead.Assigned_Dealer__c != null)
                dealerId.add(dealerLead.Assigned_Dealer__c);
            if (string.isnotblank(dealerLead.Contact__c ) && (!existingRC.containskey(string.valueof(dealerLead.Assigned_Dealer__c)+string.valueof(dealerLead.Contact__c))))
                AcclinkContactId.add(dealerLead.Contact__c);
			if(string.isnotblank(dealerLead.Company_Account__c) && (!existingRC.containskey(string.valueof(dealerLead.Assigned_Dealer__c)+string.valueof(dealerLead.Company_Account__c)))){
				CompanyId.add(dealerLead.Company_Account__c);
			}
        }

       /* List < Account_Link__c > dealercount = new List<Account_link__c>();
		dealerCount=[select id,fromRole__c,toRole__c from Account_Link__c WHERE fromRole__c IN: dealerId AND(toRole__c IN: AcclinkContactId OR toRole__c IN: CompanyId) AND(RecordTypeId =: alkCompanyRecordTypeId OR RecordTypeId =: alkpersonRecordTypeId) AND(Retail_Delete_Flag__c = false AND Retail_Duplicate_Flag__c = false)];
        set<string> CombinedId= new set<string>();
		for(account_link__c accLink: dealerCount){
				if(string.isnotblank(acclink.fromRole__c) && string.isnotblank(acclink.toRole__c))
					CombinedId=acclink.fromRole__c+acclink.toRole__c;
		}
		*/
        for (Lead__c led: leadlst) {
            if (led.Assigned_Dealer__c != null && String.isnotblank(led.Assigned_Dealer__r.Dealer_Rollout_Status__c)?(led.Assigned_Dealer__r.Dealer_Rollout_Status__c=='Done'):false) {
                Account_Link__c acclnk = new Account_Link__c();
				Account_Link__c cacclnk = new Account_Link__c();
                if (led.Contact__r.RecordTypeId == PersonRecordTypeId && (!existingRC.containskey(string.valueof(led.Assigned_Dealer__c)+string.valueof(led.Contact__c)))) {

                    acclnk = new Account_Link__c(RecordTypeId = alkpersonRecordTypeId, toRole__c = led.Contact__c, fromRole__c = led.Assigned_Dealer__c);
                    if (led.Contact__r.Primary_Address_Reference__c != null) {
                            acclnk.Retail_Province__c = led.Contact__r.Primary_Address_Reference__r.Province__c;
                            acclnk.Retail_City__c = led.Contact__r.Primary_Address_Reference__r.District__c;
                            acclnk.Retail_Distinct__c = led.Contact__r.Primary_Address_Reference__r.Sub_District__c;
                            acclnk.Retail_Address_Line_1__c = led.Contact__r.Primary_Address_Reference__r.Address_Line_1__c;
                            acclnk.Retail_Address_Line_2__c = led.Contact__r.Primary_Address_Reference__r.Address_Line_2__c;
							acclnk.Retail_Address_Line_3__c = led.Contact__r.Primary_Address_Reference__r.Address_Line_3__c;
                            acclnk.Retail_Address_Type__c = led.Contact__r.Primary_Address_Reference__r.Address_Type__c;
                            acclnk.Retail_ZipCode__c = led.Contact__r.Primary_Address_Reference__r.ZipCode__c;
                            acclnk.Retail_Address_CreatedDate__c = date.newinstance(led.Contact__r.Primary_Address_Reference__r.CreatedDate.year(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.month(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.day());
							acclnk.Retail_Address_LastModifiedDate__c = date.newinstance(led.Contact__r.Primary_Address_Reference__r.Lastmodifieddate.year(), led.Contact__r.Primary_Address_Reference__r.Lastmodifieddate.month(), led.Contact__r.Primary_Address_Reference__r.Lastmodifieddate.day());
                          
                        }
                        acclnk.Retail_Country__c = led.contact__r.country__c;
                        acclnk.Retail_Full_Name_Title__c = led.contact__r.Title__c +' '+led.Contact__r.LastName + ' ' + led.Contact__r.FirstName;
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
                        acclnk.Retail_Preferred_Language__c = led.contact__r.preferred_language__c;
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
						if (led.Contact__r.Foundation_Date__c != null)
                            acclnk.Retail_Foundation_Month__c = String.valueOf(led.Contact__r.Foundation_Date__c.year()) + (String.ValueOf(led.Contact__r.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(led.Contact__r.Foundation_Date__c.month())) : String.ValueOf(led.Contact__r.Foundation_Date__c.month())) + (String.ValueOf(led.Contact__r.Foundation_Date__c.day()).length() == 1 ? ('0' + String.ValueOf(led.Contact__r.Foundation_Date__c.day())) : String.ValueOf(led.Contact__r.Foundation_Date__c.day()));
                    
						if (led.Contact__r.Primary_Address_Reference__c != null) {
							acclnk.Retail_Address_Reference__c = led.Contact__r.Primary_Address_Reference__c;

						}
						accLst.add(acclnk);
                } 
				if (led.Company_Account__r.RecordTypeId == AccountCompanyId && (!existingRC.containskey(string.valueof(led.Assigned_Dealer__c)+string.valueof(led.Company_Account__c)))) {
                    cacclnk = new Account_Link__c(RecordTypeId = alkCompanyRecordTypeId, Name = led.Company_Account__r.UCID__c, toRole__c = led.Company_Account__c, fromRole__c = led.Assigned_Dealer__c);
                    if (led.Company_Account__r.Primary_Address_Reference__c != null) {
                            cacclnk.Retail_Province__c = led.Company_Account__r.Primary_Address_Reference__r.Province__c;
                            cacclnk.Retail_City__c = led.Company_Account__r.Primary_Address_Reference__r.Sub_District__c;
                            cacclnk.Retail_Distinct__c = led.Company_Account__r.Primary_Address_Reference__r.District__c;
                            cacclnk.Retail_Address_Line_1__c = led.Company_Account__r.Primary_Address_Reference__r.Address_Line_1__c;
                            cacclnk.Retail_Address_Line_2__c = led.Company_Account__r.Primary_Address_Reference__r.Address_Line_2__c;
							cacclnk.Retail_Address_Line_3__c = led.Company_Account__r.Primary_Address_Reference__r.Address_Line_3__c;
                            cacclnk.Retail_Address_Type__c = led.Company_Account__r.Primary_Address_Reference__r.Address_Type__c;
                            cacclnk.Retail_ZipCode__c = led.Company_Account__r.Primary_Address_Reference__r.ZipCode__c;
                            cacclnk.Retail_Address_CreatedDate__c = date.newinstance(led.Company_Account__r.Primary_Address_Reference__r.CreatedDate.year(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.month(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.day());
                            //System.debug(date.newinstance(led.Contact__r.Primary_Address_Reference__r.CreatedDate.year(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.month(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.day()));
                            cacclnk.Retail_Address_LastModifiedDate__c = date.newinstance(led.Company_Account__r.Primary_Address_Reference__r.Lastmodifieddate.year(), led.Contact__r.Primary_Address_Reference__r.Lastmodifieddate.month(), led.Contact__r.Primary_Address_Reference__r.Lastmodifieddate.day());
                        }
                        cacclnk.Retail_Country__c = led.Company_Account__r.country__c;
                        cacclnk.Retail_UCID__c = led.Company_Account__r.UCID__c;
                        cacclnk.Retail_DMS_Customer_ID__c = led.Company_Account__r.DMS_Customer_ID__c;
                        cacclnk.Retail_Company_Name__c = led.Company_Account__r.name;
                        cacclnk.createddate__c = led.Company_Account__r.createdDate;
                        cacclnk.LastModifiedDate__c = led.Company_Account__r.LastmodifiedDate;
                        cacclnk.Retail_Company_Phone__c = led.Company_Account__r.Individual_Home_Phone__c;
                        cacclnk.Retail_Company_Other_Phone__c = led.Company_Account__r.Work_Phone__c;
                        cacclnk.Retail_Mobile__c = led.Company_Account__r.Mobile__c;
                        cacclnk.Retail_Email_OptOut__c = led.Company_Account__r.PersonHasOptedOutOfEmail;
                        cacclnk.Retail_Fax_OptOut__c = led.Company_Account__r.PersonHasOptedOutOfFax;
                        cacclnk.Retail_Primary_Phone__c = led.Company_Account__r.Primary_Phone__c;
                        cacclnk.Retail_Sales_Sanction__c = led.Company_Account__r.Sales_Sanction__c;
                        cacclnk.Retail_Phone_OptOut__c = led.Company_Account__r.PersonDoNotCall;
                        cacclnk.Retail_Postal_OptOut__c = led.Company_Account__r.Postal_Opt_Out__c;
                        cacclnk.Retail_Visit_OptOut__c = led.Company_Account__r.Visit_Opt_Out__c;
                        cacclnk.Retail_Fax__c = led.Company_Account__r.fax;
                        cacclnk.Retail_Industry__c = led.Company_Account__r.Industry;
                        cacclnk.Retail_Commercial_Reg_No__c = led.Company_Account__r.Commercial_Reg_No__c;
                        cacclnk.Retail_Vat_No__c = led.Company_Account__r.Vat_No__c;
                        cacclnk.Retail_WebSite__c = led.Company_Account__r.Website;
                        cacclnk.Retail_Agreement__c = led.Company_Account__r.Personal_Agreement__c;
                        cacclnk.Retail_Information_Third_Party_Release__c = led.Company_Account__r.Personal_Information_Third_Party_Release__c;
                        cacclnk.Retail_Abroad_Agreement__c = led.Company_Account__r.Personal_Abroad_Agreement__c;
                        cacclnk.Retail_Agreement_Info_Processing__c = led.Company_Account__r.Agreement_to_commit_info_processing__c;
						cacclnk.Retail_Country__c = led.Company_Account__r.country__c;
						if (led.Company_Account__r.Foundation_Date__c != null)
                            cacclnk.Retail_Foundation_Month__c = String.valueOf(led.Company_Account__r.Foundation_Date__c.year()) + (String.ValueOf(led.Company_Account__r.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(led.Company_Account__r.Foundation_Date__c.month())) : String.ValueOf(led.Company_Account__r.Foundation_Date__c.month())) + (String.ValueOf(led.Company_Account__r.Foundation_Date__c.day()).length() == 1 ? ('0' + String.ValueOf(led.Company_Account__r.Foundation_Date__c.day())) : String.ValueOf(led.Company_Account__r.Foundation_Date__c.day()));
                    
						if(led.Company_Account__r.Primary_Address_Reference__c != null) {
						   cacclnk.Retail_Address_Reference__c = led.Company_Account__r.Primary_Address_Reference__c;							
						}
                       accLst.add(cacclnk);         
                } 
            }
        }
       
        if (!accLst.isEmpty()) {
            //insert accLst;

            Database.SaveResult[] srList = Database.insert(accLst, false);
			Integer i=0;
            for (Database.SaveResult sr: srList) {
                if (sr.isSuccess()) {
                    {
						if(!existingRC.containskey(string.valueof(accLst[i].fromRole__c)+string.valueof(acclst[i].torole__c))){
						existingRC.put(string.valueof(accLst[i].fromRole__c)+string.valueof(acclst[i].torole__c),sr.getid())	;
						}
					   actlnkids.add(sr.getid());
					   
						
                    }

                }
				i++;
            }
		}
		/*
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
*/
        Set < string > leadrecId = new set < string > ();
        Set < string > accountlnkid = new set < string > ();
		
		for (Lead__c le: leadlst) {
            if (string.isnotblank(le.Assigned_Dealer__c) && le.MD__c== Market) {
                if ( (isInsert && string.isnotblank(le.Assigned_Dealer__c))|| (isUpdate && le.Assigned_Dealer__c != leadOldMap.get(le.id).Assigned_Dealer__c)) {
					
					if(string.isnotblank(le.contact__c)?existingRC.containskey(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.contact__c)):False){
						le.Retail_Contact__c=existingRC.get(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.contact__c));
						
					}
					
					if(string.isnotblank(le.Company_Account__c)?existingRC.containskey(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.Company_Account__c)):False){
						le.Retail_Company__c=existingRC.get(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.Company_Account__c));
					}
					leadupdate.put(le.id, le);		
                }
				else if(isUpdate && (le.contact__c != leadOldMap.get(le.id).contact__c)){
					if(string.isnotblank(le.contact__c)?existingRC.containskey(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.contact__c)):False){
						le.Retail_Contact__c=existingRC.get(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.contact__c));						
					}
					leadupdate.put(le.id, le);
				}
				else if(isUpdate && (le.Company_Account__c != leadOldMap.get(le.id).Company_Account__c)){
					
					if(string.isnotblank(le.Company_Account__c)?existingRC.containskey(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.Company_Account__c)):False){
						le.Retail_Company__c=existingRC.get(string.valueof(le.Assigned_Dealer__c)+string.valueof(le.Company_Account__c));
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
		
	/*	
        for (Lead__c leds: leadlst) {
            if (leds.Assigned_Dealer__c != null) {
                for (Account_Link__c alk: dealercount) {
                    accountlnkid.add(alk.id);
                    leadrecId.add(leds.id);
                    if (accountlnkid != null && leadrecId != null) {
                        leds.Retail_Contact__c = alk.id;
                        leadupdate.put(leds.id, leds);
                    }
                }
            }
        }*/
	  if (LeadUtil.createAccountLinkRecord) {
				
				if (leadupdate != null && leadupdate.Size() > 0) {
					LeadUtil.createAccountLinkRecord = false;
					Update leadupdate.Values();
				}
		
		    }
        
    }
	
	/*
	Description: This method will be used to empty the retial copy field lookup of company and person
	*/
	
	public static void updateRetailLookups(List<Lead__c> Leadlist, String Market){
   
		for(Lead__c le:Leadlist){
			 if (string.isblank(le.Assigned_Dealer__c) && le.MD__c== Market) {
				le.Retail_Contact__c=NULL;
				le.Retail_Company__c=NULL;
			}
		
		} 
	}
	
	public static void autoPopulateAssignDealer(List<Lead__c> Leadlist, String Market){
	 if (userInfo.getUserType() == 'PowerPartner' ) {
		 User usr = [Select id, contactID,AccountID,contact.accountid from user where id =: userInfo.getUserId()];
		 for(Lead__c le:Leadlist){
			if(string.isblank(le.Assigned_Dealer__c)) le.Assigned_Dealer__c=usr.contact.AccountID;		
		} 
	  }
	}
	
}
 