@isTest
public class BBQEmployeeTest {
    static testMethod void getEmployeeTest() {
        BBQEmployee.createEmployee('narendra@infosys.com', 'Narendra ','Nimmana','JP','123456789','narendra@infosys.com.dev',
                                   'FirstNameNative','LastNameNative','Sfdc','Infosys');
        RestRequest req = new RestRequest();
        req.requestUri ='/services/apexrest/BBQEmployee/narendra@infosys.com';
        req.httpMethod = 'GET';
        RestContext.request = req;
        Test.startTest();
        Map<String,String> results = BBQEmployee.getEmployee();
        System.assertEquals('narendra@infosys.com', results.get('Email'));
        Test.stopTest();
    }
    public testmethod static void createEmployeeTest(){
        BBQEmployee.createEmployee('narendra@infosys.com', 'Narendra ','Nimmana','JP','123456789','narendra@infosys.com.dev',
                                   'FirstNameNative','LastNameNative','Sfdc','Infosys');
        try{
            BBQEmployee.createEmployee('narendra@infosys.com', 'Narendra ','Nimmana','JP','123456789','narendra@infosys.com.dev',
                                       'FirstNameNative','LastNameNative','Sfdc','Infosys');
            BBQEmployee.createEmployee('narendra@infosys.com', 'Narendra ','Nimmana','JP1','123456789','narendra@infosys.com.dev',
                                       'FirstNameNative','LastNameNative','Sfdc','Infosys');
        }catch(Exception e){
            
        }
    }
}