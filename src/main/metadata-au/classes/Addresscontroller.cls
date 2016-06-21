public class Addresscontroller{
//Variable declaration
public static list<Address__c> addresslist=new list<Address__c>();
public static boolean Preferred{get;set;}
public static string marketdiscriminator{get;set;}

//Constructor Called to get the current account record id
   public Addresscontroller(ApexPages.StandardController controller) {
        Preferred=true;
         if(ApexPages.currentPage().getParameters().get('id')!=Null)
          {
              addresslist=[select id,Name,Customer__c,Company_Name__c,MD__c,Preferred__c,City__c,Address_Type__c,Address_Line_1__c,Address_Line_2__c,Country__c,ZipCode__c,Province__c,Status__c,District__c 
                          from Address__c Where Customer__c=:ApexPages.currentPage().getParameters().get('id') AND Preferred__c=:true Limit 1]; 
             if(addresslist!=Null && !addresslist.isEmpty())
             {   
                 marketdiscriminator = addresslist.get(0).MD__c ;
                 Preferred=false; 
             }                               
          }
        }
        
  public Address__c getaddressList_details() {   
          if(addresslist!=Null && !addresslist.isEmpty())         
            return addresslist[0];        
          else
            return new Address__c();          
      }
       
}