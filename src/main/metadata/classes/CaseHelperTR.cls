
/**
* Utility for Trigger on Case to handle business logic
* Author:Hildaa
*/

public class CaseHelperTR {
    
    CaseHelperBase caseHelperBased = new CaseHelperBase();
    string market = System.Label.TR;
    public Id caseINquiryId = RecordTypeAccessService.getRecordTypeId('Case',Label.Case_Record_Type_Inquiry); 
    public Id caseMBComplaintRec_Id = RecordTypeAccessService.getRecordTypeId('Case',Label.Case_Record_Type_Complaint);
     private static final String alkCompanyRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    private static final String alkpersonRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    private static final String PersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static final String AccountCompanyId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    public static final String NOT_PRIMARY_REMINDER = 'This Complaint is not a primary complaint, please find the primary complaint.';
    public Map<Id, List<Id>> accountCaseMap = new Map<Id, List<Id>>();
     public List<Id> tmpCaseIds = new List<Id>();
     public List<Account> updateAccount = new List<Account>();
       Map<Id, List<Id>> parentIdChildIds = new Map<Id, List<Id>>();
    Set<Id> parenthasParents = new Set<Id>();
    Set<Id> parentIds = new Set<Id>();
    map<id,case> caseQueueId = new map<id,case>();
    set<Id> ownerIds = new set<id>();
    
