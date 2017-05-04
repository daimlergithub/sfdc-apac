public class AddToCampaign {

 
 public Id CampaignId { get; set; }
 public Id AccountId { get; set; }
 public String CampaignName { get; set; }
 public String AccountName { get; set; }
    public CampaignMember tempMember {get;set;}   
    
    public AddToCampaign(ApexPages.StandardController controller) {

     CampaignId =ApexPages.currentPage().getParameters().get('c_id');
     AccountId=ApexPages.currentPage().getParameters().get('parent_id'); 
      
      
     
     system.debug('+++++++++++++++++'+AccountId);
     system.debug('+++++++++++++++++'+CampaignId );
     
   
   Account accList =[Select Name From Account Where Id =:AccountId ];
   Campaign camList = [Select Name From Campaign Where Id =: CampaignId ];
   
     CampaignName = camList.Name;
     AccountName = accList.Name;
     
 }
 
 public pageReference redirectToCampaign(){
 
   PageReference nextPage = new PageReference('/' +'a1I/e?CF00Np00000012fon='+CampaignName+'&00Np00000012fon_lkid='+CampaignId+'&CF00Np00000012for='+AccountName+'&CF00Np00000012for_lkid='+AccountId  );
        return nextPage;
  
 
    return null;
 }

}