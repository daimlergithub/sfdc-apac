public with sharing class VehicleRelationshipHelperJP 
{
    List<Vehicle_Relationship__c> vehicle_relationship = new List<Vehicle_Relationship__c>();
    Map<Id, Set<Vehicle_Relationship__c>> accountVR_Map = new Map<Id, Set<Vehicle_Relationship__c>>();
    Map<Id, Set<Vehicle_Relationship__c>> existingAaccountVR_Map = new Map<Id, Set<Vehicle_Relationship__c>>();
    Set<Vehicle_Relationship__c> tempVR = new Set<Vehicle_Relationship__c>();
    Set<Id> accountIds = new Set<Id>();
    
    public void validateOverlappingVehicleRelationship(List<Vehicle_Relationship__c> vehicleRel){       
        for (Vehicle_Relationship__c vr : vehicleRel){
            system.debug('VR Contact :' +vr.Contact__c);
            tempVR = accountVR_Map.get(vr.Contact__c);
            if (tempVR == null){
                accountVR_Map.put(vr.Contact__c, new Set<Vehicle_Relationship__c>{vr});
            }else{
                tempVR.add(vr); 
            }
        }        
        system.debug('Account VR Map :' +accountVR_Map);        
        accountIds = accountVR_Map.keySet();
        system.debug('Account Ids...' +accountIds);
        
        vehicle_relationship = [Select Id, Contact__c, Start_Date__c, End_Date__c From Vehicle_Relationship__c Where Contact__c IN : accountIds];
        for (Vehicle_Relationship__c vr : vehicle_relationship){
            system.debug('VR Contact :' +vr.Contact__c);
            tempVR = existingAaccountVR_Map.get(vr.Contact__c);
            if (tempVR == null){
                existingAaccountVR_Map.put(vr.Contact__c, new Set<Vehicle_Relationship__c>{vr});
            }else{
                tempVR.add(vr); 
            }
        }
        system.debug('Account VR Map :' +existingAaccountVR_Map);
        for (Id acId : accountIds){
            Set<Vehicle_Relationship__c> VR_new = accountVR_Map.get(acId);
            Set<Vehicle_Relationship__c> VR_existing = existingAaccountVR_Map.get(acId);
            if ((VR_new != null && !VR_new.isEmpty()) && (VR_existing != null &&!VR_existing.isEmpty())){
                for (Vehicle_Relationship__c vrN : VR_new){
                    for (Vehicle_Relationship__c vrE : VR_existing){
                        if (vrN.Start_Date__c == vrE.Start_Date__c && vrN.End_Date__c == vrE.End_Date__c){
                            vrN.addError(label.Vehicle_Relationship_overlap);
                        }
                    }
                }
            }
        }
        
    }
    Public static void OnAfterInsert(List<Vehicle_Relationship__c> vehicleRelNewRecords){
        Set<Id> ContactIds=new Set<Id>();     
        Set<Id> VehicleIds=new Set<Id>();        
        Set<Id> VehicleRelationshipIds=new Set<Id>(); 
        set<Id> ContactIdsforValidity=new Set<Id>();  
        
        for (Vehicle_Relationship__c vr : vehicleRelNewRecords){
            if(vr.Contact__c!=Null && (vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && (vr.End_Date__c==Null || vr.End_Date__c>=system.today()) && vr.Validity__c.equalsIgnoreCase(System.label.Yes))
            {              
                ContactIds.add(vr.Contact__c);                          
            } 
            if(vr.Car_Relation__c=='Sales Contact Target' || vr.Car_Relation__c=='Aftersales Contact Target 1'|| vr.Car_Relation__c=='Aftersales Contact Target 2'){
                if(vr.Owner_Relation__c!='Same' || vr.Owner_Relation__c!='Unknown' || vr.Owner_Relation__c=='Others'){
                    VehicleIds.add(vr.Vehicle_ID__c);
                    VehicleRelationshipIds.add(vr.Id);
                }
            } 
            if(vr.Contact__c!=Null && vr.Validity__c.equalsIgnoreCase('Yes')){
                ContactIdsforValidity.add(vr.Contact__c); 
            }
        }  
        updateVehicleAmount(ContactIds); 
        createAccountLink(VehicleIds,VehicleRelationshipIds);
        updateAccountstatus(ContactIdsforValidity);
    } 
    
    Public static void OnAfterUpdate(List<Vehicle_Relationship__c> newVehicleRelRecords,Map<Id,Vehicle_Relationship__c> oldMapVR){     
        Set<Id> ContactIds=new Set<Id>();
        Set<Id> VehicleIds=new Set<Id>();       
        Set<Id> VehicleRelationshipIds=new Set<Id>(); 
        set<Id> ContactIdsforValidity=new Set<Id>();  
        
        for (Vehicle_Relationship__c vr : newVehicleRelRecords){
            if(vr.Contact__c!=Null  && (vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && (vr.End_Date__c==Null || vr.End_Date__c>=system.today()) && (vr.Validity__c.equalsIgnoreCase(System.label.Yes) || (oldMapVR.get(vr.id).Validity__c==System.label.Yes && vr.Validity__c!=System.label.Yes)))
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
        createAccountLink(VehicleIds,VehicleRelationshipIds);    
        updateAccountstatus(ContactIdsforValidity);   
    } 
    Public static void OnAfterDelete(List<Vehicle_Relationship__c> oldVehicleRelRecords){ 
        system.debug('oldVehicleRelRecords>>>>>>'+oldVehicleRelRecords);      
        Set<Id> ContactIds=new Set<Id>();  
        Set<Id> VehicleIds=new Set<Id>();  
        set<Id> ContactIdsforValidity=new Set<Id>();  
        
        for (Vehicle_Relationship__c vr : oldVehicleRelRecords){
            if(vr.Contact__c!=Null && (vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && (vr.End_Date__c==Null || vr.End_Date__c>=system.today()) && vr.Validity__c.equalsIgnoreCase(System.label.Yes))
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
        for(Account acct:[Select Id,status__c from Account Where Id IN:ContactIds]){            
            acct.status__c='Customer';
            lstAccount.add(acct);
        }         
        if(!lstAccount.isEmpty())
            update lstAccount;
    }
    
    
    //  UpdateVehicleAmount
    Public static void updateVehicleAmount(Set<Id> ContactIds){     
        system.debug('ContactIds>>>>'+ContactIds);      
        Map<Id,set<Id>> mapVehRel = new Map<Id,set<Id>>(); 
        for(vehicle_Relationship__c vr :[select id,Name,Contact__c,Vehicle_ID__c  from vehicle_Relationship__c Where Validity__c='Yes'])
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
        // List<Account> accRecords = [Select Id, Vehicle_amount__c From Account Where Id IN:ContactIds];        
        List<Account> vehicleAmountToUpdate=new List<Account>();
        system.debug('IN:ContactIds'+ContactIds);         
        for(Account acc : [Select Id,Vehicle_amount__c From Account Where Id IN:ContactIds]){
            if(mapVehRel.get(acc.Id)!=Null){               
                set<Id> setVehicleIds=mapVehRel.get(acc.Id); 
                system.debug('setVehicleIds.size()>>>>>'+setVehicleIds.size());           
                acc.vehicle_amount__c=setVehicleIds.size(); 
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
    Public static void createAccountLink(Set<Id> VehicleIds,Set<Id> VehicleRelationshipIds){ 
        Set<Id> ContactIds=new Set<Id>();        
        Map<Id,Vehicle_Relationship__c> mapOfContact=new Map<Id,Vehicle_Relationship__c>();
        for(Vehicle_Relationship__c  vr:[select Id,Contact__c,Owner_Relation__c,Vehicle_ID__c,Start_Date__c,End_Date__c,Car_Relation__c from Vehicle_Relationship__c Where Vehicle_ID__c IN :VehicleIds AND Car_Relation__c='Purchaser']){
            if((vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && (vr.End_Date__c==Null || vr.End_Date__c>=system.today())){
                mapOfContact.put(vr.Vehicle_ID__c,vr);
            }
        }
        List<Account_Link__c> lstAccLink=new List<Account_Link__c>();
        for(Vehicle_Relationship__c vr:[Select Id,contact__c,Vehicle_ID__c,Owner_Relation__c from Vehicle_Relationship__c Where Id IN :VehicleRelationshipIds]){       
            Account_Link__c accLink=new Account_Link__c();
            accLink.Active__c=true;
            accLink.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
            if(mapOfContact.get(vr.Vehicle_ID__c).Contact__c != null) 
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