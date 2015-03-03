@isTest
private class EpaBusinessTransactionLogControllerTest
{
    public class MultipleCallWebServiceMock implements WebServiceMock
    {
    	  private Integer callIndex = 0;
        private List<Object> responses;

        public MultipleCallWebServiceMock(List<Object> aResponseList)
        {
            responses = aResponseList;
        }

        public void doInvoke(Object aStub, Object aRequest, Map<String, Object> aResponse, String aEndpoint, String aSoapAction,
                             String aRequestName, String aResponseNS, String aResponseName, String aResponseType)
        {
            aResponse.put('response_x', responses.get(callIndex));
            callIndex++;
        }
    }


    static testMethod void testEpaBusinessTransactionLogController()
    {
        prepareStandardWebServices();

        Test.startTest();
        EpaBusinessTransactionLogController result = new EpaBusinessTransactionLogController();
        Test.stopTest();

        System.assertEquals(10000, result.numTransactions);
        System.assertEquals(new List<SelectOption>{new SelectOption('TRNSCT_ID','Transaction ID'), new SelectOption('PARENT_TRNSCT_ID','Parent Transaction ID'), new SelectOption('START_DT','Start Date'), new SelectOption('END_DT','End Date')}, result.sortOrders);
        System.assertEquals(new List<SelectOption>{createSelectOption(''), createSelectOption('COUNTRY_1'), createSelectOption('COUNTRY_2')}, result.countries);
        System.assertEquals(new List<SelectOption>{createSelectOption(''), createSelectOption('USECASE_1'), createSelectOption('USECASE_2')}, result.useCases);
        System.assertEquals(new List<SelectOption>{createSelectOption(''), createSelectOption('STATUS_1'), createSelectOption('STATUS_2')}, result.statusValues);
        System.assertEquals(new List<SelectOption>{createSelectOption(''), createSelectOption('ORIGIN_1'), createSelectOption('ORIGIN_2')}, result.messageOrigins);
    }

    static testMethod void testShowTransactionList()
    {
    	  prepareStandardWebServices();

        Test.startTest();
        PageReference result = new EpaBusinessTransactionLogController().showTransactionList();
        Test.stopTest();

        System.assertEquals(new PageReference('/apex/EPA_BTL_Transaction_List').getUrl(), result.getUrl());
    }

    static testMethod void testShowErrors()
    {
        prepareStandardWebServices();

        Test.startTest();
        PageReference result = new EpaBusinessTransactionLogController().showErrors();
        Test.stopTest();

        System.assertEquals(new PageReference('/apex/EPA_BTL_Errors').getUrl(), result.getUrl());
    }

