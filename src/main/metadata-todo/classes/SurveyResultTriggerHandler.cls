/*
    Type:       Class
    Purpose:    1. Define method used in SurveyResultBeforeUpdate trigger
                
    User Story: 
    Used By:    SurveyResultBeforeUpdate.trigger
    ---------------------------------------------------------------
    History: 
    
    1. Patrick Zhang Created on 2013-09-16
    2. Patrick Zhang add new Method removePrefix() on 2013-09-23
    3. Patrick Zhang add new Method reviewAndChange() on 2013-09-24
    4. Chris Huang Add survey result gets call message function enhancement on 2013-12-18
*/

public class SurveyResultTriggerHandler{

    private static Map<String, String> questionMapping = new Map<String, String>();
    private static List<String> commentString = new List<String>();
    private static List<String> allQuestions = new List<String>();
    private static List<String> jumpQuestions = new List<String>();

    public static void reviewAndChange(Map<Id, Survey_Result__c> newSurveys, Map<Id, Survey_Result__c> oldSurveys){

        if (!newSurveys.isEmpty() && !oldSurveys.isEmpty()) {

            Set<Id> taskIds = new Set<Id>();
            Set<Survey_Result__c> srs = new Set<Survey_Result__c>();

            for (Survey_Result__c sr : newSurveys.values()) {
                Survey_Result__c old = oldSurveys.get(sr.Id);
                reviewAndChange(sr, old);

                if (sr.QC_Approved__c && !old.QC_Approved__c && sr.TaskId__c != null) {
                    taskIds.add(sr.TaskId__c);
                    srs.add(sr);
                }
            }

            if (taskIds.size() > 0) {
                updateCallMessage(taskIds, srs);
            }
        }
        
    }  

    // Update Call Messages
    // If Qc is approved, auto update survey result call message from related task.
    private static void updateCallMessage (Set<Id> taskIds, Set<Survey_Result__c> srs) {
        Map<Id, Task> tasks = new Map<Id, Task>([
            Select Id, OB_Call_Times__c, UCID__c, Caller__c, Called__c, Start_call_time__c, End_call_time__c, CallObject 
            From Task 
            Where Id In :taskIds
        ]);

        Map<Id, Survey_Result__c> furthers = new Map<Id, Survey_Result__c>();

        for (Survey_Result__c sr : srs) {
            if (tasks.containsKey(sr.TaskId__c)) {
                Task tk = tasks.get(sr.TaskId__c);
                sr.Eventuallycontactphone__c = tk.Called__c;
                sr.Startcalltime__c = tk.Start_call_time__c;
                sr.Endcalltime__c = tk.End_call_time__c;

                if (sr.SSI_Record__c != null && (
                        sr.Eventuallycontactphone__c == null || sr.Startcalltime__c == null || sr.Endcalltime__c == null)) {
                    furthers.put(sr.SSI_Record__c, sr);
                }
            }
        }

        Id OBID = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();

        if (furthers.size() > 0) {
            Map<Id, Task> ctiMap = new Map<Id, Task>();
            for (List<Task> ctis : [
                Select Id, OB_Call_Times__c, UCID__c, Caller__c, Called__c, Start_call_time__c, End_call_time__c, CallObject, WhatId 
                From Task 
                Where recordtypeid = :OBID And CreatedDate >= LAST_N_MONTHS:6 
                    And WhatId In :furthers.keySet() 
                    And Called__c != null 
                    And Start_call_time__c != null 
                    And End_call_time__c != null
                Order By CreatedDate DESC
            ]) {
                for (Task cti : ctis) {
                    if (!ctiMap.containsKey(cti.WhatId)) {
                        ctiMap.put(cti.WhatId, cti);
                    }                    
                }
            }

            if (ctiMap.size() > 0) {
                for (Id co : ctiMap.keySet()) {
                    if (furthers.containsKey(co)) {
                        Survey_Result__c sr = furthers.get(co);
                        Task cti = ctiMap.get(co);
                        sr.Eventuallycontactphone__c = cti.Called__c;
                        sr.Startcalltime__c = cti.Start_call_time__c;
                        sr.Endcalltime__c = cti.End_call_time__c;
                    }
                }
            }
        }

    }

