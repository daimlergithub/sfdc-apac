public class segmentationredirect {

    public segmentationredirect(ApexPages.StandardController controller) {
    
    }
    
    public pageReference openPage() 
    {
    User usr=[select id,market__C from User where id=:UserInfo.getUserId()];
if(usr.market__c=='TH'){
return Page.SegmentationCriteria_TH;
}if(usr.market__c=='JP'){
   // pageReference pg = new pageReference('/apex/SegmentationCriteria');
      //  pg.setRedirect(true);
	   ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.This_function_cannot_be_used));
        return null;
        }
		else{
		return null;
		}
        }
}