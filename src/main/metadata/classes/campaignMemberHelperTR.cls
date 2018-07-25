/**
* Utility for Trigger on Campaignmemberfor TR(Turkey)
* Author: Hildaa
*/

public class campaignMemberHelperTR{

public static void beforeInsertevents(List<CampaignMember> camp){
  CampaignMemberHelperBase.beforeInsertevents(camp, Label.TR);
}

}