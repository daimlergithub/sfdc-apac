/**
* Utility for Trigger on Account_Link for TH(Thailand)
*It will Share the Records(Account Link and Account) to Dealers once the Retail Copy is created
*It will Revoke the access Once the fromRole becomes Null
*It Will Calculates the Complaint Amount based on Number of Cases
* Author: Dhanamjaya
* Created Date : 2017-01-23
*/
Public class AccountlinkhelperTH{
    Public   MAP<Account_link__C,String> AcclinkMap=new MAP<Account_link__C,String>();
    public  Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public  Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public  Id AccountLink_RetailCompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    Public  List<Account_link__C> Acclink;
    Public  List<Account_Link__Share> accshare=new List<Account_Link__Share>();
    Public  List<User> usrlist=new List<User>();
    public  void afterInsertEventShareRetailCopy(List<Account_link__C> acclinklist){
        Acclink=[select id,fromRole__r.Dealer_GC_Code__c,Retail_Delete_Flag__c,fromRole__r.Dealer_nd_Code__c from Account_link__c  where fromRole__c!=null and id=:acclinklist AND (recordtypeid =:AccountLink_RetailPersonRecordTypeId OR recordtypeid =: AccountLink_RetailCompanyRecordTypeId)];
        for(Account_link__c acclinkrec:Acclink){
            if(acclinkrec.fromRole__r.Dealer_GC_Code__c !=null){
                String grpName='TH'+acclinkrec.fromRole__r.Dealer_nd_Code__c;
                AcclinkMap.put(acclinkrec,grpName);								   
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
    
    public static void ExportNotificationTH (List<Account_Link__c> sample,Map<id,Account_Link__c> oldals)  {
   
   
        List<EP_Export_Notification__c> epList = New list<EP_Export_Notification__c>();
  
        for(Account_Link__c als : sample){
        Id recId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
        Id recrId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        if ( (als.Retail_DMS_Customer_ID__c != null && als.RecordTypeId == recId) || (als.Retail_DMS_Customer_ID__c != null && als.RecordTypeId == recrId ) ){
        
         
         if(als.Retail_Gender__c!= oldals.get(als.Id).Retail_Gender__c || als.Retail_UCID__c!= oldals.get(als.Id).Retail_UCID__c ||
 
            als.Retail_LastName__c != oldals.get(als.Id).Retail_LastName__c||
            als.Retail_Full_Name__c != oldals.get(als.Id).Retail_Full_Name__c||
            als.Retail_Full_Name_Title__c != oldals.get(als.Id).Retail_Full_Name_Title__c||
            als.Retail_Full_Name_Native__c != oldals.get(als.Id).Retail_Full_Name_Native__c||
            als.Retail_FirstName__c != oldals.get(als.Id).Retail_FirstName__c||
            als.Retail_LastName_Native__c != oldals.get(als.Id).Retail_LastName_Native__c||
            als.Retail_FirstName_Native__c != oldals.get(als.Id).Retail_FirstName_Native__c||
            als.Retail_Company_Name__c != oldals.get(als.Id).Retail_Company_Name__c||
            als.Retail_Company_Name_Native1__c != oldals.get(als.Id).Retail_Company_Name_Native1__c||
            als.Retail_Preferred_Language__c != oldals.get(als.Id).Retail_Preferred_Language__c||
            als.Retail_Special_Care__c != oldals.get(als.Id).Retail_Special_Care__c||
            als.Retail_Special_Needs_Class__c !=    oldals.get(als.Id).Retail_Special_Needs_Class__c||
            als.Retail_PersonBirthdate__c !=    oldals.get(als.Id).Retail_PersonBirthdate__c||
            als.Retail_Occupation__c != oldals.get(als.Id).Retail_Occupation__c||
            als.Retail_Vat_No__c != oldals.get(als.Id).Retail_Vat_No__c||
            als.Retail_Commercial_Reg_No__c != oldals.get(als.Id).Retail_Commercial_Reg_No__c||
            als.Retail_Foundation_Month__c  !=  oldals.get(als.Id).Retail_Foundation_Month__c||
            als.Retail_Website__c   !=  oldals.get(als.Id).Retail_Website__c||
            als.Retail_Industry__c  !=  oldals.get(als.Id).Retail_Industry__c||
            als.Retail_Primary_Phone__c !=  oldals.get(als.Id).Retail_Primary_Phone__c||
            als.Retail_Allow_Data_Sharing__c    !=  oldals.get(als.Id).Retail_Allow_Data_Sharing__c||
            als.Retail_Delete_Flag__c   !=  oldals.get(als.Id).Retail_Delete_Flag__c||
            als.Retail_Duplicate_Flag__c    !=  oldals.get(als.Id).Retail_Duplicate_Flag__c||
            als.Retail_Email__c !=  oldals.get(als.Id).Retail_Email__c||
            als.Retail_Fax__c   !=  oldals.get(als.Id).Retail_Fax__c||
            als.Retail_Individual_Home_Phone__c !=  oldals.get(als.Id).Retail_Individual_Home_Phone__c||
            als.Retail_Work_Phone__c    !=  oldals.get(als.Id).Retail_Work_Phone__c||
            als.Retail_Mobile__c    !=  oldals.get(als.Id).Retail_Mobile__c||
            als.Retail_Company_Phone__c !=  oldals.get(als.Id).Retail_Company_Phone__c||
            als.Retail_Company_Other_Phone__c   !=  oldals.get(als.Id).Retail_Company_Other_Phone__c||
            als.Retail_Fax__c   !=  oldals.get(als.Id).Retail_Fax__c||
            als.Retail_Province__c  !=  oldals.get(als.Id).Retail_Province__c||
            als.Retail_City__c  != oldals.get(als.Id).Retail_City__c||
            als.Retail_Distinct__c  !=  oldals.get(als.Id).Retail_Distinct__c||
            als.Retail_Address_Line_1__c    !=  oldals.get(als.Id).Retail_Address_Line_1__c||
            als.Retail_Address_Line_2__c    !=  oldals.get(als.Id).Retail_Address_Line_2__c||
            als.Retail_ZipCode__c   !=  oldals.get(als.Id).Retail_ZipCode__c||
            als.Retail_Related_Company__c   !=  oldals.get(als.Id).Retail_Related_Company__c||
            als.Retail_Primary_Phone__c != oldals.get(als.Id).Retail_Primary_Phone__c ||
            als.Retail_Address_Type__c  !=  oldals.get(als.Id).Retail_Address_Type__c||
            als.Retail_Address_CreatedDate__c   !=  oldals.get(als.Id).Retail_Address_CreatedDate__c||
            als.Retail_Address_LastModifiedDate__c  !=  oldals.get(als.Id).Retail_Address_LastModifiedDate__c||
            als.Retail_DMS_Customer_ID__c   !=  oldals.get(als.Id).Retail_DMS_Customer_ID__c||
            als.Retail_Complaint_Amount__c  !=  oldals.get(als.Id).Retail_Complaint_Amount__c||
            als.Retail_Sales_Sanction__c    !=  oldals.get(als.Id).Retail_Sales_Sanction__c||
            als.Retail_UCID__c  !=  oldals.get(als.Id).Retail_UCID__c||
            als.Retail_Preferred_Contact_Method__c  !=  oldals.get(als.Id).Retail_Preferred_Contact_Method__c||
            als.Retail_Email_OptOut__c  !=  oldals.get(als.Id).Retail_Email_OptOut__c||
            als.Retail_Fax_OptOut__c    !=  oldals.get(als.Id).Retail_Fax_OptOut__c||
            als.Retail_Phone_OptOut__c  !=  oldals.get(als.Id).Retail_Phone_OptOut__c||
            als.Retail_Postal_OptOut__c !=  oldals.get(als.Id).Retail_Postal_OptOut__c||
            als.Retail_Visit_OptOut__c  !=  oldals.get(als.Id).Retail_Visit_OptOut__c||
            als.Retail_Gender__c    !=  oldals.get(als.Id).Retail_Gender__c||
            als.Retail_Agreement__c !=  oldals.get(als.Id).Retail_Agreement__c||
            als.Retail_Information_Third_Party_Release__c   !=  oldals.get(als.Id).Retail_Information_Third_Party_Release__c||
            als.Retail_Abroad_Agreement__c  !=  oldals.get(als.Id).Retail_Abroad_Agreement__c||
            als.Retail_Agreement_Info_Processing__c !=  oldals.get(als.Id).Retail_Agreement_Info_Processing__c||
            als.Retail_Address_Reference__c !=  oldals.get(als.Id).Retail_Address_Reference__c||
            als.Retail_Position__c  !=  oldals.get(als.Id).Retail_Position__c){
        
            EP_Export_Notification__c epe = New EP_Export_Notification__c();
            epe.Status__c = 'New';
            epe.Usecase__c = 'AL.CustomerUpdateTH';
            epe.MD__c = 'TH';
            epe.Type__c = 'Account_Link__c';
            epe.SFDC_object_id__c = als.id;
           
            
            
         
           epList.add(epe);
        
         }
       }  
    
     }
     if(epList.size()>0){
         insert epList;
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
            String grpName='TH'+acclinkrec.fromRole__r.Dealer_nd_Code__c;
            ndCode.add(grpName);					
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
             //Database.delete(list_SharingDele, false);
             //Database.delete(accsharedelete,false);
         }
         }
       
     }
}