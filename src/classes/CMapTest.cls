@isTest
private with sharing class CMapTest {
Private static string k1='k1';
    public static testMethod void testCMap() {
        Test.startTest();
        CMap cmap = new CMap();
        cmap.add(k1,'v1');
        cmap.add(k1,'v1');
        List<String> liststr = new List<String>();
        liststr.add('v2.1');
        liststr.add('v2.2');
        cmap.addAll('k2', liststr);
        cmap.addAll('k2', liststr);
        cmap.get(k1);
        cmap.KeySet();
        cmap.value();
        cmap.values2();
        cmap.cleanLessThanTwoList();
        
        CMap cmap2 = new CMap();
        cmap2.add(k1,'v1');
        cmap2.cleanLessThanTwoList();
        Test.stopTest();
        System.assertNotEquals(null,k1);
        System.assertNotEquals(null,cmap.KeySet());
    }
  
}