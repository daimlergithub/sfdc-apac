@isTest
public with sharing class CSRLookupControllerTest {
 
    public static testMethod void testMyController() {
        
        User user1 = UtilTestData.createUser('SSI TL','CAC SSI TL');
        System.debug('SKMTestUser=>'+user1);
        
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
        
        System.debug('SKMTestProfile=>'+profileIds);
        
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
            System.debug('SKMTestNewUser=>'+newUsers);
            insert newUsers;
                        
            Test.startTest();
            CSRLookupController con = new CSRLookupController();
            List<CSRLookupController.csrUsersWrapper> users = con.getcsrUsers();
            PageReference pr0 = con.selectCSR();
            
            System.debug('SKM1 =>'+con.UserList);
            
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
            system.assertEquals(users,con.getcsrUsers());
            system.assertEquals(pr2 ,con.selectCSR());
            system.assertEquals(pr0 ,con.selectCSR());
        }
    }
}