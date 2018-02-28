/*
 Purpose : Update the Campaign_Member__c Address  using refresh button and concatenate to  Customer complete address field.
 Created : Siivaram A
 Date: 10-02-2017
 */

global class Updatecampaignmemwithrefresh{
  static User usr = [Select id, LanguageLocaleKey,Dealer_GC_Code__c,Market__c,ProfileId,Profile.Name from User WHERE ID = : UserInfo.getUserId()]; 
    webservice static void Refreshcampaignmember(String camid){
   
    if(!Test.isRunningTest()){
    Batch_RefreshButton batcher = new Batch_RefreshButton(camid);
                Database.executeBatch(batcher, 20);
                }
    
    }
    
    webservice static void Refreshretcampaignmember(String retcamid){
  
    
   
   Batch_RefreshButtonRetail batcher = new Batch_RefreshButtonRetail (retcamid);
                Database.executeBatch(batcher, 50);
   
    }
    
    }