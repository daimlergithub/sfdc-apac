public without sharing class dealerViewForContract
{
public Retail_Task__c retail{get;set;}
public Retail_Task__c displayRetail{get;set;}
public User us1{get;set;}
public String alkID{get;set;}
public String MotuserName{get;set;}
public String MotuserNameNative{get;set;}
public String AddressActual{get;set;}
public String MotuserPostal{get;set;}
public String MotuserAddress{get;set;}
public String MotuserPhone{get;set;}
public String MotownerName{get;set;}
public String MotuserownerNameNative{get;set;}
public String MotOwnerAddress{get;set;}

public dealerViewForContract(ApexPages.StandardController controller) {
     retail=new Retail_Task__c ();
     displayRetail=new Retail_Task__c ();
     alkID=ApexPages.currentPage().getParameters().get('id');
     us1 = [select id,ContactID,Dealer_GC_Code__c,User_Type__c from User WHERE Id =:UserInfo.getUserId()];
     if(alkID!=null)
     {
        retail = [select id,Latest_Sales_Person__c,Guarantor1_ZipCode__c,recordtype.Name,Contractor_Name__c,Related_Dealer__c,Related_Dealer__r.Dealer_GC_Code__c,Contractor_Name_Native__c,Vehicle_Registration_No__c,Contractor_ZipCode1__c,Contractor_Address1__c,MOT_User_Name__c,MOT_User_Name_Native__c,MOT_User_Postal__c,MOT_User_Address__c,MOT_User_Phone__c,MOT_Owner_Name__c,MOT_Owner_Name_Native__c,MOT_Owner_Address__c from Retail_Task__c WHERE ID = :alkID];
      
       }
        
   
    if((us1.ContactId ==null) && ((us1.User_Type__c == 'MBF')||(us1.User_Type__c == 'MBJ'))  && retail!=null)
        { 
           displayRetail= [select Latest_Sales_Person__c,Related_Dealer__c,Guarantor1_ZipCode__c,Contractor_Name__c,Contractor_Name_Native__c,Vehicle_Registration_No__c,Contractor_ZipCode1__c,Contractor_Address1__c,MOT_User_Name__c,MOT_User_Name_Native__c,MOT_User_Postal__c,MOT_User_Address__c,MOT_User_Phone__c,MOT_Owner_Name__c,MOT_Owner_Name_Native__c,MOT_Owner_Address__c from Retail_Task__c where id=:alkId and recordtype.Name='Contract'];
           
        }  
        system.debug('$%$%$%%$ us1.ContactId '+us1.ContactId );
        system.debug('&*&*&*&*& us1.User_Type__c'+us1.User_Type__c);
        system.debug('8978787878787&&&&&'+retail.Related_Dealer__r.Dealer_GC_Code__c);
        system.debug('us1.Dealer_GC_Code__c^&^&^'+us1.Dealer_GC_Code__c);
        system.debug('us1.retail'+retail);

        
        if((us1.ContactId !=null) &&(us1.User_Type__c == 'Dealer') && (retail.Related_Dealer__r.Dealer_GC_Code__c == us1.Dealer_GC_Code__c) && retail!=null)
        { 
        if(alkID!=null)
     {
        retail = [select id,Latest_Sales_Person__c,Guarantor1_ZipCode__c,recordtype.Name,Contractor_Name__c,Related_Dealer__c,Related_Dealer__r.Dealer_GC_Code__c,Contractor_Name_Native__c,Vehicle_Registration_No__c,Contractor_ZipCode1__c,Contractor_Address1__c,MOT_User_Name__c,MOT_User_Name_Native__c,MOT_User_Postal__c,MOT_User_Address__c,MOT_User_Phone__c,MOT_Owner_Name__c,MOT_Owner_Name_Native__c,MOT_Owner_Address__c from Retail_Task__c WHERE ID = :alkID];
      if(retail !=null && retail.recordtype.Name=='Contract' && us1.ContactId !=null)
       {
       MotuserName=retail.MOT_User_Name__c;
       
       AddressActual=retail.Contractor_Address1__c;
      
       MotuserNameNative=retail.MOT_User_Name_Native__c;
       
       MotuserAddress=retail.MOT_User_Address__c;
      
       MotownerName=retail.MOT_Owner_Name__c;
       
       MotuserPostal=retail.MOT_User_Postal__c;
       
       MotuserPhone=retail.MOT_User_Phone__c;
       
       MotuserownerNameNative=retail.MOT_Owner_Name_Native__c;
       
       MotOwnerAddress=retail.MOT_Owner_Address__c ;
       }
       }
        system.debug('Testing');
           displayRetail= [select Latest_Sales_Person__c,Guarantor1_ZipCode__c,Related_Dealer__c,Contractor_Name__c,Contractor_Name_Native__c,Vehicle_Registration_No__c,Contractor_ZipCode1__c,Contractor_Address1__c,MOT_User_Name__c,MOT_User_Name_Native__c,MOT_User_Postal__c,MOT_User_Address__c,MOT_User_Phone__c,MOT_Owner_Name__c,MOT_Owner_Name_Native__c,MOT_Owner_Address__c from Retail_Task__c where id=:alkId and recordtype.Name='Contract'];
            system.debug('Testing+displayRetail'+displayRetail);

        }    
    }
}