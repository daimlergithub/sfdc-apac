/**
** Trigger on Account
** 1. If customer has no vehicle relationship, Status must not be ‘Customer’ 
** 2. Update dealer record in salesforce manually check
** 3. When city change , update look up
** User Story: US-DS-001, US-Lead-009
** History:   
** 1. Mouse Created on 2013-03-28 for US-DS-OO1
** 2. Mouse Updated on 2013-07-04 for US-Lead-009
** 3. Sinow Update on 2013-07-22 for US-DP-022, US-DP-023, when Allow Data Sharing changed to yes, update lead's owner.
** 4. Gerhard Henning (NTTData)  Moved code to TriggerAccountHandler on 2015-04-21
** Created By: CC
** Date: 2014-6-15
   Modified By : Mohammed Touseef AHmed
   Modified date : 03-12-2016
**/

trigger TriggerAccount on Account (before insert, before update, after insert, after update) 
{
    TriggerUtil.handleTrigger('TriggerAccount');
}