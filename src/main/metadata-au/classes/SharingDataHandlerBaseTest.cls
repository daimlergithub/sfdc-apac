@isTest

public class SharingDataHandlerBaseTest {

public static testMethod void testSharingDataHandlerBase() 
{
   String AccessLevel = 'Read';
    //String shareObjName = 'parentId';
   // Schema.SObjectType  shareType;
    String  originalTypeName='led';
    //String id='parentId';
    //String UserOrGroupId ='UserOrGroupId';
    //String CMap='pIds';
    //String uogIds ='uogIds';
    
    List<sObject> scope=new list<sObject>();
    List<sObject> crmCodeList=new list<sObject>();
    SharingDataHandlerBase sh=new SharingDataHandlerBase(originalTypeName,AccessLevel);
    sh.filterDealer(scope);
    sh.executeProcessByCRMCode(crmCodeList);
   // sh.createShareObject(id,UserOrGroupId );
   // sh.makeInserRecords(CMap,uogIds);
   system.assertNotEquals(null, sh);

}
}