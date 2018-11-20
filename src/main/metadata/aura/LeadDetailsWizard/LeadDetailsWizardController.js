({
    doInit : function(component, event, helper) {
        debugger;
        var recId=component.get("v.recordId");    
        if(recId == null || recId == ""){
            var myPageRef = component.get("v.pageReference");
            if(myPageRef != null){
                var ParentAccountId = myPageRef.state.c__ParentAccountId;
                var normalisedAccId = helper.normaliseSforceID(ParentAccountId);
                component.set("v.ParentAccountId", normalisedAccId);   
            }
            component.set("v.isNew","true");
        }
        else{
            helper.getDetails(component, event, helper); 
            component.set("v.cardTitle","Edit Opportunity / Lead");
        }
        
    },
    
    handleLoad: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
    },
    
    handleSubmit: function(cmp, event, helper) {
        //below code to get fields filled on form:
        cmp.set("v.isNew", false);
        event.preventDefault(); // stop form submission
        var eventFields = event.getParam("fields");
        cmp.find('Opptyform').submit(eventFields);
        
        
    },
    
    handleSave: function(component, event, helper){  
        //TODO: Save ME
    },
    
    handleError: function(component, event, helper){
var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            mode: 'dismissible',
                            message: 'An error occurred while trying to update the record. Please try again.',
                            type: 'error',
                            duration: '0.9',
                        });
                        toastEvent.fire();		
        const showAll = !component.get("v.showAll");
        helper.toggleShowAll(component, showAll, helper);
    },
    
    toggleShowAll: function(component, event, helper){
        const showAll = !component.get("v.showAll");
        helper.toggleShowAll(component, showAll, helper);
    },
    handleSuccess: function(cmp, event, helper) {
        var recId=cmp.get("v.recordId");
        cmp.set("v.isNew", false);
        var params = event.getParams();
        var OppId = params.response.id;
        cmp.set('v.recordId',OppId );
        cmp.set('v.showSpinner', false);
        cmp.set('v.saved', true);
        if(recId == null || recId == '')
			helper.showToast('Success', 'success', "New opportunity is successfully created."); 
        else
			helper.showToast('Success', 'success', "Opportunity is successfully updated."); 
        //Call Vehicle Picker Components to set the Opportunity Id
        if(recId == null || recId == ''){
            var getOppId = $A.get("e.c:SaveVehiclePicker");
            getOppId.setParams({
                OppId: OppId
            });
            getOppId.fire();
        }
        
        var sObjectEvent = $A.get("e.force:navigateToSObject");
        sObjectEvent.setParams({
            "recordId": OppId,
            "slideDevName": "detail"
        });
        sObjectEvent.fire();
    },
    handlePrevious : function(component, event, helper) {
        helper.nextWizardPage(component, -1, helper);
    },
    
    handleNext : function(component, event, helper) {
        helper.nextWizardPage(component, 1, helper);
    },
    
    cancelNewMethod:function(component, event, helper) { 
       helper.cancelNewMethod(component, event, helper); 
    },
    onChangeRec: function(component, event, helper) { 
        component.set("v.isNew", false);
        helper.setRecordTypeId(component, event, helper);
        helper.getDetails(component, event, helper);
    },
    getRecType : function(component, event, helper) {
       component.set("v.isNew", false); 
       //alert(event.getParam("recordTypeName")); 
       if(event.getParam("isCancel"))
       {
         helper.cancelNewMethod(component, event, helper);  
       }
       else{
         helper.setRecordTypeId(component, event, helper);
         helper.getDetails(component, event, helper);    
       }  
      },
    locationChange : function (component, event, helper) {                                
        $A.get("e.force:refreshView").fire();
    }
})