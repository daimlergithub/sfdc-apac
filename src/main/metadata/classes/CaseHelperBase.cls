/**
* Utility for Trigger on Case to handle business logic
* Author:Honey
* Created Date : 26th Sep 2017
*/

public class CaseHelperBase {
    private static final String alkCompanyRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    private static final String alkpersonRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    private static final String PersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static final String AccountCompanyId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    public Id caseINquiryId = RecordTypeAccessService.getRecordTypeId('Case',Label.Case_Record_Type_Inquiry); 
    public Id caseMBComplaintRec_Id = RecordTypeAccessService.getRecordTypeId('Case',Label.Case_Record_Type_Complaint); // to get market record type id
    public List<Id> tmpCaseIds = new List<Id>();
    public List<Account> updateAccount = new List<Account>();
    public Map<Id, List<Id>> accountCaseMap = new Map<Id, List<Id>>();
    Map<Id, List<Id>> parentIdChildIds = new Map<Id, List<Id>>();
    Set<Id> parenthasParents = new Set<Id>();
    Set<Id> parentIds = new Set<Id>();
    public static final String NOT_PRIMARY_REMINDER = 'This Complaint is not a primary complaint, please find the primary complaint.';
    
    // This method is used to calculate deadline amount for complain case
    public void updateCaseDeadLineAmount(List<case> caselist, string market, Map<Id,Case> oldValcase){
        Case_Escalation_Matrix__mdt[] ceMatrix = [SELECT MasterLabel, DeveloperName, Escalation_Hours__c,Priority__c,Record_Type__c 
                                                    FROM Case_Escalation_Matrix__mdt];
        for(Case caserec:Caselist){
            for(Case_Escalation_Matrix__mdt cem : ceMatrix){
                //system.debug('inside for'+caserec.RecordTypeId+caserec.RecordTypeID+caserec.RecordType.DeveloperName+'=record type'+UtilRecordType.getRecordTypeIdByName('Case',cem.Record_Type__c)+'priorty'+caserec.priority+'---'+cem.Priority__C+'market'+caserec.md__c+'----'+cem.MasterLabel);
                if(caserec.RecordTypeID==UtilRecordType.getRecordTypeIdByName('Case',cem.Record_Type__c) && caserec.priority== cem.Priority__C && caserec.md__c==cem.MasterLabel){
                    if(oldValCase == NULL)
                        updatedeadine(caserec,Integer.ValueOf(cem.Escalation_Hours__c));
                    else if(caserec.priority !=oldValcase.get(caserec.id).priority)
                        updatedeadine(caserec,Integer.ValueOf(cem.Escalation_Hours__c));
                }
            }
        }                                            
    }
    //This method is used to return date to deadline amount method
    public void updatedeadine(case Caserec,Integer hours){
        
        if(hours < 24){
            caserec.deadline__c=System.now().addHours(hours);
        }
        else{
            Integer daystoadd=0;
            DateTime dt=System.now();
        
            Integer hourscount=0;
            While(hourscount<hours){
                string dayOfWeek = dt.format('E');
                system.debug('dayOfWeek'+dayOfWeek);
                if(dayOfWeek =='Sat'||dayOfWeek =='Sun'){
                    hourscount=hourscount+24;
                }
                else{
                    hourscount=hourscount+24;
                }
                dt=dt+1;
                daystoadd=daystoadd+1;
            }
        
                Datetime dow = System.now()+daystoadd;
                string dayOfWeek = dow.format('E');
                if(dayOfWeek =='Sat'){
                    caserec.deadline__c=System.now()+daystoadd+2;
                }
                else if(dayOfWeek =='Sun'){
                    caserec.deadline__c=System.now()+daystoadd+1;
                }
                else
                    caserec.deadline__c=System.now()+daystoadd;
        
        }
    }
    
