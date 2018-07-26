@isTest
public class BBQEmployeeTest {
    static testMethod void getEmployeeTest() {
        BBQEmployee.createEmployee('narendra@infosys.com', 'Narendra ','Nimmana','JP','123456789','narendra@infosys.com.dev',
                                   'FirstNameNative','LastNameNative','Sfdc','Infosys', 'New');
        RestRequest req = new RestRequest();
        req.requestUri ='/services/apexrest/BBQEmployee/narendra@infosys.com';
        req.httpMethod = 'GET';
        RestContext.request = req;
        Test.startTest();
        Map<String,String> results = BBQEmployee.getEmployee();
        System.assertEquals('narendra@infosys.com', results.get('Email'));
        Test.stopTest();
    }
	//below method has been added to check condition if no employee peresent for given email
	static testMethod void getEmployeeTestForNoEmployeePresent() {
        RestRequest req = new RestRequest();
        req.requestUri ='/services/apexrest/BBQEmployee/narendra@infosys.com';
        req.httpMethod = 'GET';
        RestContext.request = req;
        Test.startTest();
        Map<String,String> results = BBQEmployee.getEmployee();
        System.assertEquals(0, results.size());
        Test.stopTest();
    }
	
    public testmethod static void createEmployeeTest(){
        BBQEmployee.createEmployee('narendra@infosys.com', 'Narendra ','Nimmana','JP','123456789','narendra@infosys.com.dev',
                                   'FirstNameNative','LastNameNative','Sfdc','Infosys', 'New');
        try{
            BBQEmployee.createEmployee('narendra@infosys.com', 'Narendra ','Nimmana','JP','123456789','narendra@infosys.com.dev',
                                       'FirstNameNative','LastNameNative','Sfdc','Infosys','New');
            BBQEmployee.createEmployee('narendra@infosys.com', 'Narendra ','Nimmana','JP1','123456789','narendra@infosys.com.dev',
                                       'FirstNameNative','LastNameNative','Sfdc','Infosys','New');
            BBQEmployee.createEmployee('narendra@infosys.com', 'Narendra ','Nimmana','JP','123456789','narendra@infosys.com.dev',
                                       'FirstNameNative','LastNameNative','Sfdc','Infosys','Update');
        }catch(Exception e){
            
        }
    }
}