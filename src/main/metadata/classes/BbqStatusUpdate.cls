/************************************************************************************
* Created By:Sarath M
* Created Date:16-Mar-18
* Company:Infosys Ltd
* Description:Batch class for Changing Referral status when the lead status is changed {Won Or Lost}
*********************************************************************************************/
global class BbqStatusUpdate implements Schedulable,Database.Batchable<sObject> {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        string query ='SELECT Id,Lead_Status__c,Lead__c,ReferredEmployee__c,Status__c FROM Referral__c WHERE Lead_Status__c = \'Won\' OR Lead_Status__c = \'Purchased(Only Non BDC)\' OR Lead_Status__c = \'Lost\'';
        return database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Referral__c> referralList){
        system.debug('<<<referralList'+referralList.size());
        list<Referral__c> refUpdateList=new list<Referral__c>();
        for(Referral__c ref:referralList){
            if((ref.Lead_Status__c=='Won' && ref.Status__c!='Won') ||(ref.Lead_Status__c =='Purchased(Only Non BDC)' && ref.Status__c!='Won')){
                system.debug('<<<refLeadStatusWon'+ref.Lead_Status__c);
                ref.Status__c='Won';
                refUpdateList.add(ref);
            }else if(ref.Lead_Status__c=='Lost' && ref.Status__c!='Lost'){
                system.debug('<<<refLeadStatusLost'+ref.Lead_Status__c);
                ref.status__c='Lost';
                refUpdateList.add(ref);
            }
	   }
        if(refUpdateList.size()>0){
            system.debug('Inserted Succcessfully');
            update refUpdateList;
        }
    }    
	 global void finish(Database.BatchableContext bc){
    }
}