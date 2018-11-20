({
    loadhelper:function(component){
        var action = component.get("c.getFileStatus");        
        action.setParams({
            "fId":component.get("v.recordId")           
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.loader",false); 
                component.set("v.shareOpt",response.getReturnValue()); 
                if(response.getReturnValue()){
                    var arrayList = ["step1", "step2"];
                    //component.set("v.")
                    component.set("v.stepsArray", arrayList);
                    component.set("v.currentSteps", arrayList[0]);
                }               
                
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
        $A.enqueueAction(action);
    },   
    saveCommunityFile:function(component){        
        var action = component.get("c.getrelatedFileStatus");        
        action.setParams({
            "fId":component.get("v.recordId")           
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                if(response.getReturnValue()){
                    
                    component.set("v.currentSteps", "step2");                        
                    
                }
                else{
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Warning',
                        message: 'Please upload a file.',                        
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
                
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
        $A.enqueueAction(action);
    }
})