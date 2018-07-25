public class TriggerOpportunityTriggerHandlerAU implements TriggerHandlerIf
{ 
    OppHelperAU leadRS= new OppHelperAU();  
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {


        if(isInsert && isAfter)
        {
             if(Util_getPermissions.checkCustomPermission(Label.AUGeneric) 
                || Util_getPermissions.checkCustomPermission(Label.NZGeneric))

                leadRS.mapCarModelToOpporutnity((Map<Id,Opportunity>)Trigger.newMap);
        }
    }

    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {

        if(isInsert && isAfter)
          leadRS.mapCarModelToOpporutnity((Map<Id,Opportunity>)Trigger.newMap);
    }    

}