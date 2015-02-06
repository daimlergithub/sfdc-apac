@RestResource(urlMapping='/UotReceiver/*')
global with sharing class UotRestReceiver
{
    public class UnitOfTransfer
    {
        public Long transferId;
        public List<UnitOfWork> unitOfWork;
    }
    
    @HttpPost
    global static String doPost() 
    {
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        UnitOfTransfer uot = (UnitOfTransfer)JSON.deserialize(req.requestBody.toString(), UnitOfTransfer.class);
        
        if (uot == null) {
          throw new IllegalArgumentException('No unit of transfer delivered.');
        }
        
        List<UnitOfWorkResponse> result = UotReceiver.execute(uot.transferId, uot.unitOfWork, true).UnitOfWorkResponses;
        
        return JSON.serialize(result);
    }
}