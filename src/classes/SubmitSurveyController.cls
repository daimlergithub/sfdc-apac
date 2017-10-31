public without sharing class SubmitSurveyController{

    public String surveyID;
    private string nextString='Next';
    public String taskID;
    public String campaignId;
    public String contactID;
    public Boolean showPreviousButton {set;get;}
    public Boolean finishSurvey {set;get;}
    public Map<ID,String> answeredQuestion = new Map<ID,String>();
    public Map<ID,String> reponseNotes = new Map<ID,String>();
    public Map<ID,ID> QAIdMapping = new Map<ID,ID>();
    public Survey__c survey {set;get;}
    public String operationType {set;get;}
    public List<Question> allQuestions {set;get;}
    public Question OneQuestion {set;get;}
    public SurveyTaker__c surveyTaker {set;get;}

    public SubmitSurveyController(){
        init();
    }
    /**@Description  Based on surveyID,it checks for Survey_Taking_Status__c in SurveyTaker__c object.Based on survey taken status field it starts the surveytaking process.
      *              If Survey_Taking_Status__c is "finish" it completes the survey or if finishsurvey is false it will set some questions for survey.      
      *@author
      *@Date 11/03/2015
    */
    
    
    private void init(){
        finishSurvey = false;
        operationType = Apexpages.currentPage().getParameters().get('type');
        if ('preview'.equalsIgnoreCase(operationType)) {
             surveyID = Apexpages.currentPage().getParameters().get('surveyID');
        } else if ('submit'.equalsIgnoreCase(operationType)){
            campaignId = Apexpages.currentPage().getParameters().get('campaignID');
            surveyID = [SELECT Questionnaire__c FROM Campaign WHERE id =: campaignId Limit 1].Questionnaire__c;
            taskID = Apexpages.currentPage().getParameters().get('taskID');
            contactID = Apexpages.currentPage().getParameters().get('contactID');
            if (surveyID instanceOf id) {
                for (SurveyTaker__c st : [SELECT id, Last_Answered_Question__c,Last_Answered_Question__r.OrderNumber__c,Survey_Taking_Status__c FROM SurveyTaker__c
                                           WHERE Task_ID__c =: taskID AND survey__c =: surveyID]) {
                    surveyTaker = st;
                }
                if (surveyTaker != null) {
                    if (surveyTaker.Survey_Taking_Status__c == 'Finish') {
                        
                         finishSurvey = true;
                        showPreviousButton = false;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.VF_SubmitSurvey_FinishSurvey_Msg));
                        
                        
                    } else {
                        for (SurveyQuestionResponse__c sqr : [SELECT id, Response__c, Survey_Question__c, SurveyTaker__c, Note__c FROM SurveyQuestionResponse__c
                                                               WHERE SurveyTaker__c =: surveyTaker.id]) {
                            answeredQuestion.put(sqr.Survey_Question__c, sqr.Response__c == null ? '':sqr.Response__c);
                            reponseNotes.put(sqr.Survey_Question__c, sqr.Note__c == null ? '':sqr.Note__c);
                            QAIdMapping.put(sqr.Survey_Question__c, sqr.id);
                        }                       
                       
                    }
                }
            }
        }
       survey = [SELECT id, Survey_Header__c, Name, Thank_You_Text__c FROM Survey__c WHERE id =:surveyID Limit 1];
       List<Survey_Question__c> questionList = [SELECT Type__c, Id, Survey__c, Required__c, Question__c, Need_Free_TextBox__c,
                                                                OrderNumber__c, Name, Choices__c, Redirect_Question_Number__c, Single_FreeText_Next_Question_No__c
                                                         FROM   Survey_Question__c
                                                         WHERE  Survey__c =:surveyID AND Choices__c!=Null ORDER BY OrderNumber__c];
         system.debug('+++++++'+questionList);                                                
        if (surveyID instanceOf id && (!questionList.isEmpty())){
            if (!finishSurvey) {               
                List<Question> customQuestionList = new List<Question>();
                Integer showQuestionOrder = 1;
                for (Survey_Question__c q : questionList){
                    Question theQ;
                    if (answeredQuestion.containsKey(q.id)) {
                        theQ = new Question(q,answeredQuestion.get(q.id),reponseNotes.get(q.id));
                        theQ.surveyResponseID = QAIdMapping.get(q.id);
                    } else {
                        theQ = new Question(q,'','');
                    }
                    theQ.showQuestionOrder = showQuestionOrder.format();
                    customQuestionList.add(theQ);
                    showQuestionOrder++;
                }
                allQuestions = customQuestionList;
                if ( surveyTaker==null || surveyTaker.Last_Answered_Question__c == null) {
                    
                     if (survey.Survey_Header__c == null || survey.Survey_Header__c == '') {
                        
                         //as the survey header is blank, we will set one question.
                        OneQuestion = getQuestion(1,false,nextString);
                        
                       
                    } else {
                        
                         //Get the 0 question to show the welcome page
                        OneQuestion = getQuestion(0,false,nextString);
                        
                       
                    }
                    
                    
                    
                } else {
                    
                    //Get the question which usered answered in previous operation
                    OneQuestion = getQuestion(Integer.valueOf(surveyTaker.Last_Answered_Question__r.OrderNumber__c),true,nextString);                   
                    
                    
                }
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.VF_SubmitSurvey_ErrorMsg_Invalid_ID));
        }
    }

    /** InnerClass: Question
      *@Description Retrieves the Survey Question information and puts it in the Question inner Class
      *@author
      *@Date 11/03/2015
    */
     
     
    public class Question{
        public String surveyResponseID {set;get;}
        public Survey_Question__c surveyQuestion {get;set;}
        public String   textValue                {get;set;}
        public String   noteForResponse          {get;set;}
        public String   showQuestionOrder        {get;set;}
        public String   previousQuestionOrder    {get;set;}
        public Map<Integer,Integer> redirectQuestionNumber {get;set;}
        public String   selectedOption           {get;set;}
        public List<String> selectedOptions      {get;set;}
        public List<SelectOption> singleOptions  {get;set;}
        public List<SelectOption> multiOptions   {get;set;}
        public List<SelectOption> rowOptions     {get;set;}
        public Boolean   renderFreeText          {get;set;}
        public Boolean   renderSelectRadio       {get;set;}
        public Boolean   renderSelectCheckboxes  {get;set;}
        public Boolean   renderSelectRow         {get;set;}
        public boolean showFirstPage    {get;set;}
        public boolean showLastPage     {get;set;}

        public Question(){
            surveyQuestion = new Survey_Question__c();
        }

        /**@Description Fills up the Question object
         *@author
         *@Date 11/03/2015
         *  param:sq-Survey_Question__c
         */
        public Question(Survey_Question__c sq, String response, String note) {
            surveyQuestion = sq;
            noteForResponse = note;
            showFirstPage = false;
            showLastPage =  false;
            selectedOption = '';
            selectedOptions = new List<String>();
            redirectQuestionNumber = new Map<Integer,Integer>();
            if ('Single Select--Vertical'.equalsIgnoreCase(sq.Type__c)){
                renderSelectRadio = true;
                renderSelectCheckboxes = false;
                renderFreeText = false;
                renderSelectRow = false;
                singleOptions = stringToSelectOptions(sq.Choices__c, sq.Need_Free_TextBox__c);
                redirectQuestionNumber = stringToRedirectQuestionNumber(sq.Redirect_Question_Number__c, sq.Single_FreeText_Next_Question_No__c);
                if (response !='' && response != null) {
                    if (sq.Choices__c.contains(response)) {
                        selectedOption = getOptionValue(singleOptions,response).get(0);
                    } else {
                        selectedOption = '-1';
                        textValue = response;
                    }
                }
            } else if ('Multi-Select--Vertical'.equalsIgnoreCase(sq.Type__c)){
                renderSelectCheckboxes = true;
                renderSelectRadio = false;
                renderFreeText = false;
                renderSelectRow =  false;
                multiOptions = stringToSelectOptions(sq.Choices__c,sq.Need_Free_TextBox__c);
                selectedOptions = getOptionValue(multiOptions,response);
            } else if ('Single Select--Horizontal'.equalsIgnoreCase(sq.Type__c)){
                renderSelectCheckboxes = false;
                renderSelectRadio = false;
                renderFreeText = false;
                renderSelectRow = true;
                rowOptions = stringToSelectOptions(sq.Choices__c, sq.Need_Free_TextBox__c);
                redirectQuestionNumber = stringToRedirectQuestionNumber(sq.Redirect_Question_Number__c, sq.Single_FreeText_Next_Question_No__c);
                if (response !='' && response != null) {
                    if (sq.Choices__c.contains(response)) {
                        selectedOption = getOptionValue(rowOptions,response).get(0);
                    } else {
                        selectedOption = '-1';
                        textValue = response;
                    }
                }
            } else if ('Free Text'.equalsIgnoreCase(sq.Type__c)){
                renderFreeText = true;
                renderSelectRadio = false;
                renderSelectCheckboxes = false;
                renderSelectRow = false;
                textValue = response;
            }
        }

        /**@Description Splits up the string as given by the user and adds each option to a list to be displayed as option on the Visualforce page.
          *@author
          *@Date 11/03/2015
          *  param: str-  String as submitted by the user
          *  returns the List of SelectOption for the visualforce page
          */
        private List<SelectOption> stringToSelectOptions(String str, Boolean needFreeTextBox){
            if (str == ''){
                return new List<SelectOption>();
            }
            List<String> strList = str.split('\n');

            List<SelectOption> returnVal = new List<SelectOption>();
            Integer i = 0;
            for(String s: strList){
                if (s!='' && s!= 'null' && s!= null) {
                    returnVal.add(new SelectOption(String.valueOf(i),s.trim()));
                }
                i++;
            }
            if (needFreeTextBox) {
                returnVal.add(new SelectOption('-1', System.Label.VF_SubmitSurvey_Other_Picklist));
            }
            return returnVal;
        }

        /**@Description  once user answered the questions, when they answer again will show the value which they answered before
          *@author
          *@Date 11/03/2015
          *  Param Options-List of Selectoption 
          *  returns list of String
          */
        private List<String> getOptionValue(List<SelectOption> options, String response){
            List<String> result = new List<String>();
            for(SelectOption so : options){
                for (String s : response.split('\n')) {
                    if (s.equalsIgnoreCase(so.getLabel())){
                        result.add(so.getValue());
                    }
                }
            }
            return result;
        }

        /** @Description Get the question redirect order
           *@author
           *@Date 11/03/2015
          *  param: string   redirect question number configuration
          *  returns Map redirect order
          */
        private Map<Integer,Integer> stringToRedirectQuestionNumber(String str, Decimal otherRedirectNo){
            if (str == '' || str == null){
                return new Map<Integer,Integer>();
            } else {
                Map<Integer,Integer> redirectQuestionNumber = new Map<Integer,Integer>();
                Integer i = 0;
                for(String s : str.split('\n')){
                    if (s!='' && s!=null && s!='null'){
                        redirectQuestionNumber.put(i,Integer.valueOf(s.trim()));
                    }
                    i++;
                }
                //for other picklist value, the redirect number infomation
                if (otherRedirectNo != null) {
                    redirectQuestionNumber.put(-1, Integer.valueOf(otherRedirectNo));
                }
                return redirectQuestionNumber;
            }
        }
    }

    /** @Description get the question which show on the page
       *@author
       *@Date 11/03/2015
      *  param: Integer question Order, Boolean whether redirected question, String direction to decide click whick button
      *  returns Inner Class Question
      */
    private Question getQuestion(Integer questionOrderNumber, Boolean redirectedQuestion, String direction) {
        Question q = new Question();
        if (questionOrderNumber == 0) {   // the first welcome page
            q.surveyQuestion.OrderNumber__c = 0 ;
            q.showQuestionOrder = '0';
            q.showFirstPage = true;
            showPreviousButton = false;
        } else {
            showPreviousButton = true;
            if (redirectedQuestion){
                Boolean lastQuestionFlag = true;
                for(Question question : allQuestions){
                    if (question.surveyQuestion.OrderNumber__c == questionOrderNumber){
                        lastQuestionFlag = false;
                        q = question;
                        break;
                    }
                }
                if (lastQuestionFlag){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.VF_SubmitSurvey_ErrorMsg_Redirected));
                    return null;
                }
            } else {
                Boolean lastQuestionFlag = true;
                for(Question question : allQuestions){
                    if (question.showQuestionOrder == questionOrderNumber.format()){
                        lastQuestionFlag = false;
                        q = question;
                        break;
                    }
                }
                if (lastQuestionFlag){
                    q.surveyQuestion.OrderNumber__c = allQuestions.get(allQuestions.size()-1).surveyQuestion.OrderNumber__c + 1 ;
                    q.showQuestionOrder = (allQuestions.size() + 1).format();
                    q.showLastPage = true;
                }
            }
            //only click next buttion, set the previous question order value
            if (nextString.equalsIgnoreCase(direction)){
                if (OneQuestion == null) {
                    q.previousQuestionOrder = null;
                    showPreviousButton = false;
                } else {
                    q.previousQuestionOrder = OneQuestion.surveyQuestion.orderNumber__c.format();
                }
            }
        }
        return q;
    }

    /**@Description next button function
      *@author
      *@Date 11/03/2015
      */
    public void getNextQuestion() {
        Boolean result = true;
        //insert the question response data beside the first and last page
        if ( !OneQuestion.showFirstPage && !OneQuestion.showLastPage && 'submit'.equalsIgnoreCase(operationType)) {
            result = upsertSurveyData(OneQuestion);
        }
        if (result) {
            //load the next question
            if ('Single Select--Vertical'.equalsIgnoreCase(OneQuestion.surveyQuestion.Type__c) || 'Single Select--Horizontal'.equalsIgnoreCase(OneQuestion.surveyQuestion.Type__c)) {
                if (OneQuestion.selectedOption != null && OneQuestion.selectedOption != '' && OneQuestion.redirectQuestionNumber.size() > 0) {
                    OneQuestion = getQuestion(OneQuestion.redirectQuestionNumber.get(Integer.valueOf(OneQuestion.selectedOption)),true,nextString);
                } else {
                    OneQuestion = getQuestion( Integer.valueOf(OneQuestion.showQuestionOrder) + 1,false,nextString);
                }
            } else {
                OneQuestion = getQuestion( Integer.valueOf(OneQuestion.showQuestionOrder) + 1,false,nextString);
            }
        }
    }

    /** @Description previous button function,once user click previous button, system will empty this question's answer
      *@author
      *@Date 11/03/2015
      */
    public void getPreviousQuestion(){
        
        for(Question q : allQuestions){
            if (q.showQuestionOrder == OneQuestion.showQuestionOrder){
                q.textValue = '';
                q.selectedOption = '';
                q.selectedOptions = new List<String>();
                q.noteForResponse = '';
                break;
            }
        }
        //update the reponse data
        if (OneQuestion.surveyResponseID instanceOf id) {
            SurveyQuestionResponse__c sqr = new SurveyQuestionResponse__c();
            sqr.id = OneQuestion.surveyResponseID;
            sqr.Response__c = '';
            sqr.Note__c = '';
            update sqr;
        }
        //the previous question is the last thanks page, we shoud take the special logic
        if ( Integer.valueOf(OneQuestion.previousQuestionOrder) == allQuestions.get(allQuestions.size()-1).surveyQuestion.OrderNumber__c + 1){
            Question lastQuestion = new Question();
            lastQuestion.surveyQuestion.OrderNumber__c = allQuestions.get(allQuestions.size()-1).surveyQuestion.OrderNumber__c + 1 ;
            lastQuestion.showQuestionOrder = (allQuestions.size()+1).format();
            lastQuestion.showLastPage = true;
            lastQuestion.previousQuestionOrder = OneQuestion.surveyQuestion.orderNumber__c.format();
            OneQuestion = lastQuestion;
        } else {
            OneQuestion = getQuestion(Integer.valueOf(OneQuestion.previousQuestionOrder),true,'Previous');
        }
        //update survey taken last answered question
        if (surveyTaker != null) {
            surveyTaker.Last_Answered_Question__c = OneQuestion.surveyQuestion == null ?  null:OneQuestion.surveyQuestion.id;
            update surveyTaker;
        }
    }

    /**@Description return button function
      *@author
      *@Date 11/03/2015
      */
    public PageReference submitSurvey(){
        if (surveyTaker!=null) {
            surveyTaker.Last_Answered_Question__c = OneQuestion.surveyQuestion == null ?  null:OneQuestion.surveyQuestion.id;
            surveyTaker.Survey_Taking_Status__c = 'Finish';
            try {
                update surveyTaker;
            } catch (exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            }
        }
        return null;
    }

    /** @Description insert the survey response result and survey taken information
       *@author
       *@Date 11/03/2015
      */
   @TestVisible private Boolean upsertSurveyData(Question q){
        Boolean result = true;
        Savepoint sp = Database.setSavepoint();
        //insert the survey response information
        String response = '';
        if (q.renderSelectRadio) {
            if (q.selectedOption != null && q.selectedOption != '') {
                if ('-1'.equalsIgnoreCase(q.selectedOption)) { //others free text data
                    if(q.textValue == null || q.textValue == ''){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.VF_SubmitSurvey_FillNote_Msg));
                        result = false;
                        return result;
                    } else {
                        response = q.textValue;
                    }
                } else {
                    response = q.singleOptions.get(Integer.valueOf(q.selectedOption)).getLabel();
                }
            }
        } else if (q.renderFreeText) {
            if (q.textValue != null && q.textValue != '') {
                response = q.textValue;
            }
        } else if (q.renderSelectCheckboxes) {
            for (String opt : q.selectedOptions) {
                if (opt != '' && opt != null) {
                    response = response + q.multiOptions.get(Integer.valueOf(opt)).getLabel() + '\n';
                }
            }
        } else if (q.renderSelectRow) {
            if (q.selectedOption != null && q.selectedOption != ''){
                if ('-1'.equalsIgnoreCase(q.selectedOption)) { //others free text data
                    if (q.textValue == null || q.textValue == '') {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.VF_SubmitSurvey_FillNote_Msg));
                        result = false;
                        return result;
                    } else {
                        response = q.textValue;
                    }
                } else {
                    response = q.rowOptions.get(Integer.valueOf(q.selectedOption)).getLabel();
                }
            }
        }
        //insert the survey taker information
        if (surveyTaker == null) {
            surveyTaker = new SurveyTaker__c();
            surveyTaker.Contact__c = contactID;
            surveyTaker.Campaign__c = campaignId;
            surveyTaker.Task_ID__c = taskID;
            surveyTaker.Survey__c = surveyID;
            surveyTaker.Last_Answered_Question__c = OneQuestion.surveyQuestion == null ?  null:OneQuestion.surveyQuestion.id;
            try {
                insert surveyTaker;
            } catch (exception ex) {
                Database.rollback(sp);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
                result = false;
                return result;
            }
        } else {
            surveyTaker.Last_Answered_Question__c = OneQuestion.surveyQuestion == null ? null:OneQuestion.surveyQuestion.id;
            try {
                update surveyTaker;
            } catch (exception ex) {
                Database.rollback(sp);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
                result = false;
                return result;
            }
        }
        //insert the survey response information
        SurveyQuestionResponse__c sqr = new SurveyQuestionResponse__c();
        sqr.Response__c = response;
        sqr.Note__c = q.noteForResponse;
        sqr.Survey_Question__c = q.surveyQuestion.Id;
        sqr.SurveyTaker__c = surveyTaker.id;
        try {
            if (q.surveyResponseID instanceOf id) {
                sqr.id = q.surveyResponseID;
                update sqr;
            } else {
                insert sqr;
                for(Question qestion : allQuestions){
                    if (qestion.showQuestionOrder == q.showQuestionOrder){
                        qestion.surveyResponseID = sqr.id;
                        break;
                    }
                }
            }
        } catch (exception ex) {
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            result = false;
            return result;
        }
        return result;
    }
    /**@Description Clicking break button the survey will jump to last page(end page).
      *@author
      *@Date 11/03/2015
     */ 
    //click break button function
    public PageReference breakSurvey(){
        Boolean result = true;
        //insert the question response data beside the first and last page
        if ( !OneQuestion.showFirstPage && !OneQuestion.showLastPage && 'submit'.equalsIgnoreCase(operationType)) {
            result = upsertSurveyData(OneQuestion);
        }
        if (result) {
            Question lastQuestion = new Question();
            lastQuestion.surveyQuestion.OrderNumber__c = allQuestions.get(allQuestions.size()-1).surveyQuestion.OrderNumber__c + 1 ;
            lastQuestion.showQuestionOrder = (allQuestions.size()+1).format();
            lastQuestion.showLastPage = true;
            lastQuestion.previousQuestionOrder = OneQuestion.surveyQuestion.orderNumber__c.format();
            OneQuestion = lastQuestion;
        }
        return null;
    }
}