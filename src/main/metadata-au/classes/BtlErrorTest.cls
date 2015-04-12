@isTest
public class BtlErrorTest {
    static testMethod void testBtlError()
    {
    
    BtlError be=new BtlError();
    be.Message='error message';
            System.assertEquals('error message', be.getShortMessage());
    
    }

}