/**
Type:       Trigger for User After Update    
Purpose:    1. To get list of users inactivated to process these list in BatchDeleteNews batch class                

User Story: RCP-26
Used By:    
---------------------------------------------------------------
History:

14-August-2018 Surendranath  Created
*/
public class UserTriggerRCPHandler {
    /* Get list of inactive users and submit the list to batch job to delete Darft News */
    public static void ProcessInactiveUsers(List<User> lstUsers){        
        List<id> lstId = new List<Id>();
        for(User u: lstUsers){
            if(u.IsActive == false){
                lstId.add(u.Id); 
            }
        }
        if(lstId.size() > 0){
            BatchDeleteNews delNews = new BatchDeleteNews();
            delNews.lstId = lstId;
            Database.executeBatch(delNews);
        }        
    }     
}