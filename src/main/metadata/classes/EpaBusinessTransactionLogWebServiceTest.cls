@isTest
global class EpaBusinessTransactionLogWebServiceTest
{
    public class BusinessTransactionLogWebServiceMock implements WebServiceMock
    {
    	  private Object response;

    	  public BusinessTransactionLogWebServiceMock(Object aResponse)
    	  {
            response = aResponse;
    	  }

        public void doInvoke(Object aStub, Object aRequest, Map<String, Object> aResponse, String aEndpoint, String aSoapAction,
                             String aRequestName, String aResponseNS, String aResponseName, String aResponseType)
        {
            aResponse.put('response_x', response);
        }
    }

    static testMethod void testGetStepsById()
    {
        EpaBusinessTransactionLogWebService.GetStepsByIdResponse response = new EpaBusinessTransactionLogWebService.GetStepsByIdResponse();
        response.GetStepsByIdResult = new List<EpaBusinessTransactionLogWebService.BtlStepWto>();
        response.GetStepsByIdResult.add(new EpaBusinessTransactionLogWebService.BtlStepWto());
        response.GetStepsByIdResult.get(0).Id = '1';
        response.GetStepsByIdResult.get(0).ParentStepId = '2';
        response.GetStepsByIdResult.get(0).StepName = 'Name';
        response.GetStepsByIdResult.get(0).StartDt = DateTime.now();
        response.GetStepsByIdResult.get(0).EndDt = DateTime.now();
        response.GetStepsByIdResult.get(0).Duration = 1;
        response.GetStepsByIdResult.get(0).UsedCpuTime = 2;
        response.GetStepsByIdResult.get(0).UsedUserTime = 3;
        response.GetStepsByIdResult.get(0).UsedSystemTime = 4;
        response.GetStepsByIdResult.get(0).StepAdditionalInfo = 'AddInfo';
        response.GetStepsByIdResult.get(0).Depth = 5;
        response.GetStepsByIdResult.get(0).Server = 'Server';
        response.GetStepsByIdResult.get(0).AdditionalInformation = new List<EpaBusinessTransactionLogWebService.BtlAdditionalInfoWto>();
        response.GetStepsByIdResult.get(0).AdditionalInformation.add(new EpaBusinessTransactionLogWebService.BtlAdditionalInfoWto());
        response.GetStepsByIdResult.get(0).AdditionalInformation.get(0).Id = '1';
        response.GetStepsByIdResult.get(0).Error = new List<EpaBusinessTransactionLogWebService.BtlError>();
        response.GetStepsByIdResult.get(0).Error.add(new EpaBusinessTransactionLogWebService.BtlError());
        response.GetStepsByIdResult.get(0).Error.get(0).Id = '1';
        response.GetStepsByIdResult.get(0).Error.get(0).Organization = '1';
        response.GetStepsByIdResult.get(0).Error.get(0).UseCase = '1';
        response.GetStepsByIdResult.get(0).Error.get(0).UniqueExternalId = '1';
        response.GetStepsByIdResult.get(0).Error.get(0).Origin = '1';
        response.GetStepsByIdResult.get(0).Error.get(0).OriginDetails = '1';
        response.GetStepsByIdResult.get(0).Error.get(0).TrnsctId = '1';
        response.GetStepsByIdResult.get(0).Error.get(0).ParentTrnsctId = '1';
        response.GetStepsByIdResult.get(0).Error.get(0).StartDt = DateTime.now();
        response.GetStepsByIdResult.get(0).Error.get(0).EndDt = DateTime.now();
        response.GetStepsByIdResult.get(0).Error.get(0).Status = '1';
        response.GetStepsByIdResult.get(0).Error.get(0).Step = '1';
        response.GetStepsByIdResult.get(0).Error.get(0).Error = '1';
        response.GetStepsByIdResult.get(0).Error.get(0).ErrorCode = '1';
        response.GetStepsByIdResult.get(0).Error.get(0).ErrorSeverity = '1';
        response.GetStepsByIdResult.get(0).Error.get(0).Message = '1';
        response.GetStepsByIdResult.get(0).Error.get(0).ProblemSolver = '1';
        response.GetStepsByIdResult.get(0).Error.get(0).ErrorType = '1';

        prepareWebServiceTest(response);

        List<String> stepIds = new List<String>();
        stepIds.add('1');
        stepIds.add('2');

        Test.startTest();
        EpaBusinessTransactionLogWebService.BtlStepWto[] result = new EpaBusinessTransactionLogWebService.BusinessTransactionLogPort().GetStepsById(stepIds);
        Test.stopTest();

        System.assertEquals(response.GetStepsByIdResult, result);
    }

    static testMethod void testGetPerformanceLogInformationForTransaction()
    {
        EpaBusinessTransactionLogWebService.GetPerformanceLogInformationForTransactionResponse response = new EpaBusinessTransactionLogWebService.GetPerformanceLogInformationForTransactionResponse();
        response.GetPerformanceLogInformationForTransactionResult = new List<EpaBusinessTransactionLogWebService.PerformanceLog>();
        response.GetPerformanceLogInformationForTransactionResult.add(new EpaBusinessTransactionLogWebService.PerformanceLog());
        response.GetPerformanceLogInformationForTransactionResult.get(0).TrnsctId = '1';
        response.GetPerformanceLogInformationForTransactionResult.get(0).TrnsctStepId = '2';
        response.GetPerformanceLogInformationForTransactionResult.get(0).LogDate = DateTime.now();
        response.GetPerformanceLogInformationForTransactionResult.get(0).EventType = '3';
        response.GetPerformanceLogInformationForTransactionResult.get(0).Event = '4';
        response.GetPerformanceLogInformationForTransactionResult.get(0).Duration = 5;
        response.GetPerformanceLogInformationForTransactionResult.get(0).UsedCpuTime = 6;
        response.GetPerformanceLogInformationForTransactionResult.get(0).UsedUserTime = 7;
        response.GetPerformanceLogInformationForTransactionResult.get(0).UsedSystemTime = 8;
        response.GetPerformanceLogInformationForTransactionResult.get(0).CompleteLogDate = 9;
        response.GetPerformanceLogInformationForTransactionResult.get(0).IncludesOtherEvents = true;
        response.GetPerformanceLogInformationForTransactionResult.get(0).StackTrace = '10';

        prepareWebServiceTest(response);

        Test.startTest();
        EpaBusinessTransactionLogWebService.PerformanceLog[] result = new EpaBusinessTransactionLogWebService.BusinessTransactionLogPort().GetPerformanceLogInformationForTransaction('1');
        Test.stopTest();

        System.assertEquals(response.GetPerformanceLogInformationForTransactionResult, result);
    }

    static testMethod void testGetPerformanceLogInformationForStep()
    {
        EpaBusinessTransactionLogWebService.GetPerformanceLogInformationForStepResponse response = new EpaBusinessTransactionLogWebService.GetPerformanceLogInformationForStepResponse();
        response.GetPerformanceLogInformationForStepResult = new List<EpaBusinessTransactionLogWebService.PerformanceLog>();

        prepareWebServiceTest(response);

        Test.startTest();
        EpaBusinessTransactionLogWebService.PerformanceLog[] result = new EpaBusinessTransactionLogWebService.BusinessTransactionLogPort().GetPerformanceLogInformationForStep('1');
        Test.stopTest();

        System.assertEquals(response.GetPerformanceLogInformationForStepResult, result);
    }

    static testMethod void testGetNumTransactions()
    {
        EpaBusinessTransactionLogWebService.GetNumTransactionsResponse response = new EpaBusinessTransactionLogWebService.GetNumTransactionsResponse();
        response.return_x = 10;

        prepareWebServiceTest(response);

        Test.startTest();
        Integer result = new EpaBusinessTransactionLogWebService.BusinessTransactionLogPort().GetNumTransactions(null);
        Test.stopTest();

        System.assertEquals(10, result);
    }

    static testMethod void testGetInterfaceCosts()
    {
        EpaBusinessTransactionLogWebService.GetInterfaceCostsResponse response = new EpaBusinessTransactionLogWebService.GetInterfaceCostsResponse();
        response.GetInterfaceCostsResult = new List<EpaBusinessTransactionLogWebService.InterfaceCosts>();

        prepareWebServiceTest(response);

        Test.startTest();
        EpaBusinessTransactionLogWebService.InterfaceCosts[] result = new EpaBusinessTransactionLogWebService.BusinessTransactionLogPort().GetInterfaceCosts(null);
        Test.stopTest();

        System.assertEquals(response.GetInterfaceCostsResult, result);
    }

    static testMethod void testGetErrors()
    {
        EpaBusinessTransactionLogWebService.GetErrorsResponse response = new EpaBusinessTransactionLogWebService.GetErrorsResponse();
        response.GetErrorsResult = new List<EpaBusinessTransactionLogWebService.BtlError>();

        prepareWebServiceTest(response);

        Test.startTest();
        EpaBusinessTransactionLogWebService.BtlError[] result = new EpaBusinessTransactionLogWebService.BusinessTransactionLogPort().GetErrors(null);
        Test.stopTest();

        System.assertEquals(response.GetErrorsResult, result);
    }

    static testMethod void testPrepareRequestReload()
    {
        prepareWebServiceTest(null);

        Test.startTest();
        new EpaBusinessTransactionLogWebService.BusinessTransactionLogPort().PrepareRequestReload(null);
        Test.stopTest();
    }

    static testMethod void testGetStepIdsByTransactionId()
    {
        EpaBusinessTransactionLogWebService.GetStepIdsByTransactionIdResponse response = new EpaBusinessTransactionLogWebService.GetStepIdsByTransactionIdResponse();
        response.GetStepIdsByTransactionIdResult = new List<EpaBusinessTransactionLogWebService.BtlStepReferenceWto>();

        prepareWebServiceTest(response);

        Test.startTest();
        EpaBusinessTransactionLogWebService.BtlStepReferenceWto[] result = new EpaBusinessTransactionLogWebService.BusinessTransactionLogPort().GetStepIdsByTransactionId(null);
        Test.stopTest();

        System.assertEquals(response.GetStepIdsByTransactionIdResult, result);
    }

    static testMethod void testGetBusinessTransactionIds()
    {
        EpaBusinessTransactionLogWebService.GetBusinessTransactionIdsResponse response = new EpaBusinessTransactionLogWebService.GetBusinessTransactionIdsResponse();
        response.GetBusinessTransactionIdsResult = new List<String>();

        prepareWebServiceTest(response);

        EpaBusinessTransactionLogWebService.BtlTransactionSearchCriteria searchCriteria = new EpaBusinessTransactionLogWebService.BtlTransactionSearchCriteria();
        searchCriteria.NumberOfTransactionsToExamine = 1;
        searchCriteria.TrnsctId = '2';
        searchCriteria.ParentTrnsctId = '3';
        searchCriteria.RequestId = '4';
        searchCriteria.Organization = '5';
        searchCriteria.UseCase = '6';
        searchCriteria.Status = '7';
        searchCriteria.UniqueExternalId = '8';
        searchCriteria.Origin = '9';
        searchCriteria.OriginDetail = '10';
        searchCriteria.InterfaceName = '11';
        searchCriteria.ActiveAt = DateTime.now();
        searchCriteria.MinRuntime = 12;
        searchCriteria.FromStartDate = DateTime.now();
        searchCriteria.ToStartDate = DateTime.now();
        searchCriteria.FromEndDate = DateTime.now();
        searchCriteria.ToEndDate = DateTime.now();
        searchCriteria.FromStepDate = DateTime.now();
        searchCriteria.ToStepDate = DateTime.now();
        searchCriteria.FromErrorDate = DateTime.now();
        searchCriteria.ToErrorDate = DateTime.now();

        Test.startTest();
        String[] result = new EpaBusinessTransactionLogWebService.BusinessTransactionLogPort().GetBusinessTransactionIds(searchCriteria);
        Test.stopTest();

        System.assertEquals(response.GetBusinessTransactionIdsResult, result);
    }

    static testMethod void testGetBusinessTransactionsByIds()
    {
        EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse response = new EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse();
        response.GetBusinessTransactionsByIdsResult = new List<EpaBusinessTransactionLogWebService.BtlTransaction>();
        response.GetBusinessTransactionsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlTransaction());
        response.GetBusinessTransactionsByIdsResult.get(0).TrnsctId = '1';
        response.GetBusinessTransactionsByIdsResult.get(0).ParentTrnsctId = '2';
        response.GetBusinessTransactionsByIdsResult.get(0).RequestId = '3';
        response.GetBusinessTransactionsByIdsResult.get(0).Organization = '4';
        response.GetBusinessTransactionsByIdsResult.get(0).UseCase = '5';
        response.GetBusinessTransactionsByIdsResult.get(0).InterfaceName = '6';
        response.GetBusinessTransactionsByIdsResult.get(0).Status = '7';
        response.GetBusinessTransactionsByIdsResult.get(0).UniqueExternalId = '8';
        response.GetBusinessTransactionsByIdsResult.get(0).Origin = '9';
        response.GetBusinessTransactionsByIdsResult.get(0).OriginDetails = '10';
        response.GetBusinessTransactionsByIdsResult.get(0).InputChannel = '11';
        response.GetBusinessTransactionsByIdsResult.get(0).StartDt = DateTime.now();
        response.GetBusinessTransactionsByIdsResult.get(0).ProcessingStartDt = DateTime.now();
        response.GetBusinessTransactionsByIdsResult.get(0).EndDt = DateTime.now();
        response.GetBusinessTransactionsByIdsResult.get(0).Duration = 12;
        response.GetBusinessTransactionsByIdsResult.get(0).UsedCpuTime = 13;
        response.GetBusinessTransactionsByIdsResult.get(0).UsedUserTime = 14;
        response.GetBusinessTransactionsByIdsResult.get(0).UsedSystemTime = 15;
        response.GetBusinessTransactionsByIdsResult.get(0).Reloadable = true;
        response.GetBusinessTransactionsByIdsResult.get(0).SrcObjectInt = '16';
        response.GetBusinessTransactionsByIdsResult.get(0).SrcObjectExt = '17';
        response.GetBusinessTransactionsByIdsResult.get(0).Response = '18';
        response.GetBusinessTransactionsByIdsResult.get(0).Server = '19';
        response.GetBusinessTransactionsByIdsResult.get(0).EpaVersion = '20';
        response.GetBusinessTransactionsByIdsResult.get(0).EpaRevision = '21';
        response.GetBusinessTransactionsByIdsResult.get(0).EpaBuild = '22';
        response.GetBusinessTransactionsByIdsResult.get(0).Environment = '23';

        prepareWebServiceTest(response);

        Test.startTest();
        EpaBusinessTransactionLogWebService.BtlTransaction[] result = new EpaBusinessTransactionLogWebService.BusinessTransactionLogPort().GetBusinessTransactionsByIds(null);
        Test.stopTest();

        System.assertEquals(response.GetBusinessTransactionsByIdsResult, result);
    }

    static testMethod void testGetRequestsByIds()
    {
        EpaBusinessTransactionLogWebService.GetRequestsByIdsResponse response = new EpaBusinessTransactionLogWebService.GetRequestsByIdsResponse();
        response.GetRequestsByIdsResult = new List<EpaBusinessTransactionLogWebService.BtlRequestWto>();
        response.GetRequestsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlRequestWto());
        response.GetRequestsByIdsResult.get(0).RequestId = '1';
        response.GetRequestsByIdsResult.get(0).Organization = '1';
        response.GetRequestsByIdsResult.get(0).UseCase = '1';
        response.GetRequestsByIdsResult.get(0).InterfaceName = '1';
        response.GetRequestsByIdsResult.get(0).UniqueExternalId = '1';
        response.GetRequestsByIdsResult.get(0).Origin = '1';
        response.GetRequestsByIdsResult.get(0).OriginDetails = '1';
        response.GetRequestsByIdsResult.get(0).InputChannel = '1';
        response.GetRequestsByIdsResult.get(0).RequestDt = DateTime.now();
        response.GetRequestsByIdsResult.get(0).ReloadDt = DateTime.now();
        response.GetRequestsByIdsResult.get(0).Reloadable = true;
        response.GetRequestsByIdsResult.get(0).SrcObjectExt = '1';
        response.GetRequestsByIdsResult.get(0).AffectedOrg = '1';
        response.GetRequestsByIdsResult.get(0).responsibleOrg = '1';

        prepareWebServiceTest(response);

        Test.startTest();
        EpaBusinessTransactionLogWebService.BtlRequestWto[] result = new EpaBusinessTransactionLogWebService.BusinessTransactionLogPort().GetRequestsByIds(null);
        Test.stopTest();

        System.assertEquals(response.GetRequestsByIdsResult, result);
    }

    static void prepareWebServiceTest(Object aResponse)
    {
        Test.setMock(WebServiceMock.class, new BusinessTransactionLogWebServiceMock(aResponse));

        upsert new EPA_Settings__c(Name = 'epa.base.url', Value__c='http://base.url');
    }
}