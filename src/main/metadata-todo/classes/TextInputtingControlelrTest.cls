/*
    Type:       Test Class
    Purpose:    To test the Class TextInputtingController
    User Story: 
    ---------------------------------------------------------------
    History:

    1. Justin Created on 2013-10-12
*/
@isTest
public class TextInputtingControlelrTest {
	
	@isTest static void testTextInputtingControlelr(){
		Case newCase = (Case)UtilTestData.createSobject(new Case(), 'Inquiry');
		PageReference page = new PageReference('/apex/textinputting?cid=' + newCase.Id + '&field=mpc');
		Test.setCurrentPage(page);
		TextInputtingControlelr controller = new TextInputtingControlelr();
		controller.textValue = '';
		controller.save();
		controller.textValue = 'OK';
		controller.save();
		
		PageReference page2 = new PageReference('/apex/textinputting?cid=' + newCase.Id + '&field=mbcl');
		Test.setCurrentPage(page2);
		TextInputtingControlelr controller2 = new TextInputtingControlelr();
		controller2.textValue = 'OK';
		controller2.save();
	}
}