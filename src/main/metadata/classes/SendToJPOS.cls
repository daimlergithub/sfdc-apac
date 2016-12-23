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
    public static  Address__c AddreesSedntoJPOS{set;get;}
    public List<Account> accc {set;get;}
    public User  CurrentUsr{set;get;}
    public User  AssignedDealer{set;get;}
    public  Boolean ShowHideError{set;get;}
    public String AssignedDealerUserID;
    public static Id alkPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static Id alkCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
     public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id accCompany_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    public SendToJPOS(ApexPages.StandardController controller) { 
    CurrentUsr=[SELECT Market__c,DMS_UserID__c,contactid,Id FROM User WHERE Id = : UserInfo.getUserId()];
     addr=new Address__c();
     address=new List<Address__c>();
      Acclist =new Account();
      AssignedDealer=new User();
      DealeAccId=new Set<Id>();
      DealerID= (Account)controller.getRecord();
      AddRecords=new List<Address__c>();
      AccId=ApexPages.currentPage().getParameters().get('id'); 
      acc=[select id,Name,RecordType.Name,(select id, Sales_Person_Id__c from Account_Links1__r ), Mobile__c,FirstName,LastName,Gender__c,Company_Name__c,LastName_Native_1__c,Company_Name_Native_1__c,FirstName_Native_1__c,Company_Legal_Form__c,Company_Legal_Form_text__c,Legal_Form_Position__c,UCID__c,Foundation_Date__c,PersonBirthdate from Account where Id =:AddrecordId];
       AddRecords=[select id,Address_Type__c,Province__c,City__c,District__c,Block__c,Address_Line_1__c,Address_Line_2__c,ZipCode__c from Address__c where Customer__c=:AccId ];
          if(AddRecords!=null && AddRecords.Size()>0)
                {
       address=[select id,Customer__c,Address_Code__c ,ZipCode__c,Province__c,Province_Native__c,Block__c,Block_Native__c,City__c,City_Native__c,District__c,District_Native__c,Address_Line_1__c,Address_Line_1_Native__c,Address_Line_2__c,Address_Line_2_Native__c from address__c where Customer__c=:AccId];     
       }
       
    }
           
         public pageReference  getSelected ()
         {    
          addId =ApexPages.currentPage().getParameters().get('idselected');             
          system.debug('+++++++++'+ addId );       
        return null; 
       }
        
          public void  getDealer(){
          Dealeracc=new List<Account>();
          AccId=ApexPages.currentPage().getParameters().get('id'); 
          // DealerID=ApexPages.currentPage().getParameters().get('DealerID');  
           accc=[Select id from account where id=:DealerID.Company__c];  
           if(AccId !=null)
           {
            Acclist=[Select id,Gender__c,FirstName,LastName,FirstName_Native_1__c,LastName_Native_1__c,PersonBirthdate,Company_Name__c,Company_Name_Native_2__c,Company_Legal_Form__c,Company_Legal_Form_text__c,Legal_Form_Position__c,Recordtypeid from Account where id=:AccId];
           }
           if(AccId !=null && DealerID.Company__c!=null && (Acclist.Recordtypeid==alkPerson_RecordTypeId))  
           {
            listAlk=[Select id,Retail_Duplicate_Flag__c ,Retail_Sales_Consultant__c,Retail_Delete_Flag__c ,fromRole__c,toRole__c from  Account_Link__c where fromRole__c=:AccId and toRole__c =:DealerID.Company__c and Recordtypeid=:alkPerson_RecordTypeId];
           }
           if( AccId !=null && DealerID.Company__c!=null && (Acclist.Recordtypeid==accCompany_RecordTypeId))
           {
            System.debug('@#@# companyb   #@@#');
            listAlk=[Select id,Retail_Duplicate_Flag__c ,Retail_Sales_Consultant__c,Retail_Delete_Flag__c ,fromRole__c,toRole__c from  Account_Link__c where fromRole__c=:AccId and toRole__c =:DealeAccId and Recordtypeid=:alkCompany_RecordTypeId];
          
           }
           System.debug('@#@#listAlk#@@#'+listAlk);
           if(listAlk!=null && !listAlk.isempty())
           {
           for(Account_Link__c Acclink:listAlk)
           {
           AssignedDealerUserID=Acclink.Retail_Sales_Consultant__c;
           }
           }
           System.debug('$%$$% AssignedDealerUserID$%$%%&&&'+AssignedDealerUserID);
           if(AssignedDealerUserID!=null)
           {
           AssignedDealer=[SELECT Market__c,DMS_UserID__c,contactid,Id FROM User WHERE Id = :AssignedDealerUserID and DMS_UserID__c!=null];
           }
          System.debug('$%$$%$$%$%$%%&&&'+AssignedDealer);
                
          system.debug('+++ DealerID+'+ DealerID);
          system.debug('++++ Dealeracc'+ accc);
         
          }
        Public void  SendToJPOS()
         {
            
           
          
          Usr=new User(); 
           listAlk=new List<Account_Link__c> ();
           
           AccId=ApexPages.currentPage().getParameters().get('id'); 
           CurrentUsr=[SELECT Market__c,DMS_UserID__c,contactid,Id FROM User WHERE Id = :UserInfo.getUserId()];
           Acclist=[Select id,City__c,Gender__c,FirstName,LastName,FirstName_Native_1__c,LastName_Native_1__c,PersonBirthdate,Company_Name__c,Company_Name_Native_2__c,Company_Legal_Form__c,Company_Legal_Form_text__c,Legal_Form_Position__c,Recordtypeid from Account where id=:AccId];
          if(addId==null)
            {
            System.debug('Selected address records '+addId);
            ShowHideError=True;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select atleast one Address'));
            }
            if(DealerID.Company__c ==null)
            {
            ShowHideError=True;
            System.debug('Selected Out dealer'+DealerID.Company__c);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Dealer Outlet'));
            }
           If(addId!=null)
           {
           
           system.debug('#$#$#$#$#$#$#$# addId'+addId);
           AddreesSedntoJPOS= [select id,City__c,Name,Customer__c,Address_Type__c,ZipCode__c,Province__c ,Province_Native__c ,City_Native__c,District__c,District_Native__c ,Block__c ,Block_Native__c ,Address_Line_1__c,Address_Line_1_Native__c , Address_Line_2__c ,Address_Line_2_Native__c  ,Company_Name__c ,Company_Name_Native__c ,TitleOfHonor__c , Status__c ,Temp_ZipCode__c ,Temp_Address__c  FROM  Address__c where id =:addId Limit 1];
           }
           Dealeracc=[Select id,Name from Account where id=:DealerID.Company__c];
           for(Account AccDealer:Dealeracc)
           {
           DealeAccId.add(AccDealer.id);
           }
           system.debug('+++ Dealeracc+'+ Dealeracc);
             system.debug('+++ DealeAccId DealeAccId DealeAccId+'+ DealeAccId);
           system.debug('@#@#@#@@#@#@#@ adreess ID'+ AddreesSedntoJPOS);
          
          
           if(Acclist.Recordtypeid==accPerson_RecordTypeId)
           {
           System.debug('@#@# Person#@@#');
           System.debug('@#@# AccId  #@@#'+AccId );
           System.debug('@#@# DealerID #@@#'+DealerID );
            listAlk=[Select id,Retail_Duplicate_Flag__c ,Retail_Sales_Consultant__c,Retail_Delete_Flag__c ,fromRole__c,toRole__c from  Account_Link__c where fromRole__c=:AccId and toRole__c =:DealeAccId and Recordtypeid=:alkPerson_RecordTypeId ];
          
           }
           if(Acclist.Recordtypeid==accCompany_RecordTypeId)
           {
            System.debug('@#@# companyb   #@@#');
            listAlk=[Select id,Retail_Duplicate_Flag__c ,Retail_Sales_Consultant__c,Retail_Delete_Flag__c ,fromRole__c,toRole__c from  Account_Link__c where fromRole__c=:AccId and toRole__c =:DealeAccId and Recordtypeid=:alkCompany_RecordTypeId];
          
           }
            System.debug('@#@#listAlk#@@#'+listAlk);
           if(listAlk!=null && !listAlk.isempty())
           {
           for(Account_Link__c Acclink:listAlk)
           {
           AssignedDealerUserID=Acclink.Retail_Sales_Consultant__c;
           }
           }
           if(AssignedDealerUserID!=null)
           {
         AssignedDealer=[SELECT Market__c,DMS_UserID__c,contactid,Id FROM User WHERE Id = :AssignedDealerUserID and DMS_UserID__c!=null];
           }
           System.debug('@#@#@#@#@#@#@@#'+AssignedDealerUserID);
             if(CurrentUsr.contactid!=null)
             {
               Usr = [SELECT Market__c,contactid,Id,contact.AccountId FROM User WHERE Id = : UserInfo.getUserId() and User.Profile.UserLicense.Name='Partner Community']; 
            
             }
                   crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType response=new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType();
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
           
            if(Acclist.Recordtypeid==alkCompany_RecordTypeId)
           {
           ShowHideError=True;
               if(Acclist.Company_Name__c==null)
               {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter value for Company Name'));
               }
               if(Acclist.Company_Name_Native_2__c==null)
               {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter value for FirstName'));
               }
               if(Acclist.Company_Legal_Form__c==null)
               {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter value for FirstName Native'));
               }
               if(Acclist.Company_Legal_Form_text__c==null)
               {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter value for LastName Native'));
               }
                if(Acclist.Legal_Form_Position__c==null)
               {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter value for PersonBirthdate'));
               }
           
           }
           
           if(((Acclist.Recordtypeid==alkCompany_RecordTypeId) || (Acclist.Recordtypeid==accPerson_RecordTypeId)) && (AddreesSedntoJPOS!=Null))
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
            if(((Acclist.Recordtypeid==alkCompany_RecordTypeId) || (Acclist.Recordtypeid==accPerson_RecordTypeId)) && (AssignedDealer.DMS_UserID__c!=Null))
            {
            if(AssignedDealer.DMS_UserID__c==null)
                   {
                   ShowHideError=True;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'DMS UserID Should not be null'));
                   } 
            }
            try
           {
           if (!Test.isRunningTest())
            {
            System.debug('#$##$####$#$#$#'+Usr);
            if(Usr.Id!=null )
            {
            System.debug('#$ NOT NULL ##$#$#$#'+Usr);
            response= UtilWebservice.AccountIfnoSendToJPOS(AccId,AddreesSedntoJPOS.id,Usr.Id);
            if(response!=null)
            {
            ShowHideError=false;
            }
            }
            if(Usr.id==null)
            {
            String dId=string.valueof(DealeAccId);
             System.debug('#$ NOT equals NULL ##$#$#$#'+Usr);
              System.debug('#$ NOT UserIDNULL ##$#$#$#'+AssignedDealerUserID);
              System.debug('#$ NOT AccId  ##$#$#$#'+AccId);
              System.debug('#$ NOT UserIDNULL ##DealeAccId#$#$#'+DealeAccId);
              if(AddreesSedntoJPOS!=null  && AssignedDealer!=null)
              {
           response= UtilWebservice.AccountIfnoSendToJPOS(AccId,AddreesSedntoJPOS.id,AssignedDealer.Id);
            if(response!=null)
            {
            ShowHideError=false;
            }
            }
            }
            }
            }
           Catch(Exception e)
           {
           ShowHideError=True;
           System.debug('@#@#@#@#@#@#@#@@@#@#@#@#@'+ShowHideError);
           System.debug('@#@#@#@#@#@#@#@@@#@#@#@#@ exception'+e);
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Web service callout failed'));     
          
          }
         }
}