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
    public  Id AccountLink_C2CRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
    Public  List<Account_link__C> Acclink;
    Public  List<Account_Link__Share> accLinkshareLst=new List<Account_Link__Share>();
    Public  List<User> usrlist=new List<User>();
    public  void afterInsertEventShareRetailCopy(List<Account_link__C> acclinklist){
        Map<Id,Id> c2cAccLinkIdfromRoleIdMap=new Map<Id,Id>();
        Map<Id,Id> c2cAccLinkIdToRoleIdMap=new Map<Id,Id>();
        Acclink=[select id,fromRole__c,toRole__c,RetailDealer_ND_Code__c,Retail_Delete_Flag__c,fromRole__r.Dealer_nd_Code__c,recordTypeId from Account_link__c  where  id=:acclinklist and (fromRole__c!=null or toRole__c!=null)];
        for(Account_link__c acclinkrec:Acclink){
            if(acclinkrec.fromRole__r.Dealer_nd_Code__c !=null){
                String grpName='TH'+acclinkrec.fromRole__r.Dealer_nd_Code__c;
                AcclinkMap.put(acclinkrec,grpName);								   
            }else if(acclinkrec.recordTypeID==AccountLink_C2CRecordTypeId && acclinkrec.fromRole__c!=null && acclinkrec.toRole__c!=null)
            {
                c2cAccLinkIdfromRoleIdMap.put(acclinkrec.Id,acclinkrec.fromRole__c);
                c2cAccLinkIdToRoleIdMap.put(acclinkrec.Id, acclinkrec.toRole__c);
            }
            
        }
    
            //sharing logic for contact to contact account link recordtype
            if(c2cAccLinkIdfromRoleIdMap!=null && c2cAccLinkIdfromRoleIdMap.size()>0)
            {
                List<Account_Link__c> accLinkLst=[select Id,RetailDealer_ND_Code__c,ownerId,toRole__c,fromRole__r.recordTypeID,recordTypeID from Account_Link__c where (toRole__c IN :c2cAccLinkIdfromRoleIdMap.values() or toRole__c IN :c2cAccLinkIdToRoleIdMap.values()) and (recordTypeId=:AccountLink_RetailPersonRecordTypeId or recordTypeId=:AccountLink_RetailCompanyRecordTypeId)];
                Map<Id,Id> accLinkIdToRoleIdMap=new Map<Id,Id>();
                Map<Id,Set<String>> accLinkIdDealerCodeMap=new Map<Id,Set<String>>();
                if(accLinkLst!=null && accLinkLst.size()>0)
                {
                    for(Account_Link__c accLink:accLinkLst)
                    {
                        accLinkIdToRoleIdMap.put(accLink.Id, accLink.toRole__c);
                        if(accLink.fromRole__c!=null && accLink.fromRole__r.recordTypeID==Dealer_RecordTypeId && accLink.RetailDealer_ND_Code__c!=null)
                        {
                            accLinkIdDealerCodeMap.put(accLink.Id, new Set<String>{accLink.RetailDealer_ND_Code__c});
                        }
                    }
                }
                
                Map<Id,Set<String>> c2cAccLinkFromRoleIdSetDealerCodeMap=new Map<Id,Set<String>>();
                Map<Id,Set<String>> c2cAccLinkToRoleIdSetDealerCodeMap=new Map<Id,Set<String>>();
                for(Id accLinkId:accLinkIdToRoleIdMap.keySet())
                {
                    for(Id c2cAccLinkId:c2cAccLinkIdfromRoleIdMap.keySet())
                    {
                        if(accLinkIdToRoleIdMap.get(accLinkId)==c2cAccLinkIdfromRoleIdMap.get(c2cAccLinkId) && accLinkIdDealerCodeMap.get(accLinkId)!=null && accLinkIdDealerCodeMap.get(accLinkId).size()>0)
                        {
       						if(!c2cAccLinkFromRoleIdSetDealerCodeMap.containsKey(c2cAccLinkId))
                            	c2cAccLinkFromRoleIdSetDealerCodeMap.put(c2cAccLinkId, accLinkIdDealerCodeMap.get(accLinkId));
                            else
                               c2cAccLinkFromRoleIdSetDealerCodeMap.get(c2cAccLinkId).addAll(accLinkIdDealerCodeMap.get(accLinkId)); 
                        }
                    }
                    for(Id c2cAccLinkId:c2cAccLinkIdToRoleIdMap.keySet())
                    {
                        if(accLinkIdToRoleIdMap.get(accLinkId)==c2cAccLinkIdToRoleIdMap.get(c2cAccLinkId) && accLinkIdDealerCodeMap.get(accLinkId)!=null && accLinkIdDealerCodeMap.get(accLinkId).size()>0)
                        {
                            if(!c2cAccLinkToRoleIdSetDealerCodeMap.containsKey(c2cAccLinkId))
                            	c2cAccLinkToRoleIdSetDealerCodeMap.put(c2cAccLinkId, accLinkIdDealerCodeMap.get(accLinkId));
                            else
                               c2cAccLinkToRoleIdSetDealerCodeMap.get(c2cAccLinkId).addAll(accLinkIdDealerCodeMap.get(accLinkId));
                        }
                    }
                    
                }
                for(Id c2cAccLinkId:c2cAccLinkFromRoleIdSetDealerCodeMap.keySet())
                {
                    Set<String> fromRoleDealerCodeSet=c2cAccLinkFromRoleIdSetDealerCodeMap.get(c2cAccLinkId);
                    Set<String> toRoleDealerCodeSet=c2cAccLinkToRoleIdSetDealerCodeMap.get(c2cAccLinkId);
                    if(fromRoleDealerCodeSet!=null && fromRoleDealerCodeSet.size()>0 && toRoleDealerCodeSet!=null && toRoleDealerCodeSet.size()>0)
                    {
                        for(String fromdealerCode:fromRoleDealerCodeSet)
                        {
                            if(fromdealerCode!=null && toRoleDealerCodeSet.contains(fromdealerCode))
                            {
                                if(!accLinkIdDealerCodeMap.containsKey(c2cAccLinkId))
                                    accLinkIdDealerCodeMap.put(c2cAccLinkId, new Set<String>{fromdealerCode});
                                else
                                    accLinkIdDealerCodeMap.get(c2cAccLinkId).add(fromdealerCode);
                            }
                                
                        }
                    }
                }
                Set<String> allDealerCodeSet=new Set<String>();
                List<Group> grpLst;
                Map<String,Id> dealerCodeGrpIdMap=new Map<String,Id>();
                //get groups
                for(Id accLinkId:c2cAccLinkIdfromRoleIdMap.keySet())
                {
                 	if(accLinkIdDealerCodeMap.get(accLinkId)!=null && accLinkIdDealerCodeMap.get(accLinkId).size()>0)
                    {
                        Set<String> delaerCodeSet=accLinkIdDealerCodeMap.get(accLinkId);
                        for(String dealerCode:delaerCodeSet)
                        {
                            String THdealerCode='TH'+dealerCode;
                            allDealerCodeSet.add(THdealerCode);
                        }
                        	
                    }
                }
                
                if(allDealerCodeSet!=null && allDealerCodeSet.size()>0)
                {
                   grpLst=[Select Id,Name from Group where Name IN: allDealerCodeSet];
                }
                if(grpLst!=null && grpLst.size()>0)
                {
                    for(Group gp:grpLst)
                    {
                        String dealerCode=gp.Name;
                        dealerCode=dealerCode.substring(2);
                        dealerCodeGrpIdMap.put(dealerCode, gp.Id);
                    }        
            
                }  
                //sharing for contact2contact account Link record type
                for(Id accLinkId:c2cAccLinkIdfromRoleIdMap.keySet())
                {
                    if(accLinkIdDealerCodeMap.get(accLinkId)!=null && accLinkIdDealerCodeMap.get(accLinkId).size()>0)
                    {
                          Set<String> delaerCodeSet=accLinkIdDealerCodeMap.get(accLinkId);
                          if(delaerCodeSet!=null && delaerCodeSet.size()>0)
                          {
                              for(String dealerCode:delaerCodeSet)
                              {
                                  if(dealerCodeGrpIdMap.get(dealerCode)!=null)
                                  {
                                      Account_Link__share alshare = new Account_Link__share();
                                      alshare.AccessLevel = 'EDIT';
                                      alshare.parentid = accLinkId;
                                      alshare.UserOrGroupId = dealerCodeGrpIdMap.get(dealerCode);
                                      alshare.RowCause = Schema.Account_link__Share.RowCause.Manual;
                                    
                                      accLinkshareLst.add(alshare);
                                  }
                                  
                              }
                  	 	   }
                	}
            	}
            }
		if(AcclinkMap!=null && AcclinkMap.size()>0)
        {
            List<Group> grpLst=[select Id, Name from Group where Name IN: AcclinkMap.values()];
            Map<String,Id> grpNameGrpId=new Map<String,Id>();
            for(Group gp:grpLst)
            {
                String dealerCode=gp.Name;
                dealerCode=dealerCode.substring(2);
                grpNameGrpId.put(dealerCode, gp.Id);
            }
            
            for(Account_link__c alk:Acclink){
                    if(alk.Retail_Delete_Flag__c==false && alk.RetailDealer_ND_Code__c!=null && grpNameGrpId.get(alk.RetailDealer_ND_Code__c)!=null){
                        Account_Link__Share alshare=new Account_Link__Share ();
                        alshare.AccessLevel='EDIT';
                        alshare.RowCause = Schema.Account_link__Share.RowCause.Manual;
                        alshare.ParentId = alk.id;
                        alshare.UserOrGroupId=grpNameGrpId.get(alk.RetailDealer_ND_Code__c);
                        accLinkshareLst.add(alshare);        
                    }
            }
            
        }
		
        /*
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: AcclinkMap.values()]){
            for(Account_link__c alk:Acclink){
                if(alk.Retail_Delete_Flag__c==false){
                    Account_Link__Share alshare=new Account_Link__Share ();
                    alshare.AccessLevel='EDIT';
                    alshare.RowCause = Schema.Account_link__Share.RowCause.Manual;
                    alshare.ParentId = alk.id;
                    alshare.UserOrGroupId=groupRec.id;
                    accLinkshareLst.add(alshare);        
                }
            }
            
        }*/
        
        if(accLinkshareLst.size()>0){
            Database.insert(accLinkshareLst, false);

        }
    }
	
	public static void addressupdateRT(List<Account_Link__c> alinks,Map<id,Account_Link__c> oldals)
        {
            List<Account_Link__c> accupdatelst = new List<Account_Link__c>();
            Set<Id>addid= new Set<Id>();
            for(Account_Link__c al: alinks)
            {
                if(al.Retail_Address_Reference__c != oldals.get(al.Id).Retail_Address_Reference__c && al.Retail_Address_Reference__c!= null)
                {
                    addid.add(al.Retail_Address_Reference__c);
                }
            }
            Map<id,Address__c> addMap =new Map<id,Address__c>([select id,name,createddate, LastModifiedDate, Customer__c,Address_Code__c,Address_Last_Modified_Date__c,Address_Line_1__c,Address_Line_1_Native__c,Address_Line_2__c,Address_Line_2_Native__c,Address_Line_3__c,Address_Type__c,Address_Type_Last_Modified_Date__c,Block__c,Block_Native__c,City__c,City_Native__c,Company_Name__c,Company_Name_Native__c,Country__c,Created_By_EP_Transaction__c,Delivery_Point_ID__c,Foreign_Nationals__c,FS_Hardcopy_Last_Modified_By__c,FS_Hardcopy_Last_Modified_Date__c,FS_Opt_In_Hardcopy__c,HouseNumber__c,isTestRunning__c,Language__c,Hardcopy_Last_Modified_By__c,Hardcopy_Last_Modified_Date__c,Market__c,MD__c,Opt_In_Hardcopy__c,ZipCode__c,Province__c,Province_Native__c,Preferred__c,Source_System__c,Status__c,Sub_District__c,TitleOfHonor__c,To_Be_Deleted__c,District__c,District_Native__c,Temp_Address__c,Temp_ZipCode__c,Updated_By_EP_Transactions__c from Address__c where id in : addid]);
            
            
            for(Account_Link__c al: alinks)
            {
                if(al.Retail_Address_Reference__c != oldals.get(al.Id).Retail_Address_Reference__c && al.Retail_Address_Reference__c!= null  && addMap.containskey(al.Retail_Address_Reference__c))
                {
                    Account_Link__c alclone = new Account_Link__c(id=al.id);
                    alclone.Retail_Province__c = addMap.get(al.Retail_Address_Reference__c).Province__c;
                    alclone.Retail_City__c = addMap.get(al.Retail_Address_Reference__c).Sub_District__c;
                    alclone.Retail_Distinct__c = addMap.get(al.Retail_Address_Reference__c).District__c;
                    alclone.Retail_Address_Line_1__c = addMap.get(al.Retail_Address_Reference__c).Address_Line_1__c;
                    alclone.Retail_Address_Line_2__c = addMap.get(al.Retail_Address_Reference__c).Address_Line_2__c;
                    alclone.Retail_Address_Type__c = addMap.get(al.Retail_Address_Reference__c).Address_Type__c;
                    alclone.Retail_ZipCode__c = addMap.get(al.Retail_Address_Reference__c).ZipCode__c;
                    alclone.Retail_Address_CreatedDate__c = date.newinstance(addMap.get(al.Retail_Address_Reference__c).CreatedDate.year(), addMap.get(al.Retail_Address_Reference__c).CreatedDate.month(), addMap.get(al.Retail_Address_Reference__c).CreatedDate.day());
                    alclone.Retail_Address_LastModifiedDate__c = date.newinstance(addMap.get(al.Retail_Address_Reference__c).LastModifiedDate.year(), addMap.get(al.Retail_Address_Reference__c).LastModifiedDate.month(), addMap.get(al.Retail_Address_Reference__c).LastModifiedDate.day());
                    accupdatelst.add(alclone);
                }
            }
            if(accupdatelst.size() > 0)
            update accupdatelst;
            
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
    Map<Id,String> accLinkIdDealerCodeMap=new Map<Id,String>();
    Map<Id,Id> accLinkId2AccIdMap=new Map<Id,Id>();
    List<Account_Link__c> Acclink=[select id,toRole__c,RetailDealer_ND_Code__c,fromRole__r.Dealer_ND_Code__c from Account_link__c  where toRole__c!=null and fromRole__c!=null and id=:acclinklist];
    for(Account_Link__c acclinkrec:Acclink){
        if(acclinkrec.RetailDealer_ND_Code__c!=null && acclinkrec.toRole__c!=null){
            String grpName='TH'+acclinkrec.RetailDealer_ND_Code__c;
            ndCode.add(grpName);
            accLinkIdDealerCodeMap.put(acclinkrec.Id, acclinkrec.RetailDealer_ND_Code__c);
            accLinkId2AccIdMap.put(acclinkrec.Id, acclinkrec.toRole__c);
        }
    }

    if(ndCode.size()>0){
        List<Group> grpLst=[select Id, Name from Group where Name IN: ndCode];
            Map<String,Id> grpNameGrpId=new Map<String,Id>();
            for(Group gp:grpLst)
            {
                String dealerCode=gp.Name;
                dealerCode=dealerCode.substring(2);
                grpNameGrpId.put(dealerCode, gp.Id);
            }
        	
            for(ID accLinkId:accLinkIdDealerCodeMap.keySet()){
                if(accLinkId2AccIdMap.get(accLinkId)!=null && accLinkIdDealerCodeMap.get(accLinkId)!=null)
                {
                    AccountShare thisAccountShare = new AccountShare(); //a new empty AccountShare object
                    thisAccountShare.userorgroupid = grpNameGrpId.get(accLinkIdDealerCodeMap.get(accLinkId));
                    thisAccountShare.accountid = accLinkId2AccIdMap.get(accLinkId);
                    thisAccountShare.accountaccesslevel = 'EDIT';
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
            gname.add('TH'+acc.Dealer_ND_Code__C);
            
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