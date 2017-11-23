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
        list<Registered_Users__c> registeredUserList=new list<Registered_Users__c>();    
        list<Registered_Users__c> registeredUserApprovedList=new list<Registered_Users__c>();
        registeredUserList = Rug_util.Registereduser();
        System.assertEquals(true,registeredUserList.size()>0); 
        for(Registered_Users__c reg: registeredUserList){
            reg.Request_Status__c='Approved';            
            registeredUserApprovedList.add(reg);
        }
        update registeredUserApprovedList;
        test.startTest();        
        RegisteredUsersTriggerHelper.communityUserCreation(registeredUserApprovedList[0]); 
        test.stopTest();           
    }   
    
}