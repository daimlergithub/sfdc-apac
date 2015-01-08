@isTest
private class BtlTransactionTest
{
    static testMethod void testShortSrcObjectInt()
    {
    	  BtlTransaction trnsct = new BtlTransaction();
        trnsct.SrcObjectInt = 'short';
        System.assertEquals('short', trnsct.getShortSrcObjectInt());
        trnsct.SrcObjectInt = 'long567890123456789012345678901234567890';
        System.assertEquals('long5678901234567890123456 ...', trnsct.getShortSrcObjectInt());
    }

    static testMethod void testShortSrcObjectExt()
    {
        BtlTransaction trnsct = new BtlTransaction();
        trnsct.SrcObjectExt = 'short';
        System.assertEquals('short', trnsct.getShortSrcObjectExt());
        trnsct.SrcObjectExt = 'long567890123456789012345678901234567890';
        System.assertEquals('long5678901234567890123456 ...', trnsct.getShortSrcObjectExt());
    }

    static testMethod void testShortResponse()
    {
        BtlTransaction trnsct = new BtlTransaction();
        trnsct.Response = 'short';
        System.assertEquals('short', trnsct.getShortResponse());
        trnsct.Response = 'long567890123456789012345678901234567890';
        System.assertEquals('long5678901234567890123456 ...', trnsct.getShortResponse());
    }
}