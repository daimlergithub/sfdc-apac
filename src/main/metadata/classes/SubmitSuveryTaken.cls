public class SubmitSuveryTaken {

public SubmitSuveryTaken() {

}
public SurveyTaker__c st{get;set;}
public Task tsk{get;set;}
public String whatd {get;set;}
public String whod {get;set;}
public String taskId {get;set;}
public Static Id accountidd{get;set;}
public Static Id campidd{get;set;}
public Static Id stidd{get;set;}
public PageReference pr;
public Boolean showquestion{get;set;}
public Boolean showsurveysel{get;set;}
public String surveySoql;
public String surveyRes;
public List<String> multisplit{get; private set;}
public List<String> listquestions{get;set;}
public List<String> listresponseop{get;set;}
public List<String> listresponse{get;set;}
public list<string> lr{get;set;}
Public string soqlque{get;set;}
Public string soqlresop{get;set;}
Public string soqlstres{get;set;}
public Survey__c survey{get;set;}
public Survey__c surveyon{get;set;}
public Survey__c survey1{get;set;}
public List<String> objectFields {get;set;} 
public List<String> objectFieldst {get;set;} 
public string surveyids{get;set;}
public string VRids{get;set;}
public List<String> values = new List<String>();
public List<String> numpick= new List<String>();


public SubmitSuveryTaken(ApexPages.StandardController controller) {
  
  st= (SurveyTaker__c)controller.getRecord();  
  taskId=ApexPages.currentPage().getParameters().get('tskid');  
  if(taskId !=null)
  {
  tsk = [Select id,OwnerID,WhatID,Whoid,Status,Survey__c,Survey_Taken__c,Survey_Taken__r.Survey_Response_1__c,Survey_Taken__r.Survey_Response_2__c,Survey_Taken__r.Survey_Response_3__c,Survey_Taken__r.Survey_Response_4__c,Survey_Taken__r.Survey_Response_5__c,Survey_Taken__r.Survey_Response_6__c,Survey_Taken__r.Survey_Response_7__c,Survey_Taken__r.Survey_Response_8__c,Survey_Taken__r.Survey_Response_9__c,Survey_Taken__r.Survey_Response_10__c,Survey_Taken__r.Survey_Response_12__c,Survey_Taken__r.Survey_Response_13__c,Survey_Taken__r.Survey_Response_14__c,Survey_Taken__r.Survey_Response_15__c from Task where id=:taskId];
  system.debug('st--'+tsk.Survey_Taken__r.Survey_Response_1__c);
  system.debug('st--'+st.Survey_Response_1__c);
  system.debug('st--'+st.Survey__c);
  st.Survey__c=tsk.Survey__c;
  surveyids=tsk.Survey__c;
  st.OwnerId=UserInfo.getUserId();
  st.Survey_Taking_Status__c='In Process';
  whatd=tsk.WhatID;
  whod=tsk.WhoId;
  if(whatd!=null){
  if(whatd.startsWithIgnoreCase('701'))
  {
  st.Campaign__c=tsk.WhatID;
  campidd=tsk.WhatID;
  }
  }
  if(whod!=null)
  {
  if(whod.startsWithIgnoreCase('003'))
  {
  Contact con = [Select id,Accountid from Contact where id=:tsk.WhoId];
  st.Account__c=con.accountid;
  accountidd=con.accountid;
  }
  }
  if(tsk.Survey_Taken__c!=null)
  {
  stidd=tsk.Survey_Taken__c;
  system.debug('stidd'+stidd);
 st = [Select id,Survey__c,MD__c,Survey_Taken_Date_Time__c,OwnerId,Survey_Taking_Status__c,Task_ID__c,SurveyTakenByVehicle__c,Account__c,Survey_Response_1__c,Survey_Response_2__c,Survey_Response_3__c,Survey_Response_4__c,Survey_Response_5__c,Survey_Response_6__c,Survey_Response_7__c,Survey_Response_8__c,Survey_Response_9__c,Survey_Response_10__c,Survey_Response_11__c,Survey_Response_12__c,Survey_Response_13__c,Survey_Response_14__c,Survey_Response_15__c,Campaign__c from SurveyTaker__c where Id=:stidd];

  }
  if(surveyids!=null)
  {
 surveyon=[Select id,name,selected_questions_to_display__c,(Select Survey_Response_1__c,Survey_Response_2__c,Survey_Response_3__c,Survey_Response_4__c,Survey_Response_5__c,Survey_Response_6__c,Survey_Response_7__c,Survey_Response_8__c,Survey_Response_9__c,Survey_Response_10__c,Survey_Response_11__c,Survey_Response_12__c,Survey_Response_13__c,Survey_Response_14__c,Survey_Response_15__c from SurveyTakers1__r),survey_question_1__c,Survey_Response_Options_1__c,survey_question_2__c,Survey_Response_Options_2__c,survey_question_3__c,Survey_Response_Options_3__c,survey_question_4__c,Survey_Response_Options_4__c,survey_question_5__c,Survey_Response_Options_5__c,survey_question_6__c,Survey_Response_Options_6__c,survey_question_7__c,Survey_Response_Options_7__c,survey_question_8__c,Survey_Response_Options_8__c,survey_question_9__c,Survey_Response_Options_9__c,survey_question_10__c,Survey_Response_Options_10__c,survey_question_11__c,Survey_Response_Options_11__c,survey_question_12__c,Survey_Response_Options_12__c,survey_question_13__c,Survey_Response_Options_13__c,survey_question_14__c,Survey_Response_Options_14__c,survey_question_15__c,Survey_Response_Options_15__c from survey__c where id=:surveyids];
   }
  }
  showsurveysel=true;
  showquestion=false;
    
}
 
 
 public void getsurvrid() 
 {
   System.debug('Survey Id------' + surveyids);
   System.debug('VRid------' + VRids);
   
 }

 public PageReference Cancelreturn()
  {   
    if(taskId != null)
      {
      pr = new PageReference('/'+taskId);
      }
      pr.setRedirect(true);
      return pr;
      
  } 
  public void Previous()
 {
    showquestion=false;
    showsurveysel=true;
    
 }
 public PageReference saveandbre()
      {
        taskId=Apexpages.currentPage().getParameters().get('tskid');
          system.debug('--stidd--'+stidd);
          if(tsk.Survey_Taken__c!=null)
          {
          system.debug('st--i amhere'+st.Survey_Response_1__c);
          if(VRids !=null){
          st.SurveyTakenByVehicle__c=VRids;
            }
            try{
            update st;
            }catch(Exception e){}
          }else
          {
            system.debug('st--'+st.Survey_Response_1__c);
             try{
             if(VRids !=null){
              st.SurveyTakenByVehicle__c=VRids;
               }
             insert st;
             tsk.Survey_Taken__c=st.id;
             update tsk;
             }catch(Exception e){}
          }
        
         PageReference pr = new PageReference('/'+st.id);
          pr.setRedirect(true);
          return pr;
          
      } 
  public void getsurveys()
 {  
   if(st.Survey_Taking_Status__c == 'Finish' && st.Survey_Taken_Date_Time__c == null)
   {
   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Survey Taken Date/Time'));
   }else
   {
   showquestion=true;
   showsurveysel=false;
   surveySoql = '';
   multisplit = new List<String>();
   objectFields =  new List<String>();  
   listquestions = new List<String>();
   listresponseop = new List<String>(); 
   
   
   if(surveyids!=null)
   {
   try{
   survey=[Select id,name,selected_questions_to_display__c,(Select Survey_Response_1__c,Survey_Response_2__c,Survey_Response_3__c,Survey_Response_4__c,Survey_Response_5__c,Survey_Response_6__c,Survey_Response_7__c,Survey_Response_8__c,Survey_Response_9__c,Survey_Response_10__c,Survey_Response_11__c,Survey_Response_12__c,Survey_Response_13__c,Survey_Response_14__c,Survey_Response_15__c from SurveyTakers1__r),survey_question_1__c,Survey_Response_Options_1__c,survey_question_2__c,Survey_Response_Options_2__c,survey_question_3__c,Survey_Response_Options_3__c,survey_question_4__c,Survey_Response_Options_4__c,survey_question_5__c,Survey_Response_Options_5__c,survey_question_6__c,Survey_Response_Options_6__c,survey_question_7__c,Survey_Response_Options_7__c,survey_question_8__c,Survey_Response_Options_8__c,survey_question_9__c,Survey_Response_Options_9__c,survey_question_10__c,Survey_Response_Options_10__c,survey_question_11__c,Survey_Response_Options_11__c,survey_question_12__c,Survey_Response_Options_12__c,survey_question_13__c,Survey_Response_Options_13__c,survey_question_14__c,Survey_Response_Options_14__c,survey_question_15__c,Survey_Response_Options_15__c from survey__c where id=:surveyids];
   system.debug('survey---'+survey);
   }
   catch(Exception e)
       {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select the active questions to display for '+survey.name));
       }
       try{
       if(survey.selected_questions_to_display__c !=null){
        multisplit.addAll(survey.selected_questions_to_display__c.split(';'));
        system.debug('selected questions-----'+multisplit);
         for(String s : multisplit)
         {
            soqlque = 'survey_question_'+s+'__c';
            system.debug('soqlque---'+soqlque);
             listquestions.add(soqlque);
             system.debug('listquestions---'+listquestions);
            soqlresop = 'Survey_Response_Options_'+s+'__c';
            listresponseop.add(soqlresop);
            soqlstres='Survey_Response_'+s+'__c';
            system.debug('soqlstres---'+soqlstres);
            
         }
         
         system.debug('sq--'+listquestions);
         system.debug('SRO'+listresponseop);
       
       }
       }catch(Exception e){
         system.debug('squ--'+listquestions);
         system.debug('SROu'+listresponseop);
         //system.debug('STRu'+liststresponse);
       }
        String type='Survey__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
        system.debug(fieldMap.values());
        String typeST='SurveyTaker__c';
        Map<String, Schema.SObjectType> STschemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType STSchema = STschemaMap.get(typeST);
        Map<String, Schema.SObjectField> fieldMap1 = STSchema.getDescribe().fields.getMap();
        
        system.debug(fieldMap1.values());
        for (String fieldName: fieldMap.keySet()) {
        
        System.debug('##Field API Name='+fieldName);// list of all field API name
        System.debug('##Field API Name1='+listquestions);
         for(String questionlist1: listquestions) {
          System.debug('##Field API Name1='+questionlist1);
            if(fieldName.equalsIgnoreCase(questionlist1))
             {
              objectFields.add(questionlist1);
             }
        }
        for(String responseoplist1: listresponseop) {
          System.debug('##Field API Name1='+responseoplist1);
            if(fieldName.equalsIgnoreCase(responseoplist1))
             {
              objectFields.add(responseoplist1);
             }
        } 
        } 
        /*for (String fieldNamest: fieldMap1.keySet()) {
         System.debug('##Field API NameST='+fieldNamest);// list of all field API name
        System.debug('##Field API Name1ST='+listresponse);
         for(String responselistst: listresponse) {
          System.debug('##Field API Name1st='+responselistst);
            if(fieldNamest.equalsIgnoreCase(responselistst))
             {
              objectFieldst.add(responselistst);
             }
        }
        }*/
        system.debug('objectFields--->'+objectFields);
       // system.debug('objectFields--->'+objectFieldst);
        Integer i = 0;
        Integer j = 0;
        String fieldsToFetch = '';
        String fieldsToFetchst = '';
        for(String temp:objectFields)
        {       
            Integer len = objectFields.size();
            if(i==len-1)
            {
                  fieldsToFetch = fieldsToFetch + temp;
            }
            else
            {
                  fieldsToFetch = fieldsToFetch + temp + ',';
            }
            i++;
        } 
       /* for(String temp1:objectFieldst)
        {       
            Integer len = objectFieldst.size();
            if(j==len-1)
            {
                  fieldsToFetchst = fieldsToFetchst + temp1;
            }
            else
            {
                  fieldsToFetchst = fieldsToFetchst + temp1 + ',';
            }
            j++;
        } */
        
        surveySoql ='select ' + fieldsToFetch +' from Survey__c where id='+'\''+surveyids+'\''; 
        //,(Select'+ fieldsToFetchst +')
        try{
        system.debug('surveySoql--'+surveySoql);
        
        survey1 = Database.query(surveySoql);
        
        system.debug('survey1survey1'+survey1);
        }
        catch(Exception e)
        {
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select the active questions to display for '+survey.name));
        }
        
   }
  
   }
 }
  
  
 }