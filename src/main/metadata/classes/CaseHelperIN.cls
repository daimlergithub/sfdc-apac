/**
* Utility for Trigger on Case to handle business logic
* Author: Shashi Goswami
* Created Date : 18th April 2018
*/

public class CaseHelperIN {

    CaseHelperBase caseHelperBaseInstance = new CaseHelperBase();
    string market = System.Label.IN;
    public void updatemarket(List<case> cases){
        caseHelperBase.updatemarket(cases);
    }
    
    //To Calculate total complaints associated with an Account
    public void calculateComplaintAmount(List<Case> cases, string market){
        caseHelperBaseInstance.calculateComplaintAmount(cases,market);
    }
    
    //To count how many times a complaint was repeated
    public  void countRepeatComplaintCase (List<case> cases,boolean isInsert, string market) {
        caseHelperBaseInstance.countRepeatComplaintCase(cases,isInsert,market);    
    }
    
    //Update Owner of case to the GateKeeper of the Dealer added to case
    public void updateCaseOwnerDependsonPrimaryCaseDealer(List<case> cases,boolean isInsert, String market){
        caseHelperBaseInstance.updateCaseOwnerDependsonPrimaryCaseDealer(cases, isInsert, market);
    }
    
    //To change the Case Dealer same as the creator if the case is created by a dealer
    public void changeDealerAccount(List<case> cases, String market){
        caseHelperBaseInstance.changeDealerAccount(cases, market);
    }
    
    //To create a Retail Copy(Account Link) of Case Account
    public void CreateRetailCopy(List<case> cases, Map<Id,Case> oldValcase, boolean isInsert, boolean isUpdate, String market){
        caseHelperBaseInstance.CreateRetailCopy(cases, oldValcase, isInsert, isUpdate, market);
    }
    
    //To share the Case record with the assigned dealers
    public void ShareRecordswithDealers(List<case> cases, boolean isUpdate, String market){
        caseHelperBaseInstance.ShareRecordswithDealers(cases, isUpdate, market);
    }
    //Added to update Customer Phase of Account 
    public void changeCustomerPhase(List<Case> caseList){
        System.debug('Custom phase method');
        Id complaintRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordtypeID();
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> oIdSet = new Set<Id>();
        List<Account> accList = new List<Account>();
        Map<Id,Account> accMapToUpdate = new Map<Id,Account>();
        Map<Id,List<Case>> accCareMap= new Map<Id,List<Case>>();
        List<Case> existingCareList = new List<Case>();
        List<Case> careToBeRemoved = new List<Case>();
        List<account> accListToUpdate = new List<account>();
        List<account> oppAcc = new List<account>();
        List<Opportunity> oppList = new List<Opportunity>();
        for(Case c:caseList){
            accIdSet.add(c.AccountId); // Adding all the case account ids to a set
            //for update call
            if(c.Id!=null){
                oIdSet.add(c.Id); // Adding all the case ids to a set
            }
        }
        System.debug('Custom phase accIdSet '+accIdSet);
        if(accIdSet!= null){        
            accList = [Select Id, Customer_Lifecycle_Phase__c from Account where ID IN: accIdSet];
            //Querying all other existing cases associated to the accounts of the account set
            existingCareList=[Select Id, AccountID, Status, RecordTypeId from Case where AccountId IN:accIdSet and Id Not IN:oIdSet and Status='Open' and RecordTypeId =:complaintRecordTypeId];
        }
        for(account a:accList){
            List<Case> cList = new List<Case>();
            for(Case c:existingCareList){
                if(a.Id==c.AccountId){
                    cList.add(c); // Adding queried existing cases to a list 
                }   
            }
            for(Case c:caseList){
                if(a.Id==c.AccountId && c.Status=='Open' && c.RecordTypeId == complaintRecordTypeId){
                    cList.add(c); // Adding complaint cases to a list 
                } 
            }
            accCareMap.put(a.Id,cList); // Creating a map of Account Id with Associated Case List
            System.debug('Custom phase cList '+cList);
        }
        System.debug('Custom phase accCareMap '+accCareMap);
        for(account a:accList){
            if(accCareMap.get(a.Id) != null){
                a.Customer_Lifecycle_Phase__c = 'Care'; // Change Customer Phase of Account with associated complaint to Care
                accMapToUpdate.put(a.Id,a);
            }
        } 
        System.debug('Custom phase accMapToUpdate '+accMapToUpdate);
        accListToUpdate = accMapToUpdate.values();
        if(accListToUpdate!= null){
            update accListToUpdate;
        }
    }
    
    //Add Customer Phase of Account according to Opportunity 
    public void removeCustomerPhaseCare(List<Case> caseList){
        System.debug('entered Custom phase ');
        Id complaintRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordtypeID();
        Set<Id> accIdSet = new Set<Id>();
        List<Account> accList = new List<Account>();
        List<account> oppAcc = new List<account>();
        List<Opportunity> oppList = new List<Opportunity>();
        Case OldValue= new Case();
        for(Case c:caseList){
            accIdSet.add(c.AccountId);
        }
        System.debug('entered Custom phase accIdSet '+accIdSet);
        if(accIdSet!= null){        
            accList = [Select Id, Customer_Lifecycle_Phase__c from Account where ID IN: accIdSet];
        }

        for(account a:accList){
            List<Case> cList = new List<Case>();
            for(Case c:caseList){
                if(c.Id != null && Trigger.oldMap.get(c.Id) != null){
                    OldValue = (Case) Trigger.oldMap.get(c.Id);
                }
                if(a.Id==c.AccountId && c.Id != null  && c.Status!='Open' && OldValue.Status == 'Open' && c.RecordTypeId == complaintRecordTypeId){
                    oppAcc.add(a);
                }
            }
        }
        oppList=[Select Id, Name, AccountID, RecordTypeId, StageName from Opportunity where AccountId IN:oppAcc];
        system.debug('Case Remove Opp:'+oppList);
        OppHelperIN opphelper = new OppHelperIN();
        opphelper.changeCustomerPhase(oppList);
    }
    
    //Update Complaint creator department
    public void updateComplaintCreatorDepartment(List<Case> caseList){
        //Id complaintRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordtypeID();
        for(Case c:caseList){
            {
                if(Userinfo.getUserType() == 'PowerPartner'){
                    c.Generated_by__c= 'Dealer';
                }
                else{
                    c.Generated_by__c= 'MB';
                }
            }
        }
    }
    
    //Update Turnaround Time
    public void calculateCaseAge(List<Case> caseList){
        List<BusinessHours> lstIndiaBusinessHours = [Select Id from BusinessHours where Name='India' limit 1];
        if (lstIndiaBusinessHours == null || lstIndiaBusinessHours.size() ==0){
            system.debug('no business hours');
            return;
        }
        BusinessHours indiaBusinessHours = lstIndiaBusinessHours[0];
        Integer noOfDays = 0;
        DateTime dtStart;
        Case OldValue= new Case();
        for(Case c: caseList){
            if(c.Id != null && Trigger.oldMap.get(c.Id) != null){
                OldValue = (Case) Trigger.oldMap.get(c.Id);
            }
            if((c.Status == 'Closed' || c.Status == 'Closed (Final)' || c.Status == 'Finished') && c.Status != OldValue.Status) {
            for(dtStart = c.CreatedDate; dtStart <= System.Today(); dtStart=dtStart.addDays(1)){
                if(BusinessHours.isWithin(indiaBusinessHours.Id, dtStart)){
                    noOfDays++;
                    system.debug('is working inside: '+dtStart);
                }
            } 
            c.Turnaround_Time__c = noOfDays;
            }
        }
    }
}