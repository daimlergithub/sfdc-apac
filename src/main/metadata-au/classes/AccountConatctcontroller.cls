public class AccountConatctcontroller{
//Variable declaration
public static list<Account> contactList=new list<Account>();
public Account accountList_details{get;set;}
public boolean displayPopup {get; set;}  
public String selectedUserName{get; set;}   
Public User usrInfolst{get;set;} 

public String LastModifiedby{get;set;} 
public String LastModifieddate{get;set;} 
public String FSLastModifiedby{get;set;}
public date FSLastModifieddate{get;set;}  
//Constructor Called to get the current account record id
   public AccountConatctcontroller(ApexPages.StandardController controller) {    
          accountList_details= new Account();     
         if(ApexPages.currentPage().getParameters().get('id')!=Null)
          {
              contactList=[select id,Mobile__c,Mobile_Status__c,Mobile2__c,SMS_MMS_IM_Status_2__c,PersonHomePhone,Individual_Home_Phone__c,Individual_Home_Phone_Status__c,Home_Phone_Status_2__c,Home_Phone_2__c,
                            Work_Phone__c,Work_Phone_Status__c,Work_Phone_Status_2__c,Email__c,Email2__c,Email_Status__c,Email_Status_2__c,Opt_In_SMS__c,Opt_In_SMS2__c,Opt_In_Home_Phone__c,Opt_In_Home_Phone2__c,
                            Opt_In_Work_Phone__c,Opt_In_Work_Phone2__c,Opt_In_Email__c,Opt_In_Email2__c,FS_Opt_In_SMS__c,FS_Opt_In_SMS2__c,FS_Opt_In_Home_Phone__c,FS_Opt_In_Home_Phone2__c,FS_Opt_In_Work_Phone__c,
                            FS_Opt_In_Work_Phone2__c,FS_Opt_In_Email__c,FS_Opt_In_Email2__c,                                                         
                            FS_SMS_Last_Modified_By__c,FS_SMS_Last_Modified_Date__c,
                            FS_SMS_Last_Modified_By2__c,FS_SMS_Last_Modified_Date2__c,                            
                            FS_Home_Phone_Last_Modified_By__c,FS_Home_Phone_Last_Modified_Date__c,
                            FS_Home_Phone_Last_Modified_By2__c,FS_Home_Phone_Last_Modified_Date2__c,
                            FS_Work_Phone_Last_Modified_By__c,FS_Work_Phone_Last_Modified_Date__c,
                            FS_Work_Phone_Last_Modified_By2__c,FS_Work_Phone_Last_Modified_Date2__c,
                            FS_Email_Last_Modified_By__c,FS_Email_Last_Modified_Date__c,
                            FS_Email_Last_Modified_By2__c,FS_Email_Last_Modified_Date2__c,
                            SMS_Last_Modified_By__c,SMS_Last_Modified_Date__c,SMS_Last_Modified_By2__c,SMS_Last_Modified_Date2__c,
                            Home_Phone_Last_Modified_By__c,Home_Phone_Last_Modified_Date__c,Home_Phone_Last_Modified_By2__c,
                            Home_Phone_Last_Modified_Date2__c,Work_Phone_Last_Modified_By__c,Work_Phone_Last_Modified_Date__c,
                            Work_Phone_Last_Modified_By2__c,Work_Phone_Last_Modified_Date2__c,Email_Last_Modified_By__c,
                            Email_Last_Modified_Date__c,Email_Last_Modified_By2__c,Email_Last_Modified_Date2__c,LastModifiedById,LastModifiedDate,
                            Preferred_Email_1__c,Preferred_Email_2__c,Preferred_Mobile_1__c,Preferred_Mobile_2__c,Preferred_Home_Phone_1__c,Preferred_Home_Phone_2__c,
                            Preferred_Work_Phone_1__c,Preferred_Work_Phone_2__c,Phone 
                            from Account Where Id=:ApexPages.currentPage().getParameters().get('id') Limit 1]; 
                                            
          }
         if(contactList!=Null && !contactList.isEmpty())         
            accountList_details=contactList[0];        
          
        }
   // public Account getaccountList_details (){ return null;}  
    public pagereference updateAccount(){ 
           if(accountList_details!=null)
                update accountList_details;   
                pageReference pr = new pagereference('/'+ApexPages.currentPage().getParameters().get('id'));       
                pr.setRedirect(true);     
                return pr;  
        }
       
    public void closePopup() 
    {
        displayPopup = false;    
        if(usrInfolst!=Null)
        {
           usrInfolst.clear(); 
        } 
    }     
    public void showPopup() { 
        userInfo();              
        displayPopup = true; 
    } 
    public void userInfo(){
      for(User usr:[Select id,Name,title from User])
      {
        if(usr.Name==selectedUserName)
        {
          usrInfolst=[select id,Name,Title from User where id=:usr.Id];     
        }
      }     
     } 
}