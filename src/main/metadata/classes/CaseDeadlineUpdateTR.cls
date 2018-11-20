public class CaseDeadlineUpdateTR {
    
    public static final Id caseINquiryId = RecordTypeAccessService.getRecordTypeId('Case',Label.Case_Record_Type_Inquiry); 
    public static final Id caseMBComplaintRec_Id = RecordTypeAccessService.getRecordTypeId('Case',Label.Case_Record_Type_Complaint);
    
    @InvocableMethod
    public static void updateCaseDeadLineAmount(List<case> caselist){
        
        List <Case> uppCase = new List<Case>(); 
        Set<Id> Ids = new Set<Id>();
        for(case cs:caselist){
            Ids.add(cs.Id);
        }
        
        List<Case> cases = [Select id,deadline__c,recordtypeId,Data_Source__c from case where id IN :Ids];
        for(Case cs:cases){
            Datetime dow = System.now();
            if(cs.recordtypeId == caseINquiryId)
                dow = dow + 1;
            else if (cs.recordtypeId == caseMBComplaintRec_Id)
                dow = dow + 5;
            string dayOfWeek = dow.format('E');
            if(dayOfWeek =='Sat'){
                cs.deadline__c = dow + 2;
            }
            else if(dayOfWeek =='Sun'){
                cs.deadline__c = dow + 1;
            }
            else
                cs.deadline__c = dow;  
            
            uppCase.add(cs);
        }
        
        if(uppCase.size()>0){
            update uppCase;
        }
    }
}