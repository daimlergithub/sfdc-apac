/*
    Type:       Controller of of page CaseEscalation
    Purpose:    1. Escalate Case to Region Q
                2. Escalate Case to Central Q
    
    User Story: US-DP-013, US-DP-015
    Used By:    
    ---------------------------------------------------------------
    History:
    
    27-May-2013 Sinow Zhang (NTTData)  Created
    13-2-2014 Baib (NTTData)  Modified
*/
public class CaseEscalationController {

    private Static final String ErrorMessageInvalidId = 'Invalid Case Id.';
    private Static final String ErrorMessageWrongRegion = 'Please set up dealer region first before escalate case.';
    private final static String ERRORUpdateDealer = 'Update Account Error, Please review Account information such as Phone Number, Email.';
    private final static String ERROR_MSG = 'In case of escalation, all fields for Complaint Details section are mandatory.';
    private final static String ERROR_MSGChinese = '在升级投诉时, 所有投诉详细信息栏的字段均为必填.';
    private final static String ERROR_DupEscalate = '投诉已经升级，无需再次升级.';
    private QueueSobject CentralPLWLQ = [select Id, QueueId, Queue.Name from QueueSobject where SobjectType = 'Case' and Queue.Name = 'Central Office PL / WL Queue' limit 1];
    
    //CR No.: CR-AS-Complaint-008 START
    //added by baib 2014/02/13 
    private Map<String, Id> centralQs= new Map<String, Id>();
    private Map<String, Id> regionalQs= new Map<String, Id>();
    private Map<String, String> CENTRAL_QUEUE_NAME = new Map<String, String>{
        'EAST'=>'BMBS Central Office-ER team',
        'SOUTH'=>'BMBS Central Office-SR team',
        'NORTH'=>'BMBS Central Office-NR team',
        'WEST'=>'BMBS Central Office-WR team'
    };
    //CR No.: CR-AS-Complaint-008 END
    
    private Profile DealerCommunityUser = [select Id from Profile where Name = 'Dealer Community User'];
    private Profile DealerDelegatedAdmin = [select Id from Profile where Name = 'Dealer Community Delegate Admin'];
    private Set<Id> profileIds = new Set<Id>();

    List<String> MandatoryFields = new List<String>{
           'Case_Department__c',
           'Dealer_Case_Type__c',
           'Dealer_Case_SubType__c',
           'Case_Source__c',
           'Date_of_1st_Registration__c',
           'Selling_Dealer__c',
           'Last_Known_Mileage__c',
           'Case_Dealer__c',
           'Defective_Item__c',
           'Defective_SubItem__c',
           'Customer_Requests_Transport__c',
           'Dealer_Provides_Transport__c',
           'Customer_Background_Info__c',
           'Region__c',
           'Government_Background__c',
           'Occupation__c',
           'Owned_MB_Vehicle_PL__c',
           'Order_No__c',
           'Vehicle_Class__c',
           'CLB__c',
           'Owner_Tele__c',
           'Car_Type__c',
           'US_VIN__c',
           'RO_CO_Case_Category__c',
           'Vehicle_In_Workshop__c',
           'Registration_Number__c'};    
    private final static String AWAITING_MB = 'Awaiting MB';
        
    public Case EscalateCase { get; set; }
    private List<CaseShare> caseShares { get; set; }
    
