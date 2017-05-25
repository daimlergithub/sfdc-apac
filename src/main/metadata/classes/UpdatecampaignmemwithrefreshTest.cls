@isTest
public class UpdatecampaignmemwithrefreshTest {
    public static Campaign objParentCamp;
    public static Campaign objParentCamp1;
    public static Campaign objChildCamp;
    public static Campaign objChildCamp2;
    public static Campaign_Member__c objCampMember;
    public static Campaign_Member__c objCampMember1;
    public static Campaign_Member__c objCampMember2;
    public static Campaign_Member__c objCampMember3;
    public static Account perAcc;
    public static Address__c perAccAddress;
    public static Address__c perAccAddress2;
    public static Retail_Task__c objRtltask;
    public static Retail_Task__c objRtltask1;
    public static Vehicle__c testVehicleMB;
    public static Vehicle_Relationship__c testVR;
    public static Vehicle_Relationship__c testVR1;
    public static Retail_Campaign__c retailParentCampFin;
    public static Retail_Campaign__c retailParentCampSales;
    public static Retail_Campaign__c retailChildCamp;
    public static Retail_Campaign__c retailChildCamp2;
    public static Id parentCampRecordTypeId = Schema.SobjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
    public static Id childCampRecordTypeId = Schema.SobjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();   
    public static Id perAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id ContractRtlTskRecordType= Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Contract').getRecordTypeId();
    public static Id VRRecordTypeId=Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId();
    
    @isTest
    public static void testmethodRefreshcampaignmemberFin(){
      createData();
        test.startTest();
           String campId = objChildCamp.Id; 
           Updatecampaignmemwithrefresh.Refreshcampaignmember(campId);
          
        createRetailCampaignData();
        String campId1 = retailChildCamp.Id;
          // Updatecampaignmemwithrefresh.Refreshretcampaignmember(campId1);
        test.stopTest();
    }
   
    @isTest
    public static void testmethodRefreshcampaignmemberSales2(){
      createData();
        test.startTest();
           String campId = objChildCamp2.Id; 
           Updatecampaignmemwithrefresh.Refreshcampaignmember(campId);
           createRetailCampaignData();
           String campId1 = retailChildCamp2.Id;
           //Updatecampaignmemwithrefresh.Refreshretcampaignmember(campId1);
        test.stopTest();
    }
    
