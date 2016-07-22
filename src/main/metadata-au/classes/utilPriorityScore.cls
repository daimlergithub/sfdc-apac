public class utilPriorityScore 
{
	public static Map<String,Decimal> enquiryTypeMap = new Map<String,Decimal>();
    public static Map<String,Decimal> purchaseIntentMap = new Map<String,Decimal>();
    public static Map<String,Decimal> behaviouralGroupMap = new Map<String,Decimal>();
    public static Map<String,Decimal> contractRecordTypeMap = new Map<String,Decimal>();
    public static Map<String,Decimal> requestTestDriveMap = new Map<String,Decimal>();
    public static Map<String,string> natureOfRequestMap = new Map<String,string>();
    public static Map<String,Decimal> noOfMBsMap = new Map<String,Decimal>();
    public static Map<String,Decimal> prospectenquiryTypeMap = new Map<String,Decimal>();
    public static Map<String,Decimal> prospectpurchaseIntentMap = new Map<String,Decimal>();
    public static Map<String,Decimal> prospectbehaviouralGroupMap = new Map<String,Decimal>();
    public static Map<String,Decimal> prospectcontractRecordTypeMap = new Map<String,Decimal>();
    public static Map<String,Decimal> prospectrequestTestDriveMap = new Map<String,Decimal>();
    public static Map<String,string> prospectnatureOfRequestMap = new Map<String,string>();
    public static Map<String,Decimal> prospectnoOfMBsMap = new Map<String,Decimal>();
    public static Map<String,Decimal> prospectLeadMap = new Map<String,Decimal>();
    
    public static List<Lead_Priority_Score__mdt> ledpriscrelist = new List<Lead_Priority_Score__mdt>();
    
    public static void getEnquiryTypeScore()
    {
        ledpriscrelist = [select Customer_Type__c,Enquiry_type__c,Score__c,Behavioural_group__c,Nature_Of_Request__c,Contract_Record_Types__c,
                          Customer_Contrats_to_Lead__c,Purchase_intent__c,Requested_a_test_drive__c,Number_OF_MBs__c,Prospect__c
                          from Lead_Priority_Score__mdt];
        
        for(Lead_Priority_Score__mdt ledpriscre : ledpriscrelist)
        {
            if(ledpriscre.Enquiry_type__c != null && ledpriscre.Enquiry_type__c != '' && ledpriscre.Customer_Type__c == 'Owner')
            {
                enquiryTypeMap.put(ledpriscre.Enquiry_type__c , ledpriscre.Score__c);
            }
            else if(ledpriscre.Enquiry_type__c != null && ledpriscre.Enquiry_type__c != '' && ledpriscre.Customer_Type__c == 'Prospect')
            {
                prospectenquiryTypeMap.put(ledpriscre.Enquiry_type__c, ledpriscre.Score__c);
            }
            if(ledpriscre.Purchase_intent__c != null && ledpriscre.Purchase_intent__c != '' && ledpriscre.Customer_Type__c == 'Owner')
            {
                purchaseIntentMap.put(ledpriscre.Purchase_intent__c , ledpriscre.Score__c);
            }
            else if(ledpriscre.Purchase_intent__c != null && ledpriscre.Purchase_intent__c != '' && ledpriscre.Customer_Type__c == 'Prospect')
            {
                prospectenquiryTypeMap.put(ledpriscre.Purchase_intent__c, ledpriscre.Score__c);
            }
			if(ledpriscre.Behavioural_group__c != null && ledpriscre.Behavioural_group__c != '' && ledpriscre.Customer_Type__c == 'Owner')
            {
                behaviouralGroupMap.put(ledpriscre.Behavioural_group__c , ledpriscre.Score__c);
            }
            else if(ledpriscre.Behavioural_group__c != null && ledpriscre.Behavioural_group__c != '' && ledpriscre.Customer_Type__c == 'Prospect')
            {
                prospectbehaviouralGroupMap.put(ledpriscre.Behavioural_group__c, ledpriscre.Score__c);
            }
            if(ledpriscre.Customer_Contrats_to_Lead__c != null && ledpriscre.Customer_Contrats_to_Lead__c != '' && ledpriscre.Customer_Type__c == 'Owner')
            {
                contractRecordTypeMap.put(ledpriscre.Customer_Contrats_to_Lead__c , ledpriscre.Score__c);
            }
            else if(ledpriscre.Behavioural_group__c != null && ledpriscre.Behavioural_group__c != '' && ledpriscre.Customer_Type__c == 'Prospect')
            {
                prospectcontractRecordTypeMap.put(ledpriscre.Customer_Contrats_to_Lead__c, ledpriscre.Score__c);
            }
            if(ledpriscre.Nature_Of_Request__c != null && ledpriscre.Nature_Of_Request__c != '' && ledpriscre.Customer_Type__c == 'Owner')
            {
                natureOfRequestMap.put(ledpriscre.Nature_Of_Request__c, ledpriscre.Nature_Of_Request__c);
            }
            else if(ledpriscre.Nature_Of_Request__c != null && ledpriscre.Nature_Of_Request__c != '' && ledpriscre.Customer_Type__c == 'Prospect')
            {
               prospectnatureOfRequestMap.put(ledpriscre.Nature_Of_Request__c, ledpriscre.Nature_Of_Request__c); 
            }
            if(ledpriscre.Requested_a_test_drive__c != null && ledpriscre.Requested_a_test_drive__c != '' && ledpriscre.Customer_Type__c == 'Owner')
            {
                requestTestDriveMap.put(ledpriscre.Requested_a_test_drive__c , ledpriscre.Score__c);
            }
            else if(ledpriscre.Requested_a_test_drive__c != null && ledpriscre.Requested_a_test_drive__c != '' && ledpriscre.Customer_Type__c == 'Prospect')
            {
                prospectrequestTestDriveMap.put(ledpriscre.Requested_a_test_drive__c, ledpriscre.Score__c);
            }
            if(ledpriscre.Number_OF_MBs__c != null && ledpriscre.Number_OF_MBs__c != '' && ledpriscre.Customer_Type__c == 'Owner')
            {
                noOfMBsMap.put(ledpriscre.Number_OF_MBs__c , ledpriscre.Score__c);
            }
            else if(ledpriscre.Number_OF_MBs__c != null && ledpriscre.Number_OF_MBs__c != '' && ledpriscre.Customer_Type__c == 'Prospect')
            {
                prospectnoOfMBsMap.put(ledpriscre.Number_OF_MBs__c, ledpriscre.Score__c);
            }
            if(ledpriscre.Prospect__c != null && ledpriscre.Prospect__c != '' && ledpriscre.Customer_Type__c == 'Prospect')
            {
                prospectLeadMap.put(ledpriscre.Prospect__c , ledpriscre.Score__c);
            }
        }
        system.debug('enquiryTypeMap>>>' + enquiryTypeMap);                        	
    }  	
}