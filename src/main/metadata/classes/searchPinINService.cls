public class searchPinINService{
    public String searchPinIN(String PinCode, String country){

        CDM_Integration_URLs__c oUrl =  CDM_Integration_URLs__c.getInstance('INSearchPinCode');
        if (oURL == null || oURL.Informatica_URL__c == ''){
            return '';
        }
        String endpoint = (String)oUrl.Informatica_URL__c;
        if (PinCode == null || Pincode == '' || country == null || country == '')
            return '';
        string body = '{"inp_JSON_Pin_Code":"' + Pincode + '","inp_JSON_Country":"' + country + '"}';
        
        HttpResponse response = new HttpResponse();
        String retStr = '';
        try
        {
            Map<string,string> header_k = new map<string,string>();
            header_k.put('Content-Type','application/json');
            response = CalloutHandlerService.sendCalloutForPost('GET', endpoint, 10000,header_k, 'error',body,Label.IN);
           
            system.debug('response'+response);
            if (response.getStatusCode() == 200){
                String respBody = response.getBody();
                if (respBody != null && respBody != ''){
                    Map<String, String> respMap = (Map<String,String>) JSON.deserialize(respBody, Map<String,String>.class); 
                    String respState = respMap.get('out_JSON_State');
                    if (respState != null && respState != ''){
                        List<String> elems = respState.split(' ');
                        respState = '';
                        //Code to change state to camel case prior to returning it
                        for (String x : elems)
                        {
                            respState += x.substring(0,1).toUpperCase()+x.substring(1,x.length()).toLowerCase() + ' ';
                        }
                        retStr = respMap.get('out_JSON_City') + '|' + respState.substring(0, respState.length() - 1);
                        system.debug('retStr ' + retStr);
                    }
                }
            }

        }
        catch(Exception e)
        {	
            //system.debug('An exception occurred: ' + e.getMessage());
            CustomLogUtil.CustomLoggingEntry('Error Occured '+ e.getMessage());
            CustomLogUtil.DebugLogInsert();
        }
        return retStr;
     }   
}