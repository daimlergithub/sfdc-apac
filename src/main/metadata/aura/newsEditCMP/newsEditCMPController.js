({
    handleloader : function(component,event,helper) {
      component.set("v.spinner",false);
    },
    update : function(component,event,helper) {
        var sta = component.find("editForm").submit();       
    },
    handleSuccess : function(component, event, helper) {
        //var payload = event.getParams().response;
        //alert(JSON.stringify(payload));
        var sObectEvent = $A.get("e.force:navigateToSObject");
         sObectEvent .setParams({
            "recordId":  component.get("v.recordId"),
            "slideDevName": "detail"
        });
        sObectEvent.fire(); 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully.",
            "type": "success"
        });
        toastEvent.fire();
        //refreshing...
         $A.get('e.force:refreshView').fire();

    },     
    handleError : function(component, event, helper) { 
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "Review the errors on this page.",
            "type": "error"
        });
        toastEvent.fire();
    },
    cancel :  function(component,event,helper) {
        var sObectEvent = $A.get("e.force:navigateToSObject");
        sObectEvent .setParams({
            "recordId":  component.get("v.recordId"),
            "slideDevName": "detail"
        });
        sObectEvent.fire(); 
    }  
})