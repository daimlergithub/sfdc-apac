({
    loadHelper : function(component){
        var fid = component.get("v.recordId");        
        var action = component.get("c.getrecordDetails");        
        action.setParams({
            "cfId":fid            
        });
        action.setCallback(this, function(response) {           
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                console.log('res '+res);
                component.set("v.shareOpt",res); 
                if(res){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Warning',
                        message: 'You are not authorized to Share the File.',                        
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire(); 
                                       
                }
                
                //
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    
                }
        });        
        $A.enqueueAction(action);
    },
    shareHelper : function(component,selUsrs,selgrps) {
        var fid = component.get("v.recordId");        
        var action = component.get("c.shreRecord");        
        action.setParams({
            "cfId":fid,
            "usrList":selUsrs,
            "selgrps":selgrps            
        });
        action.setCallback(this, function(response) {           
            var state = response.getState();
            if (state === "SUCCESS") {
                var sObjectEvent = $A.get("e.force:navigateToSObject");
                sObjectEvent.setParams({
                    "recordId": fid,
                    "slideDevName": "detail"
                });
                sObjectEvent.fire();
                //refreshing...
                $A.get('e.force:refreshView').fire();
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    
                }
        });        
        $A.enqueueAction(action);
    }
})