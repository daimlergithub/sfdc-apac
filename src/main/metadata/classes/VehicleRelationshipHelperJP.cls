public with sharing class VehicleRelationshipHelperJP 
{
    
    Public void validateOverlappingVehicleRelationshiponInsert(List<Vehicle_Relationship__c> vehicleRel){ 
       Set<Id> accountIds = new Set<Id>();
       List<Vehicle_Relationship__c> vehicle_relationship = new List<Vehicle_Relationship__c>(); 
       Set<date> setStartDate=new Set<date>();
       Set<date> setEndDate=new Set<date>();
         for (Vehicle_Relationship__c vr : vehicleRel){
               accountIds.add(vr.Contact__c);          
          }          
        if(!accountIds.isEmpty()){    
          for (Vehicle_Relationship__c vr :[Select Id, Contact__c, Start_Date__c, End_Date__c From Vehicle_Relationship__c Where Contact__c IN : accountIds AND (Start_Date__c!=Null OR End_Date__c!=Null) Limit 50000]){
               if(vr.Start_Date__c!=Null)
               setStartDate.add(vr.Start_Date__c);
               if(vr.End_Date__c!=Null) 
               setEndDate.add(vr.End_Date__c); 
          }
         }  
        for(Vehicle_Relationship__c vr : vehicleRel){
            if(setStartDate!=Null && setEndDate!=Null){
              if(setStartDate.contains(vr.Start_Date__c) && setEndDate.contains(vr.End_Date__c)){
                  vr.addError(label.Vehicle_Relationship_overlap);
              }
            }
          }     
     }
    Public void validateOverlappingVehicleRelationshiponUpdate(List<Vehicle_Relationship__c> newVehicleRel,Map<Id,Vehicle_Relationship__c> oldVehicleRel){ 
         Set<Id> accountIds = new Set<Id>();
         List<Vehicle_Relationship__c> vehicle_relationship = new List<Vehicle_Relationship__c>(); 
         Set<date> setStartDate=new Set<date>();
         Set<date> setEndDate=new Set<date>();
          for (Vehicle_Relationship__c vr : newVehicleRel){
               accountIds.add(vr.Contact__c);          
          }          
        if(!accountIds.isEmpty()){    
          for (Vehicle_Relationship__c vr :[Select Id, Contact__c, Start_Date__c, End_Date__c From Vehicle_Relationship__c Where Contact__c IN : accountIds AND (Start_Date__c!=Null OR End_Date__c!=Null) Limit 50000]){
               if(vr.Start_Date__c!=Null)
               setStartDate.add(vr.Start_Date__c);
               if(vr.End_Date__c!=Null) 
               setEndDate.add(vr.End_Date__c); 
          }
         }
          for(Vehicle_Relationship__c vr : newVehicleRel){            
              if(setStartDate!=Null && setEndDate!=Null && setStartDate.contains(vr.Start_Date__c) && setEndDate.contains(vr.End_Date__c)){
                 if(oldVehicleRel!=Null && (vr.Start_Date__c!=oldVehicleRel.get(vr.Id).Start_Date__c || vr.End_Date__c!=oldVehicleRel.get(vr.Id).End_Date__c)){
                  vr.addError(label.Vehicle_Relationship_overlap);
              }
            }
          }
       }
    
    Public static void OnAfterInsert(List<Vehicle_Relationship__c> vehicleRelNewRecords){
        Set<Id> ContactIds=new Set<Id>();    
        Set<Id> contactIdofVehicleRelationship=new Set<Id>(); 
        Set<Id> VehicleIds=new Set<Id>();        
        Set<Id> VehicleRelationshipIds=new Set<Id>(); 
        set<Id> ContactIdsforValidity=new Set<Id>();  
        
        for (Vehicle_Relationship__c vr : vehicleRelNewRecords){
            if(vr.Contact__c!=Null && (vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && vr.End_Date__c==Null && vr.Validity__c.equalsIgnoreCase(System.label.Yes))
            {              
                ContactIds.add(vr.Contact__c);                          
            } 
            if(vr.Car_Relation__c=='Sales Contact Target' || vr.Car_Relation__c=='Aftersales Contact Target 1'|| vr.Car_Relation__c=='Aftersales Contact Target 2'){
                if(vr.Owner_Relation__c!='Same' || vr.Owner_Relation__c!='Unknown' || vr.Owner_Relation__c=='Others'){
                    VehicleIds.add(vr.Vehicle_ID__c);
                    VehicleRelationshipIds.add(vr.Id);
                    contactIdofVehicleRelationship.add(vr.Contact__c);
                }
            } 
            if(vr.Contact__c!=Null && vr.Validity__c.equalsIgnoreCase('Yes')){
                ContactIdsforValidity.add(vr.Contact__c); 
          }
        }  
         updateVehicleAmount(ContactIds);        
         createAccountLink(VehicleIds,VehicleRelationshipIds,contactIdofVehicleRelationship);
         updateAccountstatus(ContactIdsforValidity);
    } 
    
    Public static void OnAfterUpdate(List<Vehicle_Relationship__c> newVehicleRelRecords,Map<Id,Vehicle_Relationship__c> oldMapVR){     
        Set<Id> ContactIds=new Set<Id>();
        Set<Id> VehicleIds=new Set<Id>();       
        Set<Id> VehicleRelationshipIds=new Set<Id>(); 
        set<Id> ContactIdsforValidity=new Set<Id>();  
        Set<Id> contactIdofVehicleRelationship=new Set<Id>(); 
        
        for (Vehicle_Relationship__c vr : newVehicleRelRecords){
            if(vr.Contact__c!=Null  && (vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && (vr.Validity__c.equalsIgnoreCase(System.label.Yes) || (oldMapVR.get(vr.id).Validity__c==System.label.Yes && vr.Validity__c!=System.label.Yes)))
            {                 
                ContactIds.add(vr.Contact__c);
                if(oldMapVR.get(vr.id).Contact__c!=vr.Contact__c){
                    ContactIds.add(oldMapVR.get(vr.id).Contact__c);
                }                        
            } 
            system.debug('ContactIds>>>>>>>>>>>>>'+ContactIds);
            if(oldMapVR.get(vr.id).Car_Relation__c!=vr.Car_Relation__c){
                if(vr.Car_Relation__c=='Sales Contact Target' || vr.Car_Relation__c=='Aftersales Contact Target 1'|| vr.Car_Relation__c=='Aftersales Contact Target 2'){
                    if(oldMapVR.get(vr.id).Owner_Relation__c!=vr.Owner_Relation__c){
                        if(vr.Owner_Relation__c!='Same' || vr.Owner_Relation__c!='Unknown' || vr.Owner_Relation__c=='Others'){
                            VehicleIds.add(vr.Vehicle_ID__c);
                            VehicleRelationshipIds.add(vr.Id);
                            contactIdofVehicleRelationship.add(vr.Contact__c);
                        }
                    }
                }   
            } 
            if(vr.Contact__c!=Null && vr.Validity__c.equalsIgnoreCase('Yes')){
               ContactIdsforValidity.add(vr.Contact__c); 
            }  
        }         
        
        system.debug('ContactIdsAfterUpdate>>>>>>'+ContactIds);                  
        updateVehicleAmount(ContactIds);
        createAccountLink(VehicleIds,VehicleRelationshipIds,contactIdofVehicleRelationship);    
        updateAccountstatus(ContactIdsforValidity);   
    } 
    Public static void OnAfterDelete(List<Vehicle_Relationship__c> oldVehicleRelRecords){ 
        system.debug('oldVehicleRelRecords>>>>>>'+oldVehicleRelRecords);      
        Set<Id> ContactIds=new Set<Id>();  
        Set<Id> VehicleIds=new Set<Id>();  
               
        for (Vehicle_Relationship__c vr : oldVehicleRelRecords){
            if(vr.Contact__c!=Null && (vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && vr.Validity__c.equalsIgnoreCase(System.label.Yes))
            {              
                ContactIds.add(vr.Contact__c);
                VehicleIds.add(vr.Vehicle_ID__c);
            }  
        }         
        system.debug('ContactIdsAfterDelete>>>>>>'+ContactIds);         
        updateVehicleAmount(ContactIds);          
    } 
    
    Public static void updateAccountstatus(Set<Id> ContactIds){
        List<Account> lstAccount=new List<Account>();  
        for(Account acct:[Select Id,status__c from Account Where Id IN:ContactIds Limit 50000]){            
            acct.status__c='Customer';
            lstAccount.add(acct);
        }         
        if(!lstAccount.isEmpty())
            update lstAccount;
    }
    
    
    //  UpdateVehicleAmount
    Public static void updateVehicleAmount(Set<Id> ContactIds){     
        system.debug('ContactIds>>>>'+ContactIds.size());      
        Map<Id,set<Id>> mapVehRel = new Map<Id,set<Id>>(); 
        for(vehicle_Relationship__c vr :[select id,Name,Contact__c,Vehicle_ID__c  from vehicle_Relationship__c Where Validity__c='Yes' AND End_Date__c=:Null AND Contact__c IN : ContactIds Limit 50000])
        {
            if(mapVehRel !=Null && mapVehRel.containsKey(vr.Contact__c)) { 
                set<Id> setVehicleIds=mapVehRel.get(vr.Contact__c);  
                setVehicleIds.add(vr.Vehicle_ID__c);              
                mapVehRel.put(vr.Contact__c,setVehicleIds);              
            }
            else{              
                mapVehRel.put(vr.Contact__c,new set<Id> {vr.Vehicle_ID__c});
            }
        }
        system.debug('mapVehRel'+mapVehRel);            
        List<Account> vehicleAmountToUpdate=new List<Account>();
        system.debug('IN:ContactIds'+ContactIds);         
        for(Account acc : [Select Id,Vehicle_amount__c From Account Where Id IN:ContactIds]){
            if(mapVehRel.get(acc.Id)!=Null){               
                set<Id> setVehicleIds=mapVehRel.get(acc.Id); 
                system.debug('setVehicleIds.size()>>>>>'+setVehicleIds.size());    
                if(setVehicleIds!=Null && setVehicleIds.size()>99){
                   acc.vehicle_amount__c=99;
                }
                else{       
                acc.vehicle_amount__c=setVehicleIds.size(); 
                }
                 vehicleAmountToUpdate.add(acc);
            }  
            else{
                acc.vehicle_amount__c=0;   
                vehicleAmountToUpdate.add(acc);
            } 
        }   
        system.debug('vehicleAmountToUpdate>>>>>>'+vehicleAmountToUpdate);
        if(!vehicleAmountToUpdate.isEmpty())
            update vehicleAmountToUpdate;         
    }     
    //Create Account Link   
    Public static void createAccountLink(Set<Id> VehicleIds,Set<Id> VehicleRelationshipIds,Set<Id> contactIdofVehicleRelationship){ 
        Set<Id> ContactIds=new Set<Id>();        
        Map<Id,Vehicle_Relationship__c> mapOfContact=new Map<Id,Vehicle_Relationship__c>();
        List<Vehicle_Relationship__c> lstVehicleRelationship=[select Id,Contact__c,Owner_Relation__c,Vehicle_ID__c,Start_Date__c,End_Date__c,Car_Relation__c from Vehicle_Relationship__c Where Vehicle_ID__c IN :VehicleIds AND Car_Relation__c='Purchaser' AND Contact__c IN : contactIdofVehicleRelationship Limit 50000];
        for(Vehicle_Relationship__c  vr:lstVehicleRelationship){
            if((vr.Vehicle_ID__c!=Null && vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && (vr.End_Date__c==Null || vr.End_Date__c>=system.today())){
                mapOfContact.put(vr.Vehicle_ID__c,vr);
            }
        }
        List<Account_Link__c> lstAccLink=new List<Account_Link__c>();
        List<Vehicle_Relationship__c> listVehicleRelationship=[Select Id,contact__c,Vehicle_ID__c,Owner_Relation__c from Vehicle_Relationship__c Where Id IN :VehicleRelationshipIds Limit 50000];
          for(Vehicle_Relationship__c vr:listVehicleRelationship){       
                Account_Link__c accLink=new Account_Link__c();
                accLink.Active__c=true;
                accLink.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
                                 
                if(vr.Vehicle_ID__c != null && (!mapOfContact.isEmpty()) && mapOfContact.get(vr.Vehicle_ID__c).Contact__c != null) 
                {
                   accLink.fromRole__c = mapOfContact.get(vr.Vehicle_ID__c).Contact__c;
                }
                accLink.toRole__c=vr.Contact__c;           
                accLink.Role2__c=vr.Owner_Relation__c;
                
                if(vr.Owner_Relation__c=='Grand Parent'){
                    accLink.Role__c='Grand Child';
                }
                else if(vr.Owner_Relation__c=='Parent'){
                    accLink.Role__c='Child';
                }
                else if(vr.Owner_Relation__c=='Child'){
                    accLink.Role__c='Parent';
                }
                else if(vr.Owner_Relation__c=='Grand Child'){
                    accLink.Role__c='Grand Parent';
                }    
                else if(vr.Owner_Relation__c=='Employee'){
                    accLink.Role__c='Manager';
                } 
                else if(vr.Owner_Relation__c=='Manager'){
                    accLink.Role__c='Employee';
                } 
                else{
                    accLink.Role__c=vr.Owner_Relation__c;
                } 
                
                lstAccLink.add(accLink);
            }
          if(!lstAccLink.isEmpty())
            insert lstAccLink;
    }
} 