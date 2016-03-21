public class UtilWebService
{
    public static void entityUpdateNotification(String organizationId,String sfdcId,String sfdcTypeName,String sfdcMarketDiscriminator,String updateType,String serlializedObject)
    {
        //Soap over http
        String requestXML='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ep="http://ep.apac.crm.daimler.com">';
        requestXML+='<soapenv:Header/>';
        requestXML+='<soapenv:Body>';
        requestXML+='<ep:notifyEntityUpdate>';
        requestXML+='<ep:organizationId>'+organizationId+'</ep:organizationId>';
        requestXML+='<ep:sfdcId>'+sfdcId+'</ep:sfdcId>';
        requestXML+='<ep:sfdcTypeName>'+sfdcTypeName+'</ep:sfdcTypeName>';
        requestXML+='<ep:sfdcMarketDiscriminator>'+sfdcMarketDiscriminator+'</ep:sfdcMarketDiscriminator>';
        requestXML+='<ep:updateType>'+updateType+'</ep:updateType>';
        requestXML+='<ep:serlializedObject>'+serlializedObject+'</ep:serlializedObject>';
        requestXML+='</ep:notifyEntityUpdate>';
        requestXML+='</soapenv:Body>';
        requestXML+='</soapenv:Envelope>';
        
        HttpRequest req=new HttpRequest();
        req.setMethod('GET');
        system.debug('req UtilCustomSettings >>>>>'+UtilCustomSettings.getEndPointURL(UtilConstant.ENTITY_UPDATE_NOTIFICATION));
        req.setEndpoint(UtilCustomSettings.getEndPointURL(UtilConstant.ENTITY_UPDATE_NOTIFICATION));
        req.setTimeout(120000);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', '""');
        req.setHeader('Connection', 'Keep-Alive');
        req.setBody(requestXML);
        system.debug('req >>>>>'+req);
        Http http=new Http();
        HTTPResponse res ;
        try{
            res=http.send(req);  
            system.debug('res>>>>>'+res);
        }catch(Exception e)
        {
            system.debug('e>>>>>'+e.getmessage()+'>>>>>'+e.getstacktracestring());
        }
    }
}