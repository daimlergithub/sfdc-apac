/**
    Type:       Batch class for UserHelper    
    Purpose:    Insert the share data in batch class so that the insert operation cannot be up to the system limitation.
    User Story: Release 1.3
    Used By:    UserHelper
    ---------------------------------------------------------------
    History:  
    06-11-2014 zhongyang.si(NTTData)  Created
 */
global class ShareDataToNewUserBatch implements Database.Batchable<sObject>{
    global final ID newUserID;
    global final String existUserIDs;
    global final String sobjectName;

    global ShareDataToNewUserBatch(ID userID, Set<ID> userIDList, String sobjectNameStr){
        newUserID = userID;
        sobjectName = sobjectNameStr;
        String userIDs = '';
        for (ID id : userIDList) {
            String idStr = '\'' + id + '\',';
            userIDs += idStr;
        }
        existUserIDs = userIDs.left(userIDs.length()-1);
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT {0} FROM {1} WHERE {2}';
        List<String> condition = new List<String>();
        if ('Account'.equalsIgnoreCase(sobjectName)){
            condition.add('ID');
            condition.add('Account');
            condition.add('ID IN (SELECT accountid FROM accountshare WHERE UserOrGroupId in ('+existUserIDs+'))');
        } else if ('Vehicle'.equalsIgnoreCase(sobjectName)){
            condition.add('Id');
            condition.add('Vehicle__c');
            condition.add('ID IN (SELECT parentid FROM vehicle__share WHERE UserOrGroupId in ('+existUserIDs+'))');
        } else if ('VehicleRelation'.equalsIgnoreCase(sobjectName)){
            condition.add('Id');
            condition.add('Vehicle_Relationship__c');
            condition.add('ID in (SELECT ParentId from vehicle_relationship__share where UserOrGroupId in ('+existUserIDs+'))');
        } 
        /*else if ('CaseOwner'.equalsIgnoreCase(sobjectName)){
            condition.add('id');
            condition.add('case');
            condition.add('ownerid in ('+existUserIDs+')');
        } else if ('CaseTeamMember'.equalsIgnoreCase(sobjectName)){
            condition.add('parentid');
            condition.add('CaseTeamMember');
            condition.add('MemberId in ('+existUserIDs+')');
        } else if ('Lead'.equalsIgnoreCase(sobjectName)){
            String recordTypes = '';
            recordTypes = recordTypes + '\'' +Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId() + '\',';
            recordTypes = recordTypes + '\'' +Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId() + '\',';
            recordTypes = recordTypes + '\'' +Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Retail Sales Leads').getRecordTypeId() + '\'';
            condition.add('id');
            condition.add('lead__c');
            condition.add('id in (select ParentId from Lead__Share where UserOrGroupId in ('+existUserIDs+')) And recordtypeid In ('+recordTypes+')');
        } else if ('ToolKit'.equalsIgnoreCase(sobjectName)){
            condition.add('id');
            condition.add('tool_kit__c');
            condition.add('id in (select ParentId from tool_kit__Share where UserOrGroupId in ('+existUserIDs+'))');            
        } else if ('ASRetailCampaign'.equalsIgnoreCase(sobjectName)){
            String recordTypes = '';
            recordTypes = recordTypes + '\'' +Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId() + '\'';
            condition.add('id');
            condition.add('Retail_Campaign__c');
            condition.add('id in (select ParentId from Retail_Campaign__Share where UserOrGroupId in ('+existUserIDs+')) AND recordtypeid = '+ recordTypes);
        } else if ('ASCampaign'.equalsIgnoreCase(sobjectName)){
            String recordTypes = '';
            recordTypes = recordTypes + '\'' +Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS Central Campaign').getRecordTypeId() + '\'';
            condition.add('id');
            condition.add('Campaign');
            condition.add('id in (select campaignId from CampaignShare where UserOrGroupId in ('+existUserIDs+')) AND recordtypeid = \'AS Central Campaign\'');
        } else if ('AsYearlyTA'.equalsIgnoreCase(sobjectName)){
            String recordTypes = '';
            recordTypes = recordTypes + '\'' +Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Aftersales Yearly TA').getRecordTypeId() + '\',';
            recordTypes = recordTypes + '\'' +Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Monthly TA').getRecordTypeId() + '\'';
            condition.add('id');
            condition.add('Retail_Campaign__c');
            condition.add('id in (select ParentId from Retail_Campaign__Share where UserOrGroupId in ('+existUserIDs+')) AND recordtypeid IN ('+recordTypes+')');
        } else if ('SmRecords'.equalsIgnoreCase(sobjectName)){
            String recordTypes = '';
            recordTypes = recordTypes + '\'' +Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId() + '\',';
            recordTypes = recordTypes + '\'' +Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Media Retail Campaign').getRecordTypeId() + '\'';
            condition.add('id');
            condition.add('Retail_Campaign__c');
            condition.add('id in (select ParentId from Retail_Campaign__Share where UserOrGroupId in ('+existUserIDs+')) AND recordtypeid IN ('+recordTypes+')');
        } else if ('SmCampaign'.equalsIgnoreCase(sobjectName)){
            String recordTypes = '';
            recordTypes = recordTypes + '\'' +Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Event Centrtal Campaign').getRecordTypeId() + '\'';
            condition.add('id');
            condition.add('Campaign');
            condition.add('id in (select campaignId from CampaignShare where UserOrGroupId in ('+existUserIDs+')) AND recordtypeid ='+recordTypes);   
        } else if ('SmYearlyTA'.equalsIgnoreCase(sobjectName)){
            String recordTypes = '';
            recordTypes = recordTypes + '\'' +Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Sales & Marketing Yearly TA').getRecordTypeId() + '\',';
            recordTypes = recordTypes + '\'' +Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Monthly TA').getRecordTypeId() + '\'';
            condition.add('id');
            condition.add('Retail_Campaign__c');
            condition.add('id in (select ParentId from Retail_Campaign__Share where UserOrGroupId in ('+existUserIDs+')) AND recordtypeid IN ('+recordTypes+')');  
        } else if ('RetailBestPractice'.equalsIgnoreCase(sobjectName)){
            String recordTypes = '';
            recordTypes = recordTypes + '\'' +Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Retail MB Best Practice').getRecordTypeId() + '\',';
            recordTypes = recordTypes + '\'' +Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Retail smart Best Practice').getRecordTypeId() + '\'';
            condition.add('id');
            condition.add('Retail_Campaign__c');
            condition.add('id in (select ParentId from Retail_Campaign__Share where UserOrGroupId in ('+existUserIDs+')) AND recordtypeid IN ('+recordTypes+')');              
        } else if ('BestPractice'.equalsIgnoreCase(sobjectName)){
            String recordTypes = '';
            recordTypes = recordTypes + '\'' +Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('MB Best Practice').getRecordTypeId() + '\',';
            recordTypes = recordTypes + '\'' +Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('smart Best Practice').getRecordTypeId() + '\'';
            condition.add('id');
            condition.add('Campaign');
            condition.add('id in (select campaignId from CampaignShare where UserOrGroupId in ('+existUserIDs+')) AND recordtypeid in ('+recordTypes+')');
        }*/
        return Database.getQueryLocator(String.format(query,condition));
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Sobject> insertSobject;
        if ('Account'.equalsIgnoreCase(sobjectName)) {
            insertSobject = new List<AccountShare>();
            for(sObject acc : scope){
                Account accountShare = (Account)acc;
                AccountShare share = new AccountShare();
                share.AccountAccessLevel = 'Read';
                share.OpportunityAccessLevel = 'Read';
                share.AccountId = accountShare.Id;
                share.UserOrGroupId = newUserID;
                insertSobject.add(share);
            }
        }else if ('Vehicle'.equalsIgnoreCase(sobjectName)){
            insertSobject = new List<Vehicle__Share>();
            for(sObject acc : scope){
                Vehicle__c vehicleShare = (Vehicle__c)acc;
                Vehicle__Share share = new Vehicle__Share();
                share.AccessLevel = 'Read';
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
                share.AccessLevel = 'Read';
                share.ParentID = vehicleRelationshipShare.Id;
                share.RowCause = Schema.Vehicle_Relationship__Share.RowCause.Manual;
                share.UserOrGroupId = newUserID;
                insertSobject.add(share);
            }
        } 
        /* else if ('CaseOwner'.equalsIgnoreCase(sobjectName)){
            Id teamRoleId = [select Id from CaseTeamRole where Name = 'Dealer' limit 1].id;
            insertSobject = new List<CaseTeamMember>();
            for(sObject acc : scope){
                Case caseShare = (Case)acc;
                CaseTeamMember share = new CaseTeamMember();
                share.ParentID = caseShare.id;
                share.MemberId = newUserID;
                share.TeamRoleId = teamRoleId;
                insertSobject.add(share);
            }
        } else if ('CaseTeamMember'.equalsIgnoreCase(sobjectName)){
            Id teamRoleId = [select Id from CaseTeamRole where Name = 'Dealer' limit 1].id;
            insertSobject = new List<CaseTeamMember>();
            for(sObject acc : scope){
                CaseTeamMember caseShare = (CaseTeamMember)acc;
                CaseTeamMember share = new CaseTeamMember();
                share.ParentID = caseShare.parentid;
                share.MemberId = newUserID;
                share.TeamRoleId = teamRoleId;
                insertSobject.add(share);
            }
        } else if ('Lead'.equalsIgnoreCase(sobjectName)){
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
        } else if ('ToolKit'.equalsIgnoreCase(sobjectName)){
            insertSobject = new List<Tool_Kit__Share>();
            for(sObject acc : scope){
                Tool_Kit__c toolKitShare = (Tool_Kit__c)acc;
                Tool_Kit__Share share = new Tool_Kit__Share();
                share.AccessLevel = 'Edit';
                share.ParentID = toolKitShare.id;
                share.RowCause = Schema.Tool_Kit__Share.RowCause.Manual;
                share.UserOrGroupId = newUserId;
                insertSobject.add(share);
            }
        } else if ('ASRetailCampaign'.equalsIgnoreCase(sobjectName) || 'AsYearlyTA'.equalsIgnoreCase(sobjectName) || 'SmRecords'.equalsIgnoreCase(sobjectName)|| 'SmYearlyTA'.equalsIgnoreCase(sobjectName) || 'RetailBestPractice'.equalsIgnoreCase(sobjectName)){
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
        } else if ('ASCampaign'.equalsIgnoreCase(sobjectName) || 'SmCampaign'.equalsIgnoreCase(sobjectName) || 'BestPractice'.equalsIgnoreCase(sobjectName)){
            insertSobject = new List<CampaignShare>();
            for(sObject acc : scope){
                Campaign campaignShare = (Campaign)acc;
                CampaignShare share = new CampaignShare();
                share.CampaignAccessLevel = 'Read';
                share.CampaignID = campaignShare.id;
                share.UserOrGroupId = newUserId;
                insertSobject.add(share);
            }
        }*/
        try {
            DataBase.insert(insertSobject, false);
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing '+ sobjectName +' to new Dealer user: ' + e);
        }
    }

    global void finish(Database.BatchableContext BC){

    }
}