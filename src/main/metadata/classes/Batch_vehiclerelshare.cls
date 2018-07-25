global class Batch_vehiclerelshare implements Database.Batchable<sObject> ,Database.stateful
{
    global string query;
    global string mainName='';
    global set<string> unproperSharingList = new set<string>();
    global list<string> unproperSharingListids = new list<string>();
    global integer size=0;
    global string md='JP';
    global String retCompanyId= Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    global String retPersonId= Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    global Batch_vehiclerelshare(){
        //this.query = query;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,selling_dealer__c,selling_dealer__r.dealer_gc_code__c,contact__c  from vehicle_relationship__c where selling_dealer__c != null and MD__C =' +'\'JP\'');
    }
    global void execute(Database.BatchableContext BC, List<vehicle_relationship__c> scope){
          Id retPersonId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
     Id retCompanyId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
       // list<account_link__c> RetailcopyInsertionList = new   list<account_link__c> ();
        set<string> unproperSharingList = new set<string>();
        set<id>contactIds = new set<id>();
        Map<id,list<string>> contactandRetCopyIdsmap= new Map<id,list<string>>();
        for(vehicle_relationship__c sc:scope){
           if(sc.selling_dealer__c != null && sc.contact__c != null)
               {
                contactIds.add(sc.contact__c);                              }
                }
        list<Account_link__c>retailCopyList=[Select id,torole__c,fromrole__c,fromrole__r.dealer_gc_code__c from account_link__c Where torole__c IN:contactIds and (RecordType.DeveloperName = 'retPersonId' or RecordType.DeveloperName  = 'retCompanyId')];
        
        for(account_link__c st:retailCopyList){
            if(!contactandRetCopyIdsmap.containsKey(st.torole__c)){
                contactandRetCopyIdsmap.put(st.torole__c, new List<string>());
            }
            contactandRetCopyIdsmap.get(st.torole__c).add(st.fromrole__r.dealer_gc_code__c);
        }
        
      
        
        for(vehicle_relationship__c s:scope)
        {  
            List<string>gids=new List<string>();
            gids=contactandRetCopyIdsmap.get(s.contact__c);
            System.debug('gids>>>'+gids);
                                                if(s.selling_dealer__c != null && s.selling_dealer__r.dealer_gc_code__c != null){  
                                             
                if(gids !=null && gids.contains(s.selling_dealer__r.dealer_gc_code__c)){
                    System.debug('insertion>>>>>');
                    continue;
                }
                else{
                        Account_link__c ac = new Account_link__c();
                        ac.torole__c = s.contact__c;
                        ac.fromrole__c = s.selling_dealer__c;
                        ac.RecordTypeID= retPersonId;
                    unproperSharingList.add(s.id);
                  //   RetailcopyInsertionList.add(ac);
                }                       
            } 
        } 
                            //    if(RetailcopyInsertionList.size()>0)
                              //  { 
                                   // insert RetailcopyInsertionList;
                               // }
        List<string> unprop = new list<string>(unproperSharingList);
        System.debug('unproperidsize>>>'+unprop);
        size = size+unprop.size(); 
        System.debug('wholesize>>>>'+size);
        unproperSharingListids.addAll(unprop);
        System.debug('listids'+unproperSharingListids);
    
    }     
   
    global void finish(Database.BatchableContext BC){
       System.debug('wholesize>>>>'+size);
       System.debug('listids'+unproperSharingListids);
        for(string un:unproperSharingListids){
           mainName = mainName+un+',';
       }
       String emailBodyStr = '';
       Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
       blob csvBlob = Blob.valueOf(mainName);
       string csvname= 'Non_Distributed_CM.csv';
       csvAttc.setFileName(csvname);
       csvAttc.setBody(csvBlob);
       Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
       //String[] toAddresses = new list<string> {'test@test.com};
       String subject ='Unproper DealerListMembers';
       email.setSubject(subject);
       emailBodyStr = emailBodyStr + 'Size is '+ size;
       email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
       String sendingTo ='dinesh.govindaswamy@nttdata.com';
       string[] to = new string[] {sendingTo};
      // Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
       email.setToAddresses(to);
       email.SetsaveAsActivity(false);
       email.setHTMLBody(emailBodyStr);
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});  
    }

}