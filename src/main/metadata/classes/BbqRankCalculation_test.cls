/************************************************************************************
* Created By:Sarath M
* Created Date:16-Mar-18
* Company:Infosys Ltd
* Description:Test class for BBq Rank Calculation
*********************************************************************************************/
@isTest
public class BbqRankCalculation_test {
    public static testMethod void BbqTest(){
        employee__c emp=new employee__c(First_Name__c='Test',Last_Name__c='Infy',UserName__c='Infosys',Email__c='testBBq@daimler.com');
        insert emp;        
        String CRON_EXP = '0 0 0 2 6 ? 2022'; 
        test.startTest();
            BbqRankCalculation batch=new BbqRankCalculation();
            Database.executeBatch(batch);            
            String jobId = System.schedule('Update Rank', CRON_EXP,batch);
        test.stopTest();
        System.assertnotEquals(emp.id,null);
        
    }          
}