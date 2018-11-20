({
    sendNotificationHelper : function(component) {
        var fid = component.get("v.recordId");        
        var action = component.get("c.emailNotification");        
        action.setParams({
            "cfId":fid                       
        });
        action.setCallback(this, function(response) {           
            var state = response.getState();
            var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
            dismissActionPanel.fire(); 
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                if(res){
                    var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'success',
                    message: 'Email notification sent successfully.',                        
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'dismissible'
                });
                toastEvent.fire(); 
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'info',
                    message: 'Please select atleast one user or Group.',                        
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'info',
                    mode: 'dismissible'
                });
                toastEvent.fire();
                }
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'error',
                        message: 'Error occured try after some time.',                        
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire(); 
                }
        });        
        $A.enqueueAction(action);
    }
})