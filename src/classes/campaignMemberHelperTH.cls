public class campaignMemberHelperTH{

public static void beforeInsertevents(List<CampaignMember> camp){
for(CampaignMember ca:camp){
system.debug('######'+ca.status);
if(ca.MD__c=='TH' && ca.status==''){
ca.status='Added';
}

}

}

}