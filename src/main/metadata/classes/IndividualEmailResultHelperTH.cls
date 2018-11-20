public class IndividualEmailResultHelperTH
{
    public static void updateEmailStatus(List<et4ae5__IndividualEmailResult__c> newtrigger){
        List<account> acclist=new List<Account>();
        List<et4ae5__IndividualEmailResult__c> invemail=[select id,et4ae5__Contact__c,et4ae5__Contact__r.accountid,et4ae5__Contact__r.account.md__c,et4ae5__Contact__r.account.Email_Status__c,et4ae5__HardBounce__c,et4ae5__SoftBounce__c from et4ae5__IndividualEmailResult__c where id IN:newtrigger and et4ae5__Contact__r.accountid!=null and et4ae5__Contact__r.account.md__c='TH'];
        for(et4ae5__IndividualEmailResult__c a : invemail){
            if(a.et4ae5__HardBounce__c){
                account acc=new account(id=a.et4ae5__Contact__r.accountid,Email_Status__c='Invalid');
                acclist.add(acc);    
            }
            else if(a.et4ae5__SoftBounce__c && !a.et4ae5__HardBounce__c){
                account acc=new account(id=a.et4ae5__Contact__r.accountid,Email_Status__c='Bounce-Back');
                acclist.add(acc);   
            }
            else if(!a.et4ae5__SoftBounce__c&&!a.et4ae5__HardBounce__c){
                account acc=new account(id=a.et4ae5__Contact__r.accountid,Email_Status__c='Valid');
                acclist.add(acc);  
            }
        }
        if(acclist.size()>0){ 
            try{
                update acclist;  
            }
            catch(Exception e){}
        }
    }
}