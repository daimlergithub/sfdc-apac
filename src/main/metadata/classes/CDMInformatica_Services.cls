/*------------------------------------------------------------
    Author:        Pavan Kumar D
    Company:       Infosys
    Description:   Generic service to callout informatica for CDM purposes
    History
    <Date>      <Authors Name>     <Brief Description of Change> 
    
    Pattern followed:  Separation of Concerns 
                
     Purpose:   This class will be the gateway to interface with CDM
                 Also, deminstrated the    Event logging framework
    
   This class follows the service layer which is part of the SOC and also addresses
   the CDM Informatica Services in place with an handle to leverage the Application error logging framework
    ------------------------------------------------------------*/
public Class CDMInformatica_Services extends CDMServices{


     
    public override string searchCustomerOnCDM(String method, String endpoint, Integer timeout, Map<String,String> headerKeyByValue, String status)
    {
        
        try{
            HttpResponse res = CalloutHandlerService.sendCallout(method,endpoint, timeout,headerKeyByValue,status);
        	return CalloutHandlerService.processCalloutResponse(res, null);
           
        }
        
        catch(Exception e)
        {
            //generic exception if not caught above would be handled and application logger would be invoked
            return null;
        }
    }
    

     
}