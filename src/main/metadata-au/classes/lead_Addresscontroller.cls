public class lead_Addresscontroller{
//Variable declaration
public static list<lead__c> leadList = new list<lead__c>();
public static lead__c lead;
public static list<Address__c> addresslist=new list<Address__c>();
public static list<Account> companyList = new list<Account>();    
public static boolean Preferred{get;set;}
public static Id AccountId;
public static id ContactId;
public string mobileNum{get; set;}
public string homePhone{get ; set;}
public string workPhone{get; set;}
public string email{get; set;}  
public static list<Account> updateAccountList = new list<Account>();   
//Constructor Called to get the current account record id
   public lead_Addresscontroller(ApexPages.StandardController controller) {
         Preferred=true;
         if(ApexPages.currentPage().getParameters().get('id')!=Null)
          {
              leadList=[select id,contact__c,contact__r.Mobile__c,contact__r.Mobile2__c,contact__r.Individual_Home_Phone__c,contact__r.Home_Phone_2__c,contact__r.Email__c,contact__r.Email2__c,contact__r.Work_Phone__c,
                        Company_Account__c,Company_Account__r.Mobile__c,Company_Account__r.Mobile2__c,Company_Account__r.Individual_Home_Phone__c,Company_Account__r.Home_Phone_2__c,Company_Account__r.Email__c,Company_Account__r.Email2__c,Company_Account__r.Work_Phone__c,
                        Home_Phone__c,Work_Phone__c,Email__c,Mobile__c 
                        from Lead__c where id=:ApexPages.currentPage().getParameters().get('id')];  
              if(leadList!=Null){
                for(Lead__c led:leadList){
                      if(led.contact__c!=Null)
                        AccountId=led.contact__c;
                      else
                                            AccountId=led.Company_Account__c;
                                                
                     if(led.contact__r.Mobile__c != Null)
                   mobileNum = led.contact__r.Mobile__c;
                else if (led.contact__r.Mobile2__c != null)
                   mobileNum = led.contact__r.Mobile2__c;
                else if (led.Company_Account__r.Mobile__c != null )
                   mobileNum = led.Company_Account__r.Mobile__c;
                else 
                   mobileNum = led.Company_Account__r.Mobile2__c ;
                
                if(led.contact__r.Individual_Home_Phone__c != Null)
                   homePhone = led.contact__r.Individual_Home_Phone__c;
                else if (led.contact__r.Home_Phone_2__c != null)
                   homePhone = led.contact__r.Home_Phone_2__c;
                else if (led.Company_Account__r.Individual_Home_Phone__c != null )
                   homePhone = led.Company_Account__r.Individual_Home_Phone__c;
                else 
                   homePhone = led.Company_Account__r.Home_Phone_2__c;
                
               if(led.contact__r.Work_Phone__c != Null)
                   workPhone = led.contact__r.Work_Phone__c;
                else 
                   workPhone = led.Company_Account__r.Work_Phone__c;
                
                
                 if(led.contact__r.Email__c != Null)
                   email = led.contact__r.Email__c;
                else if (led.contact__r.Email2__c != null)
                   email = led.contact__r.Email2__c;
                else if (led.Company_Account__r.Email__c != null )
                   email = led.Company_Account__r.Email__c;
                else 
                   email = led.Company_Account__r.Email2__c;
                    
                      
                    }  
                }          
              addresslist=[select id,Name,Customer__c,Preferred__c,Address_Type__c,Address_Line_1__c,Address_Line_2__c,Country__c,ZipCode__c,Province__c,Status__c,District__c 
                            from Address__c Where Customer__c=:AccountId AND Preferred__c=:true Limit 1]; 
             if(addresslist!=Null && !addresslist.isEmpty()){             
                 Preferred=false; }
       
          }
        }
   
  public Address__c getaddressList_details()
 {   
          if(addresslist!=Null && !addresslist.isEmpty())         
            return addresslist[0];        
          else
            return new Address__c();          
      }
  public Lead__c getlead_List() {   
          if(leadList!=Null && !leadList.isEmpty())         
            return leadList[0];        
          else
            return new Lead__c();          
      } 
 /*   public String getMobileNum(){
        if(MobileNum != null && MobileNum !='' )
            return MobileNum;
      else 
          return null;
    }  

public String gethomePhone(){
        if(homePhone != null && homePhone !='' )
            return homePhone;
      else 
          return null;
    }      

public String getworkPhone(){
        if(workPhone != null && workPhone !='' )
            return workPhone;
      else 
          return null;
    }  
 
    public String getemail(){
        if(email != null && email !='' )
            return email;
      else 
          return null;
    }*/  
    
    public pagereference Save()
    { 
              system.debug('Test*$*$*$*$* ');
              leadList=[select id,contact__c,contact__r.Mobile__c,contact__r.Mobile2__c,contact__r.Individual_Home_Phone__c,contact__r.Home_Phone_2__c,contact__r.Email__c,contact__r.Email2__c,contact__r.Work_Phone__c,
                        Company_Account__c,Company_Account__r.Mobile__c,Company_Account__r.Mobile2__c,Company_Account__r.Individual_Home_Phone__c,Company_Account__r.Home_Phone_2__c,Company_Account__r.Email__c,Company_Account__r.Email2__c,Company_Account__r.Work_Phone__c,
                        Home_Phone__c,Work_Phone__c,Email__c,Mobile__c 
                        from Lead__c where id=:ApexPages.currentPage().getParameters().get('id')];
               system.debug('Test123 *$*$*$*$* '+leadList);         
             if(leadList != Null && !leadList.isEmpty())
             {
                for(Lead__c led:leadList)
                {
                    if(led.contact__c!=Null)
                     {
                       AccountId = led.contact__c;
                     }
                     else
                     {
                      AccountId = led.Company_Account__c;
                     }
                     if(AccountId != null)
                     {
                         Account acc = new Account(Id = AccountId);
                         acc.Individual_Home_Phone__c = homePhone;
                         acc.Work_Phone__c = workPhone;
                         acc.Email__c = email;
                         acc.Mobile__c = mobileNum;
                         updateAccountList.add(acc);
                     }
                }
             }
             try
             {
                 if(updateAccountList != null && !updateAccountList.isEmpty())
                 {
                     update updateAccountList;
                 }
             }
             catch(DMLException ex)
             {
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, ex.getDMLMessage(0)));            
             }
       return null;
   } 
         
      
}