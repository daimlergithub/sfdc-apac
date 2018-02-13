global class ShareALLRecordsToNewUserBatch implements Database.Batchable<sObject>{
global final ID newUserID;
global final String existUserIDs;
global final String sobjectName;
global Map<String,Id> dealerCodeGrpIdMap;
global Set<String> dealerCodeLst;
Global string market;

global ShareALLRecordsToNewUserBatch (List<ID> userIdLst,String sobjectNameStr,string md){
    sobjectName = sobjectNameStr;
    List<User> usrLst=[Select Id,contact.account.Dealer_Nd_code__c from User where Id IN:userIdLst];
    dealerCodeGrpIdMap=new Map<String,Id>();
    Set<String> grpNamesLst=new Set<String>();
    dealerCodeLst=new Set<String>();
	market=md;
    for(User usr:usrLst)
    {
        String grpName=usr.contact.account.Dealer_Nd_code__c;
		//String grpName=Market+usr.contact.account.Dealer_Nd_code__c;
        grpNamesLst.add(grpName);
        dealerCodeLst.add(usr.contact.account.Dealer_Nd_code__c);
    }
    
    List<Group> grpLst;
    if(grpNamesLst!=null && grpNamesLst.size()>0)
    {
        grpLst=[Select Id,Name from Group where Name IN: grpNamesLst];
    }
    if(grpLst!=null && grpLst.size()>0)
    {
        for(Group gp:grpLst)
        {
            String dealerCode=gp.Name;
            //dealerCode=dealerCode.substring(2);
            dealerCodeGrpIdMap.put(dealerCode, gp.Id);
        }        

    }  
}
    
global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT {0} FROM {1} WHERE {2} and {3}';
         List<String> condition = new List<String>();
        if ('Account_Link__c'.equalsIgnoreCase(sobjectName)){
            condition.add('Id,RetailDealer_ND_Code__c,ownerId,toRole__c');
            condition.add('Account_Link__c');
            condition.add('Md__c=:market');
            condition.add('toRole__c!=null');
        } else if ('Lead__c'.equalsIgnoreCase(sobjectName)){
            condition.add('Id,Assigned_Dealer__r.Dealer_ND_Code__c,ownerId');
            condition.add('Lead__c');
            condition.add('Md__c=:market');
            condition.add('Assigned_Dealer__c!=null and Assigned_Dealer__r.Dealer_ND_Code__c IN:dealerCodeLst');
        } else if ('Case'.equalsIgnoreCase(sobjectName)){
            condition.add('Id,Case_Dealer__r.Dealer_ND_Code__c,ownerId');
            condition.add('Case');
            condition.add('Md__c=:market');
            condition.add('Case_Dealer__c!=null and Case_Dealer__r.Dealer_ND_Code__c IN:dealerCodeLst');
        }else if('Vehicle_Relationship__c'.equalsIgnoreCase(sobjectName)){
            condition.add('Id,Owner_Dealer_ND_Code__c,Vehicle_ID__c,Vehicle_ID__r.Car_Model__c');
            condition.add('Vehicle_Relationship__c');
            condition.add('Md__c=:market');
            condition.add('Owner_Dealer__c!=null and Owner_Dealer_ND_Code__c IN:dealerCodeLst');
          
        }else if('User'.equalsIgnoreCase(sobjectName)){
            condition.add('Id,Dealer_ND_Code__c');
            condition.add('User');
            condition.add('Market__c=:market');
            condition.add('Dealer_ND_Code__c!=null and Dealer_ND_Code__c IN:dealerCodeLst');
          
        }
        
        return Database.getQueryLocator(String.format(query, condition));
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        if ('Account_Link__c'.equalsIgnoreCase(sobjectName)) {
            Map<String,List<Account_Link__c>> DealerCodeAccountLinkMap=new Map<String,List<Account_Link__c>>();
            Map<Id,Id> accLinkIdToRoleIdMap=new Map<Id,Id>();
            for(sObject sObj:scope)
            {  
                Account_Link__c alObj=(Account_Link__c)sObj;
                accLinkIdToRoleIdMap.put(alObj.Id, alObj.toRole__c);
            }
            Id dealerAccountRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
            List<Account_Link__c> accLinkLst;
            if(accLinkIdToRoleIdMap!=null && accLinkIdToRoleIdMap.size()>0)
              accLinkLst=[select Id,toRole__c,RetailDealer_ND_Code__c from Account_Link__c where fromRole__r.recordTypeId=:dealerAccountRecordTypeId and toRole__c IN:accLinkIdToRoleIdMap.values()];
            
            Map<Id,String> accLinkIdDealerNdCodeMap=new Map<Id,String>();
            if(accLinkLst!=null && accLinkLst.size()>0)
            {
                for(Account_Link__c accLinkObj:accLinkLst)
                {
                    accLinkIdDealerNdCodeMap.put(accLinkObj.toRole__c, accLinkObj.RetailDealer_ND_Code__c);
                }
            }
            
            
            List<Account_Link__share> insertaccLinkShare=new List<Account_Link__share>();
            List<AccountShare> insertaccShare=new List<AccountShare>();
            
            for(Id accLinkId:accLinkIdToRoleIdMap.keySet())
                {
                    if(dealerCodeGrpIdMap.get(accLinkIdDealerNdCodeMap.get(accLinkIdToRoleIdMap.get(accLinkId)))!=null)
                    {
                       Account_Link__share accLinkShare = new Account_Link__share();
                      accLinkShare.AccessLevel = 'EDIT';
                      accLinkShare.parentid = accLinkId;
                      accLinkShare.UserOrGroupId = dealerCodeGrpIdMap.get(accLinkIdDealerNdCodeMap.get(accLinkIdToRoleIdMap.get(accLinkId)));
                      accLinkShare.RowCause = Schema.Account_link__Share.RowCause.Manual;
                    
                      insertaccLinkShare.add(accLinkShare);
                        
                        AccountShare accShare=new AccountShare();
                        accShare.AccountAccessLevel = 'EDIT';
                        accShare.OpportunityAccessLevel = 'READ';
                        accShare.AccountId = accLinkIdToRoleIdMap.get(accLinkId);
                        accShare.UserOrGroupId = dealerCodeGrpIdMap.get(accLinkIdDealerNdCodeMap.get(accLinkIdToRoleIdMap.get(accLinkId)));
                        accShare.RowCause = Schema.AccountShare.RowCause.Manual; 
                        
                        insertaccShare.add(accShare);
                       
                    }
                 }
                
            
            if(insertaccLinkShare!=null && insertaccLinkShare.size()>0)
            {
                DMLManagerService.insertAsSystem(insertaccLinkShare);
                
            }
            if(insertaccShare!=null && insertaccShare.size()>0)
            {
                DMLManagerService.insertAsSystem(insertaccShare); 
            }
               
              
        }else if('Lead__c'.equalsIgnoreCase(sobjectName))
      {
            Map<String,List<Lead__c>> DealerCodeLeadMap=new Map<String,List<Lead__c>>();
            for(sObject sObj:scope)
            {  
                Lead__c leadObj=(Lead__c)sObj;
                if(DealerCodeLeadMap.containsKey(leadObj.Assigned_Dealer__r.Dealer_ND_Code__c))
                {
                    List<Lead__c> leadLst=new List<Lead__c>();
                    leadLst=DealerCodeLeadMap.get(leadObj.Assigned_Dealer__r.Dealer_ND_Code__c);
                    leadLst.add(leadObj);
                    DealerCodeLeadMap.put(leadObj.Assigned_Dealer__r.Dealer_ND_Code__c,leadLst);
                }
                else //if Dealer code is not present in map
                {
                    List<Lead__c> leadLst=new List<Lead__c>();
                    leadLst.add(leadObj);
                    DealerCodeLeadMap.put(leadObj.Assigned_Dealer__r.Dealer_ND_Code__c,leadLst);
                }
            }
            
            
            List<Lead__share> insertleadShare=new List<Lead__share>();
            for(String dealerCode:DealerCodeLeadMap.keySet())
            {
                
                List<Lead__c> leadLst=DealerCodeLeadMap.get(dealerCode);
                
                for(Lead__c leadObj:leadLst)
                {
                      Lead__share share = new Lead__share();
                      share.AccessLevel = 'EDIT';
                      share.parentid = leadObj.Id;
                      share.UserOrGroupId = dealerCodeGrpIdMap.get(leadObj.Assigned_Dealer__r.Dealer_ND_Code__c);
                      share.RowCause = Schema.Lead__Share.RowCause.Manual;
                      insertleadShare.add(share);
                }
            }
            if(insertleadShare!=null && insertleadShare.size()>0)
             DMLManagerService.insertAsSystem(insertleadShare); 
        }else if('Case'.equalsIgnoreCase(sobjectName))
      {
            Map<String,List<Case>> DealerCodeCaseMap=new Map<String,List<Case>>();
            for(sObject sObj:scope)
            {  
                Case caseObj=(Case)sObj;
                if(DealerCodeCaseMap.containsKey(caseObj.Case_Dealer__r.Dealer_ND_Code__c))
                {
                    List<Case> caseLst=new List<Case>();
                    caseLst=DealerCodeCaseMap.get(caseObj.Case_Dealer__r.Dealer_ND_Code__c);
                    caseLst.add(caseObj);
                    DealerCodeCaseMap.put(caseObj.Case_Dealer__r.Dealer_ND_Code__c,caseLst);
                }
                else //if Dealer code is not present in map
                {
                    List<Case> caseLst=new List<Case>();
                    caseLst.add(caseObj);
                    DealerCodeCaseMap.put(caseObj.Case_Dealer__r.Dealer_ND_Code__c,caseLst);
                }
            }
            
            
           List<CaseShare> insertCaseShare=new List<CaseShare>();
            for(String dealerCode:DealerCodeCaseMap.keySet())
            {
                List<Case> caseLst=DealerCodeCaseMap.get(dealerCode);
                
                for(Case caseObj:caseLst)
                {
                     CaseShare share = new CaseShare();
                     share.CaseAccessLevel = 'EDIT';
                     share.CaseId = caseObj.Id;
                     share.UserOrGroupId = dealerCodeGrpIdMap.get(caseObj.Case_Dealer__r.Dealer_ND_Code__c);
                     share.RowCause = Schema.Caseshare.RowCause.Manual;
                     insertCaseShare.add(share);

                }
            }
            if(insertCaseShare!=null && insertCaseShare.size()>0)
             DMLManagerService.insertAsSystem(insertCaseShare); 
        }else if('Vehicle_Relationship__c'.equalsIgnoreCase(sobjectName))
      {
            Map<String,List<Vehicle_Relationship__c>> DealerCodeVRMap=new Map<String,List<Vehicle_Relationship__c>>();
            for(sObject sObj:scope)
            {  
                Vehicle_Relationship__c vrObj=(Vehicle_Relationship__c)sObj;
                if(DealerCodeVRMap.containsKey(vrObj.Owner_Dealer_ND_Code__c))
                {
                    List<Vehicle_Relationship__c> vrLst=new List<Vehicle_Relationship__c>();
                    vrLst=DealerCodeVRMap.get(vrObj.Owner_Dealer_ND_Code__c);
                    vrLst.add(vrObj);
                    DealerCodeVRMap.put(vrObj.Owner_Dealer_ND_Code__c,vrLst);
                }
                else //if Dealer code is not present in map
                {
                    List<Vehicle_Relationship__c> vrLst=new List<Vehicle_Relationship__c>();
                    vrLst.add(vrObj);
                    DealerCodeVRMap.put(vrObj.Owner_Dealer_ND_Code__c,vrLst);
                }
            }
            
            List<Vehicle_Relationship__share> insertVRShare=new List<Vehicle_Relationship__share>();
            List<Vehicle__share> insertVehShare=new List<Vehicle__share>();
            List<Car_Model__share> insertCarModelShare=new List<Car_Model__share>();
            
            for(String dealerCode:DealerCodeVRMap.keySet())
            {
                List<Vehicle_Relationship__c> vrLst=DealerCodeVRMap.get(dealerCode);
                
                for(Vehicle_Relationship__c vrObj:vrLst)
                {
                     Vehicle_Relationship__share vrShare = new Vehicle_Relationship__share();
                     vrShare.AccessLevel = 'EDIT';
                     vrShare.parentId = vrObj.Id;
                     vrShare.UserOrGroupId = dealerCodeGrpIdMap.get(vrObj.Owner_Dealer_ND_Code__c);
                     vrShare.RowCause = Schema.Vehicle_Relationship__share.RowCause.Manual;
                     insertVRShare.add(vrShare);
                    
					if(vrObj.Vehicle_ID__c!=null){
						Vehicle__share vehShare = new Vehicle__share();
						vehShare.AccessLevel = 'READ';
						vehShare.parentId = vrObj.Vehicle_ID__c;
						vehShare.UserOrGroupId = dealerCodeGrpIdMap.get(vrObj.Owner_Dealer_ND_Code__c);
						vehShare.RowCause = Schema.Vehicle__share.RowCause.Manual;
						insertVehShare.add(vehShare);
                    }
                }
            }
            if(insertVRShare!=null && insertVRShare.size()>0)
            {
                DMLManagerService.insertAsSystem(insertVRShare); 
                DMLManagerService.insertAsSystem(insertVehShare); 
                //DMLManagerService.insertAsSystem(insertCarModelShare); 
            }
             
        }else if('User'.equalsIgnoreCase(sobjectName))
      {
            Map<String,List<User>> DealerCodeUserMap=new Map<String,List<User>>();
            for(sObject sObj:scope)
            {  
                User userObj=(User)sObj;
                if(DealerCodeUserMap.containsKey(userObj.Dealer_ND_Code__c))
                {
                    List<User> userLst=new List<User>();
                    userLst=DealerCodeUserMap.get(userObj.Dealer_ND_Code__c);
                    userLst.add(userObj);
                    DealerCodeUserMap.put(userObj.Dealer_ND_Code__c,userLst);
                }
                else //if Dealer code is not present in map
                {
                    List<User> userLst=new List<User>();
                    userLst.add(userObj);
                    DealerCodeUserMap.put(userObj.Dealer_ND_Code__c,userLst);
                }
            }
            
            
           List<UserShare> insertUserShare=new List<UserShare>();
            for(String dealerCode:DealerCodeUserMap.keySet())
            {
                List<User> userLst=DealerCodeUserMap.get(dealerCode);
                
                for(User userObj:userLst)
                {
                     UserShare share = new UserShare();
                     share.UserAccessLevel = 'READ';
                     share.UserId = userObj.Id;
                     share.UserOrGroupId = dealerCodeGrpIdMap.get(userObj.Dealer_ND_Code__c);
                     share.RowCause = Schema.Usershare.RowCause.Manual;
                     insertUserShare.add(share);

                }
            }
            if(insertUserShare!=null && insertUserShare.size()>0)
             DMLManagerService.insertAsSystem(insertUserShare); 
        }            
    }
    global void finish(Database.BatchableContext BC)
    {
        
    }


}