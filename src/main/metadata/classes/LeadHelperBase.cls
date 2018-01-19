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
    Public void CreateRetailCopy(List < Lead__c > leadlist, map < id, Lead__c > leadOldMap, boolean isInsert, boolean isUpdate) {
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
    }
    
    
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
}