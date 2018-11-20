/**************************************************************************************************************************************************************************** 
* File Name     : FactoryHelperTest
* Description   : Factory Helper Test Class to Test Factory MetaData record
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Raju & 03/09/2018
******************************************************************************************************************************************************************/ 
@isTest
private class FactoryHelperTest {
	@isTest 
    static void TestMetaDataRec(){
        Factory_Fields__mdt factFldmdt = [SELECT market__c,Class_Name__c, Component_Name__c,Record_Type__c,sObject__c FROM Factory_Fields__mdt 
                                          WHERE market__c = 'TestMarket' and Label = 'FactoryTest' limit 1];
        String market = factFldmdt.Market__c;
        String componentName = factFldmdt.Component_Name__c;
        String className = factFldmdt.Class_Name__c;
        String obj = factFldmdt.sObject__c;
        String recType= factFldmdt.Record_Type__c;
        test.startTest();
        Factory_Fields__mdt mdt = FactoryHelper.getMetaDataRec(market, componentName);
        System.assertEquals(mdt.Market__c, market);
        Factory_Fields__mdt mdata = FactoryHelper.getMetaDataRec(obj, market, recType, componentName);
        system.assertEquals(mdata.sObject__c, obj);
        test.stopTest();  
        
         
    }
    @isTest
    static void testFactEcpetion1(){
        try{
           FactoryHelper.getMetaDataRec('', 'Test'); 
        }
        catch(Exception e){
            
        }
    }
    @isTest
    static void testFactEcpetion2(){
        try{
           FactoryHelper.getMetaDataRec('Test', '', null, null) ;
           //FactoryHelper.getMetaDataRec(obj, market, recordType, componentName);
        }
        catch(Exception e){
            
        }
    }    
}