public with sharing class ReportFinderUtil {

  public ReportFinderUtil(){}
  
  public String findReportId(String reportName){
    //modified by vincent.zhang

    Sobject myReport = [select Id,Name From Report Where Name=:reportName];
    return myReport.Id;
    
  }
  
  
}