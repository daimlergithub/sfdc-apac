global class Batch_DealerListMembers implements Database.Batchable<sObject> ,Database.stateful{
    global string query;
      // global string mainName='';
    //global set<string> unproperSharingList = new set<string>();
   // global list<string> unproperSharingListids = new list<string>();
    global integer size=0;
    global static Id AccountLink_contactToContactRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
    global static Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    global static Id AccountLink_RetailCompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    global Batch_DealerListMembers(){
        //this.query = query;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,NewAccount__c,Participating_Dealer__c,Participating_Dealer__r.dealer__c from Dealer_List_Member__c where NewAccount__c != null and Participating_Dealer__c != null and Participating_Dealer__r.dealer__c != null ');
    }
    global void execute(Database.BatchableContext BC, List<Dealer_List_Member__c> scope){
        string mainName='';
        set<string> unproperSharingList = new set<string>();
        set<id>participatingDealerIds = new set<id>();
        set<id>retailCopyIds = new set<id>();
        set<id>retailCopyC2CIds = new set<id>();
        Map<id,list<id>> accountlinkidsmap= new Map<id,list<id>>();
        Map<id,list<id>> Leadshareidsmap = new Map<id,list<id>>();
        Map<id,list<string>> Leadsharereasonsmap= new Map<id,list<string>>();
        Map<id,Account> accountMap = new Map<id,Account>();
        Map<id,Account_link__c> accountLinkMap = new Map<id,Account_link__c>();
        Map<id,id> accountLinkMap1 = new Map<id,id>();
        List<Account_link__c> accoutlinkList = new list<Account_link__c>();
        for(Dealer_List_Member__c sc:scope){
            participatingDealerIds.add(sc.Participating_Dealer__r.dealer__c);
            retailCopyIds.add(sc.NewAccount__c);
        }
        list<account_link__c>rtslist=[Select id,fromrole__c,torole__c from account_link__c where torole__c IN : retailCopyIds and (recordtypeid =: AccountLink_RetailPersonRecordTypeId or recordtypeid =: AccountLink_RetailCompanyRecordTypeId) and torole__c != null and fromrole__c != null];
        
        for(account_link__c st:rtslist){
            if(!accountlinkidsmap.containsKey(st.torole__c)){
                accountlinkidsmap.put(st.torole__c, new List<Id>());
            }
            accountlinkidsmap.get(st.torole__c).add(st.fromrole__c);
        }
        
        
        
        for(Dealer_List_Member__c s:scope)
        {
                
                    List<string>gids=new List<string>();
                    if(s.NewAccount__c != null){
                    gids=accountlinkidsmap.get(s.NewAccount__c);
                    }
                    System.debug('gids>>>'+gids);
                   
                    if(gids != null && gids.contains(s.Participating_Dealer__r.dealer__c)){
                        System.debug('insertion>>>>>');
                        continue ;
                    }
                    else{
                         Account_link__c acclink = new Account_link__c();
                         acclink.torole__c = s.NewAccount__c;
                        acclink.RecordtypeId = AccountLink_RetailPersonRecordTypeId ;
                        acclink.fromrole__c = s.Participating_Dealer__r.dealer__c;
                        acclink.market__c = 'JP';
                        accoutlinkList.add(acclink);
                        }  
           
        } 
              if(accoutlinkList.size() > 0){
                insert accoutlinkList;
              }
              size = size+accoutlinkList.size(); 
           
    }     
   
    global void finish(Database.BatchableContext BC){
       System.debug('wholesize>>>>'+size);
    }
}