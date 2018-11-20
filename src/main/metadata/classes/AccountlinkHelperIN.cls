/**
* Handler for Trigger on Case for IN(India)
* Author:Namitha
* Created Date : 6th Mar 2018
* Utility for helperon Account_Link for IN(India)
* It will validate the duplicate
*/
public class AccountlinkHelperIN{

    AccountLinkHelperBase alb=new AccountLinkHelperBase();
    public void ValidateC2CAfterUpdateInsert(List<Account_link__C> acclinklist,String Market,boolean isinsert, boolean isupdate,Map<id,sobject> oldmapAL ){
        AccountLinkHelperBase.validateC2C(acclinklist,Label.IN,isinsert,isupdate,oldmapAL);
    }
    //Start Namitha 08212018 Added to ensure parity with kernel functionality as per review.
    public void addressupdateRT(List<Account_Link__c> alinks,Map<id,Account_Link__c> oldals){
        AccountLinkHelperBase.addressupdateRT(alinks,oldals);
    }
    public  void RevokeApexSharingAfterUpdate(List<Account_Link__c> newacclinkmap,Map<Id, Account_Link__c> oldacclinkmap,List<Account_Link__c> oldrec){
		//Namitha 09192018 Commented call of below code to fix optyshare issues
        //alb.RevokeApexSharingAfterUpdate(newacclinkmap,oldacclinkmap,oldrec);
    }

    //method to share C2C to the two dealer groups who have access to the two accounts
     public void ShareC2CRecord(List<Account_Link__c> alinks){
       // commented out as for India this base functionality is not needed
       // AccountLinkHelperBase.OnAfterUpdateCreateC2CRetailCopy(alinks,oldals);
       Id C2CRecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c','Contact2Contact');
       Id RetPersonRecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c','Retail Person');
       Id RetCompanyRecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c','Retail Company');
       String marketStr = Label.IN + '%';
       Set<Id> accIdSet = new Set<Id>();
       Set<Id> retailIdSet = new Set<Id>();
       Set<Account_Link__c> c2cIdLst = new Set<Account_Link__c>();
       for (Account_link__c al : alinks){
           if (al.recordtypeid == C2CRecordTypeId){
               accIdSet.add(al.fromrole__c);
               accIdSet.add(al.torole__c);
               c2cIdLst.add(al);
           }
           else if (al.RecordTypeId == RetPersonRecordTypeId || al.RecordTypeId == RetCompanyRecordTypeId){
               retailIdSet.add(al.toRole__c);
           }
       }
       if (retailIdSet.size() > 0 && accIdSet.size() ==0){
           for (Account_Link__c alc2c : [select fromrole__c,torole__c from Account_Link__c where recordtypeid =:C2CRecordTypeId and ((fromrole__c in :retailIdSet) or (torole__c in :retailIdSet))]){
               accIdSet.add(alc2c.fromrole__c);
               accIdSet.add(alc2c.torole__c);
               c2cIdLst.add(alc2c);
           }
       }
       system.debug('++++++' + accIdSet);
       system.debug('+++++' + c2cIdLst);
       Map<Id,List<Id>> mapAccShare = new Map<Id,List<Id>>();
       if (accIdSet.size() > 0){
           for (AccountShare ash : [select accountid,userorgroupid from AccountShare where rowcause = 'Manual' and userorgroup.name like :marketStr and accountid in :accIdSet]){
               List<Id> grpIdLst= new List<Id>();
               if (mapAccShare.get(ash.Accountid) == null){
                   grpIdLst.add(ash.UserOrGroupId);
                   mapAccShare.put(ash.AccountId, grpIdLst);
               }
               else {
                   grpIdLst = mapAccShare.get(ash.AccountId);
                   grpIdLst.add(ash.UserOrGroupId);
                   mapAccShare.put(ash.AccountId, grpIdLst);
               }
           }
       }
       system.debug('++++++' + mapAccShare);
       List<Account_Link__Share> alsh = new List<Account_Link__Share>();
       if (mapAccShare.size() > 0){
           for (Account_link__c al : c2cIdLst){
               List<id> accFrom = mapAccShare.get(al.fromRole__c);
               List<Id> accTo = mapAccShare.get(al.toRole__c);
               if (accFrom != null){
                    for (Id gid : accFrom){
                        alsh.add(new Account_Link__Share(parentId = al.id,rowcause = 'Manual',userorgroupid = gid, AccessLevel='Edit'));
                    }
               }
               if (accTo != null){
                    for (Id grId : accTo){
                        alsh.add(new Account_Link__Share(parentId = al.id,rowcause = 'Manual',userorgroupid = grid, AccessLevel='Edit'));
                    }
               }
           }
           system.debug('+++++' + alsh);
           if (alsh.size() > 0){
               Database.SaveResult[] results = Database.insert(alsh, false);
               for(Database.SaveResult sr : results){
                   if (sr.isSuccess()) {
                       System.debug('Successfully inserted als: ' + sr.getId());
                   }
                   else{
                       for(Database.Error err : sr.getErrors()) {
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                       }
                   }

               }
           }
       }
    }

    public void RemoveAccessofUsers(List<Account_Link__c> alinks){
        AccountLinkHelperBase.RemoveAccessofUsers(alinks,Label.IN);
    }
    //ends 08212018
    //Start 07042018 : Namitha added to invoke share retailcopy and Account as part of ph2.
    public  void afterInsertEventShareRetailCopy(List<Account_link__C> acclinklist){
        alb.afterInsertEventShareRetailCopy(acclinklist);
    }
    public  void afterInsertEventShareAccount(List<Account_link__C> acclinklist){
        //call logic to share retail copy only if single retail copy is created or updated. Base class has issue in updating multiple account links at same time
        //TODO - fix base class for all markets
        if (acclinklist.size() == 1)
            alb.afterInsertEventShareAccount(acclinklist);
    }
    //ends 07042018
	//Start 07042018 : Namitha added to update salesconsultant as part of phase2 and call cdm int urls.
	public void InvokeCDMAccountlinkContaxt(List<Account_link__C> acclinklist,String Market,string context ){
                //change based on mSales Data
        //al_List used to get specific records where missing_flag__c not true
        List<Account_Link__c> al_List = new list<Account_Link__c>();
        for(Account_Link__c al : acclinklist){
            if(al.missing_flag__c != TRUE){
                al_List.add(al);
            }
        }
        if(al_list.size() > 0)
        AccountLinkHelperBase.CDMAccountlinkContextGroup(al_List,market,context );
    }
	public static void updateSalesConsultant(List<Account_link__C> acclinklist){
	
	Set<Id> acclinkIdSet = new Set<Id>();
	for(Account_link__C acc : acclinklist){
	acclinkIdSet.add(acc.fromRole__c);
	}
	Map<Id,Id> acclinkuserMap = new Map<Id,Id>();
        List<user> userlist =[select id,Contact.Account.ID from user where Contact.Account.ID IN :acclinkIdSet and Contact.Dealer_Lead_Gate_Keeper__c = :true];
        for(user u : userlist){
            acclinkuserMap.put(u.Contact.Account.ID,u.Id);
        }
        for(Account_link__C acc : acclinklist){
				if(Userinfo.getUserType() == 'PowerPartner')
                     acc.Retail_Sales_Consultant__c = UserInfo.getUserId();
                else acc.Retail_Sales_Consultant__c = acclinkuserMap.get(acc.fromRole__c);
        }
    }//Ends 07042018
}