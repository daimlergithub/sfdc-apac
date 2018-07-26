/**
* Utility for Trigger on Campaignmemberfor IN(India)
* Author: Sravanthi Gudibandi
* Created Date : 5th May 2018
*/

public class campaignMemberHelperIN{

public static void beforeInsertevents(List<CampaignMember> camp){
  CampaignMemberHelperBase.beforeInsertevents(camp, Label.IN);
}

}