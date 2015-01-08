@isTest
private class EpaAdminCommandWebServiceTest
{
    public class AdminCommandWebServiceMock implements WebServiceMock
    {
        private Object response;

        public AdminCommandWebServiceMock(Object aResponse)
        {
            response = aResponse;
        }

        public void doInvoke(Object aStub, Object aRequest, Map<String, Object> aResponse, String aEndpoint, String aSoapAction,
                             String aRequestName, String aResponseNS, String aResponseName, String aResponseType)
        {
            aResponse.put('response_x', response);
        }
    }

    static testMethod void testgetAvailableCommands()
    {
        EpaAdminCommandWebService.getAvailableCommandsResponse response = new EpaAdminCommandWebService.getAvailableCommandsResponse();
        response.return_x = 'COMMANDS';

        prepareWebServiceTest(response);

        Test.startTest();
        String result = new EpaAdminCommandWebService.AdminCommandPort().getAvailableCommands();
        Test.stopTest();
        System.assertEquals(response.return_x, result);
    }

    static testMethod void testexecuteCommand()
    {
        EpaAdminCommandWebService.executeCommandResponse response = new EpaAdminCommandWebService.executeCommandResponse();
        response.return_x = 'RESPONSE';

        prepareWebServiceTest(response);

        Test.startTest();
        String result = new EpaAdminCommandWebService.AdminCommandPort().executeCommand('COMMAND');
        Test.stopTest();
        System.assertEquals(response.return_x, result);
    }

    static void prepareWebServiceTest(Object aResponse)
    {
        Test.setMock(WebServiceMock.class, new AdminCommandWebServiceMock(aResponse));

        upsert new EPA_Settings__c(Name = 'epa.base.url', Value__c='http://base.url');
    }
}