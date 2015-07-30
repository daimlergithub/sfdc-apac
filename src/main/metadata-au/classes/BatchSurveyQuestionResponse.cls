global class BatchSurveyQuestionResponse implements Database.Batchable<sObject>{
    
    global Set<String> sqrSet;
    global BatchSurveyQuestionResponse(Set<String> sqrSet){      
        this.sqrSet = sqrSet;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        
         return Database.getQueryLocator([Select id,name,Total_Responses__c from Survey_Question__c where Id IN :this.sqrSet]);
    }

	global void execute(Database.BatchableContext BC, List<Survey_Question__c> scope){    
 			map<id,Survey_Question__c> mapid= new map<id,Survey_Question__c>(); 
            set<id> setId= new set<Id>();
            for(Survey_Question__c objSQ: scope)
            {
                setId.add(objSQ.Id);
            }
            if(setId!=null && !setId.isempty())
            {
                list<SurveyQuestionResponse__c> lstSQR=[Select id,Survey_Question__c from SurveyQuestionResponse__c where Survey_Question__c IN:setId];
                
                if(lstSQR!=null && !lstSQR.isEmpty())
                {	integer i=1;
                    for(Survey_Question__c objSQ: scope)
                    {
                        for(SurveyQuestionResponse__c objSQR: lstSQR)
                        {
                            if(objSQ.id==objSQR.Survey_Question__c)
                                objSQ.Total_Responses__c=i++;
                        }
                    }
                 	update scope;
                }
            }         
    }
    
    global void finish(Database.BatchableContext BC){
    }
}