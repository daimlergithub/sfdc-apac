@isTest
public class BBQReferralTest {
    static testMethod void ReferralsTestMethod() {
        BBQEmployee.createEmployee('narendra@infosys.com', 'Narendra ','Nimmana','JP','123456789','narendra@infosys.com.dev',
                                   'FirstNameNative','LastNameNative','Sfdc','Infosys');
        BBQReferral.createReferral('RefferralEmail@infy.com','Narendra ','Nimmana','JP','123456789','Address','Dealer','True',
                                  'A-Class','12345','narendra@infosys.com','New Car','fNative','lNative','Private Customer','Infosys');
        try{
            BBQReferral.createReferral('RefferralEmail@infy.com','Narendra ','Nimmana','JP1','123456789','Address','Dealer','True',
                                  'A-Class','12345','narendra@infosys.com','New Car','fNative','lNative','Private Customer','Infosys');
        }
        Catch(Exception e){}
        RestRequest req = new RestRequest();
        req.requestUri ='/services/apexrest/BBQReferral/narendra@infosys.com';
        req.httpMethod = 'GET';
        RestContext.request = req;
        Test.startTest();
        Map<String,List<Referral__c>> results = BBQReferral.getReferral();
        //System.assertEquals('narendra@infosys.com', results.get('Email'));
        Test.stopTest();
    }
}