@isTest
public class MBJ_FS_Case_Request_InlineTest {
    public static testmethod void main(){
       // List<Case> CasesLst=new List<Case>();//
        Case Caseobj1=new Case();
        Caseobj1.Case_Type__c='Early Termination';
        insert Caseobj1;
        
      
        Test.Starttest();
       
         
        ApexPages.currentPage().getParameters().put('id',Caseobj1.id);
        String id = ApexPages.currentPage().getParameters().get('id');
        system.assertEquals(true,id!=null);
        Case CaseInserted=new Case();
        CaseInserted=[select id,Case_Type__c from case where id = :id];

      
        ApexPages.StandardController stdController = new ApexPages.StandardController(caseobj1);
        MBJ_FS_Case_Request_InlineController ext=new MBJ_FS_Case_Request_InlineController(stdController);
        
       
        
        //CaseInserted=
        Test.Stoptest();
  
        
        
    }

}