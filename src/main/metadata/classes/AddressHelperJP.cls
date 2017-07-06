/*
    Type:      class
    Purpose:   1.Validates SameAddressType (validateSameAddressType)
               2.update Primary_Address_Display__c field on account on update of address(updatePrimaryAddressOnAccount)
    Create By: Sriram kalluri
*/
public with sharing class AddressHelperJP {
    static User usr = [Select Id,ProfileId,Market__c, Profile.Name from User WHERE ID = : UserInfo.getUserId()];
        
       public static Id personAccRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
       public static Id comAccRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
       public static Id retPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();     
       public static Id retCompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();     
       public static Id individualAddRecordTypeId = Schema.SObjectType.Address__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();     
       public static boolean addt=true;
       
            
       /**             
        * @Description: Gives arror message if we try to enter Address with same  Address_Type__c for an account
        * @author     : sriram kalluri
        * @Date       : 12/14/2015
        * @param      : list of new addresses 
        * @return     : void
        * @see:       : AddressHelperJP
        */
            public static void validateSameAddressType(List<Address__c> triggerNew,map<id,Address__c> addressOldMap,boolean isInsert,boolean isUpdate)
            {
               set<id> accountId = new set<id>(); 
               if(IsInsert)
               {
                //get the related accountIds
                for(Address__c add:triggerNew){
                    accountId.add(add.Customer__c);
                }                    

                    for(Address__c addresList:[select Address_Type__c from Address__c where Customer__c IN:accountId]){
                        for(Address__c addType:triggerNew)
                        {
                            if(((addresList.Address_Type__c==addType.Address_Type__c)&&(addType.Address_Type__c!=null))&&(addType.MD__c=='JP')||((addType.MD__c=='KR')&& (addType.Address_Type__c=='Home' ||addType.Address_Type__c=='Business') && ((addresList.Address_Type__c==addType.Address_Type__c)&&(addType.Address_Type__c!=null))))
                            {                  
                            addType.Address_Type__c.adderror(Label.AddressType_Validation);
                            }
                        }
                
                    }
            
                }
                if(isUpdate && addt)
                {
                    for(Address__c add:triggerNew)
                    {
                        Address__c oldaddress = addressOldMap.get(add.Id);
                        if(oldaddress.Address_Type__c!= add.Address_Type__c)
                        {
                            accountId.add(add.Customer__c);
                        }
                    }
                    for(Address__c addresList:[select Address_Type__c from Address__c where Customer__c IN:accountId]){
                        for(Address__c addType:triggerNew)
                        {
                            if(((addresList.Address_Type__c==addType.Address_Type__c)&&(addType.Address_Type__c!=null))&&(addType.MD__c=='JP')||((addType.MD__c=='KR')&& (addType.Address_Type__c=='Home' ||addType.Address_Type__c=='Business') && ((addresList.Address_Type__c==addType.Address_Type__c)&&(addType.Address_Type__c!=null))))
                            {                  
                            addType.Address_Type__c.adderror(Label.AddressType_Validation);
                            }
                        }
                
                    }
                    addt=false;
                } 
            } 
      
       /**             
        * @Description: update Primary_Address_Display__c field on account on update of address
        * @author     : sriram kalluri
        * @Date       : 1/10/2016
        * @param      : list of new addresses 
        * @return     : void
        * @see:       : AddressHelperJP
        */
    
       public static void updatePrimaryAddressOnAccount(map<ID,Address__c> newMap)
    {
        list<Account> accountList = new list<Account>();
        List<Account> accList = new List<Account>();
        set<id> accids = new set<id>();
        string regexForNullValue ='null';
        string nullValue ='';
        String province;         
        String market;
        //User usr = [SELECT Id,Market__c, Profile.Name FROM User WHERE Id=:UserInfo.getUserId()] ;
        for(Address__c addr:newMap.values())
        {
            if(addr.Customer__c != null)
            {
                accids.add(addr.Customer__c);
            }
        }
        if(!accids.isempty() && accids != null)
        {
                accList = [Select Id,Primary_Address_Reference__c,Primary_Address_Reference__r.Address_Type__c from Account where Id =:accids];
        }
        system.debug('accList>>>>>' + accList);
        market = usr.Market__c;
        Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
        if(!test.isrunningtest() && usr.Profile.Name != 'IntegrationAPI')
        {
            UtilAddressTranslation.gettranslatedvalues(market);
        }
        for(Address__c addr:newMap.values())
        {
            if(addr.preferred__c == true && market == 'KR')
            {
                if(addtrmap1.containsKey(addr.Province__c))
                {
                    province = addtrmap1.get(addr.Province__c);
                }
                Account accnt = new Account(Id = addr.Customer__c);
                accnt.Primary_Address_Display__c = province+ ' ' +addr.City__c+ ' ' +addr.District__c+ ' ' +addr.Block__c+ ' ' +addr.Address_Line_1__c+ ' ' +addr.Address_Line_2__c;
                accnt.Primary_Address_Display__c = accnt.Primary_Address_Display__c.replaceAll(regexForNullValue,nullValue);
                accountList.add(accnt);
            }
            else if(market == 'JP' )
                {
                    system.debug('Enteredddd>>>>');
                    for(Account acc : accList)
                    {
                        system.debug('INsertedddd>>>>');
                        if(addr.Customer__c == acc.id && addr.Address_Type__c == acc.Primary_Address_Reference__r.Address_Type__c)
                        {
                            if(addtrmap1.containsKey(addr.Province__c))
                            {
                                province = addtrmap1.get(addr.Province__c);
                            }
                            acc.Primary_Address_Display__c = province+ ' ' +addr.City__c+ ' ' +addr.District__c+ ' ' +addr.Block__c+ ' ' +addr.Address_Line_1__c+ ' ' +addr.Address_Line_2__c;
                            acc.Primary_Address_Display__c = acc.Primary_Address_Display__c.replaceAll(regexForNullValue,nullValue);
                            accountList.add(acc);
                        }
                    }
                }
            
        }
        system.debug('accountList>>>>>' + accountList);
        if(!accountList.isEmpty()||accountList!=null)
        {
            update accountList; 
        }
    }
     /**             
        * @Description: update Account on Delete of address       
        * @Date       : 15/11/2016
        * @param      : list of old addresses 
        * @return     : void
        * @see:       : AddressHelperJP
        */
    
       public static void updateAccountonDeletion(List<Address__c> OldAddress){         
                 set<id> accountId = new set<id>();  
                 list<Account> accountList = new list<Account>();                  
                 //get the related accountIds
                 for(Address__c add:OldAddress){
                        accountId.add(add.Customer__c);
                        System.debug('Customer__c'+accountId);
                  } 
          
                 for(Account acc:[select id,Primary_Address_Reference__c,Customer_LastUpdatedDate__c from Account where id IN:accountId]){
                    acc.Customer_LastUpdatedDate__c = Datetime.now();
                    System.debug('Customer__date'+acc.Customer_LastUpdatedDate__c);
                         accountList.add(acc);
                }                  
            
                if(!accountList.isEmpty()||accountList!=null)
                {
                  update accountList; 
                }
                 
        
          }
    @Future(callout=true)
    public static void entityNotifyUpdate(string updateType,String sfdcId,string serlializedObject)
    {
        string sfdcMarketDiscriminator = 'JP';
        string orgId=UserInfo.getOrganizationId();
       
        string sfdcTypeName='Address__c';
        if(!test.isrunningtest())
            
            UtilWebService.entityUpdateNotification(orgId,sfdcId,sfdcTypeName,sfdcMarketDiscriminator,updateType,serlializedObject);
        
        System.debug('@@@ orgId'+ orgId +'@@@@@@ sfdcTypeName'+ sfdcTypeName +'@@ updateType'+updateType +'### sfdcId'+sfdcId +'$$$$$$ serlializedObject'+serlializedObject+'@@@@ sfdcMarketDiscriminator'+sfdcMarketDiscriminator);
    }
     public static void updateAccountlinks(map<ID,Address__c> newMap){        
        set<id> accountId = new set<id>();  
        list<Account_Link__c> accountList = new list<Account_Link__c>();
        list<Account_Link__c> accountList1 = new list<Account_Link__c>();
        if(usr.Profile.Name != 'IntegrationAPI'){
        for(Address__c add:newMap.values()){
           accountId.add(add.id);
        } 
        system.debug('Class' + accountId);
         string regexForNullValue ='null';
            string nullValue ='';                            
            String province;
            Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
            UtilAddressTranslation.gettranslatedvalues('JP');
            accountList = [select id,fromRole__r.Dealer_Rollout_Status__c,Retail_Address_Reference__c , Retail_Address_Type__c ,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,
                           Retail_Address_Reference__r.District__c,Retail_Address_Reference__r.Block__c,Retail_Address_Reference__r.Address_Line_1__c,
                            Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Address_Reference__r.Address_Type__c,Retail_Address_Reference__r.City__c,Retail_Address_Reference__r.Address_Line_2__c,
                            Retail_Address_Reference__r.ZipCode__c,Retail_Address_Reference__r.Province__c,Retail_Address_Reference__r.CreatedDate,Retail_Address_Reference__r.LastModifiedDate,
                            Retail_Address_CreatedDate__c,Retail_Address_LastModifiedDate__c from Account_Link__c where Retail_Address_Reference__c IN:accountId];
         system.debug('Class1' + accountList.size());
        if(accountList.size() > 0){
            for(Account_Link__c acc: accountList){   
             if(acc.fromRole__r.Dealer_Rollout_Status__c == 'Done'){                  
                acc.Retail_Address_Type__c = acc.Retail_Address_Reference__r.Address_Type__c;                       
                acc.Retail_City__c = ((acc.Retail_Address_Reference__r.City__c != null ? acc.Retail_Address_Reference__r.City__c : '')).left(17);
                acc.Retail_Distinct__c = ((acc.Retail_Address_Reference__r.District__c != null ? acc.Retail_Address_Reference__r.District__c: '') + (acc.Retail_Address_Reference__r.Block__c != null ? acc.Retail_Address_Reference__r.Block__c : '')).left(17); 
                acc.Retail_Address_Line_1__c  = (acc.Retail_Address_Reference__r.Address_Line_1__c !=null? acc.Retail_Address_Reference__r.Address_Line_1__c :'').left(17);
               acc.Retail_Address_Line_2__c =  (acc.Retail_Address_Reference__r.Address_Line_2__c !=null? acc.Retail_Address_Reference__r.Address_Line_2__c :'').left(17);
                acc.Retail_ZipCode__c = acc.Retail_Address_Reference__r.ZipCode__c;
                if(addtrmap1.containsKey(acc.Retail_Address_Reference__r.Province__c) )
                {
                    province = addtrmap1.get(acc.Retail_Address_Reference__r.Province__c);
                }                
                acc.Retail_Province__c = province ;//+ acc.Retail_Address_Reference__r.City__c + acc.Retail_Address_Reference__r.District__c + acc.Retail_Address_Reference__r.Block__c+ acc.Retail_Address_Reference__r.Address_Line_1__c + ' ' + acc.Retail_Address_Reference__r.Address_Line_2__c ;
                system.debug('Class2' + province );
                acc.Retail_Province__c  =acc.Retail_Province__c.replaceAll(regexForNullValue,nullValue);
                acc.Retail_Address_CreatedDate__c = (acc.Retail_Address_Reference__r.CreatedDate).date();
                acc.Retail_Address_LastModifiedDate__c = (acc.Retail_Address_Reference__r.LastModifiedDate).date();
                    accountList1.add(acc);
            }
          }  
        }
        if(!accountList1.isEmpty()||accountList1!=null)
            {
                update accountList1; 
            }
        }
    }
    
     /*
     This method will only work for dealer user's 
    @Description : 1.If person account is creating as Dealer profile, retail preson accountlink will created automatically.
                   2.If you enter address fileds in the person account at the time of creating then it will create address record
                   3.If address is created, then that addresss needs to populate in the retail person accountlink record which is created in step1
                   This method will update the accountlink - retail person (field - retail_address_reference__c) records when it's created based on step 1
    @Event       : After Insert
    @Jira        : SFDCJP-2057
    @created by  : Lokesh M
    @created date: Mar 31st, 2017
    */
    public static void afterInsetAddressUpdateRetailPerson(List<Address__c> addList)
    {
        //Checking the user profile is dealer 
        if(userinfo.getUserType()=='PowerPartner'){
            System.debug('AddressHelerpJp.afterInsetAddressUpdateRetailPerson method fired');
            
            Map<Id,Address__c> accIdAddIdMap = new Map<Id,Address__c>();
            List<Account> accList = new List<Account>();
            List<Account> accCompanyList = new List<Account>();
            List<Account_Link__c> updateList = new List<Account_Link__c>();
            
            for(Address__c curAdd : addList)
            {
                //Checking Market Discriminator as JP
                if(curAdd.MD__c == Label.MarketJP)
                {
                    if(curAdd.RecordTypeId == individualAddRecordTypeId && curAdd.customer__c != NULL)
                    {
                        accIdAddIdMap.put(curAdd.Customer__c,curAdd);
                    }
                }
                if(curAdd.MD__c == Label.MarketKR)
                {
                    if(curAdd.Customer__c != null)
                    {
                        accIdAddIdMap.put(curAdd.Customer__c,curAdd);
                    }
                }
            }
            System.debug('AccIdAddIdMap.key'+accIdAddIdMap.keySet());
            System.debug('AccIdAddIdMap.size'+accIdAddIdMap.size());
            if(accIdAddIdMap.size()>0){
                //Query address related accounts with 'retail person' account link record type
                accList = [SELECT Id,(SELECT Id,Retail_Address_Reference__c,Retail_Address_Type__c,Retail_ZipCode__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c  FROM Account_Links__r WHERE RecordTypeId =: retPersonRecordTypeId) FROM Account WHERE ID IN: accIdAddIdMap.keySet() AND RecordTypeId =: personAccRecordTypeId];
                accCompanyList = [SELECT Id,(SELECT Id,Retail_Address_Reference__c,Retail_Address_Type__c,Retail_ZipCode__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c  FROM Account_Links__r WHERE RecordTypeId =: retCompanyRecordTypeId) FROM Account WHERE ID IN: accIdAddIdMap.keySet() AND RecordTypeId =: comAccRecordTypeId];
                
                //Iterating accounts to check that account have only one 'retail person' account link record
                for(Account curAcc : accList){
                    System.debug('account_Link__r.size '+curAcc.Account_Links__r.size());
                    if(curAcc.Account_Links__r.size()==1){
                        for(Account_Link__c accLink : curAcc.Account_Links__r ){
                            //Checking the account retail address reference field is null to confirm this is the first time adding address
                            If(accLink.Retail_Address_Reference__c == NUll){
                                accLink.Retail_Address_Reference__c = accIdAddIdMap.get(curAcc.Id).Id;
                                accLink.Retail_Address_Type__c = accIdAddIdMap.get(curAcc.Id).Address_Type__c;
                                accLink.Retail_ZipCode__c = accIdAddIdMap.get(curAcc.Id).ZipCode__c;
                                accLink.Retail_Province__c = accIdAddIdMap.get(curAcc.Id).Province__c;
                                accLink.Retail_City__c = accIdAddIdMap.get(curAcc.Id).City__c;
                                accLink.Retail_Distinct__c = accIdAddIdMap.get(curAcc.Id).District__c;
                                accLink.Retail_Address_Line_1__c = accIdAddIdMap.get(curAcc.Id).Address_Line_1__c;
                                accLink.Retail_Address_Line_2__c = accIdAddIdMap.get(curAcc.Id).Address_Line_2__c;
                                updateList.add(accLink);
                            }
                        }
                    }
                }
                
                //Iterating accounts to check that account have only one 'retail company' account link record
                for(Account curAcc : accCompanyList){
                    System.debug('account_Link__r.size '+curAcc.Account_Links__r.size());
                    if(curAcc.Account_Links__r.size()==1){
                        for(Account_Link__c accLink : curAcc.Account_Links__r ){
                            //Checking the account retail address reference field is null to confirm this is the first time adding address
                            If(accLink.Retail_Address_Reference__c == NUll){
                                accLink.Retail_Address_Reference__c = accIdAddIdMap.get(curAcc.Id).Id;
                                accLink.Retail_Address_Type__c = accIdAddIdMap.get(curAcc.Id).Address_Type__c;
                                accLink.Retail_ZipCode__c = accIdAddIdMap.get(curAcc.Id).ZipCode__c;
                                accLink.Retail_Province__c = accIdAddIdMap.get(curAcc.Id).Province__c;
                                accLink.Retail_City__c = accIdAddIdMap.get(curAcc.Id).City__c;
                                accLink.Retail_Distinct__c = accIdAddIdMap.get(curAcc.Id).District__c;
                                accLink.Retail_Address_Line_1__c = accIdAddIdMap.get(curAcc.Id).Address_Line_1__c;
                                accLink.Retail_Address_Line_2__c = accIdAddIdMap.get(curAcc.Id).Address_Line_2__c;
                                updateList.add(accLink);
                            }
                        }
                    }
                }
            }
            if(updateList.size()>0){
                // DML statement
                Database.SaveResult[] srList = Database.update(updateList, false);
                
                // Iterate through each returned result
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully inserted account. AccountLink ID: ' + sr.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Account fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }
        }
    }
    
    
  /*    
  Added By      : venky
  Created date  : 7/4/2017
 Descrption     : This method will fire only fire for Integration User.
                 Whenever Address type is changed, update Address type in Vehicle relation  ship record.    
  Jira          : SFDCJP-2057
    Event       : After Update
   */  
    
    public static void afterUpdateVehicleRelationship(List<Address__c> addList,Map<Id,Address__c> OldMap){
        Set<Id> CustomerId=new Set<Id>();
        Set<Id> VrId=new Set<Id>();
        Set<Id> AddId=new Set<Id>();
        String regexForNullValue ='null';
        String nullValue ='';  
        List<Vehicle_Relationship__c> listVr=new List<Vehicle_Relationship__c>();
        List<Vehicle_Relationship__c> UpdateVr=new List<Vehicle_Relationship__c>();
        List<Account> listAccount=new List<Account>();
        String province;
        Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
        UtilAddressTranslation.gettranslatedvalues('JP');
            
            if(addList !=null)
        {
             for(Address__c adr:addList)
                {
                    if(adr.Address_Type__c !=null && adr.Address_Type__c  !=OldMap.get(adr.id).Address_Type__c )
                    {
                    AddId.add(adr.Id);                         
                    }
                   
                }
        }
        
        if(AddId!=null)
        {
            
            listVr=[select id,vehicle_address_picklist__c,Contact__c,vehicle_address__c from Vehicle_Relationship__c where vehicle_address__c=:AddId];
        
            
            if(listVr !=null)
          {
              for(Address__c add:addList)
              {
                  for(Vehicle_Relationship__c vr:listVr)
                  {
                      if(   add.Address_Type__c == '')
                      {
                            vr.vehicle_address_picklist__c = '';
                          UpdateVr.add(vr);
                      }
                      if(add.Address_Type__c == 'Home')
                        { 
                            if(addtrmap1.containsKey(add.Province__c))
                            {
                                province = addtrmap1.get(add.Province__c);
                            }     
                            vr.vehicle_address_picklist__c = 'Home Address' ;
                            
                            vr.Vehicle_Address_Display__c  = province + add.City__c + add.District__c +add.Block__c+ add.Address_Line_1__c + ' ' + add.Address_Line_2__c ;
                            vr.Vehicle_Address_Display__c  =vr.Vehicle_Address_Display__c.replaceAll(regexForNullValue,nullValue);
                            UpdateVr.add(vr);
                            
                        }
                       else if(add.Address_Type__c == 'Business')
                        { 
                          if(addtrmap1.containsKey(add.Province__c))
                            {
                                province = addtrmap1.get(add.Province__c);
                            } 
                            vr.vehicle_address_picklist__c = 'Work address' ;
                            
                            vr.Vehicle_Address_Display__c  = province  +add.City__c + add.District__c +add.Block__c+ add.Address_Line_1__c + ' ' + add.Address_Line_2__c ;                           
                           vr.Vehicle_Address_Display__c  =vr.Vehicle_Address_Display__c.replaceAll(regexForNullValue,nullValue);
                           UpdateVr.add(vr);
                        }
                      
                      if(add.Address_Type__c == 'Other Address 1')
                        {
                             if(addtrmap1.containsKey(add.Province__c))
                            {
                                province = addtrmap1.get(add.Province__c);
                            }  
                            vr.vehicle_address_picklist__c = 'Other Address 1';
                            
                          vr.Vehicle_Address_Display__c  = province + add.City__c + add.District__c +add.Block__c+ add.Address_Line_1__c + ' ' + add.Address_Line_2__c ;                          
                          vr.Vehicle_Address_Display__c  =vr.Vehicle_Address_Display__c.replaceAll(regexForNullValue,nullValue);
                          UpdateVr.add(vr);
                        
                        }
                        if(add.Address_Type__c == 'Other Address 2')
                        {
                          if(addtrmap1.containsKey(add.Province__c))
                            {
                                province = addtrmap1.get(add.Province__c);
                            }        
                            vr.vehicle_address_picklist__c = 'Other Address 2' ;
                            
                           vr.Vehicle_Address_Display__c  = province + add.City__c + add.District__c +add.Block__c+ add.Address_Line_1__c + ' ' + add.Address_Line_2__c ;                           
                           vr.Vehicle_Address_Display__c  =vr.Vehicle_Address_Display__c.replaceAll(regexForNullValue,nullValue);
                        UpdateVr.add(vr);
                        }
                        if(add.Address_Type__c == 'Other Address 3'){
                            if(addtrmap1.containsKey(add.Province__c))
                            {
                                province = addtrmap1.get(add.Province__c);
                            }             
                            vr.vehicle_address_picklist__c='Other Address 3';
                            
                          vr.Vehicle_Address_Display__c  = province + add.City__c + add.District__c +add.Block__c+ add.Address_Line_1__c + ' ' + add.Address_Line_2__c ;                          
                          vr.Vehicle_Address_Display__c  =vr.Vehicle_Address_Display__c.replaceAll(regexForNullValue,nullValue);
                          UpdateVr.add(vr);
                        }
                      
                  }
              }
          }
            if(UpdateVr !=null)
            {                
             Database.update(UpdateVr, false);
            }
        }
        
    }
    
}