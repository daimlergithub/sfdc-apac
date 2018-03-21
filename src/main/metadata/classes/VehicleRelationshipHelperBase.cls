/*
    Type:       Helper class on Vehicle_Relationship__c
    Purpose:   
    1. Insert Update Delete Vehicle related details
    2. Update Account Status
    3. Update Vehicle Amount
    4. Create Account Link
                
    Used By:  Mohammed Touseef Ahmed
    ---------------------------------------------------------------
    History: 
    Created: 09-20-2017
    Modified By Honey on 17th Oct   
*/

public with sharing class VehicleRelationshipHelperBase{  
    Public String[] ignoredAccounts = new String[]{'ＭＡＹＢＡＣＨ販売店車両%','ＭＢＰＣ販売店車両%','ＳＭＡＲＴ販売店車両%','ＳＬＲ販売店車両%'};
    Public Static String[] ignoredAccount = new String[]{'ＭＡＹＢＡＣＨ販売店車両%','ＭＢＰＣ販売店車両%','ＳＭＡＲＴ販売店車両%','ＳＬＲ販売店車両%'};
    Public Static Set<Id> setIgnoredAccounts=new Set<Id>();     
    public static Id retailCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Vehicle_Relationship__c','Vehicle Relationship Retail');
    public static Id dealeraccrecid = RecordTypeAccessService.getRecordTypeId('Account','Dealer');
    public static List<sobject> sobj=new List<sobject>();
    public static List<sobject> sobjtorevokeaccess=new List<sobject>();
    public static set<string> gpnamesset=new Set<string>();
    
    Public static void IgnoredAccounts(){
        for(Account acc:[select id from Account Where Name Like :ignoredAccount]){
            setIgnoredAccounts.add(acc.Id);
        } 
    }

    /*
    * Added By: Mohammed Touseef Ahmed
    * Desc: trigger helper code for  after insert event fired and do Update vehicle amount and create Account Link.
    * Updated: September 25th, 2017
    */
    Public static void OnAfterInsert(List<Vehicle_Relationship__c> vehicleRelNewRecords){
        Set<Id> ContactIds=new Set<Id>();    
        Set<Id> contactIdofVehicleRelationship=new Set<Id>(); 
        Set<Id> VehicleIds=new Set<Id>();        
        Set<Id> VehicleRelationshipIds=new Set<Id>(); 
        set<Id> ContactIdsforValidity=new Set<Id>();
        IgnoredAccounts();        
        for (Vehicle_Relationship__c vr : vehicleRelNewRecords){               
            if(vr.Contact__c!=Null && (!setIgnoredAccounts.contains(vr.Contact__c)) && (vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && vr.End_Date__c==Null && vr.Validity__c.equalsIgnoreCase(System.label.Yes)){              
                ContactIds.add(vr.Contact__c);                          
            } 
            if(vr.Car_Relation__c==Label.Sales_Contact_Target || (string.isnotblank(vr.Car_Relation__c)?vr.Car_Relation__c.containsIgnoreCase(Label.After_Sales_Contact_Target):False) && (!setIgnoredAccounts.contains(vr.Contact__c))){
                if((!vr.Owner_Relation__c.equalsIgnoreCase(Label.Same)) && (!vr.Owner_Relation__c.equalsIgnoreCase(Label.Unknown)) && (!vr.Owner_Relation__c.equalsIgnoreCase(Label.Others))){  
                    VehicleIds.add(vr.Vehicle_ID__c);
                    VehicleRelationshipIds.add(vr.Id);
                    contactIdofVehicleRelationship.add(vr.Contact__c);
                }
            } 
            if(vr.Contact__c!=Null && vr.Validity__c.equalsIgnoreCase(Label.Yes) && (!setIgnoredAccounts.contains(vr.Contact__c))){
                ContactIdsforValidity.add(vr.Contact__c); 
            }
        }  
        updateVehicleAmount(ContactIds);        
        createAccountLink(VehicleIds,VehicleRelationshipIds,contactIdofVehicleRelationship);        
    } 
     /*
    * Added By: Asish Kumar Nanda
    * Jira: Implement Vehicle Relationship Functionality For a Company Account
    */
      
  // code for  after insert event fired and do Update vehicle amount and create Account Link.
    Public static void OnAfterInsert_company_account(List<Vehicle_Relationship__c> vehicleRelNewRecord){
        Set<Id> Company_AccountId=new Set<Id>();    
        Set<Id> Company_AccountIdofVehicleRelationship=new Set<Id>(); 
        Set<Id> VehicleIds=new Set<Id>();        
        Set<Id> VehicleRelationshipIds=new Set<Id>(); 
        set<Id> Company_AccountIdforValidity=new Set<Id>();
              
        for (Vehicle_Relationship__c vr : vehicleRelNewRecord){               
            if(vr.Company_Account__c!=Null  && (vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && vr.End_Date__c==Null && vr.Validity__c.equalsIgnoreCase(System.label.Yes)){              
                Company_AccountId.add(vr.Company_Account__c);                          
            } 
            if(vr.Car_Relation__c==Label.Sales_Contact_Target || (string.isnotblank(vr.Car_Relation__c)?vr.Car_Relation__c.containsIgnoreCase(Label.After_Sales_Contact_Target):False) ){
                if((!vr.Owner_Relation__c.equalsIgnoreCase(Label.Same)) && (!vr.Owner_Relation__c.equalsIgnoreCase(Label.Unknown)) && (!vr.Owner_Relation__c.equalsIgnoreCase(Label.Others))){  
                    VehicleIds.add(vr.Vehicle_ID__c);
                    VehicleRelationshipIds.add(vr.Id);
                    Company_AccountIdofVehicleRelationship.add(vr.Company_Account__c);
                }
            } 
            if(vr.Company_Account__c!=Null && vr.Validity__c.equalsIgnoreCase(Label.Yes)){
                Company_AccountIdforValidity.add(vr.Company_Account__c); 
            }
        }  
        updateVehicleAmount_Company(Company_AccountId);        
        createAccountLink(VehicleIds,VehicleRelationshipIds,Company_AccountIdofVehicleRelationship);        
    } 
     /*
    * Added By: Asish Kumar Nanda
    * Jira: Implement Vehicle Relationship Functionality For a Company Account
    */

// code for  after Update  event fired and do Update vehicle amount and create Account Link.

 Public static void OnAfterUpdate_Company_Account(List<Vehicle_Relationship__c> newVehicleRelRecord,Map<Id,Vehicle_Relationship__c> oldMapVR){     
        Set<Id> Company_AccountId=new Set<Id>();
        Set<Id> VehicleIds=new Set<Id>();       
        Set<Id> VehicleRelationshipIds=new Set<Id>(); 
        set<Id> Company_AccountIdforValidity=new Set<Id>();  
        Set<Id> Company_AccountIdofVehicleRelationship=new Set<Id>(); 
        for (Vehicle_Relationship__c vr : newVehicleRelRecord){
            if(vr.Company_Account__c!=Null && (vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && (vr.Validity__c.equalsIgnoreCase(System.label.Yes) || (oldMapVR.get(vr.id).Validity__c==System.label.Yes && vr.Validity__c!=System.label.Yes))){                 
                Company_AccountId.add(vr.Company_Account__c);
                if(oldMapVR.get(vr.id).Company_Account__c!=vr.Company_Account__c && string.isnotblank(oldMapVR.get(vr.id).Company_Account__c)){
                    Company_AccountId.add(oldMapVR.get(vr.id).Company_Account__c);
                }
            } 
            if(vr.Car_Relation__c==Label.Sales_Contact_Target || (string.isnotblank(vr.Car_Relation__c)?vr.Car_Relation__c.containsIgnoreCase(Label.After_Sales_Contact_Target):False)){
                if(oldMapVR.get(vr.id).Owner_Relation__c!=vr.Owner_Relation__c){
                    if((!vr.Owner_Relation__c.equalsIgnoreCase(Label.Same)) && (!vr.Owner_Relation__c.equalsIgnoreCase(Label.Unknown)) && (!vr.Owner_Relation__c.equalsIgnoreCase(Label.Others))){  
                        VehicleIds.add(vr.Vehicle_ID__c);
                        VehicleRelationshipIds.add(vr.Id);
                        Company_AccountIdofVehicleRelationship.add(vr.Company_Account__c);
                    }
                }
            }   
            if(vr.Company_Account__c!=Null && vr.Validity__c.equalsIgnoreCase(Label.Yes)){
                Company_AccountIdforValidity.add(vr.Company_Account__c); 
            }  
        }                          
        updateVehicleAmount_Company(Company_AccountId);
        createAccountLink(VehicleIds,VehicleRelationshipIds,Company_AccountIdofVehicleRelationship);            
    } 
     /*
    * Added By: Asish Kumar Nanda
    * Jira: Implement Vehicle Relationship Functionality For a Company Account
    */
// code for  after Delete  event fired and do Update vehicle amount and create Account Link.

  Public static void OnAfterDelete_Company_Account(List<Vehicle_Relationship__c> oldVehicleRelRecord){ 
        Set<Id> Company_AccountId=new Set<Id>();  
        Set<Id> VehicleIds=new Set<Id>();     
                    
        for (Vehicle_Relationship__c vr : oldVehicleRelRecord){
            if(vr.Company_Account__c!=Null && (vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && vr.Validity__c.equalsIgnoreCase(System.label.Yes)){              
                Company_AccountId.add(vr.Company_Account__c);
                VehicleIds.add(vr.Vehicle_ID__c);
            }  
        }                 
        updateVehicleAmount_Company(Company_AccountId);          
    } 
     /*
    * Added By: Asish Kumar Nanda
    * Jira: Implement Vehicle Relationship Functionality For a Company Account
    */
// code for  updating Vehicle Amount on update event.

Public static void updateVehicleAmount_Company(Set<Id> Company_AccountId){                   
        Map<Id,set<Id>> mapVehRel = new Map<Id,set<Id>>(); 
        Map<Id,set<Id>> mapVehRelAUNZ = new Map<Id,set<Id>>(); 
		
        Date todayDate = Date.today() ;  
        for(vehicle_Relationship__c vr :[select id,Name,Company_Account__c,Vehicle_ID__c  from vehicle_Relationship__c Where Validity__c='Yes' AND (End_Date__c=Null OR End_Date__c>=:todayDate) AND Company_Account__c IN : Company_AccountId AND (NOT Company_Account__c IN : setIgnoredAccounts) LIMIT 50000]){
            if(mapVehRel !=Null && mapVehRel.containsKey(vr.Company_Account__c)) { 
                set<Id> setVehicleIds=mapVehRel.get(vr.Company_Account__c);  
                setVehicleIds.add(vr.Vehicle_ID__c);              
                mapVehRel.put(vr.Company_Account__c,setVehicleIds);              
            }
            else{              
                mapVehRel.put(vr.Company_Account__c,new set<Id> {vr.Vehicle_ID__c});
            }
        }
		
		//For Australia and NewZealand to fetch active and inactive vehicles
        for(vehicle_Relationship__c vrAU :[select id,Name,Contact__c,Vehicle_ID__c  from vehicle_Relationship__c Where  Contact__c IN : ContactIds AND (NOT Contact__c IN : setIgnoredAccounts) LIMIT 50000]){
            if(mapVehRelAUNZ !=Null && mapVehRelAUNZ.containsKey(vrAU.Contact__c)) { 
                set<Id> setVehicleIdAUs=mapVehRelAUNZ.get(vrAU.Contact__c);  
                setVehicleIdAUs.add(vrAU.Vehicle_ID__c);              
                mapVehRelAUNZ.put(vrAU.Contact__c,setVehicleIdAUs);              
            }
            else{              
                mapVehRelAUNZ.put(vrAU.Contact__c,new set<Id> {vrAU.Vehicle_ID__c});
            }
        }
		
        List<Account> vehicleAmountToUpdate=new List<Account>();                
        for(Account acc : [Select Id,Vehicle_amount__c From Account Where Id IN:Company_AccountId LIMIT 50000]){
		
		 //for AU/NZ Market refer all vehicles
            if(acc.MD__c == 'NZ' || acc.MD__c =='AU'){
                
                if(mapVehRelAUNZ.get(acc.Id)!=Null){               
                    set<Id> setVehicleAUIds=mapVehRelAUNZ.get(acc.Id);                 
                    if(setVehicleAUIds!=Null && setVehicleAUIds.size()>99){
                        acc.vehicle_amount__c=99;
                    }
                    else{       
                        acc.vehicle_amount__c=setVehicleAUIds.size();
                        acc.Status__c=Label.Customer_Cust; 
                    }
                    vehicleAmountToUpdate.add(acc);
                    }  
                else{
                    acc.vehicle_amount__c=0;
                    acc.Status__c=Label.ProspectStatus;   
                    vehicleAmountToUpdate.add(acc);
                } 
            }
			else
			{
				if(mapVehRel.get(acc.Id)!=Null){               
					set<Id> setVehicleIds=mapVehRel.get(acc.Id);                 
					if(setVehicleIds!=Null && setVehicleIds.size()>99){
						acc.vehicle_amount__c=99;
					}
					else{       
						acc.vehicle_amount__c=setVehicleIds.size();
						acc.Status__c=Label.Customer_Cust; 
					}
					vehicleAmountToUpdate.add(acc);
				}  
				else{
					acc.vehicle_amount__c=0;
					acc.Status__c=Label.ProspectStatus;   
					vehicleAmountToUpdate.add(acc);
				} 
			}
        }
        if(!vehicleAmountToUpdate.isEmpty())
            try{
                DMLManagerService.updateAsSystem(vehicleAmountToUpdate);
            }
            catch(Exception e){
                System.debug('Couldn\'t able to update the vehicle amount' + e.getMessage());
            }
    }
      /*
    * Added By: Mohammed Touseef Ahmed
    * Desc: trigger helper code for  after update event fired and do Update vehicle amount and create Account Link.
    * Updated: September 25th, 2017
    */

    Public static void OnAfterUpdate(List<Vehicle_Relationship__c> newVehicleRelRecords,Map<Id,Vehicle_Relationship__c> oldMapVR){     
        Set<Id> ContactIds=new Set<Id>();
        Set<Id> VehicleIds=new Set<Id>();       
        Set<Id> VehicleRelationshipIds=new Set<Id>(); 
        set<Id> ContactIdsforValidity=new Set<Id>();  
        Set<Id> contactIdofVehicleRelationship=new Set<Id>(); 
        IgnoredAccounts();
        for (Vehicle_Relationship__c vr : newVehicleRelRecords){
            if(vr.Contact__c!=Null  && (!setIgnoredAccounts.contains(vr.Contact__c)) && (vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && (vr.Validity__c.equalsIgnoreCase(System.label.Yes) || (oldMapVR.get(vr.id).Validity__c==System.label.Yes && vr.Validity__c!=System.label.Yes))){                 
                ContactIds.add(vr.Contact__c);
                if(oldMapVR.get(vr.id).Contact__c!=vr.Contact__c && string.isnotblank(oldMapVR.get(vr.id).Contact__c)){
                    ContactIds.add(oldMapVR.get(vr.id).Contact__c);
                }
            } 
            if(vr.Car_Relation__c==Label.Sales_Contact_Target || (string.isnotblank(vr.Car_Relation__c)?vr.Car_Relation__c.containsIgnoreCase(Label.After_Sales_Contact_Target):False) && (!setIgnoredAccounts.contains(vr.Contact__c))){
                if(oldMapVR.get(vr.id).Owner_Relation__c!=vr.Owner_Relation__c){
                    if((!vr.Owner_Relation__c.equalsIgnoreCase(Label.Same)) && (!vr.Owner_Relation__c.equalsIgnoreCase(Label.Unknown)) && (!vr.Owner_Relation__c.equalsIgnoreCase(Label.Others))){  
                        VehicleIds.add(vr.Vehicle_ID__c);
                        VehicleRelationshipIds.add(vr.Id);
                        contactIdofVehicleRelationship.add(vr.Contact__c);
                    }
                }
            }   
            if(vr.Contact__c!=Null && vr.Validity__c.equalsIgnoreCase(Label.Yes) && (!setIgnoredAccounts.contains(vr.Contact__c))){
                ContactIdsforValidity.add(vr.Contact__c); 
            }  
        }                          
        updateVehicleAmount(ContactIds);
        createAccountLink(VehicleIds,VehicleRelationshipIds,contactIdofVehicleRelationship);            
    } 

    /*
    * Added By: Mohammed Touseef Ahmed
    * Desc: trigger helper code for  after delete event fired and do Update vehicle amount.
    * Updated: September 25th, 2017
    */
    Public static void OnAfterDelete(List<Vehicle_Relationship__c> oldVehicleRelRecords){ 
        Set<Id> ContactIds=new Set<Id>();  
        Set<Id> VehicleIds=new Set<Id>();     
        IgnoredAccounts();            
        for (Vehicle_Relationship__c vr : oldVehicleRelRecords){
            if(vr.Contact__c!=Null && (vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && vr.Validity__c.equalsIgnoreCase(System.label.Yes) && (!setIgnoredAccounts.contains(vr.Contact__c))){              
                ContactIds.add(vr.Contact__c);
                VehicleIds.add(vr.Vehicle_ID__c);
            }  
        }                 
        updateVehicleAmount(ContactIds);          
    } 

    /*
    * Added By: Mohammed Touseef Ahmed
    * Desc: trigger helper code for  updating account status on update event.
    * Updated: September 25th, 2017
    */
    Public static void updateAccountstatus(Set<Id> ContactIds){
        List<Account> lstAccount=new List<Account>();
        IgnoredAccounts();                    
        for(Account acct:[Select Id,status__c from Account Where Id IN:ContactIds AND (NOT Id IN : setIgnoredAccounts) Limit 50000]){            
            acct.status__c=Label.Customer_Cust;
            lstAccount.add(acct);
        }         
        if(!lstAccount.isEmpty())
            DMLManagerService.updateAsSystem(lstAccount);
    }

    /*
    * Added By: Mohammed Touseef Ahmed
    * Desc: trigger helper code for  updating Vehicle Amount on update event.
    * Updated: September 25th, 2017
    */
    Public static void updateVehicleAmount(Set<Id> ContactIds){                   
        Map<Id,set<Id>> mapVehRel = new Map<Id,set<Id>>(); 
        IgnoredAccounts();   
        Date todayDate = Date.today() ;  
        for(vehicle_Relationship__c vr :[select id,Name,Contact__c,Vehicle_ID__c  from vehicle_Relationship__c Where Validity__c='Yes' AND (End_Date__c=Null OR End_Date__c>=:todayDate) AND Contact__c IN : ContactIds AND (NOT Contact__c IN : setIgnoredAccounts) LIMIT 50000]){
            if(mapVehRel !=Null && mapVehRel.containsKey(vr.Contact__c)) { 
                set<Id> setVehicleIds=mapVehRel.get(vr.Contact__c);  
                setVehicleIds.add(vr.Vehicle_ID__c);              
                mapVehRel.put(vr.Contact__c,setVehicleIds);              
            }
            else{              
                mapVehRel.put(vr.Contact__c,new set<Id> {vr.Vehicle_ID__c});
            }
        }
        List<Account> vehicleAmountToUpdate=new List<Account>();                
        for(Account acc : [Select Id,Vehicle_amount__c From Account Where Id IN:ContactIds AND (NOT Id IN : setIgnoredAccounts) LIMIT 50000]){
            if(mapVehRel.get(acc.Id)!=Null){               
                set<Id> setVehicleIds=mapVehRel.get(acc.Id);                 
                if(setVehicleIds!=Null && setVehicleIds.size()>99){
                    acc.vehicle_amount__c=99;
                }
                else{       
                    acc.vehicle_amount__c=setVehicleIds.size();
                    acc.Status__c=Label.Customer_Cust; 
                }
                vehicleAmountToUpdate.add(acc);
            }  
            else{
                acc.vehicle_amount__c=0;
                acc.Status__c=Label.ProspectStatus;   
                vehicleAmountToUpdate.add(acc);
            } 
        }
        if(!vehicleAmountToUpdate.isEmpty())
            try{
                DMLManagerService.updateAsSystem(vehicleAmountToUpdate);
            }
            catch(Exception e){
                System.debug('Couldn\'t able to update the vehicle amount' + e.getMessage());
            }
    }  

    /*
    * Added By: Mohammed Touseef Ahmed
    * Desc: Sub Method called from (OnAfterInsert, OnAfterUpdate) to Create an Account Link.
    * Updated: September 25th, 2017
    */  
    Public static void createAccountLink(Set<Id> VehicleIds,Set<Id> VehicleRelationshipIds,Set<Id> contactIdofVehicleRelationship){ 
        Set<Id> ContactIds=new Set<Id>();        
        Map<Id,Vehicle_Relationship__c> mapOfContact=new Map<Id,Vehicle_Relationship__c>();
        IgnoredAccounts();      
        List<Vehicle_Relationship__c> lstVehicleRelationship=[select Id,Contact__c,Owner_Relation__c,Vehicle_ID__c,Start_Date__c,End_Date__c,Car_Relation__c from Vehicle_Relationship__c Where Vehicle_ID__c IN :VehicleIds AND Car_Relation__c='Purchaser' /*AND Contact__c IN : contactIdofVehicleRelationship*/ AND (NOT Contact__c IN : setIgnoredAccounts) LIMIT 50000];
        for(Vehicle_Relationship__c  vr:lstVehicleRelationship){
            if((vr.Vehicle_ID__c!=Null && vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && (vr.End_Date__c==Null || vr.End_Date__c>=system.today())){
                mapOfContact.put(vr.Vehicle_ID__c,vr);
            }
        }      
        List<Account_Link__c> lstAccLink=new List<Account_Link__c>();
        List<Vehicle_Relationship__c> listVehicleRelationship=[Select Id,contact__c,Vehicle_ID__c,Owner_Relation__c from Vehicle_Relationship__c Where Id IN :VehicleRelationshipIds AND Contact__c IN : contactIdofVehicleRelationship AND (NOT Contact__c IN : setIgnoredAccounts) LIMIT 50000];       
        for(Vehicle_Relationship__c vr:listVehicleRelationship){       
            Account_Link__c accLink=new Account_Link__c();
            accLink.Active__c=true;
            //accLink.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
            accLink.RecordTypeId=RecordTypeAccessService.getRecordTypeId('Account_Link__c','Contact2Contact');
            if(vr.Vehicle_ID__c != null && (!mapOfContact.isEmpty()) && mapOfContact.get(vr.Vehicle_ID__c).Contact__c != null){
                accLink.fromRole__c = mapOfContact.get(vr.Vehicle_ID__c).Contact__c;
            }
            accLink.toRole__c=vr.Contact__c;           
            accLink.Role2__c=vr.Owner_Relation__c;
            if(vr.Owner_Relation__c == Label.GrandParent){
                accLink.Role__c=Label.GrandChild;
            }
            else if(vr.Owner_Relation__c == Label.Parent){
                accLink.Role__c=Label.Child;
            }
            else if(vr.Owner_Relation__c==Label.Child){
                accLink.Role__c=Label.Parent;
            }
            else if(vr.Owner_Relation__c==Label.GrandChild){
                accLink.Role__c=Label.GrandParent;
            }    
            else if(vr.Owner_Relation__c == Label.Employee){
                accLink.Role__c=Label.Manager;
            } 
            else if(vr.Owner_Relation__c == Label.Manager){
                accLink.Role__c=Label.Employee;
            } 
            else{
                accLink.Role__c=vr.Owner_Relation__c;
            } 
            lstAccLink.add(accLink);
        }
        if(!lstAccLink.isEmpty())
            DMLManagerService.insertAsSystem(lstAccLink);    
    }    
 /*Start - Added by Laqshay Arora as a part of Vehicle/Vehicle relationship management Phase 2 */   
     //This method wil share Vehicle Relationship,vehicle,account records to the dealers depends on the Owner Dealer Field once record type is 'Vehicle Relationship Retail'
 //This method also will revoke access once Owner Dealer got changed
public static void afterInsertUpdateSharerecordsWithDealers(List<Vehicle_Relationship__c> vehicleRellist,boolean isinsertcontext, String Market){
      List<Vehicle_Relationship__share> vehicleshare=new List<Vehicle_Relationship__share>();
      List<Accountshare> accshare=new List<Accountshare>();
      List<Vehicle__Share> vehiclestoshare=new List<Vehicle__share>();
      set<String> dealerNdcodesset=new set<String>();
      Map<id,String> vrs=new Map<id,String>();
      Map<id,String> accs=new Map<id,String>();
      Map<id,String> vehicl=new Map<id,String>();
      Map<id,String> vrseditaccesswithdealers=new Map<id,String>();
      Map<id,String> accseditaccesswithdealers=new Map<id,String>();
      Map<id,String> vehicleditaccesswithdealers=new Map<id,String>();
      Map<id,String> vrsrevokeaccess=new Map<id,String>();
      Map<id,String> accsrevokeaccess=new Map<id,String>();
      Map<id,String> vehiclerevokeaccess=new Map<id,String>();
     //This if part will work in After insert context
     if(isinsertcontext){
        for(integer i=0;i<vehicleRellist.size()&&vehicleRellist[i].recordtypeid==retailCompany_RecordTypeId &&vehicleRellist[i].md__c==Market && vehicleRellist[i].Owner_Dealer__c != null&& vehicleRellist[i].Owner_Dealer_ND_Code__c!=null;i++){
            //if user type is power partner then share only with the dealers under particular Account
            if(vehicleRellist[i].createdby.usertype=='PowerPartner'){
                String grpName=vehicleRellist[i].createdby.Dealer_ND_Code__c;
                vrseditaccesswithdealers.put(vehicleRellist[i].id,grpName);
            }
            else{
                String grpName=vehicleRellist[i].Owner_Dealer_ND_Code__c;
                vrs.put(vehicleRellist[i].id,grpName);
                if(vehicleRellist[i].Contact__c!=null){
                     accs.put(vehicleRellist[i].Contact__c,grpName);
                 }
                if(vehicleRellist[i].Vehicle_ID__c!=null){
                    vehicl.put(vehicleRellist[i].Vehicle_ID__c,grpName);
                }
                
            }
        }
    }
    //else part will work in after insert context
    else{
        //if old value is null and new value is there then share with new dealer
        for(integer i=0;i<vehicleRellist.size()&&vehicleRellist[i].recordtypeid==retailCompany_RecordTypeId&&vehicleRellist[i].md__c==Market;i++){
            String grpName=vehicleRellist[i].Owner_Dealer_ND_Code__c;
            if(((Vehicle_Relationship__c)trigger.newmap.get(vehicleRellist[i].id)).Owner_Dealer__c!=null&&trigger.oldmap!=null&&((Vehicle_Relationship__c)trigger.oldmap.get(vehicleRellist[i].id)).Owner_Dealer__c==null){
                vrs.put(vehicleRellist[i].id,grpName);
                if(vehicleRellist[i].Contact__c!=null){
                     accs.put(vehicleRellist[i].Contact__c,grpName);
                 }
                if(vehicleRellist[i].Vehicle_ID__c!=null){
                    vehicl.put(vehicleRellist[i].Vehicle_ID__c,grpName);
                }
            }
            //if old dealer is not same as new dealer then revoke the access from the old dealer and give the access to the new dealer
             else if(((Vehicle_Relationship__c)trigger.newmap.get(vehicleRellist[i].id)).Owner_Dealer__c!=null
                         &&trigger.oldMap!=null &&((Vehicle_Relationship__c)trigger.oldMap.get(vehicleRellist[i].id)).Owner_Dealer__c!=null&&
                        ((Vehicle_Relationship__c)trigger.newmap.get(vehicleRellist[i].id)).Owner_Dealer__c!=((Vehicle_Relationship__c)trigger.oldmap.get(vehicleRellist[i].id)).Owner_Dealer__c
                       ){
                        vrs.put(vehicleRellist[i].id,grpName);
                        if(vehicleRellist[i].Contact__c!=null){
                            accs.put(vehicleRellist[i].Contact__c,grpName);
                         }
                        if(vehicleRellist[i].Vehicle_ID__c!=null){
                             vehicl.put(vehicleRellist[i].Vehicle_ID__c,grpName);
                            }
                         String oldGgrpName=((Vehicle_Relationship__c)trigger.oldmap.get(vehicleRellist[i].id)).Owner_Dealer_ND_Code__c;
                        vrsrevokeaccess.put(((Vehicle_Relationship__c)trigger.oldmap.get(vehicleRellist[i].id)).id,oldGgrpName);
                        if(vehicleRellist[i].Contact__c!=null){
                            accsrevokeaccess.put(((Vehicle_Relationship__c)trigger.oldmap.get(vehicleRellist[i].id)).id,oldGgrpName);
                         }
                        if(vehicleRellist[i].Vehicle_ID__c!=null){
                            vehiclerevokeaccess.put(((Vehicle_Relationship__c)trigger.oldmap.get(vehicleRellist[i].id)).id,oldGgrpName);
                        }
  
            }//if trigger.old is there and trigger.new is null then revoke vehicle,VR,Account access from dealers
            else if(trigger.oldMap!=null &&((Vehicle_Relationship__c)trigger.oldmap.get(vehicleRellist[i].id)).Owner_Dealer__c!=null&& ((Vehicle_Relationship__c)trigger.newmap.get(vehicleRellist[i].id)).Owner_Dealer__c==null){
                 String oldGrpName=((Vehicle_Relationship__c)trigger.oldmap.get(vehicleRellist[i].id)).Owner_Dealer_ND_Code__c;
                 vrsrevokeaccess.put(((Vehicle_Relationship__c)trigger.oldmap.get(vehicleRellist[i].id)).id,oldGrpName);
                 if(vehicleRellist[i].Contact__c!=null){
                    accsrevokeaccess.put(((Vehicle_Relationship__c)trigger.oldmap.get(vehicleRellist[i].id)).Contact__c,oldGrpName);
                 }
                if(vehicleRellist[i].Vehicle_ID__c!=null){
                    vehiclerevokeaccess.put(((Vehicle_Relationship__c)trigger.oldmap.get(vehicleRellist[i].id)).Vehicle_ID__c,oldGrpName);
                }
            }
            
        }
    }
    Map<id,AccountShare> accalredayhaveaccess=new Map<id,AccountShare>([select id, AccountAccessLevel, userOrgroupid from AccountShare  where Accountid IN:accs.keyset() and userOrgroupid IN: accs.values()]);
    if(vrs.size()>0){
        for(Group gp:[select id,name from Group where name IN :vrs.values()]){
            for(ID veh:vrs.keyset()){
                if(gp.name==vrs.get(veh)){
                    vehicleshare.add(new Vehicle_Relationship__Share(parentid=veh,userorgroupid=gp.id,AccessLevel='EDIT',RowCause = Schema.Vehicle_Relationship__Share.RowCause.Manual));
                }
            }
            //give edit access to the internal users
            for(Id idsh:vrseditaccesswithdealers.keyset()){
                if(gp.name==vrseditaccesswithdealers.get(idsh)){
                    vehicleshare.add(new Vehicle_Relationship__Share(parentid=idsh,userorgroupid=gp.id,AccessLevel='EDIT',RowCause = Schema.Vehicle_Relationship__Share.RowCause.Manual));
                }
            }
            for(ID ac:accs.keyset()){
                if(gp.name==accs.get(ac)&&!accalredayhaveaccess.containsKey(ac)){
                accshare.add(new AccountShare(Accountid=ac,AccountAccessLevel='READ',OpportunityAccessLevel='None',CaseAccessLevel='None',UserOrGroupId=gp.id,RowCause=Schema.Accountshare.RowCause.Manual));
            }
            }
            for(ID ve:vehicl.keyset()){
                if(gp.name==vehicl.get(ve)){
                vehiclestoshare.add(new Vehicle__share(parentid=ve,AccessLevel='READ',UserOrGroupId=gp.id,RowCause=Schema.Vehicle__share.RowCause.Manual));
            }
            }
            
        }
    }
    if(vehicleshare.size()>0){
        sobj.addall((List<sObject>)(vehicleshare));//vehicle relationships
    }
    if(accshare.size()>0){
        sobj.addAll((List<sObject>)(accshare));
    }
    if(vehiclestoshare.size()>0){
        sobj.addall((List<sObject>)(vehiclestoshare));
    }
    if(sobj.size()>0){
        try{
            database.upsert(sobj,false);
        }
        catch(Exception e){
            System.debug('Failed while upserting share records '+e.getMessage());
        }
    }
    gpnamesset.addall(vrsrevokeaccess.values());
    gpnamesset.addall(accsrevokeaccess.values());
    //gpnamesset.addall(vehiclerevokeaccess.values());
    if(gpnamesset.size()>0){
        List<group> gp=[select id from group where name in:gpnamesset ];
        sobjtorevokeaccess.addall((List<Sobject>)([select id from Vehicle_relationship__share where parentid  IN :vrsrevokeaccess.keyset() and Userorgroupid IN :gp]));
        sobjtorevokeaccess.addall((List<Sobject>)([select id from Accountshare where accountid IN :accsrevokeaccess.keyset() and Userorgroupid IN : gp]));
        //sobjtorevokeaccess.addall((List<Sobject>)([select id from Vehicle__share where parentid IN :vehiclerevokeaccess.keyset() and Userorgroupid IN :gp]));
        //Database.delete([select id from Vehicle_relationship__share where parentid IN :vrsrevokeaccess.keyset() and Userorgroupid IN:gp /*:vrsrevokeaccess.values()*/ ]);
       //Database.delete([select id from Accountshare where accountid IN :accsrevokeaccess.keyset() and Userorgroupid IN : gp/*accsrevokeaccess.values()*/ ]);
        //Database.delete([select id from Vehicle__share where parentid IN :vehiclerevokeaccess.keyset() and Userorgroupid IN :gp/*vehiclerevokeaccess.values()*/ ]);
       Database.delete(sobjtorevokeaccess);
    }
  }
  /*End - Added by Laqshay Arora as a part of Vehicle/Vehicle relationship management Phase 2 */  
}