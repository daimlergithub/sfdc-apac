public with sharing class CustomLogUtil 
{
	public static Boolean CustomDebugLogEnabled = true;
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
		Custom_Debug_Iog__c cdi = new Custom_Debug_Iog__c();
		if(customLog.size() > 0)
		{		
			for(String str : customLog)
			{
				cdi.Debug_Data__c += str + '\n';
			}	
		Database.insert(cdi, false);		
		}
		customLog.clear();
	}
}
