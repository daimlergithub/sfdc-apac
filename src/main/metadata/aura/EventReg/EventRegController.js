({
    handleloader : function(component,event,helper) {
        component.set("v.spinner",false);
        var id = component.get("v.recordId");
        component.find("Related_Event__c").set("v.value", id);
        helper.checkEvent(component);
    },
    register : function(component,event,helper) { 
        helper.checkEvent(component);
        //var chk=component.get("v.flag");
        var sta = component.find("editForm").submit(); 
    },
    handleSuccess : function(component, event, helper) {                 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been created successfully.",
            "type": "success"
        });
        toastEvent.fire();
        //refreshing...
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),
            "slideDevName": "detail"
        });
        navEvt.fire();
    },     
    handleError : function(component, event, helper) { 
        console.log('event '+JSON.stringify(event));
        //alert('event '+JSON.stringify(event));        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "Review the errors on this page.",
            "type": "error"
        });
        toastEvent.fire();
    }    
})