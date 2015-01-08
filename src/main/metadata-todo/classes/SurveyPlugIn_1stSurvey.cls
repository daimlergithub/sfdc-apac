/*
    "S4 '用户提车时间不在合格访问期之内' 
    
    1. 结束时间为当天日期– 14
    
    2. 开始时间为：
    a) 如结束时间的月份大于档案月，则开始时间为当月1日
    b) 如结束时间的月份等于档案月，则开始时间为上月1日
    
    举例：
    
    购车月为2012年12月，今天是2013年1月16日
    则：开始时间为2013年1月1日，结束时间为2013年1月2日
    
    购车月为2012年12月，今天是2013年1月3日
    则：开始时间为2012年12月1日，结束时间为2012年12月20日（1月3日-14）
    
    购车月为2012年12月，今天是2012年12月28日
    则：开始时间为2012年11月1日，结束时间为2012年12月14日"
*/
global class SurveyPlugIn_1stSurvey implements Process.Plugin {

 
    global Process.PluginResult invoke(Process.PluginRequest request)    {
        
        Long s4_year = (Long)request.inputParameters.get('S4_Year');
        
        Long s4_month = (Long)request.inputParameters.get('S4_Month');
        
        DateTime s4_invoiceDate = (DateTime)request.inputParameters.get('SSI_InvoiceDate');

        Date endDate = Date.today().addDays(-14);
        
        // Date startDate = Date.newinstance((Integer)s4_year, 
        //     endDate.month()>s4_invoiceDate.month()?
        //         Date.today().month():
        //         Date.today().addMonths(-1).month(), 1);
        Date startDate = s4_invoiceDate.Date().toStartOfMonth();
        
        Boolean isInTS = (s4_month >= startDate.month() && s4_month <= endDate.month())?true:false;
        
        Map<String, Object> result = new Map<String, Object>();

        result.put('S4_IsInSurveyTimespan', isInTS);

        return new Process.PluginResult(result);

    }

 

    global Process.PluginDescribeResult describe()    {

        Process.PluginDescribeResult result = new Process.PluginDescribeResult();

        result.description='This plug-in is used to calculate customer booking date in survey time-span or not.';

        result.tag='Survey Timespan Calculate.';

        result.inputParameters = new List<Process.PluginDescribeResult.InputParameter> {

            new Process.PluginDescribeResult.InputParameter('S4_Year',

            Process.PluginDescribeResult.ParameterType.Long, true),
            
            new Process.PluginDescribeResult.InputParameter('S4_Month',

            Process.PluginDescribeResult.ParameterType.Long, true),
            
            new Process.PluginDescribeResult.InputParameter('SSI_InvoiceDate',

            Process.PluginDescribeResult.ParameterType.Date, true)

        };

        result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter> {

            new Process.PluginDescribeResult.OutputParameter('S4_IsInSurveyTimespan',

            Process.PluginDescribeResult.ParameterType.Boolean)

        };

        return result;

    }
    
    public static testmethod void testAll() {
    	
        SurveyPlugIn_1stSurvey plugin = new SurveyPlugIn_1stSurvey();
        Map<String,Object> inputParams = new Map<String,Object>();
        Date id = Date.today().addDays(-14);
        inputParams.put('S4_Year', id.year());
        inputParams.put('S4_Month', id.month());
        inputParams.put('SSI_InvoiceDate', id);
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult aresult = Plugin.invoke(request);
        Boolean IsInSurveyTimespan = (Boolean) aresult.outputParameters.get('S4_IsInSurveyTimespan');
        System.assertEquals(IsInSurveyTimespan,true);
        
        plugin = new SurveyPlugIn_1stSurvey();
        inputParams = new Map<String,Object>();
        inputParams.put('S4_Year', 2013);
        inputParams.put('S4_Month', 2);
        inputParams.put('SSI_InvoiceDate', Date.newInstance(2013, 4, 1));
        request = new Process.PluginRequest(inputParams);
        aresult = Plugin.invoke(request);
        IsInSurveyTimespan = (Boolean) aresult.outputParameters.get('S4_IsInSurveyTimespan');
        System.assertEquals(IsInSurveyTimespan,false);
        
        Process.PluginDescribeResult describe = plugin.describe();
        System.assertEquals(describe.InputParameters.size(), 3);
        System.assertEquals(describe.InputParameters[0].name, 'S4_Year');
        System.assertEquals(describe.InputParameters[1].name, 'S4_Month');
        System.assertEquals(describe.InputParameters[2].name, 'SSI_InvoiceDate');
        System.assertEquals(describe.OutputParameters.size(), 1);
        System.assertEquals(describe.OutputParameters[0].name, 'S4_IsInSurveyTimespan');
    }
    

}