public virtual class SharingDataHandlerBase{

    String AccessLevel = 'Read';
    protected CMap parentIds = new CMap();
    protected CMap userOrGroupIds = new CMap();
    String shareObjName = 'parentId';
    Schema.SObjectType  shareType;
        
    public SharingDataHandlerBase(String originalTypeName, String AccessLevel){

        if (AccessLevel=='Edit'||AccessLevel=='All') {
            this.AccessLevel = AccessLevel;
        }
        
        String dispatcherTypeName = '';
        if (originalTypeName.toLowerCase().endsWith('__c')) {
            Integer index = originalTypeName.toLowerCase().indexOf('__c') + 2;
            dispatcherTypeName = originalTypeName.substring(0, index) + 'Share';
        } else {
            dispatcherTypeName = originalTypeName + 'Share';
            shareObjName = originalTypeName + 'Id';
        }
       
        shareType =  Schema.getGlobalDescribe().get(dispatcherTypeName);
        
    }

    /**
     * make a dms & account map
     */
    public CMap filterDealer(List<sObject> scope){
        CMap dmsAndAccount = new CMap();
        for(sObject sa : scope){
            Account a = (Account)sa;
            dmsAndAccount.add(a.Dealer_DMS_CRM_Code__c, a.Id);
        }
        return dmsAndAccount;       
    }

    public virtual void executeProcessByCRMCode(List<sObject> crmCodeList){
    }
    
    /**
     *  Create a share record of object
     */
    public sObject createShareObject(id parentId, id UserOrGroupId){

        sObject shareObj = shareType.newSObject();

        shareObj.put(shareObjName, parentId);
        shareObj.put('UserOrGroupId', UserOrGroupId);
        if(shareObjName.indexOf('Account')>=0){
            shareObj.put('AccountAccessLevel', this.AccessLevel);
            shareObj.put('OpportunityAccessLevel', this.AccessLevel);
        }else{
            shareObj.put('AccessLevel', this.AccessLevel);
        }
        //shareObj.put('RowCause', parentId);
        
        return shareObj;
    }

    //using sharing object and to be shared people make sharing record
    public List<sObject> makeInserRecords(CMap pIds, CMap uogIds){

        List<sObject> shareRecs = new List<sObject>();
        if (pIds != null)
        for(String crmCode: pIds.keySet()){
            for(Id pId : pIds.get(crmCode)){
                for(Id uogId : uogIds.get(crmCode)){
                    shareRecs.add(createShareObject(pId,uogId));
                }           
            }
        }
        system.debug('shareRecs:'+shareRecs);
        return shareRecs;
    }

}