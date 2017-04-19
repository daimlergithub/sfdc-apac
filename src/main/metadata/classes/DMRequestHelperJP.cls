/*
    Type:      class
    Purpose:   1.Update Address fields of DMRequest on Address type pickilist of DM request  (UpdateDMRequest)
               2.Throw error when DMRequest was created or updated by IntegrationAPI profile user(intigrationAPICheck)

    Create By: Sriram kalluri
*/
public with sharing class  DMRequestHelperJP {
    
      
      /**             
        * @Description: Update Address fields of DMRequest on Address type pickilist of DM request on Update of DM Request
        * @author     : sriram kalluri
        * @Date       : 1/12/2016
        * @param      : list of new DMRequests, old map and some trigger evenets
        * @return     : void
        * @see:       : DMRequestHelperJP
        */
    
    public static void UpdateDMRequest(List<DM_Request__c> triggerNew,Map<ID,DM_Request__c> oldMap,boolean isUpdate){
        set<id> CustomerId = new set<id>();  
        Map<id,map<string,Address__c>> addressMap =new Map<id,map<string,Address__c>>();
        map<string,Address__c> admap =new map<string,Address__c>();
        map<string,Address__c> promap = new map<string,Address__c>();
        string regexForNullValue ='null';
        string nullValue ='';
        String province;
        Map<String, String> addtrmapUpdate = UtilAddressTranslation.addtrmap;
        UtilAddressTranslation.gettranslatedvalues('JP');
                 //get the accountIds 
                for(DM_Request__c lstDMR:triggerNew){
                    CustomerId.add(lstDMR.Customer_Name__c);
                }  
              
                //query for arelated addresses and create a nested map
                for(Address__c addrlst:[select Customer__c,Address_Type__c,ZipCode__c,Province__c,City__c,District__c,Block__c,Address_Line_1__c,Address_Line_2__c,Company_Name__c,TitleOfHonor__c from Address__c where Customer__c IN:CustomerId])
                {
                    admap.put(addrlst.Address_Type__c, addrlst);
                    addressMap.put(addrlst.Customer__c, admap);
                } 
            
            for(DM_Request__c lstDMR:triggerNew){          
               
               if((lstDMR.Sending_Address__c!=null)&&(lstDMR.Sending_Address__c!='Temporary'))
               {
                   if(lstDMR.Sending_Address__c!=oldMap.get(lstDMR.id).Sending_Address__c)
                   {
                        if((addressMap.containsKey(lstDMR.Customer_Name__c))&&(addressMap.get(lstDMR.Customer_Name__c).containsKey(lstDMR.Sending_Address__c)))
                        {
                                if(addressMap.get(lstDMR.Customer_Name__c).get(lstDMR.Sending_Address__c).Address_Type__c==lstDMR.Sending_Address__c){                                                                       
                                    Address__c address = addressMap.get(lstDMR.Customer_Name__c).get(lstDMR.Sending_Address__c);
                                    lstDMR.Zip_Code__c=address.ZipCode__c;
                                    lstDMR.Address__c=address.City__c+address.District__c+address.Block__c+address.Address_Line_1__c;
                                    lstDMR.Additional_Address__c=address.Address_Line_2__c;
                                    lstDMR.Attention__c=address.Company_Name__c;
                                    lstDMR.TitleOfHonor__c=address.TitleOfHonor__c;
                                    if(addtrmapUpdate.containsKey(address.Province__c))
                                    {
                                       province = addtrmapUpdate.get(address.Province__c);
                                    }
                                    lstDMR.Province__c = province;
                                }
                                else{
                                    lstDMR.adderror(Label.DMRequest_validation_error);
                                }
                                lstDMR.Address__c=lstDMR.Address__c.replaceAll(regexForNullValue,nullValue);
                        }
                        else{
                                lstDMR.adderror(Label.DMRequest_validation_error);
                            }
                    
                  }
               }
                
            }  
        
    }
    

public static void afterInsertEvent(List<DM_Request__c> newList){
        
        Map<Id, List<Id>> mapDmrequest = new Map<Id, List<Id>>();
        Map<Id, List<Id>> mapCheckingType = new Map<Id, List<Id>>();
        Set<Id> currentVrId=new Set<Id>();
        
        List<DM_Request__Share> list_SharingRecord = new List<DM_Request__Share>();
        
        for(DM_Request__c vc : newList){
            if (vc.Customer_Name__c != null && vc.View_By_All__c == true  ){
                if(!mapCheckingType.containsKey(vc.Customer_Name__c)){
                      mapCheckingType.put(vc.Customer_Name__c, new List<Id>());
                      currentVrId.add(vc.Id);
                  }
                  mapCheckingType.get(vc.Customer_Name__c).add(vc.Id);
            }else if(vc.Assigned_Dealer__c != null ){
                if(!mapDmrequest.containsKey(vc.Assigned_Dealer__c)){
                      mapDmrequest.put(vc.Assigned_Dealer__c, new List<Id>());
                  }
                  mapDmrequest.get(vc.Assigned_Dealer__c).add(vc.Id);
            }
            system.debug('++++++++++++++++'+mapDmrequest );
            system.debug('++++++++++++++++'+ mapCheckingType );
        
        if(mapDmrequest.size() > 0){
            list_SharingRecord.addAll(createDealerAccountSharing(mapDmrequest));
        }
        if(mapCheckingType.size() > 0){
            list_SharingRecord.addAll(createPersonOrCompanyAccountSharing(mapCheckingType,currentVrId));
        }
        
        
        
        if(list_SharingRecord.size() > 0){
            Database.insert(list_SharingRecord, false);
        }
        system.debug('++++++++++++++'+list_SharingRecord);
    }
    }
    
    
    public static void afterUpdateEvent(List<DM_Request__c> newList, Map<Id, DM_Request__c> oldMap){
        
        Map<Id, List<Id>> mapDmrequest = new Map<Id, List<Id>>();
        Map<Id, List<Id>> mapCheckingType = new Map<Id, List<Id>>();
        List<DM_Request__Share> list_SharingRecord = new List<DM_Request__Share>();
        Set<Id> currentVrId=new Set<Id>();
        List<Account_Link__c> ListAlk=new List<Account_Link__c>();
        //List<User> list_User = new List<User>();
        List<String> accNames=new List<String>();
        List<String> GcNames=new List<String>();
        Set<Id> set_AccountId = new Set<Id>();
        Set<Id> set_LinkId = new Set<Id>();
        Set<Id> set_CustomerId = new Set<Id>();
        List<Id> list_DmrequestId = new List<Id>();
        
        
        for(DM_Request__c vc : newList){
            if(vc.Customer_Name__c != null  &&vc.Customer_Name__c != oldMap.get(vc.Id).Customer_Name__c && vc.View_By_All__c == true || vc.View_By_All__c == true ){
                    if(!mapCheckingType.containsKey(vc.Customer_Name__c)){
                          mapCheckingType.put(vc.Customer_Name__c, new List<Id>());
                      }
                      mapCheckingType.get(vc.Customer_Name__c).add(vc.Id);
                      currentVrId.add(vc.Id);
                      if(vc.Customer_Name__c != oldMap.get(vc.Id).Customer_Name__c){
                    set_CustomerId.add(oldMap.get(vc.Id).Customer_Name__c);
                    }
                    if(vc.View_By_All__c != oldMap.get(vc.Id).View_By_All__c  && vc.View_By_All__c == true){
                    
                    set_AccountId.add(vc.Assigned_Dealer__c);
                    }
                   list_DmrequestId.add(vc.Id);
                      
               
                
        }else if(vc.Assigned_Dealer__c != null && vc.Assigned_Dealer__c != oldMap.get(vc.Id).Assigned_Dealer__c || vc.View_By_All__c == false ){
                if(!mapDmrequest.containsKey(vc.Assigned_Dealer__c)){
                      mapDmrequest.put(vc.Assigned_Dealer__c, new List<Id>());
                  }
                  mapDmrequest.get(vc.Assigned_Dealer__c).add(vc.Id);
                  currentVrId.add(vc.Id);
                  if(vc.Assigned_Dealer__c != oldMap.get(vc.Id).Assigned_Dealer__c){
                  set_AccountId.add(oldMap.get(vc.Id).Assigned_Dealer__c);
                  }
                  if(vc.View_By_All__c != oldMap.get(vc.Id).View_By_All__c  && vc.View_By_All__c == false){
                    
                    set_CustomerId.add(vc.Customer_Name__c);
                    }
                  list_DmrequestId.add(vc.Id);
            }
          }  
          
          system.debug('++++++++++++++++'+mapDmrequest );
            system.debug('++++++++++++++++'+ mapCheckingType );
            system.debug('++++++++++++++'+set_AccountId);
            system.debug('++++++++++++++'+set_CustomerId);
        
        if(set_AccountId.size() > 0){
             List<Account> accName = [select Name,Dealer_GC_Code__c from Account where Id IN:set_AccountId];
            for(Account acc : accName){
               //accNames.add(acc.Name);
               GcNames.add(acc.Dealer_GC_Code__c );
               system.debug('++++++++++++++'+'True');
               
            
            } 
            List<Account> accGCode = [select Name,Dealer_GC_Code__c from Account where Dealer_GC_Code__c  IN: GcNames AND RecordTypeId =: Dealer_RecordTypeId];
                for(Account accs : accGCode ){
                  accNames.add(accs.Name);  
                
            }
            } else if(set_CustomerId.size() >0){
                   system.debug('++++++++++++++'+'False');
               ListAlk=[select id,fromRole__c,toRole__c from Account_Link__c where toRole__c=:set_CustomerId];
                if(ListAlk.size() > 0){
         
         for(Account_Link__c  alk:ListAlk)
         {
         if(alk.fromRole__c!=null && alk.toRole__c!=null)
         {
         set_LinkId.add(alk.fromRole__c);
         } }
         List<Account> accName = [select Name,Dealer_GC_Code__c from Account where Id IN:set_LinkId];
            for(Account acc : accName){
              // accNames.add(acc.Name);
               GcNames.add(acc.Dealer_GC_Code__c );
            
            }
            List<Account> accGCode = [select Name,Dealer_GC_Code__c from Account where Dealer_GC_Code__c  IN: GcNames AND RecordTypeId =: Dealer_RecordTypeId];
                for(Account accs : accGCode ){
                  accNames.add(accs.Name);  
                
            }
            
             } }
         
              system.debug('++++++++++++++'+accNames);
            
            
            List<Group> list_User = new List<Group>( [select Id, Name, Type from Group where Name IN:accNames]);
            system.debug('+++++++++++'+list_User);
           List<DM_Request__Share> list_SharingDele = new List<DM_Request__Share>([SELECT Id FROM DM_Request__Share 
                                                                                            WHERE ParentId IN:list_DmrequestId AND UserOrGroupId IN :list_User]);
            if(list_SharingDele.size() > 0){
                delete list_SharingDele;
                system.debug('+++++++++++'+list_SharingDele);
            } 
        
        
        if(mapDmrequest.size() > 0){
            list_SharingRecord.addAll(createDealerAccountSharing(mapDmrequest));
        }
        
        if(mapCheckingType.size() > 0){
            list_SharingRecord.addAll(createPersonOrCompanyAccountSharing(mapCheckingType,currentVrId));
        }
        
        if(list_SharingRecord.size() > 0){
            Database.insert(list_SharingRecord, false);
        }
        system.debug('++++++++++++++'+list_SharingRecord);
    }
    public static Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    // Get all the Dealer Account with Same GC Code -
    private static Map<Id, Set<Id>> getAllDealerAccountWithSameGCCode(Set<Id> dealerAccountIdSet) {
        
        List<Account> dealerAccList = [select Id, Dealer_GC_Code__c from Account where Id =: dealerAccountIdSet AND RecordTypeId =: Dealer_RecordTypeId ];
        Map<String, Id> gcCodeToDealerAccIdMap = new Map<String, Id>();
        for(Account accRec : dealerAccList) {
            gcCodeToDealerAccIdMap.put(accRec.Dealer_GC_Code__c, accRec.Id);
        }
        
        Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = new Map<Id, Set<Id>>();
        if(dealerAccList.size() > 0) {
            List<Account> similarGCCodeDealerAccountList = [select Id, Dealer_GC_Code__c from Account where Dealer_GC_Code__c IN: gcCodeToDealerAccIdMap.keySet()
                                                                    AND RecordTypeId =: Dealer_RecordTypeId ];
                                                                    
                       system.debug('+++++++++++++++++++'+similarGCCodeDealerAccountList);
            for(Account accRec : similarGCCodeDealerAccountList) {
                if(!dealerIdToSimilarGCCodeDealerAccountIdsMap.containsKey(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c))) {
                    dealerIdToSimilarGCCodeDealerAccountIdsMap.put(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c), new Set<Id>());
                }
                dealerIdToSimilarGCCodeDealerAccountIdsMap.get(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c)).add(accRec.Id);
            }                                                       
        }
        return dealerIdToSimilarGCCodeDealerAccountIdsMap;
    }
    
    
    private static List<DM_Request__Share> createDealerAccountSharing(Map<Id, List<Id>> mapDmrequest){
    // START: Adding Similar GC Code related Account To Map which is sharing already.
        Set<Id> dealerAccIdSet = new Set<Id>();
        for(Id dealerAccId : mapDmrequest.keySet()) {
            dealerAccIdSet.add(dealerAccId);
        }
        Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = getAllDealerAccountWithSameGCCode(dealerAccIdSet);
        
        for(Id dealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.keySet()) {
            if(mapDmrequest.containsKey(dealerId)) {
                List<Id> vrIdList = mapDmrequest.get(dealerId);
                for(Id similarGCCodeDealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.get(dealerId)) {
                    mapDmrequest.put(similarGCCodeDealerId, vrIdList);
                }
            }
        }
        // Changing Sharing from User to Public Group
        List<Account> dealerAccList = [select Name from Account where Id IN: mapDmrequest.keySet()];
        Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        for(Account dealerRec : dealerAccList) {
            dealerAccNameSet.add(dealerRec.Name);
            accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
        }

        // END: Adding Similar GC Code related Account To Map which is sharing already.
        List<DM_Request__Share> list_SharingRecord = new List<DM_Request__Share>();
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]){
            if(accNameToAccIdMap.containsKey(groupRec.Name) && mapDmrequest.containsKey(accNameToAccIdMap.get(groupRec.Name))){
                for(Id acId : mapDmrequest.get(accNameToAccIdMap.get(groupRec.Name))){
                    DM_Request__Share dmRequestShare = new DM_Request__Share();
                    dmRequestShare.AccessLevel = 'Edit';
                    dmRequestShare.UserOrGroupId = groupRec.Id;
                    dmRequestShare.ParentId = acId;
                    dmRequestShare.RowCause = Schema.DM_Request__Share.RowCause.Manual;
                    list_SharingRecord.add(dmRequestShare);
                }
            }
        }
        return list_SharingRecord;
    }
    
    
    private static List<DM_Request__Share> createPersonOrCompanyAccountSharing(Map<Id, List<Id>> mapCheckingType,Set<Id> currentVrId){
    List<Account_Link__c> ListAlk=new List<Account_Link__c>();
        Set<Id> DealerAccId=new Set<Id>();
        Set<Id> VrID=new Set<Id>();
        
        ListAlk = [select id,fromRole__c,toRole__c from Account_Link__c where toRole__c=:mapCheckingType.keySet() ];
        for(Account_Link__c alk:ListAlk) {
            DealerAccId.add(alk.fromRole__c);
        }
        DealerAccId.remove(null);
        
        // Start: Share with all Dealer Account with same GC Code
        Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = getAllDealerAccountWithSameGCCode(DealerAccId);
        for(Id dealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.keySet()) {
            for(Id similarGCCodeDealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.get(dealerId)) {
                DealerAccId.add(similarGCCodeDealerId);
            }
        }
        // Finish: Share with all Dealer Account with same GC Code
        
        
        // Changing Sharing from User to Public Group
        List<Account> dealerAccList = [select Name from Account where Id IN: DealerAccId];
        Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        for(Account dealerRec : dealerAccList) {
            dealerAccNameSet.add(dealerRec.Name);
            accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
        }
        
        
        System.debug('DealerAccId  newList'+DealerAccId);

        List<DM_Request__Share> list_SharingRecord = new List<DM_Request__Share>();
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]){
            if(currentVrId != null){
                for(Id ids:currentVrId){
                    DM_Request__Share dmRequestShare = new DM_Request__Share();
                    dmRequestShare.AccessLevel = 'Edit';
                    dmRequestShare.UserOrGroupId = groupRec.Id;
                    dmRequestShare.ParentId = ids;
                    dmRequestShare.RowCause = Schema.DM_Request__Share.RowCause.Manual;
                    list_SharingRecord.add(dmRequestShare);
                }
            }
        }
        return list_SharingRecord;
    }

    /**             
        * @Description: Update Address fields of DMRequest on Address type pickilist of DM request on Insert of DM request
        * @author     : sriram kalluri
        * @Date       : 1/12/2016
        * @param      : list of new DMRequests, old map and some trigger evenets
        * @return     : void
        * @see:       : DMRequestHelperJP
        */
    
    public static void InsertDMRequest(List<DM_Request__c> triggerNew,boolean isInsert)
    {
        set<id> CustomerId = new set<id>();  
        Map<id,map<string,Address__c>> addressMap =new Map<id,map<string,Address__c>>();
        map<string,Address__c> admap =new map<string,Address__c>();
        map<string,Address__c> promap = new map<string,Address__c>();
        string regexForNullValue ='null';
        string nullValue ='';
        String province;
        Map<String, String> addtrmapInsert = UtilAddressTranslation.addtrmap;
        UtilAddressTranslation.gettranslatedvalues('JP');
                 //get the accountIds 
                 if(triggerNew!=null)
                {
                for(DM_Request__c lstDMR:triggerNew){
                if(lstDMR.Customer_Name__c!=null)
                    {
                    CustomerId.add(lstDMR.Customer_Name__c);
                    }
                }  
              }
                //query for arelated addresses and create a nested map
                for(Address__c addrlst:[select Customer__c,Address_Type__c,ZipCode__c,Province__c,City__c,District__c,Block__c,Address_Line_1__c,Address_Line_2__c,Company_Name__c,TitleOfHonor__c from Address__c where Customer__c IN:CustomerId])
                {
                    admap.put(addrlst.Address_Type__c, addrlst);
                    addressMap.put(addrlst.Customer__c, admap);
                } 
            if(triggerNew!=null)
                {
            for(DM_Request__c lstDMR:triggerNew){          
                
               if((lstDMR.Sending_Address__c!=null)&&(lstDMR.Sending_Address__c!='Temporary'))
               {                   
                   if((addressMap.containsKey(lstDMR.Customer_Name__c))&&(addressMap.get(lstDMR.Customer_Name__c).containsKey(lstDMR.Sending_Address__c)))
                        {
                                if(addressMap.get(lstDMR.Customer_Name__c).get(lstDMR.Sending_Address__c).Address_Type__c==lstDMR.Sending_Address__c){                                                                                                           
                                    Address__c address = addressMap.get(lstDMR.Customer_Name__c).get(lstDMR.Sending_Address__c);
                                    lstDMR.Zip_Code__c=address.ZipCode__c;
                                    lstDMR.Address__c=address.City__c+address.District__c+address.Block__c+address.Address_Line_1__c;
                                    lstDMR.Additional_Address__c=address.Address_Line_2__c;
                                    lstDMR.Attention__c=address.Company_Name__c;
                                    lstDMR.TitleOfHonor__c=address.TitleOfHonor__c;
                                    if(addtrmapInsert.containsKey(address.Province__c))
                                    {
                                       province = addtrmapInsert.get(address.Province__c);
                                    }
                                    lstDMR.Province__c = province;
                                }
                                else{
                                    lstDMR.adderror(Label.DMRequest_validation_error);
                                }
                                lstDMR.Address__c=lstDMR.Address__c.replaceAll(regexForNullValue,nullValue);
                        }
                        else{
                                lstDMR.adderror(Label.DMRequest_validation_error);
                            }                    
                  
               }
                
            }  
            }
        
    }
    
    
  
       /**             
        * @Description: Update status after 3 months
        * @author     : sriram kalluri
        * @Date       : 02/04/2016
        * @param      : list of new DMRequests, old map.
        * @return     : void
        * @see:       : DMRequestHelperJP
        */      
       
        
    public static void updateStatus(List<DM_Request__c> triggerNew,Map<ID,DM_Request__c> oldMap,boolean isInsert,boolean isUpdate)
    {
            set<id> CustomerId = new set<id>(); 
            list<DM_Request__c> DMList =new  list<DM_Request__c>();
            User Usr = new User();
            Usr = [SELECT Market__C,Id FROM User WHERE Id = : UserInfo.getUserId()];
            Map<Id,DM_Request__c> mapDMRequest=new Map<Id,DM_Request__c>();
            //get the accountIds 
            if(triggerNew!=null)
            {
                for(DM_Request__c lstDMR:triggerNew){
                if(lstDMR.Customer_Name__c !=null)
                {
                    CustomerId.add(lstDMR.Customer_Name__c);
                    }
                }  
             }   
              
        //query for DM_Request__c 
           
		if(Usr.Market__C=='JP')
		{
			DMList=[select Customer_Name__c,Expected_DM_Material1__c,Expected_DM_Material2__c,Expected_DM_Material3__c from DM_Request__c where Customer_Name__c IN:CustomerId and Sent_Date__c >= LAST_90_DAYS and (Status1__c='Success' OR Status2__c='Success' OR Status3__c='Success')];
		}
		else If(Usr.Market__C=='KR')
		{
			DMList=[select Id,Customer_Name__c,Expected_DM_Material1__c,Expected_DM_Material2__c,Expected_DM_Material3__c from DM_Request__c where Customer_Name__c IN:CustomerId and Sent_Date__c <= LAST_N_DAYS:60 and (Status1__c='Success' OR Status2__c='Success' OR Status3__c='Success')];
		}  
		if(!DMList.isEmpty() && DMList.size() > 0)
		{
			 for(DM_Request__c lstDMR:DMList)
			 {
				  mapDMRequest.put(lstDMR.Customer_Name__c,lstDMR);
			 }     
				for(DM_Request__c lstDMR:triggerNew)
				{
					if(isUpdate){
				 
					   if((lstDMR.Status__c=='to be sent')&&((lstDMR.Status1__c=='to be sent')||(lstDMR.Status2__c=='to be sent')||(lstDMR.Status3__c=='to be sent'))
						 &&((lstDMR.Expected_DM_Material1__c!=oldMap.get(lstDMR.id).Expected_DM_Material1__c)||(lstDMR.Expected_DM_Material2__c!=oldMap.get(lstDMR.id).Expected_DM_Material2__c)||(lstDMR.Expected_DM_Material3__c!=oldMap.get(lstDMR.id).Expected_DM_Material3__c)
						 ||(lstDMR.Status__c!=oldMap.get(lstDMR.id).Status__c)||(lstDMR.Status1__c!=oldMap.get(lstDMR.id).Status1__c)||(lstDMR.Status2__c!=oldMap.get(lstDMR.id).Status2__c)||(lstDMR.Status3__c!=oldMap.get(lstDMR.id).Status3__c))){
							   if(mapDMRequest.get(lstDMR.Customer_Name__c).Customer_Name__c != null){
							 if(mapDMRequest.get(lstDMR.Customer_Name__c).Customer_Name__c==lstDMR.Customer_Name__c){
									If(Usr.Market__C=='KR'){
										 lstDMR.Status__c='Duplicate';
									   }                     
									 if((lstDMR.Expected_DM_Material1__c!=null)&&((lstDMR.Expected_DM_Material1__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material1__c)||(lstDMR.Expected_DM_Material1__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material2__c)||(lstDMR.Expected_DM_Material1__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material3__c))){
										 lstDMR.Status1__c='Duplicate';
										 
									 }
									  if((lstDMR.Expected_DM_Material2__c!=null)&&((lstDMR.Expected_DM_Material2__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material1__c)||(lstDMR.Expected_DM_Material2__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material2__c)||(lstDMR.Expected_DM_Material2__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material3__c))){
										
										 lstDMR.Status2__c='Duplicate';
										 
									 }
									 if((lstDMR.Expected_DM_Material3__c!=null)&&((lstDMR.Expected_DM_Material3__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material1__c)||(lstDMR.Expected_DM_Material3__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material2__c)||(lstDMR.Expected_DM_Material3__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material3__c))){
										 
										 lstDMR.Status3__c='Duplicate';
									 }
							 }
						}               
				   }
					   
			   }
				if(isInsert)
				{
					 if((lstDMR.Status__c=='to be sent')&&((lstDMR.Status1__c=='to be sent')||(lstDMR.Status2__c=='to be sent')||(lstDMR.Status3__c=='to be sent'))
					 &&((lstDMR.Expected_DM_Material1__c!=NULL)||(lstDMR.Expected_DM_Material2__c!=NULL)||(lstDMR.Expected_DM_Material3__c!=NULL)
					 ||(lstDMR.Status__c!=NULL)||(lstDMR.Status1__c!=NULL)||(lstDMR.Status2__c!=NULL)||(lstDMR.Status3__c!=NULL))){
					  if(mapDMRequest.get(lstDMR.Customer_Name__c).Customer_Name__c != null) {
					  if(mapDMRequest.get(lstDMR.Customer_Name__c).Customer_Name__c==lstDMR.Customer_Name__c){
								If(Usr.Market__C=='KR'){
									 lstDMR.Status__c='Duplicate';
								   }                      
								 if((lstDMR.Expected_DM_Material1__c!=null)&&((lstDMR.Expected_DM_Material1__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material1__c)||(lstDMR.Expected_DM_Material1__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material2__c)||(lstDMR.Expected_DM_Material1__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material3__c))){
									 lstDMR.Status1__c='Duplicate';                                    
								 }
								  if((lstDMR.Expected_DM_Material2__c!=null) && ((lstDMR.Expected_DM_Material2__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material1__c)||(lstDMR.Expected_DM_Material2__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material2__c)||(lstDMR.Expected_DM_Material2__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material3__c))){
									
									 lstDMR.Status2__c='Duplicate';                                    
								 }
								 if((lstDMR.Expected_DM_Material3__c!=null) && ((lstDMR.Expected_DM_Material3__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material1__c)||(lstDMR.Expected_DM_Material3__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material2__c)||(lstDMR.Expected_DM_Material3__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material3__c))){
									 lstDMR.Status3__c='Duplicate';
								 }
						  }
						  }
				}
			   }
			}
		}
     }
  }