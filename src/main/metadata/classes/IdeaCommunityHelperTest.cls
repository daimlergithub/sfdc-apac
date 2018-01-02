/************************************************************************************
* Created By:Sarath M
* Created Date:21-sept-17
* Company:Infosys Ltd
* Description: 
1. Testclass for IdeaCommunityHelper controller
* ***********************************************************************************/

@isTest
public class IdeaCommunityHelperTest {
    
    static testMethod void test_IncrementCount(){
        
        ideas__c ideaTest1=Rug_util.newIdea();
        IdeaEditing__c cust=new IdeaEditing__c();
        cust.EditingAccess__c=false;
        insert cust;
        test.startTest();
        integer voteCount=IdeasCommunityHelper.getIncrementCount(ideaTest1.id);
        System.assertnotEquals(null,voteCount);
        test.stopTest();
    }
    static testMethod void test_IdeaCount(){
        ideas__c ideaTest=Rug_util.newIdea(); 
        Integer num=IdeasCommunityHelper.getIdeaCount(ideaTest.Id);
        System.assertnotEquals(null,num);
    }
    static testMethod void test_getLikeEnableValue(){
        user testhonorary=Rug_util.honoraryProfileUser();
        ideas__c ideaTest=Rug_util.newIdea();
        system.runas(testhonorary){
            boolean result=IdeasCommunityHelper.getLikeEnableValue(ideaTest.Id);        
            System.assertEquals(true,result);  
        }
    } 
    static testMethod void test_recentandtopIdeas(){
        IdeasCommunityHelper.getRecent5IdeaCount();
        IdeasCommunityHelper.getTop5IdeaCount();    
    }
	static testMethod void test_getReputationPoints(){
        string name='RUG';
        integer recordCount=5;
        IdeasCommunityHelper.getReputationPoints(name,recordCount);
    }
}