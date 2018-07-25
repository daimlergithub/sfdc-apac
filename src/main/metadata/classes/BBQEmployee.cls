@RestResource(urlMapping='/BBQEmployee/*')
Global class BBQEmployee {
    @HttpGet
    Global static Map<String,String> getEmployee(){
        RestRequest request = RestContext.request;
        String email = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Map<String,String> response=new Map<String,String>();
        for(Employee__c emp : [select id,Points__c,Rank__c,email__c,No_of_closed_Won__c,No_of_referral__c,
                        		Rank_of_Employee_with_closed_won__c,Rank_of_Employee_with_referrals_made__c,ReferralsCreated__c,ReferralsWon__c,
                                Other_Employee_s_Number_of_Generated_Lea__c, Other_Employee_s_Sales_Amount__c from Employee__c where email__c=:email]) {
			response.put('Email', emp.Email__c);
			response.put('Points', String.valueOf(emp.Points__c));
			response.put('Rank', String.valueOf(emp.Rank__c));
			response.put('NoofclosedWonthisQuarter', String.valueOf(emp.No_of_closed_Won__c));
			response.put('NoofreferralscreatedthisQuarter', String.valueOf(emp.No_of_referral__c));
			response.put('RankofEmployeewithclosedwon', String.valueOf(emp.Rank_of_Employee_with_closed_won__c));
			response.put('RankofEmployeewithreferralsmade', String.valueOf(emp.Rank_of_Employee_with_referrals_made__c));
			response.put('TotalNoOfReferralsCreated', String.valueOf(emp.ReferralsCreated__c));
			response.put('TotalNoOfReferralsWon', String.valueOf(emp.ReferralsWon__c));
			response.put('OtherEmployeesNumberofGeneratedLea', String.valueOf(emp.Other_Employee_s_Number_of_Generated_Lea__c));
			response.put('OtherEmployeesSalesAmount', String.valueOf(emp.Other_Employee_s_Sales_Amount__c));       
        }
        return response;
    }
    @HttpPost
    Global static Map<String,String> createEmployee(String Email, String FirstName, String LastName,String Market,String Phone,
                                                    String UserName,String FirstNameNative,String LastNameNative,String Department,String Company,String Action){
        Map<String,String> response=new Map<String,String>();
        Employee__c emp=new Employee__c();
        if(action=='Update'){
            for(Employee__c e :[select id from Employee__c where Email__c=:Email]){
                emp = e;
            }
        }                                                                
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
            upsert emp;
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