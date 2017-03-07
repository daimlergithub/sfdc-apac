public class ConvertToDMRequest{
 
    //Our collection of the class/wrapper objects wrapAccount
    public List<wrapAccount> wrapAccountList {get; set;}
    public List<Campaign_Member__c > selectedAccounts{get;set;}
 List<DM_Request__c> dmrec = New List<DM_Request__c>(); 
    public ConvertToDMRequest(){
        if(wrapAccountList == null) {
            wrapAccountList = new List<wrapAccount>();
            for(Campaign_Member__c  a: [select Id, Name,Contact_Id__c,Address__r.Address_Type__c,Status__c from Campaign_Member__c  where Status__c = 'Responded' ]) {
                // As each Account is processed we create a new wrapAccount object and add it to the wrapAccountList
                wrapAccountList.add(new wrapAccount(a));
            }
        }
    }
 
    public void processSelected() {
    selectedAccounts = new List<Campaign_Member__c >();
 
        for(wrapAccount wrapAccountObj : wrapAccountList) {
            if(wrapAccountObj.selected == true) {
              DM_Request__c dm = New DM_Request__c ();
              dm.Customer_Name__c = wrapAccountObj.acc.Contact_Id__c;
              dm.Sending_Address__c =wrapAccountObj.acc.Address__r.Address_Type__c;
              dm.TitleOfHonor__c = 'To person';
              dm.Channel__c = 'Campaign' ;
             dmrec.add(dm); 
            }
        }
        insert dmrec;
    }
 
    // This is our wrapper/container class. In this example a wrapper class contains both the standard salesforce object Account and a Boolean value
    public class wrapAccount {
        public Campaign_Member__c  acc {get; set;}
        public Boolean selected {get; set;}
 
        public wrapAccount(Campaign_Member__c   a) {
           acc = a;
            selected = false;
        }
    }
}

