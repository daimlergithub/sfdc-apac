/**
    *@Description : This class is implemented to post the chatter to private group.
    *@Author : Kiran P.
    *@Date : 4/12/2017
    *@Refered: Announcement page
    *@Release : Japan J4
    */
public class AnnouncementController{
    public String detail { get; set;}
    public String groupId { get; set;}
    public String message { get; set; }
    public boolean isVisible {get;set;}
    public boolean isVisibleforDealers {get;set;}
    public List<CollaborationGroupFeed> dealerchatterfeed {get;set;}
    public AnnouncementController(){  
    
        dealerchatterfeed  = [Select Body, Title,parent.Name,InsertedBy.Name, Type From CollaborationGroupFeed where parent.Name='Dealer Community'];
        system.debug('#######'+dealerchatterfeed);    
        isVisible =true;
        isVisibleforDealers = false;
        user usr = [select id,profileId,profile.Name,ContactId from User WHERE Id =: userInfo.getUserId()];
        if(usr.ContactId != NULL){
           isVisible = false;
           isVisibleforDealers = true;
        } 
    }
    public PageReference doPost() {
        FeedItem fItem = new FeedItem();
        CollaborationGroup Chattergrp;
        if(!Test.isRunningTest()){
             Chattergrp = [SELECT Id, Name From CollaborationGroup WHERE Name =: 'Dealer Community' LIMIT 1];
        }else
            Chattergrp = [SELECT Id, Name From CollaborationGroup LIMIT 1];
			
        fItem.parentId = Chattergrp.id;        
        fItem.body = detail;
        insert fItem;
        
        //PageReference pg = new PageReference('/');
        return null;
    }
}