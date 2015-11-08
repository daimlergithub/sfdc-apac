/**
** Schedule Apex
** 1.Scheduleable calculate assigned lead amount of dealer every day
** Date: 2013-3-25
**/

global class ScheduleCalcAmountOfAssignedLeads implements Schedulable {
       /**      
     * @Description assigned lead for dealer is calculated with the scope 200. 
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @return 
                 * @see   execute(SchedulableContext sc)
                */    
    
    global void execute(SchedulableContext sc) {
        String query = 'SELECT Id, Name, Assigned_Lead_Amount_of_Everyday__c, ' + 
            '(SELECT OwnerId, Id FROM Lead_Assigned_Dealer__r WHERE CreatedDate = TODAY) ' + 
            'FROM Account WHERE RecordType.Name = \'Dealer\'';

        BatchCalcAmountOfAssignedLeads calcAssignedLeads = 
            new BatchCalcAmountOfAssignedLeads(query);

        system.debug('@Shrinivas : Start Execution...' +query);
        Id batchId = Database.executeBatch(calcAssignedLeads, 200);
        System.debug('ScheduleMSASolidBaseRevenue Batch Job Id: ' + batchId);
    }
}