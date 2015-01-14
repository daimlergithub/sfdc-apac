public class EpaAdminCommandWebService {
    public class getAvailableCommands {
        private String[] apex_schema_type_info = new String[]{'http://ep.crm.nttdata.com/AdminCommand_1.0','false','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class executeCommandResponse {
        public String return_x;
        private String[] return_x_type_info = new String[]{'return','http://ep.crm.nttdata.com/AdminCommand_1.0',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ep.crm.nttdata.com/AdminCommand_1.0','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    public class getAvailableCommandsResponse {
        public String return_x;
        private String[] return_x_type_info = new String[]{'return','http://ep.crm.nttdata.com/AdminCommand_1.0',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ep.crm.nttdata.com/AdminCommand_1.0','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    public class executeCommand {
        public String arg0;
        private String[] arg0_type_info = new String[]{'arg0','http://ep.crm.nttdata.com/AdminCommand_1.0',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ep.crm.nttdata.com/AdminCommand_1.0','false','false'};
        private String[] field_order_type_info = new String[]{'arg0'};
    }
    public class AdminCommandPort {
        public String endpoint_x = EPA_Settings__c.getInstance('epa.base.url').Value__c + '/AdminCommand';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://ep.crm.nttdata.com/AdminCommand_1.0', 'EpaAdminCommandWebService'};
        public String getAvailableCommands() {
            EpaAdminCommandWebService.getAvailableCommands request_x = new EpaAdminCommandWebService.getAvailableCommands();
            EpaAdminCommandWebService.getAvailableCommandsResponse response_x;
            Map<String, EpaAdminCommandWebService.getAvailableCommandsResponse> response_map_x = new Map<String, EpaAdminCommandWebService.getAvailableCommandsResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://ep.crm.nttdata.com/AdminCommand_1.0',
              'getAvailableCommands',
              'http://ep.crm.nttdata.com/AdminCommand_1.0',
              'getAvailableCommandsResponse',
              'EpaAdminCommandWebService.getAvailableCommandsResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
        public String executeCommand(String arg0) {
            EpaAdminCommandWebService.executeCommand request_x = new EpaAdminCommandWebService.executeCommand();
            request_x.arg0 = arg0;
            EpaAdminCommandWebService.executeCommandResponse response_x;
            Map<String, EpaAdminCommandWebService.executeCommandResponse> response_map_x = new Map<String, EpaAdminCommandWebService.executeCommandResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://ep.crm.nttdata.com/AdminCommand_1.0',
              'executeCommand',
              'http://ep.crm.nttdata.com/AdminCommand_1.0',
              'executeCommandResponse',
              'EpaAdminCommandWebService.executeCommandResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
    }
}