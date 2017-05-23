@isTest
Public class PrintPDFTest  {
public static Lead__c objLead;  
  public static testMethod void GenerateTest()
    {
     init();
     Test.startTest();
     ApexPages.currentPage().getParameters().put('Id','objLead.id');     
     ApexPages.StandardController objSc = new ApexPages.StandardController(objLead);
   try{
    PrintPDFcontroller  objLeadController = new PrintPDFcontroller(objSc); 
    }Catch(exception e){}   
     Test.stopTest();     
    }
    // creating record for Case
  public static void init()
    {         
        objLead= new Lead__c(); 
        objLead.Lead_Type__c = 'New Car';        
        insert objLead;
    }  
}