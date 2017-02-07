/**
** Controller for the convert to lead functionality for Campaign Member Records.
** Created By: Siva
** Date: 2017-05-02
**/
public with sharing class ConvertToLeadController {
	
	private final String campaignId = ApexPages.currentPage().getParameters().get('CampaignId');
    public String leadRT {get; set;}
    public List<CampaignMemberInfo> campaignMembers {get; set;}
    private String leadRTId {get; set;}
    private String objectAPIName;
    
    public ConvertToLeadController() {
    	leadRT = 'Sales Leads';
        leadRTId = [SELECT Id, Name FROM RecordType WHERE SobjectType =: UtilConstant.LEAD and name = :leadRT].id;
        
        if(String.isNotBlank(campaignId)) {
        	objectAPIName = (Id.valueOf(campaignId)).getSObjectType().getDescribe().getName();
        	String query = 'SELECT Name, Campaign_ID__r.OwnerId, Retail_Campaign_Id__r.OwnerId FROM Campaign_Member__c WHERE Status__c = \'Responded\' AND ';
        	if(objectAPIName == 'Campaign') {
        		query += ' Campaign_ID__c =: campaignId ';
        	} else if(objectAPIName == 'Retail_Campaign__c') {
        		query += ' Retail_Campaign_Id__c =: campaignId ';
        	}
        	
        	List<Campaign_Member__c> campaignMemberList = Database.query(query);
        	campaignMembers = new List<CampaignMemberInfo>();
	        for(Campaign_Member__c campaignMemberRec : campaignMemberList) {
        		campaignMembers.add(new CampaignMemberInfo(campaignMemberRec));
	        }
        }
    }
    
    
    public class CampaignMemberInfo {
    	public Campaign_Member__c campaignMember { get; set; }
        public Boolean isSelected { get; set; }
        
    	public CampaignMemberInfo(Campaign_Member__c campaignMemberRec) {
            this.campaignMember = campaignMemberRec;
            this.isSelected = false;
        }
    }
    
    public PageReference cancel() {
        return new PageReference('/' + campaignId);
    }
    
    public PageReference convertToLead() {
    	List<Lead__c> leadList = new List<Lead__c>();
    	for(CampaignMemberInfo campaignMemberObj : campaignMembers) {
    		if(campaignMemberObj.isSelected) {
    			if(objectAPIName == 'Campaign') {
    				leadList.add(setLeadRecordFields(campaignId, campaignMemberObj.campaignMember.Campaign_ID__r.OwnerId));
    			} else if(objectAPIName == 'Retail_Campaign__c') {
    				leadList.add(setLeadRecordFields(campaignId, campaignMemberObj.campaignMember.Retail_Campaign_Id__r.OwnerId));
    			}
    		}
    	}
    	
    	if(leadList.size() > 0) {
    		insert leadList;
    		insertCampaignLeadRecords(leadList);
    	}
    	return new PageReference('/' + campaignId);
    }
    
    private Lead__c setLeadRecordFields(String campaignId, Id ownerId) {
    	Lead__c leadRec = new Lead__c(RecordTypeId = leadRTId);
    	leadRec.CAC_Lead_Status__c = 'New';
    	if(objectAPIName == 'Campaign') {
		    leadRec.Source_Campaign__c = campaignId;
    	} else if(objectAPIName == 'Retail_Campaign__c') {
		    leadRec.Retail_Campaign_Name__c = campaignId;
    	} 
	    leadRec.OwnerId = ownerId;
	    if(leadRTId != null) {
	        leadRec.RecordTypeId = leadRTId;
	    }
    	return leadRec;
    }
    
    private void insertCampaignLeadRecords(List<Lead__c> leadList) {
    	List<Campaign_Lead__c> cLeadList = new List<Campaign_Lead__c>();
    	for(Lead__c leadRec : leadList){
	    	Campaign_Lead__c cLeadRec = new Campaign_Lead__c(); 
      		cLeadRec.Lead__c = leadRec.id;
      		if(objectAPIName == 'Campaign') {
			    cLeadRec.Campaign__c = leadRec.Source_Campaign__c;
	    	} else if(objectAPIName == 'Retail_Campaign__c') {
			    cLeadRec.Retail_Campaign__c = leadRec.Retail_Campaign_Name__c;
	    	} 
	      	cLeadList.add(cLeadRec);
	  	}
	  	if(cLeadList.size() > 0) {
	  		insert cLeadList;
	  	}
    }
}