/*
    Type:       Utility for preparing test data
    Purpose:    Prepare Test data for Unit Test
    User Story: 
    Used By:    DealerSearchControllerTest.cls, 
                AccountMergeControllerTest.cls,

    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-03-13
    2. Chris Overwrite createUser method by RoleName and ProfileName on 2013-03-14
    3. Mouse add Singleton and simple factory pattern to this class on 2013-03-15
    4. Mouse add test data of lead management on 2013-04-24
*/
@isTest
Public class UtilViewHierarchyTestData {
	
	private static Map<String, Id> recordTypeMap;
	public final static String ACCOUNT_RT_PERSON_ACCOUNT = 'Person Account';
    public final static String ACCOUNT_RT_DEALER = 'Dealer';
	private static String accountString='Account';
	private static String classValue='A-Class';
	public final static String Vehicle_Relationship_Retail ='Vehicle Relationship Retail';
    public final static String VEHICLE_RELATIONSHIP = 'Vehicle Relationship';
    public final static String VEHICLE_MB = 'MB';
	
	 // Initiate recordTypeMap
    private static Map<String, Id> getRecordTypeMapInstance() {
        if (recordTypeMap == null) {
            recordTypeMap = new Map<String, Id>();
            for (RecordType rt : [SELECT Id, Name, SobjectType FROM RecordType LIMIT 1000]) {
                recordTypeMap.put(rt.Name + rt.SobjectType, rt.Id);
            }
        }
        
        return recordTypeMap;
    }
	
	public static Sobject createSobject(Sobject so, String recordTypeName) {
        initiateSobject(so, recordTypeName);
        
        insert so;
        return so;
    }
	public static List<Sobject> createSobjects(List<Sobject> sos, String recordTypeName) {
		initiateSobjects(sos, recordTypeName);

		insert sos;
		return sos;
	}

	// Initiate sobjects which number is BATCH_SIZE
	private static List<Sobject> initiateSobjects(List<Sobject> sos, String recordTypeName) {
		for (Sobject so : sos) {
			initiateSobject(so, recordTypeName);
		}

		return sos;
	}
	
	private static Sobject initiateSobject(Sobject so, String recordTypeName) {
        if (so instanceof Account) {
            if (recordTypeName == ACCOUNT_RT_PERSON_ACCOUNT) {
                initiatePersonAccount(so);
            }
            else if (recordTypeName == ACCOUNT_RT_DEALER) {
                initiateDealer(so);
            }
        }
        else if (so instanceof Vehicle__c) {
            initiateVehicle(so);
        }
        else if (so instanceof Vehicle_Relationship__c) {
            initiateVehicleRelationship(so, recordTypeName);
        }
        return so;
    }
	
    // Create Unsaved Person Account
    // N.B. Name is read only for Person Account
    private static void initiatePersonAccount(Sobject so) {
        Account acc = (Account)so;

        acc.RecordTypeId = 
            getRecordTypeMapInstance().get(ACCOUNT_RT_PERSON_ACCOUNT + accountString);
        // acc.Name = testString;
        acc.LastName = 'Customer';
        acc.Type = acc.Type == null ? '0=Company' : acc.Type;
        acc.Phone = '01234567';
        acc.Area_Code__c = '010';
        acc.Status__c = acc.Status__c == null ? '0=Customer' : acc.Status__c;
    }
	// Create Unsaved Dealer
    private static void initiateDealer(Sobject so) {
        Account acc = (Account)so;

        acc.RecordTypeId = 
            getRecordTypeMapInstance().get(ACCOUNT_RT_DEALER  + accountString);
        acc.Dealer_Alternate_Name__c = 'Test Alternate';
        acc.Phone = '021000000';
        acc.Dealer_GC_Code__c = 'gc code';
        acc.Dealer_GS_Code__c = 'gs code';
        acc.Name = acc.Name == null ? 'test dealer' : acc.Name;
        acc.Dealer_MB_Sub_Region__c = acc.Dealer_MB_Sub_Region__c == null ?
            'North1' : acc.Dealer_MB_Sub_Region__c;
    }
	// Create Unsaved Vehicle
    // UsVIN__c Length must be 17, 
    // EuroVIN__c length must be 17 or 18
    private static void initiateVehicle(Sobject so ) {
        Vehicle__c vehicle = (Vehicle__c)so;

        vehicle.UsVIN__c = 'usvin111111111111'; 
        vehicle.EuroVIN__c = 'eurovin1234567890';
        vehicle.Brand__c = VEHICLE_MB;
        vehicle.Class__c = classValue;
        vehicle.Model__c = '130i';
        vehicle.Colour__c = '40 ';
        vehicle.CommissionNumber__c = '123456';
    }
    
    // Create Unsaved Vehicle Relationship
    private static void initiateVehicleRelationship(Sobject so, String recordTypeName) {
        Vehicle_Relationship__c relationship = (Vehicle_Relationship__c)so;

        relationship.RegistrationProvince__c = 'Shanghai';
        relationship.Registration_City__c = 'Shanghai';
        relationship.Status__c = '0=Previously Owned';
        relationship.Main_Usage__c = '0=Taxi';
        relationship.Ownership__c = '1=Company';
        relationship.Car_Relation__c = 'User';
        relationship.New_Used__c = '0=New';
        relationship.Validity__c = 'Unknown';
        relationship.Purchase_Date__c = System.today();
        relationship.Registration_Date__c = System.today();
        relationship.recordTypeId = getRecordTypeMapInstance().get(recordTypeName + 'Vehicle_Relationship__c');
    }
}