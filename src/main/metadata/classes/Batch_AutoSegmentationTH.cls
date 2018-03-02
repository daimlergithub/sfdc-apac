global class Batch_AutoSegmentationTH implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
Date todaydate=DATE.TODAY();
Boolean flag1=false;
String commubaseurl;

global Database.QueryLocator start(Database.BatchableContext bc) {
Id executionRecordId = RecordTypeAccessService.getRecordTypeId('Retail_Campaign__c','Campaign Execution');
//List<Network>  myNetwork = [SELECT Id,Name FROM Network where Name='Daimler Community Thailand'];

List<Network>  myNetwork = [SELECT Id,Name FROM Network];
       for(Network net:myNetwork){
           if(net.name=='Dealer Community Thailand'){
           flag1=true;
           commubaseurl=Network.getLoginUrl(net.id)+'/';
           break;
           }
       }
List<Retail_campaign__c> retcamp=new List<Retail_Campaign__c>();
if(!Test.isRunningTest()){
    String query = 'Select Id,Name,owner.Email,OwnerId,Segmentation_Criteria__r.Criteria__c, Owner.Name from Retail_Campaign__c Where Auto_Segmentation__c = true AND Segmentation_Date__c =: todaydate AND IsAutoSegmentationExecuted__c = false and recordtypeid=:executionRecordId';
     query+= ' AND MD__c=\'TH\'';
     return Database.getQueryLocator(query);
}else{
  Date todaydate=DATE.TODAY();
    Date nextdate=todaydate.addDays(2);
    String query = 'Select Id,Name,owner.Email,OwnerId,Segmentation_Criteria__r.Criteria__c, Owner.Name from Retail_Campaign__c Where Auto_Segmentation__c = true AND Segmentation_Date__c =: nextdate AND IsAutoSegmentationExecuted__c = false and recordtypeid=:executionRecordId';
     query+= ' AND MD__c=\'TH\'';
     return Database.getQueryLocator(query);
 }
}
global void execute(Database.BatchableContext bc, List<Retail_Campaign__c> scope) {
    List<Retail_Campaign__c> retcamptoupdate=new List<Retail_Campaign__c>();
    for(Retail_Campaign__c retcampaign :scope){
        List<Account> acctoaddasCampaignmembers=new List<Account>();
        List<Campaign_Member__C> campmember=new List<Campaign_member__C>();
        String quer;
        String querystring=retcampaign.Segmentation_Criteria__r.Criteria__c;
        if(querystring.contains('and Id in (,')){
        quer=querystring.replace('and Id in (,','and Id in (');
        }
        else{
            quer=querystring;
        }
        acctoaddasCampaignmembers=Database.query(quer);
        for(Account Acc:acctoaddasCampaignmembers){
            campaign_member__c camMem=new Campaign_Member__c();
             camMem.Contact_Id__c = acc.Id;
                camMem.Retail_Campaign_Id__c = retcampaign.Id;
                camMem.OwnerId=retcampaign.OwnerId;
                campmember.add(camMem);
        }    
        if(campmember.size()>0){
        //insert campmember;
        DMLManagerService.insertAsSystem(campmember);
        }
         List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
          String emailBodyStr = '';
           emailBodyStr = emailBodyStr +'Number Of Campaign Members Added sucessfully  :';
           emailBodyStr = emailBodyStr + campmember.size()+'  \n'  ;
           emailBodyStr = emailBodyStr + '\n Retail Campaign Name is '+retcampaign.Name+'  \n' ;
           if(flag1){
           emailBodyStr+='\n For Communities:\n'+commubaseurl+retcampaign.id;
           }
           else{
           emailBodyStr+='\n No Community found';
           }
           emailBodyStr+='\n For Salesforce Users\n'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+retcampaign.id;
           Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
           
           msg.SetsaveAsActivity(false); 
           msg.subject = 'Campaign Notification';
           msg.setHTMLBody(emailBodyStr);
           msg.setTargetObjectId(retcampaign.OwnerId);
           List<String> emailSet=new List<STring>();
           emailSet.add(retcampaign.Owner.Email);
           system.debug('&&&&&&&&&&'+retcampaign.Owner.Email+'@@@@@@'+retcampaign.Owner);
           msg.SetToAddresses(emailSet);  
           msgList.add(msg);
           Messaging.sendEmail(msgList);
           retcampaign.IsAutoSegmentationExecuted__c=true;
           retcamptoupdate.add(retcampaign);
    }
    if(retcamptoupdate.size()>0){
        DMLManagerService.updateAsSystem(retcamptoupdate);
    }
}

 global void finish(Database.BatchableContext bc) {
    
    }
    global void execute(SchedulableContext ctx) {
    Database.ExecuteBatch(new Batch_AutoSegmentationTH (),10);
    }
}