@isTest

public class CommunityErrorControllerTest{

public static testmethod void TestPageLevelAction(){

Test.starttest();

CommunityErrorController obj = new CommunityErrorController();
//obj.failingPageResponse = 'Maximum view state size limit (135KB) exceeded';
obj.japanesePageResponse = '';
obj.PageLevelAction();
 
Test.stoptest();



}



}