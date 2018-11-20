global class UserRecordShareBatchMY implements Database.Batchable<sObject>, Database.Stateful {
public String market;
public List<User> usrLst;
global UserRecordShareBatchMY (String Market) {
        this.market = Market;
        usrLst=new List<User> ();
  
             }
           
global Database.QueryLocator start(Database.BatchableContext BC) {
        String qry;
        Integer noOfHours;
        datetime myDateTime = datetime.now();
        String dmmStatus = 'Processed';
        DateTimeForShareBatch__c dt = DateTimeForShareBatch__c.getValues('UserRecordshareBatch');
            if(dt != NULL){
                noOfHours = Integer.valueOf(dt.noOfHours__c) * (-1);
                myDateTime = myDateTime.addHours(noOfHours);
            }
            
        qry='Select Id,contact.account.Dealer_Nd_code__c from User where contact.account.Dealer_Nd_code__c!=NULL and Market__c = :market and createddate >=:myDateTime' ;
return database.getQueryLocator(qry);
}
global void execute(Database.BatchableContext BC, List <User> scope) {
 for(User u : scope)
     {
          usrLst.add(u);       
     }
     }
global void finish(Database.BatchableContext BC) {
UserHelperMY.shareRecordsAfterInsertAndUpdate(usrLst,label.MY);
}
}