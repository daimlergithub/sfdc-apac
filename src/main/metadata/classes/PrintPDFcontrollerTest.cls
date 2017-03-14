@isTest
Public class PrintPDFcontrollerTest  {
    public static Lead__c objLead;
    
    
    public static testMethod void GenerateTest()
    {
        init();
        Test.startTest();
        ApexPages.currentPage().getParameters().put('String','objLead.id');     
        ApexPages.StandardController objSc = new ApexPages.StandardController(objLead);
        PrintPDFcontroller  objLeadController = new PrintPDFcontroller(objSc);
        
        //Start test
        
        
        //Stop Test
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