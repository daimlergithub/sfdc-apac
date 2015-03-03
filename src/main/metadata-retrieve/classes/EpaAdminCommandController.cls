public class EpaAdminCommandController
    extends BaseEpaController
{
    public String nameOfAdminCommandToExecute {get; set;}
    public String adminCommandResult {get; set;}
    private List<EpaAdminCommand> allAdminCommands = null;
    private static Pattern scheduledCommandPattern = Pattern.compile('.*\\.integration\\..*\\.inadapter\\..*');
    private String organizationFilter = null;
    private String useCaseFilter = null;

    public EpaAdminCommandController()
    {
        System.debug('EpaAdminCommandController.EpaAdminCommandController: load commands');
        allAdminCommands = fromXml(getAdminCommandWebservice().getAvailableCommands());
    }

    public PageReference executeAdminCommand()
    {
        System.debug('EpaAdminCommandController.executeAdminCommand: execute commands ' + nameOfAdminCommandToExecute);
        EpaAdminCommand adminCommandToExecute = getAdminCommand(nameOfAdminCommandToExecute);
        adminCommandResult = getAdminCommandWebservice().executeCommand(toXml(adminCommandToExecute));
        return new PageReference('/apex/EPA_Admin_Command_Result');
    }

    public PageReference showAllAdminCommands()
    {
        return new PageReference('/apex/EPA_Admin_Commands');
    }

    public PageReference showServerCommands()
    {
        return new PageReference('/apex/EPA_Server_Commands');
    }

    public PageReference showClusterCommands()
    {
        return new PageReference('/apex/EPA_Cluster_Commands');
    }

    public PageReference showScheduledCommands()
    {
        return new PageReference('/apex/EPA_Scheduled_Commands');
    }

    public List<EpaAdminCommand> getAdminCommands()
    {
        return allAdminCommands;
    }

    public List<EpaAdminCommand> getServerCommands()
    {
        List<EpaAdminCommand> serverCommands = new List<EpaAdminCommand>();

        if (allAdminCommands != null) {
            for (EpaAdminCommand command : allAdminCommands) {
                if ((command.isScheduled == null || !command.isScheduled) && (command.isClusterable == null || !command.isClusterable)) {
                    serverCommands.add(command);
                }
            }
        }
        return serverCommands;
    }

    public List<EpaAdminCommand> getClusterCommands()
    {
        List<EpaAdminCommand> clusterCommands = new List<EpaAdminCommand>();

        for (EpaAdminCommand command : allAdminCommands) {
          if ((command.isScheduled == null || !command.isScheduled) && command.isClusterable != null && command.isClusterable) {
            clusterCommands.add(command);
          }
        }
        return clusterCommands;
    }

    public List<EpaAdminCommand> getScheduledCommands()
    {
        List<EpaAdminCommand> scheduledCommands = new List<EpaAdminCommand>();

        for (EpaAdminCommand command : allAdminCommands) {
          if (command.isScheduled != null && command.isScheduled
              && (organizationFilter == null || organizationFilter == '' || organizationFilter == command.organization)
              && (useCaseFilter == null || useCaseFilter == '' || useCaseFilter == command.useCase)) {
            scheduledCommands.add(command);
          }
        }
        return scheduledCommands;
    }

    public PageReference filterCommands()
    {
        organizationFilter = Apexpages.currentPage().getParameters().get('organization');
        useCaseFilter = Apexpages.currentPage().getParameters().get('useCase');
        return null;
    }

    public Set<String> getUseCases()
    {
        Set<String> result = new Set<String>();
        for (EpaAdminCommand command : allAdminCommands) {
            if (command.useCase != null) {
                result.add(command.useCase);
            }
        }
        return result;
    }

    public Set<String> getOrganizations()
    {
        Set<String> result = new Set<String>();
        for (EpaAdminCommand command : allAdminCommands) {
            if (command.organization != null) {
                result.add(command.organization);
            }
        }
        return result;
    }

    public static List<EpaAdminCommand> fromXml(String aAdminCommandListAsXml)
    {
      XmlStreamReader reader = new XmlStreamReader(aAdminCommandListAsXml);
      return parseEpaAdminCommands(reader);
    }


    private static List<EpaAdminCommand> parseEpaAdminCommands(XmlStreamReader aReader)
    {
        while (true) {
            if (aReader.getEventType() == XmlTag.START_ELEMENT) {
                if ('AdminCommandRequests' == aReader.getLocalName()) {
                    return parseAdminCommandRequests(aReader);
                 }
            }

            if (aReader.hasNext()) {
                aReader.next();
            }
            else {
                break;
            }
        }

        return new List<EpaAdminCommand>();
    }

    private static List<EpaAdminCommand> parseAdminCommandRequests(XmlStreamReader aReader)
    {
        List<EpaAdminCommand> result = new List<EpaAdminCommand>();

        while (true) {
            if (aReader.getEventType() == XmlTag.START_ELEMENT && 'AdminCommandRequest' == aReader.getLocalName()) {
                result.add(parseAdminCommandRequest(aReader));
            }
            else if (aReader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            }

            if (aReader.hasNext()) {
                aReader.next();
            }
            else {
                break;
            }
        }

        return result;
    }

    private static EpaAdminCommand parseAdminCommandRequest(XmlStreamReader aReader)
    {
        EpaAdminCommand result = new EpaAdminCommand();

        while (true) {
            if (aReader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            }
            else if (aReader.getEventType() == XmlTag.START_ELEMENT && 'AdminCommandClassName' == aReader.getLocalName()) {
                result.adminCommandClassName = parseStringElement(aReader);
            }
            else if (aReader.getEventType() == XmlTag.START_ELEMENT && 'AdminCommandName' == aReader.getLocalName()) {
                result.adminCommandName = parseStringElement(aReader);
            }
            else if (aReader.getEventType() == XmlTag.START_ELEMENT && 'Description' == aReader.getLocalName()) {
                result.description = parseStringElement(aReader);
            }
            else if (aReader.getEventType() == XmlTag.START_ELEMENT && 'Organization' == aReader.getLocalName()) {
                result.organization = parseStringElement(aReader);
            }
            else if (aReader.getEventType() == XmlTag.START_ELEMENT && 'UseCase' == aReader.getLocalName()) {
                result.useCase = parseStringElement(aReader);
            }
            else if (aReader.getEventType() == XmlTag.START_ELEMENT && 'IsClusterable' == aReader.getLocalName()) {
                result.isClusterable = parseBooleanElement(aReader);
            }
            else if (aReader.getEventType() == XmlTag.START_ELEMENT && 'Argument' == aReader.getLocalName()) {
                if (result.arguments == null) {
                    result.arguments = new List<String>();
                }
                result.arguments.add(parseStringElement(aReader));
            }

            if (aReader.hasNext()) {
                aReader.next();
            }
            else {
                break;
            }
        }

        result.isScheduled = scheduledCommandPattern.matcher(result.adminCommandClassName).matches();

        return result;
    }

    private static String parseStringElement(XmlStreamReader aReader)
    {
        String result = '';
        while (true) {
            if (aReader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            }
            else if (aReader.getEventType() == XmlTag.CHARACTERS) {
                result += aReader.getText();
            }

            if (aReader.hasNext()) {
                aReader.next();
            }
            else {
                break;
            }
        }

        return result;
    }

    private static Boolean parseBooleanElement(XmlStreamReader aReader)
    {
        Boolean result = null;
        while (true) {
            if (aReader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            }
            else if (aReader.getEventType() == XmlTag.CHARACTERS) {
                result = Boolean.valueOf(aReader.getText());
            }

            if (aReader.hasNext()) {
                aReader.next();
            }
            else {
                break;
            }
        }

        return result;
    }

    private EpaAdminCommand getAdminCommand(String aAdminCommandName)
    {
        for (EpaAdminCommand adminCommand : allAdminCommands) {
            if (aAdminCommandName == adminCommand.adminCommandName) {
                return adminCommand;
            }
        }

        return null;
    }

    public static String toXml(EpaAdminCommand aAdminCommand)
    {
        String result = '<AdminCommandRequest>';
        result += '<AdminCommandClassName>' + aAdminCommand.adminCommandClassName + '</AdminCommandClassName>';
        result += '<AdminCommandName>' + aAdminCommand.adminCommandName + '</AdminCommandName>';
        result += '<Description>' + aAdminCommand.description + '</Description>';
        result += '<Organization>' + aAdminCommand.organization + '</Organization>';
        result += '<UseCase>' + aAdminCommand.useCase + '</UseCase>';
        result += '<IsClusterable>' + aAdminCommand.isClusterable + '</IsClusterable>';
        if (aAdminCommand.arguments != null) {
            for (String argument : aAdminCommand.arguments) {
                result += '<Argument>' + argument + '</Argument>';
            }
        }
        result += '</AdminCommandRequest>';
        return result;
    }

    public EpaAdminCommandWebService.AdminCommandPort getAdminCommandWebservice()
    {
        EpaAdminCommandWebService.AdminCommandPort service = new EpaAdminCommandWebService.AdminCommandPort();
        service.endpoint_x = getAbsoluteEndpoint('/AdminCommand');
        service.inputHttpHeaders_x = getAuthorizationHeaders();
        return service;
    }
}