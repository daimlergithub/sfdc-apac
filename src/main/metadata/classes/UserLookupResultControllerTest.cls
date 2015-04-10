/*
    Type:       Page Controller
    ---------------------------------------------------------------
    History:
    
    1. 2014-03-27 Created By Justin Yu
*/
@isTest
public class UserLookupResultControllerTest {
	
	@isTest 
	static void testUserLookupResultController(){
		Test.startTest();
		PageReference page = new PageReference('/apex/UserLookupResult?type=assignment');
		Test.setCurrentPage(page);
		UserLookupResultController controller = new UserLookupResultController();
		Test.stopTest();
	}
}