@RestResource(urlMapping='/BBQReferral/*')
Global class BBQReferral {
    @HttpGet
    Global static Map<String,List<Referral__c>> getReferral(){
        RestRequest request = RestContext.request;
        String email = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        List<Referral__c> refs=[select Address__c,Dealer__c,Email__c,First_Name__c,I_explained_the_scheme_confirmed_data_p__c,
                                Last_Name__c,Model_Type__c,Phone__c,Zip_code__c,Type_of_Vehicle__c,First_name_native__c,
                                Last_Name_Native__c,Customer_type__c,status__c,CreatedDate from Referral__c where 
                                ReferredEmployee__r.Email__c=:email order by CreatedDate desc limit 10];                
        return new Map<String,List<Referral__c>>{'Referrals' => refs};
    }
    @HttpPost
    Global static Map<String,String> createReferral(String Email, String FirstName, String LastName,String Market,String Phone,
                                                    String Address,String Dealer,String Agreement, String ModelType,
                                                    String Zipcode,String EmployeeMail,String typeOfVehicle,
                                                    String FirstNameNative,String LastNameNative,String CustomerType){
        Map<String,String> response=new Map<String,String>();
        Employee__c emp=[select id from Employee__c where email__c=:EmployeeMail];
        Referral__c ref=new Referral__c();
        ref.Address__c=Address;
        ref.Dealer__c=Dealer;
        ref.Email__c=Email;
        ref.Market__c=Market;
        ref.First_Name__c=FirstName;
        ref.I_explained_the_scheme_confirmed_data_p__c=Boolean.valueOf(Agreement);
        ref.Last_Name__c=Lastname;
        ref.Model_Type__c=ModelType;
        ref.Phone__c=Phone;
        ref.Zip_code__c=Zipcode;
        ref.ReferredEmployee__c=emp.Id;
        ref.First_name_native__c=FirstNameNative;
        ref.Last_name_native__c=Lastnamenative;
        if(!String.isBlank(CustomerType))
            ref.Customer_Type__c=CustomerType;                                       
        if(!String.isBlank(typeOfVehicle))
            ref.Type_of_Vehicle__c=typeOfVehicle;
        try{
           insert ref; 
        }
        catch(Exception e){
            response.put('Message', e.getMessage());
            return response;
        }
        response.put('Message', 'OK');
        return response;
    }
    
}