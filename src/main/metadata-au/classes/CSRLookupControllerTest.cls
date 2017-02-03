/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class CSRLookupControllerTest {

    public static testMethod void testMyController() {
        
        User user1 = UtilTestData.createUser('Australia','System Administrator');
        
        System.runAs ( user1 ) {        
        	
			String[] csrProfiles = new String[]{
			  		'CAC IB CSR', 'CAC IB TL', 'CAC IB SV', 'CAC IB QC', 'CAC IB Trainer',
			  		'CAC OB CSR', 'CAC OB TL', 'CAC OB SV', 'CAC OB QC', 'CAC OB Trainer',
			  		'CAC SSI CSR', 'CAC SSI TL', 'CAC SSI SV', 'CAC SSI QC', 'CAC SSI Trainer'
			};
	        List<Profile> profileIds = [
	        	Select Id 
	        	From Profile 
	        	Where Name In :csrProfiles];
			List<User> newUsers = new List<User>();
			for(Profile p : profileIds){
		        User usr = new User();
		        usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';
		        usr.ProfileId = p.Id;
		        usr.LastName = 'Test User';
		        usr.Email = 'test001@daimler.com.full';
		        usr.Alias = 'test';
		        usr.TimeZoneSidKey = 'Asia/Shanghai';
		        usr.EmailEncodingKey = 'UTF-8';
		        usr.LanguageLocaleKey = 'en_US';
		        usr.localesidkey='en_US';
		        newUsers.add(usr);
			}
        	
        	insert newUsers;
        	
        	Test.startTest();
            CSRLookupController con = new CSRLookupController();
			List<CSRLookupController.csrUsersWrapper> users = con.getcsrUsers();
			PageReference pr0 = con.selectCSR();
			con.userList[0].selected = true;
			con.userList[1].selected = true;
			PageReference pr2 = con.selectCSR();
			String ids = con.csrIds;
			String namesText = con.selectNameText;
			String idsText = con.selectIdText;
			Test.stopTest();
			System.assert(profileIds!=null);
			System.assertEquals(ids, con.csrIds);
			System.assertEquals(namesText, con.userList[0].csr.Name + '; ' + con.userList[1].csr.Name);
			System.assertEquals(idsText, con.userList[0].csr.Id + ';' + con.userList[1].csr.Id);
        }
    }
}