/*
    Type:       Trigger
    Purpose:    1. Create Task when campaign dealer is changed
                2. A dealer couldn't create upto 3 candidates.
                3. BP number limit
    User Story: Retail Campaign
    Used By:    
    ---------------------------------------------------------------
    History:
    
    27-May-2014 Barney Lai    Created
    19-June-2014 Sinow   Updated
    3rd-July-2014 CC    Updated
    7th-July-2014 CC    Updated, moved region and sub region logic to ShareRecordToDealer.trigger.
    11-Nov-2014   zhongyang.si update, assign the delear as owner to the approver for the aftersales yearly TA for Release 1.3
*/
trigger TriggerBeforeRetailCampaign on Retail_Campaign__c (before insert, before update) {
    if (!UtilCustomSettings.isEnabled('TriggerBeforeRetailCampaign')) {
        return;
    }
    
    List<Retail_Campaign__c> preRetailCampaign = new List<Retail_Campaign__c>();
    Map<Id, Id> RCIdDealerId = new Map<Id, Id>();
    Map<Id, Account> DealerIDAccount = new Map<Id, Account>();
    Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName();
    List<Retail_Campaign__Share> deleteCsList = new List<Retail_Campaign__Share>();
    
    Set<Id> dealerIds = new Set<Id>();
    Map<String, set<Id>> existDealerIdCampaignIds = new Map<String, set<Id>>();
    Set<Id> parentBPCampaigns = new Set<Id>();
    Map<String, Integer> parCampaignRetailCamNums = new Map<String, Integer>();
    Map<String, Integer> parCampaignBPNumbers = new Map<String, Integer>();
    Map<String, Integer> parCampaignRecommendCamNums = new Map<String, Integer>();
    Map<String, Integer> parCampaignRecommendBPNumbers = new Map<String, Integer>();
    Map<String, Integer> parentCamHasFinalBest = new Map<String, Integer>();
    Map<String, Integer> parentCamHasFinalBestForSmart = new Map<String, Integer>();

    //add the business logic to assign the delear as owner to the approver for the aftersales yearly TA for Release 1.3, zhongyang.si begin
    List<Retail_Campaign__c> asYearlyTAList = new List<Retail_Campaign__c>();
    Set<ID> dealerASID = new Set<ID>();
    Map<ID,Account> dealerAS = new Map<ID,Account>();
    for(Retail_Campaign__c rc : trigger.new) {
        if(rc.Y_Dealer_Name__c != null && rc.RecordTypeId == cpRecordTypeMap.get('Aftersales Yearly TA').getRecordTypeId()) {
            asYearlyTAList.add(rc);
            dealerASID.add(rc.Y_Dealer_Name__c);
        }
    }
    if(dealerASID.size() > 0) {
        for(Account a : [SELECT id, Ownerid, Retail_AS_Owner__c FROM Account WHERE id in :dealerASID]) {
            dealerAS.put(a.id, a);
        }
    }
    for(Retail_Campaign__c rc : asYearlyTAList) {
        if(dealerAS.keyset().contains(rc.Y_Dealer_Name__c)) {
            if ( dealerAS.get(rc.Y_Dealer_Name__c).Retail_AS_Owner__c != null ){
                rc.Approver__c = dealerAS.get(rc.Y_Dealer_Name__c).Retail_AS_Owner__c;
            } else {
                rc.Approver__c = dealerAS.get(rc.Y_Dealer_Name__c).ownerid;
            }
        }
    }
    //add the business logic to assign the delear as owner to the approver for the aftersales yearly TA for Release 1.3, zhongyang.si end

    for(Retail_Campaign__c rc : trigger.new) {
        if(trigger.isinsert) {
            if(rc.Dealer_Name__c != null) {
                preRetailCampaign.add(rc);
                RCIdDealerId.put(rc.id, rc.Dealer_Name__c);
            }
            
            //Generation function, by sinow Release 1.2
            if((rc.RecordTypeId == cpRecordTypeMap.get('Retail MB Best Practice').getRecordTypeId()
               || rc.RecordTypeId == cpRecordTypeMap.get('Retail smart Best Practice').getRecordTypeId()) && rc.Y_Dealer_Name__c != null) {
                dealerIds.add(rc.Y_Dealer_Name__c); 
            }
        }
        if(trigger.isupdate) {
            preRetailCampaign.add(rc);
            if(rc.Dealer_Name__c != null && rc.Dealer_Name__c != Trigger.oldMap.get(rc.Id).Dealer_Name__c) {
                RCIdDealerId.put(rc.id, rc.Dealer_Name__c);
            }
            if(rc.Y_Status__c == 'Confirmed' &&
            (cpRecordTypeMap.get('Sales & Marketing Yearly TA').getRecordTypeId()== rc.RecordTypeId 
            || cpRecordTypeMap.get('Aftersales Yearly TA').getRecordTypeId()== rc.RecordTypeId)){
                rc.OwnerId = userinfo.getUserId();
            }
            
            if((rc.Region_Best_Practice__c && ! Trigger.oldMap.get(rc.Id).Region_Best_Practice__c) ||
               (rc.Region_Recommendation__c && ! Trigger.oldMap.get(rc.Id).Region_Recommendation__c) ||
               (rc.Final_Best_Practice__c && ! Trigger.oldMap.get(rc.Id).Final_Best_Practice__c) ||
               (rc.Final_Best_Practice_Forsmart__c && ! Trigger.oldMap.get(rc.Id).Final_Best_Practice_Forsmart__c)) {
                parentBPCampaigns.add(rc.Parent_Campaign__c);
            }
        }
    }
    
    if(RCIdDealerId.values().size() > 0) {
        for(Account a : [select id, Dealer_Region__c, Dealer_MB_Sub_Region__c, Retail_AMG_Owner__c, Ownerid, Retail_AS_Owner__c, Retail_Star_Elite_Owner__c, Retail_MB_Owner__c, Retail_smart_Owner__c from Account where id in :RCIdDealerId.values()]) {
            DealerIDAccount.put(a.id, a);
        }
    }
    
    if(dealerIds.size() > 0) {
        for(Retail_Campaign__c rcm : [select Y_Dealer_Name__c, Retail_Candidate__c, Parent_Campaign__c, Brand__c from Retail_Campaign__c where Y_Dealer_Name__c in :dealerIds]) {
            if(!existDealerIdCampaignIds.containsKey(rcm.Brand__c + rcm.Y_Dealer_Name__c + rcm.Parent_Campaign__c)) {
                existDealerIdCampaignIds.put(rcm.Brand__c + rcm.Y_Dealer_Name__c + rcm.Parent_Campaign__c, new set<Id>());
            }
            existDealerIdCampaignIds.get(rcm.Brand__c + rcm.Y_Dealer_Name__c + rcm.Parent_Campaign__c).add(rcm.Retail_Candidate__c);
        }
    }
    
    if(parentBPCampaigns.size() > 0) {
         AggregateResult[] groupedResults = [SELECT count(Id), Parent_Campaign__c FROM Retail_Campaign__c where Parent_Campaign__c in :parentBPCampaigns and Region_Best_Practice__c = true GROUP BY Parent_Campaign__c]; 
         for(AggregateResult ar : groupedResults) {
             parCampaignRetailCamNums.put(String.valueOf(ar.get('Parent_Campaign__c')), Integer.valueOf(ar.get('expr0'))); 
         }
         
         groupedResults = [SELECT count(Id), Parent_Campaign__c FROM Retail_Campaign__c where Parent_Campaign__c in :parentBPCampaigns and Region_Recommendation__c = true GROUP BY Parent_Campaign__c]; 
         for(AggregateResult ar : groupedResults) {
             parCampaignRecommendCamNums.put(String.valueOf(ar.get('Parent_Campaign__c')), Integer.valueOf(ar.get('expr0')));
         }
         
         groupedResults = [SELECT count(Id), Parent_Campaign__c FROM Retail_Campaign__c where Parent_Campaign__c in :parentBPCampaigns and Final_Best_Practice__c = true GROUP BY Parent_Campaign__c]; 
         for(AggregateResult ar : groupedResults) {
             parentCamHasFinalBest.put(String.valueOf(ar.get('Parent_Campaign__c')), Integer.valueOf(ar.get('expr0')));
         }
         
         groupedResults = [SELECT count(Id), Parent_Campaign__c FROM Retail_Campaign__c where Parent_Campaign__c in :parentBPCampaigns and Final_Best_Practice_Forsmart__c = true GROUP BY Parent_Campaign__c]; 
         for(AggregateResult ar : groupedResults) {
             parentCamHasFinalBestForSmart.put(String.valueOf(ar.get('Parent_Campaign__c')), Integer.valueOf(ar.get('expr0')));
         }
         
         for(Campaign cam : [select Id, Region_Best_Number__c, Region_Recommend_Number__c from Campaign where Id in :parentBPCampaigns and Region_Best_Number__c >= 0]) {
             parCampaignBPNumbers.put(cam.Id, Integer.valueOf(cam.Region_Best_Number__c));
             parCampaignRecommendBPNumbers.put(cam.Id, Integer.valueOf(cam.Region_Recommend_Number__c));
         }
    }
    
    for(Retail_Campaign__c rc : preRetailCampaign) {
        if(cpRecordTypeMap.get('S&M Event Retail Campaign').getRecordTypeId()== rc.RecordTypeId 
        || cpRecordTypeMap.get('S&M Media Retail Campaign').getRecordTypeId()== rc.RecordTypeId
        || cpRecordTypeMap.get('AS Retail Campaign').getRecordTypeId()== rc.RecordTypeId){
            if(RCIdDealerId.keyset().contains(rc.id) && DealerIDAccount.keyset().contains(RCIdDealerId.get(rc.id))) {
                rc.Dealer_Region__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Dealer_Region__c;
                rc.Dealer_Sub_Region__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Dealer_MB_Sub_Region__c;
                if(cpRecordTypeMap.get('AS Retail Campaign').getRecordTypeId()== rc.RecordTypeId ){
                    rc.Approver__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Retail_AS_Owner__c;
                }else if(rc.Brand__c == 'MB'){
                    rc.Approver__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Retail_MB_Owner__c;
                }else if (rc.Brand__c == 'smart'){
                    rc.Approver__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Retail_smart_Owner__c;
                }else if (rc.Brand__c == 'AMG'){
                    rc.Approver__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Retail_AMG_Owner__c;
                }else if (rc.Brand__c == 'StarElite'){
                    rc.Approver__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Retail_Star_Elite_Owner__c;
                }
            }
            if(rc.Approver__c == null && DealerIDAccount.containsKey(RCIdDealerId.get(rc.id))){
               rc.Approver__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Ownerid;
            }
        }
        
        // Set the region and sub region for Yearly TA
        if(cpRecordTypeMap.get('Aftersales Yearly TA').getRecordTypeId() == rc.RecordTypeId ||
           rc.RecordTypeId == cpRecordTypeMap.get('Retail smart Best Practice').getRecordTypeId() ||
           rc.RecordTypeId == cpRecordTypeMap.get('Retail MB Best Practice').getRecordTypeId()) {
            if(RCIdDealerId.keyset().contains(rc.id) && DealerIDAccount.keyset().contains(RCIdDealerId.get(rc.id))) {
                rc.Dealer_Region__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Dealer_Region__c;
                rc.Dealer_Sub_Region__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Dealer_MB_Sub_Region__c;
            }
        }
        
        if(trigger.isupdate && rc.Region_Recommendation__c && !Trigger.oldMap.get(rc.Id).Region_Recommendation__c) {
            if(rc.RecordTypeId == cpRecordTypeMap.get('Retail MB Best Practice').getRecordTypeId()) {
                if(parCampaignRecommendBPNumbers.containsKey(rc.Parent_Campaign__c) && parCampaignRecommendCamNums.containsKey(rc.Parent_Campaign__c)) {
                    if(parCampaignRecommendCamNums.get(rc.Parent_Campaign__c) >= parCampaignRecommendBPNumbers.get(rc.Parent_Campaign__c)) {
                        rc.addError('You can not choose any more Region Recommendation.');
                    }
                }
            }
            if(rc.RecordTypeId == cpRecordTypeMap.get('Retail smart Best Practice').getRecordTypeId()) {
                if(parCampaignRecommendCamNums.containsKey(rc.Parent_Campaign__c) && parCampaignRecommendCamNums.get(rc.Parent_Campaign__c) >= 2) {
                    rc.addError('You can not choose any more Region Recommendation.'); 
                }
            } 
        }
        
        if(trigger.isupdate && rc.Final_Best_Practice__c && !Trigger.oldMap.get(rc.Id).Final_Best_Practice__c 
        && parentCamHasFinalBest.containsKey(rc.Parent_Campaign__c) && parentCamHasFinalBest.get(rc.Parent_Campaign__c) > 1) {
            rc.addError('You can not choose any more Final Best Practice.');  
        }
        
        if(trigger.isupdate && rc.Final_Best_Practice_Forsmart__c && !Trigger.oldMap.get(rc.Id).Final_Best_Practice_Forsmart__c 
        && parentCamHasFinalBestForSmart.containsKey(rc.Parent_Campaign__c) && parentCamHasFinalBestForSmart.get(rc.Parent_Campaign__c) > 1) {
            rc.addError('You can not choose any more Final Best Practice.');  
        }
        
        if(trigger.isupdate && rc.Region_Best_Practice__c && !Trigger.oldMap.get(rc.Id).Region_Best_Practice__c) {
            if(rc.RecordTypeId == cpRecordTypeMap.get('Retail MB Best Practice').getRecordTypeId()) {
                if(parCampaignBPNumbers.containsKey(rc.Parent_Campaign__c) && parCampaignRetailCamNums.containsKey(rc.Parent_Campaign__c)) {
                    if(parCampaignRetailCamNums.get(rc.Parent_Campaign__c) >= parCampaignBPNumbers.get(rc.Parent_Campaign__c)) {
                        rc.addError('You can not choose any more Retail best Practice.');
                    }
                }
            }
            if(rc.RecordTypeId == cpRecordTypeMap.get('Retail smart Best Practice').getRecordTypeId()) {
                if(parCampaignRetailCamNums.containsKey(rc.Parent_Campaign__c) && parCampaignRetailCamNums.get(rc.Parent_Campaign__c) >= 2) {
                    rc.addError('You can not choose any more Retail best Practice.'); 
                }
            }
        }
    }
    
    if(trigger.isInsert){
        for(Retail_Campaign__c cp: trigger.new){
            if(cpRecordTypeMap.get('Aftersales Yearly TA').getRecordTypeId() == cp.RecordTypeId 
              || cpRecordTypeMap.get('Sales & Marketing Yearly TA').getRecordTypeId() == cp.RecordTypeId){
                  if(cp.Y_Status__c == null){
                      cp.Y_Status__c = 'Planned';
                  }
            }
            
            if((cp.RecordTypeId == cpRecordTypeMap.get('Retail MB Best Practice').getRecordTypeId()
               || cp.RecordTypeId == cpRecordTypeMap.get('Retail smart Best Practice').getRecordTypeId()) && cp.Y_Dealer_Name__c != null) {
                if(existDealerIdCampaignIds.containsKey(cp.Brand__c + cp.Y_Dealer_Name__c + cp.Parent_Campaign__c) && existDealerIdCampaignIds.get(cp.Brand__c + cp.Y_Dealer_Name__c + cp.Parent_Campaign__c).size() >= 3) {
                    if(UserInfo.getLanguage() != 'English') {
                    cp.addError('您最多可以创建超过3个候选市场活动, 请重新检查.');
                    }
                    else {
                        cp.addError('You only can create up to 3 retail candidates, Please try again.');
                    }
                }
            }
        }
    }
}