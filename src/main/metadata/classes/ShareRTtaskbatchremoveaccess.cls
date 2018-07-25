global class ShareRTtaskbatchremoveaccess implements Database.Batchable < sObject > {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        String query = '';
        if (!Test.isRunningTest()) {
            query = 'SELECT Id from Retail_Task__Share where rowcause =\'' + Label.rowcaused + '\' and  parent.MD__c=\'' + Label.Mrkt + '\' and parent.createddate >=' + Label.Createdatestartrange + ' and parent.createddate <=' + Label.Createdateendrange;
        } else {
            query = 'SELECT Id from Retail_Task__Share where rowcause =\'' + Label.rowcaused + '\' and  parent.MD__c=\'' + Label.Mrkt + '\'';
        }
        //System.debug(query );
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List < Retail_Task__Share > rtList) {

        if (rtList.size() > 0)
            database.delete(rtList, false);

    }

    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
    }
}