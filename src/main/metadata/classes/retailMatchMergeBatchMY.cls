global class retailMatchMergeBatchMY implements Database.Batchable<sObject>, Database.Stateful {
    private Integer currentBatchChain;
    public String market;
    public List<Id> userIdLst = new List<ID>();
    global retailMatchMergeBatchMY(String Market) {
        currentBatchChain = 1;
        this.market = Market;
    }

    global retailMatchMergeBatchMY(Integer chain, String Market) {
        this.market = Market;
        currentBatchChain = chain;
        if(currentBatchChain == 3){
          for(User usr:[Select Id,contact.account.Dealer_Nd_code__c from User where contact.account.Dealer_Nd_code__c!=NULL and Market__c = :market]){
              userIdLst.add(usr.Id);
             }
        }
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String qry;
        Integer noOfHours;
        datetime myDateTime = datetime.now();
        String dmmStatus = 'Processed';
        DateTimeForShareBatch__c dt = DateTimeForShareBatch__c.getValues('RetailMatchMergeBatchMY');
            if(dt != NULL){
                noOfHours = Integer.valueOf(dt.noOfHours__c) * (-1);
                myDateTime = myDateTime.addHours(noOfHours);
            }
        if (currentBatchChain == 1) {
            System.debug('@@@in currentBatchChain '+currentBatchChain);
            qry = 'Select id,ownerid,owner.name,name,duplicate_customer__c, duplicate_reason__c,EP_Transaction_ID__c,MD__c,Master_Customer__c,Transaction_Date__c,Duplicate_UCID__c,Master_UCID__c,Status__c,Duplicate_Retail_Customer__c,Master_Retail_Customer__c,Duplicate_Retail_Customer__r.RetailDealer_ND_Code__c,Duplicate_Customer__r.owner.Dealer_ND_Code__c,Duplicate_Customer__r.owner.id, Duplicate_Retail_Customer__r.toRole__c,CreatedDate, LastmodifiedDate from Duplicate_Merge_Info__c where md__c=:market and Status__c != :dmmStatus';
            if(noOfHours != NULL){
                qry += ' and SystemModStamp >=:myDateTime';
            }
            System.debug('start in qry1'+qry);
        } 
        else if (currentBatchChain == 2) {
            System.debug('@@@start in currentBatchChain '+currentBatchChain);
            qry = 'Select id from Vehicle__c where MD__c =:market and market__c  =:market';
            System.debug('start in qry2'+qry);
        } 
        else if(currentBatchChain == 3 ){
            System.debug('@@@start in currentBatchChain '+currentBatchChain);
            qry='select Id,Duplicate_Customer__c,Master_Customer__c,status__c,Duplicate_Retail_Customer__c,Master_Retail_Customer__c from Duplicate_Merge_Info__c where md__c=:market and Status__c != :dmmStatus';
            if(noOfHours != NULL){
                qry += ' and SystemModStamp >=:myDateTime';
            }
            System.debug('@@@start in qry3'+qry);
        }
        
        return Database.getQueryLocator(qry);
    }
                
    global void execute(Database.BatchableContext BC, List <sObject> scope) {
        if ( currentBatchChain == 1 )  {
            System.debug('@@@in execute 1');
            Id integrationInfId=[Select id,name from user where name='Integration Inf' limit 1][0].id;
            List<Account_Link__c> aclList=new List<Account_Link__c>();
            List<Account> acList=new List<Account>();
            Set<String> groupName=new Set<String>();
            Map<ID,ID> dgAccMap=new Map<ID,ID>();
            Map<ID,ID> dgAccLinkMap=new Map<ID,ID>();
            List<Account_Link__Share> delAlkShare=new List<Account_Link__Share>();
            List<AccountShare> accsharedelete=new List<AccountShare>();
            List<String> ndCodeList=new List<String>();
            for(Duplicate_Merge_Info__c d: (List<Duplicate_Merge_Info__c>)scope){
                dgAccMap.put(d.Duplicate_Customer__c,d.Master_Customer__c);
                dgAccLinkMap.put(d.Duplicate_Retail_Customer__c,d.Master_Retail_Customer__c);
                String gname=d.MD__c+d.Duplicate_Retail_Customer__r.RetailDealer_ND_Code__c;
                groupName.add(gname); 
                ndCodeList.add(d.Duplicate_Retail_Customer__r.RetailDealer_ND_Code__c);
                if(d.Duplicate_Retail_Customer__c!=Null){
                //duplicate account link owners changed to Integration Inf
                    aclList.add(new Account_Link__c(Id=d.Duplicate_Retail_Customer__c, ownerid=integrationInfId));            
                }
                if(d.Duplicate_Customer__c!=Null){
                //duplicate account owners changed to Integration Inf
                    acList.add(new Account(Id=d.Duplicate_Customer__c, ownerid=integrationInfId));  
                }                     
            }
            
            try{
                if(aclList.size()>0){
                    update aclList;
                }
                if(acList.size()>0){
                    update acList;
                }
            }
            catch(Exception e){}    
            
            //querying Account_Link__Share object which belong to the above group
            if(groupName.size()>0) { 
                delAlkShare=[SELECT Id, ParentId FROM Account_Link__Share WHERE ParentId IN :dgAccLinkMap.keyset()];
            }
            //deleting Account_Link__Share object list
            if(delAlkShare.size()>0){
                Database.delete(delAlkShare, false);
            }
            
            //querying AccountShare object which belong to the Account1 field list
            accsharedelete=[SELECT Id, accountid FROM AccountShare WHERE accountid IN :dgAccMap.keyset()];
            
            //deleting AccountShare object list 
             if(accsharedelete.size()>0){
                     Database.delete(accsharedelete,false);
             }     
        }
              //Condition for obj2 update
       if ( currentBatchChain == 2 ) {
            System.debug('@@@in execute 2');
            Map<String, Vehicle_relationship__c> mLatestRTCopyVR = new Map<String, Vehicle_relationship__c>();
            Map<String, Vehicle_relationship__c> moldRTCopyVR = new Map<String, Vehicle_relationship__c>();
            List<Vehicle_relationship__c> lWSCopyVR = new List<Vehicle_relationship__c>();
            List<Vehicle_relationship__c> lVRtoUpd = new List<Vehicle_relationship__c>();
            Set<String> carRelations = new Set<String>{'sales','aftersales','driver'};
            List<Vehicle__c> vehicleIds=(List<Vehicle__c>)scope;
            String VRFieldsToSync= System.Label.VR_Fields_Sync;
            List<String> lVRFieldsToSync =  String.isNotBlank(VRFieldsToSync) ? VRFieldsToSync.split(',') : NULL;
            String soql1 = 'Select id,' + VRFieldsToSync +  ', start_date__c, end_date__c, car_Relation__c, Contact__c, Vehicle_ID__c from vehicle_relationship__c where Vehicle_ID__c IN :vehicleIds and MD__c=\'MY\' and Car_Relation__c IN :carRelations';
            for(Vehicle_relationship__c vr : Database.query(soql1)){
                if(vr.end_date__c == NULL && vr.start_date__c != NULL)
                mLatestRTCopyVR.put(vr.Vehicle_ID__c+'_'+vr.Contact__c+'_'+vr.Car_Relation__c, vr);
                else if(vr.end_date__c != NULL && vr.start_date__c != NULL)
                moldRTCopyVR.put(vr.Vehicle_ID__c+'_'+vr.Contact__c+'_'+vr.Car_Relation__c, vr);
            }
        
            if(!moldRTCopyVR.isEmpty()){
                List<ID> lVRtoDel = new List<ID>();
                for(String str : moldRTCopyVR.keySet()){
                    if(mLatestRTCopyVR.containsKey(str)){
                        for(String fldName : lVRFieldsToSync){
                            ((Vehicle_relationship__c)moldRTCopyVR.get(str)).put(fldName, ((Vehicle_relationship__c)mLatestRTCopyVR.get(str)).get(fldName));
                        }
                        moldRTCopyVR.get(str).end_date__c = NULL;
                        lVRtoDel.add(mLatestRTCopyVR.get(str).ID);
                    }
                }
                try{
                    database.update (moldRTCopyVR.values(),false);
                    if(!lVRtoDel.isEmpty()){
            Logic_Switch__c ls = Logic_Switch__c.getValues('VRDeletionOperation');
                        if(ls != NULL && ls.execute__c){
                            database.delete (lVRtoDel,false);
                        }
                        else{
                            List<Vehicle_Relationship__c> lVR_to_del_upd = new List<Vehicle_Relationship__c>();
                            for(ID vrid : lVRtoDel){
                                lVR_to_del_upd.add(new vehicle_relationship__c(id = vrid, To_Be_Deleted__c = true));
                            }
                            if(!lVR_to_del_upd.isEmpty()){
                                database.update(lVR_to_del_upd, false);
                            }
                        }
                    }
                }catch(Exception e){
                    System.debug('Failed while updating/deleting the VRs in dataCorrectionforVR batch process' +e.getMessage());
                }
            } 
       }
       if ( currentBatchChain == 3 ){
            System.debug('@@@in execute 3');
            Boolean leadMergeSuccess = false;
            Boolean caseMergeSuccess = false;
            Boolean RTMergeSuccess = false;
            Boolean NotesAndAttachmentSuccess= false; 
            Boolean VRMergeSuccess = false;
            Boolean OpenActivitiesSuccess= false; 
            Map<Id,Id> duplicateCustmrId2MasterCustmerIdMap=new Map<Id,Id>();
            List<Duplicate_Merge_Info__c> dupMergeInfoTobeUpdated=new List<Duplicate_Merge_Info__c>();
            for(Duplicate_Merge_Info__c dupMergeObj:(List<Duplicate_Merge_Info__c>)scope){
                duplicateCustmrId2MasterCustmerIdMap.put(dupMergeObj.Duplicate_Customer__c, dupMergeObj.Master_Customer__c);
                dupMergeObj.Status__c='Processed';
                dupMergeInfoTobeUpdated.add(dupMergeObj);
            }
            
            caseMergeSuccess = sObjectMerge_MY.mergeCase(duplicateCustmrId2MasterCustmerIdMap);
            leadMergeSuccess = sObjectMerge_MY.mergeLead(dupMergeInfoTobeUpdated);
            RTMergeSuccess = sObjectMerge_MY.mergeRetailTask(duplicateCustmrId2MasterCustmerIdMap);
            VRMergeSuccess = sObjectMerge_MY.mergeVR(duplicateCustmrId2MasterCustmerIdMap);
            OpenActivitiesSuccess = sObjectMerge_MY.mergeOpenActivities(duplicateCustmrId2MasterCustmerIdMap);
            NotesAndAttachmentSuccess = sObjectMerge_MY.mergeNotesAndAttachment(duplicateCustmrId2MasterCustmerIdMap);
            if(dupMergeInfoTobeUpdated!=null && dupMergeInfoTobeUpdated.size()>0 && caseMergeSuccess && leadMergeSuccess && RTMergeSuccess && VRMergeSuccess && OpenActivitiesSuccess && NotesAndAttachmentSuccess){
                try{
                    update dupMergeInfoTobeUpdated;
                }catch(Exception e){
                    System.debug('Failed batch process' +e.getMessage());
                }
            }
        }
    }
        
    global void finish(Database.BatchableContext BC) {
        if (currentBatchChain == 1) {
            System.debug('@@@in finish 1');
            retailMatchMergeBatchMY ba1 = new retailMatchMergeBatchMY(currentBatchChain + 1, market);
            Database.executeBatch(ba1);   
        }
        else if (currentBatchChain == 2) {            //will be used for reparenting logic
            System.debug('@@@in finish 2');
            retailMatchMergeBatchMY ba2 = new retailMatchMergeBatchMY(currentBatchChain + 1, market);
            Database.executeBatch(ba2);
        }
        else if (currentBatchChain == 3) {
            System.debug('@@@in finish 3');
            UtilConstant.RETAIL_MATCH_MERGE = true;
            Database.Executebatch(new ShareALLRecordsToNewUserBatch(userIdLst,'Account_Link__c',market),100);
            Database.Executebatch(new ShareALLRecordsToNewUserBatch(userIdLst,'Lead__c',Market),100);
            Database.Executebatch(new ShareALLRecordsToNewUserBatch(userIdLst,'Case',market),100);
            Database.Executebatch(new ShareALLRecordsToNewUserBatch(userIdLst,'Vehicle_Relationship__c',market),100);
            Database.Executebatch(new ShareALLRecordsToNewUserBatch(userIdLst,'User',market),100);
        }
    }
    
}