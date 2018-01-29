@RestResource(urlMapping='/ValidateNewCustomer/*')
global without sharing class customerVehiceStatus {
    public static final Id personRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
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
        String name='';
        if(LastName!='' && !String.isBlank(LastName) && LastName!=' ' && lastname!=null){
                name+=lastname;                   
        }
        if(FirstName!='' && !String.isBlank(FirstName) && FirstName!=' ' && FirstName!=null){
            if(Pattern.matches('.*[A-Za-z]{1,}.*', FirstName) || Pattern.matches('.*[A-Za-z]{1,}.*', lastname)){
               name+=name!='' ? (' '+FirstName) :(FirstName);
            }
            else{
                name+=FirstName;
            }
        }
        system.debug(name);
        system.debug(Email);
        system.debug(Mobile);
        //changes for Frst & lastname
        List<Account> acc= new List<Account>();
        List<Account> acc2= new List<Account>();
        List<Vehicle__c> vehicle=new List<Vehicle__c>();
        if((mobile==null || mobile=='' || String.isBlank(mobile)) && Email !=null && Email !='' && !String.isBlank(Email) && name!=''){
            acc2=[select id,Ucid__c,email__c,firstname,lastname from Account where Email__c=:Email and RecordtypeId=:personRecordTypeId and Md__c='KR' Order By LastModifiedDate DESC ];
        }
        else if(mobile !=null && mobile !='' && !String.isBlank(mobile) && name!=''){
            acc2=[select id,Ucid__c,email__c,firstname,lastname from Account where Mobile__c=:Mobile and RecordtypeId=:personRecordTypeId and Md__c='KR' Order By LastModifiedDate DESC ];
        }
        for(Account a:acc2){
            if((a.firstname!=null && a.firstname.containsIgnoreCase(name)) || (a.lastname!=null && a.lastname.containsIgnoreCase(name))){
                acc.add(a);
                break;
            }
        }
        system.debug('acc'+acc);
        if(acc.size()>0){
        response.put('UCID', acc[0].Ucid__c);
        }
        //considering removal of white spaces
        RegistrationNumber=RegistrationNumber.deleteWhitespace();
        if(RegistrationNumber==null || RegistrationNumber==''){
            return response;
        }
        String regNumwithwildcards='%';
        for(Integer i=0;i<RegistrationNumber.length();i++){
            regNumwithwildcards+=RegistrationNumber.substring(i,i+1)+'%';
        }
        List<Vehicle__c> vehicles=new List<Vehicle__c>();
        vehicles=[select id,RegistrationNo__c from vehicle__c where RegistrationNo__c like :regNumwithwildcards and Md__c='KR' limit 50000];
        String regNumber=null;
        for(vehicle__c v:vehicles){
            system.debug(v.RegistrationNo__c.deleteWhitespace().right(5));
            if(v.RegistrationNo__c.deleteWhitespace().right(5)==RegistrationNumber){
                regNumber=v.RegistrationNo__c;
            }
        }
        //considering removal of white spaces
        if(regNumber !=null && regNumber !='' && !String.isBlank(regNumber)){
            vehicle=[select id from Vehicle__c where RegistrationNo__c=:regNumber limit 1];
        }
        if(vehicle.size()==0){
            return response;
        }
        response.put('VehicleExists', 'True');
        response.put('VehicleId', vehicle[0].id);
        if(response.get('UCID')=='Nil' && name!=''){
            List<Vehicle_Relationship__c> vr=new List<Vehicle_Relationship__c>();
            vr=[select id,Vehicle_ID__c,Contact__r.UCID__c from Vehicle_Relationship__c where Vehicle_ID__c=:vehicle[0].id and
                (Contact__r.LastName LIKE :('%' + name + '%') or Contact__r.FirstName LIKE :('%' + name + '%')) and Contact__r.Recordtype.name='Person Account' and Md__c='KR'  Order By LastModifiedDate DESC limit 1];
            if(vr.size()>0){
                response.put('UCID', vr[0].Contact__r.UCID__c);
                acc=[select id,Ucid__c,email__c from Account where Ucid__c=:vr[0].Contact__r.UCID__c limit 1];                            
            }
        }
        List<Loyalty_Card__c> lcv=new List<Loyalty_Card__c>();
        lcv=[select id,Loyalty_Card_Number__c from Loyalty_Card__c where vehicle__c=:vehicle[0].id and Loyalty_Card_End_Date__c>=:system.today() and Md__c='KR' limit 1];
        system.debug(lcv.size());
        if(lcv.size()>0){
              response.put('VehicleRelationship', lcv[0].Loyalty_Card_Number__c+';Nil');
        }
        if(acc.size()>0){
            List<Vehicle_Relationship__c> vrs=new List<Vehicle_Relationship__c>();
            vrs=[select id,Owner_Relation__c,Vehicle_ID__c from Vehicle_Relationship__c where Contact__c=:acc[0].id and Vehicle_ID__c=:vehicle[0].id and End_Date__c =null and Md__c='KR' Order By LastModifiedDate DESC limit 1]; 
            system.debug(vrs.size());
            if(response.get('VehicleRelationship')!='Nil' && vrs.size()>0){
              String relation=vrs[0].Owner_Relation__c=='Same'?'Owner':'Contact';
                response.put('VehicleRelationship', lcv[0].Loyalty_Card_Number__c+';'+relation);
            }
            else if(vrs.size()>0){
                response.put('VehicleRelationship', vrs[0].Owner_Relation__c=='Same'?'Owner':'Contact');    
            }
            List<Loyalty_Card__c> lc=new List<Loyalty_Card__c>();
            lc =[select id,Loyalty_Card_Number__c from Loyalty_Card__c where Account__c=:acc[0].id and Loyalty_Card_End_Date__c>=:system.today() and Md__c='KR' Order By LastModifiedDate DESC limit 1];
            if(lc.size()>0){
                response.put('LoyalityCardNumber', lc[0].Loyalty_Card_Number__c);
            }
        }
        return response;
    }
}