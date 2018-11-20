({
	myAction : function(component, event, helper) {
        var action = component.get('c.VRByCustId');
        action.setParams({
            recordId:component.get("v.recordId")
        });
          action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Vehicle",response.getReturnValue());
                console.log(response.getReturnValue());
            }
          });
         $A.enqueueAction(action);
	}
		

})