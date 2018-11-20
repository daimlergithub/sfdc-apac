({
    InitLoad : function(component) {        
        var action = component.get("c.recentNews");       
        action.setCallback(this, function(response){
            var state = response.getState();	
            if (state === "SUCCESS") { 
                var resp = response.getReturnValue();                
                component.set("v.News", resp.newsList);
                component.set("v.Subscribe",resp.Subscribe);
            }
            else {
                component.set("v.message", 'An Error Occured. Kindly refresh or contact your Salesforce administrator.');
            }
        });
        $A.enqueueAction(action);
    },
    subsNews : function(component,val) {
        var action = component.get("c.SubscribeNews"); 
        action.setParams({
            Subs : val
        });
        action.setCallback(this, function(response){
            var state = response.getState();	
            if (state === "SUCCESS") { 
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