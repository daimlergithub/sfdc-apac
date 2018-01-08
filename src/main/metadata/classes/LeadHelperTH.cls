/**
 * Utility for Trigger on Lead__c for TH(Thailand)
 *It will handle the lead reassinment funtionality and validation rules of TH market
 * Author: Dhanamjaya
 * Created Date : 2017-01-23
 */
public without sharing class LeadHelperTH {
    public static boolean booleanCampaignUpdate = true;
    private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
    private static final String retailSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.RETAIL_SALES_LEADS).getRecordTypeId();
    set < id > accId = new set < id > ();
    set < id > newmapid = new set < id > ();

    Map < id, id > accUserMap = new Map < id, id > ();
    //it will handle the lead reassign functionality befor insert the lead  
    public void updateOwnerwithDealer(List < lead__c > leads) {

        List < lead__c > leadslist = new List < lead__c > ();

        for (Lead__c lead: leads) {

            if ((lead.RecordTypeId == salesRecordTypeId || lead.RecordTypeId == afterSalesRecordTypeId || lead.RecordTypeId == retailSalesRecordTypeId) && lead.md__c == System.label.MarketTH) {
                accId.add(lead.assigned_dealer__c);
            }
        }
        List < Account > accList = new List < Account > ();
        accList = [Select Dealer_Lead_Gate_Keeper__c, Dealer_nd_code__c from Account where id =: accId];
        if (accList.size() > 0) {
            for (Account acc: accList) {
                if (acc.Dealer_Lead_Gate_Keeper__c != null) {
                    accUserMap.put(acc.id, acc.Dealer_Lead_Gate_Keeper__c);
                }

            }
        }
        for (Lead__c lead: leads) {

            if ((lead.RecordTypeId == salesRecordTypeId || lead.RecordTypeId == afterSalesRecordTypeId || lead.RecordTypeId == retailSalesRecordTypeId) && lead.md__c == System.label.MarketTH) {
                if (accUserMap.get(lead.assigned_dealer__c) != null && UserInfo.getUserType()!='PowerPartner') {
                    lead.ownerID = accUserMap.get(lead.assigned_dealer__c);
                }

            }

        }

    }
    //this will update dealername once the dealer is assigned.
    public void updateAllWorkflowsActionsAfterInsert(List < lead__c > leads, boolean flag) {
        List < Lead__c > leadlist = [select id, RecordTypeID, md__c, assigned_dealer__c, Assigned_Dealer__r.Name from Lead__c where id =: leads];
        List < lead__c > updatelist = new List < lead__c > ();
        for (Lead__c leadlst: leadlist) {
            if (leadlst.md__c == 'TH') {
                if (leadlst.assigned_dealer__c != null) {
                    if (leadlst.RecordTypeId == salesRecordTypeId || leadlst.RecordTypeId == afterSalesRecordTypeId || leadlst.RecordTypeId == retailSalesRecordTypeId) {

                        leadlst.MBTH_Assigned_Dealer_Name__c = leadlst.Assigned_Dealer__c;
                        updatelist.add(leadlst);
                    }
                }
            }
        }
        if (updatelist.size() > 0 && !flag) {
            update updatelist;
        }
    }

    //it will handle the lead reassign functionality befor update the lead  
    public void updateOwner(List < lead__c > leads) {

        for (Lead__c l: leads) {
            if (l.md__c == System.label.MarketTH) {
                if (((Lead__c) Trigger.newMap.get(l.id)).assigned_dealer__c != ((Lead__c) Trigger.oldMap.get(l.id)).assigned_dealer__c && (l.RecordTypeId == salesRecordTypeId || l.RecordTypeId == afterSalesRecordTypeId || l.RecordTypeId == retailSalesRecordTypeId)) {
                    if (((Lead__c) Trigger.newMap.get(l.id)).assigned_dealer__c != null) {
                        newmapid.add(((Lead__c) Trigger.newMap.get(l.id)).assigned_dealer__c);
                        l.Received_Date_Time__c = null;
                        l.Accepted_Date_Time__c = null;
                        l.dealer_lead_status__c = '';
                    } else {
                        if (((Lead__c) Trigger.oldMap.get(l.id)).assigned_dealer__c != null && l.assigned_dealer__c == null)

                            //l.assigned_dealer__c=null;
                            l.ownerId = l.createdbyId;

                    }

                } else if (((Lead__c) Trigger.newMap.get(l.id)).ownerid != ((Lead__c) Trigger.oldMap.get(l.id)).ownerid && (l.RecordTypeId == salesRecordTypeId || l.RecordTypeId == afterSalesRecordTypeId || l.RecordTypeId == retailSalesRecordTypeId)) {
                    //l.ownerID = ((Lead__c) Trigger.newMap.get(l.id)).ownerid;
                } else if ((l.RecordTypeId == salesRecordTypeId || l.RecordTypeId == afterSalesRecordTypeId || l.RecordTypeId == retailSalesRecordTypeId)) {
                    if (l.assigned_dealer__c == null) {
                        //l.ownerID=l.createdbyId;


                    } else {
                        if (l.assigned_dealer__c != null && l.Received_Date_Time__c != null && l.Accepted_Date_Time__c != null) {
                            if (l.dealer_lead_status__c != System.label.Accepted) {

                                //l.ownerID=l.createdbyId;
                                l.assigned_dealer__c = null;

                            }


                        }

                    }

                }

            }


            if (newmapid.size() > 0) {
                updateOwnership(newmapid, leads);
            }
        }

    }

    //Call informatica web service
    public void CdmLeadcreate(List < Lead__c > leadlist, map < id, Lead__c > leadOldMap) {
        Set < Id > LeadIdinsert = new Set < Id > ();
        Set < Id > LeadIdupdate = new Set < Id > ();
        Map < Id, Lead__c > ldmap = new Map < Id, Lead__c > ([select id, Contact__r.Ucid__c, Retail_Contact__r.Retail_DMS_Customer_ID__c, Assigned_Dealer__c from Lead__c where id in: leadOldMap.keyset()]);
        for (Lead__c le: leadlist) {
            if (ldmap.containskey(le.Id)) {
                if (ldmap.get(le.Id).Contact__r.Ucid__c != '' && ldmap.get(le.Id).Retail_Contact__r.Retail_DMS_Customer_ID__c != '' && le.Assigned_Dealer__c != null && le.Assigned_Dealer__c == leadOldMap.get(le.id).Assigned_Dealer__c && le.MD__c == 'TH' && le.CAC_Lead_Status__c != leadOldMap.get(le.id).CAC_Lead_Status__c && le.CAC_Lead_Status__c == 'Accepted') {

                    LeadIdinsert.add(le.Id);
                }
            }
        }
        if (LeadIdinsert.size() > 0)
            //call informatica service
            CDMInformatica_Services.createLead(LeadIdinsert, 'TH', 'insert');

    }

    //it will handle all SARI validations of lead module
    public void leadValidation(List < lead__c > leadlist) {
        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id, Name from Profile where Id =: profileId].Name;
        for (Lead__c listlead: leadlist) {
            if (listlead.md__c == System.label.MarketTH) {
                if ((listlead.recordtypeid == afterSalesRecordTypeId || listlead.recordtypeid == salesRecordTypeId) && profileName != 'IntegrationAPI') {
                    if (listlead.CAC_Lead_Status__c == System.label.Purchased && listlead.Purchased_CAC_Date__c == null) {
                        listlead.CAC_Lead_Status__c.adderror(system.label.TH_CACPurchaseddateRequired_Error);
                    }
                    if (listlead.recordtypeid == salesRecordTypeId && listlead.CAC_Lead_Status__c == System.label.Purchased && (listlead.Purchased_CAC_Date__c == null || listlead.Bought_Vehicle_Brand__c == null || listlead.Bought_Vehicle_Class__c == null || listlead.Bought_Vehicle_Model__c == null)) {
                        listlead.CAC_Lead_Status__c.adderror(system.label.TH_CAC_LeadstatusPurchasedError);

                    }

                }
                if ((listlead.recordtypeid == retailSalesRecordTypeId || listlead.recordtypeid == afterSalesRecordTypeId || listlead.recordtypeid == salesRecordTypeId) && profileName != 'IntegrationAPI') {
                    if (listlead.Dealer_Lead_Status__c == 'Order Placed' && listlead.Order_Placed_Date__c == null && listlead.recordtypeid != retailSalesRecordTypeId) {
                        listlead.Order_Placed_Date__c.adderror(system.label.TH_SARI_DealerOrderplacedError);

                    }
                    if (listlead.Dealer_Lead_Status__c == System.label.Purchased && listlead.Purchased_Date__c == null) {
                        listlead.Dealer_Lead_Status__c.adderror(system.label.TH_SARIDealerlead_status_error);

                    }
                }

            }
        }

    }
    Public void CreateRetailCopy(List < Lead__c > leadlist, map < id, Lead__c > leadOldMap, boolean isInsert, boolean isUpdate) {
        set < String > contactId = new set < String > ();
        for (Lead__c le: leadlist) {
            if (le.Assigned_Dealer__c != null && le.MD__c == 'TH') {
                if (isInsert || (isUpdate && le.Assigned_Dealer__c != leadOldMap.get(le.id).Assigned_Dealer__c)) {
                    contactId.add(le.id);
                }
            }
        }
        if (contactId.size() > 0) {
            LeadHelperAccountLinkCreateJP.createAccountLinkRecord(contactId);
        }
    }

    //this method is common for before update and before insert of leadreassigning functionality   
    public Static void updateOwnership(set < id > acc, List < Lead__c > leadlist) {
        Map < id, id > accUserMap = new Map < id, id > ();
        if (acc.size() > 0) {

            List < Account > accountList = [select Dealer_Lead_Gate_Keeper__c from Account where id =: acc];
            for (Account ac: accountList) {
                if (ac.Dealer_Lead_Gate_Keeper__c != null) {
                    accUserMap.put(ac.id, ac.Dealer_Lead_Gate_Keeper__c);

                }
            }

        }
        for (Lead__c lists: leadlist) {

            if (accUserMap.get(lists.assigned_dealer__c) != null && lists.md__c == System.label.MarketTH && UserInfo.getUserType()!='PowerPartner') {
                lists.ownerID = accUserMap.get(lists.assigned_dealer__c);

            }

        }


    }
    public Static void ShareRecordswithDealers(List < Lead__c > leadlist, Boolean flag) {
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
}