    public CaseEscalationController() {
        String caseId = ApexPages.currentPage().getParameters().get('id');
        //CR No.: CR-AS-Complaint-008 START
        //added by baib 2014/02/13          
        initalQueueMap();
        //CR No.: CR-AS-Complaint-008 END
        if(caseId instanceOf Id) {
            EscalateCase = [select Id, 
                                   Account.RecordTypeId, 
                                   Case_Involvement_MPC__c,
                                   OwnerId, Case_Dealer__r.Dealer_Region__c, 
                                   Case_Department__c, 
                                   Description, Dealer_Case_Type__c, 
                                   Dealer_Case_SubType__c, Case_Source__c, 
                                   Date_of_1st_Registration__c, 
                                   Selling_Dealer__c, 
                                   Last_Known_Mileage__c,
                                   Case_Dealer__c, 
                                   Defective_Item__c, 
                                   Defective_SubItem__c, 
                                   Customer_Requests_Transport__c, 
                                   Dealer_Provides_Transport__c, 
                                   Customer_Background_Info__c, 
                                   Region__c, 
                                   Government_Background__c, 
                                   Occupation__c, 
                                   Owner_Tele__c, 
                                   Owned_MB_Vehicle_PL__c, 
                                   Order_No__c, 
                                   Vehicle_Class__c, 
                                   CLB__c,
                                   RO_CO_Case_Category__c,
                                   Registration_Number__c,
                                   US_VIN__c,
                                   Vehicle_In_Workshop__c,
                                   Car_Type__c,
                   Handling_Level__c,
                                   Owner.ProfileId
                                   from Case where Id = :caseId];
            profileIds.add(DealerCommunityUser.Id);
            profileIds.add(DealerDelegatedAdmin.Id);
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorMessageInvalidId));
        }
    }

    //CR No.: CR-AS-Complaint-008 START
    //added by baib 2014/02/13     
    private void initalQueueMap(){
        //get central Q name and id
        for (QueueSobject qo : 
        [select Id, QueueId, Queue.Name from QueueSobject where SobjectType = 'Case' and Queue.Name like 'BMBS Central Office-%']){
            centralQs.put(qo.Queue.Name,qo.QueueId);
        }
        //initial reginal name and id
        for (QueueSobject qo : 
        [select Id, QueueId, Queue.Name from QueueSobject where SobjectType = 'Case' and Queue.Name like 'Regional Office %']){
            if(qo.Queue.Name.contains('East')){
              regionalQs.put('EAST',qo.QueueId);
            }
            if(qo.Queue.Name.contains('West')){
              regionalQs.put('WEST',qo.QueueId);
            }
            if(qo.Queue.Name.contains('North')){
              regionalQs.put('NORTH',qo.QueueId);
            }
            if(qo.Queue.Name.contains('South')){
              regionalQs.put('SOUTH',qo.QueueId);
            }
        }
        system.debug(regionalQs);
    }
    
    private void setEscalteInfo(String region, Profile currentUserProfle){
        EscalateCase.Status = AWAITING_MB;
        EscalateCase.OwnerId = currentUserProfle.Name == 'BMBS Regional CRM Manager' ? 
            (EscalateCase.Case_Involvement_MPC__c == 'PL/WL' ? CentralPLWLQ.QueueId : centralQs.get(CENTRAL_QUEUE_NAME.get(region))) 
            : regionalQs.get(region);
        EscalateCase.Handling_Level__c = currentUserProfle.Name == 'BMBS Regional CRM Manager' ? 'Central Office' : 'Regional Office';
    }
    //CR No.: CR-AS-Complaint-008 END
        
    public pageReference escalate() {
        Profile currentUserProfle = [select Id, Name from Profile where Id = :UserInfo.getProfileId()];
        
        for(String colName : MandatoryFields){
            if(String.isEmpty(String.valueOf(EscalateCase.get(colName))) && currentUserProfle.Name != 'BMBS Regional CRM Manager'){
                if(UserInfo.getLanguage() == 'English') {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_MSG));
                }
                else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_MSGChinese));
                }
                return null;
            }
        }

        if(EscalateCase.Handling_Level__c != 'Dealer' && profileIds.contains(currentUserProfle.Id)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_DupEscalate));
            return null;
        }
        
        //CR No.: CR-AS-Complaint-008 
        if(regionalQs.keySet().contains(EscalateCase.Case_Dealer__r.Dealer_Region__c)){
            setEscalteInfo(EscalateCase.Case_Dealer__r.Dealer_Region__c,currentUserProfle);
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorMessageWrongRegion));
            return null;
        }
        
        // Added by Chris, 20131018
        if (EscalateCase.Escalate_Date_to_RO__c == null && currentUserProfle.Name.startsWith('Dealer')) {
            EscalateCase.Escalate_Date_to_RO__c = Date.today();
        }
        system.debug('currentUserProfle:'+currentUserProfle);
        if (EscalateCase.Escalate_Date_to_CO__c == null && currentUserProfle.Name == 'BMBS Regional CRM Manager') {
            EscalateCase.Escalate_Date_to_CO__c = Date.today();
        }

        try {
            update EscalateCase;
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            return null;
        }
          
        if(profileIds.contains(currentUserProfle.Id) && EscalateCase.Account.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account Retail').getRecordTypeId())
        {
            EscalateCase.Account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            try {
                update EscalateCase.Account;
            }
            catch(Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERRORUpdateDealer));
                return null;
            }
        }
        return new pageReference('/' + EscalateCase.Id);
    }
}