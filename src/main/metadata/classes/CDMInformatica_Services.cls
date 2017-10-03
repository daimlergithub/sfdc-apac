/*------------------------------------------------------------
    Author:        Pavan Kumar D
    Company:       Infosys
    Description:   Generic service to callout informatica for CDM purposes
    History
    <Date>      <Authors Name>     <Brief Description of Change> 
    
    Pattern followed:  Separation of Concerns 
                
     Purpose:   This class will be the gateway to interface with CDM
                 Also, deminstrated the    Event logging framework
    
   This class follows the service layer which is part of the SOC and also addresses
   the CDM Informatica Services in place with an handle to leverage the Application error logging framework
    ------------------------------------------------------------*/
public Class CDMInformatica_Services extends CDMServices{


     
    public override string searchCustomerOnCDM(String method, String endpoint, Integer timeout, Map<String,String> headerKeyByValue, String status)
    {
        
        try{
            HttpResponse res = CalloutHandlerService.sendCallout(method,endpoint, timeout,headerKeyByValue,status);
            return CalloutHandlerService.processCalloutResponse(res, null);
           
        }
        
        catch(Exception e)
        {
            //generic exception if not caught above would be handled and application logger would be invoked
            return null;
        }
    }
    @future(callout=true)
     public static void  createCustomerCDM(Set<ID> acc){
         List<ID> personacc=new List<ID>();
         HttpResponse res=new HttpResponse();
         String Endpoint=null;
         String serializedAccountobj=null;
         map<String,CDM_Integration_URLs__c> mapURLs = CDM_Integration_URLs__c.getAll();
         Endpoint = mapURLs.get('CreateCustomer').Informatica_URL__c;
         List<ID> companyacc=new List<ID>();
         String companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
         String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
         List<Account> accountstosend=[Select id,recordtypeid from Account where id IN :acc];
         for(Account accrec:accountstosend){
             if(accrec.recordtypeid==PersonAccountRecordTypeID){
                 personacc.add(accrec.id);
             }
             else if(accrec.recordtypeid==companyRecordTypeId){
                 companyacc.add(accrec.id);
             }
         }        
         if(personacc.size()>0){
             serializedAccountobj=generateJson(personacc);
             serializedAccountobj= EncodingUtil.URLENCODE(serializedAccountobj,'UTF-8');
             //system.debug('---sanjay---'+serializedAccountobj);
             string str='[{"attributes":{"type":"Account","url":"/services/data/v41.0/sobjects/Account/'+personacc[0]+'"},"Id":"'+personacc[0]+'","RecordTypeId":"012280000000f14AAA"}]';
                

             //res=CalloutHandlerService.sendCalloutForPost('POST',Endpoint,null,null,null,serializedAccountobj);
             Endpoint = mapURLs.get('MY-Customer create').Informatica_URL__c;
             res=CalloutHandlerService.sendCalloutForPost('POST',Endpoint,null,null,null,str);
             
         }
         if(companyacc.size()>0){
             serializedAccountobj=generateJson(companyacc);
             serializedAccountobj= EncodingUtil.URLENCODE(serializedAccountobj,'UTF-8');
             //system.debug('---sanjay---'+serializedAccountobj);
             //res=CalloutHandlerService.sendCalloutForPost('POST',Endpoint,null,null,null,serializedAccountobj);
             
             Endpoint = mapURLs.get('MY-Customer Create').Informatica_URL__c;
             string str='[{"attributes":{"type":"Account","url":"/services/data/v41.0/sobjects/Account/'+companyacc[0]+'"},"Id":"'+companyacc[0]+'","RecordTypeId":"012280000000f0p"}]';
             res=CalloutHandlerService.sendCalloutForPost('POST',Endpoint,null,null,null,str);
         }
        
     
     }
     //Will Generate the Required Json format
     Public Static String generateJson(List<ID> idlist){
        String s='{"ip_data":[';
        integer lstsize=idlist.size();
        Integer count=0;
        for(ID inte:idlist){
            count++;
            s=s+'{"id":'+'"'+inte+'"},';
        }
        s=s+']}';
        Integer inde=s.lastIndexof(',');
        String str=s.substring(0,inde)+s.substring(inde+1);
      return str;
     }
    
    @future(callout=true)
     public static void  createCustomerCDM(Set<ID> acc, string Market,string context){
         List<ID> personacc=new List<ID>();
         List<ID> companyacc=new List<ID>();
         HttpResponse res=new HttpResponse();
         String Endpoint=null;
         String serializedAccountobj=null;
         map<String,CDM_Integration_URLs__c> mapURLs = CDM_Integration_URLs__c.getAll();
         
         
         String companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
         String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
         List<Account> accountstosend=[Select id,recordtypeid from Account where id IN :acc];
         for(Account accrec:accountstosend){
             if(accrec.recordtypeid==PersonAccountRecordTypeID){
                 personacc.add(accrec.id);
             }
             else if(accrec.recordtypeid==companyRecordTypeId){
                 companyacc.add(accrec.id);
             }
         }        
         if(personacc.size()>0){
			for( string str : mapURLs.keyset()){
             if(mapURLs.get(str).type__c==context && mapURLs.get(str).country__c==Market && MapUrls.get(str).Context__c=='Person Account')
                Endpoint = mapURLs.get(str).Informatica_URL__c; 
         }
             serializedAccountobj=generateJson(personacc);
             serializedAccountobj= EncodingUtil.URLENCODE(serializedAccountobj,'UTF-8');
             //res=CalloutHandlerService.sendCalloutForPost('POST',Endpoint,null,null,null,serializedAccountobj);
             //string str='[{"attributes":{"type":"Account","url":"/services/data/v41.0/sobjects/Account/'+personacc[0]+'"},"Id":"'+personacc[0]+'","RecordTypeId":"'+PersonAccountRecordTypeID+'"}]';
				string body='[';
			for(integer i=0 ;i<personacc.size();i++){
				   if(body.length()==1)
					   body=body+'{"attributes":{"type":"Account","url":"/services/data/v41.0/sobjects/Account/'+personacc[i]+'"},"Id":"'+personacc[i]+'","RecordTypeId":"'+PersonAccountRecordTypeID+'"}';
				   else
					   body=body+',{"attributes":{"type":"Account","url":"/services/data/v41.0/sobjects/Account/'+personacc[i]+'"},"Id":"'+personacc[i]+'","RecordTypeId":"'+PersonAccountRecordTypeID+'"}';
				}
			 body=body+']';
              Map<string,string> headerCDM= new Map<string,string>();
              headerCDM.put('Content-Type','application/json');
             //res=CalloutHandlerService.sendCalloutForPost('POST',Endpoint,null,null,null,serializedAccountobj);
            // Endpoint = mapURLs.get('MY-Customer create').Informatica_URL__c;
             res=CalloutHandlerService.sendCalloutForPost('POST',Endpoint,60000,headerCDM,null,body);
         }
         if(companyacc.size()>0){
         serializedAccountobj=generateJson(companyacc);
         serializedAccountobj= EncodingUtil.URLENCODE(serializedAccountobj,'UTF-8');
		 for( string str : mapURLs.keyset()){
             if(mapURLs.get(str).type__c==context && mapURLs.get(str).country__c==Market && MapUrls.get(str).Context__c=='Company')
                Endpoint = mapURLs.get(str).Informatica_URL__c; 
         }
         //res=CalloutHandlerService.sendCalloutForPost('POST',Endpoint,null,null,null,serializedAccountobj);
        // string str='[{"attributes":{"type":"Account","url":"/services/data/v41.0/sobjects/Account/'+personacc[0]+'"},"Id":"'+personacc[0]+'","RecordTypeId":"012280000000f14AAA"}]';
            Map<string,string> headerCDM= new Map<string,string>();
              headerCDM.put('Content-Type','application/json');    

             //res=CalloutHandlerService.sendCalloutForPost('POST',Endpoint,null,null,null,serializedAccountobj);
           //Endpoint = mapURLs.get('MY-Customer Create').Informatica_URL__c;
		   string body='[';
		   for(integer i=0 ;i<companyacc.size();i++){
			   if(body.length()==1)
				   body=body+'{"attributes":{"type":"Account","url":"/services/data/v41.0/sobjects/Account/'+companyacc[i]+'"},"Id":"'+companyacc[i]+'","RecordTypeId":"'+companyRecordTypeId+'"}';
			   else
				   body=body+',{"attributes":{"type":"Account","url":"/services/data/v41.0/sobjects/Account/'+companyacc[i]+'"},"Id":"'+companyacc[i]+'","RecordTypeId":"'+companyRecordTypeId+'"}';
		   }
		    body=body+']';
             //string str='[{"attributes":{"type":"Account","url":"/services/data/v41.0/sobjects/Account/'+companyacc[0]+'"},"Id":"'+companyacc[0]+'","RecordTypeId":"'+companyRecordTypeId+'"}]';
             res=CalloutHandlerService.sendCalloutForPost('POST',Endpoint,60000,headerCDM,null,body);
         
         }
        
     
     }
     
}