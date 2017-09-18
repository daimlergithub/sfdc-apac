global class GlobalUtilityDFWDemo {
    public static GlobalUtilityDFW gu = GlobalUtilityDFW.getInstance();
    public static void divideNum(Integer a,Integer b){       
        gu.push('divideNum');
        Integer c= 0;
        if(a>b && a !=0 ){
            c= a/b;
            System.debug('@@Value  if(a>b) of c is : '+c);
            gu.pop();
        }
        else if(b>a && a !=0 ) {
            c=b/a;
            System.debug('@@Value  if(b>a) of c is : '+c);
            gu.pop();
        }
        try{
            if(a==0){ c=b/a;
                     System.debug('@@Value if(a ==0) of c is : ');}
        }Catch(Exception e){
            gu.DebugException(e, UserInfo.getUserId());
            gu.popAll();
        }
        finally{
            
        }
        
    }
    //webservice method   
    webService static Id webServiceDemoTest(String lastName, Account a) {
        Contact c = new Contact(lastName = 'Weissman', AccountId = a.Id);
        try{
        insert c;
        c= new contact();
        insert c;
        }catch(Exception e){          
           gu.popAll(); 
           gu.DebugWebServiceLog(e,UserInfo.getUserId(),null,null);
        }
        return c.id;
    }  
  
    
    
    // Pass in the endpoint to be used using the string url
 
    public static HttpResponse getInfoFromExternalService() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.salesforce.com/foo/bar');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res ;
        try{
           res = h.send(req);           
        }
        catch (Exception ex){
            gu.DebugWebServiceLog(ex,UserInfo.getUserId(),req,res);                   
        }        
        return res;

    }
    
        
    
}