public class UtilSurveyQuestionResponse {
    public static void countSurveyQuestionResponseRecordsOnParent(List<SurveyQuestionResponse__c> listSqr){
        
        Set<String> sqrSet = new Set<String>();
        
        for(SurveyQuestionResponse__c sqrObj : listSqr){
            if(sqrObj.Survey_Question__c != null){
                sqrSet.add(sqrObj.Survey_Question__c);
            }
        }
        
        if(!sqrSet.isEmpty())
        {
            map<id,Survey_Question__c> mapid= new map<id,Survey_Question__c>(); 
            
            mapid.clear();
            for(Survey_Question__c objSQ: [Select id,name,Total_Responses__c,(Select id,name,Survey_Question__c from Survey_Question_Answers__r)from Survey_Question__c where Id IN :sqrSet])
            {
                mapid.put(objSQ.id,objSQ);
            }
            if(mapid!=null && !mapid.isempty())
            {
                for(id obj:mapid.keySet())
                {
                    Survey_Question__c survey=mapid.get(obj);
                    survey.Total_Responses__c=survey.Survey_Question_Answers__r.size();                
                }
                update mapid.values();
            }     
            
        }
    }
}