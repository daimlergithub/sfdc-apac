/**
* Utility for Trigger on Account_Link for MY(Malaysia)
*It will Share the Records(Account Link and Account) to Dealers once the Retail Copy is created
*It will Revoke the access Once the fromRole becomes Null
*It Will Calculates the Complaint Amount based on Number of Cases
*/
Public class AccountLinkHelperBase{
    Public   MAP<Account_link__C,String> AcclinkMap=new MAP<Account_link__C,String>();
    public  Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public  Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public  Id AccountLink_RetailCompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    Public  List<Account_link__C> Acclink;
    Public  List<Account_Link__Share> accshare=new List<Account_Link__Share>();
    Public  List<User> usrlist=new List<User>();
    public static Id C2C_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c','Contact2Contact');
    public static Id accPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account');
    public static Id accCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Company');

/**
* It will validate the duplicate c2c
*/
    public static void validateC2C(List<Account_link__C> acclinklist,String Market,boolean isinsert, boolean isupdate,Map<id,sobject> oldmapAL){
        List<Account_Link__c> ExistC2CList = new List<Account_Link__c>();
        Set<ID> AccC2CIds= new Set<ID>();
        Set<Id> aclistid= new set<ID>();
        Set<string> AccC2CIdCombs= new Set<string>();
        Map<string,integer> C2CCount= new Map<string,Integer>();
        
        for(Account_link__c acclinkrec: acclinklist){
                if(acclinkrec.RecordTypeId == C2C_RecordTypeId && isinsert){
                   if(string.isnotblank(acclinkrec.toRole__c)) AccC2CIds.add(acclinkrec.toRole__c);
                   if(string.isnotblank(acclinkrec.fromRole__c)) AccC2CIds.add(acclinkrec.fromRole__c);
                    aclistid.add(acclinkrec.id);
                }   
                
                if(acclinkrec.RecordTypeId == C2C_RecordTypeId && isupdate){
                 Account_Link__c oldAcc= (Account_Link__c)oldmapAL.get(acclinkrec.Id);
                   if(string.isnotblank(acclinkrec.toRole__c)?acclinkrec.toRole__c !=oldAcc.toRole__c:False)
                        AccC2CIds.add(acclinkrec.toRole__c);
                   if(string.isnotblank(acclinkrec.fromRole__c)?acclinkrec.fromRole__c!=OldAcc.fromRole__c:False) 
                       AccC2CIds.add(acclinkrec.fromRole__c);
                        
                  aclistid.add(acclinkrec.id);
                
                }    
        }
    if(AccC2CIds.size()>0){
        try{
        for(account_link__c  al :[select id,fromRole__c,toRole__c from account_link__c 
               where recordtypeid=:C2C_RecordTypeId and
               md__c=:market and toRole__c!=null and fromRole__c!=null 
               and (fromRole__c in:  AccC2CIds or toRole__c in:AccC2CIds) and id not in : aclistid 
               order by createdDate]){
                    AccC2CIdCombs.add(al.fromRole__c+'-'+al.toRole__c); 
                    AccC2CIdCombs.add(al.toRole__c+'-'+al.fromRole__c);                
            }   
        }Catch(Exception e){
        
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
    public  void afterInsertEventShareRetailCopy(List<Account_link__C> acclinklist){
        Acclink=[select id,fromRole__r.Dealer_GC_Code__c,Retail_Delete_Flag__c,fromRole__r.Dealer_nd_Code__c from Account_link__c  where fromRole__c!=null and id=:acclinklist AND (recordtypeid =:AccountLink_RetailPersonRecordTypeId OR recordtypeid =: AccountLink_RetailCompanyRecordTypeId)];
        for(Account_link__c acclinkrec:Acclink){
            if(acclinkrec.fromRole__r.Dealer_GC_Code__c !=null){
                AcclinkMap.put(acclinkrec,acclinkrec.fromRole__r.Dealer_nd_Code__c);
                system.debug('%%%'+acclinkmap);
            }
            
        }
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: AcclinkMap.values()]){
            for(Account_link__c alk:Acclink){
                if(alk.Retail_Delete_Flag__c==false){
                    Account_Link__Share alshare=new Account_Link__Share ();
                    alshare.AccessLevel='EDIT';
                    alshare.RowCause = Schema.Account_link__Share.RowCause.Manual;
                    alshare.ParentId = alk.id;
                    alshare.UserOrGroupId=groupRec.id;
                    accshare.add(alshare);        
                }
            }
            
        }
        if(accshare.size()>0){
            Database.insert(accshare, false);

        }
    }
public  void afterInsertEventShareAccount(List<Account_link__C> acclinklist){
    List<AccountShare> AccountShareList = new  List<AccountShare>();
    Set<String> ndCode=new Set<String>();
    List<id> acctoshare=new List<id>();
    List<Account_Link__c> Acclink=[select id,toRole__c,fromRole__r.Dealer_ND_Code__c from Account_link__c  where toRole__c!=null and fromRole__c!=null and id=:acclinklist];
    for(Account_Link__c acclinkrec:Acclink){
        acctoshare.add(acclinkrec.fromRole__c);
        acctoshare.add(acclinkrec.toRole__c);
        if(acclinkrec.fromRole__r.Dealer_ND_Code__c!=null){
            ndCode.add(acclinkrec.fromRole__r.Dealer_nd_Code__c);
        }
    }
    if(ndCode.size()>0){
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: ndCode]){
            for(ID acct:acctoshare){
                AccountShare thisAccountShare = new AccountShare(); //a new empty AccountShare object
                thisAccountShare.userorgroupid = groupRec.id;
                thisAccountShare.accountid = acct;
                thisAccountShare.accountaccesslevel = 'READ';
                thisAccountShare.RowCause = Schema.AccountShare.RowCause.Manual;
                thisAccountShare.OpportunityAccessLevel='Read';
                AccountShareList.add(thisAccountShare);
            }
        }
        if(AccountShareList.size()>0){
            Database.insert(AccountShareList, false);

        }
    }
            
 } 
 /*public  void afterInsertEventShareIndividualCustomerExternalLink(List<Account_link__C> acclinklist){
     List<Account_link__C> acclink=[select id,toRole__c,fromRole__c,fromRole__r.Dealer_ND_Code__c  from Account_link__c  where toRole__c!=null or fromrole__c!=null];
     
     }*/
     //Following method will Revoke the Access if once Fromrole has changed
   public  void RevokeApexSharingAfterUpdate(List<Account_Link__c> newacclinkmap,Map<Id, Account_Link__c> oldacclinkmap,List<Account_Link__c> oldrec){
         List<Account_Link__c> acclink=new List<Account_Link__C>();
         List<Account_Link__Share> list_SharingDele;
         List<Account_Link__Share> delAlk=new LIst<Account_Link__share>();
         Set<ID> deleteSharingRec=new Set<ID>();
         Set<ID> recordstoDelete=new Set<ID>();
         Set<ID> accountIds=new Set<Id>();
         List<AccountShare> accsharedelete=new List<AccountShare>();
         set<String> gname=new Set<String>();
         for(Account_Link__c acl:Oldrec){
                 if(((Account_Link__C)Trigger.newMap.get(acl.id)).fromRole__c!=((Account_Link__C)Trigger.OldMap.get(acl.id)).fromRole__c){
                     deleteSharingRec.add(acl.fromrole__C);
                     recordstoDelete.add(acl.id);
                 }             
            }
        for(Account acc:[select id,Dealer_ND_Code__c from Account where id IN:deleteSharingRec]){
            gname.add(acc.Dealer_ND_Code__C);
            
        }
        if(deleteSharingRec.size()>0){
            List<Group> groupList = [select Id, Name, Type from Group where Name IN: gname];
            delAlk= [SELECT Id, ParentId FROM Account_Link__Share WHERE ParentId IN: recordstoDelete AND UserOrGroupId IN :groupList];
         }
         if(delAlk.size()>0){
             Database.delete(delAlk, false);
         }
         
         for(Account_Link__c alk:newacclinkmap){
             if(alk.Retail_Dealer_CompanyCode__c==null &&(alk.recordtypeid==AccountLink_RetailPersonRecordTypeId||alk.recordtypeid==AccountLink_RetailCompanyRecordTypeId) ){
                 acclink.add(alk);
                 accountIds.add(alk.torole__c);
             }
         }  
         if(acclink.size()>0){
         list_SharingDele=[SELECT Id, ParentId FROM Account_Link__Share WHERE ParentId IN:acclink];
         accsharedelete=[SELECT Id, accountid FROM AccountShare WHERE accountid IN:accountIds];
         
         if(list_SharingDele.size()>0){
             Database.delete(list_SharingDele, false);
             Database.delete(accsharedelete,false);
         }
         }
       
     }
}