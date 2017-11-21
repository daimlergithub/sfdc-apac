/**
** Global utility class contain common methods
** that can be reused across the project  
** 
** Created By: Reetesh Pandey
** Date: 19 July 2017
** 
** Catch(Exception e){
** GlobalUtilityDFW gu = GlobalUtilityDFW.getInstance();
** gu.push();
** gu.pop();
** gu.DebugException();
** }
**
**/

public class GlobalUtilityDFW
{
    private static GlobalUtilityDFW instance = null;
    private static Integer currentLevel = 0;
    private static List<ApplicationLogWrapperDFW> applicationLog;
    private static SystemSettingsDFW__c sysSet;
    private static List<String> StackTrace = new List<String>();
    private static String ExceptionTrace = '';
    /** 
** private Constructor
**/
    private GlobalUtilityDFW(){      
    }
    
    /** 
** create instance of class GlobalUtilityDFW
**/ 
    public static  GlobalUtilityDFW getInstance(){        
        if(instance == null) instance = new GlobalUtilityDFW();
        return instance;
    }     
    
    /** 
** return Id of profile of user creating log
**/
    public static Id getProfileId(Id userId){  
        Id profileId = [Select ProfileId FROM User where id=:userId].ProfileId;  
        return profileId;
    }
    
    /** 
** Insert name of method in log used in first line of calling method 
**/    
    public void push(String functionName)
    {
        System.debug('Push()');
        debug('Entering: ' + functionName);
        currentLevel+=1;
        StackTrace.add(functionName);
    }
    
    /** 
** Delete last log and is used in last line of calling method    
**/        
    public void Pop()
    {
        if(CurrentLevel>0) CurrentLevel-=1;
        if(CurrentLevel==0 && applicationLog!=null) System.Debug(LoggingLevel.Info, 'applicationLog Log\n' + CurrentLog());
        if(StackTrace.size()>0) StackTrace.remove(StackTrace.size()-1);
    }
    
    
    /** 
** method called to empty log
**/      
    public void popAll()
    {
        System.debug('PopAll()');
        currentLevel=0;
        applicationLog=null;
        pop();
    }
    
    /** 
** returns the current log
**/
    public String currentLog()
    {
        if(applicationLog == null) return null;
        String spaces = '                                                                        ';
        String result = '';
        for(ApplicationLogWrapperDFW alw: applicationLog)
        {
            Integer endindex = 3 * alw.level;
            if(endindex >= spaces.length()) endindex = spaces.length()-1;
            result += spaces.substring(0,endindex) + alw.description + '\n';            
        }
        System.debug('@@@@@result : '+result);
        return result;
    }
    
    /** 
** Used for INFO and WARNINNG log
**/
    public  void debug(String debugString)
    {
        // System.Debug('@@debugString '+debugString);        
        if(applicationLog==null) applicationLog = new List<ApplicationLogWrapperDFW>();
        applicationLog.add(new ApplicationLogWrapperDFW(debugString));
        System.Debug(LoggingLevel.Info, debugString);
        
    }
    
    /**
    * Get System Setting ValueBase
    **/
    private  SystemSettingsDFW__c systemSettingValue(Id userId)
    {
        if(SystemSettingsDFW__c.getInstance(userId) != null)
            sysSet = SystemSettingsDFW__c.getInstance(userId) ;
        else if(SystemSettingsDFW__c.getInstance(getProfileId(userId)) != null)
            sysSet = SystemSettingsDFW__c.getInstance(getProfileId(userId));
        else
            sysSet = SystemSettingsDFW__c.getOrgDefaults();
        
        return sysSet;
    }
    
    /** 
** Used for ERROR log
**/
    public  void DebugException(Exception ex,Id userId)
    {
        sysSet = systemSettingValue(userId);
        
        String exceptioninfo = 'Exception occurred line ' + ex.getLineNumber() + ' - ' + ex.getMessage() + ' stack: ' + ex.getStackTraceString();
        debug(exceptioninfo);
        ApplicationLogTHDFW__c appLog = new ApplicationLogTHDFW__c();
        appLog.Age__c = sysSet.Log_Purge__c;
        appLog.Debug_Level__c ='ERROR';
        appLog.Message__c=currentLog();
        appLog.Name = '';
        appLog.Stack_Trace__c =ex.getStackTraceString();
        appLog.Error_Picklist__c ='User Created';
        Integer addPurge =Integer.valueOf(sysSet.Log_Purge__c); 
        appLog.Timer__c = System.now().addDays(addPurge); 
        appLog.Source__c='';
        appLog.Source_Function__c='';
        for(String st: StackTrace) ExceptionTrace += ' | ' + st;
        ExceptionTrace += ' |\n ';
        try {
            DMLManagerService.insertAsSystem(appLog);
        }catch(Exception e){
            
        }
        popAll();
    }
    
