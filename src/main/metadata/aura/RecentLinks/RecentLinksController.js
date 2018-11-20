({
    doInit : function(component, event, helper) {
        var action = component.get("c.getRecentLinks");       
		action.setCallback(this, function(response){
            var state = response.getState();	
            if (state === "SUCCESS") {           
            	component.set("v.Link", response.getReturnValue());
            }
            else {
                component.set("v.message", 'An Error Occured. Kindly refresh or contact your Salesforce administrator.');
            }
        });
        $A.enqueueAction(action);
    }
})