    /*
        Below questions change answer between logic1 and logic2, system will clear all answers after them
        Question No.    Logic1  Logic2
        S1 Start1       1,2     3
        S1 S1           1       2,3,11
        S1 S2           1       2,11
        S1 S3           1,2     3,11
        S1 S5           1       2,11
        S1 Q5           1       2,11
        S1 Q8           1       2,11
    */
    private static void reviewAndChange (Survey_Result__c sr, Survey_Result__c old) {
        String fieldName;
        for (String jumpStr : jumpQuestions) {
            String newValue = (String)sr.get(jumpStr);
            String oldValue = (String)old.get(jumpStr);
            if (newValue != null && oldValue != null && newValue != oldValue) {

                fieldName = jumpStr;

                String newNo = newValue.indexOf('.') > 0 ? newValue.substring(0, newValue.indexOf('.')) : '';
                String oldNo = oldValue.indexOf('.') > 0 ? oldValue.substring(0, oldValue.indexOf('.')) : '';

                if (newNo != oldNo) {
                    if (jumpStr == 'Start2__c' || jumpStr == 'Try1__c' || jumpStr == 'Try2__c' || jumpStr == 'S1_Q4__c') {
                        break;
                    }else if (jumpStr == 'Start1__c' && (newNo == '3' || oldNo == '3')) {
                        break;
                    }else if (jumpStr == 'S1_S3__c' && (
                        ((newNo == '1' || newNo == '2') && (oldNo == '3' || oldNo == '11')) || 
                        ((newNo == '3' || newNo == '11') && (oldNo == '1' || oldNo == '2')) )
                    ) {
                        break;
                    } else if ((
                            jumpStr == 'S1_S1__c' || 
                            jumpStr == 'S1_S2__c' ||
                            jumpStr == 'S1_S5__c' ||
                            jumpStr == 'S1_Q5__c' ||
                            jumpStr == 'S1_Q8__c') && (newNo == '1' || oldNo == '1')) {
                        break;
                    }                     
                }

                fieldName = null;

            }
        }

        if (fieldName != null) {
            Boolean flag = false;
            for (Integer k=0; k<allQuestions.size(); k++) {
                String fieldNameNext = allQuestions.get(k);
                if (flag) {
                    sr.put(fieldNameNext, '');
                }else {
                    if (fieldNameNext == fieldName) {
                        flag = true;
                    }
                }
            }
        }
    }

    public static void removePrefix(List<Survey_Result__c> newSurveys){
        if (!newSurveys.isEmpty()) {
            for (Integer i=0; i<newSurveys.size(); i++) {
                for (String fieldName : commentString) {
                    Object fieldObj = newSurveys[i].get(fieldName);
                    String fieldStr = String.valueOf(fieldObj);

                    if (fieldStr != null && fieldStr.startsWith('-')) {
                        //System.debug('修改前：'+newSurveys[i].get(fieldName));
                        fieldStr = fieldStr.substring(1, fieldStr.length());
                        newSurveys[i].put(fieldName, fieldStr);
                        //System.debug('修改后：'+newSurveys[i].get(fieldName));
                    }
                }
            }
        }
    }

    public static void changeCode(List<Survey_Result__c> newSurveys){
        if(!newSurveys.isEmpty()){
            for(Integer i=0;i<newSurveys.size();i++){
                for(String fieldName : questionMapping.keySet()){
                    Object fieldObj = newSurveys[i].get(fieldName);
                    String fieldStr = String.valueOf(fieldObj);

                    //System.debug('修改前：'+String.valueOf(newSurveys[i].get(questionMapping.get(fieldName))));
                    if(fieldObj != null && fieldStr != null && fieldStr.trim().length() >= 2){
                        String preStr = fieldStr.subString(0,2);
                        
                        if(preStr.subString(0,1).isNumeric() && preStr.subString(1,2).isNumeric()){
                            
                            newSurveys[i].put(questionMapping.get(fieldName), preStr);
                        } else if (preStr.subString(0,1).isNumeric() && !preStr.subString(1,2).isNumeric()) {
                            
                            newSurveys[i].put(questionMapping.get(fieldName), preStr.subString(0,1));
                        }else {
                            
                            newSurveys[i].put(questionMapping.get(fieldName), '');
                        }
                    }else if (fieldStr != null && fieldStr.trim().length() == 1) {
                        if (fieldStr.isNumeric()) {
                            
                            newSurveys[i].put(questionMapping.get(fieldName), fieldStr);
                        }
                    }else{
                        
                        newSurveys[i].put(questionMapping.get(fieldName), '');
                    }
                    //System.debug('修改后：'+String.valueOf(newSurveys[i].get(questionMapping.get(fieldName))));
                }
            }
        }
    }

