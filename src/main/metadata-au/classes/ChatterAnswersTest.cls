@isTest
public class ChatterAnswersTest {
    static testMethod void testcreateAccount(){
        ChatterAnswers obj= new ChatterAnswers();
       String testID= obj.createAccount('firstname', 'lastname', userInfo.getUserId());
        system.assertNotEquals(null, testID);
    }
}