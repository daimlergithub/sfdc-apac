 /***********************************************************************************
Created By          :    DINESH C G   
Created Date        :    30.01.2017
Company             :    NTT Data,Inc.
Usage               :    Convert to DM Request button in campaign execution                       
                                          
************************************************************************************/


public class ConvertToDMRequest{
 
    //Our collection of the class/wrapper objects wrapAccount
    public List<wrapAccount> wrapAccountList {get; set;}
    public List<Campaign_Member__c > selectedAccounts{get;set;}
    Public Static Id camId;
    
    
 List<DM_Request__c> dmrec = New List<DM_Request__c>(); 
    public ConvertToDMRequest(){
    
        camId = ApexPages.currentPage().getParameters().get('id');
        if(wrapAccountList == null) {
            wrapAccountList = new List<wrapAccount>();
            for(Campaign_Member__c  a: [select Id, Name,Contact_Id__c,Campaign_ID__c,Address__r.Address_Type__c,Status__c from Campaign_Member__c  where Status__c = 'Responded' AND Campaign_ID__c =: camId  ]) {
                // As each Account is processed we create a new wrapAccount object and add it to the wrapAccountList
                wrapAccountList.add(new wrapAccount(a));
                
                system.debug('++++++++++'+wrapAccountList);
            }
        }
    }
 
    public PageReference  processSelected() {
    
    camId = ApexPages.currentPage().getParameters().get('id');
    selectedAccounts = new List<Campaign_Member__c >();
          system.debug('++++++++++2'+wrapAccountList);
        for(wrapAccount wrapAccountObj : wrapAccountList) {
            if(wrapAccountObj.selected == true) {
             system.debug('++++++++++3'+wrapAccountObj.acc.Contact_Id__c);
             system.debug('++++++++++4'+wrapAccountObj.acc.Address__r.Address_Type__c);
              DM_Request__c dm = New DM_Request__c ();
              dm.Customer_Name__c = wrapAccountObj.acc.Contact_Id__c;
              dm.Sending_Address__c = 'Temporary';
              dm.TitleOfHonor__c = 'To person';
              dm.Channel__c = 'Campaign' ;
              dm.Campaign__c = camId ; 
             dmrec.add(dm); 
            }
        }
        insert dmrec;
        
        system.debug('++++++++++5'+camId);
        PageReference nextPage = new PageReference('/' +camId );
        //nextPage.setredirect(false);
        return nextPage;
    }
     public PageReference cancel() 
      {
        
        camId = ApexPages.currentPage().getParameters().get('id');
        return new PageReference('/'+ camId  );
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