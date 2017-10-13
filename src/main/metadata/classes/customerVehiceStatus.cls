@RestResource(urlMapping='/ValidateNewCustomer/*')
global without sharing class customerVehiceStatus {
    @HttpPost
    global static Map<String,String> findUCID(){
        Map<String,String> response=new Map<String,String>();
        response.put('UCID', 'Nil');
        response.put('VehicleExists', 'False');
        response.put('VehicleRelationship', 'Nil');
        response.put('LoyalityCardNumber', 'Nil');
        String jsonText = RestContext.request.requestBody.toString();
        Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonText);
        Object res=cObjMap.get('data');
        Map<String,Object> obj= (Map<String,Object>)res;
        String FirstName=(String)obj.get('FirstName');
        String LastName=(String)obj.get('LastName');
        String Email=(String)obj.get('Email');
        String Mobile=(String)obj.get('Mobile');
        String RegistrationNumber=(String)obj.get('RegistrationNumber');
        List<Account> acc= new List<Account>();
        List<Vehicle__c> vehicle=new List<Vehicle__c>();
        if((mobile==null || mobile=='' || String.isBlank(mobile)) && Email !=null && Email !='' && !String.isBlank(Email) ){
            acc=[select id,Ucid__c,email__c from Account where LastName LIKE :('%' + LastName + '%') and (FirstName LIKE :('%' + FirstName + '%') or FirstName=null)  and Email__c=:Email and Recordtype.name='Person Account' and Md__c='KR' Order By LastModifiedDate DESC NULLS LAST];
        }
        else if(mobile !=null && mobile !='' && !String.isBlank(mobile)){
            acc=[select id,Ucid__c,email__c from Account where LastName LIKE :('%' + LastName + '%') and (FirstName LIKE :('%' + FirstName + '%') or FirstName=null)  and Mobile__c=:Mobile and Recordtype.name='Person Account' and Md__c='KR' Order By LastModifiedDate DESC NULLS LAST];
        }
        if(acc.size()>0){
        response.put('UCID', acc[0].Ucid__c);
        }
        //considering removal of white spaces
        RegistrationNumber=RegistrationNumber.deleteWhitespace();
        String regNumwithwildcards='%';
        for(Integer i=0;i<RegistrationNumber.length();i++){
            regNumwithwildcards+=RegistrationNumber.substring(i,i+1)+'%';
        }
        List<Vehicle__c> vehicles=new List<Vehicle__c>();
        vehicles=[select id,RegistrationNo__c from vehicle__c where RegistrationNo__c like :regNumwithwildcards and Md__c='KR'];
        for(vehicle__c v:vehicles){
            if(v.RegistrationNo__c.deleteWhitespace()==RegistrationNumber){
                RegistrationNumber=v.RegistrationNo__c;
            }
        }
        //considering removal of white spaces
        if(RegistrationNumber !=null && RegistrationNumber !='' && !String.isBlank(RegistrationNumber)){
            vehicle=[select id from Vehicle__c where RegistrationNo__c=:RegistrationNumber];
        }
        if(vehicle.size()==0){
            return response;
        }
        response.put('VehicleExists', 'True');
        response.put('VehicleId', vehicle[0].id);
        if(response.get('UCID')=='Nil' && ((LastName !=null && LastName !='' && !String.isBlank(LastName)) ||
                                         (FirstName !=null && FirstName !='' && !String.isBlank(FirstName)))){
            List<Vehicle_Relationship__c> vr=new List<Vehicle_Relationship__c>();
            vr=[select id,Vehicle_ID__c,Contact__r.UCID__c from Vehicle_Relationship__c where Vehicle_ID__c=:vehicle[0].id and
                Contact__r.LastName LIKE :('%' + LastName + '%') and Contact__r.FirstName LIKE :('%' + FirstName + '%') and Contact__r.Recordtype.name='Person Account' and Md__c='KR'  Order By LastModifiedDate DESC NULLS LAST];
            if(vr.size()>0){
                response.put('UCID', vr[0].Contact__r.UCID__c);
                acc=[select id,Ucid__c,email__c from Account where Ucid__c=:vr[0].Contact__r.UCID__c];                            
            }
        }
        if(acc.size()>0){
            List<Vehicle_Relationship__c> vrs=new List<Vehicle_Relationship__c>();
            vrs=[select id,Owner_Relation__c,Vehicle_ID__c from Vehicle_Relationship__c where Contact__c=:acc[0].id and Vehicle_ID__c=:vehicle[0].id and End_Date__c =null and Md__c='KR' Order By LastModifiedDate DESC NULLS LAST];
            if(vrs.size()>0){
                List<Loyalty_Card__c> lcv=new List<Loyalty_Card__c>();
                lcv=[select id,Loyalty_Card_Number__c from Loyalty_Card__c where vehicle__c=:vehicle[0].id and Loyalty_Card_End_Date__c>=:system.today() and Md__c='KR'];
                if(lcv.size()>0){
                    response.put('VehicleRelationship', lcv[0].Loyalty_Card_Number__c);
                }
                else{
                    response.put('VehicleRelationship', vrs[0].Owner_Relation__c=='Same'?'Owner':'Contact');
                }
                
            }
            List<Loyalty_Card__c> lc=new List<Loyalty_Card__c>();
            lc =[select id,Loyalty_Card_Number__c from Loyalty_Card__c where Account__c=:acc[0].id and Loyalty_Card_End_Date__c>=:system.today() and Md__c='KR' Order By LastModifiedDate DESC NULLS LAST];
            if(lc.size()>0){
                response.put('LoyalityCardNumber', lc[0].Loyalty_Card_Number__c);
            }
        }
        return response;
    }
}