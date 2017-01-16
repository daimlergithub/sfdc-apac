public class usernotify
{
public Retail_Task__c retail{get;set;}
public User us1;

public void userDetails(){

retail = [select id,Latest_Sales_Person__c,Contractor_Name__c,Contractor_Name_Native__c,Vehicle_Registration_No__c,Contractor_ZipCode1__c,Contractor_Address1__c,MOT_User_Name__c,MOT_User_Name_Native__c,MOT_User_Postal__c,MOT_User_Address__c,MOT_User_Phone__c,MOT_Owner_Name__c,MOT_Owner_Name_Native__c,MOT_Owner_Address__c, Account__r.Dealer_GC_Code__c from Retail_Task__c WHERE ID = :ApexPages.currentPage().getParameters().get('id')];
us1 = [select id, Dealer_GC_Code__c,User_Type__c from User WHERE Id =:UserInfo.getUserId()];
}

public usernotify(ApexPages.StandardController controller) {
    userDetails();
    if((us1.User_Type__c=='MBJ'||us1.User_Type__c == 'MBF') && (retail.Account__r.Dealer_GC_Code__c == us1.Dealer_GC_Code__c))
        {
           retail=[select Latest_Sales_Person__c,Contractor_Name__c,Contractor_Name_Native__c,Vehicle_Registration_No__c,Contractor_ZipCode1__c,Contractor_Address1__c,MOT_User_Name__c,MOT_User_Name_Native__c,MOT_User_Postal__c,MOT_User_Address__c,MOT_User_Phone__c,MOT_Owner_Name__c,MOT_Owner_Name_Native__c,MOT_Owner_Address__c from Retail_Task__c where recordtype.Name='Contract'];
           
        }    
    }
}