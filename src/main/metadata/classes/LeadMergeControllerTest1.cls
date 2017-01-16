@isTest
public class LeadMergeControllerTest1 {

    public static Lead__c objMaster;
    public static Lead__c objSlave;
    private static User user;
    private static DM_Request__c dmrequest;
    private static DM_Material__c material;
    private static SurveyTaker__c SurveyTaker;
   
    public static testmethod void init(){
          User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
          // Insert account as current user
          System.runAs (thisUser) {
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
            UserRole r = [SELECT Id FROM UserRole Limit 1];
            user = new User(alias = 'testDaim', email='testDaim@acme.com', 
                emailencodingkey='UTF-8', lastname='Smith', 
                languagelocalekey='en_US', 
                localesidkey='en_US', profileid = p.Id, userroleid = r.Id,
                timezonesidkey='America/Los_Angeles', 
                username='testDaim@acme.com');
            insert user;           
          }
          Account objContact = new Account();               
          objContact = (Account)UtilTestData.createSobject(objContact,UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
          objMaster=new Lead__c(Lead_Type__c='New Car',CAC_Lead_Status__c='New',Contact__c=objContact.Id,Service_Advisor__c=user.Id);
          objMaster = (Lead__c)UtilTestData.createSobject(objMaster,UtilTestData.LEAD_RT_SALES_LEADS);
          objSlave=new Lead__c(Lead_Type__c='Used Car',CAC_Lead_Status__c='New',Contact__c=objContact.Id,Service_Advisor__c=user.Id);
          objSlave=(Lead__c)UtilTestData.createSobject(objSlave,UtilTestData.LEAD_RT_SALES_LEADS);
          
          Material = new DM_Material__c();
          Material.Name='testname';
          insert Material;
          
          dmrequest= new  DM_Request__c();
         // dmrequest.Status__c='to be sent'; 
          dmrequest.Customer_Name__c=objContact.id;
          dmrequest.Sending_Address__c='Home';
          dmrequest.TitleOfHonor__c = 'To Person';
          dmrequest.Status2__c='Success';
          dmrequest.Expected_DM_Material1__c=Material.id;
          dmrequest.Expected_DM_Material2__c=Material.id;
          dmrequest.Expected_DM_Material3__c=Material.id;
          dmrequest.Status1__c='Success';
          dmrequest.Status3__c='Success';
          dmrequest.Sent_Date__c=system.today().addDays(-10);  
          dmrequest.Lead__C=  objSlave.Id;      
          insert dmrequest;    
          
          SurveyTaker= new SurveyTaker__c();
          SurveyTaker.Lead__c=  objSlave.Id;   
          insert  SurveyTaker;
     }
        
    public static testMethod void testrejectDup() {
        init();   
        Apexpages.currentpage().getparameters().put('id',objMaster.Id);
        Apexpages.currentpage().getparameters().put('idselectedValue',objSlave.Id);      
        ApexPages.StandardController objLead = new ApexPages.StandardController(objMaster);
        LeadMergeController objLeadController = new LeadMergeController(objLead);     
        Test.startTest();
        objLeadController.rejectDup();      
        Test.stopTest(); 
    }
   public static testMethod void testMergeDup() {
        init();    
        Apexpages.currentpage().getparameters().put('id',objMaster.Id);
        Apexpages.currentpage().getparameters().put('idselectedValue',objSlave.Id);    
        ApexPages.StandardController objLead = new ApexPages.StandardController(objMaster);
        LeadMergeController objLeadController = new LeadMergeController(objLead);     
        Test.startTest();
        objLeadController.mergeDup();      
        Test.stopTest(); 
    }
     public static testMethod void testMergeLead() {
        init(); 
        Apexpages.currentpage().getparameters().put('id',objMaster.Id);
        Apexpages.currentpage().getparameters().put('selectedValue',objSlave.Id);       
        ApexPages.StandardController objLead = new ApexPages.StandardController(objMaster);
        LeadMergeController objLeadController = new LeadMergeController(objLead); 
        System.runAs ( new User(Id = UserInfo.getUserId()) ){
           user = (User)UtilTestData.createUser('Central', UtilConstant.PROFILE_SALES_LEAD_SOFT_DELETED);
        }     
        PageReference pageRef = Page.LeadMerge;
        pageRef.getParameters().put('selectedValue',objSlave.Id);
        Test.setCurrentPage(pageRef);
        objLeadController.Slave=objSlave;
        objLeadController.Master=objMaster;  
        objslave.OwnerId = user.Id; 
        objslave.Lead_Lost_Date_Time__c=date.today();
        objslave.Related_Leads__c=objMaster.id;
        objslave.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead__c', 
           UtilConstant.RECORDTYPE_SALES_LEAD_SOFT_DELETED);
        update objslave;        
        Test.startTest();                           
        objLeadController.MergeLead();      
        Test.stopTest(); 
      }
    public static testMethod void testwrap(){
        List<LeadMergeController.LeadWrapper> leadwrap=new List<LeadMergeController.LeadWrapper>();
        LeadMergeController.LeadWrapper wrap=new LeadMergeController.LeadWrapper();
      Test.startTest();
    // LeadWrapper wrap=new LeadWrapper();
              wrap.fieldLabel='Name';
            wrap.fieldAPI='name';
            wrap.isMasterNull=false;
            wrap.isSlaveNull=true;
            wrap.isSame=false;
            wrap.isMasterChecked=true;
            wrap.isSlaveChecked=false;
        //leadwrap.add(wrap);
        
        // insert leadwrap;
        Test.stopTest();
       // system.assertEquals(expected, actual)
    }
    //Tested selectAll Method for master record
    public static testMethod void testselectAllMaster() {
        init();      
        Apexpages.currentpage().getparameters().put('id',objMaster.Id);
      //  Apexpages.currentpage().getparameters().put('selectedValue',objSlave.Id);                 
        ApexPages.StandardController objAcc = new ApexPages.StandardController(objMaster);
        //Instantiate and construct the controller class.     
        LeadMergeController objLeadController= new LeadMergeController(objAcc);
        objLeadController.Slave=objSlave;
        objLeadController.Master=objMaster; 
        objLeadController.selectAllParam ='Master';       
        // Start Test
        Test.startTest();
        // Choose all master value as default
        objLeadController.selectAllParam =System.Label.master;
        objLeadController.selectAll();
        // Stop Test
        Test.stopTest();
    }    
   //Tested selectAll Method for slaverecord
    public static testMethod void testselectAllSlave() {
        init();       
        Apexpages.currentpage().getparameters().put('id',objMaster.Id);
    //    Apexpages.currentpage().getparameters().put('idselectedValue',objSlave.Id);                
        ApexPages.StandardController objAcc = new ApexPages.StandardController(objMaster);
        //Instantiate and construct the controller class.     
        LeadMergeController objLeadController= new LeadMergeController(objAcc);
        objLeadController.Slave=objSlave;
        objLeadController.Master=objMaster; 
        objLeadController.selectAllParam ='Slave';
        // Start Test
        Test.startTest();
        // Choose all master value as default
        objLeadController.selectAllParam =System.Label.slave;
        objLeadController.selectAll();
        // Stop Test
        Test.stopTest();
    }
      //Tested Previous Method 
     public static testMethod void testPrevious() {
        init();   
        Apexpages.currentpage().getparameters().put('id',objMaster.Id);
      //  Apexpages.currentpage().getparameters().put('idselectedValue',objSlave.Id); 
        ApexPages.currentPage().getParameters().put('retURL','/apex/SelectSlaveLead?Id='+objMaster.id);                 
        ApexPages.StandardController objAcc = new ApexPages.StandardController(objMaster);
        //Instantiate and construct the controller class.     
        LeadMergeController objLeadController = new LeadMergeController(objAcc);       
        // Start Test
        Test.startTest();        
        PageReference PreviousUrl=objLeadController.previous();
        // Stop Test
        Test.stopTest();  
      //  system.assertEquals(PreviousUrl.getURL(),System.Label.apex_SelectSlaveAccount+objMaster.Id);
    }
    //Tested Previous Cancel
    public static testMethod void testCancel() {
        init(); 
        Apexpages.currentpage().getparameters().put('id',objMaster.Id);
     //   Apexpages.currentpage().getparameters().put('idselectedValue',objSlave.Id);               
        ApexPages.StandardController objAcc = new ApexPages.StandardController(objMaster);
        //Instantiate and construct the controller class.     
        LeadMergeController objLeadController = new LeadMergeController(objAcc);   
        objLeadController.Slave=objSlave;
        objLeadController.Master=objMaster;      
        // Start Test
        system.debug('objLeadController >>>>>>'+objLeadController );
        Test.startTest();
        objLeadController.cancel();
        // Stop Test
        Test.stopTest();        
       // system.assertEquals(cancelUrl.getURL(),'/'+objMaster.Id);      
    }
    
    
    
}