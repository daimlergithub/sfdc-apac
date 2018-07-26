public class IndividualEmailResultHelperTH{
public static void updateEmailSeStatus(List<et4ae5__IndividualEmailResult__c> newtrigger){
    List<account> acclist=new List<Account>();
    System.debug('dddddddddd'+newtrigger[0].et4ae5__Contact__c);
   // List<et4ae5__IndividualEmailResult__c> invemail=[select id,et4ae5__Contact__r.account.Email_Status__c,et4ae5__Contact__r.accountid,et4ae5__Contact__c,et4ae5__HardBounce__c,et4ae5__SoftBounce__c from et4ae5__IndividualEmailResult__c where id IN:newtrigger and et4ae5__Contact__r.accountid!=null];
    for(et4ae5__IndividualEmailResult__c a:[select id,et4ae5__Contact__r.account.Email_Status__c,et4ae5__Contact__r.accountid,et4ae5__Contact__c,et4ae5__HardBounce__c,et4ae5__SoftBounce__c from et4ae5__IndividualEmailResult__c where id IN:newtrigger and et4ae5__Contact__r.accountid!=null]){
        if(a.et4ae5__HardBounce__c){
            account acc=new account(id=a.et4ae5__Contact__r.accountid,Email_Status__c='invaid');
            acclist.add(acc);
            
        }
        if(a.et4ae5__SoftBounce__c){
            account acc=new account(id=a.et4ae5__Contact__r.accountid,Email_Status__c='vaid');
            acclist.add(acc);
            
        }
    }
    if(acclist.size()>0){ 
        try{
    update acclist;  
        }
        catch(Exception e){
            
        }
    }
    

}

}