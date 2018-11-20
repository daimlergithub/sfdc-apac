({
    loadHelper : function(component) {
        var action = component.get("c.getFiles");
        action.setParams({
            "newsid": component.get("v.newsId")
        });
        action.setCallback(this, function(response) {           
            var state = response.getState();
            if (state === "SUCCESS") {
                var files = response.getReturnValue();              
                component.set("v.files",files);                
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
    deleterecordHelper:function(component,event){
        
        //alert(event.target.id);
        var action = component.get("c.detailedFile");
        action.setParams({
            "fileId": event.target.id,
            "newsid": component.get("v.newsId")
        });
        action.setCallback(this, function(response) {           
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "File deleted successfully.",
                    "type": "success"
                });
                toastEvent.fire();
                var files = response.getReturnValue();                
                if(files != null){
                    component.set("v.files",files);  
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