    public static void createData(){
        // ParentCampaign 
         objParentCamp =new Campaign(Name='Finance test'
                                 ,Campaign_Execution_Channels__c = 'eMail'
                              ,StartDate = System.today()
                                 ,EndDate = System.today() +60
                                 ,Status = 'Draft'
                                 ,Campaign_Type__c ='Finance'
                                 ,recordTypeId = parentCampRecordTypeId    
                                 );
        insert objParentCamp;
         objParentCamp1 =new Campaign(Name='test Sales'
                                 ,Campaign_Execution_Channels__c = 'OB'
                              ,StartDate = System.today()
                                 ,EndDate = System.today() +60
                                 ,Status = 'Draft'
                                 ,Campaign_Type__c ='Sales'
                                 ,recordTypeId = parentCampRecordTypeId    
                                 );
        insert objParentCamp1;
        
        // ChildCampaign
        objChildCamp = new Campaign(Name='childtest'
                                   ,ParentId=objParentCamp.Id
                                   ,Execution_Start_Date__c  = System.today()+2
                                   ,Segmentation_Date__c = System.today()+ 5
                                   ,Segmentation_Base__c = 'Vehicle' 
                                   ,Execution_Type__c = 'eMail'
                                   ,recordTypeId = childCampRecordTypeId 
                       );
        insert objChildCamp;
      
        objChildCamp2 = new Campaign(Name='childtest2'
                                   ,ParentId=objParentCamp1.Id
                                   ,Execution_Start_Date__c  = System.today()+2
                                   ,Segmentation_Date__c = System.today()+ 5
                                   ,Segmentation_Base__c = 'Vehicle' 
                                   ,Execution_Type__c = 'eMail'
                                   ,recordTypeId = childCampRecordTypeId 
                       );
        insert objChildCamp2;
        
        createTestData();
        
        //Campaign Member
        objCampMember = new Campaign_Member__c(Campaign_ID__c =objChildCamp.Id,Contact_Id__c=perAcc.Id,Status__c='Ready'
                                              ,Contract__c=objRtltask.Id,Address__c=perAccAddress2.Id,Vehicle_Relationship__c=testVR.Id
                                              );       
        insert objCampMember;
        objCampMember1 = new Campaign_Member__c(Campaign_ID__c =objChildCamp.Id,Contact_Id__c=perAcc.Id,Status__c='Ready'
                                              ,Contract__c=objRtltask1.Id,Address__c=perAccAddress2.Id,Vehicle_Relationship__c=testVR1.Id
                                              );       
        insert objCampMember1;
        objCampMember2 = new Campaign_Member__c(Campaign_ID__c =objChildCamp2.Id,Contact_Id__c=perAcc.Id,Status__c='Ready'
                                              ,Contract__c=objRtltask.Id,Address__c=perAccAddress2.Id,Vehicle_Relationship__c=testVR.Id
                                              );       
        insert objCampMember2;
        objCampMember3 = new Campaign_Member__c(Campaign_ID__c =objChildCamp2.Id,Contact_Id__c=perAcc.Id,Status__c='Ready'
                                              ,Contract__c=objRtltask1.Id,Address__c=perAccAddress2.Id,Vehicle_Relationship__c=testVR1.Id
                                              );       
        insert objCampMember3;
        
    }
    static void createRetailCampaignData(){
        retailParentCampFin =new Retail_Campaign__c(Name='Finance',Campaign_Type__c='Finance');
        insert retailParentCampFin;
        
        retailParentCampSales = new Retail_Campaign__c(Name='Sales',Campaign_Type__c='Sales');
        insert retailParentCampSales;
        
         Id retailrecid= Schema.SobjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
        retailChildCamp = new Retail_Campaign__c(Name='Child1',Parent_Campaign1__c=retailParentCampFin.Id,Segmentation_Base__c='Vehicle',RecordTypeId=retailrecid);
        insert retailChildCamp;
        
        retailChildCamp2 = new Retail_Campaign__c(Name='Child3',Parent_Campaign1__c=retailParentCampSales.Id,Segmentation_Base__c='Vehicle',RecordTypeId=retailrecid);
        insert retailChildCamp2;
        createTestData();
        
       
        //Campaign Member
        objCampMember = new Campaign_Member__c(Retail_Campaign_Id__c =retailChildCamp.Id,Contact_Id__c=perAcc.Id,Status__c='Ready'
                                              ,Contract__c=objRtltask.Id,Address__c=perAccAddress2.Id,Vehicle_Relationship__c=testVR.Id
                                              );       
        insert objCampMember;
        objCampMember1 = new Campaign_Member__c(Retail_Campaign_Id__c =retailChildCamp.Id,Contact_Id__c=perAcc.Id,Status__c='Ready'
                                              ,Contract__c=objRtltask1.Id,Address__c=perAccAddress2.Id,Vehicle_Relationship__c=testVR1.Id
                                              );       
        insert objCampMember1;
        objCampMember2 = new Campaign_Member__c(Retail_Campaign_Id__c =retailChildCamp2.Id,Contact_Id__c=perAcc.Id,Status__c='Ready'
                                              ,Contract__c=objRtltask.Id,Address__c=perAccAddress2.Id,Vehicle_Relationship__c=testVR.Id
                                              );       
        insert objCampMember2;
        objCampMember3 = new Campaign_Member__c(Retail_Campaign_Id__c =retailChildCamp2.Id,Contact_Id__c=perAcc.Id,Status__c='Ready'
                                              ,Contract__c=objRtltask1.Id,Address__c=perAccAddress2.Id,Vehicle_Relationship__c=testVR1.Id
                                              );       
        insert objCampMember3;
        
    }
    static void createTestData(){
        // Person Account and Address
        perAcc = new Account(Lastname='Person',mobile__c='09748561252',recordTypeId=perAccRecordTypeId);
        insert perAcc;
        perAccAddress = new Address__c(Customer__c =perAcc.Id,Address_Type__c='Home',Province__c='Iwate',ZipCode__c='1234567'
                                      ,TitleOfHonor__c='To Person',Address_Line_1__c='Line 1',Address_Line_2__c='Line 2'
                                      ,Block__c='Block',City__c= 'City');
         insert perAccAddress;
        perAccAddress2 = new Address__c(Customer__c =perAcc.Id,Address_Type__c='Business',Province__c='Akita',ZipCode__c='1238527'
                                      ,TitleOfHonor__c='To Person',Address_Line_1__c='Line 1',Address_Line_2__c='Line 2'
                                      ,Block__c='Block',City__c= 'City');
         insert perAccAddress2;
        //Retail Task
          objRtltask = new Retail_Task__c(Name='RTask',Account__c=perAcc.Id,Type__c='Service Program'
                                         ,Contractor_Address1_Native__c ='Address Native',Contractor_Address3_Native__c='Address3',recordTypeId=ContractRtlTskRecordType);
          insert objRtltask;
           objRtltask1 = new Retail_Task__c(Name='RTask',Account__c=perAcc.Id,Type__c='Service Program'
                                         ,Contractor_Address3_Native__c='Address3',recordTypeId=ContractRtlTskRecordType);
          insert objRtltask1;
        // Vehicle 
          testVehicleMB = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222',
                                                Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345'), UtilConstant.MB);
        //Vehicle Relationship 
          testVR  = new Vehicle_Relationship__c(RegistrationProvince__c = 'Shanghai'
                             ,Registration_City__c = 'Shanghai'
                                               ,Status__c = '0=Previously Owned'
                             ,Main_Usage__c = '0=Taxi'
                             ,Ownership__c = '1=Company'
                             ,Car_Relation__c = 'User'
                             ,New_Used__c = '0=New'
                             ,Validity__c = 'Unknown'
                               ,Purchase_Date__c = System.today()
                             ,Registration_Date__c = System.today()
                                   ,Contact__c = perAcc.Id
                             ,Vehicle_ID__c = testVehicleMB.Id
                                               ,vehicle_address__c= perAccAddress.Id
                                               );                                      
         insert testVR;
        testVR1  = new Vehicle_Relationship__c(RegistrationProvince__c = 'Shanghai'
                             ,Registration_City__c = 'Shanghai'
                                               ,Status__c = '0=Previously Owned'
                             ,Main_Usage__c = '0=Taxi'
                             ,Ownership__c = '1=Company'
                             ,Car_Relation__c = 'User'
                             ,New_Used__c = '0=New'
                             ,Validity__c = 'Unknown'
                               ,Purchase_Date__c = System.today()
                             ,Registration_Date__c = System.today()
                                   ,Contact__c = perAcc.Id
                             ,Vehicle_ID__c = testVehicleMB.Id
                                               ,vehicle_address__c= perAccAddress2.Id
                                               );                                      
         insert testVR1;
        
    }
}