    map<string,id> gscodeIds = new Map<string,id>();
    Map<string,Id> GrpMap = new map<string,Id>();
    
    
    public void updateCaseStatus(List<case> caselist,Map<Id,Case> oldValcase,boolean isInsert,boolean isUpdate){
         for(Case cs:caselist){
             if(cs.Market__c == market && ((isInsert && cs.Case_Dealer__c != null) || (isUpdate && cs.Case_Dealer__c != oldValcase.get(cs.Id).Case_Dealer__c && cs.Case_Dealer__c != null)))
                 cs.status = 'Awaiting Feedback From Dealer';
              
         }
    }
    public void updatePrimaryCaseDealerbasedonCaseOwner(List < Case > caselist,Map<Id,Case> oldValcase,boolean isInsert,boolean isUpdate) {
        for(case cs:caselist)
        {
            if(cs.market__c == market && !string.valueof(cs.ownerId).startswith('005') && (isInsert || (isUpdate && cs.ownerid != oldValcase.get(cs.Id).ownerId)))
            {
                caseQueueId.put(cs.id,cs);
                ownerIds.add(cs.ownerId);
            }
        }
        for(Group grp : [select id,name from group where Type='Queue' and id in :ownerIds])
        {
            GrpMap.put(string.valueof(grp.Name).right(9),grp.Id);
        }
        system.debug('Gropus '+GrpMap);
        for(account ac :[select id,name,dealer_nd_code__c,dealer_GS_code__c from account where recordtype.name='Dealer' and market__c=:market and dealer_GS_code__c IN :GrpMap.keyset()])
        {
            if(GrpMap != null && ac.dealer_GS_code__c != null && GrpMap.get(ac.dealer_GS_code__c) != null)
                gscodeIds.put(GrpMap.get(ac.dealer_GS_code__c),ac.Id);
        }
        system.debug('gs codes '+gscodeIds);
        for(case cs:caseQueueId.values())
        {
            system.debug('----> '+cs.ownerid+' ; '+gscodeIds.get(cs.ownerid));
            if(gscodeIds != null && gscodeIds.get(cs.ownerid) != null){
                system.debug('----> inside if loop');
                cs.case_dealer__c  =  gscodeIds.get(cs.ownerid);
            }
            
        }
    }
    public void ShareRecordswithDealers(List < Case > caselist, Boolean flag, String market) {
        Set < String > dealerndcodeset = new Set < String > ();
        set < Case > lstcase = new set < Case > ();
        set < caseShare > caseshare = new set < caseShare > ();
        set < id > casesharingtorevoke = new set < id > ();
        set < String > sharingrevokefromgroups = new set < String > ();
        List < Case > caselisttoiterat = [select id, createdby.usertype, createdby.Dealer_nd_code__c, Case_Dealer__c, Case_Dealer__r.Dealer_nd_code__c,Case_Dealer__r.market__c,Market__c,createdby.Market__c,ownerId from Case where id IN: caselist];
        Set < id > idset = new Set < id > ();
        for (Case c: caselisttoiterat) {
            idset.add(c.ownerid);
        }
        Map < id, User > usr = new map < id, User > ([select id, name, Dealer_nd_code__c, usertype,Market__c from user where id IN: idset]);
        //below if part will work at the time of insert
        for (Case casesrec: caselisttoiterat) {
            if (!flag) {

                //if created by is Dealer then share those records with under that Dealer depends on dealer nd code
                if (casesrec.createdby.usertype == 'PowerPartner' && casesrec.createdby.Dealer_nd_code__c != null) {
                    //String grpName = casesrec.createdby.Dealer_nd_code__c;
          String grpName = casesrec.createdby.Market__c+casesrec.createdby.Dealer_nd_code__c;
                    dealerndcodeset.add(grpName);
                    lstcase.add(casesrec);
                } else if (casesrec.Case_Dealer__c != null && casesrec.Case_Dealer__r.Dealer_nd_code__c != null) {
                    //String grpName = casesrec.Case_Dealer__r.Dealer_nd_code__c;
          String grpName = casesrec.Case_Dealer__r.Market__c+casesrec.Case_Dealer__r.Dealer_nd_code__c;
                    dealerndcodeset.add(grpName);
                    lstcase.add(casesrec);
                }
            } else {

                system.debug(((Case) trigger.oldmap.get(casesrec.id)).ownerId + '  ' + ((Case) trigger.newmap.get(casesrec.id)).ownerId);
                if (((Case) trigger.newmap.get(casesrec.id)).Case_Dealer__c != null && ((Case) trigger.oldMap.get(casesrec.id)).Case_Dealer__c == null && casesrec.Case_Dealer__r.Dealer_nd_code__c != null) {
                    //String grpName = casesrec.Case_Dealer__r.Dealer_nd_code__c;
          String grpName = casesrec.Case_Dealer__r.Market__c+casesrec.Case_Dealer__r.Dealer_nd_code__c;
          dealerndcodeset.add(grpName);
                    lstcase.add(casesrec);
                }
        else if (((Case) trigger.newmap.get(casesrec.id)).Case_Dealer__c != null && ((((Case) trigger.oldMap.get(casesrec.id)).Case_Dealer__c != null && ((Case) trigger.newmap.get(casesrec.id)).Case_Dealer__c != ((Case) trigger.oldmap.get(casesrec.id)).Case_Dealer__c ) || ((Case) trigger.oldMap.get(casesrec.id)).Case_Dealer__c != null && ((Case) trigger.newmap.get(casesrec.id)).ownerid != ((Case) trigger.oldmap.get(casesrec.id)).Ownerid)&& casesrec.Case_Dealer__r.Dealer_nd_code__c != null) {
                    //String grpName = casesrec.Case_Dealer__r.Dealer_nd_code__c;
          String grpName = casesrec.Case_Dealer__r.market__c+casesrec.Case_Dealer__r.Dealer_nd_code__c;
                    dealerndcodeset.add(grpName);
                    lstcase.add(casesrec);
                    //will revoke record access depends on dealer nd code  if we change the assigned dealer
                    if (((Case) trigger.newmap.get(casesrec.id)).Case_Dealer__r.Dealer_nd_code__c != null && ((Case) trigger.oldMap.get(casesrec.id)).Case_Dealer__c!=casesrec.Case_Dealer__c) {
                        sharingrevokefromgroups.add(((Case) trigger.oldmap.get(casesrec.id)).Case_Dealer__r.Dealer_nd_code__c);
                        casesharingtorevoke.add(((Case) trigger.oldmap.get(casesrec.id)).id);
                    }
                }
                else if (((Case) trigger.oldmap.get(casesrec.id)).Case_Dealer__c != null && ((Case) trigger.newmap.get(casesrec.id)).Case_Dealer__c == null) {
                    sharingrevokefromgroups.add(((Case) trigger.oldmap.get(casesrec.id)).Case_Dealer__r.Dealer_nd_code__c);
                    casesharingtorevoke.add(((Case) trigger.oldmap.get(casesrec.id)).id);
                } 
        else if (((Case) trigger.oldmap.get(casesrec.id)).ownerId != ((Case) trigger.newmap.get(casesrec.id)).ownerId) {
                   // String grpName = usr.get(casesrec.ownerid).dealer_nd_code__c;
            String grpName = usr.get(casesrec.ownerid).Market__c+usr.get(casesrec.ownerid).dealer_nd_code__c;
                    dealerndcodeset.add(grpName);
                    lstcase.add(casesrec);
                }
        else if(string.isnotblank(casesrec.Case_Dealer__c)){
        String grpName = casesrec.Case_Dealer__r.market__c+casesrec.Case_Dealer__r.Dealer_nd_code__c;
                    dealerndcodeset.add(grpName);
          lstcase.add(casesrec);
        }
            }
        }
    if(dealerndcodeset.size()>0){
      for (Group gp: [select id, name from Group where name IN: dealerndcodeset]) {
        for (Case caseid: lstcase) {
          //this if part will applicable for Salesforce users

          String grpName = caseid.Case_Dealer__r.market__c+caseid.Case_Dealer__r.Dealer_nd_code__c;
          String createdGrpName = caseid.createdby.Market__c+caseid.createdby.Dealer_nd_code__c;
          if (gp.name == grpName) {
            caseshare.add(new caseShare(CaseId = caseid.id, UserOrGroupId = gp.id, RowCause = Schema.caseShare.Rowcause.manual, CaseAccessLevel = 'EDIT'));
          } //this else part will applicable for Dealer users
          else if (gp.name == createdGrpName && caseid.createdby.Usertype == 'PowerPartner') {
            caseshare.add(new caseShare(CaseId = caseid.id, UserOrGroupId = gp.id, RowCause = Schema.caseShare.Rowcause.manual, CaseAccessLevel = 'EDIT'));
          }
        }
      }
    }
        //else part will work at the time of Update

        if (caseshare.size() > 0) {
            List < caseShare > caseshareList = new List < caseShare > ();
            caseshareList.addall(caseshare);
            insert(caseshareList);
            if (casesharingtorevoke.size() > 0) {
                database.delete([select id from caseShare where Id IN: casesharingtorevoke and UserOrGroupId IN: sharingrevokefromgroups]);
            }
        }

    }
    public void updateTurnAroundTime(List<case> caselist,Map<Id,Case> oldValcase,boolean isInsert,boolean isUpdate){
        for(Case cs:caselist){
            if(isInsert && cs.Market__c == market && cs.status == 'Closed')
                cs.Turnaround_time_In_Days_c_with_public__c = 0;
             else if(isUpdate && cs.Market__c == market && (cs.status!= oldValcase.get(cs.Id).status) && cs.status == 'Closed'){
                businessHours bhrs = [Select Id from BusinessHours where Name = :Label.TRCountry];
                Long diffValue = BusinessHours.diff(bhrs.Id,cs.createddate,system.now());
                Long HrsValue = diffValue/(1000 * 60 * 60);
                Integer DaysValue = Integer.valueof(HrsValue/24);
                if(math.mod(HrsValue, 24) != 0)
                    DaysValue = DaysValue + 1;
                cs.Turnaround_time_In_Days_c_with_public__c = daysvalue;
                
            }
    }

    }
    
