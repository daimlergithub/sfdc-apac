public class PrepopulateInsighstWrapper {    
      
      @AuraEnabled public string questiontext;
      @AuraEnabled public string answerText;
        
      public PrepopulateInsighstWrapper(String questiontext,String answerText)
      {
          this.questiontext = questiontext;
          this.answerText = answerText;
      }
}