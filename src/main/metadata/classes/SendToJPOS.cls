/***********************************************************************************
Created By          :    Venky    
Created Date        :    15.12.2016
Company             :    NTT Data,Inc.
Usage               :    The functionality of this Class sending Account Id,Address Id and DealerId to EP database
                         Business Conditions :
                          * In case of MBJ User select Dealer.
                          *field displayed for Address and Account object must have values.
                          * Assgigned dealer should be selected from Account_Link sales consulatant.
                          * On click of Send to jpos button webservice will be called and information will be send to EP data base. 
                          
************************************************************************************/



public class SendToJPOS{
    Public List<Address__c> AddRecords{get;set;}  
    Public static String AccId{get;set;}
    Public Id AddId{get;set;}
    Public Set<Id> DealeAccId{get;set;}
    Public static Id AddrecordId{get;set;}
    Public Account Acclist { get; set; }
    public List<Account> acc{set;get;}
    public List<Account> Dealeracc{set;get;}
    public Address__c addr{set;get;}
    public List<Address__c> address{set;get;}
    Public User  Usr{get;set;} 
    public Account DealerID { get; set; }  
    public List<Account_Link__c> listAlk{ get; set; }  
    public List<Contact> contactList{ get; set; }  
    public static  Address__c AddreesSedntoJPOS{set;get;}
    public List<Account> accc {set;get;}
    public User  CurrentUsr{set;get;}
    public User  AssignedDealer{set;get;}
    public  Boolean ShowHideError{set;get;}
    public String AssignedDealerUserID;
    public String MyMercedesID{set;get;}
    public static Id alkPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static Id alkCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    public static Id alkIndividualRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId();
    public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id accCompany_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    
    //Constructor
    public SendToJPOS(ApexPages.StandardController controller) { 
    CurrentUsr=[SELECT Market__c,IsPortalEnabled,DMS_UserID__c,contactid,Id FROM User WHERE Id = : UserInfo.getUserId()];
     addr=new Address__c();
     ShowHideError=false;
     address=new List<Address__c>();
      Acclist =new Account();
      AssignedDealer=new User();
      DealeAccId=new Set<Id>();
      contactList=new List<Contact>();
      DealerID= (Account)controller.getRecord();
      AddRecords=new List<Address__c>();
      AccId=ApexPages.currentPage().getParameters().get('id'); 
      acc=[select id,Name,RecordType.Name,(select id, Sales_Person_Id__c from Account_Links1__r ),Company_Name_Native_2__c, Mobile__c,FirstName,LastName,Gender__c,Company_Name__c,LastName_Native_1__c,Company_Name_Native_1__c,FirstName_Native_1__c,Company_Legal_Form__c,Company_Legal_Form_text__c,Legal_Form_Position__c,UCID__c,Foundation_Date__c,PersonBirthdate from Account where Id =:AddrecordId];
       AddRecords=[select id,Address_Type__c,Province__c,City__c,District__c,Block__c,Address_Line_1__c,Address_Line_2__c,ZipCode__c from Address__c where Customer__c=:AccId ];
          if(AddRecords!=null && AddRecords.Size()>0)
                {
       address=[select id,Customer__c,Address_Code__c ,ZipCode__c,Province__c,Province_Native__c,Block__c,Block_Native__c,City__c,City_Native__c,District__c,District_Native__c,Address_Line_1__c,Address_Line_1_Native__c,Address_Line_2__c,Address_Line_2_Native__c from address__c where Customer__c=:AccId];     
       }
       
       
       //To Display Mym Id and Assigned dealer name.
       if(CurrentUsr.contactid ==null || CurrentUsr.contactid!=null)
       {
        if( AccId!=null )
               {
               listAlk=[Select id,name,Retail_Duplicate_Flag__c ,System__c,Retail_Sales_Consultant__c,Primary__c,Retail_Delete_Flag__c ,fromRole__c,toRole__c,RecordTypeId from  Account_Link__c where toRole__c =:AccId and Recordtypeid=:alkIndividualRecordTypeId and Primary__c=True];
          
               }     
          System.debug('@#@#@#@ listAlk#@@#'+listAlk);
          
            if(listAlk!=null && !listAlk.isempty())
           {
           for(Account_Link__c Acclink:listAlk)
           {
           AssignedDealerUserID=Acclink.Retail_Sales_Consultant__c;
            if( (Acclink.Recordtypeid == alkIndividualRecordTypeId) &&  (Acclink.System__c=='My Mercedes') && (Acclink.Primary__c==True) )
          
           {
           MyMercedesID=Acclink.Name;
           }
           }
           }
       }
       
       //If current Logged in User is Dealer user update Assigned Dealer field value.
       if(CurrentUsr.contactid!=null)
             { 
             
               Usr = [SELECT Market__c,contactid,IsPortalEnabled,Id,contact.AccountId FROM User WHERE Id = : UserInfo.getUserId() and User.Profile.UserLicense.Name='Partner Community']; 
              
              contactList=[Select id,AccountId from Contact where id=:usr.ContactId]; 
              
              If(contactList!=null)
              {
              for(Contact con:contactList)
              {
              DealeAccId.add(con.AccountId);
              }
              }
              if(AccId!=null)
               {
               Acclist=[Select id,City__c,Gender__c,FirstName,LastName,FirstName_Native_1__c,LastName_Native_1__c,PersonBirthdate,Company_Name__c,Company_Name_Native_1__c,Company_Name_Native_2__c,Company_Legal_Form__c,Company_Legal_Form_text__c,Legal_Form_Position__c,Recordtypeid from Account where id=:AccId];
              }
               
               if(DealeAccId!=null && AccId!=null && Acclist.Recordtypeid==accCompany_RecordTypeId)
               {
              listAlk=[Select id,Retail_Duplicate_Flag__c ,System__c,Retail_Sales_Consultant__c,Retail_Delete_Flag__c ,fromRole__c,toRole__c from  Account_Link__c where fromRole__c=:DealeAccId and toRole__c =:AccId and Recordtypeid=:alkCompany_RecordTypeId ];
               } 
                if(DealeAccId!=null && AccId!=null && Acclist.Recordtypeid==accPerson_RecordTypeId)
               {
              listAlk=[Select id,Retail_Duplicate_Flag__c ,System__c,Retail_Sales_Consultant__c,Retail_Delete_Flag__c ,fromRole__c,toRole__c from  Account_Link__c where fromRole__c=:DealeAccId and toRole__c =:AccId and Recordtypeid=:alkPerson_RecordTypeId];
               }  
          
            if(listAlk!=null && !listAlk.isempty())
           {
           for(Account_Link__c Acclink:listAlk)
           {
           AssignedDealerUserID=Acclink.Retail_Sales_Consultant__c;
             
           }
           }
           if(AssignedDealerUserID!=null)
           {
         AssignedDealer=[SELECT Market__c,IsPortalEnabled,DMS_UserID__c,contactid,Id FROM User WHERE Id = :AssignedDealerUserID and DMS_UserID__c!=null];
           }
             }
       
    } // End of Constructer 
           
           
           //Method to get Selected Address record Id.
         public pageReference  getSelected ()
         {    
          addId =ApexPages.currentPage().getParameters().get('idselected');             
          system.debug('+++++++++'+ addId );       
        return null; 
       }
        
