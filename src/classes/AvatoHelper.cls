/*
    Type:       
    Purpose:    Call interactionIds from Avato.
    User Story: US-CTI-001
    Used By:
    ---------------------------------------------------------------
    History:
    
    1. Sinow Zhang (NTTData) Created on 19-July-2013
*/
public class AvatoHelper {
    
    public static String VoiceWebService(String ucid, DateTime timestamp) {
        NiceWebServices.NiceServiceHttpSoap11Endpoint niceSoap = new NiceWebServices.NiceServiceHttpSoap11Endpoint();
        try {
            niceSoap.timeout_x = 60000;
            String callDate = timestamp.year() + '-' + timestamp.month() + '-' + timestamp.day();
            return niceSoap.GetInteractionIDsByCallID(ucid, callDate);   
        }
        catch(Exception ex) {
            system.debug(ex.getMessage());
        }
        return null;
    }
    
    public static String getInteractionIds(String ucid, DateTime timestamp) {
        return VoiceWebService(ucid, timestamp);
    }
}