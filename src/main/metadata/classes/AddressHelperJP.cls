/*
    Type:      class
    Purpose:   1.Validates SameAddressType (validateSameAddressType)
               2.update Primary_Address_Display__c field on account on update of address(updatePrimaryAddressOnAccount)
    Create By: Sriram kalluri
*/
public with sharing class AddressHelperJP {
       
            
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
                if(isUpdate)
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
        string regexForNullValue ='null';
        string nullValue ='';
        String province;         
        String market;
        User usr = [SELECT Id,Market__c, Profile.Name FROM User WHERE Id=:UserInfo.getUserId()] ;
    	market = usr.Market__c;
        Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
		if(!test.isrunningtest() && usr.Profile.Name != 'IntegrationAPI')
        {
			UtilAddressTranslation.gettranslatedvalues(market);
		}
        for(Address__c addr:newMap.values())
        {
        	if(addr.preferred__c == true)
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
        }
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