        //Method to get Selected Dealer Account  record Id.
          public void  getDealer(){
          Dealeracc=new List<Account>();
          AccId=ApexPages.currentPage().getParameters().get('id'); 
          // DealerID=ApexPages.currentPage().getParameters().get('DealerID'); 
           
           accc=[Select id from account where id=:DealerID.Main_Dealer__c];   
           
           if(AccId !=null)
           {
            Acclist=[Select id,Gender__c,FirstName,LastName,FirstName_Native_1__c,LastName_Native_1__c,PersonBirthdate,Company_Name__c,Company_Name_Native_2__c,Company_Name_Native_1__c,Company_Legal_Form__c,Company_Legal_Form_text__c,Legal_Form_Position__c,Recordtypeid from Account where id=:AccId];
          
           } 
           
           
           if(AccId !=null && DealerID.Main_Dealer__c!=null && (Acclist.Recordtypeid==accPerson_RecordTypeId))  
           {
            listAlk=[Select id,System__c,Retail_Duplicate_Flag__c ,Retail_Sales_Consultant__c,Retail_Delete_Flag__c ,fromRole__c,toRole__c from  Account_Link__c where fromRole__c=:DealerID.Main_Dealer__c and toRole__c =:AccId and Recordtypeid=:alkPerson_RecordTypeId];
             
           }
           
           if( AccId !=null && DealerID.Main_Dealer__c!=null && (Acclist.Recordtypeid==accCompany_RecordTypeId))
           {
             
            listAlk=[Select id,System__c,Retail_Duplicate_Flag__c ,Retail_Sales_Consultant__c,Retail_Delete_Flag__c ,fromRole__c,toRole__c from  Account_Link__c where fromRole__c=:DealerID.Main_Dealer__c  and toRole__c =:AccId and Recordtypeid=:alkCompany_RecordTypeId];
           
           }
           
           
            
           if(listAlk!=null && !listAlk.isempty())
           {
           for(Account_Link__c Acclink:listAlk)
           {
           AssignedDealerUserID=Acclink.Retail_Sales_Consultant__c; 
           }
           }
            
           if(AssignedDealerUserID!=null)
           {
           AssignedDealer=[SELECT Market__c,IsPortalEnabled,DMS_UserID__c,contactid,Id FROM User WHERE Id = :AssignedDealerUserID and DMS_UserID__c!=null];
           }
        
         
          } // Method end for Selecting Dealer Account Id.
          
