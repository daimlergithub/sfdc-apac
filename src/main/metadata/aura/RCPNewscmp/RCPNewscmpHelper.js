({
    fileOpen : function(component,event,helper) {
        component.set("v.isFile","true");
        component.set("v.isForm","false");
    },
    updateField : function(component,event,helper) {
       var action= component.get("c.updateNews");
       var recId =component.get("v.recId");
       action.setParams({
                "recordId": recId
            });
       action.setCallback(this, function(resp) {                           
                var stateOfAction = resp.getState();
                if (stateOfAction === "SUCCESS") 
                {
                    console.log("succ"+resp);
                }
                else
                {
                    if(stateOfAction === "ERROR")
                    {
                        var error = resp.getError();
                        component.set("v.message",error[0].message); 
                    }
                }
            });
        $A.enqueueAction(action);     
    },
    getUploadedFiles : function(component) {
        var action = component.get("c.getFiles");
        action.setParams({
            "newsid": component.get("v.recId")
        });
        action.setCallback(this, function(response) {           
            var state = response.getState();
            if (state === "SUCCESS") {
                var files = response.getReturnValue();              
                component.set("v.files",files); 
                if(files.length < 1 ){
                    component.set("v.cancelFileBtn",false);
                }
                else{
                    component.set("v.cancelFileBtn",true);
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
    deleterecordHelper:function(component,event){
        var action = component.get("c.detailedFile");
        action.setParams({
            "fileId": event.target.id,
            "newsid": component.get("v.recId")
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
                if(files.length < 1 ){
                    component.set("v.cancelFileBtn",false);
                }
                else{
                    component.set("v.cancelFileBtn",true);
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
    redirectAndMessage : function(component,event,helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recId"),
            "slideDevName": "detail"
        });
        navEvt.fire();        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been created successfully.",
            "type": "success"
        });
        toastEvent.fire();
        //refreshing...
        $A.get('e.force:refreshView').fire();
    },
    handleCustomErrors : function(component,event,helper) {
        var title =component.find("title").get("v.value");
        var content =component.find("content").get("v.value");
        var startDate =component.find("startDate").get("v.value");
        var endDate =component.find("endDate").get("v.value");
        var shareWithGrps =component.find("shareWithGrps").get("v.value");
        
        if(title == null || title == '' || title == 'undefined'){
            $A.util.addClass(component.find("title"),'slds-has-error');
        }
        else{
            $A.util.removeClass(component.find("title"),'slds-has-error');
        }
        if(startDate == null || startDate == '' || startDate == 'undefined'){
            $A.util.addClass(component.find("startDate"),'slds-has-error');
        }
        else{
            $A.util.removeClass(component.find("startDate"),'slds-has-error');
        }
        if(endDate == null || endDate == '' || endDate == 'undefined'){
            $A.util.addClass(component.find("endDate"),'slds-has-error');
        }
        else{
            $A.util.removeClass(component.find("endDate"),'slds-has-error');
        }
        if(shareWithGrps == null || shareWithGrps == '' || shareWithGrps == 'undefined'){
            $A.util.addClass(component.find("shareWithGrps"),'slds-has-error');
        }
        else{
            $A.util.removeClass(component.find("shareWithGrps"),'slds-has-error');
        }
        if(content == null || content == '' || content == 'undefined'){
            $A.util.addClass(component.find("content"),'slds-has-error');
        }
        else{
            $A.util.removeClass(component.find("content"),'slds-has-error');
        }
        if((title == null || title == "" || title == 'undefined') || (startDate == null || startDate == "" || startDate == 'undefined' ) || (endDate == null || endDate == "" || endDate == 'undefined') || (shareWithGrps == null || shareWithGrps == "" || shareWithGrps == 'undefined') || (content == null || content == "" || content == 'undefined') ){
            component.set("v.message","Please fill Mandatory Fields (Title,Start Date,End Date,Share With Groups,Content)");
            /* var nHeader = "Oops! You miss something.";
            var nVariant = "warning";
            var nWarMsg = component.get("v.message");
            helper.handleShowNotice(component, nHeader, nVariant, nWarMsg); */
        }
        else{
            component.set("v.message","");
        }
        if (component.get("v.message") != "" && component.get("v.message") != null) {
            var nHeader = "Oops! You miss something.";
            var nVariant = "warning";
            helper.handleShowNotice(component, nHeader, nVariant, component.get("v.message"));
        }
            
    },
    handleShowNotice: function(component, nHeader, nVariant, syserr) {
        component.find("notifLib").showNotice({
            header: nHeader,
            variant: nVariant,
            message: syserr
        });
    },
})