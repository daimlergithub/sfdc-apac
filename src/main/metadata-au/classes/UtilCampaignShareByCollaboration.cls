/*
    Type:       Apex Class
    Purpose:    Define methods used in trigger.CampaignShareByCollaboration
    User Story: US-Cpn-006
    Used By:    CampaignShareByCollaboration.trigger
    ---------------------------------------------------------------
    History:
    
	25-Mar-2013 Jorry Chen (Breakingpoint)    Created
*/

public class UtilCampaignShareByCollaboration {
	// insert campaign sharing records
    public static void shareToUserInsert(List<Collaboration_Team__c> ctList) {
    	Savepoint sp = Database.setSavepoint();
    	List<CampaignShare> csList = new List<CampaignShare>();
    	try{
    		if(ctList.size() > 0) {
    			for(Collaboration_Team__c ct : ctList) {
    				csList.add(new CampaignShare(CampaignId = ct.Campaign__c,
    												UserOrGroupId = ct.Member_Name__c, 
    												CampaignAccessLevel = (ct.Access_Type__c == 'Read Only' ? 'Read' : 'Edit')));
    			}
    		
			if(csList.size() > 0) Database.SaveResult[] lsr = Database.insert(csList,false);
    			
	        // Process the save results
    		}
    	} catch(exception ex) {
    		Database.rollback(sp);
    		System.debug('share Campaign failed : ' + ex);
    	}
    }
    
    // update campaign sharing records
    public static void shareToUserUpdate(List<Collaboration_Team__c> ctList) {
    	Savepoint sp = Database.setSavepoint();
    	List<CampaignShare> csList = new List<CampaignShare>();
    	List<ID> userIdList = new List<ID>();
    	List<ID> cpIdList = new List<ID>();
    	try{
    		if(ctList.size() > 0) {
    			for(Collaboration_Team__c ct : ctList) {
    				userIdList.add(ct.Member_Name__c);
    				cpIdList.add(ct.Campaign__c);
    			}
    			
    			csList = [select Id, UserOrGroupId, CampaignId, CampaignAccessLevel, RowCause from CampaignShare
    						where CampaignId in :cpIdList and UserOrGroupId in :userIdList];
    			
    			for(Integer i = 0; i < ctList.size(); i++) {
    				for(Integer j = 0; j < csList.size(); j++) {
    					if(csList[j].UserOrGroupId == ctList[i].Member_Name__c) {
    						String strAccessLevel = ctList[i].Access_Type__c == 'Read Only' ? 'Read' : 'Edit';
    						if(strAccessLevel <> csList[j].CampaignAccessLevel && csList[j].RowCause <> 'Owner') {
    							csList[j].CampaignAccessLevel = strAccessLevel;
    							break;
    						} else {
    							csList.remove(j);
    							j--;
    							break;
    						}
    					}
    				}
    			}
    			
    			if(csList.size() > 0) Database.SaveResult[] lsr = Database.update(csList,false);
    		}
    	} catch(exception ex) {
    		Database.rollback(sp);
    		System.debug('share Campaign failed : ' + ex);    		
    	}
    }
    
    // delete campaign sharing records
    public static void shareToUserDelete(List<Collaboration_Team__c> ctList) {
    	Savepoint sp = Database.setSavepoint();
    	List<CampaignShare> csList = new List<CampaignShare>();
    	List<CampaignShare> csDelList = new List<CampaignShare>();
    	List<ID> userIdList = new List<ID>();
    	List<ID> cpIdList = new List<ID>();
    	try{
    		if(ctList.size() > 0) {
    			for(Collaboration_Team__c ct : ctList) {
    				userIdList.add(ct.Member_Name__c);
    				cpIdList.add(ct.Campaign__c);
    			}
    			
    			csList = [select Id, UserOrGroupId, CampaignId, CampaignAccessLevel, RowCause from CampaignShare
    						where CampaignId in :cpIdList and UserOrGroupId in :userIdList];
    			
    			for(Integer i = 0; i < ctList.size(); i++) {
    				for(Integer j = 0; j < csList.size(); j++) {
    					if(csList[j].UserOrGroupId == ctList[i].Member_Name__c && (csList[j].RowCause <> 'Owner' || csList[j].RowCause <> 'Administrator')) {
							csDelList.add(csList[j]);
							break;
    					}
    				}
    			}
    			
    			if(csDelList.size() > 0) Database.DeleteResult[] lsr = Database.delete(csDelList,false);
    		}
    	} catch(exception ex) {
    		Database.rollback(sp);
    		System.debug('share Campaign failed : ' + ex);    		
    	}
    }
    
