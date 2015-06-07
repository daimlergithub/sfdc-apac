@isTest
public class ChatterAnswersTest {
    static testMethod void testcreateAccount(){
        ChatterAnswers obj= new ChatterAnswers();
        obj.createAccount('firstname', 'lastname', userInfo.getUserId());
    }
}