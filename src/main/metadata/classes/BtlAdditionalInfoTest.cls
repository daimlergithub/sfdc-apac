@isTest
public class BtlAdditionalInfoTest {
static testMethod void testBtlAdditionalInfo()
    {
        BtlAdditionalInfo btl=new BtlAdditionalInfo();
        btl.AdditionalInformation='more additional information';
                    System.assertEquals('more additional information', btl.getShortAdditionalInformation());
        
        
    }
}