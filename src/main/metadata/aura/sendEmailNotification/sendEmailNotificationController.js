({
	handleClose :  function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
        dismissActionPanel.fire(); 
    },
    handleSend : function(component, event, helper){
        helper.sendNotificationHelper(component);
    }
})