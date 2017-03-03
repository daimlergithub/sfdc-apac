/**
    *@Description : This class is implemented to post the chatter to private group.
    *@Author : Kiran P.
    *@Date : 4/12/2016
    *@Refered: Announcement page
    *@Release : Japan J4
    */
public with sharing class AnnouncementController{
    public String detail { get; set;}
    public String groupId { get; set;}
    public String message { get; set; }
    public boolean isVisible {get;set;}
    public AnnouncementController(){        
        isVisible =true;
        user usr = [select id,profileId,profile.Name from User WHERE Id =: userInfo.getUserId()];
        String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
       // Dealer profiles can not Post  Announcements
         if(usr.profile.Name.Contains('Dealer') && usr.Market__c != 'JP')
           isVisible = false; 
    }
    public PageReference doPost() {
        FeedItem fItem = new FeedItem();
        CollaborationGroup Chattergrp = [SELECT Id, Name From CollaborationGroup WHERE Name =: 'All MBJ Users' LIMIT 1];
        fItem.parentId = Chattergrp.id;        
        fItem.body = detail;
        insert fItem;
        
        return null;
    }
}