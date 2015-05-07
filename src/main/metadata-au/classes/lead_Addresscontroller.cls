public class lead_Addresscontroller{
//Variable declaration
public static list<lead__c> leadList=new list<lead__c>();
public static list<Address__c> addresslist=new list<Address__c>();
public static boolean Preferred{get;set;}
public static Id AccountId;

//Constructor Called to get the current account record id
   public lead_Addresscontroller(ApexPages.StandardController controller) {
         Preferred=true;
         if(ApexPages.currentPage().getParameters().get('id')!=Null)
          {
              leadList=[select id,Company_Account__c,Home_Phone__c,Work_Phone__c,Email__c,Mobile__c from Lead__c where id=:ApexPages.currentPage().getParameters().get('id')];  
              if(leadList!=Null){
                for(Lead__c led:leadList){
                      if(led.Company_Account__c!=Null)
                        AccountId=led.Company_Account__c;
                    }  
                }          
              addresslist=[select id,Name,Customer__c,Preferred__c,Address_Type__c,Address_Line_1__c,Address_Line_2__c,Country__c,ZipCode__c,Province__c,Status__c,District__c 
                            from Address__c Where Customer__c=:AccountId AND Preferred__c=:true Limit 1]; 
             if(addresslist!=Null && !addresslist.isEmpty()){             
                 Preferred=false; }                               
          }
        }
        
  public Address__c getaddressList_details() {   
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
}