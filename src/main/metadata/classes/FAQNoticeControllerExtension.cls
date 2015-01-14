public class FAQNoticeControllerExtension{

    public List<FAQ_Notice__c> results {
        get {
            if(results ==null){ 
                results = new List<FAQ_Notice__c>();
            }
            return results ;            
        }            
        set;            
    }   
     
    public String noticeTitle {
        get {
            if(noticeTitle==null){ 
                noticeTitle='';
            }
            return noticeTitle;            
        }            
        set;            
    } 
    
    public FAQNoticeControllerExtension(ApexPages.StandardController stdController) {
        
        String[] noticeType = new String[]{'Both'};
        
        if(UserInfo.getProfileId() != null){
            List<Profile> pList = [Select Name From Profile Where Id=:UserInfo.getProfileId()];
            if(pList != null && pList.size()>0){
                Profile p = pList[0];
                if(p.Name.startsWith('CAC E-CSR')){
                	noticeType.add('IB');
                	noticeType.add('OB');
                }else if(p.Name.startsWith('CAC IB')){
                    noticeType.add('IB');
                }else{
                    noticeType.add('OB');
                }
            }
        }           
        
        results = [
            Select Id,Name,Message_Detail__c,FAQ_URL__c, FAQ_Title__c 
            From FAQ_Notice__c 
            Where CreatedDate = LAST_N_DAYS:10 And FAQ_Notice_Type__c In :noticeType 
            Order by Id Desc];

        if(results !=null && results.size()>0){
            noticeTitle = results[0].Name;      
        }        

    }

}