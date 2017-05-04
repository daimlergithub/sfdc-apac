public class segmentationredirect {

    public segmentationredirect(ApexPages.StandardController controller) {
    
    }
    
    public pageReference openPage() 
    {
    pageReference pg = new pageReference('/apex/SegmentationCriteria');
        pg.setRedirect(true);
        return pg;
        }

}