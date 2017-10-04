@RestResource(urlMapping='/Loyality/*')
global without sharing class LoyalityManger {
    @HttpPost
    global static Map<String,String> LAValidateCardHolder()
        {
        String jsonText = RestContext.request.requestBody.toString();
        Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonText);
        Object res=cObjMap.get('data');
        Map<String,Object> obj= (Map<String,Object>)res;
        String Loyalty_Card_No=(String)obj.get('Loyalty_Card_No');
        String Vehicle_Registration=(String)obj.get('Vehicle_Registration');
        list<Vehicle__c> vehlist=new list<Vehicle__c>();
        list<Loyalty_Card__c> Lclist=new list<Loyalty_Card__c>();
        list<Vehicle_Relationship__c> vehrel=new list<Vehicle_Relationship__c>();
        map<string,string> responsemap=new map<string,string>();
        responsemap.put('Vehicle_exist','False');
        responsemap.put('UCID','Nil');
      
    //considering removal of white spaces
        Vehicle_Registration=Vehicle_Registration.deleteWhitespace();
        String regNumwithwildcards='%';
        for(Integer i=0;i<Vehicle_Registration.length();i++)
        {
            regNumwithwildcards+=Vehicle_Registration.substring(i,i+1)+'%';
        }
        List<Vehicle__c> vehicles=new List<Vehicle__c>();
        vehicles=[select id,RegistrationNo__c from vehicle__c where RegistrationNo__c like :regNumwithwildcards];
        for(vehicle__c v:vehicles)
        {
            if(v.RegistrationNo__c.deleteWhitespace()==Vehicle_Registration)
            {
                Vehicle_Registration=v.RegistrationNo__c;
            }
        }  
    if(Vehicle_Registration!=null && Vehicle_Registration!='' && !String.isBlank(Vehicle_Registration))
    {  
    vehlist=[select id,Related_contact__c,RegistrationNo__c from Vehicle__c where RegistrationNo__c =:Vehicle_Registration];
    }
    
    if(Loyalty_Card_No!=null && Loyalty_Card_No!='' && !String.isBlank(Loyalty_Card_No))
    {
    Lclist=[select Loyalty_Card_Number__c,Account__c from Loyalty_Card__c where Loyalty_Card_Number__c =:Loyalty_Card_No and Loyalty_Card_End_Date__c>=:system.today()];
    }     
    if(Lclist.size()>0)
       {
          responsemap.put('Loyalty_Card',Lclist[0].Loyalty_Card_Number__c );
        
       }
      else
       {
               responsemap.put('Loyalty_Card','Nil');
              
               Return responsemap;
       }
    
     if(vehlist.size()>0)
        {
          vehrel=[select owner_relation__c,Contact__r.ucid__c  from Vehicle_Relationship__c where contact__c=:Lclist[0].Account__c and Vehicle_ID__c=:vehlist[0].id and End_Date__c=null]; 
          responsemap.put('Vehicle_exist','True');
        }
        
      if(vehrel.size()>0)
        {
          responsemap.put('UCID',vehrel[0].Contact__r.ucid__c);
        }
       return responsemap;  
    }
}