public class ToolKit_TriggerHelper {

 Private static Id eventTK = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('smart Event').getRecordTypeId();
    public static void toolkitinsertupdate(List<Tool_Kit__c> tool)
    {
    Map<Id, Id> tkVandorMap = new Map<Id, Id>();
    Set<Id> vandorIds = new Set<Id>();
    Map<Id, Id> vandorContactMap = new Map<Id, Id>();
    List<Tool_Kit__Share> tkShares = new List<Tool_Kit__Share>();
    List<Task> taskList = new List<Task>();
    Map<String, Schema.RecordTypeInfo> taskRecordTypeMap = Schema.SObjectType.task.getRecordTypeInfosByName();
  
    
    } 
        
        
}