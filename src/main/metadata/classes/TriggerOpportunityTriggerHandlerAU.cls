public class TriggerOpportunityTriggerHandlerAU implements TriggerHandlerIf
{ 
      
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {


    OppHelperAU leadRS= new OppHelperAU();
        if(isInsert && isAfter)
        {
             if(Util_getPermissions.checkCustomPermission(Label.AUGeneric) 
                || Util_getPermissions.checkCustomPermission(Label.NZGeneric))

                leadRS.mapCarModelToOpporutnity((Map<Id,Opportunity>)Trigger.newMap);
        }
    
    //Madhusudhan CS added as per MBANZ-403
        if((isInsert || isUpdate) && isBefore)
        {
            if(isInsert)
      {
                leadRS.beforeInsertOpportunity((list<Opportunity>)Trigger.New,isInsert);
        leadRS.updateOwnerwithDealer(Trigger.new);
                //Harshit added below line
                 leadRS.SetCloseDate(Trigger.new);
      }
      //Madhusudhan CS added as per MBANZ-139
      if(Trigger.isbefore && Trigger.isinsert && INTriggerRecursionCheck.inOppBefIns == false){
             INTriggerRecursionCheck.inOppBefIns = true;
                leadRS.updateOwnerwithDealer(Trigger.new);
      }  
            if(isUpdate)
                leadRS.beforeUpdateOpportunity((list<Opportunity>)Trigger.New,(map<id,Opportunity>)Trigger.OldMap,isUpdate);      
        }      
    //Madhusudhan CS added as per MBANZ-139
    if(Test.isRunningTest())
          INTriggerRecursionCheck.inOppBefIns = false; 
        if(Trigger.isafter && (Trigger.isinsert||Trigger.isUpdate) && INTriggerRecursionCheck.inOppBefIns == false){
                INTriggerRecursionCheck.inOppBefIns = true;          
            leadRS.ShareRecordswithDealers(Trigger.new,Trigger.isupdate); 
            leadRS.CreateRetailCopy(trigger.new, (Map < Id, Opportunity > ) Trigger.OldMap, isInsert, isUpdate,label.AU);            
        }
  
    }
  

    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {

    OppHelperAU leadRS= new OppHelperAU();
        if(isInsert && isAfter)
          leadRS.mapCarModelToOpporutnity((Map<Id,Opportunity>)Trigger.newMap);
    //Madhusudhan CS added as per MBANZ-139
       if(Trigger.isafter && (Trigger.isinsert||Trigger.isUpdate) && INTriggerRecursionCheck.inOppBefIns == false){
                INTriggerRecursionCheck.inOppBefIns = true;          
            leadRS.ShareRecordswithDealers(Trigger.new, Trigger.isupdate);
    }    

}

}
