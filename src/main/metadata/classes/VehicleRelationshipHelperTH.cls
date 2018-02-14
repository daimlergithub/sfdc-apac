/*
    Type:       Helper class on Vehicle_Relationship__c
    Purpose:   
    1. Insert Update Delete Vehicle related details
    2. Update Account Status
    3. Update Vehicle Amount
    4. Create Account Link
    5.afterInsertSharerecordsWithDealers
                
    Used By:  Mohammed Touseef Ahmed
    ---------------------------------------------------------------
    History: 
    Created: 03-06-2017
   
*/
public with sharing class VehicleRelationshipHelperTH 
{  
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
 //This method wil share Vehicle Relationship,vehicle,account records to the dealers depends on the Owner Dealer Field once record type is 'Vehicle Relationship Retail'
 //This method also will revoke access once Owner Dealer got changed
  public static void afterInsertSharerecordsWithDealers(List<Vehicle_Relationship__c> vehicleRellist,boolean isinsertcontext){
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
        for(integer i=0;i<vehicleRellist.size()&&vehicleRellist[i].recordtypeid==retailCompany_RecordTypeId &&vehicleRellist[i].md__c==System.Label.MarketTH && vehicleRellist[i].Owner_Dealer__c != null&& vehicleRellist[i].Owner_Dealer_ND_Code__c!=null;i++){
            //if user type is power partner then share only with the dealers under particular Account
            if(vehicleRellist[i].createdby.usertype=='PowerPartner'){
                String grpName='TH'+vehicleRellist[i].createdby.Dealer_ND_Code__c;
                vrseditaccesswithdealers.put(vehicleRellist[i].id,grpName);
            }
            else{
                String grpName='TH'+vehicleRellist[i].Owner_Dealer_ND_Code__c;
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
		sobj=new List<sobject>();
        //if old value is null and new value is there then share with new dealer
        for(integer i=0;i<vehicleRellist.size()&&vehicleRellist[i].recordtypeid==retailCompany_RecordTypeId&&vehicleRellist[i].md__c==System.Label.MarketTH;i++){
            String grpName='TH'+vehicleRellist[i].Owner_Dealer_ND_Code__c;
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
                         String oldGgrpName='TH'+((Vehicle_Relationship__c)trigger.oldmap.get(vehicleRellist[i].id)).Owner_Dealer_ND_Code__c;
                        vrsrevokeaccess.put(((Vehicle_Relationship__c)trigger.oldmap.get(vehicleRellist[i].id)).id,oldGgrpName);
                        if(vehicleRellist[i].Contact__c!=null){
                            accsrevokeaccess.put(((Vehicle_Relationship__c)trigger.oldmap.get(vehicleRellist[i].id)).id,oldGgrpName);
                         }
                        if(vehicleRellist[i].Vehicle_ID__c!=null){
                            vehiclerevokeaccess.put(((Vehicle_Relationship__c)trigger.oldmap.get(vehicleRellist[i].id)).id,oldGgrpName);
                        }
  
            }//if trigger.old is there and trigger.new is null then revoke vehicle,VR,Account access from dealers
            else if(trigger.oldMap!=null &&((Vehicle_Relationship__c)trigger.oldmap.get(vehicleRellist[i].id)).Owner_Dealer__c!=null&& ((Vehicle_Relationship__c)trigger.newmap.get(vehicleRellist[i].id)).Owner_Dealer__c==null){
                 String oldGrpName='TH'+((Vehicle_Relationship__c)trigger.oldmap.get(vehicleRellist[i].id)).Owner_Dealer_ND_Code__c;
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
    //accalredayhaveaccess=[select id, AccountAccessLevel, userOrgroupid from AccountShare  where Accountid IN:accs.keyset() and userOrgroupid IN: accs.values()];
   System.debug('vrs---'+vrs);
      if(vrs.size()>0){
        for(Group gp:[select id,name from Group where name IN :vrs.values()]){
            for(ID veh:vrs.keyset()){
                if(gp.name==vrs.get(veh)){
                    vehicleshare.add(new Vehicle_Relationship__Share(parentid=veh,userorgroupid=gp.id,AccessLevel='READ',RowCause = Schema.Vehicle_Relationship__Share.RowCause.Manual));
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
   /* Database.insert(vehicleshare);
    system.debug(accshare.size()+'dha**************'+accshare);
    Database.insert(accshare);
    Database.insert(vehiclestoshare);
    */
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
        Database.insert(sobj);
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
           if((string.isnotblank(vr.Car_Relation__c) ? vr.Car_Relation__c.containsIgnoreCase('Aftersales Contact Target 1') : False) || (string.isnotblank(vr.Car_Relation__c) ? vr.Car_Relation__c.containsIgnoreCase('Sales Contact Target') : False) || (string.isnotblank(vr.Car_Relation__c) ? vr.Car_Relation__c.containsIgnoreCase('Aftersales Contact Target 2') : False) && (!setIgnoredAccounts.contains(vr.Contact__c))){
                   
              if((!vr.Owner_Relation__c.equalsIgnoreCase('Same')) && (!vr.Owner_Relation__c.equalsIgnoreCase('Unknown')) && (!vr.Owner_Relation__c.equalsIgnoreCase('Others'))){  
                    VehicleIds.add(vr.Vehicle_ID__c);
                    VehicleRelationshipIds.add(vr.Id);
                    contactIdofVehicleRelationship.add(vr.Contact__c);
                }
            } 
           
            if(vr.Contact__c!=Null && vr.Validity__c.equalsIgnoreCase('Yes') && (!setIgnoredAccounts.contains(vr.Contact__c))){
                ContactIdsforValidity.add(vr.Contact__c); 
          }
        }  
         updateVehicleAmount(ContactIds);        
         createAccountLink(VehicleIds,VehicleRelationshipIds,contactIdofVehicleRelationship);        
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
                if (oldMapVR.get(vr.id).Contact__c != vr.Contact__c && oldMapVR.get(vr.id).Contact__c != null) {
                    ContactIds.add(oldMapVR.get(vr.id).Contact__c);
                }
            } 
                  
           if((string.isnotblank(vr.Car_Relation__c) ? vr.Car_Relation__c.containsIgnoreCase('Aftersales Contact Target 1') : False) || (string.isnotblank(vr.Car_Relation__c) ? vr.Car_Relation__c.containsIgnoreCase('Sales Contact Target') : False) || (string.isnotblank(vr.Car_Relation__c) ? vr.Car_Relation__c.containsIgnoreCase('Aftersales Contact Target 2') : False) && (!setIgnoredAccounts.contains(vr.Contact__c))){
                    if(oldMapVR.get(vr.id).Owner_Relation__c!=vr.Owner_Relation__c){
                        if((!vr.Owner_Relation__c.equalsIgnoreCase('Same')) && (!vr.Owner_Relation__c.equalsIgnoreCase('Unknown')) && (!vr.Owner_Relation__c.equalsIgnoreCase('Others'))){  
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
        updateVehicleAmount(ContactIds);
        createAccountLink(VehicleIds,VehicleRelationshipIds,contactIdofVehicleRelationship);            
    } 
    Public static void OnAfterDelete(List<Vehicle_Relationship__c> oldVehicleRelRecords){ 
         
        Set<Id> ContactIds=new Set<Id>();  
        Set<Id> VehicleIds=new Set<Id>();     
        IgnoredAccounts();            
        for (Vehicle_Relationship__c vr : oldVehicleRelRecords){
            if(vr.Contact__c!=Null && (vr.Start_Date__c==Null || vr.Start_Date__c<=system.today()) && vr.Validity__c.equalsIgnoreCase(System.label.Yes) && (!setIgnoredAccounts.contains(vr.Contact__c)))
            {              
                ContactIds.add(vr.Contact__c);
                if (vr.Vehicle_ID__c != null)
                VehicleIds.add(vr.Vehicle_ID__c);
            }  
        }                 
        updateVehicleAmount(ContactIds);          
    } 
    
    Public static void updateAccountstatus(Set<Id> ContactIds){
        List<Account> lstAccount=new List<Account>();
        IgnoredAccounts();                    
        for(Account acct:[Select Id,status__c from Account Where Id IN:ContactIds AND (NOT Id IN : setIgnoredAccounts) Limit 50000]){            
            acct.status__c='Customer';
            lstAccount.add(acct);
        }         
        if(!lstAccount.isEmpty())
            update lstAccount;
    }
    
    
    //  UpdateVehicleAmount
    Public static void updateVehicleAmount(Set<Id> ContactIds){                   
        Map<Id,set<Id>> mapVehRel = new Map<Id,set<Id>>(); 
        IgnoredAccounts();     
        for(vehicle_Relationship__c vr :[select id,Name,Contact__c,Vehicle_ID__c  from vehicle_Relationship__c Where Validity__c='Yes' AND End_Date__c= Null AND Contact__c IN : ContactIds AND (NOT Contact__c IN : setIgnoredAccounts) LIMIT 50000])
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
                if(setVehicleIds!=Null && setVehicleIds.size()>99){
                   acc.vehicle_amount__c=99;
                }
                else{       
                acc.vehicle_amount__c=setVehicleIds.size();
                acc.Status__c='Customer'; 
                }
                 vehicleAmountToUpdate.add(acc);
            }  
            else{
                acc.vehicle_amount__c=0;
                acc.Status__c='Prospect';   
                vehicleAmountToUpdate.add(acc);
            } 
        }    
        if(!vehicleAmountToUpdate.isEmpty())
            update vehicleAmountToUpdate;         
    }  
    
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