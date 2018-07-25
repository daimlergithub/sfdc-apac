/**
* @author Debasmita Kundu
* @date 08/07/2017
* @description Defines the Handler for making Callouts from Apex
*/
public class CalloutHandlerService {
    //Reetesh Added custom setting to strore value of callout time
    private static  Map<string,CallOutHandlerSettingDFW__c> cohMap = CallOutHandlerSettingDFW__c.getAll();

    /** Constant to represent the default callout time limit */
    @TestVisible private static final Integer DEFAULT_CALLOUT_TIME = Integer.valueOf(cohMap.get('CalloutValues').DEFAULT_CALLOUT_TIME__c);
    /** Constant representing the content type for JSON */
    private static final String JSON_CONTENT_TYPE = cohMap.get('CalloutValues').JSON_CONTENT_TYPE__c;
    /** Constant representing the content type for plain text */
    private static final String PLAIN_TEXT_CONTENT_TYPE = cohMap.get('CalloutValues').PLAIN_TEXT_CONTENT_TYPE__c;
    /** Constant representing the OK status for callout requests */
    private static final String OK_STATUS = cohMap.get('CalloutValues').OK_STATUS__c;
    /** Constant representing the KO status for callout requests */
    private static final String KO_STATUS = cohMap.get('CalloutValues').KO_STATUS__c;
    /** Constant representing the failed status for callout requests */
    private static final String FAILED_STATUS = cohMap.get('CalloutValues').FAILED_STATUS__c;
    /** Constant representing the queued status for callout requests */
    public static final String QUEUED_STATUS = cohMap.get('CalloutValues').QUEUED_STATUS__c;
    /** Constant to represent the maximum callout time limit */
    public static final Integer MAX_CALLOUT_TIME = Integer.valueOf(cohMap.get('CalloutValues').MAX_CALLOUT_TIME__c);
    /** Constant representing the attachment name used to store the body of callout requests */
    public static final String REQUEST_BODY_NAME = cohMap.get('CalloutValues').REQUEST_BODY_NAME__c;
    /** Constant representing the attachment name used to store the headers of callout requests */
    public static final String REQUEST_HEADERS_NAME = cohMap.get('CalloutValues').REQUEST_HEADERS_NAME__c;
    /** Constant representing the attachment name used to store the client certificate name of callout requests */
    public static final String REQUEST_CERT_NAME = cohMap.get('CalloutValues').REQUEST_CERT_NAME__c;
    /** Constant representing the attachment name used to store callout responses */
    public static final String RESPONSE_NAME =cohMap.get('CalloutValues').RESPONSE_NAME__c; 
    /** Constant representing the GET HTTP Method */
    public static final String GET_METHOD = 'GET';
    /** Constant representing the POST HTTP Method */
    public static final String POST_METHOD = 'POST';
    /** Constant representing the PUT HTTP Method */
    public static final String PUT_METHOD = 'PUT';
    /** Constant representing the PATCH HTTP Method */
    public static final String PATCH_METHOD = 'PATCH';
    /** Constant representing the DELETE HTTP Method */
    public static final String DELETE_METHOD = 'DELETE';
    
 //   private static SystemSettingsDFW__c sysSet;
    
    
    public static GlobalUtilityDFW gu = GlobalUtilityDFW.getInstance(); 
    
    /**
    * @date 08/07/2017
    * @description Executes Apex Callout Asynchronously
    * @param Id Id of the callout request to be made
    */
    
