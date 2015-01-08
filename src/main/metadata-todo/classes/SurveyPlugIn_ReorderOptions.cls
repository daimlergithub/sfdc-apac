/*
    Type:       Flow Apex Plugin 
    Purpose:    Reorder the input options.
    User Story: All Campaign surveys
    Used By:    Flow
    ---------------------------------------------------------------
    History:
    
    1. Chris Created on 2013-05-28

*/
global class SurveyPlugIn_ReorderOptions implements Process.Plugin {


    global Process.PluginResult invoke(Process.PluginRequest request)    {
        
        List<String> allOptions = new List<String>();
        List<String> allValues = new List<String>();
        
        for(Integer i=1; i<=50; i++){
        	String index = '' + (i<10?'0':'') + i;
            allOptions.add((String)request.inputParameters.get('Option_' + index));
            allValues.add((String)request.inputParameters.get('Value_' + index));
        }

        List<String> options = new List<String>();
		List<String> values = new List<String>();
		
        for(Integer i=0; i<50; i++){
        	String s =  allOptions[i];
            if(s!=null && s.length()>0){
                options.add(s);
                values.add(allValues[i]);
            }
        }  
                                           
        Map<String, Object> result = new Map<String, Object>();

        Integer i=1;    
        while(options.size()>0){
            Integer index = (Integer)(Math.random()*options.size());
            if(options.size()>index){
                result.put('Option_'+(i<10?'0':'') + i, options.get(index));
                result.put('Value_'+(i<10?'0':'') + i, values.get(index));
                options.remove(index);
                values.remove(index);
                i++;
            }           
        }

        return new Process.PluginResult(result);

    }

 

    global Process.PluginDescribeResult describe()    {

        Process.PluginDescribeResult result = new Process.PluginDescribeResult();

        result.description='This plug-in is used to reorder the input options.';

        result.tag='Survey Options Random Reorder.';

        result.inputParameters = new List<Process.PluginDescribeResult.InputParameter>();
        
        result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter>();
        
        for(Integer i=1; i<=50; i++){
        	String index = '' + (i<10?'0':'') + i;
        	
            result.inputParameters.add(new Process.PluginDescribeResult.InputParameter('Option_' + index,
            Process.PluginDescribeResult.ParameterType.String, false));
            result.inputParameters.add(new Process.PluginDescribeResult.InputParameter('Value_' + index,
            Process.PluginDescribeResult.ParameterType.String, false));
            
            result.outputParameters.add(new Process.PluginDescribeResult.OutputParameter('Option_' + index,
            Process.PluginDescribeResult.ParameterType.String));
            result.outputParameters.add(new Process.PluginDescribeResult.OutputParameter('Value_' + index,
            Process.PluginDescribeResult.ParameterType.String));
        }
               
      return result;

    }
    
    public static testmethod void testAll() {
        
        SurveyPlugIn_ReorderOptions plugin = new SurveyPlugIn_ReorderOptions();
        Map<String,Object> inputParams = new Map<String,Object>();
        for(Integer i=1; i<=50; i++){
        	String index = '' + (i<10?'0':'') + i;
            inputParams.put('Option_' + index,'Test-'+i);
            inputParams.put('Value_' + index,'Value-'+i);
        }
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult aresult = Plugin.invoke(request);
        for(Integer i=1; i<=50; i++){
        	String index = '' + (i<10?'0':'') + i;
            aresult.outputParameters.get('Option_' + index);
            aresult.outputParameters.get('Value_' + index);
        }
        
        Process.PluginDescribeResult describe = plugin.describe();
        System.assertEquals(describe.InputParameters.size(), 100);
        System.assertEquals(describe.OutputParameters.size(), 100);
    }

}