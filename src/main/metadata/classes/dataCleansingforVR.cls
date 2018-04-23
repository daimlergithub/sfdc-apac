global class dataCleansingforVR implements Database.Batchable<SObject> {
    String market=System.Label.MarketMY;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return DataBase.getQueryLocator('Select id from Vehicle__c where MD__c = \'MY\' and market__c  = \'MY\'');
    }
    
    global void execute(Database.BatchableContext bc, List<Vehicle__c> scope) {
       Map<String, Vehicle_relationship__c> mLatestRTCopyVR = new Map<String, Vehicle_relationship__c>();
        List<Vehicle_relationship__c> lWSCopyVR = new List<Vehicle_relationship__c>();
        List<Vehicle_relationship__c> lVRtoUpd = new List<Vehicle_relationship__c>();
        for(Vehicle_relationship__c vr : [Select id, start_date__c, Registration_number__c,Registration_Date__c,car_Relation__c, Owner_Dealer__c, Contact__c, Vehicle_ID__c from vehicle_relationship__c where Vehicle_ID__c IN :scope and MD__c='MY']){
            if(!mLatestRTCopyVR.containsKey(vr.Vehicle_ID__c+'_'+vr.Car_Relation__c) || (mLatestRTCopyVR.containsKey(vr.Vehicle_ID__c+'_'+vr.Car_Relation__c) && mLatestRTCopyVR.get(vr.Vehicle_ID__c+'_'+vr.Car_Relation__c).start_date__c < vr.start_date__c)){
                mLatestRTCopyVR.put(vr.Vehicle_ID__c+'_'+vr.Car_Relation__c, vr);
            }
        }

        if(!mLatestRTCopyVR.isEmpty()){
            for(String str : mLatestRTCopyVR.keySet()){
                List<String> key = String.isNotBlank(str) ? str.split('_') : NULL;
                if((str.contains('Purchaser') || str.contains('Sales Contact target 1')) && mLatestRTCopyVR.containsKey(key[0]+'_Sales')){
                    mLatestRTCopyVR.get(str).Selling_Dealer__c = mLatestRTCopyVR.get(key[0]+'_Sales').Owner_Dealer__c;
                    mLatestRTCopyVR.get(str).Contact__c = mLatestRTCopyVR.get(key[0]+'_Sales').Contact__c;
					mLatestRTCopyVR.get(str).start_date__c = mLatestRTCopyVR.get(key[0]+'_Sales').start_date__c;
					mLatestRTCopyVR.get(str).Registration_number__c = mLatestRTCopyVR.get(key[0]+'_Sales').Registration_number__c;
					mLatestRTCopyVR.get(str).Registration_Date__c = mLatestRTCopyVR.get(key[0]+'_Sales').Registration_Date__c;
                }
                else if(str.contains('Aftersales Contact Target 1') && mLatestRTCopyVR.containsKey(key[0]+'_Aftersales')){
                    mLatestRTCopyVR.get(str).Selling_Dealer__c = mLatestRTCopyVR.get(key[0]+'_Aftersales').Owner_Dealer__c;
                    mLatestRTCopyVR.get(str).Contact__c = mLatestRTCopyVR.get(key[0]+'_Aftersales').Contact__c;
					mLatestRTCopyVR.get(str).start_date__c = mLatestRTCopyVR.get(key[0]+'_Sales').start_date__c;
					mLatestRTCopyVR.get(str).Registration_number__c = mLatestRTCopyVR.get(key[0]+'_Sales').Registration_number__c;
					mLatestRTCopyVR.get(str).Registration_Date__c = mLatestRTCopyVR.get(key[0]+'_Sales').Registration_Date__c;
                }   
            }
            try{
                database.update (mLatestRTCopyVR.values(),false);
            }catch(Exception e){
                System.debug('Failed while updating the VRs in a batch process' +e.getMessage());
            }
        } 
    }
    
    global void finish(Database.BatchableContext bc) {
    
    }
}