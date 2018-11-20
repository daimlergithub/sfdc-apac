({
    doInit : function(component, event, helper) {
        // create a one-time use instance of the LatestEvents action
        // in the server-side controller  
        
        helper.helperLoad(component);       
    },
    redirectToSobject : function(component, event, helper) {
        //var a = event.getSource();
        var id = event.getSource().get("v.name");
        var navEvent = $A.get("e.force:navigateToSObject");
        navEvent.setParams({
            recordId: id,
            slideDevName: "detail"
        });
        navEvent.fire();
    },
    navigateToallEvents : function(component, event, helper) {
        
        var evt = $A.get("e.force:navigateToComponent");        
        evt.setParams({
            componentDef : "c:EventMaster"           
        });
        evt.fire();
        
        
    },
    subscribeEvents : function(component, event, helper) {
        helper.subsEvents(component,true);        
    },
    unsubscribeEvents : function(component, event, helper) {
        helper.subsEvents(component,false);        
    }
})