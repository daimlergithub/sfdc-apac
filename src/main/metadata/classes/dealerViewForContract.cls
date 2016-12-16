public class dealerViewForContract
{
public Retail_Task__c retail{get;set;}
public Retail_Task__c displayRetail{get;set;}
public User us1;
public String alkID{get;set;}



   public dealerViewForContract(ApexPages.StandardController controller) {
     retail=new Retail_Task__c ();
     displayRetail=new Retail_Task__c ();
    alkID=ApexPages.currentPage().getParameters().get('id');
     if(alkID!=null)
     {
        retail = [select id,Latest_Sales_Person__c,Contractor_Name__c,Contractor_Name_Native__c,Vehicle_Registration_No__c,Contractor_ZipCode1__c,Contractor_Address1__c,MOT_User_Name__c,MOT_User_Name_Native__c,MOT_User_Postal__c,MOT_User_Address__c,MOT_User_Phone__c,MOT_Owner_Name__c,MOT_Owner_Name_Native__c,MOT_Owner_Address__c, Account__r.Dealer_GC_Code__c from Retail_Task__c WHERE ID = :alkID];
       }
        us1 = [select id, Dealer_GC_Code__c,User_Type__c from User WHERE Id =:UserInfo.getUserId()];
   
    if((us1.User_Type__c=='MBJ'||us1.User_Type__c == 'MBF') && (retail.Account__r.Dealer_GC_Code__c == us1.Dealer_GC_Code__c) && retail!=null)
        {
           displayRetail=[select Latest_Sales_Person__c,Contractor_Name__c,Contractor_Name_Native__c,Vehicle_Registration_No__c,Contractor_ZipCode1__c,Contractor_Address1__c,MOT_User_Name__c,MOT_User_Name_Native__c,MOT_User_Postal__c,MOT_User_Address__c,MOT_User_Phone__c,MOT_Owner_Name__c,MOT_Owner_Name_Native__c,MOT_Owner_Address__c from Retail_Task__c where recordtype.Name='Contract'];
           
        }    
    }
    
    
}