public class EpaResourceConsumptionController
{
    public String getReportId()
    {
        Dashboard epaDashboard = [select Id from Dashboard where DeveloperName = 'EPA_Resource_Consumption'];
        return epaDashboard.Id;
    }
}