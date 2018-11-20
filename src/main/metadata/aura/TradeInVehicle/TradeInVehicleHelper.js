({
    retrieveTradeInVehicles:function(component,event,helper) {  
        //debugger;
        if(component.get("v.recId") != null && component.get("v.recId") != "")
        {
            var action = component.get('c.getTradeInVehicleList'); 
            action.setParams({
                'recordId': component.get("v.recId"),
            });
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();	
                if (state === "SUCCESS") {
                    component.set("v.tradeInVehiclesList", response.getReturnValue());
                    var value=component.get("v.tradeInVehiclesList");
                    var len=value.length;
                    if(len>=1){
                        component.set("v.isNewVisible","false");
                    }
                }
                else {
                    component.set("v.message", 'An Error Occured. Kindly refresh or contact your Salesforce administrator.');
                }
            }));
            $A.enqueueAction(action);   
        }
    }, 
    getRecordTypeID : function(component)
    {
        var action = component.get('c.getRecordTypeID'); 
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();	
            if (state === "SUCCESS" && response.getReturnValue() != null) {
                component.set("v.recordTypeId", response.getReturnValue());
            }
            else {
                component.set("v.message", 'An Error Occured. Kindly refresh or contact your Salesforce administrator.');
            }
        }));
        $A.enqueueAction(action);     
    },
    fireSuccessToast : function(component) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ 
            'title' : 'Success', 
            'message' : 'TradeIn updated sucessfully.' ,
            'type':'success'
        }); 
        toastEvent.fire(); 
    },    
    fireFailureToast : function(component) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ 
            'title' : 'Failed', 
            'message' : 'An error occurred. Please contact your administrator.',
            'type':'error'
        }); 
        toastEvent.fire(); 
    },    
    fireRefreshEvt : function(component) {
        var refreshEvent = $A.get("e.force:refreshView");
        if(refreshEvent){
            refreshEvent.fire();
        }
    },   
    saveRecord : function(component,event,helper) {
        var oppId= component.get("v.recId");
        var tiv = component.get("v.tradeInVehiclesList");
        //create new record from Opp detail page:
        debugger;
        if((tiv.length >0) && (tiv[0].Trade_In_Vehicle__c == null || tiv[0].Trade_In_Vehicle__c == "") && (tiv[0].Year_of_Manufacture__c == null || tiv[0].Year_of_Manufacture__c == "") && (tiv[0].Mileage__c == null || tiv[0].Mileage__c == "")  && (tiv[0].Trim__c == null || tiv[0].Trim__c == ""))
        {
              component.set("v.showError",true);              
              component.set("v.message", 'Please add details before submiting record.');
              component.set("v.tradeInVehiclesList",null);
        }
        else{
         component.set("v.isOpen",false);    
         component.set("v.isNewVisible",false);
         component.set("v.showError",false);      
         if(oppId != null)
        {
         var updateTradeIn = component.get("c.saveTradeInList");
         var vehstr = JSON.stringify(tiv);
         debugger;   
         updateTradeIn.setParams({
             "leadList": vehstr,
             "RelatedOpptyId" : oppId
         });
         updateTradeIn.setCallback(this, function(response){
             var state = response.getState();
             if (state === "SUCCESS") {           
                 helper.fireSuccessToast(component);  
                 helper.fireRefreshEvt(component);
             }
             else if (state === "ERROR") {
                 var errors = response.getError();
                 console.error(errors);
                 helper.fireFailureToast(component); 
             }
             
         });
         $A.enqueueAction(updateTradeIn);
         helper.retrieveTradeInVehicles(component,event,helper);
        }
       }      
    },   
})