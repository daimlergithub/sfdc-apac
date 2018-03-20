/*
    Type:       class
    Purpose:    Campaign Member Helper Base  
    User Story:     
    Used By:    
*/
public class CampaignMemberHelperBase{
   /* Data Migration Explicit Fix - Santosh Mohanty */
    public static void updateCampaignMembermarket(List<CampaignMember> campMemList){       
        
               for(CampaignMember campMem : campMemList){
                    if(Test.isRunningTest()){
                        campMem.isTestRunning__c=true;
                    }
                   if(campMem.Market__c =='' || campMem.Market__c==NULL){
                      campMem.Market__c=campMem.MD__c;
                  }  
              }       
    }    
    public static void updateCampaignMemberCustommarket(List<Campaign_Member__c> campMemCustList){       
        
               for(Campaign_Member__c campMemCust : campMemCustList){
                    if(Test.isRunningTest()){
                        campMemCust.isTestRunning__c=true;
                    }
                   if(campMemCust.Market__c =='' || campMemCust.Market__c==NULL){
                      campMemCust.Market__c=campMemCust.MD__c;
                  }  
              }       
    }
	
	public static void beforeInsertevents(List<CampaignMember> camp,String Market){
		for(CampaignMember ca:camp){
			if(ca.status==''){
			ca.status='Added';
			}

		}
		}
   
}