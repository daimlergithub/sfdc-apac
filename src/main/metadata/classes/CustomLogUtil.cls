public with sharing class CustomLogUtil 
{
    public static Boolean CustomDebugLogEnabled = boolean.valueOf(label.Custom_Debug_Log_Switch);
    public static String customDebugLog = '';
    public static List<String> customLog = new List<String>();
    
    
    public static void CustomLoggingEntry(String debugString)
    {
   
        if(!CustomDebugLogEnabled) return;
        else
            customLog.add(debugString);     
    }
    
    public static void DebugException(Exception ex)
    {   
        String exceptionInfo = 'Exception occurred in the line' + ex.getLineNumber() + '-' + ex.getMessage() + 'StackTrace: '+ ex.getStackTraceString();       
        CustomLoggingEntry(exceptionInfo);
    }
    
    public static void DebugLogInsert()
    {    
        Custom_Debug_Info__c cdi = new Custom_Debug_Info__c();       
        if(customLog.size() > 0)
        {       
            for(String str : customLog)
            {            
                cdi.Custom_Debug_Log_Data__c += str + '\n';
            }   
        Database.insert(cdi, false); 
              
        }
        
                customLog.clear();
    }
	
	//Added by Sushma for MY specific requirement
    public static void CustomLoggingEntryRecordIds(String RequestBody, String endpoint, String exceptionMsg, String Market)
    {
   
        if(!CustomDebugLogEnabled) return;
        else
        {
            if(Market == 'MY')
            DebugLogInsertMY(RequestBody, endpoint, exceptionMsg, Market);
        }       
    }
    
    public static void DebugLogInsertMY(String RequestBody, String endpoint, String exceptionMsg, String Market)
    {   
        if(requestBody!=Null)
        {   
            String interfaceName = '';
            Map < String, CDM_Integration_URLs__c > mapURLs = CDM_Integration_URLs__c.getAll();
            for (string str: mapURLs.keyset()){
                if (mapURLs.get(str).Informatica_URL__c == endpoint && mapURLs.get(str).country__c == Market)
                    interfaceName = str;
            } 
            List<Custom_Debug_Info__c> lcdi = new List<Custom_Debug_Info__c>();    
            List<Object> fieldList = (List<Object>)JSON.deserializeUntyped(requestBody);
            List<Map<String,Object>> listJson=new List<Map<String,Object>>();
            for(Object fld : fieldList){    
                Map<String,Object> data = (Map<String,Object>)fld;              
                listJson.add(data);
            }
            for(Map<String,Object> l:listJson){
                for(String str:l.keyset()){
                    if(str!='attributes'){
                        Custom_Debug_Info__c cdi = new Custom_Debug_Info__c();
                        cdi.Attribute_Name__c = str;
                        cdi.recordID__c = ''+l.get(str);
                        cdi.Group_by_Record__c = ''+l.get('CaseID');
                        cdi.Logging_Date_Time__c = System.now();
                        cdi.Error_Logged_By__c = 'SFDC';
                        cdi.Custom_Debug_Log_Data__c = exceptionMsg;
                        cdi.Interface_Name__c = interfaceName;
                        lcdi.add(cdi);
                    }   
                }
            } 
            if(lcdi!=NULL || !lcdi.isEmpty()){
                //Database.insert(lcdi, false);               
            } 
        }    
    }
}