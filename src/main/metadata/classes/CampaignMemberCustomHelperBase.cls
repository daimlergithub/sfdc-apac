/**************************************************************************************************************************************************
* Class:                            CampaignMemberCustomHelperTH
* Description:                      This class will handles the Custom Campaign Member functionalities
@ CampaignmemberssharewithsubDealers() this method will Share the records to the set of users Under a particular Dealer
* --------------------------------------------------------------------------------------------------------------------------------------------------
* Date                              Name                        Modification Description
* Created Date : 2017-10-10     Dhanamjaya D                    Created  

=====================================================================================================================================================*/
public class CampaignMemberCustomHelperBase{
Map<ID,String> retcampstatus=new MAP<Id,String>();
//if the status of parent campaign is Execution or response collection or completed then it will not allow to add the campaign members
public void CampaignmemberssharewithsubDealers(List<Campaign_member__c> campmember, string Market){
    Map<id,String> idwithndcode=new Map<id,String>();
    List<Campaign_member__share> campmembershare = new List<Campaign_member__share>();
    for(Campaign_member__c re:[Select id,Createdby.Dealer_Nd_code__c,Createdby.Market__c,MD__c from Campaign_member__c where id IN :campmember and MD__c=:Market]){
            if(Userinfo.getUserType()=='PowerPartner'&& re.createdby.dealer_nd_code__C!=null){
				string grpName=(string.isnotblank(re.MD__c)?re.MD__c:(string.isnotblank(re.Createdby.Market__c)?re.Createdby.Market__c:'') )+re.createdby.dealer_nd_code__C;
                idwithndcode.put(re.id,grpName);
            }
    }
    for(Group g:[select Name from group where name IN : idwithndcode.values() ]){
       for(Id id:idwithndcode.keyset()){
           if(idwithndcode.get(id)==g.name){
               campmembershare.add(new Campaign_member__share(ParentId=id,AccessLevel='EDIT',RowCause=Schema.Campaign_member__share.RowCause.Manual,UserOrGroupId=g.id));  
           }
        }
    }
   if(campmembershare .size()>0){
       Database.insert(campmembershare,false);
   }
}
// this method will restrict to add campaign members if Retail Campaign status Response collection/ Completed
public void  campaignMemberHelperBeforeInsert(List<Campaign_Member__c> campmember, String market){
    List<ID> retcamplst=new List<ID>();
    List<Retail_Campaign__c> retcamplststatus=new List<Retail_Campaign__c>();
    for(Campaign_Member__c camp:campmember){
        if(camp.Retail_Campaign_Id__c!=null){
            retcamplst.add(camp.Retail_Campaign_Id__c);
        }
    }
    for(Retail_Campaign__c camp: [Select id,Child_Campaign_Status__c from Retail_Campaign__c where id IN : retcamplst and Child_Campaign_Status__c!='']){    
            retcampstatus.put(camp.id,camp.Child_Campaign_Status__c);
    }
    for(Campaign_Member__c camp:campmember){
            if(camp.Retail_Campaign_Id__c!=null && retcampstatus.get(camp.Retail_Campaign_Id__c)=='Response collection'||retcampstatus.get(camp.Retail_Campaign_Id__c)=='Completed'){
                camp.addError('You Can Not Add Campaign Members with Retail Campaign Status Response Collection/Completed');
        }
    }
    
    }
    //Will allow to delete the campaign members with the campaign status "segmentation 
     public void beforeDeleteOperation(List<Campaign_Member__c> oldList) {
        List<String> CHILD_CAMPAIGN_STATUS_LIST = new List<String> {'Response collection', 'Completed'};//'Execution',
        Map<Id, Campaign_Member__c> campaignMemberMap = 
                    new Map<Id, Campaign_Member__c>([select Id from Campaign_Member__c where Id IN: oldList and Retail_Campaign_Id__r.Child_Campaign_Status__c IN: CHILD_CAMPAIGN_STATUS_LIST ]);
        for(Campaign_Member__c campaignMemberRec : oldList) {
            if(campaignMemberMap.containsKey(campaignMemberRec.Id)) {
                campaignMemberRec.addError('You can\'t delete the Campaign Member for current Campaign Status.');
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
}