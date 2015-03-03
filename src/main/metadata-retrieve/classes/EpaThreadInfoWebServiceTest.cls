@isTest
private class EpaThreadInfoWebServiceTest
{
    public class ThreadInfoWebServiceMock implements WebServiceMock
    {
        private Object response;

        public ThreadInfoWebServiceMock(Object aResponse)
        {
            response = aResponse;
        }

        public void doInvoke(Object aStub, Object aRequest, Map<String, Object> aResponse, String aEndpoint, String aSoapAction,
                             String aRequestName, String aResponseNS, String aResponseName, String aResponseType)
        {
            aResponse.put('response_x', response);
        }
    }

    static testMethod void testgetCurrentThreads()
    {
        EpaThreadInfoWebService.getCurrentThreadsResponse response = new EpaThreadInfoWebService.getCurrentThreadsResponse();
        response.return_x = new EpaThreadInfoWebService.EpaThreads();
        response.return_x.EpaThreads = new List<EpaThreadInfoWebService.EpaThread>();
        response.return_x.EpaThreads.add(new EpaThreadInfoWebService.EpaThread());
        response.return_x.EpaThreads.get(0).Server = '1';
        response.return_x.EpaThreads.get(0).Name = '2';
        response.return_x.EpaThreads.get(0).TransactionId = '3';
        response.return_x.EpaThreads.get(0).StartTime = '4';
        response.return_x.EpaThreads.get(0).ThreadId = '5';
        response.return_x.EpaThreads.get(0).Organization = '6';
        response.return_x.EpaThreads.get(0).UseCase = '7';
        response.return_x.EpaThreads.get(0).InterfaceName = '8';
        response.return_x.EpaThreads.get(0).Stacktrace = new List<EpaThreadInfoWebService.EpaStacktraceElement>();
        response.return_x.EpaThreads.get(0).Stacktrace.add(new EpaThreadInfoWebService.EpaStacktraceElement());
        response.return_x.EpaThreads.get(0).Stacktrace.get(0).DeclaringClass = '1';
        response.return_x.EpaThreads.get(0).Stacktrace.get(0).MethodName = '2';
        response.return_x.EpaThreads.get(0).Stacktrace.get(0).FileName = '3';
        response.return_x.EpaThreads.get(0).Stacktrace.get(0).LineNumber = '4';
        response.return_x.EpaThreads.get(0).ThreadInfo = '9';
        response.return_x.EpaThreads.get(0).ElapsedTimeInMsecs = 10;
        response.return_x.EpaThreads.get(0).UsedCpuTimeInMsecs = 11;
        response.return_x.EpaThreads.get(0).UsedUserTimeInMsecs = 12;
        response.return_x.EpaThreads.get(0).UsedSystemTimeInMsecs = 13;

        prepareWebServiceTest(response);

        Test.startTest();
        EpaThreadInfoWebService.EpaThreads result = new EpaThreadInfoWebService.ThreadInfoPort().getCurrentThreads();
        Test.stopTest();

        System.assertEquals(response.return_x, result);
    }

    static testMethod void testgetDeadLockInfo()
    {
        EpaThreadInfoWebService.getDeadLockInfoResponse response = new EpaThreadInfoWebService.getDeadLockInfoResponse();
        response.return_x = new List<String>();

        prepareWebServiceTest(response);

        Test.startTest();
        String[] result = new EpaThreadInfoWebService.ThreadInfoPort().getDeadLockInfo();
        Test.stopTest();

        System.assertEquals(response.return_x, result);
    }

    static testMethod void testinterruptThread()
    {
        EpaThreadInfoWebService.getDeadLockInfoResponse response = new EpaThreadInfoWebService.getDeadLockInfoResponse();

        prepareWebServiceTest(new EpaThreadInfoWebService.interruptThreadResponse());

        Test.startTest();
        new EpaThreadInfoWebService.ThreadInfoPort().interruptThread('2');
        Test.stopTest();
    }

    static void prepareWebServiceTest(Object aResponse)
    {
        Test.setMock(WebServiceMock.class, new ThreadInfoWebServiceMock(aResponse));

        upsert new EPA_Settings__c(Name = 'epa.base.url', Value__c='http://base.url');
    }
}