    //Existing au finctionality starts here
    public static void au_After_Insert_Update_Delete_Events(list<Collaboration_Team__c> listCTNew,list<Collaboration_Team__c> listCTOld,map<id,Collaboration_Team__c> ctOldMap,boolean isInsert,boolean isUpdate,boolean isDelete)
	{
		//List all CollaborationTeams for insert
	    List<Collaboration_Team__c> newCollaborationTeams = new List<Collaboration_Team__c>();
	    //List all CollaborationTeams for update
	    List<Collaboration_Team__c> updatedCollaborationTeams = new List<Collaboration_Team__c>();
	    //List all CollaborationTeams for delete
	    List<Collaboration_Team__c> deletedCollaborationTeams = new List<Collaboration_Team__c>();
	
	    if(isInsert || isUpdate) {
	        for(Collaboration_Team__c cbteam : listCTNew) {
	            if(isInsert) {
	                newCollaborationTeams.add(cbteam);
	            }
	            
	            if(isUpdate &&
	                ((cbteam.Member_Name__c != ctOldMap.get(cbteam.Id).Member_Name__c)
	                || (cbteam.Access_Type__c != ctOldMap.get(cbteam.Id).Access_Type__c))){
	                updatedCollaborationTeams.add(cbteam);
	            }
	        }
	    }
	    
	    if(isDelete) {
	        for(Collaboration_Team__c cbt : listCTOld) {
	            deletedCollaborationTeams.add(cbt);
	        }
	    }
	    
	    if(newCollaborationTeams.size() > 0) {
	        insertCampaignSharing(newCollaborationTeams);
	    }
	    
	    if(updatedCollaborationTeams.size() > 0) {
	        updateCampaignSharing(updatedCollaborationTeams);
	    }
	    
	    if(deletedCollaborationTeams.size() > 0) {
	        deleteCampaignSharing(deletedCollaborationTeams);
	    }
	}
	
	// Insert CampaignShare records
    public static void insertCampaignSharing(List<Collaboration_Team__c> collaborationTeams) {
        //List all CollaborationTeams for insert
        List<CampaignShare> campaignShareToInsert = cbTeamsToCampaignShares(collaborationTeams);
        
        if(campaignShareToInsert.size() > 0) {
            DBUtil.insertSobjects(campaignShareToInsert);
        }
    }
    
    // Update CampaignShare records
    public static void updateCampaignSharing(List<Collaboration_Team__c> collaborationTeams) {

        //List all CollaborationTeams for insert
        List<CampaignShare> campaignShareToInsert = cbTeamsToCampaignShares(collaborationTeams);
        
        if(campaignShareToInsert.size() > 0) {
            deleteCampaignSharing(collaborationTeams);
            DBUtil.insertSobjects(campaignShareToInsert);
        }
    }

    // Delete CampaignShare records
    public static void deleteCampaignSharing(List<Collaboration_Team__c> collaborationTeams) {
    
        //List all CollaborationTeams for delete
        List<CampaignShare> campaignShareToDelete = new List<CampaignShare>();
        // Get all Campaign ids for update CampaignShare
        Set<Id> campaignIds = new Set<Id>();
        // Get all User ids for update CampaignShare
        Set<Id> userIds = new Set<Id>();
        
        for(Collaboration_Team__c cbteam : collaborationTeams) {
            campaignIds.add(cbteam.Campaign__c);
            userIds.add(cbteam.Member_Name__c);
        }
        
        List<CampaignShare> campaignShareToUpdateTmp = 
                [select Id, CampaignId, UserOrGroupId from CampaignShare 
                    where CampaignId in :campaignIds and UserOrGroupId in :userIds];
                    
        for(Collaboration_Team__c cbteam : collaborationTeams) {
            for(CampaignShare cs : campaignShareToUpdateTmp) {
                if(cbteam.Campaign__c == cs.CampaignId && cbteam.Member_Name__c == cs.UserOrGroupId){
                    campaignShareToDelete.add(cs);
                }
            }
        }
        
        if(campaignShareToDelete.size() > 0) {
            DBUtil.deleteSobjects(campaignShareToDelete);
        }
    }

    private static List<CampaignShare> cbTeamsToCampaignShares(List<Collaboration_Team__c> collaborationTeams) {
        List<CampaignShare> campaignShares = new List<CampaignShare>();
        
        Set<ID> campaignOwnerid = new Set<ID>();
        Set<ID> ctCampaignid = new Set<ID>();
        List<Campaign> campaigns = new List<Campaign>();
        for(Collaboration_Team__c ct : collaborationTeams) {
            ctCampaignid.add(ct.Campaign__c);
        }
        campaigns = [select id, ownerid from Campaign where id in :ctCampaignid];
        for(Campaign c : campaigns) {
            campaignOwnerid.add(c.ownerid);
        }
        
        String campaignAccessLevel = 'Read';
        
        for(Collaboration_Team__c cbteam : collaborationTeams) {
            if(cbteam.Access_Type__c.equals('Read/Write')){
                campaignAccessLevel = 'Edit';
            }else{
                campaignAccessLevel = 'Read';
            }
            if(!campaignOwnerid.contains(cbteam.Member_Name__c)) {
                campaignShares.add(
                    new CampaignShare(CampaignId = cbteam.Campaign__c, 
                                  CampaignAccessLevel = campaignAccessLevel, 
                                  UserOrGroupId = cbteam.Member_Name__c));
            }
        }
        return campaignShares;
    }
    //existing au functionality ends here
}