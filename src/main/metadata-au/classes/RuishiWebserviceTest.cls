@isTest
public class RuishiWebserviceTest{
    static testmethod void testMethod1(){                          
        Test.setMock(WebServiceMock.class, new WebserviceMockImpl());      
        RuishiWebService.CreateUser_element cu = new RuishiWebService.CreateUser_element();
        RuishiWebService.CreateUserResponse_element cresp = new RuishiWebService.CreateUserResponse_element();
        RuishiWebService.RuishiWebServerSoap soapMethodClass = new RuishiWebService.RuishiWebServerSoap();
        Boolean check = soapMethodClass.CreateUser('Id','UserName','Email','Phone','Role','Profile');
        }
}