    //Calculate total number of repeated MB complaints per account
    public void calculateComplaintAmount(List<Case> cases, string market){
        Set<Id> accounts = new Set<Id>();
        List<Account> accRecords;
        for(Case c : cases){
            if(c.MD__C == market)
                accounts.add (c.AccountId);
                accounts.add(Trigger.isInsert ? NULL : ((Case)Trigger.oldMap.get(c.ID)).AccountID);
        }                       
        accounts.remove(NULL);
        List<Case> case_acc = [Select Id, AccountId From Case 
                              Where (AccountId IN :accounts AND RecordTypeId =:caseMBComplaintRec_Id and MD__c =: market) LIMIT 50000]; 
        if (case_acc != null && !case_acc.isEmpty()){                                         
            for(Case c : case_acc){
                tmpCaseIds = accountCaseMap.get(c.AccountId);
                if (tmpCaseIds == null){
                    accountCaseMap.put(c.AccountId, new List<Id>{c.Id});
                }
                else{
                    tmpCaseIds.add(c.Id);
                }
            }
            
           // accounts = new Set<Id>();
           // accounts = accountCaseMap.keySet();
            
            /*accRecords = [Select Id, Complaint_Amount__c From Account Where Id IN:accounts LIMIT 50000];
            for (Account acc : accRecords){
               List<Id> caseIds = accountCaseMap.get(acc.Id);
               acc.Complaint_Amount__c = caseIds.size();
               updateAccount.add(acc);
            }*/
            
            for (ID acc : accounts){
                updateAccount.add(new Account(id = acc, Complaint_Amount__c = (accountCaseMap.get(acc) != NULL ? accountCaseMap.get(acc).size() : 0)));
            }
          
        }else{
            Set<Id> accountIds = new Set<Id>();
            for (Id acc : accounts){
                updateAccount.add(new Account(id = acc, Complaint_Amount__c = 0));
            }
            /*accRecords = [Select Id, Complaint_Amount__c From Account Where Id IN:accountIds];
            for (Account acc : accRecords){
               acc.Complaint_Amount__c = 0;
               updateAccount.add(acc);
            }*/
        }
        
        if(updateAccount.size() > 0){
            DMLManagerService.updateAsSystem(updateAccount);   
        }
    }
    
    //Calculate the number of Repeated Case for an account 
    public  void countRepeatComplaintCase (List<case> cases,boolean isInsert, string market) {
        for(Case caseNew : cases) {
            if (isInsert){
                if (caseMBComplaintRec_Id == caseNew.RecordTypeId && caseNew.md__c == market && caseNew.ParentId != null){    
                    parentIds.add(caseNew.ParentId);   
                }
            }
        }
        if (parentIds.size()>0){
            for(Case ca :[select Id, ParentId from Case where ParentId in :parentIds] ) {
                if(!parentIdChildIds.containsKey(ca.ParentId)) {
                    parentIdChildIds.put(ca.ParentId, new List<Id>());
                }
                parentIdChildIds.get(ca.ParentId).add(ca.Id);
            }

            for(Case ca :[select Id, ParentId from Case where Id in :parentIds] ) {
                if(ca.ParentId != null) {
                    parenthasParents.add(ca.Id);
                }
            }
        }

        for(Case caseNew : cases) {
            if(isInsert) {
                if (caseMBComplaintRec_Id == caseNew.RecordTypeId &&caseNew.MD__c == market){
                    caseNew.Repeat_Complaint_Times__c = 0;

             
                    if (caseNew.ParentId != null){
                        if(parenthasParents.contains(caseNew.ParentId)) {
                            caseNew.addError(NOT_PRIMARY_REMINDER );
                        }
                        else
                        {   
                            if(parentIdChildIds.containsKey(caseNew.ParentId))
                                caseNew.Repeat_Complaint_Times__c = parentIdChildIds.get(caseNew.ParentId).size() + 1;
                            else
                                caseNew.Repeat_Complaint_Times__c = 1;
                        }
                    }
                }
        
            }
        }
    }
    
    public void updateCaseOwnerDependsonPrimaryCaseDealer(List < Case > caselist, boolean isInsertFlag, String market) {
        set < Id > accset = new set < ID > ();

        if (isInsertFlag) {
            for (Case cas: caselist) {
                if (cas.Case_Dealer__c != null) {
                    accset.add(cas.Case_Dealer__c);

                }
            }

        } else {
            for (Case cas: caselist) {
                if (((Case) trigger.newmap.get(cas.id)).ownerId != ((
                    case) trigger.oldmap.get(cas.id)).ownerId) {
                    //c.ownerid=dealerndcode.get(c.Case_Dealer__c).Dealer_Lead_Gate_Keeper__c;
                } else if (cas.Case_Dealer__c != null && ((Case) trigger.newmap.get(cas.id)).case_Dealer__c != ((
                    case) trigger.oldmap.get(cas.id)).Case_Dealer__c) {
                    accset.add(cas.Case_Dealer__c);
                }
            }

        }
        Map<id, id> accUserMap = new Map<id, id>();
        if(accset.size()>0){
            accUserMap = getAccountToDCGKUser(accset);
        }
        if (accUserMap.size() > 0) {
            for (Case c: caselist) {
                if (c.Case_Dealer__c != null && accUserMap.get(c.Case_Dealer__c)!= NULL && c.md__c == market) {
                    c.ownerid = accUserMap.get(c.Case_Dealer__c);
                }
                else if(c.Case_Dealer__c != null && accUserMap.get(c.Case_Dealer__c) == NULL && c.md__c == market){
                    c.addError('The Dealer Complaint Gate Keeper user is either not present or is inactive.');
                }
            }
        }
    }
    
