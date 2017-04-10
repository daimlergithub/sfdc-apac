public with sharing class PrintPDFcontroller 
{
    public List<Address__c> addresList = new List<Address__c>();
    public List<Address__c> companyAccaddList = new List<Address__c>();
    public List<Vehicle_Relationship__c> vRList{get;set;}
    public List<Task> HistoryList = new List<Task>();
    public List<Task> activityList{get;set;}
    public set<string> pickListValueSet = new Set<string>();
    public set<string> taskPickListValueSet = new Set<string>();
    public List<Task> activityhistoryList{get;set;}
    public Lead__c cas{get;set;}
    public string companyname{get;set;}
    public string homeaddress{get;set;}
    public boolean isConatct{get;set;}
    public boolean isVisited{get;set;}
    public boolean isNeedsCheck{get;set;}
    public boolean isProductProposal{get;set;}
    public boolean isFinanceProposal{get;set;}
    public boolean isInsuranceProposal{get;set;}
    public boolean isServiceProgramProposal{get;set;}
    public boolean isSimpleEstimation{get;set;}
    public boolean isTestDrive{get;set;}
    public String attachmentName;
    public Vehicle_Relationship__c VehicleRelationshipList{get;set;}
    public String CustomerStatement{get;set;}
    public String PRCommentForDealer {get;set;}
    datetime now = system.now();
    datetime sentTime;
    /**
* Escape <br/> tag
*/
    private static final String BR_TG_ESCAPE = '%%br%%';
    /**
* Regular expresssion for the tag
*/
    private static final String REGEX_TAG = '<.+?>';
    /**
* <br> tag
*/
    public static final String BR_TG = '<br/>';
    /**
* <br/> tag
*/
    public static final String BR_SLASH_TG = '\n';
    /**
* Define empty
*/
    public static final String STRING_NONE = '';
    /**
* Define \n (line break)
*/
    public static final String NEW_LINE_CHARACTER = '\n';
    /**
* Define "$"
*/
    public static final String DOLLAR_CHARACTER = '$';
    
    /**
* Define number of characters per line
*/
    public static final Integer LINE_LENGTH = 57;
    public user usr{get;set;}
    
    public PrintPDFcontroller (ApexPages.StandardController controller) 
    {        
        usr = [select id,Market__c from user where id =:userinfo.getUserId()];
        this.cas=(Lead__c)controller.getRecord();  
        cas=[select id,Name,contact__c,Company_Account__c,Lead_Type__c,Lead_DataSource__c,Vehicle_Need__c,Is_Assigned__c,Dealer_Lead_Status__c,Lost_Dealer_Date__c,Lead_Possibility__c,Lead_Possibility_text__c,Lost_Situation__c,Purchase_Amount__c,Price_Range_From__c,Price_Range_To__c,Dealer_Audit__c,Dealer_Audit_Result__c,Contact_Failed_For_3_Days_Date__c,Re_visit__c,Team__c,Next_Contact__c,CAC_Lead_Status__c,Lead_Sub_Type__c,Source_Campaign__c,Vehicle_Need_Text__c,CAC_Lost_Reason__c,Dealer_Lost_Reason__c,Lost_Comment__c,Lost_To__c,Lost_CAC_Date_Time__c,Lead_Priority__c,Reserve_Flag__c,Relation_With_The_Leads__c,Qualified_Date_Time__c,Need_Assign_To_Dealer__c,Is_Active__c,Is_Qualify__c,Network_Registration_Date__c,Batch_No__c,Quotation_Date__c,Next_Contact_Customer_Date__c,Case__c  from Lead__c Where id=:ApexPages.currentPage().getParameters().get(System.Label.Id)]; 
        system.debug('cas account>>>>' + cas.Contact__c);
        if(cas.Contact__c != null)
        {
        	addresList = [select id,Customer__c,Address_Type__c,Company_Name__c from Address__c where Customer__c =:cas.Contact__c];
        	vRList = [select id,Vehicle_ID__c,End_Date__c,Car_Relation__c,Validity__c,Vehicle_ID__r.FirstRegistrationDate__c,
                      Vehicle_ID__r.Range__c,Vehicle_ID__r.Model__c,Vehicle_ID__r.CurrentMileage__c,Registration_Date__c,Vehicle_ID__r.NextInspectionDate__c,
                      MOT_USER_NAME__c,Finance_Method__c
                      from Vehicle_Relationship__c where contact__c =:cas.Contact__c AND Car_Relation__c = 'Purchaser' AND Validity__c = 'Yes' ORDER BY CreatedDate DESC limit 3];
        }
        HistoryList = [select id,whatId,Intention_status__c from Task where whatId =:ApexPages.currentPage().getParameters().get(System.Label.Id)];
        activityList = [select id,whatId,SentTime__c,OwnerId,Owner.Lastname,Owner.FirstName,Intention_status__c,Subject,Description from Task where whatId =:ApexPages.currentPage().getParameters().get(System.Label.Id) AND SentTime__c > Today ORDER BY CreatedDate DESC limit 5];
        activityhistoryList = [select id,whatId,SentTime__c,OwnerId,Owner.Lastname,Owner.FirstName,Intention_status__c,Subject,Description from Task where whatId =:ApexPages.currentPage().getParameters().get(System.Label.Id) AND SentTime__c <= Today];
       
        if(!HistoryList.isEmpty() && HistoryList != null)
        {
            for(Task tsk : HistoryList)
            {
               	if(tsk.Intention_Status__c != null && tsk.Intention_Status__c != '')
                {
                    pickListValueSet.add(tsk.Intention_Status__c);
                }
            }
            if(!pickListValueSet.isEmpty() && pickListValueSet != null)
            {
                if(pickListValueSet.contains('Contact'))
                {
                    isConatct = true;
                }
                if(pickListValueSet.contains('Visited'))
                {
                    isVisited = true;
                }
                if(pickListValueSet.contains('Needs Check'))
                {
                    isNeedsCheck = true;
                }                
                if(pickListValueSet.contains('Product Proposal'))
                {
                    isProductProposal = true;
                }                
                if(pickListValueSet.contains('Finance Proposal'))
                {
                    isFinanceProposal = true;
                }                
                if(pickListValueSet.contains('Insurance Proposal'))
                {
                    isInsuranceProposal = true;
                }                
                if(pickListValueSet.contains('Service Program Proposal'))
                {
                    isServiceProgramProposal = true;
                }                
                if(pickListValueSet.contains('Simple Estimation'))
                {
                    isSimpleEstimation = true;
                }                
                if(pickListValueSet.contains('Test Drive'))
                {
                    isTestDrive = true;
                }                                
            }
        }
        system.debug('activityList>>>>' + activityList);
        system.debug('activityhistoryList>>>>' + activityhistoryList);
        if(cas.Company_Account__c != null)
        {
            companyAccaddList = [select id,Customer__c,Address_Type__c ,Province__c,City__c,District__c,Block__c,Address_Line_1__c,Address_Line_2__c from Address__c where Customer__c =:cas.Company_Account__c];        	
        }
        system.debug('addressList>>' + addresList);
        if(!addresList.isEmpty() && addresList !=null)
        {
            for(Address__c add : addresList)
            {
                if(add.Address_Type__c == 'Business' && (add.Company_Name__c != null || add.Company_Name__c != ''))
                {
                    companyname = add.Company_Name__c;
                }
            }
        }
        if(!companyAccaddList.isEmpty() && companyAccaddList != null)
        {
            for(Address__c comAdd : companyAccaddList)
            {
                if(comAdd.Address_Type__c == 'Home')
                {
                    if(comAdd.Province__c != null && comAdd.Province__c != '')
                    {
                        homeaddress = comAdd.Province__c;
                    }
                    if(comAdd.City__c != null && comAdd.City__c != '')
                    {
                        homeaddress = homeaddress+ comAdd.City__c;
                    }
                    if(comAdd.District__c != null && comAdd.District__c != '')
                    {
                        homeaddress = homeaddress+ comAdd.District__c;
                    }
                    if(comAdd.Block__c != null && comAdd.Block__c != '')
                    {
                        homeaddress = homeaddress+ comAdd.Block__c;
                    }
                    if(comAdd.Address_Line_1__c != null && comAdd.Address_Line_1__c != '')
                    {
                        homeaddress = homeaddress+ comAdd.Address_Line_1__c;
                    }
                    if(comAdd.Address_Line_2__c != null && comAdd.Address_Line_2__c != '')
                    {
                        homeaddress = homeaddress+ comAdd.Address_Line_2__c;
                    }
                }
            }
        }
        system.debug('companyname>>>' + companyname);
    }    
}