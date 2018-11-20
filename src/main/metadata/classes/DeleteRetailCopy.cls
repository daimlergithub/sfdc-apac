/**
** Controller is used by ALKDeleteConformationpage 
** This will update the Retail Delete Flag
** Remove the sharing access to Dealer user
** Created By: Kiran P 
** Date: 15-12-2016
** Release : JP-3.0
** Modified By : 
** Modified date :
**/
public class DeleteRetailCopy{
        static Boolean isDeleted = false;
        //static Boolean isRetail_Delete = false;
        static List<User> integrationUser = [select id,name, profile.Name from user WHERE profile.Name = 'IntegrationAPI' AND ISActive = true LIMIT 1];
    public static void updateRetailCopy(){    
       
        Account_Link__c acclnk = [select id,Retail_Delete_Flag__c, fromRole__c,toRole__c from  Account_Link__c WHERE Id = : ApexPages.currentPage().getParameters().get('id')];
        acclnk.Retail_Delete_Flag__c = true;
        acclnk.ownerId = integrationUser[0].id;
        update acclnk;
        system.debug('acclnk--->'+acclnk.Id); 
        set<Id> dealerId = new set<Id> ();
        dealerId.add(acclnk.toRole__c);
        if(!dealerId.isEmpty()){
            updateAccoutOwner(dealerId); 
        }
        //update new Account_Link__c(id = ApexPages.currentPage().getParameters().get('id'), Retail_Delete_Flag__c = true);
        
        List<Account_Link__Share> sharesToDelete = [SELECT Id FROM Account_Link__Share WHERE ParentId =: acclnk.Id];
        system.debug('sharesToDelete --->'+sharesToDelete );   
        if(!sharesToDelete.isEmpty()){
            System.debug('Deleting the Share');
            Database.Delete(sharesToDelete, false);            
        }        
    }  
    public static void updateAccoutOwner(set<Id> dealerId){
        List<AccountShare> AccountsharesToDelete = new  List<AccountShare>();
        List<Case> listcase=new List<Case>();
        Set<Id> casid=new set<Id>();
        List<CaseShare> casesharesToDelete = new  List<CaseShare>();
        
        List<Lead__c> listlead=new List<Lead__c>();
        Set<Id> leadsid=new set<Id>();
        List<Lead__Share> LeadsharesToDelete = new  List<Lead__Share>();        
        
        List<DM_Request__c> listdmreq=new List<DM_Request__c>();
        Set<Id> dmreqid=new set<Id>();
        List<DM_Request__Share> DmReqsharesToDelete = new  List<DM_Request__Share>();
        
        List<SurveyTaker__c> listsury=new List<SurveyTaker__c>();
        Set<Id> surid=new set<Id>();
        List<SurveyTaker__share> sutlist=new list<SurveyTaker__share>();   
        
        List<Vehicle_Relationship__c> listvr=new List<Vehicle_Relationship__c>();
        Set<Id> vrid=new set<Id>();
        List<Vehicle_Relationship__Share> VrReqsharesToDelete = new  List<Vehicle_Relationship__Share>();
        
        List<Retail_Task__c> listrt=new List<Retail_Task__c>();
        Set<Id> rtid=new set<Id>();
        List<Retail_Task__Share> rettasksharesToDelete = new  List<Retail_Task__Share>();
        
         List<Campaign_Member__c> liscmmt=new List<Campaign_Member__c>();
        Set<Id> cmemid=new set<Id>();
        List<Campaign_Member__Share> CmmReqsharesToDelete = new  List<Campaign_Member__Share>();
        
        List<Account> accountupdateList = new List<Account>();
        List<String> accNames=new List<String>();
        set<String> DealerGCCode = new set<String>();
        
        //List<Account_Link__c> accountlink = [select id,fromRole__c from Account_Link__c WHERE toRole__c = : dealerId];
        for(Account_Link__c acc : [select id,Retail_Delete_Flag__c, fromRole__c,Retail_Dealer_CompanyCode__c from Account_Link__c WHERE toRole__c = : dealerId AND (RecordType.Developername = 'Retail_Company' OR RecordType.Developername = 'Retail_Person')]){
            if(acc.Retail_Delete_Flag__c){
                isDeleted = true;
                DealerGCCode.add(acc.Retail_Dealer_CompanyCode__c);
            }
            /*if(!acc.Retail_Delete_Flag__c){
                isRetail_Delete = true;            
            }*/
          }  
            if(isDeleted ){
              // Account act = new Account(id=dealerId, ownerid = integrationUser[0].id );
               //accountupdateList .add(act);
               
               //Commented as part of SFDCJP-2593
               
                for(Account act : [Select id , Ownerid,CreatedById,CreatedBy.Profile.Name from Account where id in:dealerId]){
                    System.debug('act.CreatedBy.Profile.Name'+act.CreatedBy.Profile.Name);                    
                    if(act.CreatedBy.Profile.Name.Contains('Japan Dealer')){
                        act.OwnerID = integrationUser[0].id;
                       accountupdateList.add(act);
                   }
                }
                Set<ID> userId=new Set<Id>();
                for(Account DealerAcc : [select Id, Name,Dealer_GC_Code__c  from Account Where Dealer_GC_Code__c IN : DealerGCCode]){
                    accNames.add(DealerAcc.Name); 
                    userId.add(DealerAcc.id);
                }
                List<Group> list_User = new List<Group>( [select Id, Name, Type from Group where Name IN:accNames]);
                 AccountsharesToDelete = [SELECT Id,RowCause FROM AccountShare WHERE AccountId IN : dealerId AND RowCause = 'Manual' AND UserOrGroupId IN :list_User];
               List<User> CaseDealerUser=new List<User>();
                CaseDealerUser=[Select Id,Name,Dealer_GC_Code__c,contactId,isactive,Contact.AccountId,Contact.Account.Name,Profile.Name,Profile.userlicense.name from user where Contact.AccountId=:userId and isactive=true and (profile.Name='Japan Dealer Service Advisor' or profile.Name='Japan Dealer Sales Representative') and Dealer_GC_Code__c IN : DealerGCCode];
        
                //Delete case share.
                if(dealerId !=null)
                {
                    listcase=[Select id,AccountId from Case where AccountId in: dealerId];
                 for(case a:listcase)
                 {
                 casid.add(a.id);
                 }
                    if(casid !=null)
                    {
                 casesharesToDelete=[SELECT Id,RowCause FROM caseShare WHERE caseid IN : casid AND RowCause = 'Manual' AND UserOrGroupId IN :CaseDealerUser];       
                    }
                 

                    
                }
                                  
                 //Delete Lead Share
                 if(dealerId !=null)
                 {
				listlead=[Select id,Contact__c from Lead__C where Contact__c in: dealerId];
                 for(Lead__c le:listlead)
                 {
                 leadsid.add(le.id);
                 }
                system.debug('@@@@@@@@@'+leadsid+'@@@@@@@@@@@@@@@ list_User'+list_User);
                     if(leadsid !=null)
                     {
						LeadsharesToDelete=[SELECT Id,RowCause,parentID FROM Lead__Share WHERE parentId IN : leadsid AND (RowCause = 'Manual' OR RowCause = 'Assigned_Dealer__c') AND UserOrGroupId IN :list_User];                         
                     }
                                                     
                 }
                
               //DM Request delete.
               if(dealerId !=null)
               {
                    listdmreq=[Select id,Contact__c from DM_Request__c where Contact__c in: dealerId]; 
               for(DM_Request__c dm:listdmreq)
               {
               dmreqid.add(dm.id);
               }  
                   if(dmreqid !=null)
                   {
               		DmReqsharesToDelete=[Select id,ParentID,Rowcause from DM_Request__Share where parentId in:dmreqid AND (RowCause = 'Manual' OR RowCause = 'Assigned_Dealer__c') AND UserOrGroupId IN :list_User];        
                   }
               
           
                   
               }
                  
               
               //Survey taker.
               if(dealerId !=null)
               {
                   listsury=[Select id,Account__c,MD__c  from SurveyTaker__c where MD__c='JP' and Account__c in: dealerId];
                if(listsury !=null)
                {
                    for(SurveyTaker__c sur:listsury )
                    {
						surid.add(sur.id);                        
                    }
                    if(surid !=null)
                    {
					sutlist=[Select id,ParentID,Rowcause from SurveyTaker__Share where parentId in:surid AND (RowCause = 'Manual' OR RowCause = 'Assigned_Dealer__c') AND UserOrGroupId IN :list_User];                        
                    }
                    
                }
                   
               }
               
                //Vehicle Relation ship share.
                if(dealerId !=null)
                {
                     listvr=[Select id,Contact__c from Vehicle_Relationship__c where contact__c in: dealerId];
                    for(Vehicle_Relationship__c vrs:listvr)
                    {
                        vrid.add(vrs.id);
                    }
                    
               
                if(vrid !=null)
                {
           			VrReqsharesToDelete=[Select id,ParentID,Rowcause from Vehicle_Relationship__Share where parentId in:vrid AND (RowCause = 'Manual' OR RowCause = 'Assigned_Dealer__c') AND UserOrGroupId IN :list_User];         
                }
                     }
               
           
              //Retail_Task__c  share.
              if(dealerId !=null)
              {
                  listrt=[Select id,Finance_Contractor__c,Account__c from Retail_Task__c where Finance_Contractor__c in: dealerId or Account__c in:dealerId];
                for(Retail_Task__c rt:listrt)
                {
                    rtid.add(rt.id);
                }
               
                  if(rtid !=null)
                  {
           			rettasksharesToDelete =[Select id,ParentID,Rowcause from Retail_Task__Share where parentId in:rtid AND (RowCause = 'Manual' OR RowCause = 'Assigned_Dealer__c') AND UserOrGroupId IN :list_User];           
                  }       
                  
              }
                
                 //Campaign_Member__c  share.
                 if(dealerId !=null)
                 {
                      liscmmt=[Select id,Contact_ID__c from Campaign_Member__c where Contact_ID__c in: dealerId];
                    for(Campaign_Member__c cmm:liscmmt)
                    {
                        cmemid.add(cmm.id);
                    }
						if(cmemid !=null)
                        {
                     	CmmReqsharesToDelete  =[Select id,ParentID,Rowcause from Campaign_Member__Share where parentId in:cmemid AND (RowCause = 'Manual' OR RowCause = 'Assigned_Dealer__c') AND UserOrGroupId IN :list_User];       
                        }
                     
                 }
               
               
           
        
            }
        
       
    
        if(!accountupdateList.isEmpty())
        update accountupdateList;
        
        if(!AccountsharesToDelete.isEmpty())
        database.delete(AccountsharesToDelete,false);
        //Delete case share.
        if(casesharesToDelete !=null)
        {
        
        database.delete(casesharesToDelete,false);
        }
         //Delete Lead share.
        if(LeadsharesToDelete !=null)
        {
        
         database.delete(LeadsharesToDelete,false);
        }
         //Delete Dm Request share.
        if(DmReqsharesToDelete !=null)
        {
        
         database.delete(DmReqsharesToDelete,false);
        }
        if(sutlist !=null)
        {            
                database.delete(sutlist,false);
        }
        if(VrReqsharesToDelete !=null)
        {            
                database.delete(VrReqsharesToDelete,false);
        }
        if(rettasksharesToDelete !=null)
        {            
                database.delete(rettasksharesToDelete,false);
        }
        if(CmmReqsharesToDelete !=null)
        {            
                database.delete(CmmReqsharesToDelete,false);
        }
   }
}