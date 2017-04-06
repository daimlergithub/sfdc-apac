/**
    *@Description : This class is used to add the members to Chatter group.
    *@Author : Kiran P.
    *@Date : 4/12/2017
    *@Refered: Announcement page
    *@Release : Japan J4
    */
global class AddingMemberstoChatterGroup implements Database.Batchable<sObject>{
     global Database.QueryLocator start(Database.BatchableContext BC){
     return Database.getQueryLocator([SELECT id, Name,Market__c,profileId,profile.Name from User WHERE Market__c= 'JP' AND 
                                      profile.Name != 'Japan Dealer Company Manager' AND profile.Name !='Japan Dealer Sales Manager' AND profile.Name != 'Japan Dealer Sales Representative'
                                      AND profile.Name != 'Japan Dealer Service Advisor' AND profile.Name != 'Japan Dealer Service Manager' AND isActive = true]);                                
     }
      //EXECUTE METHOD
    global void execute(Database.BatchableContext BC, List<User> scope){
          List<CollaborationGroupMember> collbgrpmember = new List<CollaborationGroupMember>();
          system.debug('Lead Scope :'+Scope);
         CollaborationGroup Chattergrp;
         if(!Test.isRunningTest()){
          Chattergrp = [SELECT Id, Name From CollaborationGroup WHERE Name =: 'Dealer Community' LIMIT 1];
          }else {
               Chattergrp = [SELECT Id, Name From CollaborationGroup WHERE Name =: 'Dealer Community1' LIMIT 1];
          }
          system.debug('------>'+Chattergrp);
          for(user usr :scope){
              CollaborationGroupMember mem = new CollaborationGroupMember();
              mem.CollaborationGroupId = Chattergrp.id;
              mem.MemberId = usr.id;
              //mem.id = usr.id;
              collbgrpmember.add(mem);
          }
          if(!collbgrpmember.isEmpty()){
              Database.insert(collbgrpmember,false);
          }
          
    }  
     global void finish(Database.BatchableContext BC){
       
	   
    }                  
}