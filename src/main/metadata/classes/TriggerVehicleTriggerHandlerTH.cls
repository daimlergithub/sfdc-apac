/**************************************************************************************************************************************************
* Class:                            TriggerVehicleTH 
* Description:                      This class will handles the Vehicle helper functionalities
@methods Description            
* handleTrigger                    : will fires when the logged in user profile is not Integration
* --------------------------------------------------------------------------------------------------------------------------------------------------
* Date                              Name                        Modification Description
* Created Date : 2018-6-6    Dhanamjaya D                       Created  

=====================================================================================================================================================*/
public class TriggerVehicleTriggerHandlerTH implements TriggerHandlerIf {

    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
        if(Trigger.isafter&&Trigger.isinsert)
          VehicleHelperTH.shareRecordsWithDealers(Trigger.new);  
    }
    public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
       
    }
}