    public void updateCaseDeadLineAmount(List<case> caselist, string market,Map<Id,Case> oldValcase){
        for(Case cs:caselist){
            Datetime dow = System.now();
            if(cs.recordtypeId == caseINquiryId)
                dow = dow + 1;
            else if (cs.recordtypeId == caseMBComplaintRec_Id)
                dow = dow + 5;
            string dayOfWeek = dow.format('E');
            if(dayOfWeek =='Sat'){
                cs.deadline__c = dow + 2;
            }
            else if(dayOfWeek =='Sun'){
                cs.deadline__c = dow + 1;
            }
            else
                cs.deadline__c = dow;     
        }
    }
    
    public void calculateComplaintAmount(List<Case> cases, string market){
         Set<Id> accounts = new Set<Id>();
        List<Account> accRecords;
        for(Case c : cases){
            if(c.Market__c == market && c.RecordTypeId ==caseMBComplaintRec_Id  ){
               if(trigger.isinsert) accounts.add (c.AccountId);
               if(trigger.isupdate){
        if(c.accountid != ((Case)Trigger.oldMap.get(c.ID)).AccountID) //accounts.add(((Case)Trigger.oldMap.get(c.ID)).AccountID);
		accounts.add (c.AccountId);
         }
      }
        }                       
        accounts.remove(NULL);
        List<Case> case_acc = [Select Id, AccountId From Case 
                              Where (AccountId IN :accounts AND RecordTypeId =:caseMBComplaintRec_Id and Market__c =: market) LIMIT 50000]; 
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
    
    //createretailcopy
     public void CreateRetailCopy(List<case> caselist, Map<Id,Case> caseOldMap, boolean isInsert, boolean isUpdate, String market){
    set < String > dealerid = new set < String > ();
        set < String > accId = new set < String > ();
        set < String > actlnkids = new set < String > ();
        List < Account_Link__c > accLst = new List < Account_Link__c > ();
        List < Account_Link__c > dealercount = new List < Account_Link__c > ();
        List < Case > caseLst = [select Id, AccountId, Case_Dealer__c, Account.LastName, Account.FirstName, Account.LastName_Native_1__c, Account.ID_Type__c, Account.ID_Number__c, Account.country__c,
            Account.FirstName_Native_1__c, Account.PersonBirthdate, Account.Special_Care__c, Account.Individual_Home_Phone__c, Account.Work_Phone__c, Account.Primary_Address_Reference__r.Sub_District__c,
            Account.Mobile__c, Account.Fax, Account.Email__c, Account.Primary_Address_Reference__r.City__c, Account.Primary_Address_Reference__r.District__c, Account.createdDate, Account.lastmodifieddate,
            Account.Primary_Address_Reference__r.Block__c, Account.Primary_Address_Reference__r.Address_Line_1__c,Account.Primary_Address_Reference__r.Address_Line_3__c,
            Account.Primary_Address_Reference__r.Address_Line_2__c, Account.Primary_Address_Reference__r.ZipCode__c,
            Account.Primary_Address_Reference__r.CreatedDate, Account.Primary_Address_Reference__r.LastModifiedDate,
            Account.gender__c, Account.Occupation__c, Account.Primary_Phone__c, Account.Industry, Account.Preferred_Language__c,
            Account.Special_Needs_Class__c, Account.Allow_Data_Sharing2__c, Account.Primary_Address_Reference__r.Address_Type__c,
            Account.Primary_Address_Reference__r.Province__c, Account.Preferred_Contact_Method__c, MD__c,Account.Title__c,
            Account.UCID__c, Account.Salutation__c, Account.RecordtypeId, Account.Name, Account.Company_Name_Native_1__c, Account.Foundation_Date__c, Account.Primary_Address_Reference__r.Foreign_Nationals__c,
            Account.Website, Account.Vat_No__c, market__c,Account.DMS_Customer_ID__c, Account.Complaint_Amount__c, Account.Sales_Sanction__c, Account.Allow_Data_Sharing__c, Account.PersonEmail, Account.PersonHasOptedOutOfEmail, Account.PersonHasOptedOutOfFax, Account.Primary_Phone_Display__c, Account.PersonDoNotCall, Account.Postal_Opt_Out__c, Account.Job__c, Account.Personal_Agreement__c, Account.Personal_Information_Third_Party_Release__c, Account.Personal_Abroad_Agreement__c, Account.Agreement_to_commit_info_processing__c, Account.Commercial_Reg_No__c, Account.Company_Name__c, Account.Visit_Opt_Out__c,Case_Dealer__r.Dealer_Rollout_Status__c
            from Case WHERE id IN: caselist
        ];

        for (Case cs: caseLst) {
            if (cs.Case_Dealer__c != null && cs.Market__c== market) {
                if (isInsert || (isUpdate && cs.Case_Dealer__c != caseOldMap.get(cs.id).Case_Dealer__c)) {
                    dealerid.add(cs.Case_Dealer__c);
                }
            }
            if (string.isnotblank(cs.AccountId)) {
                accId.add(cs.AccountId);
            }
        }

        if (dealerid.size() > 0) {
            dealercount = [select id from Account_Link__c WHERE fromRole__c IN: dealerId AND toRole__c IN: accId AND(RecordTypeId =: alkCompanyRecordTypeId OR RecordTypeId =: alkpersonRecordTypeId) AND(Retail_Delete_Flag__c = false AND Retail_Duplicate_Flag__c = false)];
        }
        for (Case led: caseLst) {
            System.debug('11*');
            if (string.isnotblank(led.Case_Dealer__c)  && (String.isnotblank(led.Case_Dealer__r.Dealer_Rollout_Status__c)?(led.Case_Dealer__r.Dealer_Rollout_Status__c=='Done'):false) && (dealercount.isEmpty() || dealercount == null || dealercount.size() == 0) && (isInsert || (isUpdate && led.Case_Dealer__c != caseOldMap.get(led.id).Case_Dealer__c)) && dealerid.size() > 0) {
                Account_Link__c acclnk = new Account_Link__c();
                //accLst.add(acclnk);
                System.debug('22*' + led.Account.RecordTypeId + PersonRecordTypeId);
                if (led.Account.RecordTypeId == PersonRecordTypeId) {
                    System.debug('33*');
                    acclnk = new Account_Link__c(RecordTypeId = alkpersonRecordTypeId, toRole__c = led.AccountId, fromRole__c = led.Case_Dealer__c);
                    if (led.MD__c == market) {
                        if (led.Account.Primary_Address_Reference__c != null) {
                acclnk.Retail_Address_Type__c = led.Account.Primary_Address_Reference__r.Address_Type__c;
                acclnk.Retail_Province__c =led.Account.Primary_Address_Reference__r.Province__c !=null ?led.Account.Primary_Address_Reference__r.Province__c: '' ;
                acclnk.Retail_City__c = (led.Account.Primary_Address_Reference__r.District__c != null ? led.Account.Primary_Address_Reference__r.District__c:'').left(35);
                acclnk.Retail_Distinct__c = (led.Account.Primary_Address_Reference__r.District__c!=null ? led.Account.Primary_Address_Reference__r.District__c : '');
                acclnk.Retail_Address_Line_1__c = (led.Account.Primary_Address_Reference__r.Address_Line_1__c!=null?led.Account.Primary_Address_Reference__r.Address_Line_1__c:'').left(35);
                acclnk.Retail_Address_Line_2__c = (led.Account.Primary_Address_Reference__r.Address_Line_2__c!=null?led.Account.Primary_Address_Reference__r.Address_Line_2__c:'').left(35);
                acclnk.Retail_Address_Line_3__c = (led.Account.Primary_Address_Reference__r.Address_Line_3__c!=null?led.Account.Primary_Address_Reference__r.Address_Line_3__c:'').left(35);
                acclnk.Retail_ZipCode__c = led.Account.Primary_Address_Reference__r.ZipCode__c!=null ? led.Account.Primary_Address_Reference__r.ZipCode__c : '';
                acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(led.Account.Primary_Address_Reference__r.CreatedDate);
                acclnk.Retail_Address_LastModifiedDate__c = Date.ValueOf(led.Account.Primary_Address_Reference__r.LastModifiedDate);
                acclnk.Retail_Address_Reference__c=led.Account.Primary_Address_Reference__c;
              /*
                            acclnk.Retail_Province__c = led.Account.Primary_Address_Reference__r.Province__c;
                            acclnk.Retail_City__c = led.Account.Primary_Address_Reference__r.District__c;
                            acclnk.Retail_Distinct__c = led.Account.Primary_Address_Reference__r.District__c;
                            acclnk.Retail_Address_Line_1__c = led.Account.Primary_Address_Reference__r.Address_Line_1__c;
                            acclnk.Retail_Address_Line_2__c = led.Account.Primary_Address_Reference__r.Address_Line_2__c;
              acclnk.Retail_Address_Line_3__c = led.Account.Primary_Address_Reference__r.Address_Line_3__c;
                            acclnk.Retail_Address_Type__c = led.Account.Primary_Address_Reference__r.Address_Type__c;
                            acclnk.Retail_ZipCode__c = led.Account.Primary_Address_Reference__r.ZipCode__c;
                            acclnk.Retail_Address_CreatedDate__c = date.newinstance(led.Account.Primary_Address_Reference__r.CreatedDate.year(), led.Account.Primary_Address_Reference__r.CreatedDate.month(), led.Account.Primary_Address_Reference__r.CreatedDate.day());
              acclnk.Retail_Address_LastModifiedDate__c = date.newinstance(led.Account.Primary_Address_Reference__r.Lastmodifieddate.year(), led.Account.Primary_Address_Reference__r.Lastmodifieddate.month(), led.Account.Primary_Address_Reference__r.Lastmodifieddate.day());
              */
            }
                        acclnk.Retail_Country__c = led.Account.country__c;
                        acclnk.Retail_Full_Name_Title__c = ((string.isnotblank(led.Account.Title__c)?led.Account.Title__c:'') + ' ' + led.Account.FirstName + ' ' + led.Account.LastName).left(140);
                        acclnk.Retail_Salutation__c = led.Account.Title__c;
                        acclnk.Retail_Special_Care__c = led.Account.Special_Care__c;
                        acclnk.createddate__c = led.Account.createdDate;
                        acclnk.Retail_ID_Type__c = led.Account.ID_Type__c;
                        acclnk.Retail_ID_Number__c = led.Account.ID_Number__c;
                        acclnk.LastModifiedDate__c = led.Account.LastmodifiedDate;
                        acclnk.Retail_LastName_Native__c = led.Account.LastName_Native_1__c;
                        acclnk.Retail_FirstName_Native__c = led.Account.FirstName_Native_1__c;
                        acclnk.Retail_Primary_Phone__c = led.Account.Primary_Phone__c;
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
                           /* acclnk.Retail_Province__c = led.Account.Primary_Address_Reference__r.Province__c;
                            acclnk.Retail_City__c = led.Account.Primary_Address_Reference__r.District__c;
                            acclnk.Retail_Distinct__c = led.Account.Primary_Address_Reference__r.District__c;
                            acclnk.Retail_Address_Line_1__c = led.Account.Primary_Address_Reference__r.Address_Line_1__c;
                            acclnk.Retail_Address_Line_2__c = led.Account.Primary_Address_Reference__r.Address_Line_2__c;
              acclnk.Retail_Address_Line_3__c = led.Account.Primary_Address_Reference__r.Address_Line_3__c;
                            acclnk.Retail_Address_Type__c = led.Account.Primary_Address_Reference__r.Address_Type__c;
                            acclnk.Retail_ZipCode__c = led.Account.Primary_Address_Reference__r.ZipCode__c;
                            acclnk.Retail_Address_CreatedDate__c = date.newinstance(led.Account.Primary_Address_Reference__r.CreatedDate.year(), led.Account.Primary_Address_Reference__r.CreatedDate.month(), led.Account.Primary_Address_Reference__r.CreatedDate.day());
                            //System.debug(date.newinstance(led.Account.Primary_Address_Reference__r.CreatedDate.year(), led.Account.Primary_Address_Reference__r.CreatedDate.month(), led.Account.Primary_Address_Reference__r.CreatedDate.day()));
                            acclnk.Retail_Address_LastModifiedDate__c = date.newinstance(led.Account.Primary_Address_Reference__r.Lastmodifieddate.year(), led.Account.Primary_Address_Reference__r.Lastmodifieddate.month(), led.Account.Primary_Address_Reference__r.Lastmodifieddate.day());
              */
               acclnk.Retail_Address_Type__c = led.Account.Primary_Address_Reference__r.Address_Type__c;
                acclnk.Retail_Province__c =led.Account.Primary_Address_Reference__r.Province__c !=null ?led.Account.Primary_Address_Reference__r.Province__c: '' ;
                acclnk.Retail_City__c =( led.Account.Primary_Address_Reference__r.District__c != null ? led.Account.Primary_Address_Reference__r.District__c:'').left(35);
                acclnk.Retail_Distinct__c = (led.Account.Primary_Address_Reference__r.District__c!=null ? led.Account.Primary_Address_Reference__r.District__c : '');
                acclnk.Retail_Address_Line_1__c = (led.Account.Primary_Address_Reference__r.Address_Line_1__c!=null?led.Account.Primary_Address_Reference__r.Address_Line_1__c:'').left(35);
                acclnk.Retail_Address_Line_2__c = (led.Account.Primary_Address_Reference__r.Address_Line_2__c!=null?led.Account.Primary_Address_Reference__r.Address_Line_2__c:'').left(35);
                acclnk.Retail_Address_Line_3__c = (led.Account.Primary_Address_Reference__r.Address_Line_3__c!=null?led.Account.Primary_Address_Reference__r.Address_Line_3__c:'').left(35);
                acclnk.Retail_ZipCode__c = led.Account.Primary_Address_Reference__r.ZipCode__c!=null ? led.Account.Primary_Address_Reference__r.ZipCode__c : '' ;
                acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(led.Account.Primary_Address_Reference__r.CreatedDate);
                acclnk.Retail_Address_LastModifiedDate__c = Date.ValueOf(led.Account.Primary_Address_Reference__r.LastModifiedDate);
                acclnk.Retail_Address_Reference__c=led.Account.Primary_Address_Reference__c;
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
    
    
    //Calculate the number of Repeated Case for an account 
    public  void countRepeatComplaintCase (List<case> cases,boolean isInsert, string market) {
        for(Case caseNew : cases) {
            if (isInsert){
                if (caseMBComplaintRec_Id == caseNew.RecordTypeId && caseNew.Market__c == market && caseNew.ParentId != null){    
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
                if (caseMBComplaintRec_Id == caseNew.RecordTypeId &&caseNew.Market__c == market){
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
}