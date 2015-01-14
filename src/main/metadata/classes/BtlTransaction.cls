public class BtlTransaction
{
    public Boolean Selected  {get;set;}
    public String TrnsctId  {get;set;}
    public String ParentTrnsctId  {get;set;}
    public String RequestId  {get;set;}
    public String Organization  {get;set;}
    public String UseCase  {get;set;}
    public String InterfaceName  {get;set;}
    public String Status  {get;set;}
    public String UniqueExternalId  {get;set;}
    public String Origin  {get;set;}
    public String OriginDetails  {get;set;}
    public String InputChannel  {get;set;}
    public DateTime StartDt  {get;set;}
    public DateTime ProcessingStartDt  {get;set;}
    public DateTime EndDt  {get;set;}
    public Long Duration  {get;set;}
    public Long UsedCpuTime  {get;set;}
    public Long UsedUserTime  {get;set;}
    public Long UsedSystemTime  {get;set;}
    public Boolean Reloadable  {get;set;}
    public String SrcObjectInt  {get;set;}
    public String SrcObjectExt  {get;set;}
    public String Response  {get;set;}
    public String Server  {get;set;}
    public String EpaVersion  {get;set;}
    public String EpaRevision  {get;set;}
    public String EpaBuild  {get;set;}
    public String Environment  {get;set;}

    public String getShortSrcObjectInt()
    {
        return SrcObjectInt != null && SrcObjectInt.length() > 30 ? SrcObjectInt.substring(0, 26) + ' ...'
                                                                  : SrcObjectInt;
    }

    public String getShortSrcObjectExt()
    {
        return SrcObjectExt != null && SrcObjectExt.length() > 30 ? SrcObjectExt.substring(0, 26) + ' ...'
                                                                  : SrcObjectExt;
    }

    public String getShortResponse()
    {
        return Response != null && Response.length() > 30 ? Response.substring(0, 26) + ' ...'
                                                          : Response;
    }
}