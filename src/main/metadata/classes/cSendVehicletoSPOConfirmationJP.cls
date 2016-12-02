public with Sharing class cSendVehicletoSPOConfirmationJP {

public Vehicle_Relationship__c VehRel{get;set;}

public string MarketDiscriminator{get;set;}
public string CustomerId{get;set;}
public string Organisationid {get;set;}
public string UserProfile {get; set;}
public string DealerId{get; set;}
public string Response{get; set;}

    public cSendVehicletoSPOConfirmationJP (){
    
        string VehRelid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        system.debug('*************'+VehRelid);
        //SPONotificationJP CallSPO = new SPONotificationJP();
             
        VehRel = [SELECT Id,Name,OwnerId,Vehicle_ID__c, Contact__c,Contact__r.Id, Contact__r.Name,MD__c
                                        FROM Vehicle_Relationship__c 
                                        where Id=:VehRelid];
               system.debug('++++++++++++++'+VehRel); 
               
                                       
          
        MarketDiscriminator = VehRel.MD__c;
        //MarketDiscriminator = 'JP';
        CustomerId = VehRel.Contact__r.Id;
        //CustomerId = '001p00000042AN0AAM';
        Organisationid = UserInfo.getOrganizationId();
        //Organisationid = '00Dp00000000eeVEAQ';
        Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
        String UserProfile = p.name;
                
        if(UserProfile=='Dealer Community User' || UserProfile=='Dealer Delegate Admin')
        {                         
            DealerId = UserInfo.getUserId();
        }
        
        /*else
        {
        DealerId = '001p00000036R54AAE'; 
        }*/
        
        
       
      sendtoSPO();
   }                             
                                               
     public string sendtoSPO(){
     
         crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationPort CallSPO = new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationPort();
         //cSPOCustomernotification1.SFDCNotificationPort CallSPO = new cSPOCustomernotification1.SFDCNotificationPort();
         
         //CallSPO.SPOCustomerNotification(Organisationid,MarketDiscriminator,CustomerId,DealerId);
     
         Response = CallSPO.SPOCustomerNotification(Organisationid,MarketDiscriminator,CustomerId,DealerId);
         system.debug('ResponseComing---->'+Response); 
     
     return Null;
    
     }             
  
}