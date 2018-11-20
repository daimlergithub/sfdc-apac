public class QuestionWrapperClass { 
    @AuraEnabled public string recordId;
    @AuraEnabled public string surveyName;
    @AuraEnabled public string questionId;
    @AuraEnabled public String answerId;
    @AuraEnabled public string questionText;
    @AuraEnabled public string questionContext;
    @AuraEnabled public string questionAnswerText;
    @AuraEnabled public string questionType;
    @AuraEnabled public boolean isPicklist;
    @AuraEnabled public boolean isMultiPicklist;
    @AuraEnabled public  List<CustomSelectOption> lstSelectOptions;
    @AuraEnabled public  List<String> lstSelectedOptions;
   

    public QuestionWrapperClass()
    {
         recordId = '';
         surveyName = '';
         questionId = '';
         answerId = '';
         questionText = '';
         questionContext = '';
         questionAnswerText='';
         questionType='';
         isPicklist =false;
         isMultiPicklist=false;
         lstSelectOptions= new List<CustomSelectOption>();
         lstSelectedOptions=new List<String>();
    }
}