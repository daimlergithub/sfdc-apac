global class PA_Doc_CustomerUpdateBatch implements Database.Batchable < sObject > , Database.Stateful {
    public static Id accPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account', 'Person Account');
    public static Id accPersonsoftdeleted_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account', 'Person Account Soft Deleted');
    public static Id retailperson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c', 'Retail Person');
    public static Id VRRetailSD_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Vehicle_Relationship__c', 'Vehicle Relationship Soft Deleted');
    public Set < Id > AccSoftdeleted = new Set < Id > ();
    public List < Account > BlankoutPAAcclist = new List < Account > ();
    public List < Account > SoftdeleteAccList = new List < Account > ();

    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        Date todays = System.today();
        Date d = todays.addYears(-10);
        String s = String.valueOf(d);
        System.debug(s);
        String query = 'select  id,Opt_In_Email__c,Opt_In_SMS__c,Gender__c,Hobby__c,Marital_Status__c,PersonBirthdate,Age_Range__c,Behavioural_Group__c,Alliance_Offered_Service__c,Average_car_usage_period__c,Postal_Opt_In__c,Opt_In_Mobile__c,VIP__c,Gov_Background__c,Contact_Background__c,Newspaper__c,Working_Status__c,Industry__c,Occupation_TR__c,Fleet__c,Fleet_Category__c,Allmakes_Offered_Service__c,recordtypeId from account where recordtypeId =\'' + accPerson_RecordTypeId + '\' and market__c = \'TR\' and Updated_Consent_Date__c!= null and Updated_Consent_Date__c <' + s + '  and Personal_Agreement__c = \'Yes\'';
        System.debug(query);
        return Database.getQueryLocator(query);

    }
    global void execute(Database.BatchableContext bc, List < Account > records) {

        // process each batch of records
        Boolean Softdelete = true;
        Set < Id > accid = new Set < Id > ();
        
        for (Account accprocess: records) {
            accId.add(accprocess.Id);
        }
        map < Id, List < Account_link__c >> AcctoAcclinkMap = new Map < Id, List < Account_link__c >> ();
        for (Account_link__c al: [Select id, torole__c, Retail_Email_OptIn__c, Retail_Phone_OptIn__c, Retail_Postal_OptIn__c, Retail_SMS_OptIn__c from Account_link__c where torole__c in: accId and FromRole__c != null and Recordtype.name = 'Retail person']) {
            if (AcctoAcclinkMap.containsKey(al.torole__c)) {
                AcctoAcclinkMap.get(al.torole__c).add(al);
            } else {
                AcctoAcclinkMap.put(al.torole__c, new List < Account_link__c > {
                    al
                });
            }
        }

        for (Account a: records) {
            softdelete = true;
            if (a.Opt_In_Email__c || a.Opt_In_SMS__c || a.Postal_Opt_In__c || a.Opt_In_Mobile__c) {
                System.debug(1);
                a.Gender__c = '';
                a.Hobby__c = '';
                a.Marital_Status__c = '';
                a.PersonBirthdate = null;
                a.Age_Range__c = '';
                a.Behavioural_Group__c = '';
                a.Alliance_Offered_Service__c = '';
                a.Average_car_usage_period__c = '';
                a.VIP__c = false;
                a.Gov_Background__c = false;
                a.Contact_Background__c = '';
                a.Newspaper__c = '';
                a.Working_Status__c = '';
                a.Industry__c = '';
                a.Processed__c = true;
                a.Occupation_TR__c = '';
                a.Fleet__c = false;
                a.Fleet_Category__c = '';
                a.Allmakes_Offered_Service__c = '';
                BlankoutPAAcclist.add(a);

            } else if (!(a.Opt_In_Email__c || a.Opt_In_SMS__c || a.Postal_Opt_In__c || a.Opt_In_Mobile__c) && AcctoAcclinkMap.containsKey(a.Id)) {
                for (Account_link__c al: AcctoAcclinkMap.get(a.Id)) {
                    if (al.Retail_Email_OptIn__c || al.Retail_Phone_OptIn__c || al.Retail_Postal_OptIn__c || al.Retail_SMS_OptIn__c) {
                        System.debug(2);
                        a.Gender__c = '';
                        a.Hobby__c = '';
                        a.Marital_Status__c = '';
                        a.PersonBirthdate = null;
                        a.Age_Range__c = '';
                        a.Behavioural_Group__c = '';
                        a.Alliance_Offered_Service__c = '';
                        a.Average_car_usage_period__c = '';
                        a.VIP__c = false;
                        a.Gov_Background__c = false;
                        a.Contact_Background__c = '';
                        a.Newspaper__c = '';
                        a.Working_Status__c = '';
                        a.Industry__c = '';
                        a.Occupation_TR__c = '';
                        a.Fleet__c = false;
                        a.Fleet_Category__c = '';
                        a.Allmakes_Offered_Service__c = '';
                        a.Processed__c = true;
                        BlankoutPAAcclist.add(a);
                        softdelete = false;
                        break;
                    }
                }
                if (softdelete) {
                    System.debug(3);
                    a.recordtypeid = accPersonsoftdeleted_RecordTypeId;
                    a.To_Be_Deleted__c = true;
                    a.Gender__c = '';
                    a.Hobby__c = '';
                    a.Marital_Status__c = '';
                    a.PersonBirthdate = null;
                    a.Age_Range__c = '';
                    a.Behavioural_Group__c = '';
                    a.Alliance_Offered_Service__c = '';
                    a.Average_car_usage_period__c = '';
                    a.VIP__c = false;
                    a.Gov_Background__c = false;
                    a.Contact_Background__c = '';
                    a.Newspaper__c = '';
                    a.Working_Status__c = '';
                    a.Industry__c = '';
                    a.Occupation_TR__c = '';
                    a.Fleet__c = false;
                    a.Fleet_Category__c = '';
                    a.Allmakes_Offered_Service__c = '';
                    a.Primary_Address_Reference__c = null;
                    a.Primary_Address_Display__c = '';
                    a.Vehicle_Amount__c = null;
                    a.Status__c = '';
                    a.Data_Source__c = '';
                    a.Complaint_Amount__c = null;
                    a.Customer_Lifecycle_Phase__c = '';
                    a.Car_Owner_Club__c = '';
                    //a.UCID__c = '';
                    a.Social_ID__c = '';
                    //a.Personal_Agreement__c = '';
                    //a.Updated_Consent_Date__c = null;
                    a.Updated_Consent_User__c = null;
                    a.Mobile__c = '';
                    a.Mobile_Status__c = '';
                    a.Mobile3_Last_Modified_By__c = null;
                    a.Mobile3_Last_Modified_Date__c = null;
                    a.Individual_Home_Phone__c = '';
                    a.Individual_Home_Phone_Status__c = '';
                    a.Home_Phone_Last_Modified_By__c = null;
                    a.Home_Phone_Last_Modified_Date__c = null;
                    a.Work_Phone__c = '';
                    a.Work_Phone_Status__c = '';
                    a.Work_Phone_Last_Modified_By__c = null;
                    a.Work_Phone_Last_Modified_Date__c = null;
                    a.Email__c = '';
                    a.Email_Status__c = '';
                    a.Email_Last_Modified_By__c = null;
                    a.Email_Last_Modified_Date__c = null;
                    a.Opt_In_Email__c = false;
                    a.Opt_In_Mobile__c = false;
                    a.Opt_In_SMS__c = false;
                    a.Postal_Opt_In__c = false;

                    //BlankoutPAAcclist.add(a);
                    SoftdeleteAccList.add(a);
                }
            }
        }
        
        
    }
    
    global void finish(Database.BatchableContext bc) {
        
    List<Account_link__c> al2 = new List<Account_link__c>();
    List<Account_link__c> all = new List<Account_link__c>();
    List<Vehicle_Relationship__c> VRset = new List<Vehicle_Relationship__c>();
    List<AccountHistory> AHSet = new List<AccountHistory>();
       if (BlankoutPAAcclist.size() > 0) {
            Database.SaveResult[] srList = Database.update(BlankoutPAAcclist, false);
            for (Database.SaveResult sr: srList) {
                if (sr.isSuccess()) {
                    System.debug(4);
                    System.debug('Successfully updated account. Account ID: ' + sr.getId());
                } else {}
            }
        }
        if (BlankoutPAAcclist.size() > 0) {
            for(Account_Link__c alink: [Select id,Retail_PersonBirthdate__c,Retail_Gender__c,Retail_Occupation__c,Retail_Industry__c,Retail_Position__c,Retail_Preferred_Language__c,Retail_WebSite__c,Retail_Special_Needs_Class__c,Retail_Special_Care__c from Account_link__c where recordtypeid =: retailperson_RecordTypeId and torole__C in: BlankoutPAAcclist])
            {
                alink.Retail_PersonBirthdate__c = null;
                alink.Retail_Gender__c = '';
                alink.Retail_Occupation__c = '';
                alink.Retail_Industry__c = '';
                alink.Retail_Position__c = '';
                alink.Retail_Preferred_Language__c = '';
                alink.Retail_WebSite__c = '';
                alink.Retail_Special_Needs_Class__c = '';
                alink.Retail_Special_Care__c = '';
                al2.add(alink);
            }
            if(al2.size() > 0){
                Database.SaveResult[] srList2 = Database.update(al2, false);
                for (Database.SaveResult sr: srList2) {
                    if (sr.isSuccess()) {
                        System.debug(6);
                        
                        System.debug('Successfully updated account link. Account link ID: ' + sr.getId());
                    } else {}
                }
            }
        }
        if (SoftdeleteAccList.size() > 0) {
            Database.SaveResult[] srList3 = Database.update(SoftdeleteAccList, false);
            for (Database.SaveResult sr: srList3) {
                if (sr.isSuccess()) {
                    System.debug(5);
                    // Operation was successful, so get the ID of the record that was processed
                    AccSoftdeleted.add(sr.getId());
                    System.debug('Successfully updated account. Account ID: ' + sr.getId());
                } else {}
            }
        }
        if(SoftdeleteAccList.size() >0)
        {
            for(Account_Link__c alink: [Select id,Retail_Delete_Flag__c from Account_link__c where recordtypeid =: retailperson_RecordTypeId and torole__C in: AccSoftdeleted])
            {
                alink.Retail_Delete_Flag__c = true;
                all.add(alink);
            }
            if(all.size() > 0){
                Database.SaveResult[] srList2 = Database.update(all, false);
                for (Database.SaveResult sr: srList2) {
                    if (sr.isSuccess()) {
                        System.debug(6);
                        
                        System.debug('Successfully updated account link. Account link ID: ' + sr.getId());
                    } else {}
                }
            }
        }
        if(SoftdeleteAccList.size() >0)
        {
            for(Vehicle_Relationship__c VRs: [Select id,recordtypeId from Vehicle_Relationship__c where Contact__c in: AccSoftdeleted])
            {
                VRs.recordtypeid = VRRetailSD_RecordTypeId;
                VRset.add(VRs);
            }
            if(VRset.size() > 0){
                Database.SaveResult[] srList3 = Database.update(VRset, false);
                for (Database.SaveResult sr: srList3) {
                    if (sr.isSuccess()) {
                        System.debug(6);
                        
                        System.debug('Successfully updated VR. VR ID: ' + sr.getId());
                    } else {}
                }
            }
        }
        if(SoftdeleteAccList.size() >0)
        {
            for(AccountHistory AH: [SELECT Id, NewValue, OldValue, CreatedDate FROM AccountHistory where AccountId IN: AccSoftdeleted])
            {
                AHSet.add(AH);
            }
            /*if(AHSet.size() > 0){
                Database.DeleteResult[] srList3 = Database.delete(AHSet, false);
                for (Database.DeleteResult sr: srList3) {
                    if (sr.isSuccess()) {
                        System.debug(6);
                        
                        System.debug('Successfully deleted Accounthistory. AH ID: ' + sr.getId());
                    } else {}
                }
            }*/
        }
    }
}
