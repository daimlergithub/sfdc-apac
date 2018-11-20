({
   init: function (cmp, event, helper) {
        var action = cmp.get('c.getVehicleData');
        
        action.setParams({
            customerId:cmp.get("v.recordId")
        });
        
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                cmp.set('v.vehicleList', response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true);
    },
    hideSpinner: function(component, event, helper) {
        component.set("v.Spinner", false);
    }
})