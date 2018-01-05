global class ShareALLRecordsToNewUserBatchTH implements Database.Batchable<sObject>{
global final ID newUserID;
global final String existUserIDs;
global final String sobjectName;

global ShareALLRecordsToNewUserBatchTH (ID userID, set<id> lstofuser, String sobjectNameStr,boolean isShareorRevoke){
    newUserID = userID;
        sobjectName = sobjectNameStr;
        String userIDs = '';
        for (ID id : lstofuser) {
            String idStr = '\'' + id + '\',';
            userIDs += idStr;
        }
        existUserIDs = userIDs.left(userIDs.length()-1);
        
    
}

global Database.QueryLocator start(Database.BatchableContext BC){
    String query = 'SELECT {0} FROM {1} WHERE {2} and {3}';
        List<String> condition = new List<String>();
        if ('Account'.equalsIgnoreCase(sobjectName)){
            condition.add('ID');
            condition.add('Account');
            condition.add('ID IN (SELECT accountid FROM accountshare WHERE UserOrGroupId in ('+existUserIDs+'))');
            condition.add('md__c=\'TH\'');
        } 
        else if ('Lead'.equalsIgnoreCase(sobjectName)){
            condition.add('id');
            condition.add('lead__c');
            condition.add('id in (select ParentId from Lead__Share where UserOrGroupId in ('+existUserIDs+'))');
            condition.add('md__c=\'TH\'');
        }
        else if ('Vehicle'.equalsIgnoreCase(sobjectName)){
            condition.add('Id');
            condition.add('Vehicle__c');
            condition.add('ID IN (SELECT parentid FROM vehicle__share WHERE UserOrGroupId in ('+existUserIDs+'))');
            condition.add('md__c=\'TH\'');
        } else if ('VehicleRelation'.equalsIgnoreCase(sobjectName)){
            condition.add('Id');
            condition.add('Vehicle_Relationship__c');
            condition.add('ID in (SELECT ParentId from vehicle_relationship__share where UserOrGroupId in ('+existUserIDs+'))');
            condition.add('md__c=\'TH\'');
        } 
        else if ('Case'.equalsIgnoreCase(sobjectName)){
            condition.add('id');
            condition.add('case');
            condition.add('ownerid in ('+existUserIDs+')');
            condition.add('md__c=\'TH\'');
        } 
        else if ('RetailCampaign'.equalsIgnoreCase(sobjectName)){
            condition.add('id');
            condition.add('Retail_Campaign__c');
            condition.add('id in (select ParentId from Retail_Campaign__Share where UserOrGroupId in ('+existUserIDs+'))');
            condition.add('md__c=\'TH\'');
        }
        else if ('CampaignMemberCustom'.equalsIgnoreCase(sobjectName)){
            condition.add('id');
            condition.add('Campaign_member__c');
            condition.add('id in (select ParentId from Campaign_member__share where UserOrGroupId in ('+existUserIDs+'))');
            condition.add('md__c=\'TH\'');
        }
        else if ('Campaign'.equalsIgnoreCase(sobjectName)){
            condition.add('id');
            condition.add('Campaign');
            condition.add('id in (select CampaignID from Campaignshare where UserOrGroupId in ('+existUserIDs+'))');
            condition.add('md__c=\'TH\'');
        }
        else if ('Accountlink'.equalsIgnoreCase(sobjectName)){
            condition.add('id');
            condition.add('Account_link__c');
            condition.add('id in (select ParentId from Account_Link__share where UserOrGroupId in ('+existUserIDs+'))');
            condition.add('md__c=\'TH\'');
        } 
        else if ('User'.equalsIgnoreCase(sobjectName)){
            condition.add('id');
            condition.add('User');
            condition.add('id in (select UserId from Usershare where UserOrGroupId in ('+existUserIDs+'))');
            condition.add('market__c=\'TH\'');
        } 
        else if ('CarModel'.equalsIgnoreCase(sobjectName)){
            condition.add('id');
            condition.add('Car_model__c');
            condition.add('id in (select ParentId from Car_model__share where UserOrGroupId in ('+existUserIDs+'))');
            condition.add('md__c=\'TH\'');
        } 
        else if ('SurveyTaken'.equalsIgnoreCase(sobjectName)){
            condition.add('id');
            condition.add('SurveyTaker__c');
            condition.add('id in (select ParentId from SurveyTaker__share where UserOrGroupId in ('+existUserIDs+'))');
            condition.add('md__c=\'TH\'');
        } 
        else if ('Survey'.equalsIgnoreCase(sobjectName)){
            condition.add('id');
            condition.add('Survey__c');
            condition.add('id in (select ParentId from Survey__Share where UserOrGroupId in ('+existUserIDs+'))');
            condition.add('md__c=\'TH\'');
        } 
 return Database.getQueryLocator(String.format(query,condition));

}
 global void execute(Database.BatchableContext BC, List<sObject> scope){
      List<Sobject> insertSobject;
        if ('Account'.equalsIgnoreCase(sobjectName)) {
            insertSobject = new List<AccountShare>();
            for(sObject acc : scope){
                Account accou = (Account)acc;
                AccountShare share = new AccountShare();
                share.AccountAccessLevel = 'EDIT';
                share.OpportunityAccessLevel = 'READ';
                share.AccountId = accou.Id;
                share.UserOrGroupId = newUserID;
                share.RowCause = Schema.AccountShare.RowCause.Manual;
                insertSobject.add(share);
            }
 
 }
 else if ('Vehicle'.equalsIgnoreCase(sobjectName)){
            insertSobject = new List<Vehicle__Share>();
            for(sObject acc : scope){
                Vehicle__c vehicleShare = (Vehicle__c)acc;
                Vehicle__Share share = new Vehicle__Share();
                share.AccessLevel = 'READ';
                share.ParentID = vehicleShare.Id;
                share.RowCause = Schema.Vehicle__Share.RowCause.Manual;
                share.UserOrGroupId = newUserID;
                insertSobject.add(share);
            }
        } else if ('VehicleRelation'.equalsIgnoreCase(sobjectName)){
            insertSobject = new List<Vehicle_Relationship__Share>();
            for(sObject acc : scope){
                Vehicle_Relationship__c vehicleRelationshipShare = (Vehicle_Relationship__c)acc;
                Vehicle_Relationship__Share share = new Vehicle_Relationship__Share();
                share.AccessLevel = 'READ';
                share.ParentID = vehicleRelationshipShare.Id;
                share.RowCause = Schema.Vehicle_Relationship__Share.RowCause.Manual;
                share.UserOrGroupId = newUserID;
                insertSobject.add(share);
            }
        } 
        else if ('Lead'.equalsIgnoreCase(sobjectName)){
            insertSobject = new List<Lead__Share>();
            for(sObject acc : scope){
                Lead__c leadShare = (Lead__c)acc;
                Lead__Share share = new Lead__Share();
                share.AccessLevel = 'Edit';
                share.ParentID = leadShare.id;
                share.RowCause = Schema.Lead__Share.RowCause.Manual;
                share.UserOrGroupId = newUserId;
                insertSobject.add(share);
            }
        }
        else if ('RetailCampaign'.equalsIgnoreCase(sobjectName)){
        insertSobject = new List<Retail_Campaign__Share>();
            for(sObject acc : scope){
                Retail_Campaign__c retailCampaignShare = (Retail_Campaign__c)acc;
                Retail_Campaign__Share share = new Retail_Campaign__Share();
                share.AccessLevel = 'Edit';
                share.ParentID = retailCampaignShare.id;
                share.RowCause = Schema.Retail_Campaign__Share.RowCause.Manual;
                share.UserOrGroupId = newUserId;
                insertSobject.add(share);
            }   
        } 
        else if ('Accountlink'.equalsIgnoreCase(sobjectName)){
            insertSobject = new List<Account_Link__share>();
            for(sObject acc : scope){
                Account_Link__c campaignShare = (Account_Link__c)acc;
                Account_Link__share share = new Account_Link__share();
                share.AccessLevel = 'EDIT';
                share.parentid = campaignShare.id;
                share.UserOrGroupId = newUserId;
                share.RowCause = Schema.Account_link__Share.RowCause.Manual;
                insertSobject.add(share);
            }
        }
        else if ('CarModel'.equalsIgnoreCase(sobjectName)){
            insertSobject = new List<Car_Model__share>();
            for(sObject acc : scope){
                Car_Model__c campaignShare = (Car_Model__c)acc;
                Car_Model__share share = new Car_Model__share();
                share.AccessLevel = 'READ';
                share.parentid = campaignShare.id;
                share.UserOrGroupId = newUserId;
                share.RowCause = Schema.Car_model__Share.RowCause.Manual;
                insertSobject.add(share);
            }
        }
        else if ('Campaign'.equalsIgnoreCase(sobjectName)){
            insertSobject = new List<CampaignShare>();
            for(sObject acc : scope){
                Campaign campaignShare = (Campaign)acc;
                CampaignShare share = new CampaignShare();
                share.CampaignAccessLevel = 'READ';
                share.CampaignID = campaignShare.id;
                share.UserOrGroupId = newUserId;
                share.RowCause = Schema.CampaignShare.RowCause.Manual;
                insertSobject.add(share);
            }
        }
        else if ('CampaignMemberCustom'.equalsIgnoreCase(sobjectName)){
            insertSobject = new List<Campaign_member__share>();
            for(sObject acc : scope){
                Campaign_member__c campaignShare = (Campaign_member__c)acc;
                Campaign_member__share share = new Campaign_member__share();
                share.AccessLevel = 'EDIT';
                share.ParentId=campaignShare.Id;
                share.UserOrGroupId = newUserId;
                share.RowCause = Schema.campaign_member__Share.RowCause.Manual;
                insertSobject.add(share);
            }
        }
       else if ('Case'.equalsIgnoreCase(sobjectName)){
            insertSobject = new List<CaseShare>();
            for(sObject acc : scope){
                Case campaignShare = (Case)acc;
                caseShare share = new caseShare();
                share.CaseAccessLevel = 'EDIT';
                share.CaseId= campaignShare.id;
                share.UserOrGroupId = newUserId;
                share.RowCause = Schema.caseShare.RowCause.Manual;
                insertSobject.add(share);
            }
        }
        else if ('User'.equalsIgnoreCase(sobjectName)){
            insertSobject = new List<UserShare>();
            for(sObject acc : scope){
                User usrsha = (User)acc;
                UserShare share = new UserShare();
                share.UserAccessLevel  = 'READ';
                share.userid = usrsha.id;
                share.UserOrGroupId = newUserId;
                share.RowCause = Schema.userShare.RowCause.Manual;
                insertSobject.add(share);
            }
        }
        else if ('SurveyTaken'.equalsIgnoreCase(sobjectName)){
            insertSobject = new List<SurveyTaker__share>();
            for(sObject acc : scope){
                SurveyTaker__c surveytakerShare = (SurveyTaker__c)acc;
                SurveyTaker__share share = new SurveyTaker__share();
                share.AccessLevel = 'EDIT';
                share.parentid = surveytakerShare.id;
                share.UserOrGroupId = newUserId;
                share.RowCause = Schema.surveyTaker__Share.RowCause.Manual;
                insertSobject.add(share);
            }
        }
        else if ('Survey'.equalsIgnoreCase(sobjectName)){
            insertSobject = new List<Survey__share>();
            for(sObject acc : scope){
                Survey__c surShare = (Survey__c)acc;
                Survey__share share= new Survey__share();
                share.AccessLevel = 'EDIT';
                share.parentid = surShare.id;
                share.UserOrGroupId = newUserId;
                share.RowCause = Schema.Survey__Share.RowCause.Manual;
                insertSobject.add(share);
            }
        }
  try {
            DataBase.insert(insertSobject, false);
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing '+ sobjectName +' to new Dealer user: ' + e);
        }
 }
 global void finish(Database.BatchableContext BC){

    }


}
