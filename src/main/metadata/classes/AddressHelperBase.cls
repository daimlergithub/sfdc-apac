/*
    Type:      class
    Purpose:   1.Validates SameAddressType (validateSameAddressType)
               2.update Primary_Address_Display__c field on account on update of address(updatePrimaryAddressOnAccount)
    Create By: Honey
*/
public without sharing class AddressHelperBase {

	public static Id accPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account');
    public static Id accCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Company');
    public static Id dealer_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Dealer');
    public static Id retailPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c','Retail Person');
    public static Id retailCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c','Retail Company');
	
    // @Description: Updates Primary Address related details on account once Preferred__c is checked.
    public static void updateAddressOnAccount(list<Address__c> listNewAddress){           
        Set<Id> AccIdSet = new Set<Id>();
        map<Id,Account> updateAccntMap = new map<Id,Account>();
        list<Account> updateAccntList = new list<Account>();
		List<Account> accList= new List<account>();
        for(Address__c addr : listNewAddress){
            if(addr.preferred__c){
                if(string.isnotblank(addr.Customer__c)) AccIdSet.add(addr.Customer__c);
				if(string.isnotblank(addr.Customer__c)) acclist.add(new account(id=addr.Customer__c));
				}
        } 
        if(AccIdSet!=null && !AccIdSet.isEmpty()){
           // List<Account> accList = [select id,Primary_Address__c,Primary_Address_Reference__c from Account where id in : AccIdSet Limit 10];     
            if(accList!=null && !accList.isEmpty()){
                for(Account acc : accList){  
                    for(Address__c addr : listNewAddress){
                        if(acc.Id==addr.Customer__c){
                            if(addr.Address_Line_1__c!=null && addr.Address_Line_1__c!='')
                                acc.Primary_Address__c = addr.Address_Line_1__c;
                            if(addr.Address_Line_2__c!=null && addr.Address_Line_2__c!='')  
                                acc.Primary_Address__c +=' '+ addr.Address_Line_2__c;
							 if(addr.Address_Line_3__c!=null && addr.Address_Line_3__c!='')  
                                acc.Primary_Address__c +=' '+ addr.Address_Line_3__c;
                            if(addr.District__c!=null && addr.District__c!='')
                                acc.Primary_Address__c +=' '+ addr.District__c;
                            if(addr.Province__c!=null && addr.Province__c!='')
                                acc.Primary_Address__c +=' '+ addr.Province__c;
                            if(addr.Country__c!=null && addr.Country__c!='')
                                acc.Primary_Address__c +=' '+ addr.Country__c;
                            if(addr.ZipCode__c!=null && addr.ZipCode__c!='')
                                acc.Primary_Address__c +=' '+ addr.ZipCode__c;                            
								acc.Primary_Address_Display__c=acc.Primary_Address__c;	
								acc.Primary_Address_Reference__c= addr.id;
                            updateAccntMap.put(acc.Id, acc);
                        }
                    } 
                    if(updateAccntMap.containsKey(acc.Id) && acc.Id != null){
                        updateAccntList.add(updateAccntMap.get(acc.Id));
                    }
                }                 
            }
        }
        if(updateAccntList != null && !updateAccntList.isEmpty()){
            DMLManagerService.updateAsSystem(updateAccntList);  
            //update updateAccntList;
        }
    } 

    //@Description: Gives arror message if we try to enter Address with same  Address_Type__c for an account
    public static void validateSameAddressType(List<Address__c> triggerNew,map<id,Address__c> addressOldMap,boolean isInsert,boolean isUpdate, string Market){                
        set<id> accountId = new set<id>(); 
        if(IsInsert){                
            //get the related accountIds
            for(Address__c add:triggerNew){
                accountId.add(add.Customer__c);
            }                   
            for(Address__c addresList:[select Address_Type__c from Address__c where Customer__c IN:accountId]){
                for(Address__c addType:triggerNew){
                    if(
                        (addType.MD__c==Market)&& 
                        (addType.Address_Type__c=='Home' ||addType.Address_Type__c=='Business') && 
                        (addresList.Address_Type__c==addType.Address_Type__c)
                    ){                   
                        addType.Address_Type__c.adderror(Label.AddressType_Validation);                               
                    }
                }
            }
        }
        if(isUpdate){
            for(Address__c add:triggerNew){                 
                Address__c oldaddress = addressOldMap.get(add.Id);                     
                if(oldaddress.Address_Type__c!= add.Address_Type__c){
                    accountId.add(add.Customer__c);                         
                }
            }
            for(Address__c addresList:[select Address_Type__c from Address__c where Customer__c IN:accountId]){
                for(Address__c addType:triggerNew){
                    if((addType.MD__c==market)&& (addType.Address_Type__c=='Home' ||addType.Address_Type__c=='Business') && 
                    ((addresList.Address_Type__c==addType.Address_Type__c)&&(addType.Address_Type__c!=null))){                                           
                        addType.Address_Type__c.adderror(Label.AddressType_Validation);
                    }
                }                
            }
        } 
    } 

    //@Description: update Primary_Address_Display__c field on account on update of address
    public static void updatePrimaryAddressOnAccount(map<ID,Address__c> newMap){
        set<id> accountId = new set<id>();  
        Map<id,Account> accountList = new Map<id,Account>();
		Map<id,id> PreferredMap= new Map<id,id>();
        //get the related accountIds
        for(Address__c add:newMap.values()){
            accountId.add(add.Customer__c);
			if(add.preferred__c) PreferredMap.put(add.customer__c,add.id);
        } 
        for(Account acc:[select id,Primary_Address_Reference__c,Primary_Address_Display__c,Primary_Address__c from Account where id IN:accountId]){
            if(((acc.Primary_Address_Reference__c!=null)&&(newMap.containsKey(acc.Primary_Address_Reference__c))) || PreferredMap.containsKey(acc.id)){
                if(PreferredMap.containsKey(acc.id)?true : newMap.get(acc.Primary_Address_Reference__c).Customer__c==acc.id){
                    Address__c addr = PreferredMap.containsKey(acc.id)?  newMap.get(PreferredMap.get(acc.id)):newMap.get(acc.Primary_Address_Reference__c);
                    //acc.Primary_Address_Display__c=add.ZipCode__c+add.Province__c+add.City__c+add.District__c+add.Block__c+add.Address_Line_1__c+add.Address_Line_2__c+add.Address_Line_3__c;
					//acc.Primary_Address__c=acc.Primary_Address_Display__c
							if(addr.Address_Line_1__c!=null && addr.Address_Line_1__c!='')
                                acc.Primary_Address__c = addr.Address_Line_1__c;
                            if(addr.Address_Line_2__c!=null && addr.Address_Line_2__c!='')  
                                acc.Primary_Address__c +=' '+ addr.Address_Line_2__c;
							if(addr.Address_Line_3__c!=null && addr.Address_Line_3__c!='')  
                                acc.Primary_Address__c +=' '+ addr.Address_Line_3__c;
                            if(addr.District__c!=null && addr.District__c!='')
                                acc.Primary_Address__c +=' '+ addr.District__c;
                            if(addr.Province__c!=null && addr.Province__c!='')
                                acc.Primary_Address__c +=' '+ addr.Province__c;
                            if(addr.Country__c!=null && addr.Country__c!='')
                                acc.Primary_Address__c +=' '+ addr.Country__c;
                            if(addr.ZipCode__c!=null && addr.ZipCode__c!='')
                                acc.Primary_Address__c +=' '+ addr.ZipCode__c;                            
								acc.Primary_Address_Display__c=acc.Primary_Address__c;	
								acc.Primary_Address_Reference__c=addr.id;
							accountList.put(acc.id,acc);
                }
            }
			
        } 
		
		
        if(!accountList.isEmpty()||accountList!=null){
            DMLManagerService.updateAsSystem(accountList.values());  
            //update accountList; 
        }
    }

    // @Description: update Account on Delete of address       
    public static void updateAccountonDeletion(List<Address__c> OldAddress){         
        set<id> accountId = new set<id>();  
        list<Account> accountList = new list<Account>();                  
        //get the related accountIds
        for(Address__c add:OldAddress){
            accountId.add(add.Customer__c);
        } 
        for(Account acc:[select id,Primary_Address_Reference__c,Customer_LastUpdatedDate__c from Account where id IN:accountId]){
            acc.Customer_LastUpdatedDate__c = Datetime.now();
            accountList.add(acc);
        }                  
        if(!accountList.isEmpty()||accountList!=null){
            DMLManagerService.updateAsSystem(accountList);  
            //update accountList; 
        }
    }

    //@Description: update Account on delete/insert/update of address       
    public static void updateAddressCDM(List<Address__c> Address, string MarketDiscriminator, string updateType){         
        set<id> accountId = new set<id>();  
        list<Account> accountList = new list<Account>();                  
        //get the related accountIds
        for(Address__c add:Address){
            accountId.add(add.Customer__c);                       
        } 
        if(accountId.size()>0){
            for(Account acc:[select id,recordtypeid from Account where id IN:accountId]){
                accountList.add(acc);
            } 
            try{
                set<ID> accids=new set<ID>();
                for(Account accrec:accountlist){
					if(accrec.RecordTypeID==accPerson_RecordTypeId || accrec.RecordTypeID==accCompany_RecordTypeId){
						accids.add(accrec.id);
					}
                } 
				if (accids.size()>0){				
					CDMInformatica_Services.createCustomerCDM(accids,MarketDiscriminator,updateType);
				}
            }Catch(exception e){
                CustomLogUtil.CustomLoggingEntry('Error Occured' + e.getmessage() +'-- '+e.getlinenumber());
            }
        }
    }
    
    /* Data Migration Explicit Fix - Santosh Mohanty */
        public static void updatemarket(List<Address__c> addList){        
            
                   for(Address__c addr : addList){
                       if(addr.Market__c =='' || addr.Market__c==NULL){
                         addr.Market__c=addr.MD__c;
                      }  
                  }       
        }
		
	 public static void updateAddressRetailCopies(Map<id,Address__c> newMap, string MarketDiscriminator){         
        Map<id,id> PreferredMap= new Map<id,id>();
        for(Address__c add:newMap.values()){            
			if(!add.preferred__c) PreferredMap.put(add.customer__c,add.id);
        }  
        if (PreferredMap.size()>0){
			List<account_Link__c> UpdateRetailCopy= new List<Account_Link__c>();
			for(account_Link__c al: [select id,Retail_Address_Type__c,Retail_Address_Reference__c,Retail_City__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,
			Retail_Address_Line_3__c,Retail_Province__c,Retail_Distinct__c,Retail_ZipCode__c,Retail_Address_CreatedDate__c,Retail_Address_LastModifiedDate__c
			from Account_Link__c where Retail_Address_Reference__c in :PreferredMap.values()]){
				   al.Retail_Address_Type__c = newMap.get(al.Retail_Address_Reference__c).Address_Type__c;
                    al.Retail_Province__c =(newMap.get(al.Retail_Address_Reference__c).Province__c !=null ?(newMap.get(al.Retail_Address_Reference__c).Province__c): '') ;
                    al.Retail_City__c = (newMap.get(al.Retail_Address_Reference__c).District__c != null ? newMap.get(al.Retail_Address_Reference__c).District__c:'').left(35);
                    al.Retail_Distinct__c = ((newMap.get(al.Retail_Address_Reference__c).District__c!=null ? newMap.get(al.Retail_Address_Reference__c).District__c : '')+' '+(newMap.get(al.Retail_Address_Reference__c).Block__c!= null ?newMap.get(al.Retail_Address_Reference__c).Block__c : '')).left(35);
                    al.Retail_Address_Line_1__c = ((newMap.get(al.Retail_Address_Reference__c).Address_Line_1__c)!=null?newMap.get(al.Retail_Address_Reference__c).Address_Line_1__c:'').left(35);
                    al.Retail_Address_Line_2__c = ((newMap.get(al.Retail_Address_Reference__c).Address_Line_2__c)!=null?newMap.get(al.Retail_Address_Reference__c).Address_Line_2__c:'').left(35);
                    al.Retail_Address_Line_3__c = ((newMap.get(al.Retail_Address_Reference__c).Address_Line_3__c)!=null?newMap.get(al.Retail_Address_Reference__c).Address_Line_3__c:'').left(35);
                    al.Retail_ZipCode__c = (newMap.get(al.Retail_Address_Reference__c).ZipCode__c!=null ? newMap.get(al.Retail_Address_Reference__c).ZipCode__c : '' );
                    al.Retail_Address_CreatedDate__c = Date.ValueOf(newMap.get(al.Retail_Address_Reference__c).CreatedDate);
                    al.Retail_Address_LastModifiedDate__c = Date.ValueOf(newMap.get(al.Retail_Address_Reference__c).LastModifiedDate);
                
				UpdateRetailCopy.add(al);
			}
			DMLManagerService.updateAsSystem(UpdateRetailCopy);  
		}
    }
}