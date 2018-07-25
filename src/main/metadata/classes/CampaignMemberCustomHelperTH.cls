/**************************************************************************************************************************************************
* Class:                            CampaignMemberCustomHelperTH
* Description:                      This class will handles the Custom Campaign Member functionalities
@ CampaignmemberssharewithsubDealers() this method will Share the records to the set of users Under a particular Dealer
@MapCampaignMemberfieldsbasedOnContact() method is used to copy few fields from account to campaignmembers
* --------------------------------------------------------------------------------------------------------------------------------------------------
* Date                              Name                        Modification Description
* Created Date : 2017-10-10     Dhanamjaya D                     Created  

=====================================================================================================================================================*/
public class CampaignMemberCustomHelperTH{
Map<ID,String> retcampstatus=new MAP<Id,String>();
//if the status of parent campaign is Execution or response collection or completed then it will not allow to add the campaign members
public void CampaignmemberssharewithsubDealers(List<Campaign_member__c> campmember){
    Map<id,String> idwithndcode=new Map<id,String>();
    List<Campaign_member__share> campmembershare = new List<Campaign_member__share>();
    for(Campaign_member__c re:[Select id,Createdby.Dealer_Nd_code__c from Campaign_member__c where id IN :campmember]){
            if(Userinfo.getUserType()=='PowerPartner'&& re.createdby.dealer_nd_code__C!=null){
                idwithndcode.put(re.id,'TH'+re.createdby.dealer_nd_code__C);
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
       Database.insert(campmembershare);
   }
}
// this method will restrict to add campaign members if Retail Campaign status Response collection/ Completed
public void  campaignMemberHelperBeforeInsert(List<Campaign_Member__c> campmember){
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
     public static void beforeDeleteOperation(List<Campaign_Member__c> oldList) {
        List<String> CHILD_CAMPAIGN_STATUS_LIST = new List<String> {'Response collection', 'Completed'};//'Execution',
        Map<Id, Campaign_Member__c> campaignMemberMap = 
                    new Map<Id, Campaign_Member__c>([select Id from Campaign_Member__c where Id IN: oldList and Retail_Campaign_Id__r.Child_Campaign_Status__c IN: CHILD_CAMPAIGN_STATUS_LIST ]);
        for(Campaign_Member__c campaignMemberRec : oldList) {
            if(campaignMemberMap.containsKey(campaignMemberRec.Id)) {
                campaignMemberRec.addError('You can\'t delete the Campaign Member for this Campaign Status.');
            }
        }
    }
    //This method will copy address,vehicle,vehiclerelationships,retail copy data to campaign member 
    public static void MapCampaignMemberfieldsbasedOnContact(List<Campaign_Member__c> newlist) {     
        Map<id,Account> addmap =new Map<id,Account>();
        Set<id> accid=new Set<id>();
        Set<Campaign_Member__c> cmpwithcontact=new  Set<Campaign_Member__c>();
        for(Campaign_Member__c campme:newlist){
            if(campme.Contact_Id__c!=null)
                accid.add(campme.Contact_Id__c);
            //it will holds the campaign members whose criteria is matched
            //we are going to use this in for loop
                cmpwithcontact.add(campme);
        }
        //fetch the preffered address of the Customer
        Map<id,account> accmap=new Map<id,account>([select id,firstname,LastName,Individual_Home_Phone__c,Work_Phone__c,Primary_Address_Reference__c,Primary_Address_Reference__r.Address_Line_1__c,Primary_Address_Reference__r.Address_Line_2__c,Primary_Address_Reference__r.Sub_District__c,Primary_Address_Reference__r.District__c,Primary_Address_Reference__r.Preferred__c,Primary_Address_Reference__r.Province__c,Primary_Address_Reference__r.ZipCode__c from account where id IN:accid and md__c='TH' limit 50000]); 
        for(Campaign_Member__c camp:cmpwithcontact){
            
            if(accmap.containskey(camp.Contact_Id__c)){
                camp.Customer_FirstName__c=accmap.get(camp.Contact_Id__c).firstName;
                camp.Customer_lastName__c=accmap.get(camp.Contact_Id__c).LastName;
                camp.Customer_HomePhone__c=accmap.get(camp.Contact_Id__c).Individual_Home_Phone__c;
                camp.Customer_WorkPhone__c=accmap.get(camp.Contact_Id__c).Work_Phone__c;
                if(accmap.get(camp.Contact_Id__c).Primary_Address_Reference__c!=null && accmap.get(camp.Contact_Id__c).Primary_Address_Reference__r.preferred__c){
                  camp.Address__c= accmap.get(camp.Contact_Id__c).Primary_Address_Reference__c;
                  camp.Customer_Complete_Address__c=accmap.get(camp.Contact_Id__c).Primary_Address_Reference__r.Address_Line_1__c+','+accmap.get(camp.Contact_Id__c).Primary_Address_Reference__r.Address_Line_2__c+','+accmap.get(camp.Contact_Id__c).Primary_Address_Reference__r.Sub_District__c+','+accmap.get(camp.Contact_Id__c).Primary_Address_Reference__r.Province__c+','+accmap.get(camp.Contact_Id__c).Primary_Address_Reference__r.ZipCode__c;
               }
            }
            
        }
    }
}