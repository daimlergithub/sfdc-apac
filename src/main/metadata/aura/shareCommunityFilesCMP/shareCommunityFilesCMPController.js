({
    doInit: function(component, event, helper) {
        //helper.loadHelper(component);
    },
    handleShare : function(component, event, helper) {
        var selUsrs = component.get("v.selectedLookUpRecords");        
        var selgrps = component.get("v.selectedGroupRecords");        
        if(selUsrs.length > 0 || selgrps.length > 0){
            helper.shareHelper(component,selUsrs,selgrps);
        }
        else{
            component.set("v.showError",true);            
        }
    },
    handleClose :  function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
        dismissActionPanel.fire(); 
    }
})