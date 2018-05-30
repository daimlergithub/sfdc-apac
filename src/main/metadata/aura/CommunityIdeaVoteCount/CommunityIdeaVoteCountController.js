({
    doInit : function(component, event, helper) {
        var action = component.get("c.getIdeaCount");
        action.setParams({
            ideaID: component.get("v.recordId")           
        });
        action.setCallback(this, function(response){          
            var state = response.getState();        	
            if (state === "SUCCESS") {  
                component.set('v.numberOfVotes', response.getReturnValue()); 
            }            
        }); 
        $A.enqueueAction(action);
        
        var action = component.get("c.getLikeEnableValue");
        action.setParams({
            ideaID: component.get("v.recordId")           
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {  
                component.set('v.IconVisible', response.getReturnValue()); 
            }            
        }); 
        $A.enqueueAction(action);
    },
    increaseLikeCount : function(component, event, helper) {
        var action = component.get("c.getIncrementCount");
        action.setParams({
            ideaId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                component.set("v.numberOfVotes", response.getReturnValue());
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get("v.recordId")
                });
                navEvt.fire();
            }
        });
        $A.enqueueAction(action);
    },    
})