/**************************************************************************************************************************************************************************** 
* File Name     : AccountContactDetailsControllerLTGTest
* Description   : This Class is Unit test for the AccountContactDetailsControllerLTG.  
* Copyright     : Daimler
* @author       : Infosys 
* Author Modification & Ver.Date : Raju & 02/10/2018
******************************************************************************************************************************************************************************/ 
@isTest
public class AccountContactDetailsControllerLTGTest {
	@isTest
    public static void testfetchFields(){
        test.startTest();
        User usr = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
        System.runAs(usr) {
            string cmpname ='AccountContactDetails';
            AccountContactDetailsDefinition accConDet = AccountContactDetailsControllerLTG.fetchFields(cmpname);
            system.debug('result'+accConDet);
            system.assertNotEquals(accConDet.apiLabelMap, null);
        }
         test.stopTest();
    }
    
   @isTest
    public static void testfetchFieldsException(){
        test.startTest();
        User usr = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
        System.runAs(usr) {
            string cmpname =' ';
            try{
                AccountContactDetailsControllerLTG.fetchFields(cmpname);
                system.debug('result'+AccountContactDetailsControllerLTG.fetchFields(cmpname));  
            }
            catch(Exception e){
                
            }
        }
        test.stopTest();
    }
    @isTest
    public static void testRetrieveFields(){
        test.startTest();
        User usr = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
        System.runAs(usr) {
            try{
                List<String> fieldSetNames = new list<String> { 'Input' , 'output' , 'Button' };
                String objectName='Account';
                RetrieveFieldsFromFieldSetsController.getFieldSetValues(fieldSetNames, objectName);
            }catch(Exception e){
                
            }
        }
    }
    @isTest
    public static void testfetchFieldsException2(){
        test.startTest();
        User usr = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
        string cmpname ='AccountContactDetails';
        System.runAs(usr) {  
            Factory_Fields__mdt factRec = [SELECT market__c,Class_Name__c, Component_Name__c,Record_Type__c,sObject__c,Input_Fields__c FROM Factory_Fields__mdt 
                                           WHERE Label = 'FactoryTestExceptions' limit 1];
            system.debug('FactoryRec'+factRec.Input_Fields__c);
            try{
                
                AccountContactDetailsControllerLTG.fetchFields(factRec.Component_Name__c);
                //system.debug('result'+AccountContactDetailsControllerLTG.fetchFields(cmpname));  
            }
            catch(Exception e){
                
            }
        }
        test.stopTest();
    }
     @isTest
    public static void testfetchFieldsException3(){
        test.startTest();
        try{
            AccountContactInfoDefault avb = new AccountContactInfoDefault();
        	avb.getFields();
        }
        catch(Exception e){}
         test.stopTest();
    }
    
}