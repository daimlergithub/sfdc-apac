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
        for(vehicle_Relationship__c vr :[select id,Name,Contact__c,Vehicle_ID__c  from vehicle_Relationship__c Where Validity__c='Yes' AND End_Date__c=Null AND Contact__c IN : ContactIds AND (NOT Contact__c IN : setIgnoredAccounts) LIMIT 50000]){
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
            DMLManagerService.updateAsSystem(vehicleAmountToUpdate);
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
}