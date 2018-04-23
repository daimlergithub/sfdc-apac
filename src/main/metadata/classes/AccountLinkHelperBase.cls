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
    public static Id accRetailPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c','Retail Person');
    public static Id accRetailCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c','Retail Company');

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
        Acclink=[select id,fromRole__r.Dealer_GC_Code__c,Retail_Delete_Flag__c,fromRole__r.Dealer_nd_Code__c,fromRole__r.MD__c from Account_link__c  where fromRole__c!=null and id=:acclinklist AND (recordtypeid =:AccountLink_RetailPersonRecordTypeId OR recordtypeid =: AccountLink_RetailCompanyRecordTypeId)];
        for(Account_link__c acclinkrec:Acclink){
            if(acclinkrec.fromRole__r.Dealer_GC_Code__c !=null){
				string grpName= acclinkrec.fromRole__r.MD__c+acclinkrec.fromRole__r.Dealer_nd_Code__c;
                //AcclinkMap.put(acclinkrec,acclinkrec.fromRole__r.Dealer_nd_Code__c);
				AcclinkMap.put(acclinkrec,grpName);
                
            }
            
        }
        if(AcclinkMap.size()>0){
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
        }
        if(accshare.size()>0){
            Database.insert(accshare, false);

        }
    }
public  void afterInsertEventShareAccount(List<Account_link__C> acclinklist){
    List<AccountShare> AccountShareList = new  List<AccountShare>();
    Set<String> ndCode=new Set<String>();
    List<id> acctoshare=new List<id>();
    List<Account_Link__c> Acclink=[select id,toRole__c,fromRole__r.Dealer_ND_Code__c,fromRole__r.MD__c from Account_link__c  where toRole__c!=null and fromRole__c!=null and id=:acclinklist];
    for(Account_Link__c acclinkrec:Acclink){
        acctoshare.add(acclinkrec.fromRole__c);
        acctoshare.add(acclinkrec.toRole__c);
        if(acclinkrec.fromRole__r.Dealer_ND_Code__c!=null){
			string grpName= acclinkrec.fromRole__r.MD__c+acclinkrec.fromRole__r.Dealer_nd_Code__c;
            //AcclinkMap.put(acclinkrec,acclinkrec.fromRole__r.Dealer_nd_Code__c);
			AcclinkMap.put(acclinkrec,grpName);
            //ndCode.add(acclinkrec.fromRole__r.Dealer_nd_Code__c);
			ndCode.add(grpName);
        }
    }
    if(ndCode.size()>0){
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: ndCode]){
            for(ID acct:acctoshare){
                AccountShare thisAccountShare = new AccountShare(); //a new empty AccountShare object
                thisAccountShare.userorgroupid = groupRec.id;
                thisAccountShare.accountid = acct;
                thisAccountShare.accountaccesslevel = 'Edit';
                thisAccountShare.RowCause = Schema.AccountShare.RowCause.Manual;
                thisAccountShare.OpportunityAccessLevel='None';
                AccountShareList.add(thisAccountShare);
            }
        }
        if(AccountShareList.size()>0){
            Database.insert(AccountShareList, false);

        }
    }
            
 }
 //SB2018-02-08
 public static void addressupdateRT(List<Account_Link__c> alinks,Map<id,Account_Link__c> oldals)
        {
            List<Account_Link__c> accupdatelst = new List<Account_Link__c>();
            Set<Id>addid= new Set<Id>();
            set<id>AccID= new set<id>();
            Map<id,id> accALMap = new map<id,id>();
            for(Account_Link__c al: alinks)
            {
                if( (al.Retail_Address_Reference__c != oldals.get(al.Id).Retail_Address_Reference__c && al.Retail_Address_Reference__c!= null))
                {
                    addid.add(al.Retail_Address_Reference__c);
                }
                if((!TriggerRecursiveCheck.ALAddressCheck)  && (al.recordTypeID==accRetailPerson_RecordTypeId || al.recordTypeID==accRetailCompany_RecordTypeId)){
                    if(string.isnotblank(al.torole__c)){ AccID.add(al.torole__c);
                    accALMap.put(al.id,al.torole__c);
                    }
                }
            }
            if(AccID.size()>0){
                for(account a:[select id, Primary_Address_Reference__c from account where id in :AccID]){
                    if(string.isnotblank(a.Primary_Address_Reference__c)) addid.add(a.Primary_Address_Reference__c);
                }           
            }
            
            if(addid.size()>0){
            
            Map<id,Address__c> addMap =new Map<id,Address__c>([select id,name,createddate, LastModifiedDate, Customer__c,Address_Code__c,Address_Last_Modified_Date__c,Address_Line_1__c,Address_Line_1_Native__c,Address_Line_2__c,Address_Line_2_Native__c,Address_Line_3__c,Address_Type__c,Address_Type_Last_Modified_Date__c,Block__c,Block_Native__c,City__c,City_Native__c,Company_Name__c,Company_Name_Native__c,Country__c,Created_By_EP_Transaction__c,Delivery_Point_ID__c,Foreign_Nationals__c,FS_Hardcopy_Last_Modified_By__c,FS_Hardcopy_Last_Modified_Date__c,FS_Opt_In_Hardcopy__c,HouseNumber__c,isTestRunning__c,Language__c,Hardcopy_Last_Modified_By__c,Hardcopy_Last_Modified_Date__c,Market__c,MD__c,Opt_In_Hardcopy__c,ZipCode__c,Province__c,Province_Native__c,Preferred__c,Source_System__c,Status__c,Sub_District__c,TitleOfHonor__c,To_Be_Deleted__c,District__c,District_Native__c,Temp_Address__c,Temp_ZipCode__c,Updated_By_EP_Transactions__c from Address__c where id in : addid]);
            
            
            for(Account_Link__c al: alinks)
            {
                if((al.Retail_Address_Reference__c != oldals.get(al.Id).Retail_Address_Reference__c && al.Retail_Address_Reference__c!= null  && addMap.containskey(al.Retail_Address_Reference__c )))
                {
                  /*  Account_Link__c alclone = new Account_Link__c(id=al.id);
                    alclone.Retail_Province__c = addMap.get(al.Retail_Address_Reference__c).Province__c;
                    alclone.Retail_City__c = addMap.get(al.Retail_Address_Reference__c).District__c;
                    //alclone.Retail_Distinct__c = addMap.get(al.Retail_Address_Reference__c).District__c;
                    alclone.Retail_Address_Line_1__c = addMap.get(al.Retail_Address_Reference__c).Address_Line_1__c;
                    alclone.Retail_Address_Line_2__c = addMap.get(al.Retail_Address_Reference__c).Address_Line_2__c;
                    alclone.Retail_Address_Line_3__c = addMap.get(al.Retail_Address_Reference__c).Address_Line_3__c;
                    alclone.Retail_Address_Type__c = addMap.get(al.Retail_Address_Reference__c).Address_Type__c;
                    alclone.Retail_ZipCode__c = addMap.get(al.Retail_Address_Reference__c).ZipCode__c;
                    alclone.Retail_Address_CreatedDate__c = date.newinstance(addMap.get(al.Retail_Address_Reference__c).CreatedDate.year(), addMap.get(al.Retail_Address_Reference__c).CreatedDate.month(), addMap.get(al.Retail_Address_Reference__c).CreatedDate.day());
                    alclone.Retail_Address_LastModifiedDate__c = date.newinstance(addMap.get(al.Retail_Address_Reference__c).LastModifiedDate.year(), addMap.get(al.Retail_Address_Reference__c).LastModifiedDate.month(), addMap.get(al.Retail_Address_Reference__c).LastModifiedDate.day());
                    accupdatelst.add(alclone);
                    */
                     al.Retail_Address_Type__c = addMap.get(al.Retail_Address_Reference__c).Address_Type__c;
                    al.Retail_Province__c =(addMap.get(al.Retail_Address_Reference__c).Province__c !=null ?(addMap.get(al.Retail_Address_Reference__c).Province__c): '') ;
                    al.Retail_City__c = (addMap.get(al.Retail_Address_Reference__c).District__c != null ? addMap.get(al.Retail_Address_Reference__c).District__c:'').left(35);
                    al.Retail_Distinct__c = ((addMap.get(al.Retail_Address_Reference__c).District__c!=null ? addMap.get(al.Retail_Address_Reference__c).District__c : '')+' '+(addMap.get(al.Retail_Address_Reference__c).Block__c!= null ?addMap.get(al.Retail_Address_Reference__c).Block__c : '')).left(35);
                    al.Retail_Address_Line_1__c = ((addMap.get(al.Retail_Address_Reference__c).Address_Line_1__c)!=null?addMap.get(al.Retail_Address_Reference__c).Address_Line_1__c:'').left(35);
                    al.Retail_Address_Line_2__c = ((addMap.get(al.Retail_Address_Reference__c).Address_Line_2__c)!=null?addMap.get(al.Retail_Address_Reference__c).Address_Line_2__c:'').left(35);
                    al.Retail_Address_Line_3__c = ((addMap.get(al.Retail_Address_Reference__c).Address_Line_3__c)!=null?addMap.get(al.Retail_Address_Reference__c).Address_Line_3__c:'').left(35);
                    al.Retail_ZipCode__c = (addMap.get(al.Retail_Address_Reference__c).ZipCode__c!=null ? addMap.get(al.Retail_Address_Reference__c).ZipCode__c : '' );
                    al.Retail_Address_CreatedDate__c = Date.ValueOf(addMap.get(al.Retail_Address_Reference__c).CreatedDate);
                    al.Retail_Address_LastModifiedDate__c = Date.ValueOf(addMap.get(al.Retail_Address_Reference__c).LastModifiedDate);
                }
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
                 if(((Account_Link__C)Trigger.newMap.get(acl.id)).fromRole__c!=((Account_Link__C)Trigger.OldMap.get(acl.id)).fromRole__c &&(acl.recordtypeid==AccountLink_RetailPersonRecordTypeId||acl.recordtypeid==AccountLink_RetailCompanyRecordTypeId) ){
                     deleteSharingRec.add(acl.fromrole__C);
                     recordstoDelete.add(acl.id);
                 }             
            }
        if(deleteSharingRec.size()>0){
            for(Account acc:[select id,Dealer_ND_Code__c,MD__c from Account where id IN:deleteSharingRec]){
			
                if(string.isnotblank(acc.Dealer_ND_Code__c)){ 
					string grpName= acc.MD__c+acc.Dealer_nd_Code__c;
					//gname.add(acc.Dealer_ND_Code__C);
					gname.add(grpName);
				}
                
            }
       
            //  List<Group> groupList = [select Id, Name, Type from Group where Name IN: gname];
          if(gname.size()>0)  delAlk= [SELECT Id, ParentId FROM Account_Link__Share WHERE ParentId IN: recordstoDelete AND UserOrGroupId IN :gname];
         }
         if(delAlk.size()>0){
             Database.delete(delAlk, false);
         }
         
         for(Account_Link__c alk:newacclinkmap){
             if(alk.Retail_Dealer_CompanyCode__c==null &&(alk.recordtypeid==AccountLink_RetailPersonRecordTypeId||alk.recordtypeid==AccountLink_RetailCompanyRecordTypeId)){
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
     public static void CDMAccountlinkContaxt(List<Account_Link__c> allist,string market,string Context){
                    Set < ID > acclids = new Set < ID > ();
                    set<ID> accLinkId= new set<ID>();
                     for (Account_Link__c accrec: allist) {
                         if ( (accrec.recordTypeID==accRetailPerson_RecordTypeId || accrec.recordTypeID==accRetailCompany_RecordTypeId)){
                            if(string.isnotblank(accrec.id)) accLinkId.add(accrec.id);
                         }
                     }
                     if(accLinkId.size()>0){
                        List < Account_Link__c > acclinkr = [Select Id, toRole__r.UCID__c,fromRole__r.Dealer_Rollout_Status__c,recordTypeID from Account_Link__c where id IN: accLinkId];
                            for (Account_Link__c accrec: acclinkr) {
                            if (String.isnotblank(accrec.toRole__r.UCID__c) && (accrec.recordTypeID==accRetailPerson_RecordTypeId || accrec.recordTypeID==accRetailCompany_RecordTypeId) && (string.isnotblank(accrec.fromRole__r.Dealer_Rollout_Status__c)?(accrec.fromRole__r.Dealer_Rollout_Status__c=='Done'):false))
                                acclids.add(accrec.id);
                        }
                       if(acclids.size()> 0) CDMInformatica_Services.createAccountLink(acclids, market, Context);
                      }
     }
     
     public static void CDMAccountlinkContextGroup(List<Account_Link__c> allist,string market,string Context){
                    Set < ID > acclids = new Set < ID > ();
                    Set<string>  MagicNumber= new set <string>();
                    set<ID> accLinkId= new set<ID>();
                     for (Account_Link__c accrec: allist) {
                         if ( (accrec.recordTypeID==accRetailPerson_RecordTypeId || accrec.recordTypeID==accRetailCompany_RecordTypeId)){
                            if(string.isnotblank(accrec.id)) accLinkId.add(accrec.id);
                         }
                     }
                    if(accLinkId.size()>0){
                    List < Account_Link__c > acclinkr = [Select Id,Retail_DMS_Customer_ID__c ,toRole__r.UCID__c,recordTypeID,fromRole__r.Dealer_Rollout_Status__c from Account_Link__c where id IN: allist];
                    for (Account_Link__c accrec: acclinkr) {
                           if (String.isnotblank(accrec.toRole__r.UCID__c) && (accrec.recordTypeID==accRetailPerson_RecordTypeId || accrec.recordTypeID==accRetailCompany_RecordTypeId)&&(string.isnotblank(accrec.fromRole__r.Dealer_Rollout_Status__c)?(accrec.fromRole__r.Dealer_Rollout_Status__c=='Done'):false) && (string.isnotblank(accrec.Retail_DMS_Customer_ID__c)?MagicNumber.contains(accrec.Retail_DMS_Customer_ID__c)?false:true:true))
                            {
                            if(string.isnotblank(accrec.Retail_DMS_Customer_ID__c)) MagicNumber.add(accrec.Retail_DMS_Customer_ID__c);
                            acclids.add(accrec.id);
                            }
                    }
                   if(acclids.size()> 0) CDMInformatica_Services.createAccountLink(acclids, market, Context);
                   }
     }
	 
	  Public static void OnAfterUpdateCreateC2CRetailCopy(List<Account_Link__c> newALRecords,Map<Id,Account_Link__c> oldMapAL){
    List<Account_Link__c> lnewAL = new List<Account_Link__c>();
    for(Account_Link__c al : [Select ID, Retail_Related_Company__c, Retail_Related_Company__r.toRole__c, toRole__c, recordtypeID from Account_Link__c where ID IN :newALRecords]){
        if(al.Retail_Related_Company__c != NULL && al.Retail_Related_Company__c != oldMapAL.get(al.ID).Retail_Related_Company__c && al.recordtypeID == accRetailPerson_RecordTypeId){
            Account_Link__c newAL = new Account_Link__c();
            newAL.fromRole__c = al.Retail_Related_Company__r.toRole__c;
            newAL.Role__c = 'Company';
            newAL.toRole__c = al.toRole__c;
            newAL.Role2__c = 'Employee';
            newAL.Active__c = true;
            newAL.recordtypeID = C2C_RecordTypeId;
            lnewAL.add(newAL);
        }
    }
    if(!lnewAL.isEmpty()){
        try{
            database.insert (lnewAL,false);
        }catch(Exception e){
            System.debug('Failed to insert C2C retail copies '+e.getMessage());
        }
    }
}


	Public static void  RemoveAccessofUsers(List<Account_Link__c> newALRecords,String Market){
		List<Account_Link__c> lnewAL = new List<Account_Link__c>();
		Set<id> idvalues= new set<id>();
		for(Account_Link__c al : newALRecords){
			if(al.Retail_Delete_Flag__c == true || al.Retail_Duplicate_Flag__c == true){
			idvalues.add(al.id);
			}
		}
		if(idvalues.size()>0){
		  list <user> Integrationuser= new list<user> ();
		  integrationuser=[select id from user where name =: system.label.IntegrationInfuser limit 1 ];
		   for(Account_Link__c al : newALRecords){
			if(al.Retail_Delete_Flag__c == true || al.Retail_Duplicate_Flag__c == true){
			if(integrationuser.size()>0) al.ownerid=integrationuser[0].id;
			}
			
		 }
		 database.delete([select id from account_link__share where parentid in: idvalues and RowCause ='Manual'],false);
		}
	}
}