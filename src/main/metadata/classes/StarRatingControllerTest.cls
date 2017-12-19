/************************************************************************************
* Created By:Sarath M
* Created Date:11-Dec-17
* Company:Infosys Ltd
* Description: Testclass for starRatingControllerTest
* ***********************************************************************************/
@isTest
public class StarRatingControllerTest {
    
    static testmethod void test_createRatingDB(){
        ideas__c ideaTest=Rug_util.newIdea(); 
        Decimal rating=0;
        rating =4;
        test.startTest();
        StarRatingController.createRatingDB(rating,ideaTest.id);
        system.assertNotEquals(null, ideaTest.id);
        test.stopTest();
    }
    static testMethod void test_getRatingOnLoad(){
        ideas__c ideaTest=Rug_util.newIdea(); 
        Integer num=StarRatingController.getRatingOnLoad(ideaTest.Id);
        System.assertnotEquals(null,num);
    }
    static testMethod void test_getPointsCount(){
        ideas__c ideaTest=Rug_util.newIdea();
        IdeasVoting__c ideaVotingObj = new IdeasVoting__c(Ideas__c = ideaTest.id, rating__c= 4,Likeuser__c=userinfo.getUserId());
        Integer num=StarRatingController.getPointsCount(ideaTest.Id);
        System.assertnotEquals(null,num);
    }
    static testMethod void test_getRatingEnableValue(){
        user testHonorary=Rug_util.honoraryProfileUser();
        ideas__c ideaTest=Rug_util.newIdea();
        system.runas(testHonorary){
            boolean result=StarRatingController.getRatingEnableValue(ideaTest.Id);        
            System.assertEquals(false,result);  
        }
    } 
    
}