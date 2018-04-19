/************************************************************************************
* Created By:Sarath M
* Created Date:16-Mar-18
* Company:Infosys Ltd
* Description:Test class for BBq Rank Calculation
*********************************************************************************************/
@isTest
public class BbqRankCalculation_test {
    public static testMethod void BbqTest(){
        BBQRankingMarkets__c obj = new BBQRankingMarkets__c(name='SG');
        insert obj;        
        employee__c emp=new employee__c(First_Name__c='Test',Last_Name__c='Infy',UserName__c='Infosys',Email__c='testBBq@daimler.com',market__c='SG');
        insert emp;       
		String CRON_EXP = '0 0 0 * * ? ';  
        test.startTest();
            BbqRankCalculation batch=new BbqRankCalculation();
            String jobId = System.schedule('Update Rank', CRON_EXP,batch);
        test.stopTest();
        System.assertnotEquals(emp.id,null);
        
    }   
    public static testMethod void BbqJPTest(){
        BBQRankingMarkets__c obj = new BBQRankingMarkets__c(name='JP');
        insert obj;      
        employee__c emp=new employee__c(First_Name__c='Test',Last_Name__c='Infy',UserName__c='Infosys',Email__c='testBBq@daimler.com',market__c='JP');
        insert emp;         String CRON_EXP = '0 0 0 * * ? ';  
        test.startTest();
            BbqRankCalculation batch=new BbqRankCalculation();
            String jobId = System.schedule('Update Rank', CRON_EXP,batch);
        test.stopTest();
        System.assertnotEquals(emp.id,null);
    }  
}