    static{
        // 1st Survey
        questionMapping.put('S1_S1__c', 'S1_S1_Code__c');
        questionMapping.put('S1_S2__c', 'S1_S2_Code__c');
        questionMapping.put('S1_S3__c', 'S1_S3_Code__c');
        questionMapping.put('S1_S4__c', 'S1_S4_Code__c');
        questionMapping.put('S1_S5__c', 'S1_S5_Code__c');
        questionMapping.put('S1_Z1__c', 'S1_Z1_Code__c');
        questionMapping.put('S1_Z2__c', 'S1_Z2_Code__c');
        questionMapping.put('S1_Q1__c', 'S1_Q1_Code__c');
        questionMapping.put('S1_Q201__c', 'S1_Q201_Code__c');
        questionMapping.put('S1_Q202__c', 'S1_Q202_Code__c');
        questionMapping.put('S1_Q203__c', 'S1_Q203_Code__c');
        questionMapping.put('S1_Q2031__c', 'S1_Q2031_Code__c');
        questionMapping.put('S1_Q204__c', 'S1_Q204_Code__c');
        questionMapping.put('S1_Q2041__c', 'S1_Q2041_Code__c');
        questionMapping.put('S1_H1__c', 'S1_H1_Code__c');
        questionMapping.put('S1_Q3__c', 'S1_Q3_Code__c');
        questionMapping.put('S1_Q4__c', 'S1_Q4_Code__c');
        questionMapping.put('S1_Q5__c', 'S1_Q5_Code__c');
        questionMapping.put('S1_Q501__c', 'S1_Q501_Code__c');
        questionMapping.put('S1_Q601__c', 'S1_Q601_Code__c');
        questionMapping.put('S1_Q602__c', 'S1_Q602_Code__c');
        questionMapping.put('S1_Q603__c', 'S1_Q603_Code__c');
        questionMapping.put('S1_H2__c', 'S1_H2_Code__c');
        questionMapping.put('S1_Q701__c', 'S1_Q701_Code__c');
        questionMapping.put('S1_Q702__c', 'S1_Q702_Code__c');
        questionMapping.put('S1_Q7021__c', 'S1_Q7021_Code__c');
        questionMapping.put('S1_Q703__c', 'S1_Q703_Code__c');
        questionMapping.put('S1_Q7031__c', 'S1_Q7031_Code__c');
        questionMapping.put('S1_Q704__c', 'S1_Q704_Code__c');
        questionMapping.put('S1_Q7041__c', 'S1_Q7041_Code__c');
        questionMapping.put('S1_Q705__c', 'S1_Q705_Code__c');
        questionMapping.put('S1_Q7051__c', 'S1_Q7051_Code__c');
        questionMapping.put('S1_Q706__c', 'S1_Q706_Code__c');
        questionMapping.put('S1_Q7061__c', 'S1_Q7061_Code__c');
        questionMapping.put('S1_Q707__c', 'S1_Q707_Code__c');
        questionMapping.put('S1_Q708__c', 'S1_Q708_Code__c');
        questionMapping.put('S1_Q7071__c', 'S1_Q7071_Code__c');
        questionMapping.put('S1_H3__c', 'S1_H3_Code__c');
        questionMapping.put('S1_Q8__c', 'S1_Q8_Code__c');
        questionMapping.put('S1_Q9__c', 'S1_Q9_Code__c');
        questionMapping.put('S1_Q10__c', 'S1_Q10_Code__c');
        questionMapping.put('S1_H4__c', 'S1_H4_Code__c');
        questionMapping.put('S1_G1__c', 'S1_G1_Code__c');
        questionMapping.put('S1_G2__c', 'S1_G2_Code__c');
        questionMapping.put('S1_G3__c', 'S1_G3_Code__c');
        questionMapping.put('S1_G4__c', 'S1_G4_Code__c');
        questionMapping.put('S1_K1__c', 'S1_K1_Code__c');
        questionMapping.put('S1_K2__c', 'S1_K2_Code__c');
        questionMapping.put('S1_K3__c', 'S1_K3_Code__c');
        questionMapping.put('S1_K4__c', 'S1_K4_Code__c');
        questionMapping.put('S1_F1__c', 'S1_F1_Code__c');
        questionMapping.put('S1_F2__c', 'S1_F2_Code__c');
        questionMapping.put('S1_F2__c', 'S1_F2_Code__c');
        
        
        
        
        // 2nd Survey
        questionMapping.put('S2_Q1__c', 'S2_Q1_Code__c');
        questionMapping.put('S2_Q1b__c', 'S2_Q1b_Code__c');
        questionMapping.put('S2_Q2__c', 'S2_Q2_Code__c');
        questionMapping.put('S2_Q3__c', 'S2_Q3_Code__c');
        questionMapping.put('S2_Q4__c', 'S2_Q4_Code__c');
        questionMapping.put('S2_Q5__c', 'S2_Q5_Code__c');
        
        //commentString
        commentString.add('S1_S1a__c');
        commentString.add('S1_S2a__c');
        commentString.add('S1_S5a__c');
        commentString.add('S1_Q2031a__c');
        commentString.add('S1_Q2041a__c');
        commentString.add('S1_Q5a__c');
        commentString.add('S1_Q7021a__c');
        commentString.add('S1_Q7031a__c');
        commentString.add('S1_Q7061a__c');
        commentString.add('S1_Q7071a__c');
        commentString.add('S1_G1a__c');
        commentString.add('S1_G4a__c');
        commentString.add('S1_K4a__c');
        commentString.add('S1_Z1a__c');
        commentString.add('S1_Z2a__c');
        commentString.add('Start1a__c');
        commentString.add('Try1a__c');
        commentString.add('Try2a__c');

        //allQuestions
        allQuestions.add('Start1a__c');
        allQuestions.add('Start1__c');        
        allQuestions.add('Start2__c');
        allQuestions.add('Try1a__c');
        allQuestions.add('Try1__c');
        allQuestions.add('Try2a__c');                
        allQuestions.add('Try2__c');
        allQuestions.add('S1_S1a__c');
        allQuestions.add('S1_S1__c');
        allQuestions.add('S1_S2a__c');
        allQuestions.add('S1_S2__c');        
        allQuestions.add('S1_S3__c');
        allQuestions.add('S1_S4__c');
        allQuestions.add('S1_S4c__c');
        allQuestions.add('S1_S5a__c');
        allQuestions.add('S1_S5__c');   
        allQuestions.add('S1_Z1a__c');     
        allQuestions.add('S1_Z1__c');     
        allQuestions.add('S1_Z2a__c');   
        allQuestions.add('S1_Z2__c');        
        allQuestions.add('S1_Q1__c');
        allQuestions.add('S1_Q201__c');
        allQuestions.add('S1_Q202__c');
        allQuestions.add('S1_Q203__c');
        allQuestions.add('S1_Q2031__c');
        allQuestions.add('S1_Q2031a__c');
        allQuestions.add('S1_Q204__c');
        allQuestions.add('S1_Q2041a__c');
        allQuestions.add('S1_Q2041__c');     
        allQuestions.add('S1_H1__c');     
        allQuestions.add('S1_Q3__c');
        allQuestions.add('S1_Q4__c');
        allQuestions.add('S1_Q5a__c');
        allQuestions.add('S1_Q5__c');        
        allQuestions.add('S1_Q501__c');
        allQuestions.add('S1_Q601__c');
        allQuestions.add('S1_Q602__c');
        allQuestions.add('S1_Q603__c');
        allQuestions.add('S1_H2__c');   
        allQuestions.add('S1_Q701__c');
        allQuestions.add('S1_Q702__c');
        allQuestions.add('S1_Q7021__c');
        allQuestions.add('S1_Q7021a__c');
        allQuestions.add('S1_Q703__c');
        allQuestions.add('S1_Q7031a__c');
        allQuestions.add('S1_Q7031__c');        
        allQuestions.add('S1_Q704__c');
        allQuestions.add('S1_Q7041__c');
        allQuestions.add('S1_Q705__c');
        allQuestions.add('S1_Q7051__c');
        allQuestions.add('S1_Q706__c');
        allQuestions.add('S1_Q7061__c');
        allQuestions.add('S1_Q7061a__c');
        allQuestions.add('S1_Q707__c');
        allQuestions.add('S1_Q7071a__c');
        allQuestions.add('S1_Q7071__c');
        allQuestions.add('S1_Q708__c');
        allQuestions.add('S1_H3__c');
        allQuestions.add('S1_Q8__c');
        allQuestions.add('S1_Q9__c');
        allQuestions.add('S1_Q10__c');
        allQuestions.add('S1_H4__c');
        allQuestions.add('S1_G1a__c');
        allQuestions.add('S1_G1__c');        
        allQuestions.add('S1_G2__c');
        allQuestions.add('S1_G3__c');
        allQuestions.add('S1_G4a__c');
        allQuestions.add('S1_G4__c');        
        allQuestions.add('S1_K1__c');
        allQuestions.add('S1_K2__c');
        allQuestions.add('S1_K3__c');
        allQuestions.add('S1_K4a__c');
        allQuestions.add('S1_K4__c');        
        allQuestions.add('S1_F1__c');
        allQuestions.add('S1_F2__c');
        allQuestions.add('B1__c');
        allQuestions.add('B2__c');
        allQuestions.add('B3__c');

        //jumpQuestions
        jumpQuestions.add('Start1__c');
        jumpQuestions.add('Start2__c');
        jumpQuestions.add('Try1__c');
        jumpQuestions.add('Try2__c');
        jumpQuestions.add('S1_S1__c');
        jumpQuestions.add('S1_S2__c');
        jumpQuestions.add('S1_S3__c');
        //jumpQuestions.add('S1_S4__c');
        jumpQuestions.add('S1_S5__c');
        jumpQuestions.add('S1_Q4__c');
        jumpQuestions.add('S1_Q5__c');
        jumpQuestions.add('S1_Q8__c');

    }
}