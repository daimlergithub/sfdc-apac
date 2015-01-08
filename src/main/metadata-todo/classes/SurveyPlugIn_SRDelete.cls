/*
    Type:       Flow Apex Plugin 
    Purpose:    Delete Survey Result by Administrator.
    User Story: All SSI surveys
    Used By:    Flow
    ---------------------------------------------------------------
    History:
    
    1. Chris Created on 2013-06-18

*/
global class SurveyPlugIn_SRDelete implements Process.Plugin {

    global Process.PluginResult invoke(Process.PluginRequest request)    {

        String taskId = (String)request.inputParameters.get('TaskId');

        if(taskId != null && taskId.indexOf('00T') == 0){       
            List<sObject> dels = new List<sObject>(); 	
        	List<Survey_Result__c> srList = [Select Id, TaskId__c From Survey_Result__c Where TaskId__c = :taskId];
        	if(srList != null && srList.size() > 0){
        		for (Survey_Result__c sr : srList) {
                    // System.debug('Debug Output ===taskId===> {' + taskId + '}');
                    // System.debug('Debug Output ===sr.TaskId__c===> {' + sr.TaskId__c + '}');
                    if (taskId.compareTo(sr.TaskId__c) == 0) {
                        dels.add(sr);
                    }
                }
        	}else{
        		List<Campaign_Survey_Result__c> csrList = [Select Id, TaskId__c From Campaign_Survey_Result__c Where TaskId__c = :taskId];
                for (Campaign_Survey_Result__c csr : csrList) {
                    if (taskId.compareTo(csr.TaskId__c) == 0) {
                        dels.add(csr);
                    }
                }
        	}

            if (dels.size() > 0) {
                delete dels;
            }
        }
                                        
        Map<String, Object> result = new Map<String, Object>();

        return new Process.PluginResult(result);

    }

 

    global Process.PluginDescribeResult describe()    {

        Process.PluginDescribeResult result = new Process.PluginDescribeResult();

        result.description='This plug-in is used to delete specify Survey Result record.';

        result.tag='Delete Survey Result Record';

        result.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
            new Process.PluginDescribeResult.InputParameter('TaskId',
                Process.PluginDescribeResult.ParameterType.String, true)
        };

      return result;

    }

    public static testmethod void testAll() {
    	
        User user1 = UtilTestData.createUser('OB CSR','CAC OB CSR');

        System.runAs ( user1 ) { 
    		
    		Task tk = new Task();
    		insert tk;
    		
	    	Survey_Result__c sr = new Survey_Result__c(TaskId__c = tk.Id);
	    	insert sr;	    	
	        SurveyPlugIn_SRDelete plugin = new SurveyPlugIn_SRDelete();
	        Map<String,Object> inputParams = new Map<String,Object>();
	        inputParams.put('TaskId', tk.Id);	
	        Process.PluginRequest request = new Process.PluginRequest(inputParams);
	        Process.PluginResult aresult = Plugin.invoke(request);
	        Integer srCount = [Select count() From Survey_Result__c Where TaskId__c = :tk.Id];
	        System.assertEquals(srCount, 0);
	        
	        Campaign_Survey_Result__c csr = new Campaign_Survey_Result__c(TaskId__c = tk.Id);
	    	insert csr;
	        plugin = new SurveyPlugIn_SRDelete();
	        inputParams = new Map<String,Object>();
	        inputParams.put('TaskId', tk.Id);	
	        request = new Process.PluginRequest(inputParams);
	        aresult = Plugin.invoke(request);	        
	     	Integer csrCount = [Select count() From Campaign_Survey_Result__c Where TaskId__c = :tk.Id];
	        System.assertEquals(csrCount, 0);
	        
	   		Process.PluginDescribeResult describe = plugin.describe();
	        System.assertEquals(describe.InputParameters.size(), 1);	        
	        System.assertEquals(describe.InputParameters[0].name, 'TaskId');
        }        
    }

}