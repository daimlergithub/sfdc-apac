/*
    Type:      Extension Controller(Account) for VF page -ContactTable
    ---------------------------------------------------------------
    
    
    26-10-2015 Created by Narasimha Gundurao
*/

public class ContactTableController 
{
    /* Variables Declaration */ 
    private ApexPages.StandardController stdController;
    public boolean editMode {get; set;} 
    public string AccId {get; set;}
    public Account ParAcc {get; set;}
    
    /**
  *@Description : Constructor.
  *@Date : 26/10/2015
  *@param:Apexpages Standard Controller (Account)
  *@return:This mehtod does not return any value.

  */ 
    public  ContactTableController(ApexPages.StandardController stdController)
    {
        editMode = false;
        AccId = stdController.getId();
         
        stdController.addFields(new List<String> {'Id','Mobile__c','Mobile2__c','Individual_Home_Phone__c',
            'Home_Phone_2__c','Work_Phone__c','Phone','Email__c','Email2__c','Email3__c','Fax2__c',
            'Fax','Fax_Validity2__c','Fax_Validity__c','Email_Status__c','Email_Status_2__c','Email_Status_3__c',
            'Work_Phone_Status__c','Work_Phone_Status_2__c','Individual_Home_Phone_Status__c','Home_Phone_Status_2__c' ,
            'Mobile_Status__c','SMS_MMS_IM_Status_2__c','Email_Last_Modified_By__c','Email_Last_Modified_By2__c',
            'Email_Last_Modified_By3__c','Work_Phone_Last_Modified_By__c','Work_Phone_Last_Modified_By2__c','Home_Phone_Last_Modified_By__c',
            'Home_Phone_Last_Modified_By2__c','SMS_Last_Modified_By__c','SMS_Last_Modified_By2__c','SMS_Last_Modified_Date__c',
            'SMS_Last_Modified_Date2__c','Home_Phone_Last_Modified_Date__c','Home_Phone_Last_Modified_Date2__c','Work_Phone_Last_Modified_Date__c',
            'Work_Phone_Last_Modified_Date2__c','Email_Last_Modified_Date__c','Email_Last_Modified_Date2__c','Email_Last_Modified_Date3__c'});
        
        ParAcc = (Account)stdController.getRecord();
        
    }
    
    public void EditAccount()
     /**
  *@Description : This method makes editMode true which allows the user to input values to the phone numbers  and email fields.
  *@Date : 26/10/2015
  *@param: None
  *@return:This mehtod does not return any value.

  */ 
    {
        editMode = true;
    }
    
    public void UpdateAccount()
    
     /**
  *@Description : This method updates the Account with the values entered by user to phone number and email fields.
  *@Date : 26/10/2015
  *@param: None
  *@return:This mehtod does not return any value.

  */ 
    {
        try
        {
            if(ParAcc != null)
                update ParAcc;
        }
        
        catch(DMLException de)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,de.getDmlMessage(0)));
            
        }
    }
    
    public void CancelUpdate()
    /**
  *@Description : This method Makes Edit mode false.
  *@Date : 26/10/2015
  *@param: None
  *@return:This mehtod does not return any value.

  */ 
    {
        editMode = false; 
        
    }
    
}