          //Method for sending accountId,AddressId, Dealer ID to EP database.
        Public void  SendToJPOS()
         {
            
          
          
          Usr=new User(); 
           listAlk=new List<Account_Link__c> ();
           
           AccId=ApexPages.currentPage().getParameters().get('id'); 
           CurrentUsr=[SELECT Market__c,IsPortalEnabled,DMS_UserID__c,contactid,Id FROM User WHERE Id = :UserInfo.getUserId()];
           if(AccId!=null)
           {
           Acclist=[Select id,City__c,Gender__c,FirstName,LastName,FirstName_Native_1__c,LastName_Native_1__c,PersonBirthdate,Company_Name__c,Company_Name_Native_1__c,Company_Name_Native_2__c,Company_Legal_Form__c,Company_Legal_Form_text__c,Legal_Form_Position__c,Recordtypeid from Account where id=:AccId];
           }
           
           //If Addrees is not selected display error message.
          if(addId==null)
            {
            ShowHideError=True;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select atleast one Address'));
            }
            //For MBJ User if user not selected  Dealer Outlet display error message
            if(DealerID.Main_Dealer__c ==null && CurrentUsr.contactid==null)
            {
            ShowHideError=True;             
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Dealer Outlet'));
            }
            
            //Query to get selected address record Id
           If(addId!=null)
           {                     
           AddreesSedntoJPOS= [select id,City__c,Name,Customer__c,Address_Type__c,ZipCode__c,Province__c ,Province_Native__c ,City_Native__c,District__c,District_Native__c ,Block__c ,Block_Native__c ,Address_Line_1__c,Address_Line_1_Native__c , Address_Line_2__c ,Address_Line_2_Native__c  ,Company_Name__c ,Company_Name_Native__c ,TitleOfHonor__c , Status__c ,Temp_ZipCode__c ,Temp_Address__c  FROM  Address__c where id =:addId Limit 1];
           }
           
           //Query to get Dealer Account RecordId
           Dealeracc=[Select id,Name from Account where id=:DealerID.Main_Dealer__c];
           for(Account AccDealer:Dealeracc)
           {
           DealeAccId.add(AccDealer.id);
           } 
          
          // If Account is Person accout, Query to get Acccount_Link records with Retail person
           if(Acclist.Recordtypeid==accPerson_RecordTypeId)
           { 
           
            listAlk=[Select id,System__c,Retail_Duplicate_Flag__c ,Retail_Sales_Consultant__c,Retail_Delete_Flag__c ,fromRole__c,toRole__c from  Account_Link__c where fromRole__c=:DealeAccId and toRole__c =:AccId and Recordtypeid=:alkPerson_RecordTypeId ];
          
           }
            // If Account is Company accout, Query to get Acccount_Link records with Retail Company
           if(Acclist.Recordtypeid==accCompany_RecordTypeId)
           { 
            listAlk=[Select id,System__c,Retail_Duplicate_Flag__c ,Retail_Sales_Consultant__c,Retail_Delete_Flag__c ,fromRole__c,toRole__c from  Account_Link__c where fromRole__c=:DealeAccId and toRole__c =:AccId and Recordtypeid=:alkCompany_RecordTypeId];
          
           }
            
            // To get Retail sales consulatant Id
           if(listAlk!=null && !listAlk.isempty())
           {
           for(Account_Link__c Acclink:listAlk)
           {           
           AssignedDealerUserID=Acclink.Retail_Sales_Consultant__c;            
           }
           }
           
           // If  Retail sales consulatant is not blank ,query to get user Id.
           if(AssignedDealerUserID!=null)
           {
         AssignedDealer=[SELECT Market__c,IsPortalEnabled,DMS_UserID__c,contactid,Id FROM User WHERE Id = :AssignedDealerUserID and DMS_UserID__c!=null];
           }
           
           // If Current user is Dealer user ,get the sales consultant ID.
             if(CurrentUsr.contactid!=null)
             { 
               Usr = [SELECT Market__c,contactid,IsPortalEnabled,Id,contact.AccountId FROM User WHERE Id = : UserInfo.getUserId() and User.Profile.UserLicense.Name='Partner Community']; 
             
              contactList=[Select id,AccountId from Contact where id=:usr.ContactId];
               
              If(contactList!=null)
              {
              for(Contact con:contactList)
              {
              DealeAccId.add(con.AccountId);
              }
              }
                
             if(AccId !=null && DealeAccId!=null)
            {
              listAlk=[Select id,Retail_Duplicate_Flag__c ,System__c,Retail_Sales_Consultant__c,Retail_Delete_Flag__c ,fromRole__c,toRole__c from  Account_Link__c where fromRole__c=:DealeAccId and toRole__c =:AccId and (Recordtypeid=:alkCompany_RecordTypeId OR Recordtypeid=:alkPerson_RecordTypeId)];
            }
          
            if(listAlk!=null && !listAlk.isempty())
           {
               for(Account_Link__c Acclink:listAlk)
               {
               AssignedDealerUserID=Acclink.Retail_Sales_Consultant__c; 
               }
           }
           
           if(AssignedDealerUserID!=null)
           {
              AssignedDealer=[SELECT Market__c,IsPortalEnabled,DMS_UserID__c,contactid,Id FROM User WHERE Id = :AssignedDealerUserID and DMS_UserID__c!=null];
           }
          }
         // Webservice class intitalization.
         
         crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType response=new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType();
         // Person Account validation check
         if(Acclist.Recordtypeid==accPerson_RecordTypeId)
           {
           ShowHideError=True;
                   if(Acclist.Gender__c==null)
                   {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Gender'));
                   }
                   if(Acclist.FirstName==null)
                   {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'First Name Should not be null'));
                   }
                   if(Acclist.LastName==null)
                   {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Last Name Should not be null'));
                   }
                   if(Acclist.FirstName_Native_1__c==null)
                   {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'First Name Native Should not be null'));
                   }
                   if(Acclist.LastName_Native_1__c==null)
                   {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Last  Name Native Should not be null'));
                   }
                   if(Acclist.PersonBirthdate==null)
                   {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'PersonBirthdate Should not be null'));
                   }    
           }
           
           
            // Company Account validation check
            if(Acclist.Recordtypeid==accCompany_RecordTypeId)
           {
           ShowHideError=True;
               if(Acclist.Company_Name__c==null)
               {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter value for Company Name'));
               }
              /*  if(Acclist.Company_Name_Native_1__c==null)
               {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter value for Company Name Native'));
               }*/
               if(Acclist.Company_Name_Native_2__c==null)
               {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter value for Company Name Native2'));
               }
               if(Acclist.Company_Legal_Form__c==null)
               {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter value for Company Legal Form'));
               }
               if(Acclist.Company_Legal_Form_text__c==null)
               {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter value for Company Legal Form Text'));
               }
                if(Acclist.Legal_Form_Position__c==null)
               {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter value for Legal Form Position'));
               }
           
           }
           
            // Address  validation check
           if(((Acclist.Recordtypeid==accCompany_RecordTypeId) || (Acclist.Recordtypeid==accPerson_RecordTypeId)) && (AddreesSedntoJPOS!=Null))
            {
            ShowHideError=True;
                 if(AddreesSedntoJPOS.Province_Native__c==null)
                   {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Province Native Should not be null'));
                   }
                   if(AddreesSedntoJPOS.City_Native__c==null)
                   {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'City Native Should not be null'));
                   }
                   if(AddreesSedntoJPOS.District_Native__c==null)
                   {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'District Native Should not be null'));
                   }
                   if(AddreesSedntoJPOS.Province__c==null)
                   {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Province Should not be null'));
                   }
                   if(AddreesSedntoJPOS.City__c==null)
                   {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'City Should not be null'));
                   }
                   if(AddreesSedntoJPOS.District__c==null)
                   {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'District Should not be null'));
                   }    
                   if(AddreesSedntoJPOS.ZipCode__c==null)
                   {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Zip Code Should not be null'));
                   }    
            }
            
            // sales consultant and Dms user id validation check.
            if(((Acclist.Recordtypeid==accCompany_RecordTypeId) || (Acclist.Recordtypeid==accPerson_RecordTypeId))  )
            {
                 if(AssignedDealerUserID==null)
                   {
                   ShowHideError=True;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Retail Sales Consultant in Account Link'));
                   }
                  if(AssignedDealer.DMS_UserID__c==null)
                   {
                   ShowHideError=True;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Assigned Dealer Should not be null'));
                   } 
            }
            
               // If customer is Person account send account information to EP        
         if( (Acclist.Recordtypeid==accPerson_RecordTypeId) && (Acclist.Gender__c!=null) && (Acclist.FirstName !=null) && (Acclist.LastName!=null) && (Acclist.FirstName_Native_1__c!=null) && (Acclist.LastName_Native_1__c!=null) && (Acclist.PersonBirthdate!=null) && (AddreesSedntoJPOS!=Null) && AddreesSedntoJPOS.Province_Native__c!=null && (AddreesSedntoJPOS.City_Native__c!=null) && (AddreesSedntoJPOS.District_Native__c!=null) && (AddreesSedntoJPOS.Province__c!=null) && (AddreesSedntoJPOS.City__c!=null) && (AddreesSedntoJPOS.District__c!=null) && (AddreesSedntoJPOS.ZipCode__c!=null) && (AssignedDealerUserID!=null) && (AssignedDealer.DMS_UserID__c!=null))
         {
         try
        {
         if (!Test.isRunningTest())
            {
             
            if(Usr.id==null || Usr.Id!=null  )
            {
            String dId=string.valueof(DealeAccId);
              
              if(AddreesSedntoJPOS!=null  && AssignedDealer!=null)
              {
              String src;
              
                      
           src= UtilWebservice.AccountIfnoSendToJPOS(AccId,AddreesSedntoJPOS.id,AssignedDealer.Id); 
             
             
             
            ShowHideError=false; 
            }
            }
            }
           }
           Catch(Exception e)
           {
          
           String erre=e.getmessage();
            String[] errMessage = erre.split('webservice.WebServiceFault');          
            String errMessaget = errMessage[0];
            String errMessageText = errMessage[1];
                   ShowHideError=True; 
           ShowHideError=True; 
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMessageText));     
          
          }
         }  
          
                    
          // If customer is company send account information to EP
          if(Acclist.Recordtypeid==accCompany_RecordTypeId && Acclist.Company_Name__c!=null && Acclist.Company_Name_Native_2__c!=null && Acclist.Company_Legal_Form__c!=null && Acclist.Company_Legal_Form_text__c!=null && Acclist.Legal_Form_Position__c!=null && (AddreesSedntoJPOS!=Null) && AddreesSedntoJPOS.Province_Native__c!=null && AddreesSedntoJPOS.City_Native__c!=null && AddreesSedntoJPOS.District_Native__c!=null && AddreesSedntoJPOS.Province__c!=null && AddreesSedntoJPOS.City__c!=null && AddreesSedntoJPOS.District__c!=null && AddreesSedntoJPOS.ZipCode__c!=null && AssignedDealerUserID!=null && AssignedDealer.DMS_UserID__c!=null)
         {
                 try
                 {
                 if (!Test.isRunningTest())
                    { 
                    if(Usr.id==null || Usr.Id!=null  )
                    {
                    String dId=string.valueof(DealeAccId); 
                      if(AddreesSedntoJPOS!=null  && AssignedDealer!=null)
                      {
                      String src;
                   src= UtilWebservice.AccountIfnoSendToJPOS(AccId,AddreesSedntoJPOS.id,AssignedDealer.Id);
                   System.debug(' ^&^&^&^ Id#$#$#'+response);
                     
                    ShowHideError=false; 
                    }
                    }
                    }
                    }
                   Catch(CalloutException e)
                   {
                     
             String erre=e.getmessage();
            String[] errMessage = erre.split('webservice.WebServiceFault');          
            String errMessaget = errMessage[0];
            String errMessageText = errMessage[1];
                   ShowHideError=True; 
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMessageText));     
                  
                  }          
          } 
     }// Method End
}