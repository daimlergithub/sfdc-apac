/**
**1. Assign Dealer Lead Status to CAC Lead Status  when assigned dealer has been verified
**2. Share related Campaign Lead to Lead Owner after dealer is assigned
 ** 3. Create a custom sharing to share the lead record with Smart Account Owner or the Star Elite Account Owner (from dealer record) with Read Only access.)
 ** 4. Share lead's contact to Dealer Sales Gate Keeper
 ** 5. If a lead is created from Inquiry case, copy lead id to Case's lead.
** 
** Created By: Sinow Zhang
** Date: 18-April-2013
Modified By : Bing
Modified date : 16-June-2014
**/

public class TriggerLeadTriggerHandler 
    implements TriggerHandlerIf
{
       /**      
     * @Description implements the trigger interface with all the trigger conditions with the help of the Helper class.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  All the Trigger Parametres.
                * @return 
                 * @see  TriggerLeadTriggerHandler 
                */    
    
    public void handleTrigger()
    {
        Map<Id,Lead__c> oldmap = (Map<Id,Lead__c>)trigger.oldmap;
        Map<Id,Lead__c> newmap = (Map<Id,Lead__c>)trigger.newmap;
        
        if(trigger.isAfter && trigger.isInsert)
        {
            AccountSharingDataHandler handler = new AccountSharingDataHandler('Lead__c');
            handler.shareAccountByCRMCode(newMap, oldMap, Trigger.isInsert);
            LeadHelper.afterInsert_UpdateEvents(trigger.new,oldMap,trigger.isinsert,trigger.isUpdate);
            LeadHelper.ShareLeadsToCampaignUser(trigger.new,oldMap,newMap,trigger.isinsert,trigger.isUpdate);
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            LeadHelper.afterInsert_UpdateEvents(trigger.new,oldMap,trigger.isinsert,trigger.isUpdate);
            LeadHelper.ShareLeadsToCampaignUser(trigger.new,oldMap,newMap,trigger.isinsert,trigger.isUpdate);
        }
        if(trigger.isBefore && trigger.isInsert)
        {
            
            UtilLead.updateLeadForDataSharing(trigger.new);
            UtilLead.beforeInsert_updateEvents(trigger.new,oldMap,trigger.isinsert,trigger.isUpdate);
            LeadHelper.beforeInsert_UpdateEvents(trigger.new,oldMap,trigger.isinsert,trigger.isUpdate);
        }
        if(trigger.isBefore && trigger.isUpdate)
        {
            UtilLead.beforeInsert_updateEvents(trigger.new,oldMap,trigger.isinsert,trigger.isUpdate);
            LeadHelper.beforeInsert_UpdateEvents(trigger.new,oldMap,trigger.isinsert,trigger.isUpdate);
        }
    }

}