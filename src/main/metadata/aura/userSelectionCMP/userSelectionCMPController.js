({
    goToPrevious : function(component, event, helper) {
        var currentStage = component.get("v.currentSteps");
        component.set("v.currentSteps","step1");
        
    },
    goToNext : function(component, event, helper) {
        //alert('comm file save'+component.find("expirationDate").get("v.value"));
        if(component.get("v.currentSteps")!="step2")
            helper.saveCommunityFile(component);
    },
    startProgress : function(component, event, helper) {
        helper.loadhelper(component);       
    },
    goToGroups : function(component, event, helper) {
        //alert('select Users');        
        component.set("v.currentSteps", "step2");
    },
    handleClose :  function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
        dismissActionPanel.fire(); 
    }
})