public abstract class BaseEpaController
{
    protected String getAbsoluteEndpoint(String aRelativeEndpoint)
    {
  	    return EPA_Settings__c.getInstance('epa.base.url').Value__c + aRelativeEndpoint;
    }

    protected Map<String, String> getAuthorizationHeaders()
    {
        Blob headerValue = Blob.valueOf(EPA_Settings__c.getInstance('epa.base.user').Value__c + ':' + EPA_Settings__c.getInstance('epa.base.password').Value__c);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        Map<String, String> result = new Map<String,String>();
        result.put('Authorization', authorizationHeader);
        return result;
    }
}