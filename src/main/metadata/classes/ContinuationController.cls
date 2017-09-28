public with sharing class ContinuationController {
    // Unique label corresponding to the continuation
    // Result of callout
    // Callout endpoint as a named credential URL 
    // or, as shown here, as the long-running service URL
    private static final String LONG_RUNNING_SERVICE_URL = 
        'https://th-apex-http-callout.herokuapp.com/animals';
   
   // Action method
   public ContinuationController(){
        
    }
    public Object onLineDeduplicationCDMTH() {
      // Create continuation with a timeout
      Continuation con = null;
      dumyClass dc = new dumyClass();
      con=(Continuation)dc.onLineDeduplicationCDMTHCallout(LONG_RUNNING_SERVICE_URL);
      
      
      // Return the continuation
      return con;  
    }
    
    // Callback method 
}