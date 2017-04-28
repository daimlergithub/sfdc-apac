Global class UtilWebservice 
{



webservice static void LeadIfnoSendToAL(String LeadId,String DealerID,String AccountLinkId)
    {  
     Account_link__c  alk=new  Account_Link__c();
    List<Account_link__c> Updatealk=new List<Account_Link__c>();
    System.debug('%^%^%^%^% AccountLinkId'+AccountLinkId);
    
    if(AccountLinkId!=null && AccountLinkId!='')
    {
    System.debug('%^%^%^%^% AccountLinkId'+AccountLinkId);
    alk=[select id,CorrelationID__c from Account_Link__c where id=:AccountLinkId limit 1];
    }
    User  Usr = [SELECT Market__c, Id FROM User WHERE Id = : UserInfo.getUserId()]; 
    String Usecase; 
    crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationPort sendport=new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationPort();
    crmasiaDaimlerApacComSfdcnotificatio.SARILeadNotificationRequestMessageType  request=new crmasiaDaimlerApacComSfdcnotificatio.SARILeadNotificationRequestMessageType ();
     crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType response=new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType();
    
      String OrganizationId = UserInfo.getOrganizationId();
      String MarketDiscriminator= Usr.Market__c;          
      sendport.SARILeadNotification(OrganizationId ,MarketDiscriminator,Usecase,LeadId,DealerId,alk.CorrelationID__c);      
      System.debug('$%$%$%$%$%$%$%$ TransactionId'+response.TransactionId); 
      System.debug('%^%%^%^%^% response'+response); 
     if(alk.CorrelationID__c!=null && alk !=null)
      {
      alk.CorrelationID__c='';
      Updatealk.add(alk);
      }
      Update  Updatealk;
       //return response;
    }
    
//(String RTCustomerId,String DealerID,String CorrelationId)
    webservice static string AccountLinkIfnoSendToAL(String RTCustomerId,String DealerID,String CorrelationId)
    {  
    System.debug('%^%%^%^%^% RTCustomerId'+RTCustomerId+'DealerID'+DealerID+'CorrelationId'+CorrelationId); 
    User  Usr = [SELECT Market__c, Id FROM User WHERE Id = : UserInfo.getUserId()]; 
        String Usecase; 
    crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationPort sendport=new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationPort();
    crmasiaDaimlerApacComSfdcnotificatio.SARICustomerNotificationRequestMessageType request=new crmasiaDaimlerApacComSfdcnotificatio.SARICustomerNotificationRequestMessageType();
     crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType response=new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType();
    
      String OrganizationId = UserInfo.getOrganizationId();
         String MarketDiscriminator= Usr.Market__c;
          String src;
          try
          {
      src=sendport.SARICustomerNotification(OrganizationId ,MarketDiscriminator,Usecase,RTCustomerId,DealerId,CorrelationId);
      }
      
      
       Catch(Exception e)
           {
          
           String erre=e.getmessage();
            String[] errMessage = erre.split('webservice.WebServiceFault');          
            String errMessaget = errMessage[0];
            String errMessageText = errMessage[1];
               
               src=errMessageText;   
          
          }
          
      System.debug('$%$%$%$%$%$%$%$ TransactionId'+src);
       
    // crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType
      System.debug('%^%%^%^%^% response'+response); 
       return src;
    }
   /* Public static crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType AccountIfnoSendToJPOS(String CustomerID,String AddressId,String DealerID)
    {  
    User  Usr = [SELECT Market__c, Id FROM User WHERE Id = : UserInfo.getUserId()]; 
        
    crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationPort sendport=new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationPort();
    crmasiaDaimlerApacComSfdcnotificatio.JPOSCustomerNotificationRequestMessageType request=new crmasiaDaimlerApacComSfdcnotificatio.JPOSCustomerNotificationRequestMessageType();
     crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType response=new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType();
    crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationFaultType fault=new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationFaultType();
    
      String OrganizationId = UserInfo.getOrganizationId();
         String MarketDiscriminator= Usr.Market__c;
         System.debug('$%$%$%$%$%$%$%$ TransactionId'+CustomerID+'Address id'+ AddressId+'Dealer ids'+DealerID);
        
      sendport.JPOSCustomerNotification(OrganizationId ,MarketDiscriminator,CustomerID,AddressId,DealerId);
      
      System.debug('$%$%$%$%$%$%$%$ TransactionId'+response.TransactionId);
       
     
      System.debug('%^%%^%^%^% ErrorCode response'+fault.ErrorCode); 
      
       return response;
    } */

       Public static string AccountIfnoSendToJPOS(String CustomerID,String AddressId,String DealerID)
    {  
    User  Usr = [SELECT Market__c, Id FROM User WHERE Id = : UserInfo.getUserId()]; 
        
    crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationPort sendport=new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationPort();
    crmasiaDaimlerApacComSfdcnotificatio.JPOSCustomerNotificationRequestMessageType request=new crmasiaDaimlerApacComSfdcnotificatio.JPOSCustomerNotificationRequestMessageType();
     crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType response=new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType();
    crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationFaultType fault=new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationFaultType();
    
    
    crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType response_x;
            Map<String, crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType> response_map_x = new Map<String, crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType>();
            response_map_x.put('response_x', response_x);
            
            
      String OrganizationId = UserInfo.getOrganizationId();
         String MarketDiscriminator= Usr.Market__c;
         request.Organization=UserInfo.getOrganizationId();
          request.MarketDiscriminator=Usr.Market__c;
           request.CustomerId=CustomerID;
            request.AddressId=AddressId;
             request.UserId=DealerId;
         System.debug('$%$%$%$%$%$%$%$ TransactionId'+CustomerID+'Address id'+ AddressId+'Dealer ids'+DealerID);
        //response.(String.Valueof(sendport.JPOSCustomerNotification(request.Organization,request.MarketDiscriminator,CustomerID,AddressId,DealerId)));
  
  
   sendport.JPOSCustomerNotification(OrganizationId ,MarketDiscriminator,CustomerID,AddressId,DealerId);
  string src;
  System.debug('$%$%$%$src tra'+src);
      System.debug('$%$%$%$%$%$%$%$ TransactionId'+response.TransactionId);
       
     
      System.debug('%^%%^%^%^% ErrorCode response'+fault.ErrorCode); 
      
           
      
       return src;
    }
    
    Public static crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType AccountIfnoSendSPO(String CustomerID,String DealerID)
    {  
    User  Usr = [SELECT Market__c, Id FROM User WHERE Id = : UserInfo.getUserId()]; 
        
    crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationPort sendport=new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationPort();
    crmasiaDaimlerApacComSfdcnotificatio.SPOCustomerNotificationRequestMessageType request=new crmasiaDaimlerApacComSfdcnotificatio.SPOCustomerNotificationRequestMessageType();
     crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType response=new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType();
    
      String OrganizationId = UserInfo.getOrganizationId();
         String MarketDiscriminator= Usr.Market__c;
        
      sendport.SPOCustomerNotification(OrganizationId ,MarketDiscriminator,CustomerID,DealerId);
      
      System.debug('$%$%$%$%$%$%$%$ TransactionId'+response.TransactionId);
       
     
      System.debug('%^%%^%^%^% response'+response); 
       return response;
    }
    public static crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType validateAddressByZipCode(Address__c address)
    {
        crmasiaDaimlerApacComValidateaddress.AddressValidationPort stub = new crmasiaDaimlerApacComValidateaddress.AddressValidationPort();
        crmasiaDaimlerApacComValidateaddress.Address SendingAddress = new crmasiaDaimlerApacComValidateaddress.Address();
        crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType response = new crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType();
        crmasiaDaimlerApacComValidateaddress.AddressValidationMessageFaultType faultCode = new  crmasiaDaimlerApacComValidateaddress.AddressValidationMessageFaultType(); 
        
        List<ProvinceTranslation__mdt> ProvinceCodeKR = [select id,MD__c,Object__c,Picklist_Name__c,Province_EN1__c,Province_EN10__c,Province_EN11__c,Province_EN12__c,Province_EN13__c,  
                Province_EN14__c,Province_EN15__c,Province_EN16__c,Province_EN17__c,Province_EN18__c,Province_EN19__c,Province_EN2__c,Province_EN20__c, 
                Province_EN21__c,Province_EN22__c,Province_EN23__c,Province_EN24__c,Province_EN25__c,Province_EN26__c,Province_EN27__c,Province_EN28__c,    
                Province_EN29__c,Province_EN3__c,Province_EN30__c,Province_EN31__c,Province_EN32__c,Province_EN33__c,Province_EN34__c,Province_EN35__c, 
                Province_EN36__c,Province_EN37__c,Province_EN38__c,Province_EN39__c,Province_EN4__c,Province_EN40__c,Province_EN41__c,Province_EN42__c, 
                Province_EN43__c,Province_EN44__c,Province_EN45__c,Province_EN46__c,Province_EN47__c,Province_EN5__c,Province_EN6__c,Province_EN7__c,   
                Province_EN8__c,Province_EN9__c,Province_TR1__c,Province_TR10__c,Province_TR11__c,Province_TR12__c,Province_TR13__c,Province_TR14__c,   
                Province_TR15__c,Province_TR16__c,Province_TR17__c,Province_TR18__c,Province_TR19__c,Province_TR2__c,Province_TR20__c,Province_TR21__c, 
                Province_TR22__c,Province_TR23__c,Province_TR24__c,Province_TR25__c,Province_TR26__c,Province_TR27__c,Province_TR28__c,Province_TR29__c ,
                Province_TR3__c,Province_TR30__c,Province_TR31__c,Province_TR32__c,Province_TR33__c,Province_TR34__c,Province_TR35__c,Province_TR36__c, 
                Province_TR37__c,Province_TR38__c,Province_TR39__c,Province_TR4__c,Province_TR40__c,Province_TR41__c,Province_TR42__c,Province_TR43__c, 
                Province_TR44__c,Province_TR45__c,Province_TR46__c,Province_TR47__c,Province_TR5__c,Province_TR6__c,Province_TR7__c,Province_TR8__c,Province_TR9__c from ProvinceTranslation__mdt where MD__c=: address.MD__c LIMIT 1]; 
        system.debug(address.MD__c + '   mobileAreaCodeKR >>>>>>'+ProvinceCodeKR);
        for(ProvinceTranslation__mdt provinceCode : ProvinceCodeKR){
            if(address.Province__c == provinceCode.Province_EN1__c){
                SendingAddress.Province = provinceCode.Province_TR1__c;
            }
            if(address.Province__c == provinceCode.Province_EN2__c){
                SendingAddress.Province = provinceCode.Province_TR2__c;
            }
            if(address.Province__c == provinceCode.Province_EN3__c){
                SendingAddress.Province = provinceCode.Province_TR3__c;
            }
            if(address.Province__c == provinceCode.Province_EN4__c){
                SendingAddress.Province = provinceCode.Province_TR4__c;
            }
            if(address.Province__c == provinceCode.Province_EN5__c){
                SendingAddress.Province = provinceCode.Province_TR5__c;
            }
            if(address.Province__c == provinceCode.Province_EN6__c){
                SendingAddress.Province = provinceCode.Province_TR6__c;
            }
            if(address.Province__c == provinceCode.Province_EN7__c){
                SendingAddress.Province = provinceCode.Province_TR7__c;
            }
            if(address.Province__c == provinceCode.Province_EN8__c){
                SendingAddress.Province = provinceCode.Province_TR8__c;
            }
            if(address.Province__c == provinceCode.Province_EN9__c){
                SendingAddress.Province = provinceCode.Province_TR9__c;
            }
            if(address.Province__c == provinceCode.Province_EN10__c){
                SendingAddress.Province = provinceCode.Province_TR10__c;
            }
            if(address.Province__c == provinceCode.Province_EN11__c){
                SendingAddress.Province = provinceCode.Province_TR11__c;
            }            
            if(address.Province__c == provinceCode.Province_EN12__c){
                SendingAddress.Province = provinceCode.Province_TR12__c;
            }
            if(address.Province__c == provinceCode.Province_EN13__c){
                SendingAddress.Province = provinceCode.Province_TR13__c;
            }
            if(address.Province__c == provinceCode.Province_EN14__c){
                SendingAddress.Province = provinceCode.Province_TR14__c;
            }
            if(address.Province__c == provinceCode.Province_EN15__c){
                SendingAddress.Province = provinceCode.Province_TR15__c;
            }
            if(address.Province__c == provinceCode.Province_EN16__c){
                SendingAddress.Province = provinceCode.Province_TR16__c;
            }
            if(address.Province__c == provinceCode.Province_EN17__c){
                SendingAddress.Province = provinceCode.Province_TR17__c;
            }
            if(address.Province__c == provinceCode.Province_EN18__c){
                SendingAddress.Province = provinceCode.Province_TR18__c;
            }
            if(address.Province__c == provinceCode.Province_EN19__c){
                SendingAddress.Province = provinceCode.Province_TR19__c;
            }
            if(address.Province__c == provinceCode.Province_EN20__c){
                SendingAddress.Province = provinceCode.Province_TR20__c;
            }
            if(address.Province__c == provinceCode.Province_EN21__c){
                SendingAddress.Province = provinceCode.Province_TR21__c;
            }
            if(address.Province__c == provinceCode.Province_EN22__c){
                SendingAddress.Province = provinceCode.Province_TR22__c;
            }
            if(address.Province__c == provinceCode.Province_EN23__c){
                SendingAddress.Province = provinceCode.Province_TR23__c;
            }
            if(address.Province__c == provinceCode.Province_EN24__c){
                SendingAddress.Province = provinceCode.Province_TR24__c;
            }
            if(address.Province__c == provinceCode.Province_EN25__c){
                SendingAddress.Province = provinceCode.Province_TR25__c;
            }
            if(address.Province__c == provinceCode.Province_EN26__c){
                SendingAddress.Province = provinceCode.Province_TR26__c;
            }
            if(address.Province__c == provinceCode.Province_EN27__c){
                SendingAddress.Province = provinceCode.Province_TR27__c;
            }
            if(address.Province__c == provinceCode.Province_EN28__c){
                SendingAddress.Province = provinceCode.Province_TR28__c;
            }
            if(address.Province__c == provinceCode.Province_EN29__c){
                SendingAddress.Province = provinceCode.Province_TR29__c;
            }
            if(address.Province__c == provinceCode.Province_EN30__c){
                SendingAddress.Province = provinceCode.Province_TR30__c;
            }
            if(address.Province__c == provinceCode.Province_EN31__c){
                SendingAddress.Province = provinceCode.Province_TR31__c;
            }
            if(address.Province__c == provinceCode.Province_EN32__c){
                SendingAddress.Province = provinceCode.Province_TR32__c;
            }
            if(address.Province__c == provinceCode.Province_EN33__c){
                SendingAddress.Province = provinceCode.Province_TR33__c;
            }
            if(address.Province__c == provinceCode.Province_EN34__c){
                SendingAddress.Province = provinceCode.Province_TR34__c;
            }
            if(address.Province__c == provinceCode.Province_EN35__c){
                SendingAddress.Province = provinceCode.Province_TR35__c;
            }
            if(address.Province__c == provinceCode.Province_EN36__c){
                SendingAddress.Province = provinceCode.Province_TR36__c;
            }
            if(address.Province__c == provinceCode.Province_EN37__c){
                SendingAddress.Province = provinceCode.Province_TR37__c;
            }
            if(address.Province__c == provinceCode.Province_EN38__c){
                SendingAddress.Province = provinceCode.Province_TR38__c;
            }
            if(address.Province__c == provinceCode.Province_EN39__c){
                SendingAddress.Province = provinceCode.Province_TR39__c;
            }
            if(address.Province__c == provinceCode.Province_EN40__c){
                SendingAddress.Province = provinceCode.Province_TR40__c;
            }
            if(address.Province__c == provinceCode.Province_EN41__c){
                SendingAddress.Province = provinceCode.Province_TR41__c;
            }
            if(address.Province__c == provinceCode.Province_EN42__c){
                SendingAddress.Province = provinceCode.Province_TR42__c;
            }
            if(address.Province__c == provinceCode.Province_EN43__c){
                SendingAddress.Province = provinceCode.Province_TR43__c;
            }
            if(address.Province__c == provinceCode.Province_EN44__c){
                SendingAddress.Province = provinceCode.Province_TR44__c;
            }
            if(address.Province__c == provinceCode.Province_EN45__c){
                SendingAddress.Province = provinceCode.Province_TR45__c;
            }
            if(address.Province__c == provinceCode.Province_EN46__c){
                SendingAddress.Province = provinceCode.Province_TR46__c;
            }
            if(address.Province__c == provinceCode.Province_EN47__c){
                SendingAddress.Province = provinceCode.Province_TR47__c;
            }           
        }
        //User u = [SELECT Id,Market__c FROM User WHERE Id=:UserInfo.getUserId()] ;
        SendingAddress.ZipCode = address.ZipCode__c;
        SendingAddress.MarketDiscriminator = address.MD__c;
        SendingAddress.Address_Line_1 = address.Address_Line_1__c;
        SendingAddress.Address_Line_2 = address.Address_Line_2__c;
        SendingAddress.HouseNumber = address.HouseNumber__c;
        SendingAddress.Block = address.Block__c;
        SendingAddress.City = address.City__c;
        SendingAddress.District = address.District__c;
        SendingAddress.Province = address.Province__c;
        crmasiaDaimlerApacComValidateaddress.AddressValidationRequestMessageType request = new crmasiaDaimlerApacComValidateaddress.AddressValidationRequestMessageType();
        request.Organization = UserInfo.getOrganizationId();
        request.Address = SendingAddress;
        try
        {
            response = stub.ValidateAddress(request);            
        }
        catch(CalloutException excpObj)
        {
            system.debug('!!!!!!!!!'+excpObj.getMessage());            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.AddressValidation_callout_failure));            
        }
        return response;
    } 
    
     public static void entityUpdateNotification(String organizationId,String sfdcId,String sfdcTypeName,String sfdcMarketDiscriminator,String updateType,String serlializedObject)
    {
        //Soap over http
        String requestXML='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ep="http://ep.apac.crm.daimler.com">';
        requestXML+='<soapenv:Header/>';
        requestXML+='<soapenv:Body>';
        requestXML+='<ep:notifyEntityUpdate>';
        requestXML+='<ep:organizationId>'+organizationId+'</ep:organizationId>';
        requestXML+='<ep:sfdcId>'+sfdcId+'</ep:sfdcId>';
        requestXML+='<ep:sfdcTypeName>'+sfdcTypeName+'</ep:sfdcTypeName>';
        requestXML+='<ep:sfdcMarketDiscriminator>'+sfdcMarketDiscriminator+'</ep:sfdcMarketDiscriminator>';
        requestXML+='<ep:updateType>'+updateType+'</ep:updateType>';
        requestXML+='<ep:serlializedObject>'+serlializedObject+'</ep:serlializedObject>';
        requestXML+='</ep:notifyEntityUpdate>';
        requestXML+='</soapenv:Body>';
        requestXML+='</soapenv:Envelope>';
        
        HttpRequest req=new HttpRequest();
        req.setMethod('GET');
        //system.debug('req UtilCustomSettings >>>>>'+UtilCustomSettings.getEndPointURL(UtilConstant.ENTITY_UPDATE_NOTIFICATION));
        req.setEndpoint(UtilCustomSettings.getWebserviceUrl('EPUrlEntityNotification'));
        req.setTimeout(120000);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', '""');
        req.setHeader('Connection', 'Keep-Alive');
        req.setBody(requestXML);
        system.debug('req >>>>>'+req);
        Http http=new Http();
        HTTPResponse res ;
        try{
            res=http.send(req);  
            system.debug('res>>>>>'+res);
        }catch(Exception e)
        {
            system.debug('e>>>>>'+e.getmessage()+'>>>>>'+e.getstacktracestring());
        }
    }
    
   public static crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse validateCustomerDetails(Account accountDetails){
   
   System.debug('%^%^%^%%^ accountDetails'+accountDetails);
        User  Usr = [SELECT Market__c, Id FROM User WHERE Id = : UserInfo.getUserId()];        
        System.debug('@@@@@@ ## User'+Usr);
        String companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
        String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
        crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationPort stub = new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationPort();     
        crmasiaDaimlerApacComCustomeridentif.Customer sendingCustomerDetails = new crmasiaDaimlerApacComCustomeridentif.Customer();
        crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse response = new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse();
        sendingCustomerDetails.Id  = accountDetails.Id;
        sendingCustomerDetails.FirstName = accountDetails.FirstName; 
        sendingCustomerDetails.LastName = accountDetails.LastName;
        sendingCustomerDetails.Name= accountDetails.Name;
        sendingCustomerDetails.LastName_Native_1_xc = accountDetails.LastName_Native_1__c;
        sendingCustomerDetails.FirstName_Native_1_xc = accountDetails.FirstName_Native_1__c;
        sendingCustomerDetails.PersonBirthdate    = string.valueOf(accountDetails.PersonBirthdate);
        sendingCustomerDetails.LoyaltyCardNo = accountDetails.Loyalty_Card_No__c;
        sendingCustomerDetails.Individual_Home_Phone_xc = accountDetails.Individual_Home_Phone__c;
        sendingCustomerDetails.Home_Phone_2_xc = accountDetails.Home_Phone_2__c;
        sendingCustomerDetails.Work_Phone_xc = accountDetails.Work_Phone__c;
        sendingCustomerDetails.Phone = accountDetails.Phone;
        sendingCustomerDetails.Mobile_xc = accountDetails.Mobile__c;
        sendingCustomerDetails.Mobile2_xc = accountDetails.Mobile2__c ;
        sendingCustomerDetails.Email_xc = accountDetails.Email__c;
        sendingCustomerDetails.Email2_xc = accountDetails.Email2__c;
        sendingCustomerDetails.Email3_xc =  accountDetails.Email3__c ;
        sendingCustomerDetails.Salutation = accountDetails.Salutation ;         
        sendingCustomerDetails.Vin = accountDetails.VIN__c; 
        sendingCustomerDetails.Company_Name_xc= accountDetails.Company_Name__c; 
        sendingCustomerDetails.Company_Name_Native_1_xc = accountDetails.Company_Name_Native_1__c;         
         sendingCustomerDetails.Foundation_date_xc=  string.valueOf(accountDetails.Foundation_date__c);
        sendingCustomerDetails.Commercial_reg_no_xc= accountDetails.Commercial_reg_no__c; 
        
        if(accountDetails.RecordTypeId == PersonAccountRecordTypeID)
        {
            sendingCustomerDetails.RecordType = 'PersonAccount';     
        }
        if(accountDetails.RecordTypeId == companyRecordTypeId)
        {
            sendingCustomerDetails.RecordType = 'Company';     
        }       
        crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationRequestMessageType request = new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationRequestMessageType();
          request.OrganizationId = UserInfo.getOrganizationId();
          request.MarketDiscriminator= Usr.Market__c;
          
          System.debug('%^%^%^%%^ sendingCustomerDetails'+sendingCustomerDetails);

          System.debug('@@@@@@ request.MarketDiscriminator'+request.MarketDiscriminator);
          request.Customer = sendingCustomerDetails;
          system.debug('request request: '+request);
        try{
        system.debug('try request request: '+request);
            response = stub.IdentifyCustomer(request);
             system.debug('try response response : '+response);
        }
        catch(CalloutException excpObj){
            system.debug('Error *** :'+excpObj.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Online_Dedup_callout_failure));
        }
        system.debug('response : '+response);
        return response;
    }
    
     public static crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse validateCustomerDetailsWithAddress(Account accountDetails,Address__C AddressObj){
   
        User  Usr = [SELECT Market__c, Id FROM User WHERE Id = : UserInfo.getUserId()];        
        System.debug('@@@@@@ ## User'+Usr);
        String companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
        String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
        crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationPort stub = new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationPort();     
        crmasiaDaimlerApacComCustomeridentif.Customer sendingCustomerDetails = new crmasiaDaimlerApacComCustomeridentif.Customer();
        crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse response = new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse();
        sendingCustomerDetails.Address_xc = new List<crmasiaDaimlerApacComCustomeridentif.Address>();
        crmasiaDaimlerApacComCustomeridentif.Address addrValues = new crmasiaDaimlerApacComCustomeridentif.Address();
        
        sendingCustomerDetails.Id  = accountDetails.Id;
        sendingCustomerDetails.FirstName = accountDetails.FirstName; 
        sendingCustomerDetails.LastName = accountDetails.LastName;
        sendingCustomerDetails.LastName_Native_1_xc = accountDetails.LastName_Native_1__c;
        sendingCustomerDetails.FirstName_Native_1_xc = accountDetails.FirstName_Native_1__c;
        sendingCustomerDetails.PersonBirthdate    = string.valueOf(accountDetails.PersonBirthdate);
        sendingCustomerDetails.LoyaltyCardNo = accountDetails.Loyalty_Card_No__c;
        sendingCustomerDetails.Individual_Home_Phone_xc = accountDetails.Individual_Home_Phone__c;
        sendingCustomerDetails.Home_Phone_2_xc = accountDetails.Home_Phone_2__c;
        sendingCustomerDetails.Work_Phone_xc = accountDetails.Work_Phone__c;
        sendingCustomerDetails.Phone = accountDetails.Phone;
        sendingCustomerDetails.Mobile_xc = accountDetails.Mobile__c;
        sendingCustomerDetails.Mobile2_xc = accountDetails.Mobile2__c ;
        sendingCustomerDetails.Email_xc = accountDetails.Email__c;
        sendingCustomerDetails.Email2_xc = accountDetails.Email2__c;
        sendingCustomerDetails.Email3_xc =  accountDetails.Email3__c ;
        sendingCustomerDetails.Salutation = accountDetails.Salutation ; 
        sendingCustomerDetails.Name= accountDetails.Name;
        sendingCustomerDetails.Vin = accountDetails.VIN__c; 
        sendingCustomerDetails.Company_Name_xc= accountDetails.Company_Name__c; 
        sendingCustomerDetails.Company_Name_Native_1_xc = accountDetails.Company_Name_Native_1__c; 
        sendingCustomerDetails.Foundation_date_xc=  string.valueOf(accountDetails.Foundation_date__c);
        sendingCustomerDetails.Commercial_reg_no_xc= accountDetails.Commercial_reg_no__c; 
        
        addrValues.Address_Code_xc=AddressObj.Address_Code__c;
        addrValues.Address_Line_1_xc=AddressObj.Address_Line_1__c;
        addrValues.Address_Line_2_xc=AddressObj.Address_Line_2__c;
        addrValues.Block_xc=AddressObj.Block__c;
        addrValues.City_xc=AddressObj.City__c;
        addrValues.District_xc=AddressObj.District__c;
        addrValues.Province_xc=AddressObj.Province__c;
        addrValues.ZipCode_xc=AddressObj.ZipCode__c;
        addrValues.Country_xc=AddressObj.Country__c;
        addrValues.Company_Name_xc=AddressObj.Company_Name__c;
        addrValues.Company_Name_Native_xc=AddressObj.Company_Name_Native__c;
        addrValues.Delivery_Point_ID_xc=AddressObj.Delivery_Point_ID__c;
        addrValues.HouseNumber_xc=AddressObj.HouseNumber__c;
        addrValues.Temp_Address_xc=AddressObj.Temp_Address__c;
        addrValues.Temp_ZipCode_xc=AddressObj.Temp_ZipCode__c;
        addrValues.TitleOfHonor_xc=AddressObj.TitleOfHonor__c;
        sendingCustomerDetails.Address_xc.add(addrValues);
        
        if(accountDetails.RecordTypeId == PersonAccountRecordTypeID)
        {
            sendingCustomerDetails.RecordType = 'PersonAccount';     
        }
        if(accountDetails.RecordTypeId == companyRecordTypeId)
        {
            sendingCustomerDetails.RecordType = 'Company';     
        }       
        crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationRequestMessageType request = new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationRequestMessageType();
          request.OrganizationId = UserInfo.getOrganizationId();
          request.MarketDiscriminator= Usr.Market__c;
          
          

          System.debug('@@@@@@ request.MarketDiscriminator'+request.MarketDiscriminator);
          request.Customer = sendingCustomerDetails;
          system.debug('request request: '+request);
        try{
        system.debug('try request request: '+request);
            response = stub.IdentifyCustomer(request);
             system.debug('try response response : '+response);
        }
        catch(CalloutException excpObj){
            system.debug('Error *** :'+excpObj.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Online_Dedup_callout_failure));
        }
        system.debug('response : '+response);
        return response;
    }
    
}
