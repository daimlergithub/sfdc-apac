@isTest
Public class MassUpdatenewAssignedusercontrollerTest{
    public static testMethod void PsotivetestMethod(){
        
    List<Account> accList = new List<Account>();    
    Account acc = new Account(FirstName ='testAcc',lastName ='testAcc', recordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
    accList.add(acc);
    insert accList;
    
     List<sobject> vecleList = new List<sobject>();    
     Vehicle__c vecle = new Vehicle__c (Brand__c='Mercedes-Benz',Related_contact__c=accList[0].id);
     vecleList.add(vecle);
     insert vecle ;
    
      Account_Link__c al=new Account_Link__c(Name='new al',
      toRole__c=accList[0].id,
      Vehicle__c=vecleList[0].id,
      Retail_Sales_Consultant__c=accList[0].ownerId,
      Service_Advisor__c=accList[0].ownerId,
      
      RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
      );
   
       insert al;

    MassUpdatenewAssignedusercontroller.WrapperMassUpdate wmu= new MassUpdatenewAssignedusercontroller.WrapperMassUpdate(al);
    List<MassUpdatenewAssignedusercontroller.WrapperMassUpdate> wmulst= new List<MassUpdatenewAssignedusercontroller.WrapperMassUpdate>();
    
    List<Account> accListD = new List<Account>();    
    Account accD = new Account(Name ='testAccDealer',recordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId());
    accListD.add(accD);
    insert accListD;  
    
    List<Contact> ccList = new List<Contact>();    
    Contact cc= new Contact(Lastname='testAcc',AccountId=accListD[0].id,Dealer_Complaint_Gate_Keeper__c =True,Federation_ID__c='1234');
    ccList.add(cc);
    insert ccList;
    
    List<Lead__c> leadList = new List<Lead__c>();    
    Lead__c ledc = new Lead__c(Lead_Type__c='New car',CAC_Lead_Status__c='new',Contact__c=accList[0].id,Assigned_Dealer__c=accListD[0].id);
    leadList.add(ledc);
    insert leadList ;
        
    MassUpdatenewAssignedusercontroller.WrapperMassUpdate wmu1= new MassUpdatenewAssignedusercontroller.WrapperMassUpdate(ledc);    
    List<MassUpdatenewAssignedusercontroller.WrapperMassUpdate> wmulst1= new List<MassUpdatenewAssignedusercontroller.WrapperMassUpdate>();
    
        
    
    
    MassUpdatenewAssignedusercontroller.WrapperMassUpdate wmu2= new MassUpdatenewAssignedusercontroller.WrapperMassUpdate(al);
    List<MassUpdatenewAssignedusercontroller.WrapperMassUpdate> wmulst2= new List<MassUpdatenewAssignedusercontroller.WrapperMassUpdate>();
    
    List<Case> caseList = new List<Case>();    
    Case case1= new Case(AccountId=accList[0].id,status='Waiting for Response approval');
    caseList.add(case1);
    insert caseList;        
    
    MassUpdatenewAssignedusercontroller.WrapperMassUpdate wmu3= new MassUpdatenewAssignedusercontroller.WrapperMassUpdate(case1);    
    List<MassUpdatenewAssignedusercontroller.WrapperMassUpdate> wmulst3= new List<MassUpdatenewAssignedusercontroller.WrapperMassUpdate>();
        
    MassUpdatenewAssignedusercontroller Munauc = new MassUpdatenewAssignedusercontroller();
        Munauc.accUsr.ownerid=UserInfo.getUserId();
        Munauc.NewAsignUsr.Dealer_Lead_Gate_Keeper__c =UserInfo.getUserId(); 
        Munauc.NewAsignUsr.Portal_Apply_User__c = UserInfo.getUserId();
        Munauc.getLeads();
        Munauc.getCases();
        Munauc.getVehicles();
        Munauc.getAccounts();
        Munauc.getUserDetails();
        Munauc.disPlayNewAssignUserInfo();
        Munauc.getFields();
        
        Munauc.massUpdateNewAssign();
   // WrapperMassUpdate
}
}