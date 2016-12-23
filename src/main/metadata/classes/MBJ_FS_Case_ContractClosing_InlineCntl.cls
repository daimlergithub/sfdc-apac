public class MBJ_FS_Case_ContractClosing_InlineCntl{
    Public Case caseRec{get;set;}
    public MBJ_FS_Case_ContractClosing_InlineCntl(ApexPages.StandardController controller) {
        if(ApexPages.currentPage().getParameters().get('id') != null){
            caseRec = [select id,Case_Type__c from Case where id = :ApexPages.currentPage().getParameters().get('id')];   
        }
    }
}