public with sharing class  DMRequestHelperBase {
    public static User Usr = [SELECT Id, Market__c,Profile.Name FROM User WHERE Id = : UserInfo.getUserId()];
      
      /**             
        * @Description: Update Address fields of DMRequest on Address type pickilist of DM request on Update of DM Request
        * @author     : sushma bharti
        * @Date       : 25/10/2016
        * @param      : list of new DMRequests, old map and some trigger evenets
        * @return     : void
        * @see:       : DMRequestHelperBase
        */
    
    public static void UpdateDMRequest(List<DM_Request__c> triggerNew,Map<ID,DM_Request__c> oldMap,boolean isUpdate,string market){
        set<id> CustomerId = new set<id>();  
        Map<id,map<string,Address__c>> addressMap =new Map<id,map<string,Address__c>>();
        map<string,Address__c> admap =new map<string,Address__c>();
        map<string,Address__c> promap = new map<string,Address__c>();
        string regexForNullValue ='null';
        string nullValue ='';
        String province;
         Set<String> province1=new set<String>();
        Map<String, String> addtrmapUpdate = UtilAddressTranslation.addtrmap;
        if(test.isrunningtest() && Usr.Profile.Name != 'IntegrationAPI' && Usr.Market__c !=null)
        {
            UtilAddressTranslation.gettranslatedvalues(Usr.Market__c);
        }
                 //get the accountIds 
                for(DM_Request__c lstDMR:triggerNew){
                    CustomerId.add(lstDMR.Customer_Name__c);
                }  
              
              
                 String str;
               for(Account s:[select id,MD__c From Account Where id =:CustomerId] )
               {
               
               str = s.MD__c;
               }
                if(!test.isrunningtest() && Usr.Profile.Name == 'IntegrationAPI' && usr.Market__c ==null && str!=null)
        {
        UtilAddressTranslation.gettranslatedvalues(str);
        }
                //query for arelated addresses and create a nested map
                for(Address__c addrlst:[select Customer__c,Address_Type__c,ZipCode__c,Province__c,City__c,District__c,Block__c,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,Company_Name__c,TitleOfHonor__c from Address__c where Customer__c IN:CustomerId])
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
                                    lstDMR.Address__c=address.Address_Line_1__c+' '+address.Address_Line_2__c+' '+address.Address_Line_3__c+' '+address.city__c+' '+address.District__c+' '+address.Province__c+' '+address.zipcode__c;
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
    
    /**             
        * @Description: Update Address fields of DMRequest on Address type pickilist of DM request on Insert of DM request
        * @author     : sushma bharti
        * @Date       : 25/10/2017
        * @param      : list of new DMRequests, old map and some trigger evenets
        * @return     : void
        * @see:       : DMRequestHelperBase
        */
    
    public static void InsertDMRequest(List<DM_Request__c> triggerNew,boolean isInsert,string market)
    {
        set<id> CustomerId = new set<id>();  
        Map<id,map<string,Address__c>> addressMap =new Map<id,map<string,Address__c>>();
        map<string,Address__c> admap =new map<string,Address__c>();
        map<string,Address__c> promap = new map<string,Address__c>();
        string regexForNullValue ='null';
        string nullValue ='';
        String province;
        Set<String> province1=new set<String>();
        Map<String, String> addtrmapInsert = UtilAddressTranslation.addtrmap;
        
          if(!test.isrunningtest() && Usr.Profile.Name != 'IntegrationAPI' && usr.Market__c !=null)
        {
        UtilAddressTranslation.gettranslatedvalues(Usr.Market__c);
        }
                 //get the accountIds 
                 if(triggerNew!=null)
                {
                for(DM_Request__c lstDMR:triggerNew){
                if(lstDMR.Customer_Name__c!=null)
                    {
                    CustomerId.add(lstDMR.Customer_Name__c);
                    province1.add(lstDMR.Md__c);
                    }
                }  
              }
               
               String str;
               for(Account s:[select id,MD__c From Account Where id =:CustomerId] )
               {
               
               str = s.MD__c;
               }
                if(!test.isrunningtest() && Usr.Profile.Name == 'IntegrationAPI' && usr.Market__c ==null && str!=null)
        {
        UtilAddressTranslation.gettranslatedvalues(str);
        }
                //query for arelated addresses and create a nested map
                for(Address__c addrlst:[select Customer__c,Address_Type__c,ZipCode__c,Province__c,City__c,District__c,Block__c,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,Company_Name__c,TitleOfHonor__c from Address__c where Customer__c IN:CustomerId])
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
                                    lstDMR.Address__c=address.Address_Line_1__c+' '+address.Address_Line_2__c+' '+address.Address_Line_3__c+' '+address.city__c+' '+address.District__c+' '+address.Province__c+' '+address.zipcode__c;
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
    
    public static list<DM_Material__Share> insertDMMaterialShareList = new list<DM_Material__Share>();
    public static void shareDMRequestRecordsWithDealer (list<DM_Request__c> dmRequestListNew, Map<ID, DM_Request__c> dmRequestlListOld, String market)
    {
        if(userinfo.getUserType() == 'PowerPartner')
        {
            list<DM_Request__Share> insertDMRequestShareList = new list<DM_Request__Share>();
            list<Id> userIdList = new list<Id>();
            set<string> dealerCompNdCodeSet = new set<string>();
            list<Group> dealerCompGroupList = new list<Group>();
            User currentUser = [select Id, Contact.Account.Dealer_Type__c, Contact.Account.Dealer_ND_Code__c from User where Id =: UserInfo.getUserId()];
            
            if(String.isNotBlank(currentUser.Contact.Account.Dealer_ND_Code__c)){
               String dealerndcode = currentUser.Contact.Account.Dealer_ND_Code__c;
               dealerCompGroupList = [select Id, Name from Group where Name = :dealerndcode];
               if(!dmRequestListNew.isEmpty() && dmRequestListNew != null)
                {
                    for(DM_Request__c dmRqtl : dmRequestListNew)
                    {
                        if(!dealerCompGroupList.isEmpty() && dealerCompGroupList != null)
                        {
                            for(group grp : dealerCompGroupList)
                            {
                                DM_Request__Share dmRqtShare = new DM_Request__Share();
                                dmRqtShare.ParentId = dmRqtl.Id;
                                dmRqtShare.AccessLevel = 'Edit';
                                dmRqtShare.UserOrGroupId = grp.Id;
                                insertDMRequestShareList.add(dmRqtShare);
                            }
                        }
                    }
                }
            }
            system.debug('*$*$*$*$* insertDMRequestShareList  ' + insertDMRequestShareList);
            if(!insertDMRequestShareList.isEmpty() && insertDMRequestShareList != null)
            {
                DMLManagerService.InsertAsSystem(insertDMRequestShareList);
            }
        }
        else{
            list<DM_Request__Share> insertDMRequestShareList = new list<DM_Request__Share>();
            list<Id> userIdList = new list<Id>();
            set<Id> ownerIdSet = new set<Id>();
            set<string> dealerCompNdCodeSet = new set<string>();
            list<Group> dealerCompGroupList = new list<Group>();
            List<DM_Request__c> lDMRqt = new List<DM_Request__c>([Select id, Assigned_Dealer__r.Dealer_ND_Code__c, Actual_DM_Material1__c, Actual_DM_Material2__c, Actual_DM_Material3__c, Expected_DM_Material1__c, Expected_DM_Material2__c, Expected_DM_Material3__c from DM_Request__c where ID in :dmRequestListNew]);
            Map<ID, String> mDMRqtToDealerND = new Map<ID, String>();
            for(DM_Request__c dmRqtl : lDMRqt){
                if((Trigger.isInsert && dmRqtl.Assigned_Dealer__c != NULL) || (Trigger.isUpdate && dmRqtl.Assigned_Dealer__c != NULL && dmRqtl.Assigned_Dealer__c != dmRequestlListOld.get(dmRqtl.ID).Assigned_Dealer__c)){
                    mDMRqtToDealerND.put(dmRqtl.ID, dmRqtl.Assigned_Dealer__r.Dealer_ND_Code__c);
                }       
            }
            if(!mDMRqtToDealerND.isEmpty()){
                dealerCompGroupList = [select Id, Name from Group where Name in :mDMRqtToDealerND.values()];
                if(!dealerCompGroupList.isEmpty() && dealerCompGroupList != NULL){
                    Map<String, ID> mGroupNameToID = new Map<String, ID>();
                    for(Group grp : dealerCompGroupList){
                        mGroupNameToID.put(grp.name, grp.ID);
                    }
                    if(!mGroupNameToID.isEmpty()){
                        for(DM_Request__c dmRqst : lDMRqt){
                            DM_Request__Share dmRequestShare = new DM_Request__Share();
                            dmRequestShare.ParentID = dmRqst.ID;
                            dmRequestShare.AccessLevel = 'EDIT';
                            dmRequestShare.UserOrGroupID = mGroupNameToID.get(dmRqst.Assigned_Dealer__r.Dealer_ND_Code__c);
                            insertDMRequestShareList.add(dmRequestShare);
                            if((Trigger.isInsert && dmRqst.Actual_DM_Material1__c != NULL) || (Trigger.isUpdate && dmRqst.Actual_DM_Material1__c != NULL && dmRqst.Actual_DM_Material1__c != dmRequestlListOld.get(dmRqst.ID).Actual_DM_Material1__c))
                            addDMMaterialShareRecordToList(dmRqst.Actual_DM_Material1__c, mGroupNameToID.get(dmRqst.Assigned_Dealer__r.Dealer_ND_Code__c)); 
                            if((Trigger.isInsert && dmRqst.Actual_DM_Material2__c != NULL) || (Trigger.isUpdate && dmRqst.Actual_DM_Material2__c != NULL && dmRqst.Actual_DM_Material2__c != dmRequestlListOld.get(dmRqst.ID).Actual_DM_Material2__c))
                            addDMMaterialShareRecordToList(dmRqst.Actual_DM_Material2__c, mGroupNameToID.get(dmRqst.Assigned_Dealer__r.Dealer_ND_Code__c));
                            if((Trigger.isInsert && dmRqst.Actual_DM_Material3__c != NULL) || (Trigger.isUpdate && dmRqst.Actual_DM_Material3__c != NULL && dmRqst.Actual_DM_Material3__c != dmRequestlListOld.get(dmRqst.ID).Actual_DM_Material3__c))
                            addDMMaterialShareRecordToList(dmRqst.Actual_DM_Material3__c, mGroupNameToID.get(dmRqst.Assigned_Dealer__r.Dealer_ND_Code__c));
                            if((Trigger.isInsert && dmRqst.Expected_DM_Material1__c != NULL) || (Trigger.isUpdate && dmRqst.Expected_DM_Material1__c != NULL && dmRqst.Expected_DM_Material1__c != dmRequestlListOld.get(dmRqst.ID).Expected_DM_Material1__c))
                            addDMMaterialShareRecordToList(dmRqst.Expected_DM_Material1__c, mGroupNameToID.get(dmRqst.Assigned_Dealer__r.Dealer_ND_Code__c));
                            if((Trigger.isInsert && dmRqst.Expected_DM_Material2__c != NULL) || (Trigger.isUpdate && dmRqst.Expected_DM_Material2__c != NULL && dmRqst.Expected_DM_Material2__c != dmRequestlListOld.get(dmRqst.ID).Expected_DM_Material2__c))
                            addDMMaterialShareRecordToList(dmRqst.Expected_DM_Material2__c, mGroupNameToID.get(dmRqst.Assigned_Dealer__r.Dealer_ND_Code__c));
                            if((Trigger.isInsert && dmRqst.Expected_DM_Material3__c != NULL) || (Trigger.isUpdate && dmRqst.Expected_DM_Material3__c != NULL && dmRqst.Expected_DM_Material3__c != dmRequestlListOld.get(dmRqst.ID).Expected_DM_Material3__c))
                            addDMMaterialShareRecordToList(dmRqst.Expected_DM_Material3__c, mGroupNameToID.get(dmRqst.Assigned_Dealer__r.Dealer_ND_Code__c));
                        }
                        
                        if(insertDMRequestShareList != NULL && !insertDMRequestShareList.isEmpty()){
                            DMLManagerService.InsertAsSystem(insertDMRequestShareList);
                        }
                        if(insertDMMaterialShareList != NULL && !insertDMMaterialShareList.isEmpty()){
                            DMLManagerService.InsertAsSystem(insertDMMaterialShareList);
                        }   
                    }
                }
            }
        }
    }
    
    public static void addDMMaterialShareRecordToList(ID DMMaterialID, ID UserGroupID){
        DM_Material__Share dmMtrlShare = new DM_Material__Share();
        dmMtrlShare.ParentId = DMMaterialID;
        dmMtrlShare.AccessLevel = 'Edit';
        dmMtrlShare.UserOrGroupId = UserGroupID;
        insertDMMaterialShareList.add(dmMtrlShare);
    }
}