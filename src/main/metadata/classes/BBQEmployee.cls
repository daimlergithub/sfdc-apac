@RestResource(urlMapping='/BBQEmployee/*')
Global class BBQEmployee {
    @HttpGet
    Global static Map<String,String> getEmployee(){
        RestRequest request = RestContext.request;
        String email = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Employee__c emp=[select id,Points__c,Rank__c,email__c,No_of_closed_Won__c,No_of_referral__c,
        				Rank_of_Employee_with_closed_won__c,Rank_of_Employee_with_referrals_made__c,ReferralsCreated__c,ReferralsWon__c 
                        from Employee__c where email__c=:email];
        Map<String,String> response=new Map<String,String>();
        response.put('Email', emp.Email__c);
        response.put('Points', String.valueOf(emp.Points__c));
        response.put('Rank', String.valueOf(emp.Rank__c));
        response.put('NoofclosedWonthisQuarter', String.valueOf(emp.No_of_closed_Won__c));
        response.put('NoofreferralscreatedthisQuarter', String.valueOf(emp.No_of_referral__c));
        response.put('RankofEmployeewithclosedwon', String.valueOf(emp.Rank_of_Employee_with_closed_won__c));
        response.put('RankofEmployeewithreferralsmade', String.valueOf(emp.Rank_of_Employee_with_referrals_made__c));
        response.put('TotalNoOfReferralsCreated', String.valueOf(emp.ReferralsCreated__c));
        response.put('TotalNoOfReferralsWon', String.valueOf(emp.ReferralsWon__c));
        
        return response;
    }
    @HttpPost
    Global static Map<String,String> createEmployee(String Email, String FirstName, String LastName,String Market,String Phone,
                                                    String UserName,String FirstNameNative,String LastNameNative,String Department,String Company){
    	Map<String,String> response=new Map<String,String>();
        Employee__c emp=new Employee__c();
        emp.Email__c=Email;
        emp.First_Name__c=FirstName;
        emp.Last_Name__c=LastName;
        emp.Market__c=Market;
        emp.Phone__c=Phone;
        emp.UserName__c=UserName;
        emp.First_name_native__c=FirstNameNative;
        emp.Last_name_native__c=LastNameNative;
        emp.Department__c=Department;
        if(!String.isBlank(Company))
        	emp.Company__c=Company;
        try{
            insert emp;
        }
        catch(Exception e){
            if(e.getMessage().contains('DUPLICATE_VALUE'))
            	response.put('Message', 'Employee already Exists');
            else
                response.put('Message', e.getMessage());
            return response;
        }
        response.put('Message', 'OK');
        return response;
    }
}