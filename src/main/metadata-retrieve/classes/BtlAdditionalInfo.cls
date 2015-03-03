public class BtlAdditionalInfo
{
    public String Id  {get;set;}
    public String Type_x  {get;set;}
    public String AdditionalInformation  {get;set;}
    public Integer Count  {get;set;}

    public String getShortAdditionalInformation()
    {
        String shortAdditionalInfo =
        AdditionalInformation != null && AdditionalInformation.length() > 100 ? AdditionalInformation.substring(0, 96) + ' ...'
                                              : AdditionalInformation;

        if (Count > 1) {
        shortAdditionalInfo = shortAdditionalInfo + ' (' + Count + ' times)';
        }

        return shortAdditionalInfo;
    }
}