public class UserTriggerCallout {

    @future(callout = true)
    public static void syncUser(String userId, String userName, String email, String phone, String role, String profile) {
        RuishiWebService.RuishiWebServerSoap rws = new RuishiWebService.RuishiWebServerSoap();

		rws.CreateUser(userId, userName, email, phone, role, profile);
    }
    
}