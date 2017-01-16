@isTest
Public with sharing class SSIVINMatchProcessTest
{
 public static testmethod void testAll() {
 
 Test.StartTest();
 SSIVINMatchProcess sp=new SSIVINMatchProcess();
        SSIVINMatchProcess.runProcess();
        Test.StopTest();
        system.assertNotEquals(null,sp);
    }
}