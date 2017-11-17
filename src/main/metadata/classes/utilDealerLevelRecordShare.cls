/*********************************************************************************
    Method Name  : utilDealerLevelRecordShare
    Created By   : 
    Created Date : 16th November 2017
    Project      : Daimler APAC
    Usages       : This a generic util class to having the common logic.
                    To handle dealer outlet hierarchy level sharing of records.
    
 ***********************************************************************************/
 
public class utilDealerLevelRecordShare 
{
  /*************************************************************************************************************************
    Method Name  : shareRecordsWithinDealership
    Created By   : 
    Created Date : 16th November 2017
    Project      : Daimler APAC
    Usages       : This is a generic method which would the pick the dealer users based on the hierarchy setup on the user level 
                    and send the list of users to be shared back to the calling class and method.
    
  ***************************************************************************************************************************/
    public static list<Id> shareRecordsWithinDealership (set<Id> ownerIdSet)
    {
        list<User> queryUserList = new list<User>();
        list<Id> responseUserList = new list<Id>();
        set<Id> teamLeaderUserSet = new set<Id>();
        set<Id> managerUserSet = new set<Id>();
        
        if(!ownerIdSet.isEmpty() && ownerIdSet != null)
        {
            queryUserList = [select Id, MBK_Partner_Roles__c, MBK_Reporting_Partner_User__c, MBK_Reporting_Partner_User__r.MBK_Partner_Roles__c from user where Id in : ownerIdSet];
        }
        system.debug('    *$*$*$* queryUserList  ' + queryUserList);
        if(!queryUserList.isEmpty() && queryUserList != null)
        {
            for(User usr: queryUserList)
            {
                system.debug(usr.MBK_Reporting_Partner_User__c + '    *$*$*$* User query result  ' + usr.MBK_Partner_Roles__c + '  *$*$*$* hierarchy role   ' + usr.MBK_Reporting_Partner_User__r.MBK_Partner_Roles__c);
                if(usr.MBK_Partner_Roles__c == 'Sales Consultant' && usr.MBK_Reporting_Partner_User__c != null && usr.MBK_Reporting_Partner_User__r.MBK_Partner_Roles__c == 'Team Leader')
                {
                    teamLeaderUserSet.add(usr.MBK_Reporting_Partner_User__c);
                    responseUserList.add(usr.MBK_Reporting_Partner_User__c);
                    system.debug('*$*$*$* responseUserList Team Leaders  ' + responseUserList);
                }
                else if(usr.MBK_Partner_Roles__c == 'Team Leader' && usr.MBK_Reporting_Partner_User__c != null && usr.MBK_Reporting_Partner_User__r.MBK_Partner_Roles__c == 'Sales Manager')
                {
                    managerUserSet.add(usr.MBK_Reporting_Partner_User__c);
                    responseUserList.add(usr.MBK_Reporting_Partner_User__c);
                    system.debug('*$*$*$* responseUserList Managers  ' + responseUserList);
                }
                else if(usr.MBK_Partner_Roles__c == 'Sales Manager' && usr.MBK_Reporting_Partner_User__c != null)
                {
                    managerUserSet.add(usr.MBK_Reporting_Partner_User__c);
                    responseUserList.add(usr.MBK_Reporting_Partner_User__c);
                    system.debug('*$*$*$* responseUserList GM Managers  ' + responseUserList);
                }
            }
        }
        if((!teamLeaderUserSet.isEmpty() && teamLeaderUserSet != null) || (!managerUserSet.isEmpty() && managerUserSet != null))
        {
            queryUserList = [select Id, MBK_Partner_Roles__c, MBK_Reporting_Partner_User__c, MBK_Reporting_Partner_User__r.MBK_Partner_Roles__c from user where Id in : teamLeaderUserSet or Id in : managerUserSet];
        }
        if(!queryUserList.isEmpty() && queryUserList != null)
        {
            for(User usr: queryUserList)
            {
                if(usr.MBK_Partner_Roles__c == 'Team Leader' && usr.MBK_Reporting_Partner_User__c != null && usr.MBK_Reporting_Partner_User__r.MBK_Partner_Roles__c == 'Sales Manager')
                {
                    responseUserList.add(usr.MBK_Reporting_Partner_User__c);
                    system.debug('*$*$*$* Getting 2nd Level Managers responseUserList   ' + responseUserList);
                }
                else if(usr.MBK_Partner_Roles__c == 'Sales Manager' && usr.MBK_Reporting_Partner_User__c != null)
                {
                    responseUserList.add(usr.MBK_Reporting_Partner_User__c);
                    system.debug('*$*$*$* Getting 3rd Level Managers responseUserList if any    ' + responseUserList);
                }
            }
        }
        system.debug('*$*$*$* Final returned responseUserList  ' + responseUserList);
        return responseUserList;
    }
}