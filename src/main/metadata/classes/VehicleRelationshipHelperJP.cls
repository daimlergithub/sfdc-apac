/*
Modification: Changes related to SFDCJP-1270.VR Sharing Rule.
Auther : Venky
Date : 2017-02-1
Description : Updated  afterUpdateEvent,afterInsertEvent, createPersonOrCompanyAccountSharing methods.
------------------------------------------------------------------------------------------------------
Modification: commenting updateVechileAmount method related to SFDCJP-1599.
modified by : lokesh m
Date : 2017-02-24
Description : Vehicle_amount__c in account object should not be update from vehicleRelationship tigger.
*/

public with sharing class VehicleRelationshipHelperJP 
{  
    Public String[] ignoredAccounts = new String[]{'ＭＡＹＢＡＣＨ販売店車両%','ＭＢＰＣ販売店車両%','ＳＭＡＲＴ販売店車両%','ＳＬＲ販売店車両%'};
    Public Static String[] ignoredAccount = new String[]{'ＭＡＹＢＡＣＨ販売店車両%','ＭＢＰＣ販売店車両%','ＳＭＡＲＴ販売店車両%','ＳＬＲ販売店車両%'};
    Public Static Set<Id> setIgnoredAccounts=new Set<Id>();     
        
    Public static void IgnoredAccounts(){
    for(Account acc:[select id from Account Where Name Like :ignoredAccount]){
                setIgnoredAccounts.add(acc.Id);
            } 
     }
    Public void validateOverlappingVehicleRelationshiponInsert(List<Vehicle_Relationship__c> vehicleRel){       
       Set<Id> accountIds = new Set<Id>();
       List<Vehicle_Relationship__c> vehicle_relationship = new List<Vehicle_Relationship__c>(); 
       Set<date> setStartDate=new Set<date>();
       Set<date> setEndDate=new Set<date>();       
       Set<Id> ignoredAcct=new Set<Id>();         
          for(Account acc:[select id from Account Where Name Like :ignoredAccounts ]){
                ignoredAcct.add(acc.Id);
            }
          for (Vehicle_Relationship__c vr : VehicleRel){
              /* if(vr.Contact__c!=Null){
               accountIds.add(vr.Contact__c);  
               }*/
               system.debug('>>>>'+vr.Contact__c);
               if(vr.Contact__c!=Null && (!ignoredAcct.contains(vr.Contact__c))){
                   accountIds.add(vr.Contact__c);  
               } 
          }                  
        if(!accountIds.isEmpty()){    
          system.debug('accountIds>>>>>'+accountIds);  
          List<Vehicle_Relationship__c> vrlist=new List<Vehicle_Relationship__c>();                  
          vrlist=[Select Id, Contact__c, Start_Date__c, End_Date__c From Vehicle_Relationship__c Where Contact__c IN : accountIds AND Contact__c !=Null AND Start_Date__c!=Null AND End_Date__c!=Null Limit 50000];
          system.debug(vrlist.size());
          for (Vehicle_Relationship__c vr :vrlist){
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
         Set<Id> ignoredAcct=new Set<Id>();
         
          for(Account acc:[select id from Account Where Name Like :ignoredAccounts ]){
                ignoredAcct.add(acc.Id);
            }
          for (Vehicle_Relationship__c vr : newVehicleRel){
              /* if(vr.Contact__c!=Null){
               accountIds.add(vr.Contact__c);  
               }*/
               system.debug('>>>>'+vr.Contact__c);
               if(vr.Contact__c!=Null && (!ignoredAcct.contains(vr.Contact__c))){
                   accountIds.add(vr.Contact__c);  
               } 
          }          
        if(!accountIds.isEmpty()){  
             system.debug('accountIds>>>>>'+accountIds);  
          List<Vehicle_Relationship__c> vrlist=new List<Vehicle_Relationship__c>();        
          vrlist=[Select Id, Contact__c, Start_Date__c, End_Date__c From Vehicle_Relationship__c Where Contact__c IN : accountIds AND Contact__c !=Null AND Start_Date__c!=Null AND End_Date__c!=Null Limit 50000];
          system.debug(vrlist.size());
          for (Vehicle_Relationship__c vr :vrlist){
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
        IgnoredAccounts();
                
        for (Vehicle_Relationship__c vr : vehicleRelNewRecords){
            if(vr.Contact__c!=Null && (!setIgnoredAccounts.contains(vr.Contact__c)) && (vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && vr.End_Date__c==Null && vr.Validity__c.equalsIgnoreCase(System.label.Yes))
            {              
                ContactIds.add(vr.Contact__c);                          
            } 
           if((vr.Car_Relation__c=='Sales Contact Target' || vr.Car_Relation__c=='Aftersales Contact Target 1'|| vr.Car_Relation__c=='Aftersales Contact Target 2') && (!setIgnoredAccounts.contains(vr.Contact__c))){
                   
              if(vr.Owner_Relation__c != NULL && (!vr.Owner_Relation__c.equals('Same')) && (!vr.Owner_Relation__c.equals('Unknown')) && (!vr.Owner_Relation__c.equals('Others'))){  
                    VehicleIds.add(vr.Vehicle_ID__c);
                    VehicleRelationshipIds.add(vr.Id);
                    contactIdofVehicleRelationship.add(vr.Contact__c);
                }
            } 
           
            if(vr.Contact__c!=Null && vr.Validity__c.equalsIgnoreCase('Yes') && (!setIgnoredAccounts.contains(vr.Contact__c))){
                ContactIdsforValidity.add(vr.Contact__c); 
          }
        }  
         //this line is commenting as per SFDCJP-1599 ---- updateVehicleAmount(ContactIds);        
         createAccountLink(VehicleIds,VehicleRelationshipIds,contactIdofVehicleRelationship);
         updateAccountstatus(ContactIdsforValidity);
    } 
    
    Public static void OnAfterUpdate(List<Vehicle_Relationship__c> newVehicleRelRecords,Map<Id,Vehicle_Relationship__c> oldMapVR){     
        Set<Id> ContactIds=new Set<Id>();
        Set<Id> VehicleIds=new Set<Id>();       
        Set<Id> VehicleRelationshipIds=new Set<Id>(); 
        set<Id> ContactIdsforValidity=new Set<Id>();  
        Set<Id> contactIdofVehicleRelationship=new Set<Id>(); 
        IgnoredAccounts();
        for (Vehicle_Relationship__c vr : newVehicleRelRecords){
            if(vr.Contact__c!=Null  && (!setIgnoredAccounts.contains(vr.Contact__c)) && (vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && (vr.Validity__c.equalsIgnoreCase(System.label.Yes) || (oldMapVR.get(vr.id).Validity__c==System.label.Yes && vr.Validity__c!=System.label.Yes)))
            {                 
                ContactIds.add(vr.Contact__c);
                if(oldMapVR.get(vr.id).Contact__c!=vr.Contact__c){
                    ContactIds.add(oldMapVR.get(vr.id).Contact__c);
                }    
                system.debug('ContactIds>>>>'+ContactIds);                    
            } 
                  
           if((vr.Car_Relation__c=='Sales Contact Target' || vr.Car_Relation__c=='Aftersales Contact Target 1'|| vr.Car_Relation__c=='Aftersales Contact Target 2') && (!setIgnoredAccounts.contains(vr.Contact__c))){
                    if(oldMapVR.get(vr.id).Owner_Relation__c!=vr.Owner_Relation__c){
                        if((!vr.Owner_Relation__c.equals('Same')) && (!vr.Owner_Relation__c.equals('Unknown')) && (!vr.Owner_Relation__c.equals('Others'))){  
                           VehicleIds.add(vr.Vehicle_ID__c);
                            VehicleRelationshipIds.add(vr.Id);
                            contactIdofVehicleRelationship.add(vr.Contact__c);
                        }
                    }
                }   
           
            if(vr.Contact__c!=Null && vr.Validity__c.equalsIgnoreCase('Yes') && (!setIgnoredAccounts.contains(vr.Contact__c))){
               ContactIdsforValidity.add(vr.Contact__c); 
            }  
        }                          
        //this line is commenting as per SFDCJP-1599 ---- updateVehicleAmount(ContactIds);
        createAccountLink(VehicleIds,VehicleRelationshipIds,contactIdofVehicleRelationship);    
        updateAccountstatus(ContactIdsforValidity);   
    } 
    Public static void OnAfterDelete(List<Vehicle_Relationship__c> oldVehicleRelRecords){ 
         
        Set<Id> ContactIds=new Set<Id>();  
        Set<Id> VehicleIds=new Set<Id>();     
        IgnoredAccounts();            
        for (Vehicle_Relationship__c vr : oldVehicleRelRecords){
            if(vr.Contact__c!=Null && (vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && vr.Validity__c.equalsIgnoreCase(System.label.Yes) && (!setIgnoredAccounts.contains(vr.Contact__c)))
            {              
                ContactIds.add(vr.Contact__c);
                VehicleIds.add(vr.Vehicle_ID__c);
            }  
        }                 
         //this line is commenting as per SFDCJP-1599 ---- updateVehicleAmount(ContactIds);           
    } 
    
    Public static void updateAccountstatus(Set<Id> ContactIds){
        List<Account> lstAccount=new List<Account>();
        IgnoredAccounts();                    
        for(Account acct:[Select Id,status__c from Account Where Id IN:ContactIds AND status__c!='Customer' AND (NOT Id IN : setIgnoredAccounts) Limit 50000]){            
            acct.status__c='Customer';
            lstAccount.add(acct);
        }         
        if(!lstAccount.isEmpty())
         //   update lstAccount;
            
 Database.update (lstAccount, false);
    }
    
    
    //  UpdateVehicleAmount
    /*   this method is commenting as per SFDCJP-1599
       Cause : SFDCJP-1599
       Description : As discussed, we have agreement with MBJ that by disabling this functionality,
                       Vehicle Amount field will no longer have meaningful value, from UI or EP interface,
                       to MBJ or to Dealer user, in every which case. MBJ agreed that for time being we basically disable
                       the functionality to count the amount of vehicle in its entirity to all the cases,
                       until we enable it again at some point in future.
       Commented by : Lokesh M
       
    Public static void updateVehicleAmount(Set<Id> ContactIds){           
        system.debug('ContactIds>>>>'+ContactIds.size());      
        Map<Id,set<Id>> mapVehRel = new Map<Id,set<Id>>(); 
        IgnoredAccounts();     
        for(vehicle_Relationship__c vr :[select id,Name,Contact__c,Vehicle_ID__c  from vehicle_Relationship__c Where Validity__c='Yes' AND End_Date__c=:Null AND Contact__c IN : ContactIds AND (NOT Contact__c IN : setIgnoredAccounts) LIMIT 50000])
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
                   
        List<Account> vehicleAmountToUpdate=new List<Account>();                
        for(Account acc : [Select Id,Vehicle_amount__c From Account Where Id IN:ContactIds AND (NOT Id IN : setIgnoredAccounts) LIMIT 50000]){
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
        if(!vehicleAmountToUpdate.isEmpty())
            update vehicleAmountToUpdate;         
    }  
        */
        
        
    //Create Account Link   
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
        system.debug('<<<<<<<'+listVehicleRelationship);
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
            }try{
       
          if(!lstAccLink.isEmpty())  
        insert lstAccLink;      
   }
   catch(exception e){
   system.debug(e.getmessage()); }
    }
    
    /*Update Portal Apply Status on create/update of the VR for MyMercedes User
    Japan 2.0 SFDCJP-629
    Created by Sivaram
    */
    public static void updatePortalApplyStatus(List<Vehicle_RelationShip__C> vehRelList, Map<Id,Vehicle_Relationship__c> oldMap){
        try{
            List<Vehicle_Relationship__c> filterVehRelList = new List<Vehicle_Relationship__c>();
            List<Id> accountId = new List<Id>();
            List<Vehicle_relationship__c> updateVehRelList = new List<Vehicle_Relationship__c>();
            if(oldMap.isEmpty()){
                for(Vehicle_Relationship__c curVehRel : vehRelList){
                    if(curVehRel.Start_Date__c != NULL && curVehRel.End_Date__c == NULL && curVehRel.Car_Relation__c != NULL && curVehRel.Contact__c != NULL){
                        accountId.add(curVehRel.contact__c);
                        filterVehRelList.add(curVehRel);
                    }
                }
            }
            else{
                for(Vehicle_Relationship__c curVehRel : vehRelList){
                   Vehicle_Relationship__c oldRec  = oldMap.get(curVehRel.Id);
                    if(oldRec.Start_Date__c != NULL && oldRec.End_Date__c == NULL){
                        if(curVehRel.Car_Relation__c != oldRec.Car_Relation__c || curVehRel.Contact__c != oldRec.Contact__c || curVehRel.Registration_Number__c != oldRec.Registration_Number__c){
                            accountId.add(curVehRel.contact__c);
                            filterVehRelList.add(curVehRel); 
                        }
                    }
                }
            }
            List<Account_Link__C> accLinkList = [SELECT Id,System__c,toRole__C FROM Account_Link__c WHERE toRole__C IN: accountId AND System__C = 'My Mercedes'];
            for(Vehicle_Relationship__c vr : filterVehRelList){
                for(Account_Link__c al : accLInkList){
                    if(vr.Contact__c == al.toRole__C){
                        vr.Portal_Apply_Status__c = 'To be Sent';
                        updateVehRelList.add(vr);
                        System.debug('Updating Record Id ===> '+vr.Id);
                    }
                }
            }   
        }
        catch(Exception e){
            system.debug('Error'+e.getMessage());
            system.debug('Error'+e.getCause());
            system.debug('Error'+e.getLineNumber());             
        }
    }
    public static void updateOnVehicleRelation(List<Vehicle_RelationShip__C> veReList,Map<id,Vehicle_Relationship__c> vRoldmap,boolean isInsert,boolean isUpdate)
  {
      system.debug('@#@##@##veReList'+veReList);
      system.debug('&*&*&*&vRoldmap'+vRoldmap); 
        string regexForNullValue ='null';
        string nullValue ='';
        set<id> sid = new set<id>();
        set<id> addressids = new set<id>();
        List<Address__c> addresslist = new List<Address__c> ();   
        List<Vehicle_Relationship__c> Updatelist = new List<Vehicle_Relationship__c> ();
        List<Vehicle_Relationship__c> vrList = new List<Vehicle_Relationship__c> ();
        
      if(LeadUtil.verTrigger)
      { 
        for (Vehicle_Relationship__c ve : veReList ) 
        {
          system.debug('+++++++++++++++++++'+veReList );
                    system.debug('+++++++++++++++++++'+ve.contact__c );
          if(ve.contact__c != null  && (!setIgnoredAccounts.contains(ve.Contact__c)) && (isInsert || (isUpdate && ve.contact__c != vRoldmap.get(ve.Id).contact__c))) //&& ve.contact__c != vRoldmap.get(ve.Id).contact__c
          {
            sid.add(ve.Contact__c);
          }  
        }
        
      }
      system.debug('@@#@##@#@#@ SId'+sid);
      if(!sid.isempty() && sid != null )
      {
        vrList = [select id,contact__r.Sales_Address_Type__c,contact__r.Primary_Address_Reference__c,contact__r.Primary_Address_Display__c,contact__r.Primary_Email_Display__c,contact__r.Primary_Fax_Display__c,contact__r.Primary_Phone_Display__c,
        contact__r.Individual_Home_Phone__c,contact__r.Work_Phone__c,contact__r.Home_Phone_2__c,contact__r.FAX,contact__r.Fax2__c,contact__r.Email__c,
        contact__r.Email2__c,contact__r.Email3__c,vehicle_address__c,Vehicle_Address_Display__c,vehicle_fax__c,vehicle_mail__c,Vehicle_Phone__c,vehicle_address_picklist__c ,vehicle_fax_picklist__c,vehicle_mail_picklist__c,Vehicle_Phone_picklist__c from Vehicle_Relationship__c where Contact__c =:sid];
      }
      system.debug('@@#@##@#@#@ vrList'+vrList);
      for(Vehicle_Relationship__c vRs : vrList)
      {
        if(vRs.contact__r.Primary_Address_Reference__c != null)
        {
          addressids.add(vRs.contact__r.Primary_Address_Reference__c);
        }
      }
          LeadUtil.verTrigger = false;
                system.debug('++++++++++++++++++++'+sid);
            if(addressids != Null && !addressids.isempty())
      {
        addresslist = [Select ID,Company_Name_Native__C,Customer__c,Name,Address_Type__c,ZipCode__c,Province__c,
                       Province_Native__c,City__c,City_Native__c,District__c,District_Native__c,Block__c,Block_Native__c,
                       Address_Line_1__c,Address_Line_1_Native__c,Address_Line_2__c,Address_Line_2_Native__c,
                       Company_Name__c,Status__c,Temp_ZipCode__c,Temp_Address__c from Address__c where Id =: addressids];
      }
      
      system.debug('++++++++++++++++++'+addresslist);
      for(Vehicle_Relationship__c Vels  : vrList)
      {
        if (vels.Vehicle_Phone_picklist__c == Null)
        {
          Vels.Vehicle_Phone__c = Vels.Contact__r.Primary_Phone_Display__c;
        }
        if (Vels.Vehicle_Phone_picklist__c == 'Home phone')
        {
          vels.Vehicle_Phone__c = Vels.Contact__r.Individual_Home_Phone__c;
        } 
        else if (Vels.Vehicle_Phone_picklist__c == 'work phone')
        {
          vels.Vehicle_Phone__c = Vels.Contact__r.Work_Phone__c;
        }
        else if (vels.Vehicle_Phone_picklist__c ==  'Home Phone 2')
        {
            vels.Vehicle_Phone__c = Vels.Contact__r.Home_Phone_2__c;
        }
         
        if (vels.vehicle_fax_picklist__c == Null)
         {
          Vels.vehicle_fax__c = Vels.Contact__r.Primary_Fax_Display__c;
        }  

        if (vels.vehicle_fax_picklist__c == 'FAX')
        {
          vels.vehicle_fax__c = Vels.Contact__r.Fax;
        }
        else if (vels.vehicle_fax_picklist__c == 'Work FAX')
        {
          vels.vehicle_fax__c = Vels.Contact__r.Fax2__c;
        }
        if (vels.vehicle_mail_picklist__c == Null)
        {
          vels.vehicle_mail__c = Vels.Contact__r.Primary_Email_Display__c;
        }
        if (vels.vehicle_mail_picklist__c == 'Email Home')
        {
          vels.vehicle_mail__c =  Vels.Contact__r.Email__c;
        }
        else if (vels.vehicle_mail_picklist__c == 'Email Work')
        {
          vels.vehicle_mail__c = Vels.Contact__r.Email2__c;
        }
        else if (vels.vehicle_mail_picklist__c == 'MyMercedes Email')
        {
          vels.vehicle_mail__c = Vels.Contact__r.Email3__c;
        }
                if(!addresslist.isEmpty() && addresslist != null)
                {
                    for( Address__c add : addresslist)
                    {
                        system.debug('+++++++++++++ vels.vehicle_address_picklist__c'+vels.vehicle_address_picklist__c);
                        if( vels.vehicle_address_picklist__c == Null  || vels.vehicle_address_picklist__c == '')
                        {
                            //  vels.vehicle_address__c = acc.Sales_Address_Type__c;
                            vels.Vehicle_Address_Display__c  = Vels.Contact__r.Primary_Address_Display__c;
                            system.debug('+++++++++++++'+Vels.Contact__r.Primary_Address_Display__c);
                            system.debug('+++++++++++++ vels'+ vels);
                        }
                        //if( vels.vehicle_address_picklist__c == add.Address_Type__c){
                        if( vels.vehicle_address_picklist__c == 'Home Address' && add.Address_Type__c == 'Home')
                        {   
                            vels.vehicle_address__c = add.Id;
                            vels.Vehicle_Address_Display__c  =add.ZipCode__c +' '   +add.Province__c+' ' +add.Province_Native__c + ' '+add.City__c +' ' +add.City_Native__c+' ' +add.District__c+' ' +add.District_Native__c+' ' +add.Block__c+' '+add.Block_Native__c+' ' +add.Address_Line_1__c+' ' +add.Address_Line_1_Native__c+ ' ' + add.Address_Line_2__c+' '+add.Address_Line_2_Native__c+'  '+add.Company_Name__c+ '    '+add.Company_Name_Native__c+' ' +add.Status__c +' ' +add.Temp_ZipCode__c+' ' + add.Temp_Address__c ;
                            vels.Vehicle_Address_Display__c  =vels.Vehicle_Address_Display__c.replaceAll(regexForNullValue,nullValue);
                            
                        }
                        else if( vels.vehicle_address_picklist__c == 'Work address' && add.Address_Type__c == 'Business')
                        {
                            vels.vehicle_address__c = add.Id;
                            vels.Vehicle_Address_Display__c  =add.ZipCode__c +' '   +add.Province__c+' ' +add.Province_Native__c + ' '+add.City__c +' ' +add.City_Native__c+' ' +add.District__c+' ' +add.District_Native__c+' ' +add.Block__c+' '+add.Block_Native__c+' ' +add.Address_Line_1__c+' ' +add.Address_Line_1_Native__c+ ' ' + add.Address_Line_2__c+' '+add.Address_Line_2_Native__c+'  '+add.Company_Name__c+ '    '+add.Company_Name_Native__c+' ' +add.Status__c +' ' +add.Temp_ZipCode__c+' ' + add.Temp_Address__c ;
                            vels.Vehicle_Address_Display__c  =vels.Vehicle_Address_Display__c.replaceAll(regexForNullValue,nullValue);
                        }
                        if( vels.vehicle_address_picklist__c == 'Other Address 1' && add.Address_Type__c == 'Other Address 1')
                        {
                            vels.vehicle_address__c = add.Id;
                            vels.Vehicle_Address_Display__c  =add.ZipCode__c +' '   +add.Province__c+' ' +add.Province_Native__c + ' '+add.City__c +' ' +add.City_Native__c+' ' + add.District__c+' ' +add.District_Native__c+' ' +add.Block__c+' '+add.Block_Native__c+' ' +add.Address_Line_1__c+' ' +add.Address_Line_1_Native__c+ ' ' + add.Address_Line_2__c+' '+add.Address_Line_2_Native__c+'  '+add.Company_Name__c+ '    '+add.Company_Name_Native__c+' ' +add.Status__c +' ' +add.Temp_ZipCode__c+' ' + add.Temp_Address__c ;
                            vels.Vehicle_Address_Display__c  =vels.Vehicle_Address_Display__c.replaceAll(regexForNullValue,nullValue);
                        }
                        if( vels.vehicle_address_picklist__c == 'Other Address 2' && add.Address_Type__c == 'Other Address 2')
                        {
                            vels.vehicle_address__c = add.Id;
                            vels.Vehicle_Address_Display__c  =add.ZipCode__c +' '   +add.Province__c+' ' +add.Province_Native__c + ' '+add.City__c +' ' +add.City_Native__c+' ' +add.District__c+' ' +add.District_Native__c+' ' +add.Block__c+' '+add.Block_Native__c+' ' +add.Address_Line_1__c+' ' +add.Address_Line_1_Native__c+ ' ' + add.Address_Line_2__c+' '+add.Address_Line_2_Native__c+'  '+add.Company_Name__c+ '    '+add.Company_Name_Native__c+' ' +add.Status__c +' ' +add.Temp_ZipCode__c+' ' + add.Temp_Address__c ;
                            vels.Vehicle_Address_Display__c  =vels.Vehicle_Address_Display__c.replaceAll(regexForNullValue,nullValue);
                            vels.End_Reason__c = 'Updated EndDate';
                        }
                        if( vels.vehicle_address_picklist__c == 'Other Address 3' && add.Address_Type__c == 'Other Address 3'){
                            vels.vehicle_address__c = add.Id;
                            vels.Vehicle_Address_Display__c  =add.ZipCode__c +' '   +add.Province__c+' ' +add.Province_Native__c + ' '+add.City__c +' ' +add.City_Native__c+' ' + add.District__c+' ' +add.District_Native__c+' ' +add.Block__c+' '+add.Block_Native__c+' ' +add.Address_Line_1__c+' ' +add.Address_Line_1_Native__c+ ' ' + add.Address_Line_2__c+' '+add.Address_Line_2_Native__c+'  '+add.Company_Name__c+ '    '+add.Company_Name_Native__c+' ' +add.Status__c +' ' +add.Temp_ZipCode__c+' ' + add.Temp_Address__c ;
                            vels.Vehicle_Address_Display__c  =vels.Vehicle_Address_Display__c.replaceAll(regexForNullValue,nullValue);
                        }
                    }
                }                   
                Updatelist.add(Vels);
            }
              
                            
  // update Updatelist;
  
 Database.update(Updatelist, false);
 LeadUtil.verTrigger = false;

    }

    
    /*
    * Added By: SivaKrishna
    * Desc: Sharing code of Vehicle relationship
    * Updated: Dec 16, 2016
    */
    
    public static Id vehicleRelationship_VRRRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();
    public static Id vehicleRelationship_VRRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId();
    
    
    public static void afterInsertEvent(List<Vehicle_Relationship__c> newList){ 
    
        Map<Id, List<Id>> map_AccountIdAndListVCId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> map_AccountIdAndListVCwithVRrecordtypeId = new Map<Id, List<Id>>();
        List<Vehicle_Relationship__Share> list_SharingRecord = new List<Vehicle_Relationship__Share>();
        Set<Id> currentVrId=new Set<Id>();
        
        for(Vehicle_Relationship__c vc : newList){
            if(vc.Owner_Dealer__c != null && vc.RecordTypeId == vehicleRelationship_VRRRecordTypeId){
                if(!map_AccountIdAndListVCId.containsKey(vc.Owner_Dealer__c)){
                      map_AccountIdAndListVCId.put(vc.Owner_Dealer__c, new List<Id>());
                       
                  }
                  map_AccountIdAndListVCId.get(vc.Owner_Dealer__c).add(vc.Id);
            }
            else 
                if(vc.Contact__c != null && vc.RecordTypeId == vehicleRelationship_VRRecordTypeId){
                    if(!map_AccountIdAndListVCwithVRrecordtypeId.containsKey(vc.Contact__c)){
                          map_AccountIdAndListVCwithVRrecordtypeId.put(vc.Contact__c, new List<Id>());
                         
                      }
                      map_AccountIdAndListVCwithVRrecordtypeId.get(vc.Contact__c).add(vc.Id);
                       currentVrId.add(vc.Id);
                }
        }
        
        if(map_AccountIdAndListVCId.size() > 0){
            list_SharingRecord.addAll(createDealerAccountSharing(map_AccountIdAndListVCId));
        }
          
        if(map_AccountIdAndListVCwithVRrecordtypeId.size() > 0){
            list_SharingRecord.addAll(createPersonOrCompanyAccountSharing(map_AccountIdAndListVCwithVRrecordtypeId,currentVrId));
        }
        
        if(list_SharingRecord.size() > 0){
            Database.insert(list_SharingRecord, false);
        }
        
    }
    
    
    public static void afterUpdateEvent(List<Vehicle_Relationship__c> newList, Map<Id, Vehicle_Relationship__c> oldMap){
        Set<Id> currentVrId=new Set<Id>();
        Map<Id, List<Id>> map_AccountIdAndListVCId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> map_AccountIdAndListVCwithVRrecordtypeId = new Map<Id, List<Id>>();
        List<Vehicle_Relationship__Share> list_SharingRecord = new List<Vehicle_Relationship__Share>();
        Set<Id> set_AccountId = new Set<Id>();
        List<Id> list_VehicleRelationId = new List<Id>();
        List<String> accNames=new List<String>();
        List<String> GcNames=new List<String>();
         List<Account_Link__c> ListAlk=new List<Account_Link__c>();
         Set<Id> DealerAccId=new Set<Id>();
         Set<Id> set_LinkId = new Set<Id>();
         //List<User> list_User = new List<User>();
          List<Vehicle_Relationship__Share> list_SharingDele = new List<Vehicle_Relationship__Share>();
          
        for(Vehicle_Relationship__c vc : newList){
            system.debug('+++++++++++'+vehicleRelationship_VRRRecordTypeId );
            system.debug('+++++++++++'+vehicleRelationship_VRRecordTypeId  );
            
            if(vc.Owner_Dealer__c != null && vc.RecordTypeId == vehicleRelationship_VRRRecordTypeId && vc.Owner_Dealer__c != oldMap.get(vc.Id).Owner_Dealer__c){
                if(!map_AccountIdAndListVCId.containsKey(vc.Owner_Dealer__c)){
                      map_AccountIdAndListVCId.put(vc.Owner_Dealer__c, new List<Id>());
                       
                  }
                  map_AccountIdAndListVCId.get(vc.Owner_Dealer__c).add(vc.Id);
                  currentVrId.add(vc.Id);
                  set_AccountId.add(oldMap.get(vc.Id).Owner_Dealer__c);
                  list_VehicleRelationId.add(vc.Id);
            } 
            else 
                if(vc.Contact__c != null && vc.RecordTypeId == vehicleRelationship_VRRecordTypeId  && vc.Contact__c != oldMap.get(vc.Id).Contact__c){ 
                    system.debug('+++++++++++'+'working');
                    if(!map_AccountIdAndListVCwithVRrecordtypeId.containsKey(vc.Contact__c)){
                          map_AccountIdAndListVCwithVRrecordtypeId.put(vc.Contact__c, new List<Id>());
                      }
                      if(map_AccountIdAndListVCwithVRrecordtypeId.get(vc.Contact__c)!=null)
                      {
                      map_AccountIdAndListVCwithVRrecordtypeId.get(vc.Contact__c).add(vc.Id);
                      }
                      currentVrId.add(vc.Id);
                
                set_AccountId.add(oldMap.get(vc.Id).Contact__c);
                system.debug('+++++++++++'+set_AccountId);
                list_VehicleRelationId.add(vc.Id);
                } }
        
        if(set_AccountId!=null)
        {
         
         ListAlk=[select id,fromRole__c,toRole__c from Account_Link__c where toRole__c=:set_AccountId];
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
         
           List<Group> list_User = new List<Group>( [select Id, Name, Type from Group where Name IN:accNames]);
          
          if(list_User!=null)
          {
          list_SharingDele=[SELECT Id FROM Vehicle_Relationship__Share WHERE ParentId IN:list_VehicleRelationId AND UserOrGroupId IN :list_User];
            } 
            if(list_SharingDele.size() > 0){
                 Database.delete(list_SharingDele, false);
                system.debug('+++++++++++'+list_SharingDele);
            }
       
        
        if(map_AccountIdAndListVCId.size() > 0){
            list_SharingRecord.addAll(createDealerAccountSharing(map_AccountIdAndListVCId));
        }
        
        if(map_AccountIdAndListVCwithVRrecordtypeId.size() > 0){
            list_SharingRecord.addAll(createPersonOrCompanyAccountSharing(map_AccountIdAndListVCwithVRrecordtypeId,currentVrId));
        }
        
        if(list_SharingRecord.size() > 0){
            Database.insert(list_SharingRecord, false);
        }
    }
    
    public static Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    
    // Get all the Dealer Account with Same GC Code -
    @TestVisible private static Map<Id, Set<Id>> getAllDealerAccountWithSameGCCode(Set<Id> dealerAccountIdSet) {
        
        
        List<Account> dealerAccList = [select Id, Dealer_GC_Code__c from Account where Id =: dealerAccountIdSet AND RecordTypeId =: Dealer_RecordTypeId];
        Map<String, Id> gcCodeToDealerAccIdMap = new Map<String, Id>();
        for(Account accRec : dealerAccList) {
            if(String.isNotBlank(accRec.Dealer_GC_Code__c)) {
                gcCodeToDealerAccIdMap.put(accRec.Dealer_GC_Code__c, accRec.Id);
            }
        }
        
        Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = new Map<Id, Set<Id>>();
        if(dealerAccList.size() > 0) {
            List<Account> similarGCCodeDealerAccountList = [select Id, Dealer_GC_Code__c from Account where Dealer_GC_Code__c IN: gcCodeToDealerAccIdMap.keySet()
                                                                    AND RecordTypeId =: Dealer_RecordTypeId AND Id NOT IN: gcCodeToDealerAccIdMap.values()];
            //system.assert(false, similarGCCodeDealerAccountList);
            for(Account accRec : similarGCCodeDealerAccountList) {
                if(!dealerIdToSimilarGCCodeDealerAccountIdsMap.containsKey(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c))) {
                    dealerIdToSimilarGCCodeDealerAccountIdsMap.put(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c), new Set<Id>());
                }
                dealerIdToSimilarGCCodeDealerAccountIdsMap.get(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c)).add(accRec.Id);
            }                                                       
        }
        //system.assert(false, dealerIdToSimilarGCCodeDealerAccountIdsMap);
        return dealerIdToSimilarGCCodeDealerAccountIdsMap;
    }
    
   @TestVisible private static List<Vehicle_Relationship__Share> createDealerAccountSharing(Map<Id, List<Id>> map_AccountIdAndListVCId){
        
        // START: Adding Similar GC Code related Account To Map which is sharing already.
        Set<Id> dealerAccIdSet = new Set<Id>();
        for(Id dealerAccId : map_AccountIdAndListVCId.keySet()) {
            dealerAccIdSet.add(dealerAccId);
        }
        Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = getAllDealerAccountWithSameGCCode(dealerAccIdSet);
        
        for(Id dealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.keySet()) {
            if(map_AccountIdAndListVCId.containsKey(dealerId)) {
                List<Id> vrIdList = map_AccountIdAndListVCId.get(dealerId);
                for(Id similarGCCodeDealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.get(dealerId)) {
                    map_AccountIdAndListVCId.put(similarGCCodeDealerId, vrIdList);
                }
            }
        }
        // END: Adding Similar GC Code related Account To Map which is sharing already. 
        
        // Changing Sharing from User to Public Group
        List<Account> dealerAccList = [select Name from Account where Id IN: map_AccountIdAndListVCId.keySet()];
        Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        for(Account dealerRec : dealerAccList) {
            dealerAccNameSet.add(dealerRec.Name);
            accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
        }
        
        
        List<Vehicle_Relationship__Share> list_SharingRecord = new List<Vehicle_Relationship__Share>();
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]){
            if(accNameToAccIdMap.containsKey(groupRec.Name) && map_AccountIdAndListVCId.containsKey(accNameToAccIdMap.get(groupRec.Name))){
                for(Id accountLinkId : map_AccountIdAndListVCId.get(accNameToAccIdMap.get(groupRec.Name))){
                    Vehicle_Relationship__Share vehicleRelationShare = new Vehicle_Relationship__Share();
                    vehicleRelationShare.AccessLevel = 'Read';
                    vehicleRelationShare.UserOrGroupId = groupRec.Id;
                    vehicleRelationShare.ParentId = accountLinkId;
                    vehicleRelationShare.RowCause = Schema.Vehicle_Relationship__Share.RowCause.Manual;
                    list_SharingRecord.add(vehicleRelationShare);
                }
            }
        } 
        return list_SharingRecord;
    }
    
    
    @TestVisible private static List<Vehicle_Relationship__Share> createPersonOrCompanyAccountSharing(Map<Id, List<Id>> map_AccountIdAndListVCwithVRrecordtypeId,Set<Id> currentVrId){
     
        List<Account_Link__c> ListAlk=new List<Account_Link__c>();
        Set<Id> DealerAccId=new Set<Id>();
        Set<Id> VrID=new Set<Id>();
        
        ListAlk = [select id,fromRole__c,toRole__c from Account_Link__c where toRole__c=:map_AccountIdAndListVCwithVRrecordtypeId.keySet() ];
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
        
        List<Vehicle_Relationship__Share> list_SharingRecord = new List<Vehicle_Relationship__Share>();
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]) {
            if(currentVrId != null) {
                for(Id ids:currentVrId) {
                    Vehicle_Relationship__Share vehicleRelationShare = new Vehicle_Relationship__Share();
                    vehicleRelationShare.AccessLevel = 'Edit';
                    vehicleRelationShare.UserOrGroupId = groupRec.Id; 
                    vehicleRelationShare.ParentId =ids; 
                    vehicleRelationShare.RowCause = Schema.Vehicle_Relationship__Share.RowCause.Manual;
                    list_SharingRecord.add(vehicleRelationShare);
                }
            }
        } 
        return list_SharingRecord;
    }
    
    
 public static void beforeupdateEventAddress(List<Vehicle_Relationship__c> newList,Map<Id, Vehicle_Relationship__c> oldMap){
     set<id> addressids= new set<id>();
     
     for(Vehicle_Relationship__c vc : newList){
         addressids.add(vc.vehicle_address__c);
     }
     Map<id,Address__c> addressMap = new Map<id,Address__c>([select id,HouseNumber__c,City__c,Country__c,District__c,Province__c,ZipCode__c from Address__c where id in:addressids] );
 
     for(Vehicle_Relationship__c vc : newList){
         if(addressMap !=null && addressMap.get(vc.vehicle_address__c) !=null &&vc.vehicle_address__c!=oldMap.get(vc.id).vehicle_address__c)
         {
                Address__c addr =addressMap.get(vc.vehicle_address__c);
                vc.MOT_User_Address__c='';
                if(addr.HouseNumber__c!=null)
                vc.MOT_User_Address__c=addr.HouseNumber__c+',';
                if(addr.District__c!=null)
                vc.MOT_User_Address__c=vc.MOT_User_Address__c+addr.District__c+',';
                if(addr.City__c!=null)
                vc.MOT_User_Address__c=vc.MOT_User_Address__c+addr.City__c+',';
                if(addr.Country__c!=null)
                vc.MOT_User_Address__c=vc.MOT_User_Address__c+addr.Country__c+',';
                if(addr.Province__c!=null)
                vc.MOT_User_Address__c=vc.MOT_User_Address__c+addr.Province__c+',';
                if(addr.ZipCode__c!=null)
                vc.MOT_User_Address__c=vc.MOT_User_Address__c+addr.ZipCode__c;
                
                
                
         }
     
     
     }
 }
}