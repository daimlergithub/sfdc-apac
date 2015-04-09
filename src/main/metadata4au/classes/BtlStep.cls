public class BtlStep
{
    public String Id  {get;set;}
    public String ParentStepId  {get;set;}
    public String StepName  {get;set;}
    public DateTime StartDt  {get;set;}
    public DateTime EndDt  {get;set;}
    public Long Duration  {get;set;}
    public Long UsedCpuTime  {get;set;}
    public Long UsedUserTime  {get;set;}
    public Long UsedSystemTime  {get;set;}
    public String StepAdditionalInfo  {get;set;}
    public Integer Depth  {get;set;}
    public String Server  {get;set;}
    public String Indent  {get;set;}
    public List<BtlAdditionalInfo> AdditionalInformation  {get;set;}
    public List<BtlError> Errors  {get;set;}
}