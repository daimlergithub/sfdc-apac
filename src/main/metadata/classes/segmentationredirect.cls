public class segmentationredirect {

    public segmentationredirect(ApexPages.StandardController controller) {
    
    }
    
    public pageReference openPage() 
    {
    User usr=[select id,market__C from User where id=:UserInfo.getUserId()];
if(usr.market__c=='TH'){
return Page.SegmentationCriteria_TH;
}else{
    pageReference pg = new pageReference('/apex/SegmentationCriteria');
        pg.setRedirect(true);
        return pg;
        }
        }
}