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
        //String grpName=usr.contact.account.Dealer_Nd_code__c;
		String grpName=Market+usr.contact.account.Dealer_Nd_code__c;
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
            dealerCode=dealerCode.substring(2);
            dealerCodeGrpIdMap.put(dealerCode, gp.Id);
        }        

    }  
}
    
global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT {0} FROM {1} WHERE {2} and {3}';
         List<String> condition = new List<String>();
        if ('Account_Link__c'.equalsIgnoreCase(sobjectName)){
            condition.add('Id,RetailDealer_ND_Code__c,ownerId,toRole__c,fromRole__c,fromRole__r.recordTypeID,recordTypeID');
            condition.add('Account_Link__c');
            condition.add('Md__c=:market');
            condition.add('(toRole__c!=null or fromRole__c!=null) AND Retail_Delete_Flag__c = false AND Retail_Duplicate_Flag__c = false');
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
		else if('Retail_Task__c'.equalsIgnoreCase(sobjectName)){
            condition.add('Id,Service_Dealer__r.Dealer_ND_Code__c,MD__c');
            condition.add('Retail_Task__c');
            condition.add('MD__c=:market');
            condition.add('Service_Dealer__c!=null and Service_Dealer__r.Dealer_ND_Code__c IN:dealerCodeLst and recordtype.name=\'Service\'');          
        }
        
        return Database.getQueryLocator(String.format(query, condition));
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        if ('Account_Link__c'.equalsIgnoreCase(sobjectName)) {
            Map<String,List<Account_Link__c>> DealerCodeAccountLinkMap=new Map<String,List<Account_Link__c>>();
            Map<Id,Id> accLinkIdToRoleIdMap=new Map<Id,Id>();
			Map<Id,Set<String>> accLinkIdDealerCodeMap=new Map<Id,Set<String>>();
            Map<Id,String> accLinkIdDealerCodeForAccountMap=new Map<Id,String>();
            Id dealerAccountRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
            Id contact2contactAccountLinkRecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
            Map<Id,Id> c2cAccLinkIdfromRoleIdMap=new Map<Id,Id>();
            Map<Id,Id> c2cAccLinkIdToRoleIdMap=new Map<Id,Id>();																	 
			
            for(sObject sObj:scope)
            {  
                Account_Link__c alObj=(Account_Link__c)sObj;
                accLinkIdToRoleIdMap.put(alObj.Id, alObj.toRole__c);
                if(alObj.fromRole__c!=null && alObj.fromRole__r.recordTypeID==dealerAccountRecordTypeId && alObj.RetailDealer_ND_Code__c!=null)
                {
                    accLinkIdDealerCodeMap.put(alObj.Id, new Set<String>{alObj.RetailDealer_ND_Code__c});
                    accLinkIdDealerCodeForAccountMap.put(alObj.Id, alObj.RetailDealer_ND_Code__c);
                }
                else if(alObj.recordTypeID==contact2contactAccountLinkRecordTypeId && alObj.fromRole__c!=null && alObj.toRole__c!=null)
                {
                    c2cAccLinkIdfromRoleIdMap.put(alObj.Id,alObj.fromRole__c);
                    c2cAccLinkIdToRoleIdMap.put(alObj.Id, alObj.toRole__c);
                    
                }
                    
            }
            
            //sharing logic for contact to contact account link recordtype
            if(c2cAccLinkIdfromRoleIdMap!=null && c2cAccLinkIdfromRoleIdMap.size()>0)
            {
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
            }
             
            List<Account_Link__share> insertaccLinkShare=new List<Account_Link__share>();
            List<AccountShare> insertaccShare=new List<AccountShare>();
            
                for(Id accLinkId:accLinkIdToRoleIdMap.keySet())
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
                                  Account_Link__share accLinkShare = new Account_Link__share();
                                  accLinkShare.AccessLevel = 'EDIT';
                                  accLinkShare.parentid = accLinkId;
                                  accLinkShare.UserOrGroupId = dealerCodeGrpIdMap.get(dealerCode);
                                  accLinkShare.RowCause = Schema.Account_link__Share.RowCause.Manual;
                                
                                  insertaccLinkShare.add(accLinkShare);
                              }
                              
                          }
                          
                      }
                        //all account records will shared excecpt dealer account record type
                        if(accLinkIdToRoleIdMap.get(accLinkId)!=null && accLinkIdDealerCodeForAccountMap.get(accLinkId)!=null)
                        {
                            if(accLinkIdDealerCodeForAccountMap.get(accLinkId)!=null && dealerCodeGrpIdMap.get(accLinkIdDealerCodeForAccountMap.get(accLinkId))!=null)
                            {
                                AccountShare accShare=new AccountShare();
                                accShare.AccountAccessLevel = 'EDIT';
                                accShare.OpportunityAccessLevel = 'READ';
                                accShare.AccountId = accLinkIdToRoleIdMap.get(accLinkId);
                                accShare.UserOrGroupId = dealerCodeGrpIdMap.get(accLinkIdDealerCodeForAccountMap.get(accLinkId));
                                accShare.RowCause = Schema.AccountShare.RowCause.Manual; 
                                
                                insertaccShare.add(accShare);
                            }
                            
                        }
                        
                       
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
		else if('Retail_Task__c'.equalsIgnoreCase(sobjectName))
      {
            Map<String,List<Retail_Task__c>> DealerCodeRTMap=new Map<String,List<Retail_Task__c>>();
            for(sObject sObj:scope)
            {  
                Retail_Task__c RTObj=(Retail_Task__c)sObj;
                if(DealerCodeRTMap.containsKey(RTObj.Service_Dealer__r.Dealer_ND_Code__c))
                {
                    List<Retail_Task__c> rtList=new List<Retail_Task__c>();
                    rtList=DealerCodeRTMap.get(RTObj.Service_Dealer__r.Dealer_ND_Code__c);
                    rtList.add(RTObj);
                    DealerCodeRTMap.put(RTObj.Service_Dealer__r.Dealer_ND_Code__c,rtList);
                }
                else //if Dealer code is not present in map
                {
                    List<Retail_Task__c> rtList=new List<Retail_Task__c>();
                    rtList.add(RTObj);
                    DealerCodeRTMap.put(RTObj.Service_Dealer__r.Dealer_ND_Code__c,rtList);
                }
            }
            
            
           List<Retail_Task__Share> insertRTShare=new List<Retail_Task__Share>();
            for(String dealerCode:DealerCodeRTMap.keySet())
            {
                List<Retail_Task__c> rtList=DealerCodeRTMap.get(dealerCode);
                
                for(Retail_Task__c RTObj:rtList)
                {
                     Retail_Task__Share share = new Retail_Task__Share();
                     share.AccessLevel = 'READ';
                     share.ParentId = RTObj.Id;
                     share.UserOrGroupId = dealerCodeGrpIdMap.get(RTObj.Service_Dealer__r.Dealer_ND_Code__c);
                     share.RowCause = Schema.Retail_Task__Share.RowCause.Service_Share__c;
                     insertRTShare.add(share);

                }
            }
            if(insertRTShare!=null && insertRTShare.size()>0)
             DMLManagerService.insertAsSystem(insertRTShare); 
        }
    }
    global void finish(Database.BatchableContext BC)
    {
		Id dealerAccountRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
        List<Account> dealerAccountLst=[Select Id,Dealer_ND_Code__c from account where recordTypeId=:dealerAccountRecordTypeId];
        Map<Id,String> accIdDealerCodeMap=new Map<Id,String>();
        List<AccountShare> insertaccShare=new List<AccountShare>();
        if(dealerAccountLst!=null && dealerAccountLst.size()>0)
        {
            for(Account acc:dealerAccountLst)
            {
                accIdDealerCodeMap.put(acc.Id, acc.Dealer_ND_Code__c);
            }
        }
        //share dealerRecordType
        if(accIdDealerCodeMap!=null && accIdDealerCodeMap.size()>0)
        {
            for(Id accId:accIdDealerCodeMap.keySet())
            {
                if(accIdDealerCodeMap.get(accId)!=null && dealerCodeGrpIdMap.get(accIdDealerCodeMap.get(accId))!=null)
                {
                    AccountShare accShare=new AccountShare();
                    accShare.AccountAccessLevel = 'EDIT';
                    accShare.OpportunityAccessLevel = 'READ';
                    accShare.AccountId = accId;
                    accShare.UserOrGroupId = dealerCodeGrpIdMap.get(accIdDealerCodeMap.get(accId));
                    accShare.RowCause = Schema.AccountShare.RowCause.Manual; 
                    insertaccShare.add(accShare);          
                }
             
            }
            if(insertaccShare!=null && insertaccShare.size()>0)
            {
                DMLManagerService.insertAsSystem(insertaccShare); 
            }
            
        }
    }																																		 
  
}