    public static String getCommunityURL() {
        String communityName = 'Daimler Community Malaysia';
        String commubaseurl = '';
        boolean flag1;
        List < Network > myNetwork = [SELECT Id, Name FROM Network];
        for (Network net: myNetwork) {
            if (net.name == communityName) {
                flag1 = true;
                commubaseurl = Network.getLoginUrl(net.id);
                break;
            }
        }
        return commubaseurl.replace('login', '');
    }
    
    public void updatecommunityurl(List < Case > caselist, String market) {
        String commURLMY = getCommunityURL();
        for (Case cas: caselist) {
            cas.Others__c = commURLMY;
        }

    }
    
    //Update Case Creator field with the CreatedBy value
    public void updateCaseCreator(List < Case > lst_Cases, String market) {
        If(!lst_Cases.isEmpty() && lst_Cases != Null) {
            for (Case newCase: lst_Cases) {
                newCase.Case_Creator__c = UserInfo.getUserId();
            }
        }
    }
    
    public void changeDealerAccount(List<case> triggernew, String Market){
        Map<id,User> usrmap=getDealerAccount(triggernew);
        for(case re:triggernew){
             if(re.ownerid!=null&&usrmap.get(re.ownerid)!=null&&(usrmap.get(re.ownerid)).contact!=null){
                 re.Case_Dealer__c=(usrmap.get(re.ownerid)).contact.accountid;
             }
        }
    }
    
    Public static Map<id,User> getDealerAccount(List<Sobject> triggernew){
    set<id> usrset=new Set<id>();
         for(sobject re:triggernew){
             usrset.add((ID)re.get('ownerid'));
         }
    return new map<id,User>([select id,usertype,contact.accountid from user where id IN : usrset and usertype='PowerPartner']);
    }
    
