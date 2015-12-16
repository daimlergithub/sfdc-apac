/*
    Type:       Apex Class
    Purpose:    Define methods used in TriggerTask
    User Story: US-SSI-008, US-SSI-011, US-SSI-014, US-SSI-018
    Used By:    TriggerTask.trigger
    ---------------------------------------------------------------
    History:
    
    24-Apr-2013 Chris Huang (Breakingpoint)    Created
    10-mar-2014 shuang Li (NTTData) Update BRD-AS-CAC-007
    18-mar-2014 shuang Li (NTTData) Update US-smart_SSI-008
    2015-04-21 Gerhard Henning (NTTData)  Moved code to TaskTriggerHandler
*/

public class TaskTriggerHandlerJP
    implements TriggerHandlerIf
{ 
      
    private static final String WELAND1STSURVEY = 'Welcome Call + 1st Survey Call';
    private static final String X1STSURVEY = '1st Survey Call';
    private static final String X2NDSURVEY = '2nd Survey Call';  
    private static Id OBRTID;
    private static Id IBRTID; 
    private static Id SSIRTID;
    private static Id WCRTID;
    private static Id OBTRTID;
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
    {
        // Implementation to addedd as required in market
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
    {
    	// Implementation to addedd as required in market
    }
    
    
}