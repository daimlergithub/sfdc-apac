({
    // initialisation function - retrieves the Market specific fields from the 
    // Apex controller
    doInit : function(component, event, helper) {
        helper.getFields(component, event, helper);
    },
    //Funtion to show Toast Message on Record Save
    handleSuccess : function(component, event, helper) {
        helper.onSuccess(component, event, helper);
    },
    
    handleCompactSave: function(component){
        var saveRecord=component.find("editForm");
        debugger;
        var resultMsg=saveRecord.submit();
        //component.set('v.EditEnabled', false);
        console.log('test11 '+resultMsg);
        return resultMsg;
    },
    //Toggle fucntion to switch between Edit mode and View Mode
    enableDisableEditableMode: function(component, event, helper) {
        helper.toggleEditMode(component, event, helper);
    },
    //Function to show Toast on Error in Record Edit Form
    onError : function(component, event, helper) {
        helper.handleError(component, event, helper);
    },
})