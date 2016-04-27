public class lead_Addresscontroller{
//Variable declaration
public static list<lead__c> leadList = new list<lead__c>();
public static lead__c lead;
public Address__c addr {get;set;}
public static list<Address__c> addresslist = new list<Address__c>();
public static list<Address__c> upsertaddresslist= new list<Address__c>();
public static list<Account> companyList = new list<Account>();    
public static boolean Preferred{get;set;}
public static Id AccountId;
public static id ContactId; 
public string mobileNum{get; set;}
public string recordtypeid{get; set;}
public string marketdiscriminator{get; set;}    
public string homePhone{get ; set;}
public string companyname{get ; set;}
public string workPhone{get; set;}
public string email{get; set;}
public string zipcode{get; set;}
public string city{get; set;}
public string addressline1{get; set;}
public string addressline2{get; set;}
public string suburb{get; set;}
public string addstate{get; set;}
public string postcode{get; set;}
public static list<Account> updateAccountList = new list<Account>();   
//Constructor Called to get the current account record id
   public lead_Addresscontroller(ApexPages.StandardController controller) {
         Preferred=true;
         addr = new Address__c();
         if(ApexPages.currentPage().getParameters().get('id')!=Null)
          {
                            
              leadList=[select id,RecordtypeId,RecordType.developername,contact__c,contact__r.Mobile__c,contact__r.Mobile2__c,contact__r.Individual_Home_Phone__c,contact__r.Home_Phone_2__c,contact__r.Email__c,contact__r.Email2__c,contact__r.Work_Phone__c,contact__r.Zipcode__c,
                        Company_Account__c,Company_Account__r.Mobile__c,Company_Account__r.Mobile2__c,Company_Account__r.Individual_Home_Phone__c,Company_Account__r.Home_Phone_2__c,Company_Account__r.Email__c,Company_Account__r.Email2__c,Company_Account__r.Work_Phone__c,Company_Account__r.Zipcode__c,
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
                 if(led.contact__r.Zipcode__c!= Null)                     
                   zipcode =led.contact__r.Zipcode__c;
                 else
                   zipcode =led.Company_Account__r.Zipcode__c ;                                                                        
        	  recordtypeid = leadList.get(0).RecordType.developername;
                    system.debug(')@$$#$%$#%$#%'+recordtypeid);
              addresslist=[select id,Name,Customer__c,MD__c,Preferred__c,city__c,Address_Type__c,Company_Name__c,Address_Line_1__c,Address_Line_2__c,Country__c,ZipCode__c,Province__c,Status__c,District__c 
                            from Address__c Where Customer__c=:AccountId AND Preferred__c=:true Limit 1]; 
             if(addresslist!=Null && !addresslist.isEmpty())
             {
                 marketdiscriminator = addresslist.get(0).Md__c;
                 addr.id =  addresslist.get(0).id;
                 addr.Address_Type__c = addresslist.get(0).Address_Type__c;
                 addressline1 = addresslist.get(0).Address_Line_1__c;
                 addressline2 = addresslist.get(0).Address_Line_2__c;
                 suburb = addresslist.get(0).District__c;
                 city = addresslist.get(0).city__c;
                 addr.Province__c = addresslist.get(0).Province__c;
              	 companyname = addresslist.get(0).Company_Name__c;
              	 addr.Country__c = addresslist.get(0).Country__c;
              	 addr.Status__c = addresslist.get(0).Status__c;
                 postcode = addresslist.get(0).ZipCode__c;        
                
             }
           }  
        }  
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
/* public String getMobileNum(){
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
              leadList=[select id,contact__c,contact__r.Mobile__c,contact__r.Mobile2__c,contact__r.Individual_Home_Phone__c,contact__r.Home_Phone_2__c,contact__r.Email__c,contact__r.Email2__c,contact__r.Work_Phone__c,contact__r.Zipcode__c,
                        Company_Account__c,Company_Account__r.Mobile__c,Company_Account__r.Mobile2__c,Company_Account__r.Individual_Home_Phone__c,Company_Account__r.Home_Phone_2__c,Company_Account__r.Email__c,Company_Account__r.Email2__c,Company_Account__r.Work_Phone__c,Company_Account__r.Zipcode__c,
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
                         acc.ZipCode__c = zipcode;
                         updateAccountList.add(acc);
                     }
                     system.debug('##########'+updateAccountList);                     
                    
                     addresslist=[select id,Name,Customer__c,Preferred__c,Address_Type__c,Address_Line_1__c,Address_Line_2__c,Country__c,ZipCode__c,Province__c,Status__c,District__c from Address__c Where Customer__c=:AccountId AND Preferred__c=:true Limit 1];
                      
                     system.debug(addr.Province__c + '   %&&&%^&^%&'+addresslist);
                    if(addresslist!= null && !addresslist.isEmpty())
                    {                       
                        Address__c add = new Address__c();
                        add.id = addresslist.get(0).id;
                        add.Customer__c = AccountId;
                        add.Address_Line_1__c = addressline1 ;
                        add.District__c = suburb ;
                        add.Province__c = addr.Province__c;
                        add.ZipCode__c = postcode;
                        upsertaddresslist.add(add);
                        system.debug('Address line1'+addressline1);
                        system.debug('Address Id'+addresslist.get(0).id); 
                            if(upsertaddresslist.get(0).id != null)
                        {
                             update upsertaddresslist;
                        }                                               
                    } 
                   
                    if(addresslist.isEmpty())
                    {
                        Address__c add = new Address__c();
                        add.Customer__c = AccountId;
                        add.Address_Line_1__c = addressline1 ;
                        add.District__c = suburb ;
                        add.Province__c = addr.Province__c;
                        add.ZipCode__c = postcode;
                        upsertaddresslist.add(add);
                        try
                     {
                         if(upsertaddresslist != null && !upsertaddresslist.isEmpty())
                         {
                             insert upsertaddresslist;
                         }
                     }
                     catch(DMLException ex)
                     {
                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, ex.getDMLMessage(0)));            
                     }      
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
    
    Public Pagereference UpdateAddress(){
    	update addr;
        return null;
    }
         
      
}