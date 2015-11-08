@isTest
public with sharing class VehicleDataSharingHandlerTest {

	private static List<User> createPortalUser(String userRole, String profile, List<Account> sharedAccounts) { 
		List<Contact> contacts = new List<Contact>();
		for(Account acc : sharedAccounts) {
			  Contact con = new Contact ( AccountId = acc.Id, LastName = 'portalTestUser',Dealer_Complaint_Gate_Keeper__c=true, Permission_Set_Settings__c = 'S_M_Retail_Campaign');
			  contacts.add(con);
		}
        insert  contacts;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.assertEquals(UserInfo.getUserId(),thisUser.id);          
        List<User> sharedUsers = new List<User>();  
        System.runAs ( thisUser ) { 
        	for(Contact con : contacts) {
        		User usr=new User();            
                usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';
                usr.ProfileId=UtilTestData.getProfileId(profile);
                usr.LastName = 'Test User';
                usr.Email = 'test001@daimler.com.full';
                usr.Alias = 'test';
                usr.TimeZoneSidKey = 'Asia/Shanghai';
                usr.EmailEncodingKey = 'UTF-8';
                usr.LanguageLocaleKey = 'en_US';
                usr.localesidkey='en_US';
                usr.isActive = true;
                usr.ContactId =con.Id;
                Database.insert(usr); 
                system.debug('!!!!! User Records'+usr); 
                sharedUsers.add(usr);
            }
         }                        
        return sharedUsers;     
    }

	public static testMethod void testVehicleDataSharingHandler() {
		//Create Dealer Record
		List<String> dmsCodes = new List<String>{'DMS-00001', 'DMS-00001', 'DMS-00002', 'DMS-00002', 'DMS-00005'};
		List<Account> accs = new List<Account>();
		for (integer i=0; i<4; i++){
			accs.add(new Account());
		}	
		List<Account> sharedAccount;
		User usr = [Select id from User where Id = :UserInfo.getUserId()];
		System.RunAs(usr){
			System.debug('@Entered method...1');
			sharedAccount = createAccountAndVehicle();
		}
		VehicleDataSharingHandler vehicleDataSharing = new VehicleDataSharingHandler();
		Test.startTest();
		vehicleDataSharing.executeProcessByCRMCode(sharedAccount);
		Test.stopTest();
	}
	
	private static List<Account> createAccountAndVehicle(){
		//Create Dealer Record
		List<String> dmsCodes = new List<String>{'DMS-00001', 'DMS-00002', 'DMS-00001', 'DMS-00002'};
		List<Account> accs = new List<Account>();
		for (integer i=0; i<4; i++){
			accs.add(new Account());
		}
		List<Account> sharedAccount = (List<Account>)UtilTestData.createSobjects(accs, UtilTestData.ACCOUNT_RT_DEALER);
		for (Integer j=0; j<sharedAccount.size(); j++){
				sharedAccount[j].Dealer_DMS_CRM_Code__c = dmsCodes[j];
		}
		update sharedAccount;
		//Create User Record
		List<User> sharedUsers = (List<User>)createPortalUser('Dealer User', 'Dealer Delegate Admin', sharedAccount);
		//Create Vehicle Record.
		Vehicle__c vehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(), UtilTestData.VEHICLE_MB);
		//Create Vehicle Relationship Record.
		List<Vehicle_Relationship__c> vRS = new List<Vehicle_Relationship__c>();
		for (integer i=0; i<4; i++){
			vRS.add(new Vehicle_Relationship__c());
		}
		List<Vehicle_Relationship__c> vehicleRelationships = (List<Vehicle_Relationship__c>)UtilTestData.createSobjects(vRS, UtilTestData.Vehicle_Relationship_Retail);
		for (integer i=0; i<4; i++){
			vehicleRelationships[i].Owner_Dealer__c = sharedAccount[i].Id;
			vehicleRelationships[i].Vehicle_ID__c = vehicle.Id;
		}
		update vehicleRelationships;
		return sharedAccount;
	}
		
}