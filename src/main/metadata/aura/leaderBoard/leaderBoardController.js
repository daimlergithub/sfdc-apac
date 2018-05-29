({
    doInit : function(component, event, helper) {
        var action = component.get("c.getReputationPoints");  
        action.setStorable();
        action.setParams({
            'communityName': component.get("v.communityName"),
            'recordCount': component.get("v.recordCount")           
        });
		action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {				
				component.set("v.leaderboard", response.getReturnValue());
            }
         	else {
                component.set("v.message", 'An Error Occured. Kindly refresh or contact your Salesforce administrator.');
            }
        });
        $A.enqueueAction(action);
    }                           
})