    static testMethod void testLoadTransactions()
    {
        EpaBusinessTransactionLogWebService.GetBusinessTransactionIdsResponse getTransactionIdsResponse = new EpaBusinessTransactionLogWebService.GetBusinessTransactionIdsResponse();
        getTransactionIdsResponse.GetBusinessTransactionIdsResult = new List<String>{'ID_1', 'ID_2'};

        EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse getTransactionsByIdsResponse = new EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse();
        getTransactionsByIdsResponse.GetBusinessTransactionsByIdsResult = new List<EpaBusinessTransactionLogWebService.BtlTransaction>();
        getTransactionsByIdsResponse.GetBusinessTransactionsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlTransaction());
        getTransactionsByIdsResponse.GetBusinessTransactionsByIdsResult.get(0).TrnsctId = 'ID_1';
        getTransactionsByIdsResponse.GetBusinessTransactionsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlTransaction());
        getTransactionsByIdsResponse.GetBusinessTransactionsByIdsResult.get(1).TrnsctId = 'ID_2';

        prepareStandardAndAdditionalWebServices(new List<Object>{getTransactionIdsResponse, getTransactionsByIdsResponse});

        Test.startTest();
        EpaBusinessTransactionLogController controller = new EpaBusinessTransactionLogController();
        controller.loadTransactions();
        Test.stopTest();

        System.assertEquals(1, controller.transactionsPageNumber);
        System.assertEquals(1, controller.transactionsNumPages);
        System.assertEquals(10, controller.transactionsPageSize);

        System.assertEquals(2, controller.transactions.size());
        System.assertEquals('ID_1', controller.transactions.get(0).TrnsctId);
        System.assertEquals('ID_2', controller.transactions.get(1).TrnsctId);
    }

    static testMethod void testLoadNextTransactionsPage()
    {
        EpaBusinessTransactionLogWebService.GetBusinessTransactionIdsResponse getTransactionIdsResponse = new EpaBusinessTransactionLogWebService.GetBusinessTransactionIdsResponse();
        getTransactionIdsResponse.GetBusinessTransactionIdsResult = new List<String>{'ID_1', 'ID_2', 'ID_3', 'ID_4', 'ID_5'};

        EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse getTransactionsByIdsResponse1 = new EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse();
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult = new List<EpaBusinessTransactionLogWebService.BtlTransaction>();
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlTransaction());
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult.get(0).TrnsctId = 'ID_1';
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlTransaction());
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult.get(1).TrnsctId = 'ID_2';

        EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse getTransactionsByIdsResponse2 = new EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse();
        getTransactionsByIdsResponse2.GetBusinessTransactionsByIdsResult = new List<EpaBusinessTransactionLogWebService.BtlTransaction>();
        getTransactionsByIdsResponse2.GetBusinessTransactionsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlTransaction());
        getTransactionsByIdsResponse2.GetBusinessTransactionsByIdsResult.get(0).TrnsctId = 'ID_3';
        getTransactionsByIdsResponse2.GetBusinessTransactionsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlTransaction());
        getTransactionsByIdsResponse2.GetBusinessTransactionsByIdsResult.get(1).TrnsctId = 'ID_4';

        prepareStandardAndAdditionalWebServices(new List<Object>{getTransactionIdsResponse, getTransactionsByIdsResponse1, getTransactionsByIdsResponse2});

        Test.startTest();
        EpaBusinessTransactionLogController controller = new EpaBusinessTransactionLogController();
        controller.transactionsPageSize = 2;
        controller.loadTransactions();
        System.assertEquals(2, controller.transactions.size());
        controller.loadNextTransactionsPage();
        Test.stopTest();

        System.assertEquals(2, controller.transactionsPageNumber);
        System.assertEquals(3, controller.transactionsNumPages);
        System.assertEquals(2, controller.transactionsPageSize);

        System.assertEquals(2, controller.transactions.size());
        System.assertEquals('ID_3', controller.transactions.get(0).TrnsctId);
        System.assertEquals('ID_4', controller.transactions.get(1).TrnsctId);
    }

    static testMethod void testGetHasNextTransactionsPage()
    {
        prepareStandardWebServices();

        Test.startTest();
        EpaBusinessTransactionLogController controller = new EpaBusinessTransactionLogController();
        controller.transactionsPageSize = 2;
        controller.transactionsNumPages = 2;
        controller.transactionsPageNumber = 1;
        System.assertEquals(true, controller.getHasNextTransactionsPage());
        controller.transactionsPageNumber = 2;
        System.assertEquals(false, controller.getHasNextTransactionsPage());
        Test.stopTest();
    }

    static testMethod void testLoadPreviousTransactionsPage()
    {
        EpaBusinessTransactionLogWebService.GetBusinessTransactionIdsResponse getTransactionIdsResponse = new EpaBusinessTransactionLogWebService.GetBusinessTransactionIdsResponse();
        getTransactionIdsResponse.GetBusinessTransactionIdsResult = new List<String>{'ID_1', 'ID_2', 'ID_3', 'ID_4', 'ID_5'};

        EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse getTransactionsByIdsResponse1 = new EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse();
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult = new List<EpaBusinessTransactionLogWebService.BtlTransaction>();
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlTransaction());
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult.get(0).TrnsctId = 'ID_1';
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlTransaction());
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult.get(1).TrnsctId = 'ID_2';

        EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse getTransactionsByIdsResponse2 = new EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse();
        getTransactionsByIdsResponse2.GetBusinessTransactionsByIdsResult = new List<EpaBusinessTransactionLogWebService.BtlTransaction>();
        getTransactionsByIdsResponse2.GetBusinessTransactionsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlTransaction());
        getTransactionsByIdsResponse2.GetBusinessTransactionsByIdsResult.get(0).TrnsctId = 'ID_3';
        getTransactionsByIdsResponse2.GetBusinessTransactionsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlTransaction());
        getTransactionsByIdsResponse2.GetBusinessTransactionsByIdsResult.get(1).TrnsctId = 'ID_4';

        prepareStandardAndAdditionalWebServices(new List<Object>{getTransactionIdsResponse, getTransactionsByIdsResponse1, getTransactionsByIdsResponse2, getTransactionsByIdsResponse1});

        Test.startTest();
        EpaBusinessTransactionLogController controller = new EpaBusinessTransactionLogController();
        controller.transactionsPageSize = 2;
        controller.loadTransactions();
        System.assertEquals(2, controller.transactions.size());
        controller.loadNextTransactionsPage();
        controller.loadPreviousTransactionsPage();
        Test.stopTest();

        System.assertEquals(1, controller.transactionsPageNumber);
        System.assertEquals(3, controller.transactionsNumPages);
        System.assertEquals(2, controller.transactionsPageSize);

        System.assertEquals(2, controller.transactions.size());
        System.assertEquals('ID_1', controller.transactions.get(0).TrnsctId);
        System.assertEquals('ID_2', controller.transactions.get(1).TrnsctId);
    }

    static testMethod void testGetHasPreviousTransactionsPage()
    {
        prepareStandardWebServices();

        Test.startTest();
        EpaBusinessTransactionLogController controller = new EpaBusinessTransactionLogController();
        controller.transactionsPageSize = 2;
        controller.transactionsNumPages = 2;
        controller.transactionsPageNumber = 2;
        System.assertEquals(true, controller.getHasPreviousTransactionsPage());
        controller.transactionsPageNumber = 1;
        System.assertEquals(false, controller.getHasPreviousTransactionsPage());
        Test.stopTest();
    }

    static testMethod void testLoadFirstTransactionsPage()
    {
        EpaBusinessTransactionLogWebService.GetBusinessTransactionIdsResponse getTransactionIdsResponse = new EpaBusinessTransactionLogWebService.GetBusinessTransactionIdsResponse();
        getTransactionIdsResponse.GetBusinessTransactionIdsResult = new List<String>{'ID_1', 'ID_2', 'ID_3', 'ID_4', 'ID_5'};

        EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse getTransactionsByIdsResponse1 = new EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse();
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult = new List<EpaBusinessTransactionLogWebService.BtlTransaction>();
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlTransaction());
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult.get(0).TrnsctId = 'ID_1';
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlTransaction());
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult.get(1).TrnsctId = 'ID_2';

        EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse getTransactionsByIdsResponse2 = new EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse();
        getTransactionsByIdsResponse2.GetBusinessTransactionsByIdsResult = new List<EpaBusinessTransactionLogWebService.BtlTransaction>();
        getTransactionsByIdsResponse2.GetBusinessTransactionsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlTransaction());
        getTransactionsByIdsResponse2.GetBusinessTransactionsByIdsResult.get(0).TrnsctId = 'ID_3';
        getTransactionsByIdsResponse2.GetBusinessTransactionsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlTransaction());
        getTransactionsByIdsResponse2.GetBusinessTransactionsByIdsResult.get(1).TrnsctId = 'ID_4';

        prepareStandardAndAdditionalWebServices(new List<Object>{getTransactionIdsResponse, getTransactionsByIdsResponse1, getTransactionsByIdsResponse2, getTransactionsByIdsResponse1});

        Test.startTest();
        EpaBusinessTransactionLogController controller = new EpaBusinessTransactionLogController();
        controller.transactionsPageSize = 2;
        controller.loadTransactions();
        System.assertEquals(2, controller.transactions.size());
        controller.loadNextTransactionsPage();
        controller.loadFirstTransactionsPage();
        Test.stopTest();

        System.assertEquals(1, controller.transactionsPageNumber);
        System.assertEquals(3, controller.transactionsNumPages);
        System.assertEquals(2, controller.transactionsPageSize);

        System.assertEquals(2, controller.transactions.size());
        System.assertEquals('ID_1', controller.transactions.get(0).TrnsctId);
        System.assertEquals('ID_2', controller.transactions.get(1).TrnsctId);
    }

    static testMethod void testLoadLastTransactionsPage()
    {
        EpaBusinessTransactionLogWebService.GetBusinessTransactionIdsResponse getTransactionIdsResponse = new EpaBusinessTransactionLogWebService.GetBusinessTransactionIdsResponse();
        getTransactionIdsResponse.GetBusinessTransactionIdsResult = new List<String>{'ID_1', 'ID_2', 'ID_3', 'ID_4', 'ID_5'};

        EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse getTransactionsByIdsResponse1 = new EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse();
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult = new List<EpaBusinessTransactionLogWebService.BtlTransaction>();
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlTransaction());
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult.get(0).TrnsctId = 'ID_1';
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlTransaction());
        getTransactionsByIdsResponse1.GetBusinessTransactionsByIdsResult.get(1).TrnsctId = 'ID_2';

        EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse getTransactionsByIdsResponse2 = new EpaBusinessTransactionLogWebService.GetBusinessTransactionsByIdsResponse();
        getTransactionsByIdsResponse2.GetBusinessTransactionsByIdsResult = new List<EpaBusinessTransactionLogWebService.BtlTransaction>();
        getTransactionsByIdsResponse2.GetBusinessTransactionsByIdsResult.add(new EpaBusinessTransactionLogWebService.BtlTransaction());
        getTransactionsByIdsResponse2.GetBusinessTransactionsByIdsResult.get(0).TrnsctId = 'ID_5';

        prepareStandardAndAdditionalWebServices(new List<Object>{getTransactionIdsResponse, getTransactionsByIdsResponse1, getTransactionsByIdsResponse2});

        Test.startTest();
        EpaBusinessTransactionLogController controller = new EpaBusinessTransactionLogController();
        controller.transactionsPageSize = 2;
        controller.loadTransactions();
        System.assertEquals(2, controller.transactions.size());
        controller.loadLastTransactionsPage();
        Test.stopTest();

        System.assertEquals(3, controller.transactionsPageNumber);
        System.assertEquals(3, controller.transactionsNumPages);
        System.assertEquals(2, controller.transactionsPageSize);

        System.assertEquals(1, controller.transactions.size());
        System.assertEquals('ID_5', controller.transactions.get(0).TrnsctId);
    }

    static testMethod void testShowTransaction()
    {
        EpaBusinessTransactionLogWebService.GetStepIdsByTransactionIdResponse getStepIdsByTransactionIdResponse = new EpaBusinessTransactionLogWebService.GetStepIdsByTransactionIdResponse();
        getStepIdsByTransactionIdResponse.GetStepIdsByTransactionIdResult = new List<EpaBusinessTransactionLogWebService.BtlStepReferenceWto>();
        getStepIdsByTransactionIdResponse.GetStepIdsByTransactionIdResult.add(new EpaBusinessTransactionLogWebService.BtlStepReferenceWto());
        getStepIdsByTransactionIdResponse.GetStepIdsByTransactionIdResult.get(0).TrnsctStepId = '1';
        getStepIdsByTransactionIdResponse.GetStepIdsByTransactionIdResult.add(new EpaBusinessTransactionLogWebService.BtlStepReferenceWto());
        getStepIdsByTransactionIdResponse.GetStepIdsByTransactionIdResult.get(1).TrnsctStepId = '2';

        EpaBusinessTransactionLogWebService.GetStepsByIdResponse getStepsByIdResponse = new EpaBusinessTransactionLogWebService.GetStepsByIdResponse();
        getStepsByIdResponse.GetStepsByIdResult = new List<EpaBusinessTransactionLogWebService.BtlStepWto>();
        getStepsByIdResponse.GetStepsByIdResult.add(new EpaBusinessTransactionLogWebService.BtlStepWto());
        getStepsByIdResponse.GetStepsByIdResult.get(0).Id = '1';
        getStepsByIdResponse.GetStepsByIdResult.get(0).StepName = 'NAME_1';
        getStepsByIdResponse.GetStepsByIdResult.add(new EpaBusinessTransactionLogWebService.BtlStepWto());
        getStepsByIdResponse.GetStepsByIdResult.get(1).Id = '2';
        getStepsByIdResponse.GetStepsByIdResult.get(1).StepName = 'NAME_2';

        prepareStandardAndAdditionalWebServices(new List<Object>{getStepIdsByTransactionIdResponse, getStepsByIdResponse});

        Test.startTest();
        EpaBusinessTransactionLogController controller = new EpaBusinessTransactionLogController();
        controller.selectedTransaction = new BtlTransaction();
        controller.selectedTransaction.TrnsctId = '1';
        controller.selectedTransactionId = '1';
        controller.Transactions = new List<BtlTransaction> {controller.selectedTransaction};
        PageReference result = controller.showTransaction();
        Test.stopTest();

        System.assertEquals(new PageReference('/apex/EPA_BTL_Transaction').getUrl(), result.getUrl());

        System.assertEquals(2, controller.stepsOfSelectedTransaction.size());
        System.assertEquals('NAME_1', controller.stepsOfSelectedTransaction.get(0).StepName);
        System.assertEquals('NAME_2', controller.stepsOfSelectedTransaction.get(1).StepName);
    }

    static void prepareStandardAndAdditionalWebServices(List<Object> aAdditionalWebServiceResultList)
    {
    	  List<Object> webServiceResults = new List<Object>();
        webServiceResults.addAll(getStandardWebServiceResults());
        webServiceResults.addAll(aAdditionalWebServiceResultList);
        prepareWebServiceTest(webServiceResults);
    }

    static void prepareStandardWebServices()
    {
        prepareWebServiceTest(getStandardWebServiceResults());
    }

    static List<Object> getStandardWebServiceResults()
    {
        EpaApplicationInfoWebservice.getOrganizationsResponse getOrganizationsResponse = new EpaApplicationInfoWebservice.getOrganizationsResponse();
        getOrganizationsResponse.return_x = new List<String>{'COUNTRY_1', 'COUNTRY_2'};

        EpaApplicationInfoWebservice.getUseCasesResponse getUsecasesResponse = new EpaApplicationInfoWebservice.getUseCasesResponse();
        getUsecasesResponse.return_x = new List<String>{'USECASE_1', 'USECASE_2'};

        EpaApplicationInfoWebservice.getStatusValuesResponse getStatusResponse = new EpaApplicationInfoWebservice.getStatusValuesResponse();
        getStatusResponse.return_x = new List<String>{'STATUS_1', 'STATUS_2'};

        EpaApplicationInfoWebservice.getMessageOriginsResponse getOriginResponse = new EpaApplicationInfoWebservice.getMessageOriginsResponse();
        getOriginResponse.return_x = new List<String>{'ORIGIN_1', 'ORIGIN_2'};

        return new List<Object>{getOrganizationsResponse, getUsecasesResponse, getStatusResponse, getOriginResponse};
    }

    static void prepareWebServiceTest(List<Object> aResponseList)
    {
        Test.setMock(WebServiceMock.class, new MultipleCallWebServiceMock(aResponseList));

        upsert new EPA_Settings__c(Name = 'epa.base.url', Value__c='http://base.url');
        upsert new EPA_Settings__c(Name = 'epa.base.user', Value__c='USER');
        upsert new EPA_Settings__c(Name = 'epa.base.password', Value__c='PASSWORD');
    }

    static SelectOption createSelectOption(String aValue)
    {
        return new SelectOption(aValue, aValue);
    }
}