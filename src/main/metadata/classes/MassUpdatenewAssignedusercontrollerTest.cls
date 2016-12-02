@isTest
Public class MassUpdatenewAssignedusercontrollerTest{
    public static testMethod void PsotivetestMethod(){
    
    List<Account> accList = new List<Account>();    
    Account acc = new Account(FirstName ='testAcc',lastName ='testAcc', MBK_Data_Source__c = 'MB Card', recordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
    accList.add(acc);
    insert accList;
    
    List<Contact> ccList = new List<Contact>();    
    Contact cc= new Contact(Lastname='testAcc');
    ccList.add(cc);
    insert ccList;
    
    List<Lead__c> leadList = new List<Lead__c>();    
    Lead__c ledc = new Lead__c(Lead_Type__c='New car',CAC_Lead_Status__c='new',Contact__c=accList[0].id);
    leadList .add(ledc);
    insert leadList ;
    
    List<Vehicle__c > vecleList = new List<Vehicle__c >();    
    Vehicle__c vecle = new Vehicle__c (Brand__c='Mercedes-Benz',Related_contact__c=accList[0].id);
    vecleList .add(vecle);
    insert vecleList ;
    
    MassUpdatenewAssignedusercontroller Munauc = new MassUpdatenewAssignedusercontroller();
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