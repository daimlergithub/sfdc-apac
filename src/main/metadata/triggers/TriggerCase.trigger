/*
  Name                 : TriggerCase
  Object               : Case
  Requirement          : US-Cpn-010
  Refer classes        : UtilCase.cls
  Author               : Mouse Liu
  Create Date          : 2013/7/9
  Modify History       : 
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerCaseTriggerHandler
 
 */
trigger TriggerCase on Case(after insert, after delete, after undelete,before Delete) 
{
    TriggerUtil.handleTrigger('TriggerCase');
}