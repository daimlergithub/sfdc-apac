/**
* Utility for Trigger on Account_Link for MY(Malaysia)
*It will Share the Records(Account Link and Account) to Dealers once the Retail Copy is created
*It will Revoke the access Once the fromRole becomes Null
*It Will Calculates the Complaint Amount based on Number of Cases
*/
Public class AccountLinkHelperBase{
    
    public static Id C2C_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c','Contact2Contact');
    public static Id accPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account');
    public static Id accCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Company');
    
    public void validateC2C(List<Account_link__C> acclinklist,String Market){
        List<Account_Link__c> ExistC2CList = new List<Account_Link__c>();
        Set<ID> AccC2CIds= new Set<ID>();
        Set<Id> aclistid= new set<ID>();
        Set<string> AccC2CIdCombs= new Set<string>();
        Map<string,integer> C2CCount= new Map<string,Integer>();
        system.debug(acclinklist);
        for(Account_link__c acclinkrec: acclinklist){
                if(acclinkrec.RecordTypeId == C2C_RecordTypeId && trigger.isinsert){
                   if(string.isnotblank(acclinkrec.toRole__c)) AccC2CIds.add(acclinkrec.toRole__c);
                   if(string.isnotblank(acclinkrec.fromRole__c)) AccC2CIds.add(acclinkrec.fromRole__c);
                    aclistid.add(acclinkrec.id);
                }   
                system.debug('----'+trigger.isupdate);
                if(acclinkrec.RecordTypeId == C2C_RecordTypeId && trigger.isupdate){
                 Account_Link__c oldAcc= (Account_Link__c)Trigger.oldMap.get(acclinkrec.Id);
                   if(string.isnotblank(acclinkrec.toRole__c)?acclinkrec.toRole__c !=oldAcc.toRole__c:False)
                        AccC2CIds.add(acclinkrec.toRole__c);
                   if(string.isnotblank(acclinkrec.fromRole__c)?acclinkrec.fromRole__c!=OldAcc.fromRole__c:False) 
                       AccC2CIds.add(acclinkrec.fromRole__c);
                        
                  aclistid.add(acclinkrec.id);
                
                }    
        }
    if(AccC2CIds.size()>0){
    system.debug('----'+AccC2CIds +'\n-----'+aclistid );
        for(account_link__c  al :[select id,fromRole__c,toRole__c from account_link__c 
               where recordtypeid=:C2C_RecordTypeId and
               md__c=:market and toRole__c!=null and fromRole__c!=null 
               and (fromRole__c in:  AccC2CIds or toRole__c in:AccC2CIds) and id not in : aclistid 
               order by createdDate]){
                    AccC2CIdCombs.add(al.fromRole__c+'-'+al.toRole__c); 
                    AccC2CIdCombs.add(al.toRole__c+'-'+al.fromRole__c);                
            }   
        for(Account_link__c acclinkrec: acclinklist){
                if(acclinkrec.RecordTypeId == C2C_RecordTypeId){
                   if(string.isnotblank(acclinkrec.toRole__c) && (string.isnotblank(acclinkrec.fromRole__c))){
                       if(AccC2CIdCombs.contains(acclinkrec.fromRole__c+'-'+acclinkrec.toRole__c))
                            acclinkrec.addError(Label.Account_Link_record_with_the_same_Role_1_and_Role2_exists);
                       else{
                           AccC2CIdCombs.add(acclinkrec.fromRole__c+'-'+acclinkrec.toRole__c); 
                           AccC2CIdCombs.add(acclinkrec.toRole__c+'-'+acclinkrec.fromRole__c);
                           
                       
                       }
                   }                   
                }       
           }         
        }
   } 
        
}