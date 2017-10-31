public with Sharing class cSendVehicletoSPOConfirmationJP {

public  Vehicle_Relationship__c VehRel{get;set;}
public Account acc {get;set;}
public Account_Link__c alc  {get;set;}
public string MarketDiscriminator{get;set;}
public string CustomerId{get;set;}
public string Organisationid {get;set;}
public string UserProfile {get; set;}
public string DealerId{get; set;}
public string Response{get; set;}
public set<Id> asetId {get; set;}
public Static Id vehId {get; set;}
public Static Id accId {get; set;}

    public cSendVehicletoSPOConfirmationJP (){
    
        string VehRelid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        system.debug('*************'+VehRelid);
        //SPONotificationJP CallSPO = new SPONotificationJP();
        // getting ids of account clicked and vehicle id 
        accId = ApexPages.currentPage().getParameters().get('accountId');
         vehId = ApexPages.currentPage().getParameters().get('vehicleid');
        
        system.debug('++++++++++++++++++'+accId );
        system.debug('+++++++++++++++++'+vehId );
             
        
        // quering to display all fields in format according to the requirement
        
        VehRel = [SELECT Id,Name,OwnerId,Registration_Number__c,Vehicle_ID__c,New_Used__c,Vehicle_ID__r.UsVIN__c,Vehicle_ID__r.FirstRegistrationDate__c,MD__c,Registration_Date__c,MOT_Owner_Name__c,MOT_Owner_Address__c,MOT_USER_NAME__c,MOT_User_Address__c, Contact__c,Contact__r.Id, Contact__r.Name
                                    FROM Vehicle_Relationship__c
                                     WHERE Vehicle_ID__c =:VehId AND Car_Relation__c = 'Purchaser' AND End_Date__c = null  ];
               system.debug('++++++++++++++'+VehRel); 
          if(accId != null){     
          acc = [SELECT Id,Name From Account Where id =:accId ]; 
          alc = [select id,Name From Account_Link__c where system__c ='UCID' AND Primary__c = true And toRole__c =:accId AND RecordType.Name IN('Individual Customer External Link') ]; 
          } else {
          
          acc = [SELECT Id,Name From Account where id =:VehRel.Contact__r.Id];
          alc = [select id,Name From Account_Link__c where system__c ='UCID' AND Primary__c = true And toRole__c =:VehRel.Contact__r.Id AND RecordType.Name IN('Individual Customer External Link') ];
          
          
          
          }                          
          system.debug('++++++++++++'+acc);
          system.debug('++++++++++++'+alc);
        MarketDiscriminator = VehRel.MD__c;
        //MarketDiscriminator = 'JP';
        CustomerId = VehRel.Contact__r.Id;
        //CustomerId = '001p00000042AN0AAM';
        Organisationid = UserInfo.getOrganizationId();
        //Organisationid = '00Dp00000000eeVEAQ';
       // Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
       // String UserProfile = p.name;
                
       // if(UserProfile=='Dealer Community User' || UserProfile=='Dealer Delegate Admin')
        //{                         
        //    DealerId = UserInfo.getUserId();
        //}
        
        /*else
        {
        DealerId = '001p00000036R54AAE'; 
        }*/
        
        
       
     // sendtoSPO();
   } 
   
   
       public Static pagereference backButton()
            {
            vehId = ApexPages.currentPage().getParameters().get('vehicleid');
            Pagereference pg = new Pagereference('/apex/SendVehicleInformationtoSPOJP');
            pg.getParameters().put('id',VehId);
            pg.setRedirect(true);
            return pg ;
            
            }                        
                                               
     public  Void sendtoSPO(){
     
        // updating fields 
        
        vehId = ApexPages.currentPage().getParameters().get('vehicleid');
        accId = ApexPages.currentPage().getParameters().get('accountId');
        Map<Id,Account> accList = New Map<Id,Account>();
         Id userId = userinfo.getuserid();
         User u = [SELECT Id,Name,Dealer_ND_Code__c FROM User WHERE Id =:userId];
        set<Id> asetId = New set<Id>();
        system.debug('+++++++++++++++++'+vehId );
     list<Vehicle_Relationship__c> VehRelUpdated = new list<Vehicle_Relationship__c>();
         // updating a fields of a vehicle relation record who is a purchaser 
         list<Vehicle_Relationship__c> VehRellist = [SELECT Id,Name,OwnerId,Vehicle_ID__c,Car_Relation__c, Contact__c,Contractor__c,New_Used__c,Warranty_Apply_Status__c,UsedWarranty_Apply_Status__c,UsedWarranty_Apply_NDCode__c,Warranty_Apply_NDCode__c FROM Vehicle_Relationship__c where Vehicle_ID__c =:vehId AND Car_Relation__c = 'Purchaser'AND End_Date__c = null];         
         system.debug('+++++++++++++++++'+vehId );
         system.debug('++++++++++++++'+ VehRellist);  
         for(Vehicle_Relationship__c Ve: VehRellist  ){
                 //asetId.add(ve.Contact__c);
            //system.debug('++++++++++++++'+ asetId);     
                  If(accId != null){
             Ve.Contractor__c = accId;
             } else {
             Ve.Contractor__c = Ve.Contact__c;
             }
         if(Ve.New_Used__c == 'New'){
        
         
         Ve.Warranty_Apply_Status__c = 'To be Sent';
         Ve.Warranty_Apply_Date__c = System.today();
         Ve.Warranty_Apply_User__c = userinfo.getuserid();
             Ve.Warranty_Apply_NDCode__c = u.Dealer_ND_Code__c;
         
         }
         if(Ve.New_Used__c == 'Used'){
             
             Ve.Warranty_Apply_Status__c = 'To be Sent';
             Ve.UsedWarranty_Apply_Status__c = 'To be Sent';
             Ve.UsedWarranty_Apply_Date__c = System.today();
             Ve.Warranty_Apply_Date__c = System.today();
             Ve.Warranty_Apply_User__c = userinfo.getuserid();
             Ve.UsedWarranty_Apply_User__c = userinfo.getuserid();
              ve.UsedWarranty_Apply_NDCode__c = u.Dealer_ND_Code__c; 
             
         }
         
            
        VehRelUpdated.add(Ve); 
         
         }
         
         
         list<Vehicle_Relationship__c> VehRelTwo = [SELECT Id,Vehicle_ID__c, Contact__c,Contact__r.Id FROM Vehicle_Relationship__c where Vehicle_ID__c =:vehId AND End_Date__c = null];
         for(Vehicle_Relationship__c Va: VehRelTwo  ){
                 asetId.add(va.Contact__r.Id);
            system.debug('++++++++++++++'+ asetId); 
            system.debug('++++++++++++++'+ VehRelTwo );

            
            }

    system.debug('++++++++++++++'+VehRelUpdated); 
      
      List<Account> abc = New List<Account>();
      abc = [Select id ,Warranty_Apply_Status__c,Data_Source__c,Allow_Data_Sharing2__c From Account Where Id =:asetId AND RecordType.Name IN('Person Account')];
     system.debug('++++++++++++++'+abc); 
     
     For(Account acc : abc ){
     
        acc.Warranty_Apply_Status__c = 'To be Sent';
     accList.put(acc.id,acc);
      if(Acc.Allow_Data_Sharing2__c =='No' && Acc.Data_Source__c=='Dealer Outlet')
    {
    acc.Data_Source__c='Service Program';
    acc.Allow_Data_Sharing2__c='Yes';
    accList.put(acc.id,acc);
    }
     }
     
     
      List<Account> abcone = New List<Account>();
     
    if(accId != null){
       abcone  = [SELECT Id,Name,Warranty_Apply_Status__c,Data_Source__c,Allow_Data_Sharing2__c From Account Where id =:accId ]; 
    For(Account ac : abcone ){
     
        ac.Warranty_Apply_Status__c = 'To be Sent';
     accList.put(ac.id,ac);
     if(Ac.Allow_Data_Sharing2__c =='No' && Ac.Data_Source__c=='Dealer Outlet')
    {
    ac.Data_Source__c='Service Program';
    ac.Allow_Data_Sharing2__c='Yes';
    accList.put(ac.id,ac);
    }
     } 
     }else 
     {
     
     
     } 
    
    
    update VehRelUpdated;
    update accList.Values();
    //update accListone ;
     }             
  }