    public void CreateRetailCopy(List < Case > caselist, map < id, Case > caseOldMap, boolean isInsert, boolean isUpdate, String Market) {
        set < String > dealerid = new set < String > ();
        set < String > accId = new set < String > ();
        set < String > actlnkids = new set < String > ();
        List < Account_Link__c > accLst = new List < Account_Link__c > ();
        List < Account_Link__c > dealercount = new List < Account_Link__c > ();
        List < Case > caseLst = [select Id, AccountId, Case_Dealer__c, Account.LastName, Account.FirstName, Account.LastName_Native_1__c, Account.ID_Type__c, Account.ID_Number__c, Account.country__c,
            Account.FirstName_Native_1__c, Account.PersonBirthdate, Account.Special_Care__c, Account.Individual_Home_Phone__c, Account.Work_Phone__c, Account.Primary_Address_Reference__r.Sub_District__c,
            Account.Mobile__c, Account.Fax, Account.Email__c, Account.Primary_Address_Reference__r.City__c, Account.Primary_Address_Reference__r.District__c, Account.createdDate, Account.lastmodifieddate,
            Account.Primary_Address_Reference__r.Block__c, Account.Primary_Address_Reference__r.Address_Line_1__c,
            Account.Primary_Address_Reference__r.Address_Line_2__c, Account.Primary_Address_Reference__r.ZipCode__c,
            Account.Primary_Address_Reference__r.CreatedDate, Account.Primary_Address_Reference__r.LastModifiedDate,
            Account.gender__c, Account.Occupation__c, Account.Primary_Phone__c, Account.Industry, Account.Preferred_Language__c,
            Account.Special_Needs_Class__c, Account.Allow_Data_Sharing2__c, Account.Primary_Address_Reference__r.Address_Type__c,
            Account.Primary_Address_Reference__r.Province__c, Account.Preferred_Contact_Method__c, MD__c,
            Account.UCID__c, Account.Salutation__c, Account.RecordtypeId, Account.Name, Account.Company_Name_Native_1__c, Account.Foundation_Date__c, Account.Primary_Address_Reference__r.Foreign_Nationals__c,
            Account.Website, Account.Vat_No__c, Account.DMS_Customer_ID__c, Account.Complaint_Amount__c, Account.Sales_Sanction__c, Account.Allow_Data_Sharing__c, Account.PersonEmail, Account.PersonHasOptedOutOfEmail, Account.PersonHasOptedOutOfFax, Account.Primary_Phone_Display__c, Account.PersonDoNotCall, Account.Postal_Opt_Out__c, Account.Job__c, Account.Personal_Agreement__c, Account.Personal_Information_Third_Party_Release__c, Account.Personal_Abroad_Agreement__c, Account.Agreement_to_commit_info_processing__c, Account.Commercial_Reg_No__c, Account.Company_Name__c, Account.Visit_Opt_Out__c,Case_Dealer__r.Dealer_Rollout_Status__c
            from Case WHERE id IN: caselist
        ];

        for (Case cs: caseLst) {
            if (cs.Case_Dealer__c != null && cs.MD__c == market) {
                if (isInsert || (isUpdate && cs.Case_Dealer__c != caseOldMap.get(cs.id).Case_Dealer__c)) {
                    dealerid.add(cs.Case_Dealer__c);
                }
            }
            if (cs.AccountId != null) {
                accId.add(cs.AccountId);
            }
        }

        if (dealerid.size() > 0) {
            dealercount = [select id from Account_Link__c WHERE fromRole__c IN: dealerId AND toRole__c IN: accId AND(RecordTypeId =: alkCompanyRecordTypeId OR RecordTypeId =: alkpersonRecordTypeId) AND(Retail_Delete_Flag__c = false AND Retail_Duplicate_Flag__c = false)];
        }
        for (Case led: caseLst) {
            System.debug('11*');
            if (led.Case_Dealer__c != null && String.isnotblank(led.Case_Dealer__r.Dealer_Rollout_Status__c)?(led.Case_Dealer__r.Dealer_Rollout_Status__c=='Done'):false && (dealercount.isEmpty() || dealercount == null || dealercount.size() == 0) && (isInsert || (isUpdate && led.Case_Dealer__c != caseOldMap.get(led.id).Case_Dealer__c)) ) {
                Account_Link__c acclnk = new Account_Link__c();
                //accLst.add(acclnk);
                System.debug('22*' + led.Account.RecordTypeId + PersonRecordTypeId);
                if (led.Account.RecordTypeId == PersonRecordTypeId) {
                    System.debug('33*');
                    acclnk = new Account_Link__c(RecordTypeId = alkpersonRecordTypeId, toRole__c = led.AccountId, fromRole__c = led.Case_Dealer__c);
                    if (led.MD__c == market) {
                        if (led.Account.Primary_Address_Reference__c != null) {
                            acclnk.Retail_Province__c = led.Account.Primary_Address_Reference__r.Province__c;
                            acclnk.Retail_City__c = led.Account.Primary_Address_Reference__r.Sub_District__c;
                            acclnk.Retail_Distinct__c = led.Account.Primary_Address_Reference__r.District__c;


                            acclnk.Retail_Address_Line_1__c = led.Account.Primary_Address_Reference__r.Address_Line_1__c;
                            acclnk.Retail_Address_Line_2__c = led.Account.Primary_Address_Reference__r.Address_Line_2__c;
                            acclnk.Retail_Address_Type__c = led.Account.Primary_Address_Reference__r.Address_Type__c;
                            acclnk.Retail_ZipCode__c = led.Account.Primary_Address_Reference__r.ZipCode__c;
                            acclnk.Retail_Address_CreatedDate__c = date.newinstance(led.Account.Primary_Address_Reference__r.CreatedDate.year(), led.Account.Primary_Address_Reference__r.CreatedDate.month(), led.Account.Primary_Address_Reference__r.CreatedDate.day());

                            acclnk.Retail_Address_LastModifiedDate__c = date.newinstance(led.Account.Primary_Address_Reference__r.Lastmodifieddate.year(), led.Account.Primary_Address_Reference__r.Lastmodifieddate.month(), led.Account.Primary_Address_Reference__r.Lastmodifieddate.day());
                            System.debug('**prprpr*' + acclnk.Retail_Address_CreatedDate__c + acclnk.Retail_Address_LastModifiedDate__c + date.newinstance(led.Account.Primary_Address_Reference__r.CreatedDate.year(), led.Account.Primary_Address_Reference__r.CreatedDate.month(), led.Account.Primary_Address_Reference__r.CreatedDate.day()));
                        }
                        acclnk.Retail_Country__c = led.Account.country__c;
                        acclnk.Retail_Full_Name_Title__c = (led.Account.Salutation__c + ' ' + led.Account.FirstName + ' ' + led.Account.LastName).left(140);
                        acclnk.Retail_Salutation__c = led.Account.Salutation__c;
                        acclnk.Retail_Special_Care__c = led.Account.Special_Care__c;
                        acclnk.createddate__c = led.Account.createdDate;
                        acclnk.Retail_ID_Type__c = led.Account.ID_Type__c;
                        acclnk.Retail_ID_Number__c = led.Account.ID_Number__c;
                        acclnk.LastModifiedDate__c = led.Account.LastmodifiedDate;
                        acclnk.Retail_LastName_Native__c = led.Account.LastName_Native_1__c;
                        acclnk.Retail_FirstName_Native__c = led.Account.FirstName_Native_1__c;
                        acclnk.Retail_Primary_Phone__c = led.Account.Primary_Phone__c;
                        acclnk.Retail_DMS_Customer_ID__c = led.Account.DMS_Customer_ID__c;
                        acclnk.Retail_DMS_Customer_ID__c = led.Account.DMS_Customer_ID__c;
                        acclnk.Retail_Full_Name__c = led.Account.FirstName + ' ' + led.Account.LastName;
                        acclnk.Retail_LastName__c = led.Account.LastName;
                        acclnk.Retail_FirstName__c = led.Account.FirstName;
                        acclnk.Retail_Complaint_Amount__c = led.Account.Complaint_Amount__c;
                        acclnk.Retail_Sales_Sanction__c = led.Account.Sales_Sanction__c;
                        acclnk.Retail_UCID__c = led.Account.UCID__c;
                        acclnk.Retail_Allow_Data_Sharing__c = led.Account.Allow_Data_Sharing__c;
                        acclnk.Retail_Mobile__c = led.Account.Mobile__c;
                        acclnk.Retail_Individual_Home_Phone__c = led.Account.Individual_Home_Phone__c;
                        acclnk.Retail_Work_Phone__c = led.Account.Work_Phone__c;
                        acclnk.Retail_Email__c = led.Account.PersonEmail;
                        acclnk.Retail_Fax__c = led.Account.Fax;
                        acclnk.Retail_Preferred_Contact_Method__c = led.Account.Preferred_Contact_Method__c;
                        acclnk.Retail_Email_OptOut__c = led.Account.PersonHasOptedOutOfEmail;
                        acclnk.Retail_Fax_OptOut__c = led.Account.PersonHasOptedOutOfFax;
                        //acclnk.Retail_Primary_Phone__c = led.Account.Primary_Phone_Display__c;
                        acclnk.Retail_Phone_OptOut__c = led.Account.PersonDoNotCall;
                        acclnk.Retail_Postal_OptOut__c = led.Account.Postal_Opt_Out__c;
                        acclnk.Retail_Visit_OptOut__c = led.Account.Visit_Opt_Out__c;
                        acclnk.Retail_PersonBirthdate__c = led.Account.PersonBirthdate;
                        acclnk.Retail_Occupation__c = led.Account.Occupation__c;
                        acclnk.Retail_Position__c = led.Account.Job__c;
                        acclnk.Retail_Preferred_Language__c = 'Malay';
                        acclnk.Retail_Gender__c = led.Account.Gender__c;
                        acclnk.Retail_Industry__c = led.Account.industry;
                        acclnk.Retail_WebSite__c = led.Account.Website;
                        acclnk.Retail_Company_Name_Native1__c = led.Account.Company_Name_Native_1__c;
                        acclnk.Retail_Commercial_Reg_No__c = led.Account.Commercial_Reg_No__c;

                        acclnk.Retail_Agreement__c = led.Account.Personal_Agreement__c;
                        acclnk.Retail_Information_Third_Party_Release__c = led.Account.Personal_Information_Third_Party_Release__c;
                        acclnk.Retail_Abroad_Agreement__c = led.Account.Personal_Abroad_Agreement__c;
                        acclnk.Retail_Agreement_Info_Processing__c = led.Account.Agreement_to_commit_info_processing__c;
                        acclnk.Retail_Vat_No__c = led.Account.Vat_No__c;
                        if (led.Account.Foundation_Date__c != null)
                            acclnk.Retail_Foundation_Month__c = String.valueOf(led.Account.Foundation_Date__c.year()) + (String.ValueOf(led.Account.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(led.Account.Foundation_Date__c.month())) : String.ValueOf(led.Account.Foundation_Date__c.month())) + (String.ValueOf(led.Account.Foundation_Date__c.day()).length() == 1 ? ('0' + String.ValueOf(led.Account.Foundation_Date__c.day())) : String.ValueOf(led.Account.Foundation_Date__c.day()));
                    }
                } else if (led.Account.RecordTypeId == AccountCompanyId) {

                    acclnk = new Account_Link__c(RecordTypeId = alkCompanyRecordTypeId, toRole__c = led.AccountId, fromRole__c = led.Case_Dealer__c);
                    if (led.MD__c == market) {
                        if (led.Account.Primary_Address_Reference__c != null) {
                            acclnk.Retail_Province__c = led.Account.Primary_Address_Reference__r.Province__c;
                            acclnk.Retail_City__c = led.Account.Primary_Address_Reference__r.Sub_District__c;
                            acclnk.Retail_Distinct__c = led.Account.Primary_Address_Reference__r.District__c;
                            acclnk.Retail_Address_Line_1__c = led.Account.Primary_Address_Reference__r.Address_Line_1__c;
                            acclnk.Retail_Address_Line_2__c = led.Account.Primary_Address_Reference__r.Address_Line_2__c;
                            acclnk.Retail_Address_Type__c = led.Account.Primary_Address_Reference__r.Address_Type__c;
                            acclnk.Retail_ZipCode__c = led.Account.Primary_Address_Reference__r.ZipCode__c;
                            acclnk.Retail_Address_CreatedDate__c = date.newinstance(led.Account.Primary_Address_Reference__r.CreatedDate.year(), led.Account.Primary_Address_Reference__r.CreatedDate.month(), led.Account.Primary_Address_Reference__r.CreatedDate.day());
                            //System.debug(date.newinstance(led.Account.Primary_Address_Reference__r.CreatedDate.year(), led.Account.Primary_Address_Reference__r.CreatedDate.month(), led.Account.Primary_Address_Reference__r.CreatedDate.day()));
                            acclnk.Retail_Address_LastModifiedDate__c = date.newinstance(led.Account.Primary_Address_Reference__r.Lastmodifieddate.year(), led.Account.Primary_Address_Reference__r.Lastmodifieddate.month(), led.Account.Primary_Address_Reference__r.Lastmodifieddate.day());
                        }
                        acclnk.Retail_Country__c = led.Account.country__c;
                        acclnk.Retail_UCID__c = led.Account.UCID__c;
                        acclnk.Retail_DMS_Customer_ID__c = led.Account.DMS_Customer_ID__c;
                        acclnk.Retail_Company_Name__c = led.Account.name;
                        acclnk.createddate__c = led.Account.createdDate;
                        acclnk.LastModifiedDate__c = led.Account.LastmodifiedDate;
                        acclnk.Retail_Company_Phone__c = led.Account.Individual_Home_Phone__c;
                        acclnk.Retail_Company_Other_Phone__c = led.Account.Work_Phone__c;
                        acclnk.Retail_Mobile__c = led.Account.Mobile__c;
                        acclnk.Retail_Email_OptOut__c = led.Account.PersonHasOptedOutOfEmail;
                        acclnk.Retail_Fax_OptOut__c = led.Account.PersonHasOptedOutOfFax;
                        acclnk.Retail_Primary_Phone__c = led.Account.Primary_Phone__c;
                        acclnk.Retail_Sales_Sanction__c = led.Account.Sales_Sanction__c;
                        acclnk.Retail_Phone_OptOut__c = led.Account.PersonDoNotCall;
                        acclnk.Retail_Postal_OptOut__c = led.Account.Postal_Opt_Out__c;
                        acclnk.Retail_Visit_OptOut__c = led.Account.Visit_Opt_Out__c;
                        acclnk.Retail_Fax__c = led.Account.fax;
                        acclnk.Retail_Industry__c = led.Account.Industry;
                        acclnk.Retail_Commercial_Reg_No__c = led.Account.Commercial_Reg_No__c;
                        acclnk.Retail_Vat_No__c = led.Account.Vat_No__c;
                        acclnk.Retail_WebSite__c = led.Account.Website;
                        acclnk.Retail_Agreement__c = led.Account.Personal_Agreement__c;
                        acclnk.Retail_Information_Third_Party_Release__c = led.Account.Personal_Information_Third_Party_Release__c;
                        acclnk.Retail_Abroad_Agreement__c = led.Account.Personal_Abroad_Agreement__c;
                        acclnk.Retail_Agreement_Info_Processing__c = led.Account.Agreement_to_commit_info_processing__c;
                        if (led.Account.Foundation_Date__c != null)
                            acclnk.Retail_Foundation_Month__c = String.valueOf(led.Account.Foundation_Date__c.year()) + (String.ValueOf(led.Account.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(led.Account.Foundation_Date__c.month())) : String.ValueOf(led.Account.Foundation_Date__c.month())) + (String.ValueOf(led.Account.Foundation_Date__c.day()).length() == 1 ? ('0' + String.ValueOf(led.Account.Foundation_Date__c.day())) : String.ValueOf(led.Account.Foundation_Date__c.day()));
                    }

                }

                if (led.Account.Primary_Address_Reference__c != null) {
                    acclnk.Retail_Address_Reference__c = led.Account.Primary_Address_Reference__c;

                }
                accLst.add(acclnk);
            }
        }
        if (!accLst.isEmpty()) {
            Database.SaveResult[] srList = Database.insert(accLst, false);
            for (Database.SaveResult sr: srList) {
                if (sr.isSuccess())
                    actlnkids.add(sr.getid());
            }
        }
    }
    
