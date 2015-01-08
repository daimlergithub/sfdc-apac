/*
    Type:       Flow Apex Plugin 
    Purpose:    Limit the Count of Multi-Select Answers.
    User Story: All Campaign surveys
    Used By:    Flow
    ---------------------------------------------------------------
    History:
    
    1. Chris Created on 2013-05-29

*/
global class SurveyPlugIn_LimitSelections implements Process.Plugin {

    

    global Process.PluginResult invoke(Process.PluginRequest request)    {
        
        List<String> allOptions = new List<String>();
        
        Long limitCount = long.valueOf(String.valueOf(request.inputParameters.get('LimitCount')));
        
        String selectedAnswers = (String)request.inputParameters.get('SelectedAnswers');

        Boolean overflow = selectedAnswers.split(';').size()>limitCount;
                                        
        Map<String, Object> result = new Map<String, Object>();

        result.put('IsOverflow', overflow);
		
        return new Process.PluginResult(result);

    }

 

    global Process.PluginDescribeResult describe()    {

        Process.PluginDescribeResult result = new Process.PluginDescribeResult();

        result.description='This plug-in is used to limit the count of multi-select answers.';

        result.tag='Survey Options Select Limit.';

        result.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
            new Process.PluginDescribeResult.InputParameter('LimitCount',
                Process.PluginDescribeResult.ParameterType.Long, true),
            
            new Process.PluginDescribeResult.InputParameter('SelectedAnswers',
                Process.PluginDescribeResult.ParameterType.String, true)
        };
        
        result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter> {
            new Process.PluginDescribeResult.OutputParameter('IsOverflow',
                Process.PluginDescribeResult.ParameterType.Boolean)
        };

        
      return result;

    }

    public static testmethod void testAll() {
    	
        SurveyPlugIn_LimitSelections plugin = new SurveyPlugIn_LimitSelections();
        Map<String,Object> inputParams = new Map<String,Object>();
        inputParams.put('LimitCount', '3');
        inputParams.put('SelectedAnswers', 'A;B;C;D');
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult aresult = Plugin.invoke(request);
        Boolean IsOverflow = (Boolean) aresult.outputParameters.get('IsOverflow');
        System.assertEquals(IsOverflow,true);
        
		plugin = new SurveyPlugIn_LimitSelections();
        inputParams = new Map<String,Object>();
        inputParams.put('LimitCount', '4');
        inputParams.put('SelectedAnswers', 'A;B;C;D');
        request = new Process.PluginRequest(inputParams);
        aresult = Plugin.invoke(request);
        IsOverflow = (Boolean) aresult.outputParameters.get('IsOverflow');
        System.assertEquals(IsOverflow,false);
        
        Process.PluginDescribeResult describe = plugin.describe();
        System.assertEquals(describe.InputParameters.size(), 2);
        System.assertEquals(describe.InputParameters[0].name, 'LimitCount');
        System.assertEquals(describe.InputParameters[1].name, 'SelectedAnswers');
        System.assertEquals(describe.OutputParameters.size(), 1);
        System.assertEquals(describe.OutputParameters[0].name, 'IsOverflow');
    }

}