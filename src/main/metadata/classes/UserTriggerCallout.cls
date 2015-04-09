public class UserTriggerCallout {

    @future(callout = true)
    public static void syncUser(String userId, String userName, String email, String phone, String role, String profile) {
        RuishiWebService.RuishiWebServerSoap rws = new RuishiWebService.RuishiWebServerSoap();
        try{
            Boolean result = rws.CreateUser(userId, userName, email, phone, role, profile);
            //System.debug('-------------Ruishi Callout Result:------------->' + result);
        }catch(Exception ex){
            //System.debug('------Ruishi Callout Errors:------->' + ex.getMessage());
        }
    }
    
}