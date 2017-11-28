@isTest
public class segmentationredirectTest{
    public testmethod static void  openPagetest(){
    Test.startTest();
      User user1 = TestUtils.createAdminUser();
      system.runas(user1){
    Segmentation_Criteria__c seg=new Segmentation_criteria__c();
    ApexPages.StandardController sc1 = new ApexPages.StandardController(seg);
        segmentationredirect abc=new segmentationredirect(sc1);
        abc.openPage();
        }
        Test.StopTest();
        
    }
    public testmethod static void  openPagetestKR(){
    Test.startTest();
      User user1 = TestUtils.createAdminUser();
      user1.market__c='KR';
      update user1;
      system.runas(user1){
    Segmentation_Criteria__c seg=new Segmentation_criteria__c();
    ApexPages.StandardController sc1 = new ApexPages.StandardController(seg);
        segmentationredirect abc=new segmentationredirect(sc1);
        abc.openPage();
        }
        Test.StopTest();
        
    }


}