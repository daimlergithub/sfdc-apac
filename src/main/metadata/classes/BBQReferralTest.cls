@isTest
public class BBQReferralTest {
    static testMethod void ReferralsTestMethod() {
        BBQEmployee.createEmployee('narendra@infosys.com', 'Narendra ','Nimmana','JP','123456789','narendra@infosys.com.dev',
                                   'FirstNameNative','LastNameNative','Sfdc','Infosys','New');
        BBQReferral.createReferral('RefferralEmail@infy.com','Narendra ','Nimmana','JP','123456789','Address','Dealer','True',
                                  'A-Class','12345','narendra@infosys.com','New Car','fNative','lNative','Private Customer','Infosys','As a new customer','This is for comment');
		BBQReferral.createReferral('test@test.com','test ','test','JP','123456789','Address','Dealer','True',
                                  'A-Class','12345','testEmailIdNotPresent@testing.com','New Car','fNative','lNative','Private Customer','test','As a new customer','This is for comment');						  
        try{
            BBQReferral.createReferral('RefferralEmail@infy.com','Narendra ','Nimmana','JP1','123456789','Address','Dealer','True',
                                  'A-Class','12345','narendra@infosys.com','New Car','fNative','lNative','Private Customer','Infosys','As a new customer','This is for comment');
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