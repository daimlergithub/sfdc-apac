({
	helperLoad : function(component) {        
		var action = component.get("c.LatestEvents");        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                component.set("v.eventList",response.getReturnValue());				               
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        // optionally set storable, abortable, background flag here
        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
        var action1 = component.get("c.getSubscribeEvent");
        action1.setCallback(this, function(response){
            var state = response.getState();	
            if (state === "SUCCESS") { 
                var resp = response.getReturnValue();                                
                component.set("v.Subscribe",resp);
            }
            else {
                component.set("v.message", 'An Error Occured. Kindly refresh or contact your Salesforce administrator.');
            }
        });
        $A.enqueueAction(action1);
        
	},
    subsEvents : function(component,val) {
        //alert('val '+val);
        var action = component.get("c.SubscribeEvents"); 
        action.setParams({
            Subs : val
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log('response '+JSON.stringify(response));
            if (state === "SUCCESS") {
                //console.log('response1 '+JSON.stringify(response));
                component.set("v.Subscribe",val);
                var toastEvent = $A.get("e.force:showToast");
                if(val){                    
                    toastEvent.setParams({
                        title : 'Success Message',
                        message: 'Successfully Subscribed.',            
                        duration:' 5000',                        
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
                else{
                    toastEvent.setParams({
                        title : 'Un Subscribe',
                        message: 'Successfully Un Subscribed.',            
                        duration:' 5000',                        
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
            }
            else {
                component.set("v.message", 'An Error Occured. Kindly refresh or contact your Salesforce administrator.');
            }
        });
        $A.enqueueAction(action);
    }
})