    /** 
** Used for ERROR log for Webservice 
**/
    public  void DebugWebServiceLog(Exception ex,Id userId,HttpRequest req, HttpResponse res)
    {
        
        sysSet = systemSettingValue(userId);
        String status='';
        Integer statusCode;
        if(res != null ){
        status = res.getStatus();
        statusCode= res.getStatusCode();
        }
        String debugLevel='';
        ApplicationLogTHDFW__c appLog = new ApplicationLogTHDFW__c();
        if(statusCode == 110 ||statusCode ==111||statusCode ==112||statusCode ==113||statusCode ==199||statusCode ==214||statusCode ==299)        
            debugLevel ='WARNING';        
        else 
            debugLevel ='INFO';
        
        if(debugLevel == 'WARNING' || debugLevel == 'INFO'  && ex == null){                  
            appLog.Age__c = sysSet.Log_Purge__c;
            appLog.Debug_Level__c =debugLevel;
            appLog.Message__c=currentLog();
            appLog.Name = '';
            appLog.Stack_Trace__c ='';
            appLog.Integration_Payload__c='';
            appLog.Error_Picklist__c ='Interface related';
            Integer addPurge =Integer.valueOf(sysSet.Log_Purge__c); 
            appLog.Timer__c = System.now().addDays(addPurge); 
            appLog.Source__c='';
            appLog.Source_Function__c='';      
        
        }
        if(ex != null)
        {
         debugLevel = 'ERROR';
        String exceptioninfo = 'Exception occurred line ' + ex.getLineNumber() + ' - ' + ex.getMessage() + ' stack: ' + ex.getStackTraceString();
        debug(exceptioninfo);        
        appLog.Age__c = sysSet.Log_Purge__c;
        appLog.Debug_Level__c =debugLevel;
        appLog.Message__c=currentLog();
        appLog.Name = '';
        appLog.Stack_Trace__c =ex.getStackTraceString();
        appLog.Integration_Payload__c=ex.getMessage();
        appLog.Error_Picklist__c ='Interface related';
        Integer addPurge =Integer.valueOf(sysSet.Log_Purge__c); 
        appLog.Timer__c = System.now().addDays(addPurge); 
        appLog.Source__c='';
        appLog.Source_Function__c='';
        }
        try {
            DMLManagerService.insertAsSystem(appLog);
        }catch(Exception e){
            
        }
        popAll();
    }
    
    /** 
** Method to check the expiration of a log record 
**/
    public void CheckDebugInfoLog()
    {
        list<ApplicationLogTHDFW__c> debugInfoLogToDelete = new list<ApplicationLogTHDFW__c>();
        debugInfoLogToDelete = [SELECT Id, Name, CreatedDate, Message__c,Age__c,Timer__c FROM ApplicationLogTHDFW__c where Timer__c < :System.now()];
        if (!debugInfoLogToDelete.isEmpty() ||  debugInfoLogToDelete.size()>0){                   
            ClearDebugInfoLog(debugInfoLogToDelete);
        }        
    }
    
    
    /** 
** Method to delete an expired log record
**/
    private void ClearDebugInfoLog(list<ApplicationLogTHDFW__c> expiredDebugInfoLog)
    {
        
        if (expiredDebugInfoLog.size()>0){
            try {
                DMLManagerService.deleteAsSystem(expiredDebugInfoLog);
                Database.emptyRecycleBin(expiredDebugInfoLog);
            }
            catch(Exception ex){
                
            }
        }
    }
    
    /** 
** Inner class for bulkification for Batch process
**/ 
    private class ApplicationLogWrapperDFW{
        
        Integer level;      
        String description;     
        private ApplicationLogWrapperDFW(String entrydescription)
        {
            level = currentLevel;
            description = '[' + System.now().format('HH:mm:ss.SSS') + '] {' + UserInfo.getName() + '} ' + entrydescription;
        }
        
    }
    
    
}