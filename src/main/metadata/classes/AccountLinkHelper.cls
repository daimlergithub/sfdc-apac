/**
** This class is a Helper functionality 
** 
** Created By: 
** Date: 
** Modified By : 
** Modified date : 27-oct-2015
**/

public class AccountLinkHelper
{

/**	
* @Description  This method is for parsing crmCode
* @author  
* @Date (mm/dd/yy)
* @param  Maps the crm code of a retail task record to dealers using the crm code.
* @return returns crm codes
* @see   AccountLinkSharingWrapService, UserService, VehicleSharingWrapService
*/ 	 
	public static string nameParsing(string name)
    {
    	String crmCode;
        if(name!=null && name.indexOf('DMS-') > -1)
        {
            name = name.substring(name.indexOf('DMS-'));
            crmCode = name.substring(name.lastIndexOf('-') - 2, name.lastIndexOf('-'));
        }
        return crmCode;    
    }
}