public class UserTriggerCallout {
	
	 /**    
     * @Description : calls webService class and passes user parameters to create a user in Third party system.
     * @author      : 
     * @Date        : 
     * @param       : gets the user detals as parameters.
     * @return      : returns user detals as parameters to RuishiWebService.RuishiWebServerSoap.CreateUser.
     * @see         : 
    **/	

    @future(callout = true)
    public static void syncUser(String userId, String userName, String email, String phone, String role, String profile) {
if(!Test.isRunningtest())
{ 
        RuishiWebService.RuishiWebServerSoap rws = new RuishiWebService.RuishiWebServerSoap();
        rws.CreateUser(userId, userName, email, phone, role, profile);
    }
}    
}