    public void ShareRecordswithDealers(List < Case > caselist, Boolean flag, String market) {
        Set < String > dealerndcodeset = new Set < String > ();
        set < Case > lstcase = new set < Case > ();
        set < caseShare > caseshare = new set < caseShare > ();
        set < id > casesharingtorevoke = new set < id > ();
        set < String > sharingrevokefromgroups = new set < String > ();
        List < Case > caselisttoiterat = [select id, createdby.usertype, createdby.Dealer_nd_code__c, Case_Dealer__c, Case_Dealer__r.Dealer_nd_code__c, ownerId from Case where id IN: caselist];
        Set < id > idset = new Set < id > ();
        for (Case c: caselisttoiterat) {
            idset.add(c.ownerid);
        }
        Map < id, User > usr = new map < id, User > ([select id, name, Dealer_nd_code__c, usertype from user where id IN: idset]);
        //below if part will work at the time of insert
        for (Case casesrec: caselisttoiterat) {
            if (!flag) {

                //if created by is Dealer then share those records with under that Dealer depends on dealer nd code
                if (casesrec.createdby.usertype == 'PowerPartner' && casesrec.createdby.Dealer_nd_code__c != null) {
                    String grpName = casesrec.createdby.Dealer_nd_code__c;
                    dealerndcodeset.add(grpName);
                    lstcase.add(casesrec);
                } else if (casesrec.Case_Dealer__c != null && casesrec.Case_Dealer__r.Dealer_nd_code__c != null) {
                    String grpName = casesrec.Case_Dealer__r.Dealer_nd_code__c;
                    dealerndcodeset.add(grpName);
                    lstcase.add(casesrec);
                }
            } else {

                //if trigger new map value is filled and  oldmap assigned dealer is null then share records with new assigned value
                //system.debug(((Case)trigger.oldmap.get(casesrec.id)).owner!=((Case)trigger.newmap.get(casesrec.id)).owner);
                system.debug(((Case) trigger.oldmap.get(casesrec.id)).ownerId + '  ' + ((Case) trigger.newmap.get(casesrec.id)).ownerId);
                if (((Case) trigger.newmap.get(casesrec.id)).Case_Dealer__c != null && ((Case) trigger.oldMap.get(casesrec.id)).Case_Dealer__c == null && casesrec.Case_Dealer__r.Dealer_nd_code__c != null) {
                    String grpName = casesrec.Case_Dealer__r.Dealer_nd_code__c;
                    dealerndcodeset.add(grpName);
                    lstcase.add(casesrec);
                }
                //if trigger old is not equal to trigger new  then give access to new dealer and then revoke access from old dealer
                else if (((Case) trigger.newmap.get(casesrec.id)).Case_Dealer__c != null && ((Case) trigger.oldMap.get(casesrec.id)).Case_Dealer__c != null && ((Case) trigger.newmap.get(casesrec.id)).Case_Dealer__c != ((Case) trigger.oldmap.get(casesrec.id)).Case_Dealer__c && casesrec.Case_Dealer__r.Dealer_nd_code__c != null) {
                    String grpName = casesrec.Case_Dealer__r.Dealer_nd_code__c;
                    dealerndcodeset.add(grpName);
                    lstcase.add(casesrec);
                    //will revoke record access depends on dealer nd code  if we change the assigned dealer
                    if (((Case) trigger.newmap.get(casesrec.id)).Case_Dealer__r.Dealer_nd_code__c != null) {
                        sharingrevokefromgroups.add(((Case) trigger.oldmap.get(casesrec.id)).Case_Dealer__r.Dealer_nd_code__c);
                        casesharingtorevoke.add(((Case) trigger.oldmap.get(casesrec.id)).id);
                    }
                }
                //if trigger old value is filled and new value did not filled then revoke access from old Dealer
                else if (((Case) trigger.oldmap.get(casesrec.id)).Case_Dealer__c != null && ((Case) trigger.newmap.get(casesrec.id)).Case_Dealer__c == null) {
                    sharingrevokefromgroups.add(((Case) trigger.oldmap.get(casesrec.id)).Case_Dealer__r.Dealer_nd_code__c);
                    casesharingtorevoke.add(((Case) trigger.oldmap.get(casesrec.id)).id);
                } else if (((Case) trigger.oldmap.get(casesrec.id)).ownerId != ((Case) trigger.newmap.get(casesrec.id)).ownerId) {
                    String grpName = usr.get(casesrec.ownerid).dealer_nd_code__c;
                    dealerndcodeset.add(grpName);
                    lstcase.add(casesrec);
                }
            }
        }
        for (Group gp: [select id, name from Group where name IN: dealerndcodeset]) {
            for (Case caseid: lstcase) {
                //this if part will applicable for Salesforce users
                String grpName = caseid.Case_Dealer__r.Dealer_nd_code__c;
                String createdGrpName = caseid.createdby.Dealer_nd_code__c;
                if (gp.name == grpName) {
                    caseshare.add(new caseShare(CaseId = caseid.id, UserOrGroupId = gp.id, RowCause = Schema.caseShare.Rowcause.manual, CaseAccessLevel = 'EDIT'));
                } //this else part will applicable for Dealer users
                else if (gp.name == createdGrpName && caseid.createdby.Usertype == 'PowerPartner') {
                    caseshare.add(new caseShare(CaseId = caseid.id, UserOrGroupId = gp.id, RowCause = Schema.caseShare.Rowcause.manual, CaseAccessLevel = 'EDIT'));
                }
            }
        }

        //else part will work at the time of Update

        if (caseshare.size() > 0) {
            List < caseShare > caseshareList = new List < caseShare > ();
            caseshareList.addall(caseshare);
            Database.insert(caseshareList);
            if (casesharingtorevoke.size() > 0) {
                database.delete([select id from caseShare where Id IN: casesharingtorevoke and UserOrGroupId IN: sharingrevokefromgroups]);
            }
        }

    }
    
    public Static Map<ID, ID> getAccountToDCGKUser(Set<ID> Accid){
        Map<ID,ID> mAccToDLGKUser = new Map<ID,ID>();
        Map<ID,ID> mContactToUsr = new Map<ID,ID>();
        
        for(User user : [Select id, contact.AccountID, ContactID from user where contact.AccountID in :Accid and isActive = true]){
            mContactToUsr.put(user.contactID, user.id);
        }
        
        for(Contact con : [Select id, AccountID from contact where AccountID in :Accid and Dealer_Complaint_Gate_Keeper__c = true]){
            mAccToDLGKUser.put(con.AccountID, mContactToUsr.get(con.id));
        }
        
        return mAccToDLGKUser;
    }
    
/* Data Migration Explicit Fix - Santosh Mohanty */
    public static void updatemarket(List<Case> caseList){        
        
               for(Case caseRec : caseList){
                    if(Test.isRunningTest()){
                        caseRec.isTestRunning__c=true;
                    }
                   if(caseRec.Market__c =='' || caseRec.Market__c==NULL){
                     caseRec.Market__c=caseRec.MD__c;
                  }  
              }       
    }
}