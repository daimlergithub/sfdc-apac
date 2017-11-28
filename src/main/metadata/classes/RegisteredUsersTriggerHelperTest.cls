/************************************************************************************
* Created By:Sarath M
* Created Date:23-Sept-2017
* Company:Infosys Ltd
* Description: Test Class for RegisteredUsersTriggerHandler
* **********************************************************************************/
@istest
public class RegisteredUsersTriggerHelperTest{  
   
    private static testMethod void test_submitForApproval(){
        
        list<Registered_Users__c> regList=new list<Registered_Users__c>(); 
        regList = Rug_util.Registereduser();
        System.assertEquals(true,regList.size()>0);        
     
        
    }
    private static testMethod void test_CommunityuserCreation(){
        Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
        user user2 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user2 );
        system.runas(user2 ){
         test.startTest();
          list<PermissionSet> ps1 = [SELECT Id FROM PermissionSet WHERE Name =:label.assignRugPermissionSet];
         if(ps1.size()==0){
            PermissionSet ps = new PermissionSet();
            ps.Name = 'Company_Community_for_Force_com';
            ps.Label = 'Company_Community_for_Force_com';
            insert ps;
        }
        user user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user1 );
        system.runas(user1 ){
        list<Registered_Users__c> registeredUserList=new list<Registered_Users__c>();    
        list<Registered_Users__c> registeredUserApprovedList=new list<Registered_Users__c>();
        registeredUserList = Rug_util.Registereduser();
        System.assertEquals(true,registeredUserList.size()>0); 
        for(Registered_Users__c reg: registeredUserList){
            reg.Request_Status__c='Approved';            
            registeredUserApprovedList.add(reg);
        }
        
        update registeredUserApprovedList;       
        
        try{  
        RegisteredUsersTriggerHelper.communityUserCreation(registeredUserApprovedList[0]); 
        }catch(Exception e){}
        test.stopTest();      
        }
       }
    }   
    
}