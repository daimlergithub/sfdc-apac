/**
** Trigger on Account
** 1. If customer has no vehicle relationship, Status must not be ‘Customer’ 
** 2. Update dealer record in salesforce manually check
** 3. When city change , update look upWrap service for retail tasks to share.

**  Created By: CC
**  User Story: US-DS-001, US-Lead-009
**  History:  
**  1. Mouse Created on 2013-03-28 for US-DS-OO1
**  2. Mouse Updated on 2013-07-04 for US-Lead-009
**  3. Sinow Update on 2013-07-22 for US-DP-022, US-DP-023, when Allow Data Sharing changed to yes, update lead's owner.
**  4. Gerhard Henning (NTTData)  Moved code to TriggerAccountHandler on 2015-04-21	
	Modified By : 
	Modified date : 27-oct-2015
**/

public class TriggerAccountTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
    {
        if (Trigger.isBefore) {
            UtilAccount.beforeAccDealerInfo(Trigger.new,(Map<Id,Account>)Trigger.oldMap,Trigger.isInsert,Trigger.isUpdate);
        }
    
        if (trigger.isAfter && trigger.isUpdate) {
            UtilAccount.accountSetForUpdateLead(trigger.new,(Map<Id,Account>)Trigger.oldMap);
        }
    }
}
