public class SubmitSuveryTaken {

    public SubmitSuveryTaken() {

    }

    public Boolean showquestion{get;set;}
    public Boolean display{get;set;}
    public Boolean showsurveysel{get;set;}
    public SurveyTaker__c st{get;set;}
    public Survey__c survey{get;set;}
    public Survey__c survey1{get;set;}
    public List<Survey__c> lstObjs{get;set;}
    public Static Id accountidd{get;set;}
    public string surveyids{get;set;}
    public string VRids{get;set;}
    public List<String> multisplit{get; private set;}
    public List<String> listquestions{get;set;}
    public List<String> listresponse{get;set;}
    Public string soqlque{get;set;}
    Public string soqlres{get;set;}
    public List<String> objectFields {get;set;}     
     public PageReference pr;
    public String surveySoql;
    public SubmitSuveryTaken(ApexPages.StandardController controller) {
        st= (SurveyTaker__c)controller.getRecord();
        showsurveysel=true;
        showquestion=false;
        
    }
     
      public void Previous()
     {
        showquestion=false;
        showsurveysel=true;
        
     }
      public void getsurvrid() {
       System.debug('Survey Id------' + surveyids);
       System.debug('VRid------' + VRids);
       
           }
      public PageReference Cancelreturn()
      {   
          accountidd=Apexpages.currentPage().getParameters().get('accid');
          string pre=Survey__c.getSObjectType().getDescribe().getKeyprefix();
          if(accountidd != null)
          {
          pr = new PageReference('/'+accountidd);
          }
          pr.setRedirect(true);
          return pr;
          
      }    
      public PageReference saveandbre()
      {
        accountidd=Apexpages.currentPage().getParameters().get('accid');
        try{
          update survey1;
          try{
          st = [Select id,Survey__c,SurveyTakenByVehicle__c,Account__c from SurveyTaker__c where Survey__c=:surveyids and Account__c=:accountidd];
		   if(VRids !=null){
          st.SurveyTakenByVehicle__c=VRids;
          }
		  update st;
          }
          catch(Exception e)
          {
          st=new SurveyTaker__c();
          st.Survey__c=surveyids;
          
          if(VRids !=null){
          st.SurveyTakenByVehicle__c=VRids;
          }
          if(accountidd!=null)
          {
           st.Account__c=accountidd;
          }
         insert st;
         }
        }catch(Exception e){}
        
         PageReference pr = new PageReference('/'+accountidd);
          pr.setRedirect(true);
          return pr;
          
      } 
     public void getsurveys()
     {  
       showquestion=true;
       showsurveysel=false;
       surveySoql = '';
       multisplit = new List<String>();
       objectFields =  new List<String>();  
       listquestions = new List<String>();
       listresponse = new List<String>();
       system.debug('SurveyTaker__c.Survey__c');
       try{
       survey=[Select id,name,selected_questions_to_display__c,survey_question_1__c,survey_response_1__c,survey_question_2__c,survey_response_2__c,survey_question_3__c,survey_response_3__c,survey_question_4__c,survey_response_4__c,survey_question_5__c,survey_response_5__c,survey_question_6__c,survey_response_6__c,survey_question_7__c,survey_response_7__c,survey_question_8__c,survey_response_8__c,survey_question_9__c,survey_response_9__c,survey_question_10__c,survey_response_10__c from survey__c where id=:surveyids];
       
       }catch(Exception e)
      {
       
       }
       
      
       try{
       if(survey.selected_questions_to_display__c !=null){
        multisplit.addAll(survey.selected_questions_to_display__c.split(';'));
        system.debug('selected questions-----'+multisplit);
         for(String s : multisplit)
         {
            soqlque = 'survey_question_'+s+'__c';
            listquestions.add(soqlque);
            soqlres = 'survey_response_'+s+'__c';
            listresponse.add(soqlres);
         }
         system.debug(listquestions);
         system.debug(listresponse);
       }
       }catch(Exception e){
        
       }
     
       
        String type='Survey__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
         system.debug(fieldMap.values());
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
        for(String responselist1: listresponse) {
          System.debug('##Field API Name1='+responselist1);
            if(fieldName.equalsIgnoreCase(responselist1))
             {
              objectFields.add(responselist1);
             }
        } 
        } 
        system.debug('objectFields--->'+objectFields);
        Integer i = 0;
        String fieldsToFetch = '';
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
         
        surveySoql ='select ' + fieldsToFetch +' from Survey__c where id='+'\''+surveyids+'\''; 
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