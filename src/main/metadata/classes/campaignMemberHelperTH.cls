public class campaignMemberHelperTH{
	public static void beforeInsertevents(List<CampaignMember> camp){
		for(CampaignMember ca:camp){
			if(ca.MD__c=='TH' && (ca.status==''||ca.status==null))
				ca.status='Added';
		}
	}
}