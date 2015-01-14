@isTest
public class EpaAdminCommandControllerTest
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


    static testmethod void testFromXml()
    {
        String xml =   '<AdminCommandRequests>'
                         + '<AdminCommandRequest>'
                             + '<AdminCommandClassName>COMMAND_1_CLASSNAME</AdminCommandClassName>'
                             + '<AdminCommandName>COMMAND_1_NAME</AdminCommandName>'
                             + '<Description>COMMAND_1_DESCR</Description>'
                             + '<Organization>COMMAND_1_ORG</Organization>'
                             + '<UseCase>COMMAND_1_USECASE</UseCase>'
                             + '<IsClusterable>true</IsClusterable>'
                             + '<Argument>COMMAND_1_ARG_1</Argument>'
                             + '<Argument>COMMAND_1_ARG_2</Argument>'
                         + '</AdminCommandRequest>'
                         + '<AdminCommandRequest>'
                             + '<AdminCommandClassName>COMMAND_2_CLASSNAME</AdminCommandClassName>'
                             + '<AdminCommandName>COMMAND_2_NAME</AdminCommandName>'
                             + '<Description>COMMAND_2_DESCR</Description>'
                             + '<Organization>COMMAND_2_ORG</Organization>'
                             + '<UseCase>COMMAND_2_USECASE</UseCase>'
                         + '</AdminCommandRequest>'
                     + '</AdminCommandRequests>';
        test.startTest();
        List<EpaAdminCommand> result = EpaAdminCommandController.fromXml(xml);
        test.stopTest();

        System.assertEquals(2, result.size());

        System.assertEquals('COMMAND_1_CLASSNAME', result.get(0).adminCommandClassName);
        System.assertEquals('COMMAND_1_NAME', result.get(0).adminCommandName);
        System.assertEquals('COMMAND_1_DESCR', result.get(0).description);
        System.assertEquals('COMMAND_1_ORG', result.get(0).organization);
        System.assertEquals('COMMAND_1_USECASE', result.get(0).useCase);
        System.assertEquals(true, result.get(0).isClusterable);
        System.assertEquals(2, result.get(0).arguments.size());
        System.assertEquals('COMMAND_1_ARG_1', result.get(0).arguments.get(0));
        System.assertEquals('COMMAND_1_ARG_2', result.get(0).arguments.get(1));

        System.assertEquals('COMMAND_2_CLASSNAME', result.get(1).adminCommandClassName);
        System.assertEquals('COMMAND_2_NAME', result.get(1).adminCommandName);
        System.assertEquals('COMMAND_2_DESCR', result.get(1).description);
        System.assertEquals('COMMAND_2_ORG', result.get(1).organization);
        System.assertEquals('COMMAND_2_USECASE', result.get(1).useCase);
    }

    static testmethod void testToXml()
    {
        EpaAdminCommand adminCommand = new EpaAdminCommand();
        adminCommand.adminCommandClassName = 'COMMAND_CLASSNAME';
        adminCommand.adminCommandName = 'COMMAND_NAME';
        adminCommand.description = 'COMMAND_DESCR';
        adminCommand.organization = 'COMMAND_ORG';
        adminCommand.useCase = 'COMMAND_USECASE';
        adminCommand.arguments = new List<String>();
        adminCommand.isClusterable = true;
        adminCommand.arguments.add('ARG_1');
        adminCommand.arguments.add('ARG_2');

        test.startTest();
        String result = EpaAdminCommandController.toXml(adminCommand);
        test.stopTest();

        System.assertEquals('<AdminCommandRequest>'
                            + '<AdminCommandClassName>COMMAND_CLASSNAME</AdminCommandClassName>'
                            + '<AdminCommandName>COMMAND_NAME</AdminCommandName>'
                            + '<Description>COMMAND_DESCR</Description>'
                            + '<Organization>COMMAND_ORG</Organization>'
                            + '<UseCase>COMMAND_USECASE</UseCase>'
                            + '<IsClusterable>true</IsClusterable>'
                            + '<Argument>ARG_1</Argument>'
                            + '<Argument>ARG_2</Argument>'
                            + '</AdminCommandRequest>'
                            , result);
    }

    static testmethod void testEpaAdminCommandController()
    {
        prepareStandardWebServices();

        test.startTest();
        EpaAdminCommandController result = new EpaAdminCommandController();
        test.stopTest();

        System.assertEquals(2, result.getAdminCommands().size());

        System.assertEquals('COMMAND_1_CLASSNAME', result.getAdminCommands().get(0).adminCommandClassName);
        System.assertEquals('COMMAND_1_NAME', result.getAdminCommands().get(0).adminCommandName);
        System.assertEquals('COMMAND_1_DESCR', result.getAdminCommands().get(0).description);
        System.assertEquals('COMMAND_1_ORG', result.getAdminCommands().get(0).organization);
        System.assertEquals('COMMAND_1_USECASE', result.getAdminCommands().get(0).useCase);
        System.assertEquals(true, result.getAdminCommands().get(0).isClusterable);
        System.assertEquals(2, result.getAdminCommands().get(0).arguments.size());
        System.assertEquals('COMMAND_1_ARG_1', result.getAdminCommands().get(0).arguments.get(0));
        System.assertEquals('COMMAND_1_ARG_2', result.getAdminCommands().get(0).arguments.get(1));

        System.assertEquals('COMMAND_2_CLASSNAME', result.getAdminCommands().get(1).adminCommandClassName);
        System.assertEquals('COMMAND_2_NAME', result.getAdminCommands().get(1).adminCommandName);
        System.assertEquals('COMMAND_2_DESCR', result.getAdminCommands().get(1).description);
        System.assertEquals('COMMAND_2_ORG', result.getAdminCommands().get(1).organization);
        System.assertEquals('COMMAND_2_USECASE', result.getAdminCommands().get(1).useCase);
    }

    static testmethod void testExecuteAdminCommand()
    {
        EpaAdminCommandWebService.executeCommandResponse response = new EpaAdminCommandWebService.executeCommandResponse();
        response.return_x = 'RESPONSE';

        prepareStandardAndAdditionalWebServices(new List<Object>{response});

        test.startTest();
        EpaAdminCommandController controller = new EpaAdminCommandController();
        controller.nameOfAdminCommandToExecute = 'COMMAND_2_NAME';
        PageReference result = controller.executeAdminCommand();
        test.stopTest();

        System.assertEquals(new PageReference('/apex/EPA_Admin_Command_Result').getUrl(), result.getUrl());
        System.assertEquals('RESPONSE', controller.adminCommandResult);
    }

    static testmethod void testShowAllAdminCommands()
    {
        prepareStandardWebServices();

        test.startTest();
        EpaAdminCommandController controller = new EpaAdminCommandController();
        PageReference result = controller.showAllAdminCommands();
        test.stopTest();

        System.assertEquals(new PageReference('/apex/EPA_Admin_Commands').getUrl(), result.getUrl());
    }

    static testmethod void testShowServerCommands()
    {
        prepareStandardWebServices();

        test.startTest();
        EpaAdminCommandController controller = new EpaAdminCommandController();
        PageReference result = controller.showServerCommands();
        test.stopTest();

        System.assertEquals(new PageReference('/apex/EPA_Server_Commands').getUrl(), result.getUrl());
    }

    static testmethod void testShowClusterCommands()
    {
        prepareStandardWebServices();

        test.startTest();
        EpaAdminCommandController controller = new EpaAdminCommandController();
        PageReference result = controller.showClusterCommands();
        test.stopTest();

        System.assertEquals(new PageReference('/apex/EPA_Cluster_Commands').getUrl(), result.getUrl());
    }

    static testmethod void testShowScheduledCommands()
    {
        prepareStandardWebServices();

        test.startTest();
        EpaAdminCommandController controller = new EpaAdminCommandController();
        PageReference result = controller.showScheduledCommands();
        test.stopTest();

        System.assertEquals(new PageReference('/apex/EPA_Scheduled_Commands').getUrl(), result.getUrl());
    }

    static testmethod void testGetServerCommands()
    {
        prepareStandardWebServices();

        test.startTest();
        EpaAdminCommandController controller = new EpaAdminCommandController();
        List<EpaAdminCommand> result = controller.getServerCommands();
        test.stopTest();

        System.assertEquals(1, result.size());
        System.assertEquals('COMMAND_2_NAME', result.get(0).adminCommandName);
    }

    static testmethod void testGetClusterCommands()
    {
        prepareStandardWebServices();

        test.startTest();
        EpaAdminCommandController controller = new EpaAdminCommandController();
        List<EpaAdminCommand> result = controller.getClusterCommands();
        test.stopTest();

        System.assertEquals(1, result.size());
        System.assertEquals('COMMAND_1_NAME', result.get(0).adminCommandName);
    }

    static testmethod void testGetScheduledCommands()
    {
        prepareStandardWebServices();

        test.startTest();
        EpaAdminCommandController controller = new EpaAdminCommandController();
        List<EpaAdminCommand> result = controller.getScheduledCommands();
        test.stopTest();

        System.assertEquals(0, result.size());
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
        EpaAdminCommandWebService.getAvailableCommandsResponse response = new EpaAdminCommandWebService.getAvailableCommandsResponse();
        response.return_x =
                       '<AdminCommandRequests>'
                         + '<AdminCommandRequest>'
                             + '<AdminCommandClassName>COMMAND_1_CLASSNAME</AdminCommandClassName>'
                             + '<AdminCommandName>COMMAND_1_NAME</AdminCommandName>'
                             + '<Description>COMMAND_1_DESCR</Description>'
                             + '<Organization>COMMAND_1_ORG</Organization>'
                             + '<UseCase>COMMAND_1_USECASE</UseCase>'
                             + '<IsClusterable>true</IsClusterable>'
                             + '<Argument>COMMAND_1_ARG_1</Argument>'
                             + '<Argument>COMMAND_1_ARG_2</Argument>'
                         + '</AdminCommandRequest>'
                         + '<AdminCommandRequest>'
                             + '<AdminCommandClassName>COMMAND_2_CLASSNAME</AdminCommandClassName>'
                             + '<AdminCommandName>COMMAND_2_NAME</AdminCommandName>'
                             + '<Description>COMMAND_2_DESCR</Description>'
                             + '<Organization>COMMAND_2_ORG</Organization>'
                             + '<UseCase>COMMAND_2_USECASE</UseCase>'
                         + '</AdminCommandRequest>'
                     + '</AdminCommandRequests>';

        return new List<Object>{response};
    }

    static void prepareWebServiceTest(List<Object> aResponseList)
    {
        Test.setMock(WebServiceMock.class, new MultipleCallWebServiceMock(aResponseList));

        upsert new EPA_Settings__c(Name = 'epa.base.url', Value__c='http://base.url');
        upsert new EPA_Settings__c(Name = 'epa.base.user', Value__c='USER');
        upsert new EPA_Settings__c(Name = 'epa.base.password', Value__c='PASSWORD');
    }
}