@isTest
private class EpaApplicationInfoWebserviceTest
{
    public class ApplicationInfoWebServiceMock implements WebServiceMock
    {
        private Object response;

        public ApplicationInfoWebServiceMock(Object aResponse)
        {
            response = aResponse;
        }

        public void doInvoke(Object aStub, Object aRequest, Map<String, Object> aResponse, String aEndpoint, String aSoapAction,
                             String aRequestName, String aResponseNS, String aResponseName, String aResponseType)
        {
            aResponse.put('response_x', response);
        }
    }

    static testMethod void testgetAllCrmQueues()
    {
        EpaApplicationInfoWebservice.getAllCrmQueuesResponse response = new EpaApplicationInfoWebservice.getAllCrmQueuesResponse();
        response.return_x = new List<EpaApplicationInfoWebservice.CrmQueue>();
        response.return_x.add(new EpaApplicationInfoWebservice.CrmQueue());

        prepareWebServiceTest(response);

        Test.startTest();
        EpaApplicationInfoWebservice.CrmQueue[] result = new EpaApplicationInfoWebService.ApplicationInfoPort().getAllCrmQueues();
        Test.stopTest();

        System.assertEquals(response.return_x, result);
    }

    static testMethod void testgetEpaApplicationVersions()
    {
        EpaApplicationInfoWebservice.getEpaApplicationVersionResponse response = new EpaApplicationInfoWebservice.getEpaApplicationVersionResponse();
        response.return_x = new List<String>();

        prepareWebServiceTest(response);

        Test.startTest();
        String[] result = new EpaApplicationInfoWebService.ApplicationInfoPort().getEpaApplicationVersion();
        Test.stopTest();

        System.assertEquals(response.return_x, result);
    }

    static testMethod void testgetEpaBaseVersions()
    {
        EpaApplicationInfoWebservice.getEpaBaseVersionResponse response = new EpaApplicationInfoWebservice.getEpaBaseVersionResponse();
        response.return_x = '';

        prepareWebServiceTest(response);

        Test.startTest();
        String result = new EpaApplicationInfoWebService.ApplicationInfoPort().getEpaBaseVersion();
        Test.stopTest();

        System.assertEquals(response.return_x, result);
    }

    static testMethod void testgetServerStatus()
    {
        EpaApplicationInfoWebservice.getServerStatusResponse response = new EpaApplicationInfoWebservice.getServerStatusResponse();
        response.return_x = new List<EpaApplicationInfoWebservice.ServerStatus>();
        response.return_x.add(new EpaApplicationInfoWebservice.ServerStatus());

        prepareWebServiceTest(response);

        Test.startTest();
        EpaApplicationInfoWebservice.ServerStatus[] result = new EpaApplicationInfoWebService.ApplicationInfoPort().getServerStatus();
        Test.stopTest();

        System.assertEquals(response.return_x, result);
    }

    static testMethod void testgetStatusValues()
    {
        EpaApplicationInfoWebservice.getStatusValuesResponse response = new EpaApplicationInfoWebservice.getStatusValuesResponse();
        response.return_x = new List<String>();

        prepareWebServiceTest(response);

        Test.startTest();
        String[] result = new EpaApplicationInfoWebService.ApplicationInfoPort().getStatusValues();
        Test.stopTest();

        System.assertEquals(response.return_x, result);
    }

    static testMethod void testgetMessageOrigins()
    {
        EpaApplicationInfoWebservice.getMessageOriginsResponse response = new EpaApplicationInfoWebservice.getMessageOriginsResponse();
        response.return_x = new List<String>();

        prepareWebServiceTest(response);

        Test.startTest();
        String[] result = new EpaApplicationInfoWebService.ApplicationInfoPort().getMessageOrigins();
        Test.stopTest();

        System.assertEquals(response.return_x, result);
    }

    static testMethod void testgetEpaQueues()
    {
        EpaApplicationInfoWebservice.getEpaQueuesResponse response = new EpaApplicationInfoWebservice.getEpaQueuesResponse();
        response.return_x = new EpaApplicationInfoWebservice.EpaQueues();

        prepareWebServiceTest(response);

        Test.startTest();
        EpaApplicationInfoWebservice.EpaQueues result = new EpaApplicationInfoWebService.ApplicationInfoPort().getEpaQueues();
        Test.stopTest();

        System.assertEquals(response.return_x, result);
    }

    static testMethod void testgetEpaApplicationName()
    {
        EpaApplicationInfoWebservice.getEpaApplicationNameResponse response = new EpaApplicationInfoWebservice.getEpaApplicationNameResponse();
        response.return_x = new List<String>();

        prepareWebServiceTest(response);

        Test.startTest();
        String[] result = new EpaApplicationInfoWebService.ApplicationInfoPort().getEpaApplicationName();
        Test.stopTest();

        System.assertEquals(response.return_x, result);
    }

    static testMethod void testgetContextFactoryClass()
    {
        EpaApplicationInfoWebservice.getContextFactoryClassResponse response = new EpaApplicationInfoWebservice.getContextFactoryClassResponse();
        response.return_x = '';

        prepareWebServiceTest(response);

        Test.startTest();
        String result = new EpaApplicationInfoWebService.ApplicationInfoPort().getContextFactoryClass();
        Test.stopTest();

        System.assertEquals(response.return_x, result);
    }

    static testMethod void testgetContextUrl()
    {
        EpaApplicationInfoWebservice.getContextUrlResponse response = new EpaApplicationInfoWebservice.getContextUrlResponse();
        response.return_x = '';

        prepareWebServiceTest(response);

        Test.startTest();
        String result = new EpaApplicationInfoWebService.ApplicationInfoPort().getContextUrl();
        Test.stopTest();

        System.assertEquals(response.return_x, result);
    }

    static testMethod void testgetUseCases()
    {
        EpaApplicationInfoWebservice.getUseCasesResponse response = new EpaApplicationInfoWebservice.getUseCasesResponse();
        response.return_x = new List<String>();

        prepareWebServiceTest(response);

        Test.startTest();
        String[] result = new EpaApplicationInfoWebService.ApplicationInfoPort().getUseCases();
        Test.stopTest();

        System.assertEquals(response.return_x, result);
    }

    static testMethod void testgetOrganizations()
    {
        EpaApplicationInfoWebservice.getOrganizationsResponse response = new EpaApplicationInfoWebservice.getOrganizationsResponse();
        response.return_x = new List<String>();

        prepareWebServiceTest(response);

        Test.startTest();
        String[] result = new EpaApplicationInfoWebService.ApplicationInfoPort().getOrganizations();
        Test.stopTest();

        System.assertEquals(response.return_x, result);
    }

    static testMethod void testgetEpaInterfaces()
    {
        EpaApplicationInfoWebservice.getEpaInterfacesResponse response = new EpaApplicationInfoWebservice.getEpaInterfacesResponse();
        response.return_x = new EpaApplicationInfoWebservice.EpaInterfaces();

        prepareWebServiceTest(response);

        Test.startTest();
        EpaApplicationInfoWebservice.EpaInterfaces result = new EpaApplicationInfoWebService.ApplicationInfoPort().getEpaInterfaces();
        Test.stopTest();

        System.assertEquals(response.return_x, result);
    }

    static void prepareWebServiceTest(Object aResponse)
    {
        Test.setMock(WebServiceMock.class, new ApplicationInfoWebServiceMock(aResponse));

        upsert new EPA_Settings__c(Name = 'epa.base.url', Value__c='http://base.url');
    }
}