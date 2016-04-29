public class AccountConatctcontroller{
    //Variable declaration
    public static list<Account> contactList=new list<Account>();
    public Account accountList_details{get;set;}
    public boolean displayPopup {get; set;}  
    public String selectedUserName{get; set;}   
    Public User usrInfolst{get;set;} 
    private ApexPages.StandardController stdController;
    public String LastModifiedby{get;set;} 
    public String LastModifieddate{get;set;} 
    public String FSLastModifiedby{get;set;}
    public date FSLastModifieddate{get;set;}  
    public String redirectUrl {public get; public set;}
    public Boolean shouldRedirect {public get; private set;}
    public String accountid{get;set;}
    public boolean isnoerror{get;set;}
    public string marketDiscriminator{get;set;}
    //Constructor Called to get the current account record id
    public AccountConatctcontroller(ApexPages.StandardController stdController) {    
        accountList_details= new Account();
        this.stdController = stdController;
        isnoerror=false;
        shouldRedirect = false;
        accountid=ApexPages.currentPage().getParameters().get('id');
        Account accObj = [Select MD__c FROM Account where Id =:accountid];        
        marketDiscriminator = accObj.MD__c;
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
                         Preferred_Work_Phone_1__c,Preferred_Work_Phone_2__c,Phone,IsPersonAccount
                         from Account Where Id=:ApexPages.currentPage().getParameters().get('id') Limit 1]; 
            
        }
        if(contactList!=Null && !contactList.isEmpty())         
            accountList_details=contactList[0];        
        
    }
    // public Account getaccountList_details (){ return null;}  
    public pagereference updateAccount(){ 
        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
        if(accountList_details!=null && profileName != 'IntegrationAPI')
        {
            
            if(string.valueOf(accountList_details.Mobile__c) != null && string.valueOf(accountList_details.Mobile__c) != '')
            {
                if(!(string.valueof(accountList_details.Mobile__c).trim().replaceAll('(\\s+)', '').startsWith('+614') || string.valueof(accountList_details.Mobile__c).trim().replaceAll('(\\s+)', '').startsWith('+615')  ||string.valueof(accountList_details.Mobile__c).trim().replaceAll('(\\s+)', '').startsWith('04') || string.valueof(accountList_details.Mobile__c).trim().replaceAll('(\\s+)', '').startsWith('05')))
                {
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Mobile number should begin with any one of these values +614, 04, +615, 05'));
                    isnoerror=false;
                    return null;
                }
                
                String errorMsg = validatePhoneNumberFields(string.valueof(accountList_details.Mobile__c));                         
                if(errorMsg != null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,errorMsg));
                    isnoerror=false;
                    return null;
                }
                
            }
            
            if(string.valueOf(accountList_details.Mobile2__c) != null && string.valueOf(accountList_details.Mobile2__c) != '')
            {
                if(!(string.valueof(accountList_details.Mobile2__c).trim().replaceAll('(\\s+)', '').startsWith('+614') || string.valueof(accountList_details.Mobile2__c).trim().replaceAll('(\\s+)', '').startsWith('+615')  ||string.valueof(accountList_details.Mobile2__c).trim().replaceAll('(\\s+)', '').startsWith('04') || string.valueof(accountList_details.Mobile2__c).trim().replaceAll('(\\s+)', '').startsWith('05')))
                {
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Mobile number should begin with any one of these values +614, 04, +615, 05'));
                    isnoerror=false;
                    return null;
                }
                String errorMsg = validatePhoneNumberFields(string.valueof(accountList_details.Mobile2__c));                         
                if(errorMsg != null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,errorMsg));
                    isnoerror=false;
                    return null;
                }
                
            }
            
            
            if(string.valueOf(accountList_details.Individual_Home_Phone__c) != null && string.valueOf(accountList_details.Individual_Home_Phone__c) != '')
            {
                
                String errorMsg = validatePhoneNumberFields(string.valueof(accountList_details.Individual_Home_Phone__c)); 
                if(errorMsg != null)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,errorMsg));
                    isnoerror=false;
                    return null;
                }
                
            }
            
            if(string.valueOf(accountList_details.Home_Phone_2__c) != null && string.valueOf(accountList_details.Home_Phone_2__c) != '')
            {
                
                String errorMsg = validatePhoneNumberFields(string.valueof(accountList_details.Home_Phone_2__c));
                
                if(errorMsg != null)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,errorMsg));
                    isnoerror=false;
                    return null;
                }
                
            }
            
            if(string.valueOf(accountList_details.Work_Phone__c) != null && string.valueOf(accountList_details.Work_Phone__c) != '')
            {
                
                String errorMsg = validatePhoneNumberFields(string.valueof(accountList_details.Work_Phone__c));                         
                if(errorMsg != null)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,errorMsg));
                    isnoerror=false;
                    return null;
                }
                
                
            }
            
            if(string.valueOf(accountList_details.Phone) != null && string.valueOf(accountList_details.Phone) != '')
            {
                
                String errorMsg = validatePhoneNumberFields(string.valueof(accountList_details.Phone));                         
                if(errorMsg != null)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,errorMsg));
                    isnoerror=false;
                    return null;
                }
                
            }
            try
            {
                update accountList_details;                 
                isnoerror=true;             
            }           
            catch(DMLException de)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,de.getDmlMessage(0)));
                isnoerror=false;
            }
            return null;
        }   
        return null;
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
    
    public static String ValidatePhoneNumberFields(String PhoneNum)
    {
        if((string.valueof(PhoneNum).startsWith('0') && (string.valueof(PhoneNum).trim().replaceAll('(\\s+)', '').length() > 10 || string.valueof(PhoneNum).trim().replaceAll('(\\s+)', '').length() < 8 ) ))
            return 'Number of digits in Phone Number should be more than 8 or less than 10 if it starts with 0';
        else if(string.valueof(PhoneNum).startsWith('+61') && string.valueof(PhoneNum).trim().replaceAll('(\\s+)', '').length() != 12)
            return 'The phone Number record needs to have only 12 digits if it starts with +61';
        else if((string.valueof(PhoneNum).startsWith('1300') || string.valueof(PhoneNum).startsWith('1800')) && string.valueof(PhoneNum).trim().replaceAll('(\\s+)', '').length() != 10 )
            return 'The The phone Number record needs to have only 10 digits if it starts with 1800 or 1300';
        else if((string.valueof(PhoneNum).startsWith('13') && !string.valueof(PhoneNum).startsWith('1300')) && string.valueof(PhoneNum).trim().replaceAll('(\\s+)', '').length() != 6)
            return 'The Phone Number record needs to have only 6 digits if it starts with 13';
        else 
            return null; 
    }
    
   
}