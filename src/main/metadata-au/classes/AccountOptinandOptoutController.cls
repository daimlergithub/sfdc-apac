public class AccountOptinandOptoutController
{
    public id AccountId=ApexPages.currentPage().getParameters().get('Id');
    public Address__c objAddress {get;set;}
    public boolean isShow{get;set;}
    public AccountOptinandOptoutController(ApexPages.StandardController controller) 
    {
        objAddress= new Address__c();
        if(AccountId!=null)
        {
            List<Address__c> lstAddress=[Select id,Customer__c,Address_Type__c,Address_Line_1__c,Address_Line_2__c,Country__c,ZipCode__c,Preferred__c,Province__c,Status__c,District__c,Opt_In_Hardcopy__c,
                                                FS_Hardcopy_Last_Modified_By__c,FS_Hardcopy_Last_Modified_Date__c,FS_Opt_In_Hardcopy__c,Hardcopy_Last_Modified_By__c,Hardcopy_Last_Modified_Date__c
                                                from Address__c where Customer__c=:AccountId AND Preferred__c=true limit 1];
            if(lstAddress!=null && !lstAddress.isEmpty())
            {                                
               objAddress=lstAddress[0]; 
               isShow=true;
            }
        }
    }

    public pagereference updateAddress()
    {
        if(objAddress.Id!=null)
            update objAddress;
        pageReference pr = new pagereference('/'+AccountId);    
        pr.setRedirect(true);
        return pr; 
    }
}