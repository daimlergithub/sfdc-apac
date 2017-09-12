/*
The below is a template to highlight the key functionalities on a CDM Services 
These methods can be overwritten by respective country and can change accordingly.
*/
public abstract class CDMServices{

    public virtual string searchCustomerOnCDM(String method, String endpoint, Integer timeout, Map<String,String> headerKeyByValue, String status){return null;}
    public virtual void createCustomerCDM(){}
    public virtual void createRetailCopy(){}
   
}