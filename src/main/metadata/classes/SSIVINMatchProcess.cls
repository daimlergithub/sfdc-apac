/*
    Type:       Extension for DealerSearch Visualforce page 
    Purpose:    When SSI status='All Valid', 
                System should run VIN match process automatically,
                and generate different type of SSI OB call task based on VIN match result.
    User Story: US-DS-005
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Chris Created on 2013-04-22

*/

/*
    1. 'VehicleUSvin' field on SSI record object match with 'UsVIN' field on Vehicle object.
    2. 'CustomerName' field on SSI record object match with 'Account Name' field on Account object.
    3. 'HomeMobilePhone' field on SSI record object match with 'Mobile'and 'Second Mobile'field on Account object.
    4. Once the VIN match is completed, SSI task will be generated automatically based on the result.
    5. If VIN matched, same customer name and mobile phone, generate Welcome Call + 1st Survey Call task immediately related to SSI record. SSI Status changed to be 'Matched'. Refers to US-SSI-008
    6. If VIN matched, different customer name or mobile phone, generate 1st Survey Call task immediately related to SSI record. SSI Status changed to be 'Matched'. Refers to US-SSI-0018
    7. If VIN unmatched, use SSI information generate 1st Survey Call task immediately related to SSI record. SSI Status changed to be 'Unmatched'. Refers to US-SSI-018.
*/
    
public with sharing class SSIVINMatchProcess {
    
    private final static String SUBJECT_WELCOMECALL = 'Welcome Call';
    private final static String SUBJECT_WELCOMECALLAND1STSURVEYCALL = 'Welcome Call + 1st Survey Call';
    private final static String SUBJECT_1STSURVEYCALL = '1st Survey Call';
    private final static String SUBJECT_2NDSURVEYCALL = '2nd Survey Call';
    
    
    public static void runProcess(){
        /*
        //new tasks list
        List<Task> surveyTasks = new List<Task>();
        
        //search all all valid ssi records
        List<SSI__c> ssiList = [Select VehicleUSvin__c, HomeMobilePhone__c, CustomerName__c From SSI__c Where Status__c = 'All Valid'];
        //set up ssi match map
        Map<String, SSI__c> ssiMap = new Map<String, SSI__c>();
        for(SSI__c ssi : ssiList){
            if(ssi.VehicleUSvin__c == null){
            
            }
            
                
            if(!ssiMap.containsKey(ssi.VehicleUSvin__c)){
                ssiMap.put(ssi.VehicleUSvin__c, ssi);
            }
        }
        //search all vehicle relationship with AccountName and UsVin
        List<Vehicle_Relationship__c> vrList = [
            Select  v.Vehicle_ID__c, v.Vehicle_ID__r.UsVIN__c, 
                    v.Contact__c, v.Contact__r.Name, v.Contact__r.PersonMobilePhone, v.Contact__r.Second_Mobile__c 
            From Vehicle_Relationship__c v 
            Where v.Vehicle_ID__r.UsVIN__c != null And v.Contact__c != null];
        //set up vr match map   
        Map<String, Vehicle_Relationship__c> vrMap = new Map<String, Vehicle_Relationship__c>();
        for(Vehicle_Relationship__c vr : vrList){
            if(!vrMap.containsKey(vr.Vehicle_ID__r.UsVIN__c)){
                vrMap.put(vr.Vehicle_ID__r.UsVIN__c, vr);
            }
        }
        
        for(SSI__c ssi : ssiMap.values()){
            if(vrMap.containsKey(ssi.VehicleUSvin__c)){
                Vehicle_Relationship__c vr = vrMap.get(ssi.VehicleUSvin__c);
                if(ssi.CustomerName__c == vr.Contact__r.Name && (ssi.HomeMobilePhone__c == vr.Contact__r.PersonMobilePhone || ssi.HomeMobilePhone__c == vr.Contact__r.Second_Mobile__c)){
                    String subject = SUBJECT_WELCOMECALLAND1STSURVEYCALL;
                }else{
                    surveyTasks.add(createSurveyTask(ssi, vr, SUBJECT_1STSURVEYCALL));
                }
            }else{
                surveyTasks.add(createSurveyTask(ssi, null, SUBJECT_1STSURVEYCALL));
            }
        }   
        
        for(Vehicle_Relationship__c vr : vrMap.values()){
            //if(!ssiMap.containsKey(vr.Vehicle_ID__r.UsVIN__c)){
        }
        */
    }
    
    /*
    private static Task createSurveyTask(SSI__c ssi, Vehicle_Relationship__c vr, String subject){
        Task t = new Task();

        return t;
    }
    */
    
   
        
}