    public static HttpResponse sendCallout(String method, String endpoint, Integer timeout, Map<String,String> headerKeyByValue, String status)
    {
        // Perform HTTP Callout
        String responseString = null;
        HttpResponse response = new HttpResponse();
        HttpRequest request;
        Long start = System.now().getTime();
        try {
            Http h = new Http();
            request = new HttpRequest();
            request.setMethod(method);
            request.setEndpoint(endpoint);
            request.setTimeout(calculateTimeout(timeout));        
            
            
			for (String headerKey : headerKeyByValue.keySet())
                {
                    request.setHeader(headerKey, headerKeyByValue.get(headerKey));
                }	
			
			response = h.send(request);            
            //responseString = processCalloutResponse(response, status);  
           
        }
        catch (Exception ex){
            processFailure(status, ex, request, response);                     
        }
        
       return response;     
    }
	/** Added by Dhanamjaya & Narendra to Handle Call outs Through Post method*/
	public static HttpResponse sendCalloutForPost(String method, String endpoint, Integer timeout, Map<String,String> headerKeyByValue, String Status,String Body, String market)
    {
        // Perform HTTP Callout
		Boolean isExceptionOccured = false;
        String responseString = null;
        HttpResponse response = new HttpResponse();
        HttpRequest request;
        Long start = System.now().getTime();
        try {
            Http h = new Http();
            request = new HttpRequest();
            request.setMethod(method);
            request.setEndpoint(endpoint);
            request.setTimeout(calculateTimeout(timeout));        
            request.setBody(Body);
            if(headerKeyByValue!=null){
				for (String headerKey : headerKeyByValue.keySet())
					{
						request.setHeader(headerKey, headerKeyByValue.get(headerKey));
					}	
			}
			response = h.send(request);            
            //responseString = processCalloutResponse(response, status);  
           
        }
        catch (Exception ex){
			isExceptionOccured = true;
            if(market=='MY'){
                CustomLogUtil.CustomLoggingEntryRecordIds(request.getbody(),endpoint, ''+ex.getMessage(), market);  
            }
            processFailure(status, ex, request, response);                     
        }
        if(!isExceptionOccured && response.getStatusCode() != 200 && market=='MY'){
            CustomLogUtil.CustomLoggingEntryRecordIds(request.getbody(),endpoint, ''+response.getBody(), market);
        }
        else if(Market != 'MY')
		CustomLogUtil.CustomLoggingEntry('Call for post' + request.getbody() +'-- '+endpoint); 
        return response;     
    }	



  /**  
    * @date 08/07/2017
    * @description Processes timeout to be used for HTTP callout and updates callout request record as needed
    * @param CalloutRequest__c The callout request to be sent
    * @return Integer Timeout (in milliseconds) to be used for HTTP callout
    */
    private static Integer calculateTimeout(Integer timeout)
    {
        if (timeout==null || timeout <= 0)
        {
            timeout = DEFAULT_CALLOUT_TIME / 1000;
            return DEFAULT_CALLOUT_TIME;
        }
        else if ((timeout*1000) > MAX_CALLOUT_TIME)
        {
            timeout = MAX_CALLOUT_TIME / 1000;
            return MAX_CALLOUT_TIME;
        }
        else return Integer.valueOf(timeout*1000);
    }
    /* added by dhanamjaya and narendra to handle callouts from VF pages i.e Continuation call outs*/
    public Static String onLineDeduplicationCDMTHCallout(String sss,Continuation con){
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setEndpoint(sss); 
        req.setMethod('GET');
		return con.addHttpRequest(req);
    	}

	 /* added by dhanamjaya and narendra to handle callouts from VF pages i.e Continuation call outs*/
    public Static String onLineDeduplicationCDMCallout(String endURL,Continuation con){
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setEndpoint(endURL); 
        req.setMethod('GET');
		req.setHeader('Content-Type','application/json');
        req.setHeader('Accept-Language','application/json');
		CustomLogUtil.CustomLoggingEntry('Online Dedup Request' + endUrl);
        return con.addHttpRequest(req);
        }
    /**
    
    * @date 08/07/2017
    * @description Processes HTTP callout responses and updates callout request fields accordingly
    * @param HttpResponse Response of an HTTP callout
    * @param CalloutRequest__c Callout request that was made
    */
    public static string processCalloutResponse(HttpResponse response, String Status)
    {
        if (response.getStatusCode() == 200){
            Status = OK_STATUS;
        }
        else{
            Status = KO_STATUS;
        }
        // Create response body attachment
        return response.getBody();
    }

    /**
    
    * @date 08/07/2017
    * @description Processes failure encountered in attempting to perform HTTP callout
    * @param CalloutRequest__c Callout request that should have been made
    * @param Exception System Exception encountered while attempting to perform HTTP callout
    */
    private static void processFailure(String status, Exception ex, HttpRequest request, HttpResponse response)
    {
        status = FAILED_STATUS;
        gu.DebugWebServiceLog(ex, userInfo.getUserId(), request, response);
    }


}